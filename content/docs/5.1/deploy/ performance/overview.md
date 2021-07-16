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

# Baseline

The goal of the YCSB project is to develop a framework and common set of workloads for evaluating the performance of different "key-value" and "cloud" serving stores. **A 3-node TiKV cluster could achieve at most 200,000 OPS and <10ms latency in a 10M records and 10M operations YCSB workload.**

For a refresher on what exactly YCSB is and how it is measured, see [the official instructions to the core YCSB workload](https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads)

TiKV achieves this performance in [linearizability](https://en.wikipedia.org/wiki/Linearizability), a strong correctness condition, which constrains what outputs are possible when an object is accessed by multiple processes concurrently.

We will give a demonstration to the benchmark result of a 3-node TiKV cluster with different client concurrency to give a big picture of the throughput and latency of TiKV.

# Cluster Configuration

# Throughput

