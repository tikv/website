---
title: Fault tolerance and recovery
description: Fault tolerance, recovery
menu:
    "5.1":
        parent: Features
        weight: 2
---

This page walks you through a simple demonstration of how TiKV remains available during, and recovers after, failure.

1. Starting with a 6-node local cluster with the default 3-way replication.
2. Run a sample workload via [go-ycsb](https://github.com/pingcap/go-ycsb), terminate a node to simulate failure, and see how the cluster continues uninterrupted.
3. Leave that node offline for long enough to watch the cluster repair itself by re-replicating missing data to other nodes.
4. Prepare the cluster for 2 simultaneous node failures by increasing to 5-way replication, then take two nodes offline at the same time, and again see how the cluster continues uninterrupted.


## Prerequisites

1. Installed [TiUP](https://github.com/pingcap/tiup) version **v1.5.2** or above as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes) for cluster deployment
2. Clone and compile tool [go-ycsb](https://github.com/pingcap/go-ycsb) in local for launch a workload
3. Install [client-py](https://github.com/tikv/client-py) to interact with the TiKV cluster.


## Step 1. Start a 6-node cluster

With a new terminal session, use `tiup playground` command to launch a 6-node local cluster.
```sh
tiup playground --mode tikv-slim --kv 6
```
This command will give you a hint about components' addresses. It will be used in the following steps:
```txt
Playground Bootstrapping...
Start pd instance
Start tikv instance
Start tikv instance
Start tikv instance
Start tikv instance
Start tikv instance
Start tikv instance
PD client endpoints: [127.0.0.1:2379]
To view the Prometheus: http://127.0.0.1:44549
To view the Grafana: http://127.0.0.1:3000
```

**By now, each region in this cluster will have 3 replicas according to the default configuration.**

## Step 2. Write data

On another terminal session, use [go-ycsb](https://github.com/pingcap/go-ycsb) to launch a workload.

1. Clone the `go-ycsb` from GitHub.
    ```sh
    git clone https://github.com/pingcap/go-ycsb.git
    ```
2. Build the application from the source.
    ```sh
    make
    ```
3. Load a workload using `go-ycsb` with **10000** keys.
    ```sh
    ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p recordcount=10000
    ```
    This command will output the following content:
    ```txt
    Run finished, takes 11.722575701s
    INSERT - Takes(s): 11.7, Count: 10000, OPS: 855.2, Avg(us): 18690, Min(us): 11262, Max(us): 61304, 99th(us): 36000, 99.9th(us): 58000, 99.99th(us): 62000

    ```

## Step 3. Verify the data importing.

Within python3.5+ REPL environment, you can scan all the keys that just inserted by `go-ycsb` and assert the count of them is `recordcount` in the `go-ycsb` command above.
```python
>>> from tikv_client import RawClient
>>> client = RawClient.connect("127.0.0.1:2379")
>>> len(client.scan_keys(None, None, 10000))
10000
```

The evaluation of last expression should be **10000**, as the `recordcount` specified in the `go-ycsb` command.


## Step 4. Run a sample workload.