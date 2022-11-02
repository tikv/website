---
title: RocksDB Config
description: Learn how to configure RocksDB engine in TiKV.
menu:
    "6.1":
        parent: Configure TiKV-v6.1
        weight: 8
        identifier: RocksDB Config-v6.1
---

TiKV uses [RocksDB](https://rocksdb.org/) internally to store Raft logs and key-value pairs.

TiKV creates two RocksDB instances on each Node:

* One `rocksdb` instance that stores key-value data.
* One `raftdb` instance that stores Raft logs and has a single column family called `raftdb.defaultcf`.

The `rocksdb` instance has three column families:

Column family | Purpose
:-------------|:-------
`rocksdb.defaultcf` | Stores actual KV pairs for TiKV
`rocksdb.lockcf` | Stores transaction lock
`rocksdb.writecf` | Stores transactions' commits and rollback records

RocksDB can be configured on each column family. Here is an example:

```toml
[rocksdb.writecf]
whole-key-filtering = false
```

For more information about the RocksDB configuration parameters, see [RocksDB-related parameters](../tikv-configuration-file/#rocksdb).
