---
title: RocksDB Titan
description: Learn how to enable Titan in TiKV.
menu:
    "5.1":
        parent: Configure TiKV
        weight: 11
---

Titan is a RocksDB plugin developed by PingCAP to separate keys and values in RocksDB storage. The goal of Titan is to reduce the write amplification when storing large values.

## How Titan works

{{< figure
    src="/img/docs/titan-architecture.png"
    caption="Titan Architecture"
    number="" >}}

Titan store values separately from the LSM-tree during flush and compaction. The value in the LSM tree is the position index to the blob file of the real value. For more details on the design and implementation of Titan, please refer to [Titan: A RocksDB Plugin to Reduce Write Amplification](https://pingcap.com/blog/titan-storage-engine-design-and-implementation/).

{{< info >}}
**Be cautious:** Even though Titan improves write performance, it enlarges data storage size and reduces range scan performance. We recommended using Titan when the average size of values is larger than 1KB.
{{< /info >}}

## How to enable Titan

As Titan has not reached ultimate maturity to be applied in production, it is disabled in TiKV by default. Before enabling it, make sure you understand the warning above and you have evaluated your scenarios and needs.

To enable Titan in TiKV, set in the TiKV configuration file:

```toml
[rocksdb.titan]
# Enables or disables `Titan`. Note that Titan is still an experimental feature.
# default: false
enabled = true
```

You can find all the Titan configuration options [here](../tikv-configuration-file/#rocksdbtitan).

## How to fall back to RocksDB

If you find Titan does not help or is causing read or other performance issues, you can take the following steps to fall back to RocksDB:

1. Enter the fallback mode using `tikv-ctl`:

   ```bash
   tikv-ctl --host 127.0.0.1:20160 modify-tikv-config -m kvdb -n default.blob_run_mode -v "kFallback"
   ```

    {{< info >}}
Make sure you have already enabled Titan when using this command.
    {{< /info >}}

2. Wait until the number of blob files reduces to 0. Also, you can accelerate it by `tikv-ctl compact-cluster`.

3. In the TiKV configuration file, set `rocksdb.titan.enabled=false`, and then restart TiKV.
