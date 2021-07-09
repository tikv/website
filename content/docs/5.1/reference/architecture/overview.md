---
title: Overview
description: Core concepts and architecture behind TiKV.
menu:
    "5.1":
        parent: Architecture
        weight: 1
---

This page provides an overview of the TiKV architecture.

## System architecture

The overall architecture of TiKV is as follows:

{{< figure
    src="/img/tikv-architecture.png"
    caption="The architecture of TiKV"
    alt="TiKV architecture diagram" >}}

A TiKV cluster consists of the following components:

- [A group of TiKV nodes](./#tikv-cluster) storing key-value pair data
- [A Placement Driver (PD) node](./#pd-cluster) working as the manager of the TiKV cluster

TiKV clients interact with PD and TiKV through gRPC.

## TiKV

TiKV stores data in RocksDB, which is a persistent and fast key-value store. To learn why TiKV selects RocksDB to store data, see [RocksDB](/deep-dive/key-value-engine/rocksdb/).

Implementing the [Raft](/deep-dive/consensus-algorithm/raft/) consensus algorithm, TiKV works as follows:

- TiKV replicates data to multiple machines, ensures data consistency, and tolerates machine failures.
- TiKV data is written through the interface of Raft instead of directly to RocksDB.
- TiKV becomes a distributed Key-Value storage, which can automatically recover lost replicas in case of machine failures and keep the applications unaffected.

Based on the Raft layer, TiKV provides two APIs that clients can interact with:

| API           | Description                                                                           | Atomicity     | Use when...                                                                   |
|:------------- |:------------------------------------------------------------------------------------- |:------------- |:----------------------------------------------------------------------------- |
| Raw           | A lower-level key-value API to interact directly with individual key-value pairs | Single key    | Your application requires low latency and do not involve multi-key transactions. |
| Transactional | A higher-level key-value API to provide snapshot isolation transaction           | Multiple keys | Your application requires distributed transactions.                           |

## PD

As the manager in a TiKV cluster, the Placement Driver ([PD](https://github.com/tikv/pd)) provides the following functions:

- [Timestamp oracle](/deep-dive/distributed-transaction/timestamp-oracle/)

   Timestamp oracle plays a significant role in the Percolator transaction model. PD implements a service to hand out timestamps in the strictly increasing order, which is a property required for the correct operations of the snapshot isolation protocol.

- Region scheduler

    Data in TiKV is organized as Regions, which are replicated to several stores. PD, as the Region scheduler, decides the storage location of each replica.
