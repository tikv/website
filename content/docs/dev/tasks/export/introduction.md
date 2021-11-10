---
title: Export
description: Export data to SST
menu:
    "dev":
        parent: Tasks
---

This document describes how to use [BR Raw KV backup](br-rawkv) capability to export KV data to remote storages as SST files.

[br-rawkv]: https://docs.pingcap.com/tidb/stable/use-br-command-line-tool#restore-raw-kv-experimental-feature

# Basic Usage

```bash
br backup raw --pd ⟨pd address⟩ \
  -s ⟨storage url⟩ \
  --start ⟨start key⟩ \
  --end ⟨end key⟩ \
  --format ⟨key format⟩ \
  --ratelimit ⟨in MiB/s⟩
```

This will export all KV data in the range `[start key, end key)` to the specified storage in the format of SST.

## Supported storage

The storage URL support following schemes:

| Service                                     | Scheme  | Example                             |
|---------------------------------------------|---------|-------------------------------------|
| Local filesystem, distributed on every node | local   | `local:///path/to/dest/`            |
| Hadoop HDFS and other compatible services   | hdfs    | `hdfs:///prefix/of/dest/`           |
| Amazon S3 and other compatible services     | s3      | `s3://bucket-name/prefix/of/dest/`  |
| GCS                                         | gcs, gs | `gcs://bucket-name/prefix/of/dest/` |
| Write to nowhere（for benchmark only）      | noop    | `noop://`                           |

S3 and GCS can be configured using URL and command line parameters, see the BR documentation [External Storage](br-external-storage) for more information.

[br-external-storage]: https://docs.pingcap.com/tidb/stable/backup-and-restore-storages

### HDFS configuration

To use HDFS storage, [Apache Hadoop](hdfs-client) or compatible client should be installed and currectly configured on all BR and TiKV machines. The `bin/hdfs` binary in hadoop installation will be used by BR and TiKV.

Various configuration should be provided for HDFS storage to work, see the following table.

| Component | Configuration                         | Environment variable | Configuration file item  |
|-----------|---------------------------------------|----------------------|--------------------------|
| BR        | hadoop installation directory         | HADOOP_HOME          | (None)                   |
| TiKV      | hadoop installation directory         | HADOOP_HOME          | backup.hadoop.home       |
| TiKV      | linux user to use when calling hadoop | HADOOP_LINUX_USER    | backup.hadoop.linux-user |

For TiKV, the configuration file have higher priority than environment variables.

[hdfs-client]: https://hadoop.apache.org/docs/stable/

### Parse SST file

#### Java Client

The exported SST file can be parsed using [Java Client](../../../reference/clients/java).

