---
title: Fault Tolerance and Recovery
description: Learn how TiKV recovers from failures
menu:
    "5.1":
        parent: Features
        weight: 2
---

This page walks you through a simple demonstration of how TiKV recovers from failures and continues to provide services during failures.

1. Starting a 6-node local cluster.
2. Run a sample workload via [go-ycsb](https://github.com/pingcap/go-ycsb), terminate a node to simulate a failure, and see how the cluster continues uninterrupted.
3. Leave that node offline for long enough to watch the cluster repair itself by re-replicating missing data to other nodes.
4. Prepare the cluster for 2 simultaneous node failures by increasing to 5-way replication, then take two nodes offline at the same time, and again see how the cluster continues uninterrupted.


## Prerequisites

1. Install [TiUP](https://github.com/pingcap/tiup) version **v1.5.2** or above as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes)
2. Install [client-py](https://github.com/tikv/client-py) to interact with the TiKV cluster.


## Step 1. Start a 6-node cluster

Use `tiup playground` command to launch a 6-node local cluster.

```sh
tiup playground --mode tikv-slim --kv 6
```

This command will give you a hint about components' addresses. It will be used in the following steps.

```
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

{{< info >}}
Each region contains 3 replicas according to the default configuration.
{{< /info >}}

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
    ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p recordcount=1000000
    ```

    This command will output the following content:

    ```
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

The evaluation of the last expression should be **10000**, as the `recordcount` specified in the `go-ycsb` command.


## Step 4. Run a sample workload.

Go to the source directory of `go-ycsb`, use the following command to run the `workloada` from YCSB benchmark, simulating multiple client connections, each performing mixed 50% read and 50% write operations.

```sh
./bin/go-ycsb run tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p tikv.conncount=16 -p threadcount=16 -p recordcount=10000 -p operationcount=1000000
```

You'll see per-operation statistics print to standard output every second.

```
...
READ   - Takes(s): 10.0, Count: 7948, OPS: 796.2, Avg(us): 395, Min(us): 72, Max(us): 20545, 99th(us): 2000, 99.9th(us): 19000, 99.99th(us): 21000
UPDATE - Takes(s): 10.0, Count: 7945, OPS: 796.8, Avg(us): 19690, Min(us): 11589, Max(us): 40429, 99th(us): 34000, 99.9th(us): 41000, 99.99th(us): 41000
READ   - Takes(s): 20.0, Count: 15858, OPS: 793.6, Avg(us): 380, Min(us): 68, Max(us): 20545, 99th(us): 2000, 99.9th(us): 3000, 99.99th(us): 21000
UPDATE - Takes(s): 20.0, Count: 15799, OPS: 791.1, Avg(us): 19834, Min(us): 10505, Max(us): 41090, 99th(us): 35000, 99.9th(us): 40000, 99.99th(us): 41000
...
```

{{ <info> }}
This workload above will run several minutes, you will have enough time to simulate a node failure described as follows.
{{ </info> }}

## Step 5. Check the workload

1. Go to the [Grafana](https://grafana.com) page at [http://127.0.0.1:3000](http://127.0.0.1:3000)

2. Login with default username `admin` and password `admin`

3. Go to dashboard **playground-tikv-summary**, the OPS information is in panel **gRPC message count** in row **gRPC**.

{{< figure
    src="/img/docs/check-ops.png"
    width="80"
    number="1" >}}

4. By default, TiKV replicates all data 3 times and balances it across all stores. To see this balance, go to page **playground-overview** and check the region count across all nodes. In this example, we load a small amount of data, thus only one region is presented:

{{< figure
    src="/img/docs/fault-tolerance-region-count.png"
    width="80"
    number="1" >}}

## Step 6. Simulate a single node failure

To understand fault tolerance in TiKV, it's important to review a few concepts from the [architecture](https://tikv.org/docs/5.1/reference/architecture/overview).
| Concept        |                                                   Description                                                    |
| -------------- | :--------------------------------------------------------------------------------------------------------------: |
| **Raft Group** |                  Each replica of a region is called Peer. All of such peers form a raft group.                   |
| **Leader**     | In every raft group, there is a unique role called leader, are responsible for read/write requests from clients. |


Notice that all read/write operations are handled by the leader of the region group, we are going to stop the only one leader in the cluster, and check the load continuity and cluster health.


1. Go to Grafana dashboard **playground-overview**, the leader distribution is in panel **leader** in row **TiKV**.

2. In the example, the local process that open port `20180` hold only one leader in the cluster. Use the following command to stop the process.

    ```sh
    kill -STOP $(lsof -i:20180 | grep tikv | head -n1 | awk '{print $2}')
    ```

## Step 7. Check load continuity and cluster health

1. Check the leader distribution again, you will find the leader is moving to another store.

{{< figure
    src="/img/docs/fault-tolerance-leader-recover.png"
    width="80"
    number="1" >}}

2. Check the gRPC OPS, you will find there is a small duration that the TiKV is unavailable because the leader was down. However, the workload is back online as soon as the [election](https://raft.github.io/raft.pdf) is completed.

{{< figure
    src="/img/docs/fault-tolerance-ops.png"
    width="80"
    number="1" >}}

## Step 8. Prepare for two simultaneous node failures

At this point, the cluster has recovered. In the example above, we stop the leader of the cluster which result in 5 stores are alive. Then, a new leader is presented after a while. We are going to increase the region replicas of TiKV to 5, stop 2 non-leader nodes simultaneously and check the cluster status.

{{< info >}}
While using `tiup ctl`, an explicit version of the component is needed. In this example, it's v5.1.0.
{{< /info >}}
1. Increase replicas to the cluster:

    ```sh
    tiup ctl:v5.1.0 pd config set max-replicas 5
    ```

2. Stop 2 non-leader nodes simultaneously. In this example, we stop the processes that hold port `20181` and `20182` whose PID is `1009934` and `109941`.

   ```sh
   kill -STOP 1009934
   kill -STOP 1009941
   ```

## Step 9. Check load continuity and cluster health

1. Like before, go to the Grafana and follow **playground-tikv-summary** -> **gRPC** -> **gRPC message count**. You will find there is no impact on our workload continuity because the leader is still alive.

{{< figure
    src="/img/docs/fault-tolerance-workload.png"
    width="80"
    number="1" >}}

2. To verify this further, we could use `client-py` to read/write some data to prove our cluster is still available.

    ```python
    >>> from tikv_client import RawClient
    >>> client = RawClient.connect("127.0.0.1:2379")
    >>> len(client.scan_keys(None, None, 10240))
    10000
    >>> client.put(b'key', b'value')
    >>> len(client.scan_keys(None, None, 10240))
    10001
    ```
## Step 10. Clean up

1. Back to the terminal session that you just started the TiKV cluster and press `ctrl-c` and wait for the cluster to stop.
2. You can destroy the cluster by:

    ```sh
    tiup clean --all
    ```
