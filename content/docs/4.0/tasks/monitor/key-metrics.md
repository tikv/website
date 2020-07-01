---
title: Key Metrics
description: Learn some key metrics displayed on the Grafana Overview dashboard.
menu:
    "4.0":
        parent: Monitor
        weight: 2
---

If your TiKV cluster is deployed using Ansible or Docker Compose, the monitoring system is deployed at the same time. For more details, see [Overview of the TiKV Monitoring Framework](https://pingcap.com/docs/stable/reference/key-monitoring-metrics/overview-dashboard/).

The Grafana dashboard is divided into a series of sub-dashboards which include Overview, PD, TiKV, and so on. You can use various metrics to help you diagnose the cluster.

But you can also deploy your own Grafana server to monitor the TiKV cluster, especially when you are going to use TiKV without TiDB. This document provides a detailed description of key metrics so that you can monitor the Prometheus metrics you are interested in.

## Key metrics description

To understand the key metrics, check the following table:

Service | Metric Name | Description | Normal Range
---- | ---------------- | ---------------------------------- | --------------
Cluster | tikv_store_size_bytes | The size of storage. The metric has a `type` label (eg: "capacity", "available"). |
gRPC | tikv_grpc_msg_duration_seconds | Bucketed histogram of gRPC server messages. The metric has a `type` label which represents the type of the server message. You can count the metric and calculate the QPS. |
gRPC | tikv_grpc_msg_fail_total | The total number of gRPC message handling failure. The metric has a `type` label which represents gRPC message type. |
gRPC | grpc batch size of gRPC requests | grpc batch size of gRPC requests. |
Scheduler | tikv_scheduler_too_busy_total | The total count of too busy schedulers. The metric has a `type` label which represents the scheduler type. |
Scheduler | tikv_scheduler_contex_total | The total number of pending commands. The scheduler receives commands from clients, executes them against the MVCC layer storage engine. |
Scheduler | tikv_scheduler_stage_total | Total number of commands on each stage. The metric has two labels: `type` and `stage`. `stage` represents the stage of executed commands like "read_finish", "async_snapshot_err", "snapshot", etc. |
Scheduler | tikv_scheduler_commands_pri_total | Total count of different priority commands. The metric has a `priority` label. |
Server | tikv_server_grpc_resp_batch_size | grpc batch size of gRPC responses. |
Server | tikv_server_report_failure_msg_total | Total number of reporting failure messages. The metric has two labels: `type` and `store_id`. `type` represents the failure type, and `store_id` represents the destination peer store id. |
Server | tikv_server_raft_message_flush_total | Total number of raft messages flushed immediately. |
Server | tikv_server_raft_message_recv_total | Total number of raft messages received. |
Server | tikv_region_written_keys | Histogram of written keys for regions. |
Server | tikv_server_send_snapshot_duration_seconds | Bucketed histogram of duration in which the server sends snapshots. |
Server | tikv_region_written_bytes | Histogram of bytes written for regions. |
Raft | tikv_raftstore_leader_missing | Total number of leader missed regions. |
Raft | tikv_raftstore_region_count | The number of regions collected in each TiKV node. The label `type` has `region` and `leader`. `region` represents regions collected, and `leader` represents the number of leaders in each TiKV node. |
Raft | tikv_raftstore_region_size | Bucketed histogram of approximate region size. |
Raft | tikv_raftstore_apply_log_duration_seconds | Bucketed histogram of the duration in which each peer applies log. |
Raft | tikv_raftstore_commit_log_duration_seconds | Bucketed histogram of the duration in which each peer commits logs. |
Raft | tikv_raftstore_raft_ready_handled_total | Total number of Raft ready handled. The metric has a label `type`. |
Raft | tikv_raftstore_raft_process_duration_secs | Bucketed histogram of duration in which each peer processes Raft. The metric has a label `type`. |
Raft | tikv_raftstore_event_duration | Duration of raft store events. The metric has a label `type`. |
Raft | tikv_raftstore_raft_sent_message_total | Total number of messages sent by Raft ready. The metric has a label `type`. |
Raft | tikv_raftstore_raft_dropped_message_total | Total number of messages dropped by Raft. The metric has a label `type`. |
Raft | tikv_raftstore_apply_proposal | The count of proposals sent by a region at once. |
Raft | tikv_raftstore_proposal_total | Total number of proposals made. The metric has a label `type`. |
Raft | tikv_raftstore_request_wait_time_duration_secs | Bucketed histogram of request wait time duration. |
Raft | tikv_raftstore_propose_log_size | Bucketed histogram of the size of each peer proposing log. |
Raft | tikv_raftstore_apply_wait_time_duration_secs | Bucketed histogram of apply task wait time duration. |
Raft | tikv_raftstore_admin_cmd_total | Total number of admin command processed. The metric has 2 labels `type` and `status`. |
Raft | tikv_raftstore_check_split_total | Total number of raftstore split check. The metric has a label `type`. |
Raft | tikv_raftstore_check_split_duration_seconds | Bucketed histogram of duration for the raftstore split check. |
Raft | tikv_raftstore_local_read_reject_total | Total number of rejections from the local reader. The metric has a label `reason` which represents the rejection reason. |
Raft | tikv_raftstore_snapshot_duration_seconds | Bucketed histogram of raftstore snapshot process duration. The metric has a label `type`. |
Raft | tikv_raftstore_snapshot_traffic_total | The total amount of raftstore snapshot traffic. The metric has a label `type`. |
Raft | tikv_raftstore_local_read_executed_requests | Total number of requests directly executed by local reader. |
Coprocessor | tikv_coprocessor_request_duration_seconds | Bucketed histogram of coprocessor request duration. The metric has a label `req`. |
Coprocessor | tikv_coprocessor_request_error | Total number of push down request error. The metric has a label `reason`. |
Coprocessor | tikv_coprocessor_scan_keys | Bucketed histogram of scan keys observed per request. The metric has a label `req` which represents the tag of requests. |
Coprocessor | tikv_coprocessor_rocksdb_perf | Total number of RocksDB internal operations from PerfContext. The metric has 2 labels `req` and `metric`. `req` represents the tag of requests and `metric` is performance metric like "block_cache_hit_count", "block_read_count", "encrypt_data_nanos", etc. |
Coprocessor | tikv_coprocessor_executor_count | The number of various query operations. The metric has a single label `type` which represents the related query operation (e.g., "limit", "top_n", and "batch_table_scan"). | 
Coprocessor | tikv_coprocessor_response_bytes | Total bytes of response body. |
Storage | tikv_storage_mvcc_versions | Histogram of versions for each key. |
Storage | tikv_storage_mvcc_gc_delete_versions | Histogram of versions deleted by GC for each key. |
Storage | tikv_storage_mvcc_conflict_counter | Total number of conflict error. The metric has a label `type`. |
Storage | tikv_storage_mvcc_duplicate_cmd_counter | Total number of duplicated commands. The metric has a label `type`. |
Storage | tikv_storage_mvcc_check_txn_status | Counter of different results of `check_txn_status`. The metric has a label `type`. |
Storage | tikv_storage_command_total | Total number of commands received. The metric has a label `type`. |
Storage | tikv_storage_engine_async_request_duration_seconds | Bucketed histogram of processing successful asynchronous requests. The metric has a label `type`. |
Storage | tikv_storage_engine_async_request_total | Total number of engine asynchronous requests. The metric has 2 labels `type` and `status`. |
GC | tikv_gcworker_gc_task_fail_vec | Counter of failed GC tasks. The metric has a label `task`. |
GC | tikv_gcworker_gc_task_duration_vec | Duration of GC tasks execution. The metric has a label `task`. |
GC | tikv_gcworker_gc_keys | Counter of keys affected during GC. The metric has two labels `cf` and `tag`. |
GC | tikv_gcworker_autogc_processed_regions | Processed regions by auto GC. The metric has a label `type`. |
GC | tikv_gcworker_autogc_safe_point | Safe point used for auto GC. The metric has a label `type`. |
Snapshot | tikv_snapshot_size | Size of snapshot. |
Snapshot | tikv_snapshot_kv_count | Total number of KVs in the snapshot |
Snapshot | tikv_worker_handled_task_total | Total number of tasks handled by the worker. The metric has a label `name`. |
Snapshot | tikv_worker_pending_task_total | The number of tasks currently running by the worker or pending. The metric has a label `name`.|
Snapshot | tikv_futurepool_handled_task_total | The total number of tasks handled by `future_pool`. The metric has a label `name`. |
Snapshot | tikv_snapshot_ingest_sst_duration_seconds | Bucketed histogram of RocksDB ingestion durations |
Snapshot | tikv_futurepool_pending_task_total | Current future_pool pending + running tasks. The metric has a label `name`. |
RocksDB | tikv_engine_get_served | queries served by engine. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_write_stall | Histogram of write stall. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_size_bytes | Sizes of each column families. The metric has two labels: `db` and `type`. `db` represents which database is being counted (e.g., "kv", "raft"), and `type` represents the type of column families (e.g., "default", "lock", "raft", "write"). |
RocksDB | tikv_engine_flow_bytes | Bytes and keys of read/write. The metric has `type` label (eg: "capacity", "available"). |
RocksDB | tikv_engine_wal_file_synced | The number of times WAL sync is done. The metric has a label `db`. |
RocksDB | tikv_engine_get_micro_seconds | Histogram of time used to get micros. The metric has two labels: `db` and `type`. |
RocksDB | tikv_engine_locate | The number of calls to seek/next/prev. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_seek_micro_seconds | Histogram of seek micros. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_write_served | Write queries served by engine. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_write_micro_seconds | Histogram of write micros. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_write_wal_time_micro_seconds | Histogram of duration for write WAL micros. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_event_total | Number of engine events. The metric has 3 labels `db`, `cf` and `type`. |
RocksDB | tikv_engine_wal_file_sync_micro_seconds | Histogram of WAL file sync micros. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_sst_read_micros | Histogram of SST read micros. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_compaction_time | Histogram of compaction time. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_block_cache_size_bytes | Usage of each column families' block cache. The metric has 2 labels `db` and `cf`. |
RocksDB | tikv_engine_compaction_reason | The number of compaction reasons. The metric has 3 labels `db`, `cf` and `reason`.  |
RocksDB | tikv_engine_cache_efficiency | Efficiency of RocksDB's block cache. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_memtable_efficiency | Hit and miss of memtable. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_bloom_efficiency | Efficiency of RocksDB's bloom filter. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_estimate_num_keys | Estimate num keys of each column families. The metric has 2 labels `db` and `cf`. |
RocksDB | tikv_engine_compaction_flow_bytes | Bytes of read/write during compaction |
RocksDB | tikv_engine_bytes_per_read | Histogram of bytes per read. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_read_amp_flow_bytes | Bytes of read amplification. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_bytes_per_write | tikv_engine_bytes_per_write. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_num_snapshots | Number of unreleased snapshots. The metric has a label `db`. |
RocksDB | tikv_engine_pending_compaction_bytes | Pending compaction bytes. The metric has 2 labels `db` and `cf`. |
RocksDB | tikv_engine_num_files_at_level | Number of files at each level. The metric has 3 labels `db`, `cf` and `level`. |
RocksDB | tikv_engine_compression_ratio | Compression ratio at different levels. The metric has 3 labels `db`, `cf` and `level`. |
RocksDB | tikv_engine_oldest_snapshot_duration | Oldest unreleased snapshot duration in seconds. The metric has a label `db`. |
RocksDB | tikv_engine_write_stall_reason | QPS of each reason which causes TiKV write stall. The metric has 2 labels `db` and `type`. |
RocksDB | tikv_engine_memory_bytes | Sizes of each column families. The metric has 3 labels `db`, `cf` and `type`. |
