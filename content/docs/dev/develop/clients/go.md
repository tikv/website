---
title: Go Client
description: Interact with TiKV using Go.
menu:
    "dev":
        parent: TiKV Clients-dev
        weight: 2
        identifier: Go Client-dev
---

This document guides you on how to use [Go Client](https://github.com/tikv/client-go) through some simple examples. For more details, please visit [client-go wiki].

## Try the transactional key-value API

The `txnkv` package provides a transactional API against TiKV cluster.

### Create Client

Information about a TiKV cluster can be found by the address of PD server. After starting a TiKV cluster successfully, we can use PD's address list to create a client to interact with it.

```go
import "github.com/tikv/client-go/v2/txnkv"

client, err := txnkv.NewClient([]string{"127.0.0.1:2379"})
```

### Closing Client

When you are done with a client, you need to gracefully close the client to finish pending tasks and terminate all background jobs.

```go
// ... create a client as described above ...
// ... do something with the client ...
if err := client.Close(); err != nil {
    // ... handle error ...
}
```

### Starting Transaction

When using the transactional API, almost all read and write operations are done within a transaction (or a snapshot). You can use `Begin` to start a transaction.

```go
txn, err := client.Begin(opts...)
if err != nil {
    // ... handle error ...
}
```

### Reads

`TxnKV` provides `Get`, `BatchGet`, `Iter` and `IterReverse` methods to query TiKV.

`Get` retrieves a key-value record from TiKV.

```go
import tikverr "github.com/tikv/client-go/v2/error"

v, err := txn.Get(context.TODO(), []byte("foo"))
if tikverr.IsErrNotFound(err) {
    // ... handle not found ...
}
if err != nil {
    // ... handle other errors ...
}
// ... handle value v ...
```

When reading multiple keys from TiKV, `BatchGet` can be used.

```go
values, err := txn.BatchGet(context.TODO(), keys)
if err != nil {
    // ... handle error ...
}
for _, k := range keys {
    if v, ok := values[string(k)]; ok {
        // ... handle record k:v ...
    } else {
        // ... k does not exist ...
    }
}
```

All key-value records are logically arranged in sorted order. The iterators allow applications to do range scans on TiKV. The iterator yields records in the range `[start, end)`.

```go
iter, err := txn.Iter(start, end)
if err != nil {
    // ... handle error ...
}
defer iter.Close()
for iter.Valid() {
    k, v := iter.Key(), iter.Value()
    // ... handle record k:v
    if err := iter.Next(); err != nil {
        // ... handle error ...
    }
}
```

`IterReverse` also creates an iterator instance, but it iterates in reverse order.

### Writes

You can use `Set` and `Delete` methods to write data into the transaction.

```go
if err := txn.Set([]byte("foo"), []byte("bar")); err != nil {
    // ... handle error ...
}
if err := txn.Delete([]byte("foo")); err != nil {
    // ... handle error ...
}
```

### Committing or Rolling Back Transaction

To actually commit the transaction to TiKV, you need to call `Commit` to trigger the commit process.

If the transaction does not need to commit, for optimistic transactions, you can just discard the transaction instance, for pessimistic transactions you need to actively call the `Rollback()` method to clean up the data previously sent to TiKV.

```go
if err := txn.Commit(context.TODO()); err != nil {
    // ... handle error ...
}
// ... commit success ...
```

### Snapshots (Read-Only Transactions)

If you want to create a read-only transaction, you can use `GetSnapshot` method to create a snapshot. A `Snapshot` is more lightweight than a transaction.

```go
ts, err := client.CurrentTimestamp("global")
if err != nil {
    // ... handle error ...
}
snapshot, err := client.GetSnapshot(ts)
if err != nil {
    // ... handle error ...
}
v, err := snapshot.Get(context.TODO(), []byte("foo"))
// ... handle Get result ...
```

Snapshot can also be extracted from a existed transaction.

```go
snapshot := txn.GetSnapshot()
// ... use snapshot ...
```


## Try the Raw key-value API

### Create client

After starting a TiKV cluster successfully, we can use PD's address list to create a client to interact with it.

```go
import (
    "github.com/tikv/client-go/v2/config"
    "github.com/tikv/client-go/v2/rawkv"
)

client, err := rawkv.NewClient(context.TODO(), []string{"127.0.0.1:2379"}, config.Security{})
if err != nil {
    // ... handle error ...
}
```

### Closing Client

When you are done with a client, you need to gracefully close the client to finish pending tasks and terminate all background jobs.

```go
if err := client.Close(); err != nil {
    // ... handle error ...
}
```

### Single Key Read/Write

`RawKV` provides `Get`, `Put` and `Delete` methods to read and write a single key.

```go
v, err := client.Get(context.TODO(), []byte("key"))
if err != nil {
    // ... handle error ...
}
// ... handle value v ...

err = client.Put(context.TODO(), []byte("key"), []byte("value"))
if err != nil {
    // ... handle error ...
}

err = client.Delete(context.TODO(), []byte("key"))
if err != nil {
    // ... handle error ...
}
```

### Iterations
Like `txnkv`, there are also `Scan` and `ReverseScan` methods to iterate over a range of keys.

```go
keys, values, err := client.Scan(context.TODO(), []byte("begin"), []byte("end"), 10)
if err != nil {
    // ... handle error ...
}
// ... handle keys, values ...

keys, values, err := client.ReverseScan(context.TODO(), []byte("begin"), []byte("end"), 10)
if err != nil {
    // ... handle error ...
}
// ... handle keys, values ...
```

### Batch Operations

`RawKV` also supports batch operations using batch. Note that since `RawKV` is not transaction guaranteed, we do not guarantee that all writes will succeed or fail at the same time when these keys are distributed across multiple regions.

```go
values, err := client.BatchGet(context.TODO(), [][]byte{[]byte("key1"), []byte("key2")})
if err != nil {
    // ... handle error ...
}
// ... handle values ...

err = client.BatchPut(context.TODO(), [][]byte{[]byte("key1"), []byte("key2")}, [][]byte{[]byte("value1"), []byte("value2")}, nil)
if err != nil {
    // ... handle error ...
}

err = client.BatchDelete(context.TODO(), [][]byte{[]byte("key1"), []byte("key2")})
if err != nil {
    // ... handle error ...
}
```

[client-go wiki]: https://github.com/tikv/client-go/wiki
