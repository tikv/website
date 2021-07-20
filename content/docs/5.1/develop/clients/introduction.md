---
title: TiKV Clients
description: Interact with TiKV using the raw key-value API or the transactional key-value API.
menu:
    "5.1":
        parent: Develop
        weight: 1
---

TiKV offers two APIs that you can interact with:

| API           | Description                                                                           | Atomicity     | Usage scenarios                                                                      |
|:------------- |:------------------------------------------------------------------------------------- |:------------- |:-------------------------------------------------------------------------------- |
| Raw           | A lower-level key-value API to interact directly with individual key-value pairs  | Single key    | Your application requires low latency and does not involve distributed transactions. |
| Transactional | A higher-level key-value API to provide ACID semantics.                            | Multiple keys | Your application requires distributed transactions.                              |

{{< warning >}}
It is **not supported** to use both the raw and transactional APIs on the same keyspace.
{{< /warning >}}

TiKV provides the following clients developed in different programming languages:

| Clients                    | RawKV API         | TxnKV API         | Supported TiKV Version |
| -------------------------- | ----------------- | ----------------- | ---------------------- |
| [Java Client](../java)     | Stable            | Under development | >= 2.0.0               |
| [Go Client](../go)      | Unstable          | Unstable          | >= 5.0.0               |
| [Rust Client](../rust)     | Unstable          | Unstable          | >= 5.0.0               |
| [Python Client](../python) | Unstable          | Unstable          | >= 5.0.0               |
| [C++ Client](../cpp)       | Unstable          | Unstable          | >= 5.0.0               |
