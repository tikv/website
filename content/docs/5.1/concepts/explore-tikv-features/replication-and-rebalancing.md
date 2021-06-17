---
title: Replication and rebalancing
description: replication, rebalancing
menu:
    "5.1":
        parent: Features
        weight: 1
---

This page walks you through a simple demonstration of how TiKV replicates, distributes, and rebalances data. Starting with a 3-node local cluster, you'll: 

1. Write some data via [go-ycsb](https://github.com/pingcap/go-ycsb) and verify that it replicates in triplicate by default.
2. Add two more nodes and watch how TiKV automatically rebalances replicas to efficiently use all available capacity.

{{< warning >}}
Do not apply this in production.
{{< /warning >}}


## Prerequisites

Make sure you have installed [TiUP](https://github.com/pingcap/tiup) version **v1.5.2** or above as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes).


## Step 1. Start a 3-node cluster

Use the `tiup-playground` to start a 3-node local cluster.
```sh
tiup playground --mode tikv-slim --kv 3
```

The command above will output the following content:
```txt
...
Starting component `playground`: /home/pingcap/.tiup/components/playground/v1.5.0/tiup-playground --mode tikv-slim --kv 3
Using the version v5.0.2 for version constraint "".

If you'd like to use a TiDB version other than v5.0.2, cancel and retry with the following arguments:
    Specify version manually:   tiup playground <version>
    Specify version range:      tiup playground ^5
    The nightly version:        tiup playground nightly

Playground Bootstrapping...
Start pd instance
Start tikv instance
Start tikv instance
Start tikv instance
PD client endpoints: [127.0.0.1:2379]
To view the Prometheus: http://127.0.0.1:33703
To view the Grafana: http://127.0.0.1:3000
```

## Step 2. Write data

On another terminal session, we will use [go-ycsb](https://github.com/pingcap/go-ycsb) to launch a workload.

1. Clone the `go-ycsb` from GitHub.
    ```sh
    git clone https://github.com/pingcap/go-ycsb.git
    ```
2. Build the application from the source.
    ```sh
    make
    ```
3. Load a small workload using `go-ycsb`
    ```sh
    # By default, this workload will insert 1000 records into TiKV
    ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" 
    ```

## Step 3. Verify replication

1. To understand replication in TiKV, it's important to review a few concepts from the [architecture](https://github.com/tikv/tikv#tikv-software-stack).

| Concept     |                                                                                                           Description                                                                                                            |
| ----------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Region**  | TiKV could seem like a giant sorted map of key-value pairs. The region is the basic unit of key-value data movement. Each region is a range of keys and replicated to multiple Nodes. These multiple replicas form a Raft group. |
| **Replica** |                                                                  TiKV replicates each region (3 times by default) and stores each replica on a different node.                                                                   |

2. With those concepts in mind, open the Grafana at [http://localhost:3000](http://localhost:3000) (printed from `tiup-playground`) and log in with `admin` whose password is the same as username.

3. On the **playground-overview** dashboard, note the matrices in **region** panel in **TiKV** tab. It shows that the Regions count is the same on all three nodes. This indicates that:
   *  There are this many "ranges" of data in the cluster. These are the small workload that we use `go-ycsb` injected.
   * Each region has been replicated 3 times (according to the TiKV default).
   * For each region, each replica is stored on different nodes.

{{< figure
    src="/img/docs/region-count.png"
    width="80"
    number="1" >}}

## Step 4. Write more data

In this section, we will launch a larger workload, then scales the 3-node local cluster to a 5-node cluster and check the load of TiKV cluster will be **rebalanced** as expected.

1. With a new terminal session, and launch a larger workload with `go-ycsb`.
    For example, on a machine with 16 virtual cores, you can launch a workload in the following way:
   ```sh
   ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p tikv.conncount=16 -p threadcount=16 -p recordcount=1000000
   ```

2. Go to Grafana page mentioned above. Checking the region distribution on the TiKV cluster, it should be increasing while the data is continuously written to the cluster. Just like:

{{< figure
    src="/img/docs/region-count-after-load-data.png"
    width="80"
    number="1" >}}

## Step 5. Add two more nodes

1. Create another terminal session, use `tiup playground` to scale out the cluster.
    ```sh
    tiup playground scale-out --kv 2
    ```
2. You can verify the scale-out with:
    ```sh
    tiup playground display
    Pid     Role  Uptime
    ---     ----  ------
    282731  pd    4h1m23.792495134s
    282752  tikv  4h1m23.77761744s
    282757  tikv  4h1m23.761628915s
    282761  tikv  4h1m23.748199302s
    308242  tikv  9m50.551877838s
    308243  tikv  9m50.537477856s
    ```

## Step 6. Verify the data rebalance

Go to Grafana page mentioned above. You will find some regions are split and rebalance to the two new nodes.

{{< figure
    src="/img/docs/data-rebalance.png"
    width="80"
    number="1" >}}


## Last step. Stop and delete the cluster.

1. Back to the terminal session that you just started the TiKV cluster and press `ctrl-c` and wait for the cluster to stop.
2. You can destroy the cluster by:
    ```sh
    tiup clean --all
    ```