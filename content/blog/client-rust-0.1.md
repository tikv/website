---
title: TiKV Rust Client - 0.1 release
date: 2021-05-14
author: Nick Cameron
tags: ['Release', 'Announcement']
---

We're pleased to announce the 0.1 release of the [TiKV Rust client](https://crates.io/crates/tikv-client).

[TiKV](https://tikv.org/) is a distributed key-value store. TiKV is powerful, mature, and widely used as part of [TiDB](https://pingcap.com/products/tidb/) (a 'NewSQL' database). It is [open source](https://github.com/tikv/tikv) and written in Rust. However, up until now it has been very difficult to use as a standalone store in a Rust program. With the Rust client, that has changed; it is now easy to access reliable, persistent storage from Rust.

## What is TiKV?

TiKV is a key-value store, like a hashmap but reliably persistent and scalable to terrabytes of data. It runs across multiple nodes for reliability, availability, and scalability - even if you lose some nodes, your data will never be lost and will still be readable and writable; as your data grows, you can simply add more nodes.

TiKV supports transactions, like traditional SQL databases, and is ACID-compliant, i.e., transactions are atomic, isolated (with snapshot isolation), and durable.

The API of TiKV operates of keys and values which are opaque bytes, but it offers a rich selection of operations including scans, operations on ranges, compare and swap, etc. TiKV can operate in transactional or raw modes.

TiKV is open source, Apache licensed, and governed by the [CNCF](https://www.cncf.io/).

## What does the Rust client do?

If TiKV is just like a hashmap (but more powerful) why do we need a client? TiKV usually runs on its own dedicated machines, so at minimum your code needs to communicate with TiKV via the network. You can do this using gRPC, however, the user experience would not be great. TiKV's API is needfully low-level and complicated. For one thing, the transaction protocol is collaborative between TiKV and the client, which means if the client implementation is incorrect then data might be lost or corrupted. Secondly, data in TiKV is sharded between nodes and the shards are actively managed. Therefore, there is significant overhead before the client can even send a message to TiKV.

The TiKV client presents an ergonomic API which hides the complications of interacting with a distributed key-value store. It handles the transaction protocol, including recovering failed transactions, retries due to network failure or re-sharding, caching location and address information, encoding using protobufs, and network communication using gRPC.

The client offers transactional and raw APIs (using `TransactionClient` and `RawClient`, respectively), and if you need to customise things, the client gives you lower level access too.

An example using the client's transactional API:

```rust
let txn_client = TransactionClient::new(vec!["127.0.0.1:2379"]).await?;
let mut txn = txn_client.begin_optimistic().await?;

txn.put("key".to_owned(), "value".to_owned()).await?;
let value = txn.get("key".to_owned()).await?;

txn.commit().await?;
```

Like TiKV, the TiKV Rust client is [open source](https://github.com/tikv/client-rust/) and Apache licensed.

## Getting started with the client

The TiKV client is a Rust library (crate). To use this crate in your project, add the following dependencies to your `Cargo.toml` file:

```toml
[dependencies]
tikv-client = "0.1"
tokio = { version = "1.5", features = ["full"] }
```

Note that you need to use Tokio. The TiKV client has an async API and therefore you need an async runtime in your program to use it. At the moment, Tokio is used internally in the client and so you must use Tokio in your code too. We plan to become more flexible in future versions.

The general flow of using the client crate is to create either a raw or transaction client object (which can be configured), then send commands using the client object, or use it to create transactions objects. In the latter case, the transaction is built up using various commands and then committed (or rolled back).

To make an example which builds and runs:

```rust
use tikv_client::{TransactionClient, Error};

async fn run() -> Result<(), Error> {
    let txn_client = TransactionClient::new(vec!["127.0.0.1:2379"]).await?;
    let mut txn = txn_client.begin_optimistic().await?;

    txn.put("key".to_owned(), "value".to_owned()).await?;
    let value = txn.get("key".to_owned()).await?;
    println!("value: {:?}", value);

    txn.commit().await?;

    Ok(())
}

#[tokio::main]
async fn main() {
    run().await.unwrap();
}
```

To use the client, you'll need a TiKV instance to communicate with. In production, this should be a cluster of dedicated servers which are accessed via the network. To get started, you can run a TiKV 'cluster' on your local machine.

A TiKV cluster consists of TiKV nodes and PD nodes. For normal use, you need at least three of each; there is no maximum. For testing etc., you need at least one TiKV node
and one PD node. For more details, see the [TiKV docs](https://tikv.org/docs/dev/concepts/architecture/).

The easiest way to manage a TiKV cluster (locally or on multiple machines) is to use [TiUP](https://github.com/pingcap/tiup). To install it on your computer, use

```
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
```

then, to start a local TiKV 'cluster' for testing or experimentation,

```
tiup playground nightly --kv-only
```

Then you just need to `cargo run` to run your program using the client.

There is more info in our [docs](https://docs.rs/tikv-client). If you want more help, the best place to go is the #client-rust channel in the [TiKV Slack](https://tikv.org/chat).

## Ongoing development

Today marks the 0.1 release of TiKV's Rust client. As the version number suggests, there is lots more [work to do](https://github.com/tikv/client-rust/pull/290/files), (and the current release is not suitable for use in production). There is good support for all the fundamentals. However, the client is not yet feature-complete, with lots of options, features, and customizations to add to the client. There is also ongoing work to improve reliability, ergonomics, and performance.

The client's API is async-only and requires Tokio. In the future, we'd like to make the client async runtime-independent, and to provide a non-async version of the API.

We would love to hear your feedback to help us improve. And contributions to code, docs, tests, examples, etc are most welcome! Please [file issues](https://github.com/tikv/client-rust/issues/new) on GitHub, and/or get in touch via the #client-rust channel in the [TiKV Slack](https://tikv.org/chat) or in the [TiDB forum](https://internals.tidb.io/c/tikv-client).
