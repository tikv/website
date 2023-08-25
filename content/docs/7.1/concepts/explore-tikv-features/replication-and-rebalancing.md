---
title: Replication and Rebalancing
description: Learn how TiKV replicates, distributes, and rebalances data.
menu:
    "7.1":
        parent: Features-7.1
        weight: 1
        identifier: Replication and Rebalancing-7.1
---

This document walks you through a simple demonstration of how TiKV replicates, distributes, and rebalances data. To start a 3-node local cluster, you need to perform the following operations:

1. Write some data via [go-ycsb](https://github.com/pingcap/go-ycsb), and then verify whether the data is replicated in triplicate by default.
2. Add two more nodes and see how TiKV automatically rebalances replicas to efficiently use all available capacity.

{{< warning >}}
Do not apply this operation in the production environment.
{{< /warning >}}

## Prerequisites

Make sure that you have installed [TiUP](https://github.com/pingcap/tiup) as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes).

## Step 1: Start a 3-node cluster

1. Check your TiUP version. Execute the following command:

    ```sh
    tiup -v
    ```

2. Depending on the TiUP version, execute the `tiup-playground` command to start a 3-node local cluster.

    If TiUP version is v1.5.2 or later, execute the following command:

    ```sh
    tiup playground --mode tikv-slim --kv 3
    ```

    If TiUP version is earlier than v1.5.2, execute the following command:

    ```sh
    tiup playground --kv 3
    ```

After you execute the command, the output is as follows:

```
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

## Step 2: Write data

On another terminal session, you can use [go-ycsb](https://github.com/pingcap/go-ycsb) to launch a workload.

1. Clone the `go-ycsb` from GitHub.

    ```sh
    git clone https://github.com/pingcap/go-ycsb.git
    ```

2. Build the application from the source.

    ```sh
    make
    ```

3. Load a small workload using `go-ycsb`.

    ```sh
    # By default, this workload will insert 1000 records into TiKV.
    ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw"
    ```

## Step 3: Verify the replication

To understand the replication in TiKV, it is important to review several concepts in the [architecture](https://github.com/tikv/tikv#tikv-software-stack).

| Concept    | Description                                                                                                                                                                                                                         |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Region** | TiKV can be taken as a giant sorted map of key-value pairs. The Region is the basic unit of key-value data movement. Each Region is a range of keys and is replicated to multiple Nodes. These multiple replicas form a Raft group. |
| **Peer**   | TiKV replicates each Region (three times by default) and stores each replica on a different peer. In the same node, it contains multiple peers of different Regions.                                                                |

1. Open the Grafana at [http://localhost:3000](http://localhost:3000) (printed from the `tiup-playground` command), and then log in to Grafana using username `admin` and password `admin`.

2. On the **playground-overview** dashboard, check the metrics on the **Region** panel in the **TiKV** tab. You can see that the numbers of Regions on all three nodes are the same, which indicates the following:

   * There is only one Region. It contains the data imported by `go-ycsb`.
   * Each Region has 3 replicas (according to the default configuration).
   * For each Region, each replica is stored in different stores.

{{< figure
    src="/img/docs/region-count.png"
    width="80"
    number="1" >}}

## Step 4: Write more data

In this section, you can launch a larger workload, scale the 3-node local cluster to a 5-node cluster, and then check whether the load of the TiKV cluster is **rebalanced** as expected.

1. Start a new terminal session and launch a larger workload with `go-ycsb`.
    For example, on a machine with 16 virtual cores, you can launch a workload by executing the following command:

   ```sh
   ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p tikv.conncount=16 -p threadcount=16 -p recordcount=1000000
   ```

2. Go to the **playground-overview** dashboard of the Grafana, and check the Region distribution on the TiKV cluster. The number of Regions keeps increasing while writing data to the cluster as follows:

{{< figure
    src="/img/docs/region-count-after-load-data.png"
    width="80"
    number="1" >}}

## Step 5: Add two more nodes

1. Start another terminal session and use the `tiup playground` command to scale out the cluster.

    ```sh
    tiup playground scale-out --kv 2
    ```

2. Verify the scale-out cluster by executing the following command:

    ```sh
    tiup playground display
    ```

    The output is as follows:

    ```
    Pid     Role  Uptime
    ---     ----  ------
    282731  pd    4h1m23.792495134s
    282752  tikv  4h1m23.77761744s
    282757  tikv  4h1m23.761628915s
    282761  tikv  4h1m23.748199302s
    308242  tikv  9m50.551877838s
    308243  tikv  9m50.537477856s
    ```

## Step 6: Verify the data rebalance

Go to the Grafana page as mentioned above. You can find some Regions are split and rebalanced to the two new nodes.

{{< figure
    src="/img/docs/data-rebalance.png"
    width="80"
    number="1" >}}

## Step 7: Stop and delete the cluster

If you do not need the local TiKV cluster anymore, you can stop and delete it.

1. To stop the TiKV cluster, get back to the terminal session in which you have started the TiKV cluster. Press <kbd>Ctrl</kbd> + <kbd>C</kbd> and wait for the cluster to stop.

2. After the cluster is stopped, to delete the cluster, execute the following command:

    ```sh
    tiup clean --all
    ```
