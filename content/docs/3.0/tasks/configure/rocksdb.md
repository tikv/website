---
title: RocksDB Config
description: Learn how to configure namespace in TiKV.
menu:
    "3.0":
        parent: Configure
        weight: 6
---

TiKV uses [RocksDB](https://rocksdb.org/) as its underlying storage engine for storing both [Raft logs](../../../concepts/architecture#raft) and KV (key-value) pairs.

{{< info >}}
RocksDB was chosen for TiKV because it provides a highly customizable persistent key-value store that can be tuned to run in a variety of production environments, including pure memory, Flash, hard disks, or HDFS, it supports various compression algorithms, and it provides solid tools for production support and debugging.
{{< /info >}}

TiKV creates two RocksDB instances on each Node:

* A `rocksdb` instance that stores most TiKV data
* A `raftdb` that stores [Raft logs](../../../concepts/architecture#raft) and has a single column family called `raftdb.defaultcf`

The `rocksdb` instance has three column families:

Column family | Purpose
:-------------|:-------
`rocksdb.defaultcf` | Stores actual KV pairs for TiKV
`rocksdb.writecf` | Stores commit information in the MVCC model

RocksDB can be configured on a per-column-family basis. Here's an example:

```toml
[rocksdb]
max-background-jobs = 8
```

## RocksDB configuration options

### `max-background-jobs`

+ The number of background threads in RocksDB
+ Default value: `8`
+ Minimum value: `1`

### `max-sub-compactions`

+ The number of sub-compaction operations performed concurrently in RocksDB
+ Default value: `3`
+ Minimum value: `1`

### `max-open-files`

+ The total number of files that RocksDB can open
+ Default value: `40960`
+ Minimum value: `-1`

### `max-manifest-file-size`

+ The maximum size of a RocksDB Manifest file
+ Default value: `128MB`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `create-if-missing`

+ Determines whether to automatically create a DB switch
+ Default value: `true`

### `wal-recovery-mode`

+ WAL recovery mode
+ Optional values: `0` (`TolerateCorruptedTailRecords`), `1` (`AbsoluteConsistency`), `2` (`PointInTimeRecovery`), `3` (`SkipAnyCorruptedRecords`)
+ Default value: `2`
+ Minimum value: `0`
+ Maximum value: `3`

### `wal-dir`

+ The directory in which WAL files are stored
+ Default value: `/tmp/tikv/store`

### `wal-ttl-seconds`

+ The living time of the archived WAL files. When the value is exceeded, the system deletes these files.
+ Default value: `0`
+ Minimum value: `0`
+ unit: second

### `wal-size-limit`

+ The size limit of the archived WAL files. When the value is exceeded, the system deletes these files.
+ Default value: `0`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `enable-statistics`

+ Determines whether to automatically optimize the configuration of Rate LImiter
+ Default value: `false`

### `stats-dump-period`

+ Enables or disables Pipelined Write
+ Default value: `true`

### `compaction-readahead-size`

+ The size of `readahead` when compaction is being performed
+ Default value: `0`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `writable-file-max-buffer-size`

+ The maximum buffer size used in WritableFileWrite
+ Default value: `1MB`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `use-direct-io-for-flush-and-compaction`

+ Determines whether to use `O_DIRECT` for both reads and writes in background flush and compactions
+ Default value: `false`

### `rate-bytes-per-sec`

+ The maximum rate permitted by Rate Limiter
+ Default value: `0`
+ Minimum value: `0`
+ Unit: Bytes

### `rate-limiter-mode`

+ Rate LImiter mode
+ Optional values: `1` (`ReadOnly`), `2` (`WriteOnly`), `3` (`AllIo`)
+ Default value: `2`
+ Minimum value: `1`
+ Maximum value: `3`

### `auto-tuned`

+ Determines whether to automatically optimize the configuration of the Rate LImiter
+ Default value: `false`

### `enable-pipelined-write`

+ Enables or disables Pipelined Write
+ Default value: `true`

### `bytes-per-sync`

+ The rate at which OS incrementally synchronizes files to disk while these files are being written asynchronously
+ Default value: `1MB`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `wal-bytes-per-sync`

+ The rate at which OS incrementally synchronizes WAL files to disk while the WAL files are being written
+ Default value: `512KB`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `info-log-max-size`

+ The maximum size of Info log
+ Default value: `1GB`
+ Minimum value: `0`
+ Unit: B|KB|MB|GB

### `info-log-roll-time`

+ The time interval at which Info logs are truncated. If the value is `0`, logs are not truncated.
+ Default value: `0`

### `info-log-keep-log-file-num`

+ The maximum number of kept log files
+ Default value: `10`
+ Minimum value: `0`

### `info-log-dir`

+ The directory in which logs are stored
+ Default value: ""
