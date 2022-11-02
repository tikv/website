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
