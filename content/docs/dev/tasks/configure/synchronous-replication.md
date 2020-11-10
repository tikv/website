---
title: Synchronous Replication Config
description: Learn how to configure synchronous replication.
menu:
    "dev":
        parent: Configure
        weight: 13
---

This document describes how to configure synchronous replication in dual data centers.

One of the data centers is primary, and the other is dr (data recovery). When a Region has an odd number of replicas, primary will be placed more replicas. When dr is down for more than configured time, replication will be changed to be asynchronous and primary will serve requests by its own. Asynchronous replication is used by default.

> **Note:** Synchronous replication is still an experimental feature.

## Enable synchronous replication

Replication mode is controlled by PD. You can use the following example PD configuration to set up a cluster with synchronous replication from scratch:

```toml
[replication-mode]
replication-mode = "dr-auto-sync"

[replication-mode.dr-auto-sync]
label-key = "zone"
primary = "z1"
dr = "z2"
primary-replicas = 2
dr-replicas = 1
wait-store-timeout = "1m"
wait-sync-timeout = "1m"
```

In the above configuration, `dr-auto-sync` is the mode to enable synchronous replication. Label key `zone` is used to distinguish different data centers. TiKV instances with "z1" value are considered in primary data center, and "z2" are in dr data center. `primary-replicas` and `dr-replicas` are the numbers of replicas that should be placed in the data centers respectively. `wait-store-timeout` is the time to wait before falling back to asynchronous replication. `wait-sync-timeout` is the time to wait before forcing TiKV to change replication mode, but it's not supported yet.

You can use the following URL to check current replication status of the cluster:

```bash
% curl http://pd_ip:pd_port/pd/api/v1/replication_mode/status
{
  "mode": "dr-auto-sync",
  "dr-auto-sync": {
    "label-key": "zone",
    "state": "sync"
  }
}
```

After the cluster becomes `sync`, it won't become `async` unless the number of down instances is larger than the specified replica number in either data centers. After the state becomes `async`, PD will ask TiKV to change replication mode to `asynchronous` and check if TiKV instances are recovered from time to time. When the number of down instances is smaller than the number of replicas in both data centers, it will become the `sync-recover` state, and ask TiKV to change replication mode to `synchronous`. After all regions become `synchronous`, the cluster becomes `sync` again.

## Change replication mode manually

You can use `pd-ctl` to change a cluster from `asynchronous` to `synchronous`.

```bash
>> config set replication-mode dr-auto-sync
```

Or change back to `asynchronous`:

```bash
>> config set replication-mode majority
```

You can also update the label key:

```bash
>> config set replication-mode dr-auto-sync label-key dc
```
