---
title: TiKV RoadMap
description: Roadmap to TiKV 3.0
menu:
    "3.0":
        weight: 4
---

This document describes the roadmap for TiKV development. As an open source project, TiKV is developed by a community of contributors and adopted by many of them in production. That's where most of the goals on the roadmap come from.

Let us know on [Slack](https://tikv-wg.slack.com/join/shared_invite/enQtNTUyODE4ODU2MzI0LWVlMWMzMDkyNWE5ZjY1ODAzMWUwZGVhNGNhYTc3MzJhYWE0Y2FjYjliYzY1OWJlYTc4OWVjZWM1NDkwN2QxNDE) if you have any questions regarding the roadmap.

## TiKV 3.0 goals

+ Raft
    - [x] Region Merge - Merge small Regions together to reduce overhead
    - [x] Local Read Thread - Process read requests in a local read thread
    - [x] Split Region in Batch - Speed up Region split for large Regions
    - [x] Raft Learner - Support Raft learner to smooth the configuration change process
    - [x] Raft Pre-vote - Support Raft pre-vote to avoid unnecessary leader election on network isolation
    - [ ] Joint Consensus - Change multi members safely.
    - [ ] Multi-thread Raftstore - Process Region Raft logic in multiple threads
    - [ ] Multi-thread apply pool - Apply Region Raft committed entries in multiple threads
+ Engine
    - [ ] Titan - Separate large key-values from LSM-Tree
    - [ ] Pluggable Engine Interface - Clean up the engine wrapper code and provide more extensibility
+ Storage
    - [ ] Flow Control - Do flow control in scheduler to avoid write stall in advance
+ Transaction
    - [x] Optimize transaction conflicts
    - [ ] Distributed GC - Distribute MVCC garbage collection control to TiKV
+ Coprocessor
    - [x] Streaming - Cut large data set into small chunks to optimize memory consumption
    - [ ] Chunk Execution - Process data in chunk to improve performance
    - [ ] Request Tracing - Provide per-request execution details
+ Tools
    - [x] TiKV Importer - Speed up data importing by SST file ingestion
+ Client
    - [ ] TiKV client (Rust crate)
    - [ ] Batch gRPC Message - Reduce message overhead

## PD

- [x] Improve namespace
    - [x] Different replication policies for different namespaces and tables
- [x] Decentralize scheduling table Regions
- [x] Scheduler supports prioritization to be more controllable
- [ ] Use machine learning to optimize scheduling
- [ ] Optimize Region metadata - Save Region metadata in detached storage engine
