---
title: RocksDB Titan Config
description: Learn how to enable Titan in TiKV.
menu:
    "dev":
        parent: Configure TiKV-dev
        weight: 11
        identifier: RocksDB Titan Config-dev
---

Titan is a RocksDB plugin developed by PingCAP to separate keys and values in RocksDB storage. The goal of Titan is to reduce the write amplification when storing large values.

## How Titan works

{{< figure
    src="/img/docs/titan-architecture.png"
    caption="Titan Architecture"
    number="" >}}

Titan store values separately from the LSM-tree during flush and compaction. The value in the LSM tree is the position index to the blob file of the real value. For more details on the design and implementation of Titan, see [Titan: A RocksDB Plugin to Reduce Write Amplification](https://pingcap.com/blog/titan-storage-engine-design-and-implementation/).

{{< info >}}
**Notes:** Although Titan improves write performance, it enlarges data storage size and reduces range scan performance at the same time. Therefore, it is recommended to use Titan when the average size of values is larger than 1KB.
{{< /info >}}

## How to enable Titan

{{< warning >}}
As Titan has not reached ultimate maturity to be applied in production, it is disabled in TiKV by default. Before enabling it, make sure you understand the above notes and have evaluated your scenario and needs.
{{< /warning >}}

To enable Titan in TiKV, set the following in the TiKV configuration file:

```toml
[rocksdb.titan]
# Enables or disables `Titan`. Note that Titan is still an experimental feature.
# default: false
enabled = true
```

For the information of all the Titan configuration parameters, see [Titan-related parameters](../tikv-configuration-file/#rocksdbtitan).

## How to fall back to RocksDB

If you find Titan does not help or causes read or other performance issues, you can take the following steps to fall back to RocksDB:

1. Enter the fallback mode using `tikv-ctl`:

   ```bash
   tikv-ctl --host 127.0.0.1:20160 modify-tikv-config -m kvdb -n default.blob_run_mode -v "kFallback"
   ```

    {{< info >}}
When using this command, make sure you have already enabled Titan.
    {{< /info >}}

2. Wait until the number of blob files reduces to 0. You can also accelerate it by `tikv-ctl compact-cluster`.

3. Set `rocksdb.titan.enabled=false` in the TiKV configuration file, and then restart TiKV.
