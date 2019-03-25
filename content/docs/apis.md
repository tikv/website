---
title: APIs
description: Interact with TiKV using the raw key-value API or the transactional key-value API
weight: 4
draft: false
---

TiKV offers two APIs that you can interact with:

API | Description | Atomicity | Use when...
:---|:------------|:----------|:-----------
[Raw](#raw) | A lower-level key-value API for interacting directly with individual key-value pairs. | Single key | Your application doesn't require distributed transactions or multi-version concurrency control (MVCC)
[Transactional](#transactional) | A higher-level key-value API that provides ACID semantics | Multiple keys | Your application requires distributed transactions and/or MVCC

{{< info >}}
It is **not recommended or supported** to use both the raw and transactional APIs on the same keyspace.
{{< /info >}}

There are several clients that connect to TiKV:

* [Rust](https://github.com/tikv/client-rust)
* [Java](https://github.com/tikv/client-java)
* [Go](https://github.com/pingcap/tidb/store/tikv)

Below we use the Rust client for some examples, but you should find all clients work similarly.

## Adding the dependency {#dependency}

This guide assumes you are using Rust 1.31 or above. You will also need an already deployed TiKV and PD cluster, since TiKV is not an embedded database.

To start, open the `Cargo.toml` of your project, and add the `tikv-client` and `futures` as dependencies.

<!-- TODO: Use crates.to once published -->

```toml
[dependencies]
tikv-client = { git = "https://github.com/tikv/client-rust" }
futures = "0.1"
```

## Basic Types {#types}

Both client use a few basic types for most of their API:

* `Key`, a wrapper around a `Vec<u8>` symbolizing the 'key' in a key-value pair.
* `Value`, a wrapper around a `Vec<u8>` symbolizing the 'value' in a key-value pair.
* `KvPair`, a tuple of `(Key, Value)` representing a key-value pair.
* `KeyRange`, a trait representing a range of `Key`s from one value to either another value, or the end of the entire dataset.

The `Key` and `Value` types implement `Deref<Target=Vec<u8>>` so they can generally be used just like their contained values. Where possible API calls accept `impl Into<T>` instead of the type `T` when it comes to `Key`, `Value`, and `KvPair`.

If you're using your own key or value types, we reccomend implementing `Into<Key>` and/or `Into<Value>` for them where appropriate. You can also `impl KeyRange` if you have any range types.

## Connect a client {#connnect}

In your `src/main.rs` you can then import the raw API as well as the functionality of the `Future` trait so you can utilize it.

*Note:* In this example we used `raw`, but you can also use `transaction`. The process is the same.

```rust
use tikv_client::{Config, raw::Client}
use futures::Future;
```

Start by building an instance of `Config` then using it to build an instance of a `Client`.

```rust
let config = Config::new(vec![ // Always use more than one PD endpoint!
    "192.168.0.100:2379",
    "192.168.0.101:2379",
    "192.168.0.102:2379",
]).with_security( // Configure TLS if used.
    "root.ca",
    "internal.cert",
    "internal.key",
);

let unconnected_client = Client::new(config);
let client = unconnected_client.wait()?; // Block and resolve the future.
```

The value returned by `Client::new` is a `Future`. Futures need to be resolved in order to obtain the output. During the resolution of the future the client must create a connection with the cluster.

{{< info >}}
If your application is syncronous you can call `.wait()` to block the current task until the future is resolved. If your application is asyncronous you might have better ways (eg. a Tokio reactor) of dealing with this.
{{< /info >}}

With a connected client, you'll be able to send requests to TiKV. This client supports both singlular or batch operations.

## Raw key-value API {#raw}

Using a connected `raw::Client` you can perform actions such as basic `put`, `get`, and `delete`:

```rust
let client = Client::new(config).wait();
// Data stored in TiKV does not need to be UTF-8.
let key = "TiKV".to_bytes();
let value = "Astronaut".to_bytes();

// This creates a future that must be resolved.
let req = client.put(
    key,  // Vec<u8> impl Into<Key>
    value // Vec<u8> impl Into<Value>
);
req.wait()?;

let req = client.get(key);
let result = req.wait()?;

// `Value` derefs to `Vec<u8>`.
assert_eq!(result, Some(value));

let req = client.delete(key);
req.wait()?;

let req = client.get(key).wait()?;
assert_eq!(result, None);
```

You can also perform `scan`s, giving you all the values for keys in a given range:

```rust
// For stability and reliability, it's good to chose a reasonable limit.
const REASONABLE_LIMIT = 1000;
// If you are using UTF-8,`Key` and `Value` arguments can be provided as
// `String` or `&'static str` as well.
const (START, END) = ("C", "F");

// Scanning can also work on an open end (Eg `START..`)
let req = client.scan(START..END, REASONABLE_LIMIT);
let result: Vec<KvPair> = req.wait()?;
```

These functions also have batch variants which accept sets and return `Vec<_>`s of data. These offer considerably reduced network overhead and can result in dramatic performance increases under certain workloads.

For documented, tested examples of all functionalities, check the documentation of `raw::Client` in the generated Rust documentation.

## Transactional key-value API {#transactional}

> The transactional API of the Rust client is incomplete. You can track the progress with [issue #15](https://github.com/tikv/client-rust/issues/15). For a complete implementation, you can try the [Go client](https://github.com/pingcap/tidb/store/tikv).

Using a connected `transaction::Client` you can then begin a transaction:

```rust
let client = Client::new(config).wait();
let txn = client.begin();
```

Then it's possible to send commands like `get`, `set`, `delete`, or `scan`.

```rust
// `Key` and `Value` wrap around `Vec<u8>` values.
// This means data need not be UTF-8.
let key = "TiKV".to_bytes();
let value = "Astronaut".to_bytes();

// This creates a future that must be resolved.
let req = txn.set(key, value);
req.wait()?;

let req = txn.get(key);
let result = req.wait()?;

// `Value` and `Key` deref to `Vec<u8>`.
// This means you should find them easy to work with.
assert_eq!(result, Some(value));

let req = txn.delete(key);
req.wait()?;

let req = txn.get(key).wait()?;
assert_eq!(result, None);

// For more detail on scanning, see the raw section above or the documentation.
let req = client.scan("A".."B", 1000);
let result: Vec<KvPair> = req.wait()?;
```

Commit these changes when you're ready, or roll back if you prefer to abort the operation:

```rust
if all_is_good {
    txn.commit()?;
} else {
    txn.rollback()?
}
```

## Beyond the Basics

At this point you're familiar with the basic functionality of TiKV. To begin integrating with TiKV you should explore the documentation of your favorite client from those we listed above.

For the Rust client, you can find the full documentation for the client (and all your dependencies) by running:

```bash
cargo doc --package tikv-client --open
```
