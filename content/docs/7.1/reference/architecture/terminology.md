---
title: Terminologies
description: Explain TiKV and PD terminologies.
menu:
    "7.1":
        parent: Architecture-7.1
        weight: 4
        identifier: Terminologies-7.1
---

This document explains some important terminologies of TiKV and PD.

## Node

A TiKV **Node** is a physical node in the cluster, which might be a virtual machine, a container, etc. Within each Node, there can be one or more stores.

The Node, Store, and Region regularly report their status to the Placement Driver.

## Placement Driver (PD)

The Placement Driver (PD) is the cluster manager of TiKV. It periodically records the cluster information, makes decisions to move/split/merge TiKV Regions across nodes according to the application workload and storage capacities. This process is called **scheduling**.

## Peer

A replica of a Region is called a peer. Multiple peers of the same Region replicate data via the Raft consensus algorithm.

## Raft

Data is distributed across TiKV instances via the [Raft consensus algorithm](https://raft.github.io/), which is based on the [Raft paper](https://raft.github.io/raft.pdf) ("In Search of an Understandable Consensus Algorithm") from [Diego Ongaro](https://ongardie.net/diego/) and [John Ousterhout](https://web.stanford.edu/~ouster/cgi-bin/home.php).

## Region

TiKV shards continuous ranges of keys into **Regions**, and replicates **Regions** via the Raft protocol. When data size increases until a threshold is reached, a Region will be split into multiple ones. Conversely, if the size of the Region shrinks due to data deletion, two adjacent Regions can be merged into one.

## Store

A **Store** is an instance of a TiKV server in which multiple peers are stored.

## Transaction

TiKV provides transactions that allow you to read and write across any keys with **Snapshot Isolation** regardless of the physical placement of the Region. TiKV also provides the pessimistic transactions that are semantically similar to `SELECT ... FOR UPDATE` in SQL.

The underlying transaction model is similar to Google's [Percolator](https://ai.google/research/pubs/pub36726), a system built for processing updates to large data sets.
