---
title: Overview
description: Core concepts and architecture behind TiKV.
menu:
    "5.1":
        parent: Architecture
        weight: 1
---

This page discusses the core concepts and architecture behind TiKV, including:

* The [APIs](#apis) that applications can use to interact with TiKV
* The basic [system architecture](#system) underlying TiKV
* The anatomy of each [instance](#instance) in a TiKV installation
* TiKV's terminology including [Placement Driver](#placement-driver), [Store](#store), [Region](#region), and [Node](#node)
* TiKV's [transaction model](#transactions)
* The role of the [Raft consensus algorithm](#raft) in TiKV
* The [origins](#origins) of TiKV

## APIs

TiKV provides two APIs that you can use to interact with it:

| API           | Description                                                                           | Atomicity     | Use when...                                                                   |
|:------------- |:------------------------------------------------------------------------------------- |:------------- |:----------------------------------------------------------------------------- |
| Raw           | A lower-level key-value API for interacting directly with individual key-value pairs. | Single key    | Your application requires low latency and doesn't use multi-key transactions. |
| Transactional | A higher-level key-value API that provides snapshot isolation transaction.            | Multiple keys | Your application requires distributed transactions.                           |

## System architecture

The overall architecture of TiKV is illustrated below:

{{< figure
    src="/img/basic-architecture.png"
    caption="The architecture of TiKV"
    alt="TiKV architecture diagram"
    width="70" >}}

## TiKV instance

The architecture of each TiKV instance is illustrated below:

{{< figure
    src="/img/tikv-instance.png"
    caption="TiKV instance architecture"
    alt="TiKV instance architecture diagram"
    width="60" >}}


## Placement driver (PD)

The TiKV placement driver is the cluster manager of TiKV, which periodically and automatically balances workload and data storage across nodes by moving Regions. This process is called **auto-sharding**.

## Store

A **Store** refers to the storage node in the TiKV cluster (an instance of tikv-server). Each store has a corresponding TiKV instance.

## Region

TiKV shards continuous ranges of keys into **Regions**, and replicates **Regions** via the Raft protocol. When data size increases until reaching a threshold, a Region will be split into multiple. Conversely, if the size of the Region shrinks due to data deletion, two adjacent Regions can be merged into one.

## Peer

A replica of a Region is called a peer. Multiple peers of the same Region replicate data via the Raft consensus algorithm, so peers are also members of a Raft instance.

## Node

A TiKV **Store** is a physical node in the cluster, which could be a virtual machine, a container, etc. Within each Node, there can be one or more stores.

The status for the Node, Store, and Region will be regularly reported to the Placement Driver.

## Transaction

TiKV provides transactions that allow you to read and write across any keys with **Snapshot Isolation** regardless of the physical placement of the Region. TiKV also provides the pessimistic transactions that are semantically analogous to `SELECT ... FOR UPDATE` in SQL.

The underlying transaction model is similar to Google's [Percolator](https://ai.google/research/pubs/pub36726), a system built for processing updates to large data sets.

## Raft

Data is distributed across TiKV instances via the [Raft consensus algorithm](https://raft.github.io/), which is based on the so-called [Raft paper](https://raft.github.io/raft.pdf) ("In Search of an Understandable Consensus Algorithm") from [Diego Ongaro](https://ongardie.net/diego/) and [John Ousterhout](https://web.stanford.edu/~ouster/cgi-bin/home.php).

## The origins of TiKV

TiKV was originally created by [PingCAP](https://pingcap.com) to complement [TiDB](https://github.com/pingcap/tidb), a distributed [HTAP](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing_(HTAP)) database compatible with the [MySQL protocol](https://dev.mysql.com/doc/dev/mysql-server/latest/PAGE_PROTOCOL.html).
