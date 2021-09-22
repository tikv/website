---
title: FAQs
description: Frequently asked questions about TiKV
menu:
    "5.1":
        parent: Reference
        weight: 10
---

## What is TiKV?

TiKV is a distributed Key-value database that features in geo-replication, horizontal scalability, consistent distributed transactions, and coprocessor support.

## How do I run TiKV?

If you would like to deploy a TiKV cluster for test environments, you can refer to [TiKV in 5 Minutes](../../concepts/tikv-in-5-minutes/). Besides, for production environments, you can follow the instructions in [Install TiKV](../../deploy/install/install/).

## When to use TiKV?

TiKV is the service you need if your applications require the following features:

* Horizontal scalability (including writes-in)
* Strong consistency
* Support distributed ACID transactions

## How does TiKV scale?

You can scale out TiKV as your business grows. To increase the capacity of TiKV, you only need to add more machines. TiKV can run across physical, virtual, container, and cloud environments.

Placement Driver ([PD](https://github.com/pingcap/pd)) periodically checks replication constraints and balances the load, and automatically handles data movement. Therefore, when PD notices that the load is too high, it rebalances data.

## How is TiKV highly available?

TiKV is self-recoverable. With the guaranteed strong consistency of TiKV, the data stored in TiKV can still be recovered automatically even though data machines fail or an entire data center breakdown.

## How is TiKV strongly consistent?

Strong consistency indicates that all replicas return the same value when queried for an object's attribute. TiKV uses the [Raft consensus algorithm](https://raft.github.io/) to ensure its consistency among multiple replicas. TiKV allows a collection of machines to work as a coherent group so that TiKV can normally work even though some parts of machines fail during the working process.

## Does TiKV support distributed transactions?

Yes. The transaction model in TiKV is inspired by Google Percolator, a paper published in 2006. It is mainly a two-phase commit protocol with some practical optimizations. This model relies on a timestamp allocator to assign a monotonically increasing timestamp to each transaction in order to detect conflicts.

## Does TiKV have ACID semantics?

Yes. ACID semantics are guaranteed in TiKV:

* Atomicity: Each transaction in TiKV is "all or nothing"- if one part of the transaction fails, then the entire transaction fails, and the database state is left unchanged. TiKV guarantees atomicity in each and every situation, including power failures, errors, and crashes.
* Consistency: TiKV ensures that any transaction brings the database from one valid state to another. Any data written to the TiKV database must be valid according to all defined rules.
* Isolation: TiKV provides snapshot isolation (SI), snapshot isolation with lock, and externally consistent reads and writes in distributed transactions.
* Durability: TiKV allows a collection of machines to work as a coherent group so that TiKV can normally work even though some parts of machines fail during the working process. Accordingly, once a transaction has been committed in TiKV, it remains its status, even though power loss, crashes, or errors happen.

## How are TiKV transactions unlocked?

TiKV has an optimistic transaction model, which means that the client buffers all writes in the transaction. When the client calls the commit function, the writes are packed and sent to the server. If there are no conflicts, the key-value pair writes with specific version information are written to the database and can be read by other transactions.

## Can I use TiKV as a key-value store?

Yes. That is what TiKV is.

## How does TiKV compare to NoSQL databases like Cassandra, HBase, or MongoDB?

TiKV has the scalability as NoSQL databases. At the same time, it also has the strong consistency for distributed transactions and provides solid support for the stateless query layers, such as TiSpark (Spark), Titan (Redis), or TiDB (MySQL).

## How many replicas are recommended to be set in a TiKV cluster? Is it better to keep the minimum number of replicas in a TiKV cluster for TiKV's high availability?

Three replicas for each Region is sufficient for a testing environment. However, you must not operate a TiKV cluster with less than three nodes in a production environment. Depending on the infrastructure, workload, and resiliency needs, you can increase the number as you need.

## If a node is down, will the service be affected? If so, how long will it take?

TiKV uses Raft to synchronize data among multiple replicas (three replicas for each Region by default). If one replica is down, the data safety can still be guaranteed by other replicas. Based on the Raft protocol, once a node is down, and a single leader fails, a follower in another node is elected as the Region leader right after. This substitution process takes no longer than 2 * lease time (lease time is 10 seconds).

## Is the Range of the key data table divided before data access?

No. It differs from the table splitting rules of MySQL. In TiKV, the table Range is dynamically split based on the size of Region.

## How does Region split?

The Region is not divided in advance, but it follows a Region split mechanism. When the Region size exceeds the value of the `region-split-size` or `region-split-keys` parameters, the split process is triggered. When the split is over, the information is reported to PD.

## What are the features of TiKV block cache?

TiKV implements the Column Family (CF) feature of RocksDB. By default, the key-value data is eventually stored in the 3 CFs (default, write and lock) within RocksDB.

- The default CF stores the real data, and the corresponding parameter is in `[rocksdb.defaultcf]`. The write CF stores the data version information (MVCC) and index-related data, and the corresponding parameter is in `[rocksdb.writecf]`. The lock CF stores the lock information, and the system uses the default parameter.
- The Raft RocksDB instance stores Raft logs. The default CF mainly stores Raft logs, and the corresponding parameter is in `[raftdb.defaultcf]`.
- All CFs have a shared block-cache to cache data blocks and improve RocksDB read speed. The `block-cache-size` parameter controls the size of block-cache. A larger parameter value means more hot data can be cached and is more favorable to read operation. At the same time, it consumes more system memory.
- Each CF has an individual write-buffer, and the `write-buffer-size` parameter controls the size.

## What are the TiKV scenarios that take up high I/O, memory, CPU, and exceed the parameter configuration?

Writing or reading a large volume of data in TiKV takes up high I/O, memory, and CPU. Besides, executing very complex queries also costs a lot of memory and CPU resources, such as the scenario that generates large intermediate result sets.

## Does TiKV have the `innodb_flush_log_trx_commit` parameter like MySQL to guarantee data security?

Yes. Currently, the standalone storage engine uses two RocksDB instances. One instance is used to store the raft-log. When the `sync-log` parameter in TiKV is set to true, each commit is mandatorily flushed to the raft-log. Then, if a crash occurs, you can restore the KV data using the raft-log.

## What is the recommended server configuration for WAL storage, such as SSD, RAID level, cache strategy of RAID card, NUMA configuration, file system, I/O scheduling strategy of the operating system?

WAL belongs to ordered writing. Currently, we do not have separate configuration for it. The recommended configuration is as follows:

- SSD
- RAID 10 preferred
- Cache strategy of RAID card and I/O scheduling strategy of the operating system: no specific best practices currently; you can use the default configuration in Linux 7 or later
- NUMA: no specific suggestion; for memory allocation strategy, you can use `interleave = all`
- File system: ext4

## Can Raft + multiple replicas in the TiKV architecture achieve absolute data safety? Is it necessary to apply the most strict mode (`sync-log = true`) to a standalone storage?

To ensure data's recoverability when a node failure occurs, data is redundantly replicated between TiKV nodes using the Raft consensus algorithm [Raft consensus algorithm](https://raft.github.io/). Only when the data has been written into more than 50% of the replicas, the application returns ACK (two out of three nodes). However, theoretically, two nodes might crash. Therefore, you are strongly recommended to enable the sync-log mode, except for the scenarios with less strict data security requirements but high performance requirements.

You can also consider having five replicas instead of keeping three in your Raft group as an alternative to using' sync-log'. This method provides data safety even if the two replicas fail.

For a standalone TiKV node, it is still recommended to enable the sync-log mode. Otherwise, the last write might be lost in case of a node failure.

## Why does TiKV frequently switch Region leaders?

TiKV switches Region leaders in the following cases:

- Leaders cannot reach out to followers. For example, network problem or node failure happens.
- Leader balance from PD. For example, PD tries to transfer leaders from a hotspot node to others.

## The `cluster ID mismatch` message is displayed when starting TiKV.

This is because the cluster ID stored in local TiKV is different from the cluster ID specified by PD. When a new PD cluster is deployed, PD generates random cluster IDs. TiKV gets the cluster ID from PD and stores the cluster ID locally when it is initialized. The next time when TiKV is started, it checks the local cluster ID with the cluster ID in PD. If the cluster IDs do not match each other, the `cluster ID mismatch` message is displayed, and TiKV exits.

If you previously deployed a PD cluster but removed the PD data and deployed a new PD cluster, this error occurs because TiKV uses the old data to connect to the new PD cluster.

## The `duplicated store address` message is displayed when starting TiKV.

This is because the address in the startup parameter has been registered in the PD cluster by other TiKVs. This error occurs when there is no data folder under the directory that TiKV `--store` specifies, but you use the previous parameter to restart the TiKV.

To solve this problem, use the [`store delete`](https://github.com/pingcap/pd/tree/55db505e8f35e8ab4e00efd202beb27a8ecc40fb/tools/pd-ctl#store-delete--label--weight-store_id----jqquery-string) function to delete the previous store and then restart TiKV.

## TiKV leader replicas and its follower replicas use the same compression algorithm. Why the amount of occupied disk space is different?

TiKV stores data in the LSM tree, in which each layer has a different compression algorithm. If two replicas of the same data are located in different layers in two TiKV nodes, the two replicas might occupy different space.

## What causes "TiKV channel full"?

- The Raftstore thread is too slow or blocked by I/O. You can view the CPU usage status of Raftstore.
- TiKV is too busy (CPU, disk I/O, so on) and cannot manage to handle it.

## How is the write performance in the most strict data available mode (`sync-log = true`)?

Generally, enabling `sync-log` reduces about 30% of the performance. For write performance when `sync-log` is set to `false`, see [Performance test result for TiDB using Sysbench](https://github.com/pingcap/docs/blob/master/benchmark/benchmark-sysbench-v5-vs-v4.md).

## Why does `IO error: No space left on device While appending to file` message occur?

This is because the disk space is not enough. You need to add nodes or enlarge the disk space.

## Why does the OOM (Out of Memory) error occur frequently in TiKV?

The memory usage of TiKV mainly comes from the block-cache of RocksDB, which is 40% of the system memory size by default. When the OOM error occurs frequently in TiKV, you should check whether the value of `block-cache-size` is set too high. In addition, when multiple TiKV instances are deployed on a single machine, you need to explicitly configure the parameter to prevent multiple instances from using too much system memory that results in the OOM error.
