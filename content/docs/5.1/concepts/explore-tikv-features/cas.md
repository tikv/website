---
title: CAS on RawKV
description: Compare And Swap
menu:
    "5.1":
        parent: Features
        weight: 4
---

This page walks you through a simple demonstration of how to use TiKV's `compare-and-swap`.

In RawKV, `compare-and-swap (CAS)` is an atomic instruction used in multi-threading to achieve synchronization. It compares the `current_value` of a `key` with a given value and, only if they are the same, modifies the contents of that `key` to a new given value. This is done as a single atomic operation. The atomicity guarantees that the new value is calculated based on up-to-date information; if the value had been updated by another thread in the meantime, the write would fail.

## Prerequisites

1. Install TiUP by executing the following command:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
```

2. If TiUP is already installed, update the TiUP playground component to the latest version:

```bash
tiup update --self && tiup update playground
```

3. Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Step 1: Start TiKV Cluster

For the purpose of this tutorial, you need only one TiKV node, so use the `tiup playground` command.

Show TiUP version:

```bash
tiup -v
```

version >= 1.5.0:

```bash
tiup playground --mode tikv-slim
```

version < 1.5.0:

```bash
tiup playground
```

## Step 2: Create a rust project

Use `cargo` to create a rust project:

```bash
cargo new hello-tikv
cd hello-tikv
```

## Step 3: Add dependency

Append the following content to file `Cargo.toml`.

```toml
tikv-client = "0.1.0"
tokio = { version = "1.5.0", features = ["full"] }
```

## Step 4: Write test code

Save the following code to file `src/main.rs`.

```rust
use tikv_client::RawClient;

#[tokio::main]
use tikv_client::RawClient;

#[tokio::main]
async fn main() {
    let client = RawClient::new(vec!["127.0.0.1:2379"])
        .await
        .unwrap()
        .with_atomic_for_cas();

    let key = "key".to_owned();
    let value = "value".to_owned();
    let new_value = "newValue".to_owned();

    // call put(key, value)
    client.put(key.to_owned(), value.to_owned()).await.unwrap();
    println!("put key={}, value={}", key, value);

    // call get(key) returns value
    let res = client.get(key.to_owned()).await.unwrap().unwrap();
    println!("get key={} returnedValue={:?}", key, res);
    assert_eq!(res, value.clone().as_bytes());

    // call compare_and_swap(key, value, new_value) returns (value, true)
    // If the value retrived is equal to `current_value`, `new_value` is written.
    // A tuple is returned if successful: the previous value and whether the value is swapped
    let res = client
        .compare_and_swap(
            key.to_owned(),
            Some(value.to_owned()).map(|v| v.into()),
            new_value.to_owned(),
        )
        .await
        .unwrap();
    println!(
        "compare_and_swap key={} oldValue={} newValue={} returnedValue={:?}",
        key, value, new_value, res
    );

    // call get(key) returns new_value
    let res = client.get(key.to_owned()).await.unwrap().unwrap();
    println!("get key={} returnedValue={:?}", key, res);
    assert_eq!(res, new_value.clone().as_bytes());
}
```

## Step 5: Run the code

```bash
cargo run

put key=key, value=value
get key=key returnedValue Some([118, 97, 108, 117, 101])
compare_and_swap key=key oldValue=value newValue=newValue returnedValue=(Some([118, 97, 108, 117, 101]), true)
get key=key returnedValue=Some([110, 101, 119, 86, 97, 108, 117, 101])
```

As we can see, after calling `compare_and_swap` the `value` is replaced by `newValue`.

{{< warning >}}
Users must set `with_atomic_for_cas` to ensure linearizability of `compare_and_swap` when used together with `put`, `delete`, `batch_put`, or `batch_delete`.

To guarantee the atomicity of CAS, write operations like `put` or `delete` in atomic mode are more expensive.
{{< /warning >}}
