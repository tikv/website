---
title: Overview
description: How to make a benchmark over a TiKV cluster
menu:
    "5.1":
        parent: Performance
        weight: 5
---

TiKV delivers predictable throughput and latency at all scales on commodity hardware. This document provides an overview of the performance profiles you can expect, based on PingCAP's testing using industry-standard benchmarks [YCSB](https://github.com/brianfrankcooper/YCSB)

For instructions to reproduce the TPC-C results listed here, see [Benchmark Instructions](./instructions.md). If you fail to achieve similar results, there is likely a problem in either the hardware, workload, or test design.

## Baseline

The goal of the YCSB project is to develop a framework and common set of workloads for evaluating the performance of different "key-value" and "cloud" serving stores. **A 3-node TiKV cluster could achieve at most 200,000 OPS and <10ms latency in a 10M records and 10M operations YCSB workload.**

For a refresher on what exactly YCSB is and how it is measured, see [the official instructions to the core YCSB workload](https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads)

TiKV achieves this performance in [linearizability](https://en.wikipedia.org/wiki/Linearizability), a strong correctness condition, which constrains what outputs are possible when an object is accessed by multiple processes concurrently.

We will give a demonstration to the benchmark result of a 3-node TiKV cluster with different client concurrency to give a big picture of the throughput and latency of TiKV.

# Cluster Configuration

We deploy a 3-node cluster in our private cloud environment with the following node configuration.

| CPU                                                        | Memory | Disk             | Mode  |
| ---------------------------------------------------------- | ------ | ---------------- | ----- |
| 40 virtual CPUs, Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz | 64GiB  | 500GiB NVMEe SSD | RawKV |

We also deploy a 12-pod cluster to simulate a large workload. Each pod is allocated with 40 threads to run a YSCB workload with 10M operations over a dataset contains 10M records.

## Throughput

On a 3-node cluster of configuration listed above, TiKV can achieve 212,000 point get read per second on the YCSB workloadc and 43,200 update per second on the YCSB workloada. With diffrent concurrency, the throughput change is shown in [Figure 1](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=1044850259&format=interactive).

{{< figure
    src="/img/docs/ycsb-throughput.svg"
    caption="YCSB throughput"
    width="1000"
    number="1" >}}


## Latency

TiKV fits to latency-sensitive service, we could achieve <10ms average latency even in a high pressure throughput. You can check the average latency in [Figure 2](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=334435174&format=interactive).

{{< figure
    src="/img/docs/avg-latency.svg"
    caption="YCSB latency"
    width="1000"
    number="1" >}}

For the 99th percentile latency, see [Figure 3](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=6574505&format=interactive)

{{< figure
    src="/img/docs/99-latency.svg"
    caption="YCSB 99th percentile latency"
    width="1000"
    number="1" >}}

## Performance limitations

For now, with more replication factor, the latency of TiKV would increase linearly. In addition, under heavily write worload, the write latency will increase more faster than the read latency. Practically, we will be improving bottlenecks and addressing challenges over the next several releases.


## See also

* If you are interested in the rest of benchmark result, see this [sheet](https://docs.google.com/spreadsheets/d/1VjzC3IxCiqGQmSUgRxewgExE3c32YiZMUKNsKDuvrPg/edit?usp=sharing).