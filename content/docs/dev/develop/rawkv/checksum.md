---
title: Checksum
description: Learn how to use RawKV's Checksum API.
menu:
    "dev":
        parent: RawKV-dev
        weight: 2
        identifier: Checksum-dev
---

This document walks you through how to use RawKV's `Checksum` API.

`Checksum` result includes `Crc64Xor`, `TotalKvs` and `TotalBytes`.
- `Crc64Xor`: The [XOR](https://en.wikipedia.org/wiki/Exclusive_or) of every key-value pair's [crc64](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) value.
- `TotalKVs`: The count of key-value pairs.
- `TotalBytes`: The size of key-value pairs in bytes.

_Note: If [API V2](../../../concepts/explore-tikv-features/api-v2) is enable in tikv cluster, tikv client will encode prefix for raw key [here](https://github.com/tikv/client-go/blob/9c0835c80eba6cbda6fc4ae460d645de9d36cd05/internal/client/api_version.go#L57), and `Checksum` API also count prefix into `Crc64Xor` and `TotalBytes`._

## Go

### Checksum with range

Using the `Checksum` API, you can get `{Crc64Xor, TotalKvs, TotalBytes}` from TiKV in a range (from a `startKey` to an `endKey`).

{{< info >}}
`startKey` is inclusive while `endKey` is exclusive.

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

	fmt.Printf("cluster ID: %d\n", cli.ClusterID())

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

	fmt.Printf("Get checksum=, Crc64Xor:%d, TotalKvs:%d, TotalBytes:%d.\n",
		checksum.Crc64Xor, checksum.TotalKvs, checksum.TotalBytes)
}
```
If you want to check all the data, the `startKey` and `endKey` can be specified as `[]byte("")`
