---
title: Features
description: The features of TiKV
menu:
    "5.1":
        parent: Get Started
        weight: 2
---

TiKV offers the following key features:

| Feature                                                 | Description                                                                                                                                                                                             |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Replication and rebalancing](../replication-and-rebalancing)             | With the [Placement Driver](/docs/3.0/concepts/architecture#placement-driver) and carefully designed Raft groups, TiKV excels in horizontal scalability and can easily scale to over 100 terabytes of data. |
| [Fault tolerance and auto-recovery](../fault-tolerance) | TiKV applies the Raft consensus algorithm to replicate data to multiple nodes, thus achieving fault tolerance.                                                                                              |
| [TTL (Time to Live) on RawKV](../ttl)                   | RawKV supports TTL to automatically clear expired Key-Value pairs.                                                                                                                  |
| [CAS (Compare And Swap) on RawKV](../cas)               | RawKV supports the compare-and-swap operation to achieve synchronization in multi-threading.                                                                          |
| [Distributed Transaction](../distributed-dransaction)   | Similar to [Google Spanner](https://ai.google/research/pubs/pub39966), TiKV supports externally consistent distributed transactions.                                                                  |