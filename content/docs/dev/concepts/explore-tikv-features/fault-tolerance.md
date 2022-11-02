---
title: Fault Tolerance and Recovery
description: Learn how TiKV recovers from failures.
menu:
    "6.1":
        parent: Features-v6.1
        weight: 2
        identifier: Fault Tolerance and Recovery-v6.1
---

This document walks you through a demonstration of how TiKV recovers from failures and continues providing services when some nodes fail. You can follow the steps of this demonstration and perform operations on your own. In this way, you will have a hands-on experience of the fault tolerance feature of TiKV.

The demonstration consists of two experiments: a single-node failure simulation, where one node is taken offline, and then a two-node failure, where two TiKV nodes are simultaneously taken offline. In both failures, the cluster repairs itself by re-replicating missing data to other nodes, and you can see how the cluster continues running uninterrupted.

The process is as follows:

1. [Prepare a TiKV cluster for test](#prepare-a-tikv-cluster-for-test).
2. [Run a workload against TiKV](#run-a-workload-against-tikv).
3. [Experiment 1: Simulate a single-node failure](#experiment-1-simulate-a-single-node-failure).
4. [Experiment 2: Simulate two simultaneous node failures](#experiment-2-simulate-two-simultaneous-node-failures).
5. [Clean up the test cluster](#clean-up-the-test-cluster).

## Prepare a TiKV cluster for test

Before the process of failure simulation begins, the following requirements are already met:

+ [TiUP](https://github.com/pingcap/tiup) has been installed (v1.5.2 or later) as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes).
+ [client-py](https://github.com/tikv/client-py) has been installed. It is used to interact with the TiKV cluster.

### Step 1. Start a six-node cluster

Use the `tiup playground` command to start a six-node local TiKV cluster:

```sh
tiup playground --mode tikv-slim --kv 6
```

The output of this command will show the components' addresses. These addresses will be used in the following steps.

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
Each Region has three replicas according to the default configuration.
{{< /info >}}

### Step 2. Import data to TiKV

Start a new terminal session, and use [go-ycsb](https://github.com/pingcap/go-ycsb) to launch a workload of writing data to the TiKV cluster.

1. Clone `go-ycsb` from GitHub.

    ```sh
    git clone https://github.com/pingcap/go-ycsb.git
    ```

2. Build the application from the source.

    ```sh
    make
    ```

3. Load a workload using `go-ycsb` with **10000** keys into the TiKV cluster.

    ```sh
    ./bin/go-ycsb load tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p recordcount=1000000
    ```

    The expected output is as follows:

    ```
    Run finished, takes 11.722575701s
    INSERT - Takes(s): 11.7, Count: 10000, OPS: 855.2, Avg(us): 18690, Min(us): 11262, Max(us): 61304, 99th(us): 36000, 99.9th(us): 58000, 99.99th(us): 62000
    ```

### Step 3: Verify the data import

Use the client-py tool to verify the data imported in the last step. Note that the Python 3.5+ REPL environment is required for such verification. It is expected that the key count in the output matches the `recordcount` in the `go-ycsb` command in the previous step.

```python
>>> from tikv_client import RawClient
>>> client = RawClient.connect("127.0.0.1:2379")
>>> len(client.scan_keys(None, None, 10000))
10000
```

The evaluation of the last expression should be **10000**, as the `recordcount` has been specified in the `go-ycsb` command.

## Run a workload against TiKV

### Step 1. Run a sample workload

Enter the source directory of `go-ycsb` and use the following command to run the `workloada` from the YCSB benchmark.

`workloada` simulates multiple client connections and performs a mix of reads (50%) and writes (50%) per connection.

```sh
./bin/go-ycsb run tikv -P workloads/workloada -p tikv.pd="127.0.0.1:2379" -p tikv.type="raw" -p tikv.conncount=16 -p threadcount=16 -p recordcount=10000 -p operationcount=1000000
```

Per-operation statistics are printed to the standard output every second.

```
...
READ   - Takes(s): 10.0, Count: 7948, OPS: 796.2, Avg(us): 395, Min(us): 72, Max(us): 20545, 99th(us): 2000, 99.9th(us): 19000, 99.99th(us): 21000
UPDATE - Takes(s): 10.0, Count: 7945, OPS: 796.8, Avg(us): 19690, Min(us): 11589, Max(us): 40429, 99th(us): 34000, 99.9th(us): 41000, 99.99th(us): 41000
READ   - Takes(s): 20.0, Count: 15858, OPS: 793.6, Avg(us): 380, Min(us): 68, Max(us): 20545, 99th(us): 2000, 99.9th(us): 3000, 99.99th(us): 21000
UPDATE - Takes(s): 20.0, Count: 15799, OPS: 791.1, Avg(us): 19834, Min(us): 10505, Max(us): 41090, 99th(us): 35000, 99.9th(us): 40000, 99.99th(us): 41000
...
```

{{< info >}}
This workload above runs for several minutes, which is enough to simulate a node failure described as follows.
{{< /info >}}

### Step 2. Check the workload on Grafana dashboard

1. Open the [Grafana](https://grafana.com) dashboard by accessing [`http://127.0.0.1:3000`](http://127.0.0.1:3000) in your browser.

2. Log in the dashboard by using the default username `admin` and password `admin`.

3. Enter the dashboard **playground-tikv-summary**, and the OPS information is in the panel **gRPC message count** in the row **gRPC**.

    {{< figure
        src="/img/docs/check-ops.png"
        width="80"
        number="1" >}}

4. By default, TiKV replicates all data three times and balances the load across all stores. To see this balancing process, enter the page **playground-overview** and check the Region count across all nodes. In this example, a small amount of data is loaded. Thus only one Region is shown:

    {{< figure
        src="/img/docs/fault-tolerance-region-count.png"
        width="80"
        number="1" >}}

## Experiment 1: Simulate a single-node failure

### Step 1: Stop the target process

In TiKV, all read/write operations are handled by the leader of the Region group. See [architecture](https://tikv.org/docs/6.1/reference/architecture/overview/#system-architecture) for details.

In this example, the only one leader in the cluster is stopped. Then the load continuity and cluster health are checked.

1. Enter the Grafana dashboard **playground-overview**. The leader distribution is shown in the panel **leader** in row **TiKV**.

2. In this example, the local process that opens the port `20180` holds only one leader in the cluster. Execute the following command to stop this process.

    ```sh
    kill -STOP $(lsof -i:20180 | grep tikv | head -n1 | awk '{print $2}')
    ```

### Step 2. Check the load continuity and cluster health on Grafana dashboard

1. Check the leader distribution on the dashboard again. The monitoring metric shows that the leader is moved to another store.

    {{< figure
        src="/img/docs/fault-tolerance-leader-recover.png"
        width="80"
        number="1" >}}

2. Check the gRPC OPS. The monitoring metric shows that there is a short duration in which the TiKV instance is unavailable because the leader is down. However, the workload is back online as soon as the leader [election](https://raft.github.io/raft.pdf) is completed.

    {{< figure
        src="/img/docs/fault-tolerance-ops.png"
        width="80"
        number="1" >}}

## Experiment 2: Simulate two simultaneous node failures

### Step 1: Stop the target processes

In the above single-node failure simulation, the TiKV cluster has recovered. The leader of the cluster has been stopped, so there are five stores alive. Then, a new leader is elected after a while.

Experiment 2 will increase the Region replicas of TiKV to five, stop two non-leader nodes simultaneously, and check the cluster status.

{{< info >}}
The component version should be explicitly specified in the `tiup ctl` command. In the following example, the component version is v6.1.0.
{{< /info >}}

1. Increase the replicas of the cluster to five:

    ```sh
    tiup ctl:v6.1.0 pd config set max-replicas 5
    ```

2. Stop two non-leader nodes simultaneously. In this example, the processes that hold the ports `20181` and `20182` are stopped. The process IDs (PIDs) are `1009934` and `109941`.

   ```sh
   kill -STOP 1009934
   kill -STOP 1009941
   ```

### Step 2: Check the load continuity and cluster health on Grafana dashboard

1. Similar to [Step 2. Check the load continuity and cluster health on Grafana dashboard](#step-2-check-the-load-continuity-and-cluster-health-on-grafana-dashboard) in the single-node failure simulation, enter the Grafana dashboard and follow **playground-tikv-summary** -> **gRPC** -> **gRPC message count**. The metrics show that the workload continuity is not impacted because the leader is still alive.

    {{< figure
        src="/img/docs/fault-tolerance-workload.png"
        width="80"
        number="1" >}}

2. To further verify the load continuity and cluster health, `client-py` is used to read and write some data to prove that the cluster is still available.

    ```python
    >>> from tikv_client import RawClient
    >>> client = RawClient.connect("127.0.0.1:2379")
    >>> len(client.scan_keys(None, None, 10240))
    10000
    >>> client.put(b'key', b'value')
    >>> len(client.scan_keys(None, None, 10240))
    10001
    ```

## Clean up the test cluster

After experiment 2 is finished, you might need to clean up the test cluster. To do that, take the following steps:

1. Go back to the terminal session that you have just started the TiKV cluster and press <kbd>ctrl</kbd> + <kbd>c</kbd> and wait for the cluster to stop.
2. After the cluster is stopped, destroy the cluster using the following command:

    ```sh
    tiup clean --all
    ```
