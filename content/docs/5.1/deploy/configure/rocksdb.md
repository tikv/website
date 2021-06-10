---
title: RocksDB
description: Learn how to configure RocksDB engine in TiKV.
menu:
    "5.1":
        parent: Configure TiKV
        weight: 8
---

TiKV uses [RocksDB](https://rocksdb.org/) internally to store Raft logs and key-value pairs.

TiKV creates two RocksDB instances on each Node:

* A `rocksdb` instance that stores key-value data.
* A `raftdb` that stores Raft logs.

The `rocksdb` instance has three column families:

Column family | Purpose
:-------------|:-------
`rocksdb.defaultcf` | Stores actual KV pairs for TiKV
`rocksdb.lockcf` | Stores transaction lock
`rocksdb.writecf` | Stores transactions' commit and rollback record

RocksDB can be configured on each column family. Here's an example:

```toml
[rocksdb.writecf]
whole-key-filtering = false
```

You can find all the RocksDB configuration options [here](../tikv-configuration-file/#rocksdb).
