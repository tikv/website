---
title: TiKV API v2
description: What's TiKV API v2 and how to use it
menu:
    "7.1":
        parent: Features-7.1
        weight: 6
        identifier: TiKV API v2-7.1
---

This page introduces what's TiKV API v2 and how to use it.

## TiKV API v2

Before TiKV v6.1.0, RawKV interfaces just store the raw data from clients, so it only provides basic read/write ability of key-values. Besides, due to different encoding and lacking of isolation, TiDB, TxnKV, and RawKV can not be used simultaneously in the same TiKV cluster. In this scenario, multiple clusters must be deployed, and make costs of resource and maintenance increase.

TiKV API v2 provides new storage format, including:

- RawKV organizes data as [MVCC], records update timestamp of every entry, and provides [CDC] feature based on the timestamp (RawKV [CDC] is an experimental feature provided by another component, see [TiKV-CDC]).
- Data in TiKV is separated by modes, supports using TiDB, TxnKV, and RawKV in a single cluster at the same time.
- `Key Space` field is reserved, to support multi-tenant in the future.

To use TiKV API v2, please add or modify `api-version = 2` & `enable-ttl = true` in `[storage]` section of TiKV. See [configuration file](https://docs.pingcap.com/tidb/dev/tikv-configuration-file#api-version-new-in-v610) for detail.

Besides, when API V2 is enabled, you need to deploy at least one tidb-server instance to reclaim expired data of [MVCC]. To ensure high availability, you can deploy multiple tidb-server instances. Note that these tidb-server instances can also be used as normal TiDB database.

> Warning
>   - Due to the significant change on storage format, **only if** the existing TiKV cluster is empty or storing **only** TiDB data, you can enable or disable API v2 smoothly. In other scenario, you must deploy a new cluster, and migrate data using [TiKV-BR].
>   - After API V2 is enabled, you **cannot** downgrade the TiKV cluster to a version earlier than v6.1.0. Otherwise, data corruption might occur.

## Usage Demonstration

### Prerequisites

Before you start, ensure that you have installed TiUP according to [TiKV in 5 Minutes](../../tikv-in-5-minutes).

### Step 1: Config TiKV to enable API v2

To enable API v2, create a file `tikv.yaml` using the following configuration.

```yaml
[storage]
api-version = 2
enable-ttl = true
```

### Step 2: Start TiKV Cluster

```bash
tiup playground nightly --db 1 --tiflash 0 --pd 1 --kv 1 --kv.config tikv.yaml
```

### Step 3: Write the code to test API v2

Take [Go client] as example, save the following script to file `test_api_v2.go`.

```go
package main

import (
	"context"
	"fmt"

	"github.com/pingcap/kvproto/pkg/kvrpcpb"
	"github.com/tikv/client-go/v2/rawkv"
)

func main() {
	cli, err := rawkv.NewClientWithOpts(context.TODO(), []string{"127.0.0.1:2379"},
		rawkv.WithAPIVersion(kvrpcpb.APIVersion_V2))
	if err != nil {
		panic(err)
	}
	defer cli.Close()

	fmt.Printf("cluster ID: %d\n", cli.ClusterID())

	key := []byte("Company")
	val := []byte("PingCAP")

	// put key into tikv
	err = cli.Put(context.TODO(), key, val)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Successfully put %s:%s to tikv\n", key, val)

	// get key from tikv
	val, err = cli.Get(context.TODO(), key)
	if err != nil {
		panic(err)
	}
	fmt.Printf("found val: %s for key: %s\n", val, key)

	// delete key from tikv
	err = cli.Delete(context.TODO(), key)
	if err != nil {
		panic(err)
	}
	fmt.Printf("key: %s deleted\n", key)

	// get key again from tikv
	val, err = cli.Get(context.TODO(), key)
	if err != nil {
		panic(err)
	}
	fmt.Printf("found val: %s for key: %s\n", val, key)
}
```

### Step 4: Run the code

```bash
❯ go mod tidy
❯ go run test_api_v2.go
[2022/11/02 21:23:10.507 +08:00] [INFO] [client.go:405] ["[pd] create pd client with endpoints"] [pd-address="[172.16.5.32:32379]"]
[2022/11/02 21:23:10.513 +08:00] [INFO] [base_client.go:378] ["[pd] switch leader"] [new-leader=http://172.16.5.32:32379] [old-leader=]
[2022/11/02 21:23:10.513 +08:00] [INFO] [base_client.go:105] ["[pd] init cluster id"] [cluster-id=7153087019074699621]
[2022/11/02 21:23:10.514 +08:00] [INFO] [client.go:698] ["[pd] tso dispatcher created"] [dc-location=global]
cluster ID: 7153087019074699621
Successfully put Company:PingCAP to tikv
found val: PingCAP for key: Company
key: Company deleted
found val:  for key: Company
[2022/11/02 21:23:10.532 +08:00] [INFO] [client.go:779] ["[pd] stop fetching the pending tso requests due to context canceled"] [dc-location=global]
[2022/11/02 21:23:10.533 +08:00] [INFO] [client.go:716] ["[pd] exit tso dispatcher"] [dc-location=global]
```

[MVCC]: https://en.wikipedia.org/wiki/Multiversion_concurrency_control
[CDC]: https://en.wikipedia.org/wiki/Change_data_capture
[TiKV-CDC]: https://github.com/tikv/migration/blob/main/cdc/README.md
[TiKV-BR]: https://github.com/tikv/migration/blob/main/br/README.md
[Go client]: https://github.com/tikv/client-go/wiki/RawKV-Basic
