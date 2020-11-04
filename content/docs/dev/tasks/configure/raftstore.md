---
title: Raftstore Config
description: Learn how to configure Raftstore in TiKV.
menu:
    "dev":
        parent: Configure
        weight: 7
---

This document describes the configuration parameters related to Raftstore.

### `sync-log`

+ Enables or disables synchronous write mode. In the synchronous write mode, each commit is forced to be flushed to raft-log synchronously for persistent storage.
+ Default value: `true`

{{< warning >}}
Setting this value to `false` might lead to **data loss**. It is **strongly recommended** that you do not modify this configuration.
{{< /warning >}}

### `prevote`

+ Enables or disables `prevote`. Enabling this feature helps reduce jitter on the system after recovery from network partition.
+ Default value: `true`

### `raftdb-path`

+ The path to the Raft library, which is `storage.data-dir/raft` by default
+ Default value: ""

### `raft-base-tick-interval`

+ The time interval at which the Raft state machine ticks
+ Default value: `1s`
+ Minimum value: greater than `0`

### `raft-heartbeat-ticks`

+ The number of passed ticks when the heartbeat is sent. This means that a heartbeat is sent at the time interval of `raft-base-tick-interval` * `raft-heartbeat-ticks`.
+ Default value: `2`
+ Minimum value: greater than `0`

### `raft-election-timeout-ticks`

+ The number of passed ticks when Raft election is initiated. This means that if Raft group is missing the leader, a leader election is initiated approximately after the time interval of `raft-base-tick-interval` * `raft-election-timeout-ticks`.
+ Default value: `10`
+ Minimum value: `raft-heartbeat-ticks`

### `raft-min-election-timeout-ticks`

+ The minimum number of ticks during which the Raft election is initiated. If the number is `0`, the value of `raft-election-timeout-ticks` is used. The value of this parameter must be greater than or equal to `raft-election-timeout-ticks`.
+ Default value: `0`
+ Minimum value: `0`

### `raft-max-election-timeout-ticks`

+ The maximum number of ticks during which the Raft election is initiated. If the number is `0`, the value of `raft-election-timeout-ticks` * `2` is used.
+ Default value: `0`
+ Minimum value: `0`

### `raft-max-size-per-message`

+ The soft limit on the size of a single message packet
+ Default value: `1MB`
+ Minimum value: `0`
+ Unit: MB

### `raft-max-inflight-msgs`

+ The number of Raft logs to be confirmed. If this number is exceeded, log sending slows down.
+ Default value: `256`
+ Minimum value: greater than `0`

### `raft-entry-max-size`

+ The hard limit on the maximum size of a single log
+ Default value: `8MB`
+ Minimum value: `0`
+ Unit: MB|GB

### `raft-log-gc-tick-interval`

+ The time interval at which the polling task of deleting Raft logs is scheduled. `0` means that this feature is disabled.
+ Default value: `10s`
+ Minimum value: `0`

### `raft-log-gc-threshold`

+ The soft limit on the maximum allowable count of residual Raft logs
+ Default value: `50`
+ Minimum value: `1`

### `raft-log-gc-count-limit`

+ The hard limit on the allowable number of residual Raft logs
+ Default value: the log number that can be accommodated in the 3/4 Region size (calculated as 1MB for each log)
+ Minimum value: `0`

### `raft-log-gc-size-limit`

+ The hard limit on the allowable size of residual Raft logs
+ Default value: 3/4 of the Region size
+ Minimum value: greater than `0`

### `raft-entry-cache-life-time`

+ The maximum remaining time allowed for the log cache in memory.
+ Default value: `30s`
+ Minimum value: `0`

### `raft-reject-transfer-leader-duration`

+ The protection time for new nodes, which is used to control the shortest interval to migrate a leader to the newly added node. Setting this value too small might cause the failure of leader transfer.
+ Default value: `3s`
+ Minimum value: `0`

### `raftstore.hibernate-regions` (**Experimental**)

+ Enables or disables Hibernate Region. When this option is enabled, a Region idle for a long time is automatically set as hibernated. This reduces the extra overhead caused by heartbeat messages between the Raft leader and the followers for idle Regions. You can use `raftstore.peer-stale-state-check-interval` to modify the heartbeat interval between the leader and the followers of hibernated Regions.
+ Default value: false

### `raftstore.peer-stale-state-check-interval`

+ Modifies the state check interval for Regions.
+ Default value: 5 min

### `split-region-check-tick-interval`

+ Specifies the interval at which to check whether the Region split is needed. `0` means that this feature is disabled.
+ Default value: `10s`
+ Minimum value: `0`

### `region-split-check-diff`

+ The maximum value by which the Region data is allowed to exceed before Region split
+ Default value: 1/16 of the Region size.
+ Minimum value: `0`

### `region-compact-check-interval`

+ The time interval at which to check whether it is necessary to manually trigger RocksDB compaction. `0` means that this feature is disabled.
+ Default value: `5m`
+ Minimum value: `0`

### `clean-stale-peer-delay`

+ Delays the time in deleting expired replica data
+ Default value: `10m`
+ Minimum value: `0`

### `region-compact-check-step`

+ The number of Regions checked at one time for each round of manual compaction
+ Default value: `100`
+ Minimum value: `0`

### `region-compact-min-tombstones`

+ The number of tombstones required to trigger RocksDB compaction
+ Default value: `10000`
+ Minimum value: `0`

### `region-compact-tombstones-percent`

+ The proportion of tombstone required to trigger RocksDB compaction
+ Default value: `30`
+ Minimum value: `1`
+ Maximum value: `100`

### `pd-heartbeat-tick-interval`

+ The time interval at which a Region's heartbeat to PD is triggered. `0` means that this feature is disabled.
+ Default value: `1m`
+ Minimum value: `0`

### `pd-store-heartbeat-tick-interval`

+ The time interval at which a store's heartbeat to PD is triggered. `0` means that this feature is disabled.
+ Default value: `10s`
+ Minimum value: `0`

### `snap-mgr-gc-tick-interval`

+ The time interval at which the recycle of expired snapshot files is triggered. `0` means that this feature is disabled.
+ Default value: `5s`
+ Minimum value: `0`

### `snap-gc-timeout`

+ The longest time for which a snapshot file is saved
+ Default value: `4h`
+ Minimum value: `0`

### `lock-cf-compact-interval`

+ The time interval at which TiKV triggers a manual compaction for the Lock Column Family
+ Default value: `256MB`
+ Default value: `10m`
+ Minimum value: `0`

### `lock-cf-compact-bytes-threshold`

+ The size out of which TiKV triggers a manual compaction for the Lock Column Family
+ Default value: `256MB`
+ Minimum value: `0`
+ Unit: MB

### `notify-capacity`

+ The longest length of the Region message queue.
+ Default value: `40960`
+ Minimum value: `0`

### `messages-per-tick`

+ The maximum number of messages processed per batch
+ Default value: `4096`
+ Minimum value: `0`

### `max-peer-down-duration`

+ The longest inactive duration allowed for a peer. A peer with timeout is marked as `down`, and PD tries to delete it later.
+ Default value: `5m`
+ Minimum value: `0`

### `max-leader-missing-duration`

+ The longest duration allowed for a peer to be in the state where a Raft group is missing the leader. If this value is exceeded, the peer verifies with PD whether the peer has been deleted.
+ Default value: `2h`
+ Minimum value: greater than `abnormal-leader-missing-duration`

### `abnormal-leader-missing-duration`

+ The longest duration allowed for a peer to be in the state where a Raft group is missing the leader. If this value is exceeded, the peer is seen as abnormal and marked in metrics and logs.
+ Default value: `10m`
+ Minimum value: greater than `peer-stale-state-check-interval`

### `peer-stale-state-check-interval`

+ The time interval to trigger the check for whether a peer is in the state where a Raft group is missing the leader.
+ Default value: `5m`
+ Minimum value: greater than `2 * election-timeout`

### `leader-transfer-max-log-lag`

+ The maximum number of missing logs allowed for the transferee during a Raft leader transfer
+ Default value: `10`
+ Minimum value: `10`

### `snap-apply-batch-size`

+ The memory cache size required when the imported snapshot file is written into the disk
+ Default value: `10MB`
+ Minimum value: `0`
+ Unit: MB

### `consistency-check-interval`

+ The time interval at which the consistency check is triggered. `0` means that this feature is disabled.
+ Default value: `0s`
+ Minimum value: `0`

### `raft-store-max-leader-lease`

+ The longest trusted period of a Raft leader
+ Default value: `9s`
+ Minimum value: `0`

### `allow-remove-leader`

+ Determines whether to allow deleting the main switch
+ Default value: `false`

### `merge-max-log-gap`

+ The maximum number of missing logs allowed when `merge` is performed
+ Default value: `10`
+ Minimum value: greater than `raft-log-gc-count-limit`

### `merge-check-tick-interval`

+ The time interval at which TiKV checks whether a Region needs merge
+ Default value: `10s`
+ Minimum value: greater than `0`

### `use-delete-range`

+ Determines whether to delete data from the `rocksdb delete_range` interface
+ Default value: `false`

### `cleanup-import-sst-interval`

+ The time interval at which the expired SST file is checked. `0` means that this feature is disabled.
+ Default value: `10m`
+ Minimum value: `0`

### `local-read-batch-size`

+ The maximum number of read requests processed in one batch
+ Default value: `1024`
+ Minimum value: greater than `0`

### `apply-max-batch-size`

+ The maximum number of requests for data flushing in one batch
+ Default value: `1024`
+ Minimum value: greater than `0`

### `apply-pool-size`

+ The allowable number of threads in the pool that flushes data to storage
+ Default value: `2`
+ Minimum value: greater than `0`

### `store-max-batch-size`

+ The maximum number of requests processed in one batch
+ Default value: `1024`
+ Minimum value: greater than `0`

### `store-pool-size`

+ The allowable number of threads that process Raft
+ Default value: `2`
+ Minimum value: greater than `0`

### `future-poll-size`

+ The allowable number of threads that drive `future`
+ Default value: `1`
+ Minimum value: greater than `0`
