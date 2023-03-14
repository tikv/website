---
title: What's New
description: New features and improvements about TiKV since 6.2
menu:
    "6.5":
        weight: 1
        identifier: What's New-6.5
---

This document lists some significant features and improvements since **TiKV 6.2**.

## [TiKV 6.5.1](https://docs.pingcap.com/tidb/v6.5/release-6.5.1)

### Key new features and improvements

- Support starting TiKV on a CPU with less than 1 core [#13586](https://github.com/tikv/tikv/issues/13586) [#13752](https://github.com/tikv/tikv/issues/13752) [#14017](https://github.com/tikv/tikv/issues/14017) @[andreid-db](https://github.com/andreid-db)
- Increase the thread limit of the Unified Read Pool (`readpool.unified.max-thread-count`) to 10 times the CPU quota, to better handle high-concurrency queries [#13690](https://github.com/tikv/tikv/issues/13690) @[v01dstar](https://github.com/v01dstar)
- Change the the default value of `resolved-ts.advance-ts-interval` from `"1s"` to `"20s"`, to reduce cross-region traffic [#14100](https://github.com/tikv/tikv/issues/14100) @[overvenus](https://github.com/overvenus)



## [TiKV 6.5.0](https://docs.pingcap.com/tidb/v6.5/release-6.5.0)

### Key new features and improvements

* TiKV-BR GA: Supports backing up and restoring RawKV [#67](https://github.com/tikv/migration/issues/67) @[haojinming](https://github.com/haojinming)

    TiKV-BR is a backup and restore tool used in TiKV clusters. TiKV and PD can constitute a KV database when used without TiDB, which is called RawKV. TiKV-BR supports data backup and restore for products that use RawKV. TiKV-BR can also upgrade the [`api-version`](https://docs.pingcap.com/tidb/stable/tikv-configuration-file#api-version-new-in-v610) from `API V1` to `API V2` for TiKV cluster.

    For more information, see [documentation](https://tikv.org/docs/latest/concepts/explore-tikv-features/backup-restore/).



## [TiKV 6.4.0](https://docs.pingcap.com/tidb/v6.4/release-6.4.0)

### Key new features and improvements

- Accelerate fault recovery in extreme situations such as disk failures and stuck I/O.
- The [cluster diagnostics](https://docs.pingcap.com/tidb/v6.4/dashboard-diagnostics-access) feature becomes GA.
- [TiKV API V2](../../concepts/explore-tikv-features/api-v2) feature becomes GA.

### Observability

* Cluster diagnostics becomes GA [#1438](https://github.com/pingcap/tidb-dashboard/issues/1438) @[Hawkson-jee](https://github.com/Hawkson-jee)

    The [cluster diagnostics](https://docs.pingcap.com/tidb/v6.4/dashboard-diagnostics-access) feature in TiDB Dashboard diagnoses the problems that might exist in a cluster within a specified time range, and summarizes the diagnostic results and the cluster-related load monitoring information into [a diagnostic report](https://docs.pingcap.com/tidb/v6.4/dashboard-diagnostics-report). This diagnostic report is in the form of a web page. You can browse the page offline and circulate this page link after saving the page from a browser.

    With the diagnostic reports, you can quickly understand the basic health information of the cluster, including the load, component status, time consumption, and configurations. If the cluster has some common problems, you can locate the causes in the result of the built-in automatic diagnosis in the [diagnostic information](https://docs.pingcap.com/tidb/v6.4/dashboard-diagnostics-report#diagnostic-information) section.

### Stability

* Accelerate fault recovery in extreme situations such as disk failures and stuck I/O [#13648](https://github.com/tikv/tikv/issues/13648) @[LykxSassinator](https://github.com/LykxSassinator)

    For enterprise users, database availability is one of the most important metrics. While in complex hardware environments, how to quickly detect and recover from failures has always been one of the challenges of database availability. In v6.4.0, TiDB fully optimizes the state detection mechanism of TiKV nodes. Even in extreme situations such as disk failures and stuck I/O, TiDB can still report node state quickly and use the active wake-up mechanism to launch Leader election in advance, which accelerates cluster self-healing. Through this optimization, TiDB can shorten the cluster recovery time by about 50% in the case of disk failures.

### Ease of use

* TiKV API V2 becomes generally available (GA) [#11745](https://github.com/tikv/tikv/issues/11745) @[pingyu](https://github.com/pingyu)

    Before v6.1.0, TiKV only provides basic Key Value read and write capability because it only stores the raw data passed in by the client. In addition, due to different coding methods and unscoped data ranges, TiDB, Transactional KV, and RawKV cannot be used at the same time in the same TiKV cluster; instead, multiple clusters are needed in this case, thus increasing machine and deployment costs.

    TiKV API V2 provides a new RawKV storage format and access interface, which delivers the following benefits:

    - Store data in MVCC with the change timestamp of the data recorded, based on which Change Data Capture (CDC) is implemented. This feature is experimental and is detailed in [RawKV CDC](../../concepts/explore-tikv-features/cdc/cdc).
    - Data is scoped according to different usage and API V2 supports co-existence of TiDB, Transactional KV, and RawKV applications in a single cluster.
    - Reserve the Key Space field to support features such as multi-tenancy.

  To enable TiKV API V2, set `api-version = 2` in the `[storage]` section of the TiKV configuration file.

  For more information, see [User document](https://docs.pingcap.com/tidb/v6.4/tikv-configuration-file#api-version-new-in-v610).



## [TiKV 6.3.0](https://docs.pingcap.com/tidb/v6.3/release-6.3.0)

### Key new features and improvements

- TiKV supports encryption at rest using the SM4 algorithm.

### Security

* TiKV supports the SM4 algorithm for encryption at rest [#13041](https://github.com/tikv/tikv/issues/13041) @[jiayang-zheng](https://github.com/jiayang-zheng)

    Add the [SM4 algorithm](https://docs.pingcap.com/tidb/v6.3/encryption-at-rest) for TiKV encryption at rest. When you configure encryption at rest, you can enable the SM4 encryption capacity by setting the value of the `data-encryption-method` configuration to `sm4-ctr`.

### Performance

* TiKV supports log recycling [#214](https://github.com/tikv/raft-engine/issues/214) @[LykxSassinator](https://github.com/LykxSassinator)

    TiKV supports [recycling log files](https://docs.pingcap.com/tidb/v6.3/tikv-configuration-file#enable-log-recycle-new-in-v630) in Raft Engine. This reduces the long tail latency in network disks during Raft log appending and improves performance under write workloads.

### Stability

* Disabling Titan becomes GA @[tabokie](https://github.com/tabokie)

    You can [disable Titan](https://docs.pingcap.com/tidb/v6.3/titan-configuration#disable-titan) for online TiKV nodes.



## [TiKV 6.2.0](https://docs.pingcap.com/tidb/v6.2/release-6.2.0)

### Key new feature and improvements

* TiKV supports [automatically tuning the CPU usage](https://docs.pingcap.com/tidb/v6.2/tikv-configuration-file#background-quota-limiter), thus ensuring stable and efficient database operations.
* [Cross-cluster RawKV replication](../../concepts/explore-tikv-features/cdc/cdc) is now supported.

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
