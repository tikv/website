---
title: Features
description: The features of TiKV
menu:
    "5.1":
        parent: Get Started
        weight: 2
---

| Feature                                                 | Description                                                                                                                                                                                             |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Replication and rebalancing](../replication-and-rebalancing)             | With the [Placement Driver](/docs/3.0/concepts/architecture#placement-driver) and carefully designed Raft groups, TiKV excels in horizontal scalability and can easily scale to 100+ terabytes of data. |
| [Fault tolerance and auto-recovery](../fault-tolerance) | TiKV achieves fault tolerance through replicating data to multiple nodes via the Raft consensus algorithm.                                                                                              |
| [TTL (Time to Live) on RawKV](../ttl)                   | RawKV supports TTL, which means expired Key-Value pairs will be cleared automatically.                                                                                                                  |
| [CAS (Compare And Swap) on RawKV](../cas)               | RawKV supports compare-and-swap operation, which is an atomic instruction used in multi-threading to achieve synchronization.                                                                          | 
| [Distributed Transaction](../distributed-dransaction)   | Similar to Google's [Spanner](https://ai.google/research/pubs/pub39966), TiKV supports externally consistent distributed transactions.                                                                  |
