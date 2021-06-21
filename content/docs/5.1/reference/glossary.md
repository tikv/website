---
title: Glossary
description: Glossaries about TiKV.
menu:
    "5.1":
        parent: Reference
        weight: 10
---



## N

### Node

A TiKV **Node** is a physical node in the cluster, which could be a virtual machine, a container, etc. Within each Node, there can be one or more stores.

The status for the Node, Store, and Region will be regularly reported to the Placement Driver.

## P

### Placement driver (PD)

The TiKV placement driver is the cluster manager of TiKV, which periodically and automatically balances workload and data storage across nodes by moving Regions. This process is called **auto-sharding**.

### Peer

A replica of a Region is called a peer. Multiple peers of the same Region replicate data via the Raft consensus algorithm.

## R

### Raft

Data is distributed across TiKV instances via the [Raft consensus algorithm](https://raft.github.io/), which is based on the so-called [Raft paper](https://raft.github.io/raft.pdf) ("In Search of an Understandable Consensus Algorithm") from [Diego Ongaro](https://ongardie.net/diego/) and [John Ousterhout](https://web.stanford.edu/~ouster/cgi-bin/home.php).

### Region

TiKV shards continuous ranges of keys into **Regions**, and replicates **Regions** via the Raft protocol. When data size increases until reaching a threshold, a Region will be split into multiple. Conversely, if the size of the Region shrinks due to data deletion, two adjacent Regions can be merged into one.

## S

### Store

A **Store** is an instance of a TiKV server in which multiple peers are stored.

## T

### Transaction

TiKV provides transactions that allow you to read and write across any keys with **Snapshot Isolation** regardless of the physical placement of the Region. TiKV also provides the pessimistic transactions that are semantically analogous to `SELECT ... FOR UPDATE` in SQL.

The underlying transaction model is similar to Google's [Percolator](https://ai.google/research/pubs/pub36726), a system built for processing updates to large data sets.