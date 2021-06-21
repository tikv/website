---
title: Overview
description: Core concepts and architecture behind TiKV.
menu:
    "5.1":
        parent: Architecture
        weight: 1
---

This page walks you through the overview of TiKV architecture.

## System architecture

The overall architecture of TiKV is illustrated below:

{{< figure
    src="/img/tikv-architecture.png"
    caption="The architecture of TiKV"
    alt="TiKV architecture diagram" >}}

A TiKV cluster consists of 2 components:

1. [A TiKV Cluster](./#tikv-cluster), which is responsible for storing key-value pair data.
2. [A Placement Driver (PD) Cluster](./#pd-cluster), which works as the manager in a TiKV cluster.

TiKV Clients interact with PD and TiKV through gRPC.

## TiKV Cluster

TiKV stores data in RocksDB, which is a persistent key-value store for fast storage environment. This [article](/deep-dive/key-value-engine/rocksdb/) explains why RocksDB is selected.

TiKV replicates data to multiple machines via [Raft](/deep-dive/consensus-algorithm/raft/) in case of machine failure. Data is written through the interface of Raft instead of to RocksDB. With the implementation of Raft, TiKV becomes a distributed Key-Value storage. Even with a few machine failures, TiKV can automatically complete replicas by virtue of the native Raft protocol, which does not impact the application.

Based on the Raft layer, TiKV provides two APIs that clients can use to interact with it:

| API           | Description                                                                           | Atomicity     | Use when...                                                                   |
|:------------- |:------------------------------------------------------------------------------------- |:------------- |:----------------------------------------------------------------------------- |
| Raw           | A lower-level key-value API for interacting directly with individual key-value pairs. | Single key    | Your application requires low latency and doesn't use multi-key transactions. |
| Transactional | A higher-level key-value API that provides snapshot isolation transaction.            | Multiple keys | Your application requires distributed transactions.                           |

## PD Cluster

As the manager in a TiKV cluster, the Placement Driver ([PD](https://github.com/tikv/pd)) provides two major functions: [Timestamp Oracle](./#timestamp-oracle) and [Region Scheduler](./#region-scheduler).

### Timestamp Oracle

[Timestamp oracle](/deep-dive/distributed-transaction/timestamp-oracle/) plays a significant role in the Percolator Transaction model. PD implements such a service that hands out timestamps in strictly increasing order, which is a property required for the correct operation of the snapshot isolation protocol.

### Region Scheduler

Data in TiKV is organized as Regions, which are replicated on several stores. Someone needs to be responsible for deciding the storage location of each replica, which is the second job of PD.
