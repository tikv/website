---
title: Performance Overview
description: An overview of TiKV performance
menu:
    "5.1":
        parent: Benchmark and Performance
        weight: 5
---

 
TiKV can deliver predictable throughput and latency at all scales on requiring hardware. This document provides an overview of TiKV benchmark performance on throughput and latency.

To learn how to reproduce the benchmark results in this document, see [Benchmark Instructions](../instructions). If you do not achieve similar results, check whether your hardware, workload, and test design meet the requirements in this document.

## Baseline

The TiKV performance in this document is evaluated using [GO YCSB](https://github.com/pingcap/go-ycsb), which is the Go version of the industry-standard [Yahoo! Cloud Serving Benchmark (YCSB)](https://github.com/brianfrankcooper/YCSB).

The goal of the YCSB project is to develop a framework and common set of workloads for evaluating the performance of different key-value and cloud serving stores. For more information about how YCSB is measured, see [Core Workload](https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads).

## Cluster configuration

To provide the overall performance of TiKV throughput and latency, the benchmark in this document uses a 3-node TiKV cluster with different client concurrencies.

The configuration of the 3-node cluster is as follows:

| CPU                                                        | Memory | Disk             | Mode  |
| ---------------------------------------------------------- | ------ | ---------------- | ----- |
| 40 virtual CPUs, Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz | 64GiB  | 500GiB NVMEe SSD | RawKV |

In addition, a 12-pod cluster is deployed to simulate a large workload. Each pod is allocated with 40 threads to run a YSCB workload with 10M operations over a dataset with 10M records.

## Benchmark results

The results show that **A 3-node TiKV cluster achieves at most 200,000 OPS within 10 ms latency in a 10M records and 10M operations YCSB workload**.

TiKV achieves this performance in [linearizability](https://en.wikipedia.org/wiki/Linearizability), a strong correctness condition, which constrains what outputs are possible when an object is accessed by multiple processes concurrently.

### Throughput

On a 3-node cluster of configuration listed above, TiKV can achieve 212,000 point get read per second on the YCSB workloadc and 43,200 update per second on the YCSB workloada. With different concurrencies, the throughput changes are shown in [Figure 1](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=1044850259&format=interactive).

{{< figure
    src="/img/docs/ycsb-throughput.svg"
    caption="YCSB throughput"
    width="1000"
    number="1" >}}

### Latency

TiKV is suitable for delay-sensitive services. Even at a high pressure throughput, the average latency is less than 10 ms, as shown in [Figure 2](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=334435174&format=interactive).

{{< figure
    src="/img/docs/avg-latency.svg"
    caption="YCSB latency"
    width="1000"
    number="2" >}}

For the 99th percentile latency, see [Figure 3](https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=6574505&format=interactive).

{{< figure
    src="/img/docs/99-latency.svg"
    caption="YCSB 99th percentile latency"
    width="1000"
    number="3" >}}

## Performance limitations

For the current TiKV release, if replication factors increase, the TiKV latency increases linearly. In addition, under heavily write workload, the write latency increases much faster than the read latency. For the next several releases, more improvements will be made to address the limitations.

## See also

* If you are interested in more benchmark results, see this [sheet](https://docs.google.com/spreadsheets/d/1VjzC3IxCiqGQmSUgRxewgExE3c32YiZMUKNsKDuvrPg/edit?usp=sharing).
