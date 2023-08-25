---
title: Features
description: The features of TiKV
menu:
    "7.1":
        parent: Get Started-7.1
        weight: 2
        identifier: Features-7.1
---

TiKV offers the following key features:

| Feature                                                       | Description                                                                                                                                                                                                 |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Replication and rebalancing](../replication-and-rebalancing) | With the [Placement Driver](/docs/3.0/concepts/architecture#placement-driver) and carefully designed Raft groups, TiKV excels in horizontal scalability and can easily scale to over 100 terabytes of data. |
| [High fault tolerance and auto-recovery](../fault-tolerance)  | TiKV applies the Raft consensus algorithm to replicate data to multiple nodes, thus achieving high fault tolerance.                                                                                         |
| [TTL (Time to Live) on RawKV](../ttl)                         | RawKV supports TTL to automatically clear expired Key-Value pairs.                                                                                                                                          |
| [CAS (Compare-And-Swap) on RawKV](../cas)                     | RawKV supports the compare-and-swap operation to achieve synchronization in multi-threading.                                                                                                                |
| [Distributed Transaction](../distributed-transaction)         | Similar to [Google Spanner](https://ai.google/research/pubs/pub39966), TiKV supports externally consistent distributed transactions.                                                                        |
| [TiKV API V2](../api-v2)                                      | TiKV API v2 provides new storage format to support more features, such as **Changed Data Capture** and **Key Space**.                                                                                        |
| [RawKV BR](../backup-restore)                                 | RawKV supports backup and restoration.                                                                                                                                                                      |
| [RawKV CDC](../cdc/cdc)                                       | RawKV supports Changed Data Capture.                                                                                                                                                                        |