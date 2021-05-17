---
title: Optimized Percolator
aliases: ['/docs/deep-dive/distributed-transaction/optimized-percolator']
menu:
    nav:
        parent: Distributed transaction
        weight: 6
---

As said in [previous chapter](../percolator), TiKV makes use of Percolator's transaction algorithm. In TiKV's implementation, there are some optimizations on Percolator. In this chapter, we will introduce these optimizations in TiKV.

## Parallel Prewrite

In practice, for a single transaction, we don't want to do prewrites one by one. When there are dozens of TiKV nodes in the cluster, we hope the prewrite can be executed concurrently on these TiKV nodes.

In TiKV's implementation, when committing a transaction, the keys in the transaction will be divided into several batches and each batch will be prewritten in parallel. It doesn't matter whether the primary key is written first.

If a conflict happens during a transaction's prewrite phase, the prewrite process will be canceled and rollback will be performed on all keys affected by the transaction. Doing rollback on a key will leave a `Rollback` record in `CF_WRITE`(Percolator's `write` column), which is not described in Google's Percolator paper. The `Rollback` record is a mark to indicate that the transaction with `start_ts` in the record has been rolled back, and if a prewrite request arrives later than the rollback request, the prewrite will not succeed. This situation may be caused by network issues. The correctness won't be broken if we allow the prewrite to succeed. However, the key will be locked and unavailable until the lock's TTL expires.

## Short Value in Write Column

As mentioned in [Percolator in TiKV](../percolator/#percolator-in-tikv), TiKV uses RocksDB's column families to save different columns of Percolator. Different column families of RocksDB are actually different LSM-Trees. When we access a value, we need to search firstly the `CF_WRITE` to find the `start_ts` of the next record, and then the corresponding record in `CF_DEFAULT`. If a value is very small, it is wasteful to search RocksDB twice.

The optimization in TiKV is to avoid handling `CF_DEFAULT` for short values. If the value is short enough, it will not be put into `CF_DEFAULT` during the prewrite phase. Instead, it will be embedded in the lock and saved in `CF_LOCK`. Then in the commit phase, the value will be moved out of the lock and inlined in the write record. Therefore, we can access and manipulate short values without having to handle `CF_DEFAULT`.

## Point Read Without Timestamp

Timestamps are critical to providing isolation for transactions. For every transaction, we allocate a unique `start_ts` for it, and ensures transaction T can only see the data committed before T's `start_ts`.

But if transaction T does nothing but reads a single key, is it really necessary to allocate it a `start_ts`? The answer is no. We can simply read the newest version directly, because it's equivalent to reading with `start_ts` which is exactly the instant when the key is read. It's even ok to read a locked key, because it's equivalent to reading with the `start_ts` allocated before the lock's `start_ts`.

## Calculated Commit Timestamp

{{< warning >}}
This optimization hasn't been finished yet, but will be available in the future. [RFC](https://github.com/tikv/rfcs/pull/25).
{{</ warning >}}

To provide Snapshot Isolation, we must ensure all transactional reads are
repeatable. The `commit_ts` should be large enough so that the transaction will
not be committed before a valid read. Otherwise, Repeatable Read will be broken.
For example:

1. Txn1 gets `start_ts` 100
2. Txn2 gets `start_ts` 200
3. Txn2 reads key `"k1"` and gets value `"1"`
4. Txn1 prewrites `"k1"` with value `"2"`
5. Txn1 commits with `commit_ts` 101
6. Tnx2 reads key `"k1"` and gets value `"2"`

Txn2 reads `"k1"` twice but gets two different results. If `commit_ts` is
allocated from PD, this will not happen, because Txn2's first read must happen
before Txn1's prewrite while Txn1's `commit_ts` must be requested after
finishing prewrite. And as a result, Txn1's `commit_ts` must be larger than
Txn2's `start_ts`.

On the other hand, `commit_ts` can't be arbitrarily large. If the `commit_ts` is
ahead of the actual time, the committed data may be unreadable by other new
transactions, which breaks integrity. We are not sure whether a timestamp is
ahead of the actual time if we don't ask PD.

To conclude, in order not to break the Snapshot Isolation and the integrity, a
valid range for `commit_ts` should be:

```text
max{start_ts, max_read_ts_of_written_keys} < commit_ts <= now
```

So here comes a method to calculate the commit_ts:

```text
commit_ts = max{start_ts, region_1_max_read_ts, region_2_max_read_ts, ...} + 1
```

where `region_N_max_read_ts` is the maximum timestamp of all reads on the
region, for all regions involved in the transaction.

## Single Region 1PC

{{< warning >}}
This optimization haven't been finished yet, but will be available in the future.
{{</ warning >}}

For non-distributed databases, it's easy to provide ACID transactions; but for distributed databases, usually 2PC (two-phase commit) is required to make transactions ACID. Percolator provides such a 2PC algorithm, which is adopted by TiKV.

Considering that write batches are done atomically in a single Region, we come up with this realization that if a transaction affects only one region, 2PC is actually unnecessary. Once there is no write conflict, the transaction can be committed directly. Based on [the previous optimization](#calculated-commit-ts), the `commit_ts` can be set to `max_read_ts` of the region directly. In this way, we saved an RPC and a write operation (including a Raft committing and RocksDB writing) in TiKV for single-region transactions.
