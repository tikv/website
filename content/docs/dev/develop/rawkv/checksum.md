---
title: Checksum
description: Learn how to use RawKV's Checksum API.
menu:
    "dev":
        parent: RawKV-dev
        weight: 5
        identifier: Checksum-dev
---

This document walks you through how to use RawKV's `Checksum` API.

`Checksum` API returns `Crc64Xor`, `TotalKvs` and `TotalBytes` from TiKV cluster.
- `Crc64Xor`: The [XOR](https://en.wikipedia.org/wiki/Exclusive_or) of every key-value pair's [crc64](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) value.
- `TotalKVs`: The number of key-value pairs.
- `TotalBytes`: The size of key-value pairs in bytes.

*Note: If [API V2](../../../concepts/explore-tikv-features/api-v2) is enabled, a `4` bytes prefix is encoded with keys, and also calculated by `Checksum` API*

## Go

### Checksum with range

Using the `Checksum` API, you can get `{Crc64Xor, TotalKvs, TotalBytes}` of a range from `startKey` (inclusive) to `endKey` (exclusive).

{{< info >}}
To calculate checksum of all keys, specify `startKey` and `endKey` as `[]byte("")`.

{{< /info >}}

```go
package main

import (
	"context"
	"fmt"

	"github.com/pingcap/kvproto/pkg/kvrpcpb"
	"github.com/tikv/client-go/v2/rawkv"
)

func main() {
	ctx := context.TODO()
	cli, err := rawkv.NewClientWithOpts(ctx, []string{"127.0.0.1:2379"},
		rawkv.WithAPIVersion(kvrpcpb.APIVersion_V2))
	if err != nil {
		panic(err)
	}
	defer cli.Close()

	fmt.Printf("Cluster ID: %d\n", cli.ClusterID())

	// put key into tikv
	cli.Put(ctx, []byte("k1"), []byte("v1"))
	cli.Put(ctx, []byte("k2"), []byte("v2"))
	cli.Put(ctx, []byte("k3"), []byte("v3"))
	cli.Put(ctx, []byte("k4"), []byte("v4"))
	cli.Put(ctx, []byte("k5"), []byte("v5"))

	checksum, err := cli.Checksum(ctx, []byte("k1"), []byte("k6"))
	if err != nil {
		panic(err)
	}

	fmt.Printf("Get checksum, Crc64Xor:%d, TotalKvs:%d, TotalBytes:%d.\n",
		checksum.Crc64Xor, checksum.TotalKvs, checksum.TotalBytes)
}
```
You will get the result as following:

```bash
Cluster ID: 7166545317297238572
Get checksum, Crc64Xor:7402990595130313958, TotalKvs:5, TotalBytes:40.
```