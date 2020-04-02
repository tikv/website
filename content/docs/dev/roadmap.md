---
title: TiKV RoadMap
description: Roadmap to TiKV 4.0 and beyond
menu:
    "dev":
        weight: 4
---

This document describes the roadmap for TiKV development. As an open source project, TiKV is developed by a community of contributors and adopted by many of them in production. That's where most of the goals on the roadmap come from. Currently, the 4.0 goals are being actively implemented. However, there is no guarantee that the medium-term goals will be implemented in any specific order.

Let us know on [Slack](https://tikv-wg.slack.com/join/shared_invite/enQtNTUyODE4ODU2MzI0LWVlMWMzMDkyNWE5ZjY1ODAzMWUwZGVhNGNhYTc3MzJhYWE0Y2FjYjliYzY1OWJlYTc4OWVjZWM1NDkwN2QxNDE) if you have any questions regarding the roadmap.

## TiKV 4.0 goals

### Features

- [ ] Support up to 200+ nodes in a cluster
- [ ] Fast full backup and restoration
- [ ] Dynamically split and merge hot spot Regions
- [ ] Fine-grained memory control
- [ ] Raft
    + Joint Consensus
    + Read-only Replicas

### Performance

- [ ]Improve scan performance
- [ ]Dynamically increase the number of worker threads
- [ ]Flexibly increase read-only replicas
- [ ]Optimize the scheduling system to prevent QPS jitter

### Usability

- [ ] Refactor log content

### Features

- [ ] Fast incremental backup and restoration
- [ ] Flashback to any point-in-time
- [ ] Hierarchical storage
- [ ] Fine-grained QoS control
- [ ] Configure the number of replicas and distribution strategy by Regions
- [ ] Raft
    + Chain replication of data
    + Witness role
- [ ] Storage engine
    + Support splitting SSTables according to Guards During compaction in RocksDB
    + Separate cold and hot data

### Performance

- [ ] Improve fast backup performance
- [ ] Improve fast restoration performance
- [ ] 1PC
- [ ] Support storage class memory hardware
- [ ] New Raft engine
