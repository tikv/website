---
title: What's New
description: New features and improvements about TiKV since 6.2
menu:
    "dev":
        weight: 1
        identifier: What's New-dev
---

This document lists some significant features and improvements since **TiKV 6.2**.

## [TiKV 6.3.0]((https://docs.pingcap.com/tidb/v6.3/release-6.3.0))

### Key new features and improvements

- TiKV supports encryption at rest using the SM4 algorithm.

### Security

* TiKV supports the SM4 algorithm for encryption at rest [#13041](https://github.com/tikv/tikv/issues/13041) @[jiayang-zheng](https://github.com/jiayang-zheng)

    Add the [SM4 algorithm](/encryption-at-rest.md) for TiKV encryption at rest. When you configure encryption at rest, you can enable the SM4 encryption capacity by setting the value of the `data-encryption-method` configuration to `sm4-ctr`.

### Performance

* TiKV supports log recycling [#214](https://github.com/tikv/raft-engine/issues/214) @[LykxSassinator](https://github.com/LykxSassinator)

    TiKV supports [recycling log files](/tikv-configuration-file.md#enable-log-recycle-new-in-v630) in Raft Engine. This reduces the long tail latency in network disks during Raft log appending and improves performance under write workloads.

### Stability

* Disabling Titan becomes GA @[tabokie](https://github.com/tabokie)

    You can [disable Titan](/storage-engine/titan-configuration.md#disable-titan) for online TiKV nodes.

### Compatibility changes

### Configuration file parameters

| Configuration file | Configuration | Change type | Description |
| --- | --- | --- | --- |
| TiKV | [`auto-adjust-pool-size`](/tikv-configuration-file.md#auto-adjust-pool-size-new-in-v630) | Newly added | Controls whether to automatically adjust the thread pool size. When it is enabled, the read performance of TiKV is optimized by automatically adjusting the UnifyReadPool thread pool size based on the current CPU usage.|
| TiKV | [`data-encryption-method`](/tikv-configuration-file.md#data-encryption-method) | Modified | Introduces a new value option `sm4-ctr`. When this configuration item is set to `sm4-ctr`, data is encrypted using SM4 before being stored. |
| TiKV | [`enable-log-recycle`](/tikv-configuration-file.md#enable-log-recycle-new-in-v630) | Newly added | Determines whether to recycle stale log files in Raft Engine. When it is enabled, logically purged log files will be reserved for recycling. This reduces the long tail latency on write workloads. This configuration item is only available when [format-version](/tikv-configuration-file.md#format-version-new-in-v630) is >= 2. |
| TiKV | [`format-version`](/tikv-configuration-file.md#format-version-new-in-v630) | Newly added | Specifies the version of log files in Raft Engine. The default log file version is `1` for TiKV earlier than v6.3.0. The log files can be read by TiKV >= v6.1.0. The default log file version is `2` for TiKV v6.3.0 and later. TiKV v6.3.0 and later can read the log files. |
| TiKV | [`log-backup.enable`](/tikv-configuration-file.md#enable-new-in-v620) | Modified | Since v6.3.0, the default value changes from `false` to `true`. |
| TiKV | [`log-backup.max-flush-interval`](/tikv-configuration-file.md#max-flush-interval-new-in-v620) | Modified | Since v6.3.0, the default value changes from `5min` to `3min`. |
| PD | [enable-diagnostic](/pd-configuration-file.md#enable-diagnostic-new-in-v630) | Newly added | Controls whether to enable the diagnostic feature. The default value is `false`. |

### Improvements

- Support configuring the `unreachable_backoff` item to avoid Raftstore broadcasting too many messages after one peer becomes unreachable [#13054](https://github.com/tikv/tikv/issues/13054) @[5kbpers](https://github.com/5kbpers)
- Improve the fault tolerance of TSO service [#12794](https://github.com/tikv/tikv/issues/12794) @[pingyu](https://github.com/pingyu)
- Support dynamically modifying the number of sub-compaction operations performed concurrently in RocksDB (`rocksdb.max-sub-compactions`) [#13145](https://github.com/tikv/tikv/issues/13145) @[ethercflow](https://github.com/ethercflow)
- Optimize the performance of merging empty Regions [#12421](https://github.com/tikv/tikv/issues/12421) @[tabokie](https://github.com/tabokie)
- Support more regular expression functions [#13483](https://github.com/tikv/tikv/issues/13483) @[gengliqi](https://github.com/gengliqi)
- Support automatically adjusting the thread pool size based on the CPU usage [#13313](https://github.com/tikv/tikv/issues/13313) @[glorv](https://github.com/glorv)

### Bug fixes

+ TiKV

    - Fix the issue that PD does not reconnect to TiKV after the Region heartbeat is interrupted [#12934](https://github.com/tikv/tikv/issues/12934) @[bufferflies](https://github.com/bufferflies)
    - Fix the issue that Regions might be overlapped if Raftstore is busy [#13160](https://github.com/tikv/tikv/issues/13160) @[5kbpers](https://github.com/5kbpers)
    - Fix the issue that the PD client might cause deadlocks [#13191](https://github.com/tikv/tikv/issues/13191) @[bufferflies](https://github.com/bufferflies) [#12933](https://github.com/tikv/tikv/issues/12933) @[BurtonQin](https://github.com/BurtonQin)
    - Fix the issue that TiKV might panic when encryption is disabled [#13081](https://github.com/tikv/tikv/issues/13081) @[jiayang-zheng](https://github.com/jiayang-zheng)
    - Fix the wrong expression of `Unified Read Pool CPU` in Dashboard [#13086](https://github.com/tikv/tikv/issues/13086) @[glorv](https://github.com/glorv)
    - Fix the issue that the TiKV service is unavailable for several minutes when a TiKV instance is in an isolated network environment [#12966](https://github.com/tikv/tikv/issues/12966) @[cosven](https://github.com/cosven)
    - Fix the issue that TiKV mistakenly reports a `PessimisticLockNotFound` error [#13425](https://github.com/tikv/tikv/issues/13425) @[sticnarf](https://github.com/sticnarf)
    - Fix the issue that PITR might cause data loss in some situations [#13281](https://github.com/tikv/tikv/issues/13281) @[YuJuncen](https://github.com/YuJuncen)
    - Fix the issue that causes checkpoint not advanced when there are some long pessimistic transactions [#13304](https://github.com/tikv/tikv/issues/13304) @[YuJuncen](https://github.com/YuJuncen)
    - Fix the issue that TiKV does not distinguish the datetime type (`DATETIME`, `DATE`, `TIMESTAMP` and `TIME`) and `STRING` type in JSON [#13417](https://github.com/tikv/tikv/issues/13417) @[YangKeao](https://github.com/YangKeao)
    - Fix incompatibility with MySQL of comparison between JSON bool and other JSON value [#13386](https://github.com/tikv/tikv/issues/13386) [#37481](https://github.com/pingcap/tidb/issues/37481) @[YangKeao](https://github.com/YangKeao)

+ PD

    - Fix PD panics caused by the issue that gRPC handles errors inappropriately when `enable-forwarding` is enabled [#5373](https://github.com/tikv/pd/issues/5373) @[bufferflies](https://github.com/bufferflies)
    - Fix the issue that unhealthy Region might cause PD panic [#5491](https://github.com/tikv/pd/issues/5491) @[nolouch](https://github.com/nolouch)
    - Fix the issue that the TiFlash learner replica might not be created [#5401](https://github.com/tikv/pd/issues/5401) @[HunDunDM](https://github.com/HunDunDM)


## [TiKV 6.2.0](https://docs.pingcap.com/tidb/v6.2/release-6.2.0)

### Key new feature and improvements

* TiKV supports [automatically tuning the CPU usage](https://docs.pingcap.com/tidb/v6.2/tikv-configuration-file#background-quota-limiter), thus ensuring stable and efficient database operations.
* [Cross-cluster RawKV replication](https://docs.pingcap.com/tidb/v6.2/tikv-configuration-file#api-version-new-in-v610) is now supported.

### Stability

* TiKV supports automatically tuning the CPU usage (experimental)

    Databases usually have background processes to perform internal operations. Statistical information can be collected to help identify performance problems, generate better execution plans, and improve the stability and performance of the database. However, how to more efficiently collect information, and how to balance the resource overhead of background operations and foreground operations without affecting the daily use have always been one of the headaches in the database industry.

    Starting from v6.2.0, TiDB supports setting the CPU usage rate of background requests using the TiKV configuration file, thereby limiting the CPU usage ratio of background operations such as automatically collecting statistics in TiKV, and avoiding the resource preemption of user operations by background operations in extreme cases. This ensures that the operations of the database are stable and efficient.

    At the same time, TiDB also supports automatically adjusting CPU usage. Then, TiKV will adaptively adjust the CPU resources occupied by background requests according to the CPU usage of the instance. This feature is disabled by default.

    [User document](https://docs.pingcap.com/tidb/v6.2/tikv-configuration-file#background-quota-limiter) [#12503](https://github.com/tikv/tikv/issues/12503) @[BornChanger](https://github.com/BornChanger)

### Ease of use

* TiKV supports listing detailed configuration information using command-line flags

    The TiKV configuration file can be used to manage TiKV instances. However, for instances that run for a long time and are managed by different users, it is difficult to know which configuration item has been modified and what the default value is. This might cause confusion when you upgrade the cluster or migrate data. Since TiDB v6.2.0, tikv-server supports a new command-line flag [`—-config-info`](https://docs.pingcap.com/tidb/v6.2/command-line-flags-for-tikv-configuration#--config-info-format) that lists default and current values of all TiKV configuration items, helps users to quickly verify the startup parameters of the TiKV process, and improves usability.

    [User document](https://docs.pingcap.com/tidb/v6.2/command-line-flags-for-tikv-configuration#--config-info-format) [#12492](https://github.com/tikv/tikv/issues/12492) @[glorv](https://github.com/glorv)

### Compatibility changes

#### Configuration file parameters

| Configuration file | Configuration | Change type | Description |
| --- | --- | --- | --- |
| TiKV | [server.simplify-metrics](/tikv-configuration-file.md#simplify-metrics-new-in-v620) | Newly added | This configuration specifies whether to simplify the returned monitoring metrics. |
| TiKV | [quota.background-cpu-time](/tikv-configuration-file.md#background-cpu-time-new-in-v620) | Newly added | This configuration specifies the soft limit on the CPU resources used by TiKV background to process read and write requests. |
| TiKV | [quota.background-write-bandwidth](/tikv-configuration-file.md#background-write-bandwidth-new-in-v620) | Newly added | This configuration specifies the soft limit on the bandwidth with which background transactions write data (not effective currently). |
| TiKV | [quota.background-read-bandwidth](/tikv-configuration-file.md#background-read-bandwidth-new-in-v620) | Newly added | This configuration specifies the soft limit on the bandwidth with which background transactions and the Coprocessor read data (not effective currently). |
| TiKV | [quota.enable-auto-tune](/tikv-configuration-file.md#enable-auto-tune-new-in-v620) | Newly added | This configuration specifies whether to enable the auto-tuning of quota. If this configuration item is enabled, TiKV dynamically adjusts the quota for the background requests based on the load of TiKV instances. |
| TiKV | rocksdb.enable-pipelined-commit | Deleted | This configuration is no longer effective. |
| TiKV | gc-merge-rewrite | Deleted | This configuration is no longer effective. |
| TiKV | [log-backup.enable](/tikv-configuration-file.md#enable-new-in-v620) | Newly added | This configuration controls whether to enable log backup on TiKV. |
| TiKV | [log-backup.file-size-limit](/tikv-configuration-file.md#file-size-limit-new-in-v620) | Newly added | This configuration specifies the size limit on log backup data. Once this limit is reached, data is automatically flushed to external storage. |
| TiKV | [log-backup.initial-scan-pending-memory-quota](/tikv-configuration-file.md#initial-scan-pending-memory-quota-new-in-v620) | Newly added | This configuration specifies the quota of cache used for storing incremental scan data. |
| TiKV | [log-backup.max-flush-interval](/tikv-configuration-file.md#max-flush-interval-new-in-v620) | Newly added | This configuration specifies the maximum interval for writing backup data to external storage in log backup. |
| TiKV | [log-backup.initial-scan-rate-limit](/tikv-configuration-file.md#initial-scan-rate-limit-new-in-v620) | Newly added | This configuration specifies the rate limit on throughput in an incremental data scan in log backup. |
| TiKV | [log-backup.num-threads](/tikv-configuration-file.md#num-threads-new-in-v620) | Newly added | This configuration specifies the number of threads used in log backup. |
| TiKV | [log-backup.temp-path](/tikv-configuration-file.md#temp-path-new-in-v620) | Newly added | This configuration specifies temporary path to which log files are written before being flushed to external storage. |
| PD | replication-mode.dr-auto-sync.wait-async-timeout | Deleted | This configuration does not take effect and is deleted. |
| PD | replication-mode.dr-auto-sync.wait-sync-timeout | Deleted | This configuration does not take effect and is deleted. |

#### Others

- TiKV adds a configuration item `split.region-cpu-overload-threshold-ratio` that supports [online configuration](/dynamic-config.md#modify-tikv-configuration-online).

### Improvements

- Support compressing the metrics response using gzip to reduce the HTTP body size [#12355](https://github.com/tikv/tikv/issues/12355) @[glorv](https://github.com/glorv)
- Improve the readability of the TiKV panel in Grafana Dashboard [#12007](https://github.com/tikv/tikv/issues/12007) @[kevin-xianliu](https://github.com/kevin-xianliu)
- Optimize the commit pipeline performance of the Apply operator [#12898](https://github.com/tikv/tikv/issues/12898) @[ethercflow](https://github.com/ethercflow)
- Support dynamically modifying the number of sub-compaction operations performed concurrently in RocksDB (`rocksdb.max-sub-compactions`) [#13145](https://github.com/tikv/tikv/issues/13145) @[ethercflow](https://github.com/ethercflow)

### Bug fixes

+ TiKV

    - Avoid reporting `WriteConflict` errors in pessimistic transactions [#11612](https://github.com/tikv/tikv/issues/11612) @[sticnarf](https://github.com/sticnarf)
    - Fix the possible duplicate commit records in pessimistic transactions when async commit is enabled [#12615](https://github.com/tikv/tikv/issues/12615) @[sticnarf](https://github.com/sticnarf)
    - Fix the issue that TiKV panics when modifying the `storage.api-version` from `1` to `2` [#12600](https://github.com/tikv/tikv/issues/12600) @[pingyu](https://github.com/pingyu)
    - Fix the issue of inconsistent Region size configuration between TiKV and PD [#12518](https://github.com/tikv/tikv/issues/12518) @[5kbpers](https://github.com/5kbpers)
    - Fix the issue that TiKV keeps reconnecting PD clients [#12506](https://github.com/tikv/tikv/issues/12506), [#12827](https://github.com/tikv/tikv/issues/12827) @[Connor1996](https://github.com/Connor1996)
    - Fix the issue that TiKV panics when performing type conversion for an empty string [#12673](https://github.com/tikv/tikv/issues/12673) @[wshwsh12](https://github.com/wshwsh12)
    - Fix the issue of time parsing error that occurs when the `DATETIME` values contain a fraction and `Z` [#12739](https://github.com/tikv/tikv/issues/12739) @[gengliqi](https://github.com/gengliqi)
    - Fix the issue that the perf context written by the Apply operator to TiKV RocksDB is coarse-grained [#11044](https://github.com/tikv/tikv/issues/11044) @[LykxSassinator](https://github.com/LykxSassinator)
    - Fix the issue that TiKV fails to start when the configuration of [backup](/tikv-configuration-file.md#backup)/[import](/tikv-configuration-file.md#import)/[cdc](/tikv-configuration-file.md#cdc) is invalid [#12771](https://github.com/tikv/tikv/issues/12771) @[3pointer](https://github.com/3pointer)
    - Fix the panic issue that might occur when a peer is being split and destroyed at the same time [#12825](https://github.com/tikv/tikv/issues/12825) @[BusyJay](https://github.com/BusyJay)
    - Fix the panic issue that might occur when the source peer catches up logs by snapshot in the Region merge process [#12663](https://github.com/tikv/tikv/issues/12663) @[BusyJay](https://github.com/BusyJay)
    - Fix the panic issue caused by analyzing statistics when `max_sample_size` is set to `0` [#11192](https://github.com/tikv/tikv/issues/11192) @[LykxSassinator](https://github.com/LykxSassinator)
    - Fix the issue that encryption keys are not cleaned up when Raft Engine is enabled [#12890](https://github.com/tikv/tikv/issues/12890) @[tabokie](https://github.com/tabokie)
    - Fix the issue that the `get_valid_int_prefix` function is incompatible with TiDB. For example, the `FLOAT` type was incorrectly converted to `INT` [#13045](https://github.com/tikv/tikv/issues/13045) @[guo-shaoge](https://github.com/guo-shaoge)
    - Fix the issue that the Commit Log Duration of a new Region is too high, which causes QPS to drop [#13077](https://github.com/tikv/tikv/issues/13077) @[Connor1996](https://github.com/Connor1996)
    - Fix the issue that PD does not reconnect to TiKV after the Region heartbeat is interrupted [#12934](https://github.com/tikv/tikv/issues/12934) @[bufferflies](https://github.com/bufferflies)
