---
title: TiKV Clients
description: Interact with TiKV using the raw key-value API or the transactional key-value API.
menu:
    "dev":
        parent: Develop-dev
        weight: 1
        identifier: TiKV Clients-dev
---

TiKV offers two APIs that you can interact with:

| API           | Description                                                                      | Atomicity     | Usage scenarios                                                                      |
|:------------- |:-------------------------------------------------------------------------------- |:------------- |:------------------------------------------------------------------------------------ |
| Raw           | A lower-level key-value API to interact directly with individual key-value pairs | Single key    | Your application requires low latency and does not involve distributed transactions. |
| Transactional | A higher-level key-value API to provide ACID semantics.                          | Multiple keys | Your application requires distributed transactions.                                  |

{{< warning >}}
To use both the raw and transactional APIs in the same cluster, please enable [API V2](../../../concepts/explore-tikv-features/api-v2).
{{< /warning >}}

TiKV provides the following clients developed in different programming languages:

| Clients                    | RawKV API         | TxnKV API         | Supported TiKV Version |
| -------------------------- | ----------------- | ----------------- | ---------------------- |
| [Java Client](../java)     | (Stable) Has been used in the production environment of some commercial customers in latency sensitive systems. | (Stable) Has been used in the [TiSpark] and [TiBigData] project to integrate data from TiDB to Big Data ecosystem. [TiSpark] and [TiBigData] are used in the production system of some commercial customers and internet companies. | >= 2.0.0               |
| [Go Client](../go)         | (Stable) Has been used in the production environment of some internet commercial customers, to access TiKV as feature store and other scenarios. | (Stable) Has been used as one of the fundamental library of TiDB. Has been used in production environment of some internet commercial customers to access TiKV as metadata store and other scenarios. | >= 5.0.0               |
| [Rust Client](../rust)     | (Unstable)        | (Unstable)        | >= 5.0.0               |
| [Python Client](../python) | (Unstable)        | (Unstable)        | >= 5.0.0               |
| [C++ Client](../cpp)       | (Unstable)        | (Unstable)        | >= 5.0.0               |

[TiSpark]: https://github.com/pingcap/tispark
[TiBigData]: https://github.com/tidb-incubator/TiBigData
