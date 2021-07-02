---
title: Benchmark
description: How to make a benchmark over a TiKV cluster
menu:
    "5.1":
        parent: Deploy
        weight: 3
---

TiKV delivers predictable throughput and latency at all scales on commodity hardware. This page provides an step-by-step tutorial about industry-standard benchmarks [YCSB](https://github.com/brianfrankcooper/YCSB) on TiKV.

## Step 1. Setup the environment.

1. Prepare 1 node for the YCSB benchmark worker, 1 node for PD, 3 nodes for TiKV.

Here is the recommended hardware configuration of the cluster:

| **Component** | **CPU**          | **Memory**     | **Storage**     | **Network** | **Instance**                    |
| ------------- | ---------------- | -------------- | --------------- | ----------- | ------------------------------- |
| YSCB worker   | 8 cores or above | 8 GB or above  | no requirements | Gigabit LAN | 1                               |
| PD            | 4 cores or above | 8 GB or above  | SAS, 200 GB+    | Gigabit LAN | 1                               |
| Monitor       | 4 cores or above | 8 GB or above  | SAS, 200 GB+    | Gigabit LAN | 1 (can be the same as PD nodes) |
| TiKV          | 8 cores or above | 32 GB or above | SSD, 200 GB+    | Gigabit LAN | 3                               |

{{< info >}}
Use local SSD instance store volumes. Local SSDs are low latency disks attached to each node, which maximizes performance. We do not recommend using network-attached block storage. We highly recommend you depoly TiKV over NVMe SSDs in order to maximizes the ability of it.
{{< /info >}}

2. Prepare services for the control node and component nodes.

For the control node, we require:

| package |    version     | comment             |
| :------ | :------------: | :------------------ |
| sshpass | 1.06 or above  | remote control      |
| TiUP    | 0.6.2 or above | depoly TiKV cluster |

For the component node:

| package |     version     |          comment           |
| :------ | :-------------: | :------------------------: |
| sshpass |  1.06 or above  |       remote control       |
| numa    | 2.0.12 or above | memory allocation strategy |
| tar     | no requirements |           unzip            |

For the YCSB node:

| package                                       |     version     |  comment  |
| :-------------------------------------------- | :-------------: | :-------: |
| [go-ycsb](https://github.com/pingcap/go-ycsb) | no requirements | benchmark |


{{< info >}}
You can install [TiUP](https://github.com/pingcap/tiup) as described in [TiKV in 5 Minutes](../../tikv-in-5-minutes).
{{< /info >}}

## Step 2. Deploy a cluster

1. We could use the following topology to deploy our benchmark cluster via `tiup cluster`. **For more information, see [Production Deployment](../../install/production)**
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

2. Save the content above as `topology.yaml`:
```sh
tiup cluster deploy [cluster-name] [cluster-version] topology.yaml
```

3. Start the cluster:
```sh
tiup cluster start [cluster-name]
```

4. You can inspect the cluster information:
```sh
tiup cluster display [cluster-name]
```

## Step 3. Run a YCSB workload

YCSB has six kinds of workloads whose main difference are the portion of different operations. All six workloads have a data set which is similar. Workloads D and E insert records during the test run. Thus, to keep the database size consistent, we recommend the following sequence:
1. Load the database, using workload A's parameter file (workloads/workloada) and the "-load" switch to the client.
2. Run workload A (using workloads/workloada and "-t") for a variety of throughputs.
3. Run workload B (using workloads/workloadb and "-t") for a variety of throughputs.
4. Run workload C (using workloads/workloadc and "-t") for a variety of throughputs.
5. Run workload F (using workloads/workloadf and "-t") for a variety of throughputs.
6. Run workload D (using workloads/workloadd and "-t") for a variety of throughputs. This workload inserts records, increasing the size of the database.
7. Delete the data in the database.
8. Reload the database, using workload E's parameter file (workloads/workloade) and the "-load switch to the client.
9. Run workload E (using workloads/workloade and "-t") for a variety of throughputs. This workload inserts records, increasing the size of the database.

{{< info >}}
If you trying to use more clients to benchmark, check [Running a Workload in Parallel](https://github.com/brianfrankcooper/YCSB/wiki/Running-a-Workload-in-Parallel).
{{< /info >}}

For example, you can load a workload contains 10M records and 30M operations by:

```sh
go-ycsb load tikv -P workloads/workloada -p tikv.pd="10.0.1.1:2379" -p tikv.type="raw" -p recordcount=10000000 -p operationcount=30000000
```

After successfully loaded the data, you can launch it.

```sh
go-ycsb run tikv -P workloads/workloada -p tikv.pd="10.0.1.1:2379" -p tikv.type="raw" -p recordcount=10000000 -p operationcount=30000000
```

You can specify the concurrency of the workload client by `-p threadcount=`. Normally, the number should be the number of virtual CPU cores binded to the machine.

## Step 4. Inspect the benchmark results

While running `go-ycsb`, it will reports workload runtime information like the OPS, latency:

```
...
READ   - Takes(s): 9.7, Count: 110092, OPS: 11380.1, Avg(us): 3822, Min(us): 236, Max(us): 342821, 99th(us): 51000, 99.9th(us): 59000, 99.99th(us): 339000
UPDATE - Takes(s): 9.7, Count: 110353, OPS: 11408.8, Avg(us): 7760, Min(us): 944, Max(us): 344934, 99th(us): 59000, 99.9th(us): 65000, 99.99th(us): 339000
READ   - Takes(s): 19.7, Count: 229147, OPS: 11647.2, Avg(us): 3094, Min(us): 202, Max(us): 342821, 99th(us): 52000, 99.9th(us): 58000, 99.99th(us): 335000
```

It will report the summary of the workload whlie the workload is done.

```
Run finished, takes 4m25.292657267s
READ   - Takes(s): 265.0, Count: 4998359, OPS: 18864.7, Avg(us): 1340, Min(us): 181, Max(us): 342821, 99th(us): 11000, 99.9th(us): 51000, 99.99th(us): 73000
UPDATE - Takes(s): 265.0, Count: 5001641, OPS: 18877.1, Avg(us): 5416, Min(us): 599, Max(us): 1231403, 99th(us): 53000, 99.9th(us): 276000, 99.99th(us): 772000
```

{{< warning >}}
If it report errors like `batch commands send error:EOF`, it relates to this [issue](https://github.com/pingcap/go-ycsb/issues/145).
{{< /warning >}}


## Step 5. Clean up

You can destroy the cluster by:

```sh
tiup cluster destroy [cluster-name]
```