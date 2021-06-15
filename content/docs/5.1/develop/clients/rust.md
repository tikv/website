---
title: Rust Client
description: Interact with TiKV using Rust.
menu:
    "5.1":
        parent: TiKV Clients
        weight: 3
---

This guide introduces how to interact with TiKV using [Rust Client](https://github.com/tikv/client-rust).

{{< warning >}}
The minimum supported version of Rust is 1.40. The minimum supported version of TiKV is 5.0.0.
{{< /warning >}}

## Basic Types

Both RawKV API and TxnKV API use a few basic types:

* `Key`: a key in the store. `String` and `Vec<u8>` implement `Into<Key>`, so you can pass them directly into client functions.
* `Value`: a value in the store; just an alias of `Vec<u8>`.
* `KvPair`: a pair of a `Key` and a `Value`. It provides convenience methods for conversion to and from other types.
* `BoundRange`: used for range related requests like `scan`. It implements `From` for Rust ranges so you can pass a Rust range of keys to the request, e.g., `client.delete_range(vec![]..)`.

## Add the dependency

To start, open the `Cargo.toml` of your project, and add the `tikv-client` as dependencies.

```toml
[dependencies]
tikv-client = "0.1.0"
```

## Raw key-value API

Using a connected `tikv_client::RawClient`, you can perform actions such as `put`, `get`, `delete` and `scan`:

```rust
let client = RawClient::new(vec!["127.0.0.1:2379"]).await?;

let key = "Hello".to_owned();
let value = "RawKV".to_owned();

// put
let result = client.put(key.to_owned(), value.to_owned()).await?;
assert_eq!(result, ());

// get
let result = client.get(key.to_owned()).await?;
assert_eq!(result.unwrap(), value.clone().as_bytes());

// delete
let result = client.delete(key.to_owned()).await?;
assert_eq!(result, ());

// get
let result = client.get(key.to_owned()).await?;
assert_eq!(result, None);

// scan
let limit = 1000;
client.put("k1".to_owned(), "v1".to_owned()).await?;
client.put("k2".to_owned(), "v2".to_owned()).await?;
client.put("k3".to_owned(), "v3".to_owned()).await?;
client.put("k4".to_owned(), "v4".to_owned()).await?;
let result = client.scan("k1".to_owned().."k5".to_owned(), limit).await?;
println!("{:?}", result);
```

These functions also have batch variants (`batch_put`, `batch_get`, `batch_delete` and `batch_scan`), which offer considerably reduced network overhead and can result in dramatic performance increases under certain workloads.

You can find all the functions that `RawClient` supports [here](https://github.com/tikv/client-rust#raw-requests).

## Transactional key-value API

Using a connected `tikv_client::TransactionClient` you can then begin a transaction:

```rust
use tikv_client::TransactionClient;

let txn_client = TransactionClient::new(vec!["127.0.0.1:2379"]).await?;
let mut txn = txn_client.begin_optimistic().await?;
```

Then it's possible to send commands like `get`, `set`, `delete`, and `scan`:

```rust
let key = "Hello".to_owned();
let value = "TxnKV".to_owned();

// put
let mut txn = txn_client.begin_optimistic().await?;
txn.put(key.to_owned(), value.to_owned()).await?;
txn.commit().await?;

// get
let mut txn = txn_client.begin_optimistic().await?;
let result = txn.get(key.to_owned()).await?;
txn.commit().await?;
assert_eq!(result.unwrap(), value.clone().as_bytes());

// delete
let mut txn = txn_client.begin_optimistic().await?;
txn.delete(key.to_owned()).await?;
txn.commit().await?;

// get
let mut txn = txn_client.begin_optimistic().await?;
let result = txn.get(key.to_owned()).await?;
txn.commit().await?;
assert_eq!(result, None);

// scan
let mut txn = txn_client.begin_optimistic().await?;
txn.put("k1".to_owned(), "v1".to_owned()).await?;
txn.put("k2".to_owned(), "v2".to_owned()).await?;
txn.put("k3".to_owned(), "v3".to_owned()).await?;
txn.put("k4".to_owned(), "v4".to_owned()).await?;
txn.commit().await?;

let limit = 1000;
let mut txn2 = txn_client.begin_optimistic().await?;
let result = txn2.scan("k1".to_owned().."k5".to_owned(), limit).await?;
result.for_each(|pair| println!("{:?}", pair));
txn2.commit().await?;
```

Commit these changes when you're ready, or roll back if you prefer to abort the operation:

```rust
if all_is_good {
    txn.commit().await?;
} else {
    txn.rollback().await?;
}
```

These functions also have batch variants (`batch_put`, `batch_get`, `batch_delete` and `batch_scan`), which offer considerably reduced network overhead and can result in dramatic performance increases under certain workloads.

You can find all the functions that `TransactionClient` supports [here](https://github.com/tikv/client-rust#transactional-requests).
