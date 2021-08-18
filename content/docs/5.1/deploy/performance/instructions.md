---
title: Benchmark Instructions
description: How to do a benchmark over a TiKV cluster
menu:
    "5.1":
        parent: Benchmark and Performance
        weight: 6
---

TiKV delivers predictable throughput and latency at all scales on commodity hardware. This document provides a step-by-step tutorial on performing a benchmark test using the industry-standard benchmark tool [YCSB](https://github.com/brianfrankcooper/YCSB) on TiKV.

## Step 1. Set up the environment

1. Prepare 1 node for the YCSB benchmark worker, 1 node for Placement Driver (PD), and 3 nodes for TiKV.

    The following table shows the recommended hardware configuration:

    | **Component** | **CPU**          | **Memory**     | **Storage**          | **Network** | **Instance**                    |
    | ------------- | ---------------- | -------------- | -------------------- | ----------- | ------------------------------- |
    | YSCB worker   | 8 cores or above | 8 GB or above  | No requirement       | Gigabit LAN | 1                               |
    | PD            | 4 cores or above | 8 GB or above  | SAS, 200 GB+         | Gigabit LAN | 1                               |
    | Monitor       | 4 cores or above | 8 GB or above  | SAS, 200 GB or above | Gigabit LAN | 1 (can be the same as PD nodes) |
    | TiKV          | 8 cores or above | 32 GB or above | SSD, 200 GB or above | Gigabit LAN | 3                               |

    {{< info >}}
It is recommended to use local SSDs as the store volume for the instances. Local SSDs are low-latency disks attached to each node and can maximize performance. It is not recommended to use the network-attached block storage. It is recommended to deploy TiKV on NVMe SSDs to maximize its capacity.
    {{< /info >}}

2. Prepare services for the control node and component nodes.

    For the control node, the following requirements must be met:

    | Package |    Version     | Note                   |
    | :------ | :------------: | :--------------------- |
    | sshpass | 1.06 or later  | For remote control     |
    | TiUP    | 0.6.2 or later | To deploy TiKV cluster |

    For the component node, the following requirements must be met:

    | Package |     Version     |              Note              |
    | :------ | :-------------: | :----------------------------: |
    | sshpass |  1.06 or later  |       For remote control       |
    | numa    | 2.0.12 or later | The memory allocation strategy |
    | tar     | No requirement  |         For unzipping          |

    For the YCSB node:

    | Package                                       |    Version     |     Note      |
    | :-------------------------------------------- | :------------: | :-----------: |
    | [go-ycsb](https://github.com/pingcap/go-ycsb) | No requirement | For benchmark |

    {{< info >}}
You can install [TiUP](https://github.com/pingcap/tiup) as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes).
    {{< /info >}}

## Step 2. Deploy a TiKV cluster

1. You can use the following topology to deploy your benchmark cluster via `tiup cluster`. For more information, see [Production Deployment](../../install/production). Save the content below as `topology.yaml`:

    ```yaml
    global:
    user: "tikv"
    ssh_port: 22
    deploy_dir: "/tikv-deploy"
    data_dir: "/tikv-data"
    server_configs: {}
    pd_servers:
    - host: 10.0.1.1
    tikv_servers:
    - host: 10.0.1.2
    - host: 10.0.1.3
    - host: 10.0.1.4
    monitoring_servers:
    - host: 10.0.1.5
    grafana_servers:
    - host: 10.0.1.6
    ```

2. Deploy the cluster:

    ```sh
    tiup cluster deploy [cluster-name] [cluster-version] topology.yaml
    ```

3. Start the cluster:

    ```sh
    tiup cluster start [cluster-name]
    ```

4. You can check the cluster information:

    ```sh
    tiup cluster display [cluster-name]
    ```

## Step 3. Run a YCSB workload

This section introduces the types of core workloads and the recommended sequence for running the workloads. Most of the content in this section comes from [Core Workloads](https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads).

YCSB has 6 types of workloads. The main differences among each type are the portion of different operations.

1. Workload A: `Update heavy workload`
2. Workload B: `Read mostly workload`
3. Workload C: `Read only`
4. Workload D: `Read latest workload`. In this workload, new records are inserted, and the most recently inserted records are the most popular. An application example is the user status updates and people want to read the latest.
5. Workload E: `Short ranges`. In this workload, short ranges of records are queried, instead of individual records. Application example: threaded conversations, where each scan is for the posts in a given thread (assumed to be clustered by thread ID).
6. Workload F: `Read-modify-write`. In this workload, the client will read a record, modify it, and write back the changes.

All 6 workloads above have a data set which is **similar**. Workloads D and E insert records during the test run. Thus, to keep the database size consistent, the following operation sequence is recommended:

1. Load the database, using workload A's parameter file (workloads/workloada).

    ```sh
    go-ycsb load -P workloads/workloada -p ...
    ```

2. Run workload A (using workloads/workloada) for a variety of throughputs.

    ```sh
    go-ycsb run -P workloads/workloada -p ...
    ```

3. Run workload B (using workloads/workloadb) for a variety of throughputs.
4. Run workload C (using workloads/workloadc) for a variety of throughputs.
5. Run workload F (using workloads/workloadf) for a variety of throughputs.
6. Run workload D (using workloads/workloadd) for a variety of throughputs. This workload inserts records, increasing the size of the database.
7. Delete the data in the database. You need to destroy the cluster via `tiup cluster destroy [cluster-name]` and delete the data directory of cluster. Otherwise, the remaining data of the cluster might affect the results of the following workload.
8. Start a new TiKV cluster, load a new data set using workload E's parameter file (workloads/workloade).
9. Run workload E (using workloads/workloade) for a variety of throughputs. This workload inserts records, increasing the size of the database.

{{< info >}}
If you try to use more clients for benchmark test, see [Running a Workload in Parallel](https://github.com/brianfrankcooper/YCSB/wiki/Running-a-Workload-in-Parallel).
{{< /info >}}

For example, you can load a workload that contains 10 million records and 30 million operations by executing the following command:

```sh
go-ycsb load tikv -P workloads/workloada -p tikv.pd="10.0.1.1:2379" -p tikv.type="raw" -p recordcount=10000000 -p operationcount=30000000
```

After the data is successfully loaded, you can launch the workload:

```sh
go-ycsb run tikv -P workloads/workloada -p tikv.pd="10.0.1.1:2379" -p tikv.type="raw" -p recordcount=10000000 -p operationcount=30000000
```

You can specify the concurrency of the workload client using `-p threadcount=`. Normally, this number should be the same as that of virtual CPU cores bound to the machine.

## Step 4. Check the benchmark results

While `go-ycsb` is running, the workload runtime information is output, such as the OPS and latency:

```
...
READ   - Takes(s): 9.7, Count: 110092, OPS: 11380.1, Avg(us): 3822, Min(us): 236, Max(us): 342821, 99th(us): 51000, 99.9th(us): 59000, 99.99th(us): 339000
UPDATE - Takes(s): 9.7, Count: 110353, OPS: 11408.8, Avg(us): 7760, Min(us): 944, Max(us): 344934, 99th(us): 59000, 99.9th(us): 65000, 99.99th(us): 339000
READ   - Takes(s): 19.7, Count: 229147, OPS: 11647.2, Avg(us): 3094, Min(us): 202, Max(us): 342821, 99th(us): 52000, 99.9th(us): 58000, 99.99th(us): 335000
```

When the workload is completed, the summary of the workload is reported.

```
Run finished, takes 4m25.292657267s
READ   - Takes(s): 265.0, Count: 4998359, OPS: 18864.7, Avg(us): 1340, Min(us): 181, Max(us): 342821, 99th(us): 11000, 99.9th(us): 51000, 99.99th(us): 73000
UPDATE - Takes(s): 265.0, Count: 5001641, OPS: 18877.1, Avg(us): 5416, Min(us): 599, Max(us): 1231403, 99th(us): 53000, 99.9th(us): 276000, 99.99th(us): 772000
```

{{< warning >}}
If it reports an error like `batch commands send error:EOF`, refer to [this issue](https://github.com/pingcap/go-ycsb/issues/145).
{{< /warning >}}

## Step 5. Find the maximum throughput

You can find the maximum throughput of the TiKV cluster in either of the following methods:

+ Increase the `threadcount` of the client.

    You can increase the `threadcount` to the number of virtual cores of the machine. In some cases, the number might reach the bottleneck of the TiKV cluster.

+ Increase the count of benchmark clients.

    You can deploy more benchmark clients to increase the requests towards the TiKV cluster. Multiple `go-ycsb` from different nodes can be launched simultaneously. And then you can summarize the result of these nodes.

Repeat the 2 methods above. When the QPS displayed in the TiKV cluster's Grafana page is no longer increasing, the bottleneck of the TiKV cluster is reached.

## Step 6. Clean up the cluster

After the benchmark test is finished, you might want to clean up the cluster. To do that, run the following command:

```sh
tiup cluster destroy [cluster-name]
```
