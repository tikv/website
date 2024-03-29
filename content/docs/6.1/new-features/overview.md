---
title: What's New
description: New features and improvements about TiKV 6.1
menu:
    "6.1":
        weight: 1
        identifier: What's New-v6.1
---

This document lists some significant features and improvements in **TiKV 6.1**.

## Improve stability of TiKV flow control

TiKV introduces **a new flow control mechanism to replace the previous RocksDB write stall mechanism**. Compared with the write stall mechanism, this new mechanism **reduces the impact on the stability of foreground write**.

In specific, when the stress of RocksDB compaction accumulates, flow control is performed at the TiKV scheduler layer instead of the RocksDB layer, to avoid the following issues:

- Raftstore is stuck, which is caused by RocksDB write stall.

- Raft election times out and, as a result, the node leader is transferred.

**This new mechanism improves the flow control algorithm to mitigate QPS decrease when the write traffic is high**.

[Click here](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#storageflow-control) to see user guide.

## Improve Write latency

**Reduce write latency by separating I/O operations from Raftstore thread pool** (disabled by default). For more information about tuning, see [Tune TiKV Thread Pool Performance](https://docs.pingcap.com/tidb/stable/tune-tikv-thread-performance).

## Support Raft Engine

Since v6.1, TiKV has used Raft Engine as the default storage engine for logs. Compared with RocksDB, **Raft Engine can reduce TiKV I/O write traffic by up to 40% and CPU usage by 10%, while improving foreground throughput by about 5% and reducing tail latency by 20% under certain loads**.

[Click here](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#raft-engine) to see user guide.

## Support Continuous Profiling

TiKV Dashboard introduces the Continuous Profiling feature, which is now generally available in v6.1. Continuous profiling is not enabled by default. **When enabled, the performance data of individual TiKV, and PD instances will be collected all the time, with negligible overhead**. With history performance data, technical experts can backtrack and pinpoint the root causes of issues like high memory consumption, even when the issues are difficult to reproduce. **In this way, the mean time to recovery (MTTR) can be reduced**.

[Click here](https://docs.pingcap.com/tidb/stable/continuous-profiling) to see user guide.

## Accelerate leader balancing after restarting TiKV nodes

After a restart of TiKV nodes, the unevenly scattered leaders must be redistributed for load balance. In large-scale clusters, leader balancing time is positively correlated with the number of Regions. For example, the leader balancing of 100K Regions can take 20-30 minutes, which is prone to performance issues and stability risks due to uneven load. **TiKV v6.1 provides a parameter to control the balancing concurrency and enlarges the default value to 4 times of the original, which greatly shortens the leader rebalancing time and accelerates business recovery after a restart of the TiKV nodes**.

[Click here](https://docs.pingcap.com/tidb/stable/pd-control#scheduler-config-balance-leader-scheduler) to see user guide.


## TiKV API V2 (experimental)

Before v6.1, when TiKV is used as Raw Key Value storage, TiKV only provides basic Key Value read and write capability because it only stores the raw data passed in by the client.

TiKV API V2 provides a new Raw Key Value storage format and access interface, including the following changes:

- **The data is stored in MVCC and the change timestamp of the data is recorded. This feature lays the foundation for implementing Change Data Capture and incremental backup and restore**.
- **Data is scoped according to different usage. Now you can run TiDB, Transactional KV, and RawKV applications within a single TiKV cluster**.

{{< warning >}}
Due to significant changes in the underlying storage format, after enabling API V2, you cannot roll back a TiKV cluster to a version earlier than v6.1. Downgrading TiKV might result in data corruption.{{</ warning >}}

[Click here](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#api-version-new-in-v610) to see user guide.


