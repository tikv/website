---
title: Distributed Transaction
description: How transaction works on TxnKV
menu:
    "5.1":
        parent: Features
        weight: 5
---

This chapter walks you through a simple demonstration of how TiKV's distributed transaction works.

## Prerequisites

Before you start, ensure that you have set up a TiKV cluster and install the `tikv-client` Python package according to [TiKV in 5 Minutes](../../tikv-in-5-minutes).

{{< warning >}}
TiKV Java client's Transaction API has not been released yet, so the Python client is used in this example.
{{< /warning >}}

## Test snapshot isolation

Transaction isolation is one of the foundations of database transaction processing. Isolation is one of the four key properties of a transaction (commonly referred as ACID).

TiKV implements [Snapshot Isolation (SI)](https://en.wikipedia.org/wiki/Snapshot_isolation) consistency, which means that:

- all reads made in a transaction will see a consistent snapshot of the database (in practice it reads the last committed values that existed at the time it started);
- the transaction itself will successfully commit only if no updates it has made conflict with any concurrent updates made since that snapshot.

The following example shows how to test TiKV's snapshot isolation.

Save the following script to file `test_snapshot_isolation.py`.

```python
from tikv_client import TransactionClient

client = TransactionClient.connect("127.0.0.1:2379")

# clean
txn1 = client.begin()
txn1.delete(b"k1")
txn1.delete(b"k2")
txn1.commit()

# put k1 & k2 without commit
txn2 = client.begin()
txn2.put(b"k1", b"Snapshot")
txn2.put(b"k2", b"Isolation")

# get k1 & k2 returns nothing
# cannot read the data before transaction commit
snapshot1 = client.snapshot(client.current_timestamp())
print(snapshot1.batch_get([b"k1", b"k2"]))

# commit txn2
txn2.commit()

# get k1 & k2 returns nothing
# still cannot read the data after transaction commit
# because snapshot1's timestamp < txn2's commit timestamp
# snapshot1 can see a consistent snapshot of the database
print(snapshot1.batch_get([b"k1", b"k2"]))

# can read the data finally
# because snapshot2's timestamp > txn2's commit timestamp
snapshot2 = client.snapshot(client.current_timestamp())
print(snapshot2.batch_get([b"k1", b"k2"]))
```

Run test script

```bash
python3 test_snapshot_isolation.py

[]
[]
[(b'k1', b'Snapshot'), (b'k2', b'Isolation')]
```

From the above example, you can find that `snapshot1` cannot read the data before and after `txn2` is commited. This indicates that `snapshot1` can see a consistent snapshot of the database.

## Try optimistic transaction model

TiKV supports distributed transactions using either pessimistic or optimistic transaction models.

TiKV uses the optimistic transaction model by default. With optimistic transactions, conflicting changes are detected as part of a transaction commit. This helps improve the performance when concurrent transactions infrequently modify the same rows, because the process of acquiring row locks can be skipped.

The following example shows how to test TiKV with optimistic transaction model.

Save the following script to file `test_optimistic.py`.

```python
from tikv_client import TransactionClient

client = TransactionClient.connect("127.0.0.1:2379")

# clean
txn1 = client.begin(pessimistic=False)
txn1.delete(b"k1")
txn1.delete(b"k2")
txn1.commit()

# create txn2 and put k1 & k2
txn2 = client.begin(pessimistic=False)
txn2.put(b"k1", b"Optimistic")
txn2.put(b"k2", b"Mode")

# create txn3 and put k1
txn3 = client.begin(pessimistic=False)
txn3.put(b"k1", b"Optimistic")

# txn2 commit successfully
txn2.commit()

# txn3 commit failed because of conflict
# with optimistic transactions conflicting changes are detected when the transaction commits
txn3.commit()
```

Run the test script

```bash
python3 test_optimistic.py

Exception: KeyError WriteConflict
```

From the above example, you can find that with optimistic transactions, conflicting changes are detected when the transaction commits.

## Try pessimistic transaction model

In the optimistic transaction model, transactions might fail to be committed because of write–write conflict in heavy contention scenarios. In the case that concurrent transactions frequently modify the same rows (a conflict), pessimistic transactions might perform better than optimistic transactions.

The following example shows how to test TiKV with pessimistic transaction model.

Save the following script to file `test_pessimistic.py`.

```python
from tikv_client import TransactionClient

client = TransactionClient.connect("127.0.0.1:2379")

# clean
txn1 = client.begin(pessimistic=True)
txn1.delete(b"k1")
txn1.delete(b"k2")
txn1.commit()

# create txn2
txn2 = client.begin(pessimistic=True)

# put k1 & k2
txn2.put(b"k1", b"Pessimistic")
txn2.put(b"k2", b"Mode")

# create txn3
txn3 = client.begin(pessimistic=True)

# put k1
# txn3 put data failed because of conflict
# with pessimistic transactions conflicting changes are detected when writing data
txn3.put(b"k1", b"Pessimistic")
```

Run the test script

```bash
python3 test_pessimistic.py

Exception: KeyError
```

From the above example, you can find that with pessimistic transactions, conflicting changes are detected at the moment of data writing.
