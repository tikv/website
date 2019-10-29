---
title: FAQ
description: FAQs about TiKV
menu:
    nav:
        parent: Docs
        weight: 5
    docs:
        weight: 5
---

## What is TiKV?

TiKV is a distributed Key-Value database that features in geo-replication, horizontal scalability, consistent distributed transactions and coprocessor support.

## How do TiDB and TiKV work together? What is the relationship between the two?

TiDB works as the SQL layer and TiKV works as the Key-Value layer. TiDB provides TiKV the SQL enablement and turns TiKV into a NewSQL database. TiDB and TiKV work together to be as scalable as a NoSQL database while maintains the ACID transactions of a relational database.

## Why do you have separate layers?

Inspired by Google F1 and Spanner, TiDB and TiKV adopt a highly-layered architecture. This architecture supports pluggable storage drivers and engines, which powers you to customize your database solutions based on your own business requirements. Meanwhile, this architecture makes it easy to debug, update, tune, and maintain. You won’t have to go through the whole system just to find and fix a bug in one module.

## How do I run TiKV?

For further information, see [Quick Start](../../tasks/getting-started) for deploying a TiKV testing cluster, or [Deploy TiKV](../../tasks/deploy/introduction) for deploying TiKV in production.

## When to use TiKV?

TiKV is at your service if your applications require:

* Horizontal scalability (including writes)
* Strong consistency
* Support for distributed ACID transactions

## When is TiKV inappropriate?

TiKV is not yet ready to deal with very low latency reads and writes.

## How does TiKV scale?

Grow TiKV as your business grows. You can increase the capacity simply by adding more machines. You can run TiKV across physical, virtual, container, and cloud environments.

PD ([Placement Driver](https://github.com/pingcap/pd)) periodically checks replication constraints and balances the load, and it handles data movement automatically. When PD notices that the load is too high, it will rebalance data.

## How is TiKV highly available?

TiKV is self-healing. With its strong consistency guarantee, whether it’s data machine failures or even downtime of an entire data center, your data can be recovered automatically.

## How is TiKV strongly-consistent?

Strong consistency means all replicas return the same value when queried for the attribute of an object. TiKV uses the [Raft consensus algorithm](https://raft.github.io/) to ensure consistency among multiple replicas. TiKV allows a collection of machines to work as a coherent group that can survive the failures of some of its members.

## Does TiKV support distributed transactions?

Yes. The transaction model in TiKV is inspired by Google’s Percolator, a paper published in 2006. It’s mainly a two-phase commit protocol with some practical optimizations. This model relies on a timestamp allocator to assign a monotonically increasing timestamp for each transaction, so that conflicts can be detected.  

## Does TiKV have ACID semantics?

Yes. ACID semantics are guaranteed in TiKV:

* Atomicity: Each transaction in TiKV is "all or nothing": if one part of the transaction fails, then the entire transaction fails, and the database state is left unchanged. TiKV guarantees atomicity in each and every situation, including power failures, errors, and crashes.
* Consistency: TiKV ensures that any transaction brings the database from one valid state to another. Any data written to the TiKV database must be valid according to all defined rules.
* Isolation: TiKV provides snapshot isolation (SI), snapshot isolation with lock, and externally consistent reads and writes in distributed transactions.
* Durability: TiKV allows a collection of machines to work as a coherent group that can survive the failures of some of its members. So in TiKV, once a transaction has been committed, it will remain so, even in the event of power loss, crashes, or errors.

## How are transactions in TiKV lock-free?

TiKV has an optimistic transaction model, which means the client will buffer all the writes within a transaction, and when the client calls commit function, the writes will be packed and sent to the servers. If there is no conflict, the writes which are the key-value pairs with specific version are written into the database, and can be read by other transactions.

## Can I use TiKV as a key-value store?

Yes. That's what TiKV is.

## How does TiKV compare to NoSQL databases like Cassandra, HBase, or MongoDB?

TiKV is as scalable as NoSQL databases like to advertise, while including features like externally consistent distributed transactions and good support for stateless query layers such as TiSpark (Spark), Titan (Redis), or TiDB (MySQL)

## What is the recommended number of replicas in the TiKV cluster? Is it better to keep the minimum number for high availability?

3 replicas for each Region is sufficient for a testing environment. However, you should never operate a TiKV cluster with under 3 nodes in a production scenario. Depending on infrastructure, workload, and resiliency needs, you may wish to increase this number.

## If a node is down, will the service be affected? How long?

TiKV uses Raft to synchronize data among multiple replicas (by default 3 replicas for each Region). If one replica goes wrong, the other replicas can guarantee data safety. Based on the Raft protocol, if a single leader fails as the node goes down, a follower in another node is soon elected as the Region leader after a maximum of 2 * lease time (lease time is 10 seconds).

## Is the Range of the Key data table divided before data access?

No. It differs from the table splitting rules of MySQL. In TiKV, the table Range is dynamically split based on the size of Region.

## How does Region split?

Region is not divided in advance, but it follows a Region split mechanism. When the Region size exceeds the value of the `region-split-size` or `region-split-keys` parameters, split is triggered. After the split, the information is reported to PD.

## What are the features of TiKV block cache?

TiKV implements the Column Family (CF) feature of RocksDB. By default, the KV data is eventually stored in the 3 CFs (default, write and lock) within RocksDB.

- The default CF stores real data and the corresponding parameter is in `[rocksdb.defaultcf]`. The write CF stores the data version information (MVCC) and index-related data, and the corresponding parameter is in `[rocksdb.writecf]`. The lock CF stores the lock information and the system uses the default parameter.
- The Raft RocksDB instance stores Raft logs. The default CF mainly stores Raft logs and the corresponding parameter is in `[raftdb.defaultcf]`.
- All CFs have a shared block-cache to cache data blocks and improve RocksDB read speed. The size of block-cache is controlled by the `block-cache-size` parameter. A larger value of the parameter means more hot data can be cached and is more favorable to read operation. At the same time, it consumes more system memory.
- Each CF has an individual write-buffer and the size is controlled by the `write-buffer-size` parameter.

## What are the TiKV scenarios that take up high I/O, memory, CPU, and exceed the parameter configuration?

Writing or reading a large volume of data in TiKV takes up high I/O, memory and CPU. Executing very complex queries costs a lot of memory and CPU resources, such as the scenario that generates large intermediate result sets.

## Does TiKV have the `innodb_flush_log_trx_commit` parameter like MySQL, to guarantee the security of data?

Yes. Currently, the standalone storage engine uses two RocksDB instances. One instance is used to store the raft-log. When the `sync-log` parameter in TiKV is set to true, each commit is mandatorily flushed to the raft-log. If a crash occurs, you can restore the KV data using the raft-log.

## What is the recommended server configuration for WAL storage, such as SSD, RAID level, cache strategy of RAID card, NUMA configuration, file system, I/O scheduling strategy of the operating system?

WAL belongs to ordered writing, and currently, we don't have separate configuration for it. Recommended configuration is as follows:

- SSD
- RAID 10 preferred
- Cache strategy of RAID card and I/O scheduling strategy of the operating system: currently no specific best practices; you can use the default configuration in Linux 7 or later
- NUMA: no specific suggestion; for memory allocation strategy, you can use `interleave = all`
- File system: ext4

## Can Raft + multiple replicas in the TiKV architecture achieve absolute data safety? Is it necessary to apply the most strict mode (`sync-log = true`) to a standalone storage?

Data is redundantly replicated between TiKV nodes using the [Raft consensus algorithm](https://raft.github.io/) to ensure recoverability should a node failure occur. Only when the data has been written into more than 50% of the replicas will the application return ACK (two out of three nodes). However, theoretically, two nodes might crash. Therefore, except for scenarios with less strict requirement on data security but extreme requirement on performance, it is strongly recommended that you enable the sync-log mode.

As an alternative to using `sync-log`, you may also consider having five replicas instead of three in your Raft group. This would allow for the failure of two replicas, while still providing data safety.

For a standalone TiKV node, it is still recommended to enable the sync-log mode. Otherwise, the last write might be lost in case of a node failure.

## Why does TiKV frequently switch Region leader?

- Leaders can not reach out to followers. E.g., network problem or node failure.
- Leader balance from PD. E.g., PD wants to transfer leaders from a hotspot node to others.

## The `cluster ID mismatch` message is displayed when starting TiKV.

This is because the cluster ID stored in local TiKV is different from the cluster ID specified by PD. When a new PD cluster is deployed, PD generates random cluster IDs. TiKV gets the cluster ID from PD and stores the cluster ID locally when it is initialized. The next time when TiKV is started, it checks the local cluster ID with the cluster ID in PD. If the cluster IDs don't match, the `cluster ID mismatch` message is displayed and TiKV exits.

If you previously deploy a PD cluster, but then you remove the PD data and deploy a new PD cluster, this error occurs because TiKV uses the old data to connect to the new PD cluster.

## The `duplicated store address` message is displayed when starting TiKV.

This is because the address in the startup parameter has been registered in the PD cluster by other TiKVs. This error occurs when there is no data folder under the directory that TiKV `--store` specifies, but you use the previous parameter to restart the TiKV.

To solve this problem, use the [`store delete`](https://github.com/pingcap/pd/tree/55db505e8f35e8ab4e00efd202beb27a8ecc40fb/tools/pd-ctl#store-delete--label--weight-store_id----jqquery-string) function to delete the previous store and then restart TiKV.

## TiKV master and slave use the same compression algorithm, why the results are different?

Currently, some files of TiKV master have a higher compression rate, which depends on the underlying data distribution and RocksDB implementation. It is normal that the data size fluctuates occasionally. The underlying storage engine adjusts data as needed.

## What are causes for "TiKV channel full"?

- The Raftstore thread is too slow or blocked by I/O. You can view the CPU usage status of Raftstore.
- TiKV is too busy (CPU, disk I/O, etc.) and cannot manage to handle it.

## How is the write performance in the most strict data available mode (`sync-log = true`)?

Generally, enabling `sync-log` reduces about 30% of the performance. For write performance when `sync-log` is set to `false`, see [Performance test result for TiDB using Sysbench](https://github.com/pingcap/docs/blob/master/v3.0/benchmark/sysbench-v4.md).

## Why does `IO error: No space left on device While appending to file` occur?

This is because the disk space is not enough. You need to add nodes or enlarge the disk space.

## Why does the OOM (Out of Memory) error occur frequently in TiKV?

The memory usage of TiKV mainly comes from the block-cache of RocksDB, which is 40% of the system memory size by default. When the OOM error occurs frequently in TiKV, you should check whether the value of `block-cache-size` is set too high. In addition, when multiple TiKV instances are deployed on a single machine, you need to explicitly configure the parameter to prevent multiple instances from using too much system memory that results in the OOM error.
