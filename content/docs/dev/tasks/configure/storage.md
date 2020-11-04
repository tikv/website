---
title: Storage Config
description: Learn how to configure storage in TiKV.
menu:
    "dev":
        parent: Configure
        weight: 10
---

This document describes the configuration parameters related to storage.

### `scheduler-notify-capacity`

+ The maximum number of messages that `scheduler` gets each time
+ Default value: `10240`
+ Minimum value: `1`

### `scheduler-concurrency`

+ A built-in memory lock mechanism to prevent simultaneous operations on a key. Each key has a hash in a different slot.
+ Default value: `2048000`
+ Minimum value: `1`

### `scheduler-worker-pool-size`

+ The number of `scheduler` threads, mainly used for checking transaction consistency before data writing
+ Default value: `4`
+ Minimum value: `1`

### `scheduler-pending-write-threshold`

+ The maximum size of the write queue. A `Server Is Busy` error is returned for a new write to TiKV when this value is exceeded.
+ Default value: `100MB`
+ Unit: MB|GB

### `reserve-space`

+ The size of the temporary file that preoccupies the extra space when TiKV is started. The name of temporary file is `space_placeholder_file`, located in the `storage.data-dir` directory. When TiKV runs out of disk space and cannot be started normally, you can delete this file as an emergency intervention and set `reserve-space` to `0MB`.
+ Default value: `2GB`
+ Unite: MB|GB
