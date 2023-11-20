---
title: What's New
description: New features and improvements about TiKV since 6.6
menu:
    "7.1":
        weight: 1
        identifier: What's New-7.1
---

This document lists some significant features and improvements after **TiKV 6.5**.

## [TiKV 7.1.2](https://docs.pingcap.com/tidb/v7.1/release-7.1.2)

## [TiKV 7.1.1](https://docs.pingcap.com/tidb/v7.1/release-7.1.1)

## [TiKV 7.1.0](https://docs.pingcap.com/tidb/v7.1/release-7.1.0)

* Enhance the Partitioned Raft KV storage engine (experimental) [#11515](https://github.com/tikv/tikv/issues/11515) [#12842](https://github.com/tikv/tikv/issues/12842) @[busyjay](https://github.com/busyjay) @[tonyxuqqi](https://github.com/tonyxuqqi) @[tabokie](https://github.com/tabokie) @[bufferflies](https://github.com/bufferflies) @[5kbpers](https://github.com/5kbpers) @[SpadeA-Tang](https://github.com/SpadeA-Tang) @[nolouch](https://github.com/nolouch)

    TiDB v6.6.0 introduces the Partitioned Raft KV storage engine as an experimental feature, which uses multiple RocksDB instances to store TiKV Region data, and the data of each Region is independently stored in a separate RocksDB instance. The new storage engine can better control the number and level of files in the RocksDB instance, achieve physical isolation of data operations between Regions, and support stably managing more data. Compared with the original TiKV storage engine, using the Partitioned Raft KV storage engine can achieve about twice the write throughput and reduce the elastic scaling time by about 4/5 under the same hardware conditions and mixed read and write scenarios.

    In TiDB v7.1.0, the Partitioned Raft KV storage engine supports tools such as TiDB Lightning, BR, and TiCDC.

    Currently, this feature is experimental and not recommended for use in production environments. You can only use this engine in a newly created cluster and you cannot directly upgrade from the original TiKV storage engine.

    For more information, see [documentation](https://docs.pingcap.com/tidb/stable/partitioned-raft-kv).

* Resource Control becomes generally available (GA) [#38825](https://github.com/pingcap/tidb/issues/38825) @[nolouch](https://github.com/nolouch) @[BornChanger](https://github.com/BornChanger) @[glorv](https://github.com/glorv) @[tiancaiamao](https://github.com/tiancaiamao) @[Connor1996](https://github.com/Connor1996) @[JmPotato](https://github.com/JmPotato) @[hnes](https://github.com/hnes) @[CabinfeverB](https://github.com/CabinfeverB) @[HuSharp](https://github.com/HuSharp)

    TiDB enhances the resource control feature based on resource groups, which becomes GA in v7.1.0. This feature significantly improves the resource utilization efficiency and performance of TiDB clusters. The introduction of the resource control feature is a milestone for TiDB. You can divide a distributed database cluster into multiple logical units, map different database users to corresponding resource groups, and set the quota for each resource group as needed. When the cluster resources are limited, all resources used by sessions in the same resource group are limited to the quota. In this way, even if a resource group is over-consumed, the sessions in other resource groups are not affected.

    With this feature, you can combine multiple small and medium-sized applications from different systems into a single TiDB cluster. When the workload of an application grows larger, it does not affect the normal operation of other applications. When the system workload is low, busy applications can still be allocated the required system resources even if they exceed the set quotas, which can achieve the maximum utilization of resources. In addition, the rational use of the resource control feature can reduce the number of clusters, ease the difficulty of operation and maintenance, and save management costs.

    In TiDB v7.1.0, this feature introduces the ability to estimate system capacity based on actual workload or hardware deployment. The estimation ability provides you with a more accurate reference for capacity planning and assists you in better managing TiDB resource allocation to meet the stability needs of enterprise-level scenarios.

    To improve user experience, TiDB Dashboard provides the [Resource Manager page](https://docs.pingcap.com/tidb/stable/dashboard-resource-manager). You can view the resource group configuration on this page and estimate cluster capacity in a visual way to facilitate reasonable resource allocation.

    For more information, see [documentation](https://docs.pingcap.com/tidb/stable/tidb-resource-control).

## [TiKV 7.0.0](https://docs.pingcap.com/tidb/v7.0/release-7.0.0)

### Key new features and improvements

* [Resource control](https://docs-archive.pingcap.com/tidb/v7.0/tidb-resource-control) enhancement (experimental)

    Support using resource groups to allocate and isolate resources for various applications or workloads within one cluster. For more information, see [documentation](https://docs.pingcap.com/tidb/stable/tidb-resource-control).

* TiKV supports automatically generating empty log files for log recycling [#14371](https://github.com/tikv/tikv/issues/14371) [@LykxSassinator](https://github.com/LykxSassinator)

    In v6.3.0, TiKV introduced the [Raft log recycling](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#enable-log-recycle-new-in-v630) feature to reduce long-tail latency caused by write load. However, log recycling can only take effect when the number of Raft log files reaches a certain threshold, making it difficult for users to directly experience the throughput improvement brought by this feature.

    In v7.0.0, a new configuration item called `raft-engine.prefill-for-recycle`` was introduced to improve user experience. This item controls whether empty log files are generated for recycling when the process starts. When this configuration is enabled, TiKV automatically fills a batch of empty log files during initialization, ensuring that log recycling takes effect immediately after initialization.

    For more information, see [documentation](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#prefill-for-recycle-new-in-v700).

## [TiKV 6.6.0](https://docs.pingcap.com/tidb/v6.6/release-6.6.0)

### Key new features and improvements

#### Scalability

* Support Partitioned Raft KV storage engine (experimental) [#11515](https://github.com/tikv/tikv/issues/11515) [#12842](https://github.com/tikv/tikv/issues/12842) @[busyjay](https://github.com/busyjay) @[tonyxuqqi](https://github.com/tonyxuqqi) @[tabokie](https://github.com/tabokie) @[bufferflies](https://github.com/bufferflies) @[5kbpers](https://github.com/5kbpers) @[SpadeA-Tang](https://github.com/SpadeA-Tang) @[nolouch](https://github.com/nolouch)

    Before TiDB v6.6.0, TiKV's Raft-based storage engine used a single RocksDB instance to store the data of all 'Regions' of the TiKV instance. To support larger clusters more stably, starting from TiDB v6.6.0, a new TiKV storage engine is introduced, which uses multiple RocksDB instances to store TiKV Region data, and the data of each Region is independently stored in a separate RocksDB instance. The new engine can better control the number and level of files in the RocksDB instance, achieve physical isolation of data operations between Regions, and support stably managing more data. You can see it as TiKV managing multiple RocksDB instances through partitioning, which is why the feature is named Partitioned-Raft-KV. The main advantage of this feature is better write performance, faster scaling, and larger volume of data supported with the same hardware. It can also support larger cluster scales.

    Currently, this feature is experimental and not recommended for use in production environments.

    For more information, see [documentation](https://docs.pingcap.com/tidb/v6.6/partitioned-raft-kv).

#### DB operations

* The TiKV-CDC tool is now GA and supports subscribing to data changes of RawKV [#48](https://github.com/tikv/migration/issues/48) @[zeminzhou](https://github.com/zeminzhou) @[haojinming](https://github.com/haojinming) @[pingyu](https://github.com/pingyu)

    TiKV-CDC is a CDC (Change Data Capture) tool for TiKV clusters. TiKV and PD can constitute a KV database when used without TiDB, which is called RawKV. TiKV-CDC supports subscribing to data changes of RawKV and replicating them to a downstream TiKV cluster in real time, thus enabling cross-cluster replication of RawKV.

    For more information, see [documentation](https://tikv.org/docs/latest/concepts/explore-tikv-features/cdc/cdc/).

* Support configuring read-only storage nodes for resource-consuming tasks @[v01dstar](https://github.com/v01dstar)

    In production environments, some read-only operations might consume a large number of resources regularly and affect the performance of the entire cluster, such as backups and large-scale data reading and analysis. TiDB v6.6.0 supports configuring read-only storage nodes for resource-consuming read-only tasks to reduce the impact on the online application. Currently, TiDB, TiSpark, and BR support reading data from read-only storage nodes. You can configure read-only storage nodes according to [steps](https://docs.pingcap.com/tidb/v6.6/readonly-nodes#procedures) and specify where data is read through the system variable `tidb_replica_read`, the TiSpark configuration item `spark.tispark.replica_read`, or the br command line argument `--replica-read-label`, to ensure the stability of cluster performance.

    For more information, see [documentation](https://docs.pingcap.com/tidb/v6.6/readonly-nodes).

* Support dynamically modifying `store-io-pool-size` [#13964](https://github.com/tikv/tikv/issues/13964) @[LykxSassinator](https://github.com/LykxSassinator)

    The TiKV configuration item [`raftstore.store-io-pool-size`](https://docs.pingcap.com/tidb/v6.6/tikv-configuration-file#store-io-pool-size-new-in-v530) specifies the allowable number of threads that process Raft I/O tasks, which can be adjusted when tuning TiKV performance. Before v6.6.0, this configuration item cannot be modified dynamically. Starting from v6.6.0, you can modify this configuration without restarting the server, which means more flexible performance tuning.

    For more information, see [documentation](https://docs.pingcap.com/tidb/v6.6/dynamic-config).
