---
title: TiKV 3.0 GA Release Notes
date: 2019-07-08
---
Today we're very proud to announce the general availability of TiKV 3.0! Before release, TiKV 3.0 underwent a rigorous testing, including an [official Jepsen test](https://www.pingcap.com/blog/tidb-passes-jepsen-test-for-snapshot-isolation-and-single-key-linearizability/) with TiDB.

In this version, we tackled the problem of stability at massive scales. Whether it's spanning hundreds of nodes, or storing over a trillion key-value pairs, we've seen our users and contributors put TiKV to the test in serious, real world, production scenarios. With 3.0, we've taken our ideas and lessons to bring a host of features that can better support these growing demands.

## Steady at scale

In TiKV 3.0 we've improved our system by:

* **Optimizing the Raft heartbeat mechanism.** TiKV now adjusts the heartbeat frequency according to region activity. This means you'll see less CPU time and network traffic from idle regions.

* **Distributing Garbage Collection.** The introduction of a distributed garbage collector improves performance on large scale clusters dramatically, leading to better stability though more consistent performance.

* **Pessimistic Locking.** It's now possible to ask TiKV to treat your transactions pessimistically. This means you can take exclusive ownership over a value for a duration. As Rust developers, we really like the idea of ownership!

* **Expanding our coprocessor.** With lots of new or improved functionalities such as vector operations, batch executor, RPN functions, `work-stealing` thread pool model,  our coprocessor continues to evolve, allowing for more efficient ways to work with your data.

* **Enhancing operator friendliness.** Human or machine, we've empowered our operators to get more out of TiKV by unifying our log format, adding new features to `tikv-ctl`, adding even more in depth metrics, and serving HTTP based metrics. This makes TiKV easier to operate, inspect, and enjoy.

* **Refining request types.** While TiKV previously supported commands like `BatchGet`, 3.0 brings a new `BatchCommands` request type. This allows TiKV to handle batches of requests of differing kinds, leading to less data on the wire and better performance. We also added support for raw reversed scanning, and `Insert` semantics on prewrite.

* **Reducing write amplication.** We were inspired by the great ideas from [WiscKey](https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf) and implemented a feature we dubbed 'Titan'. It works best with larger (>1 KB) values.

You can see all the changes in detail [here](https://github.com/tikv/tikv/blob/release-3.0/CHANGELOG.md).

## Improved Performance

Using [`go-ycsb`](https://github.com/pingcap/go-ycsb) we benchmarked TiKV 3.0.0-rc.2 against TiKV 2.1.12. We benchmarked a cluster of 3 TiKV nodes and 1 PD node. They were running on public cloud machines with 16 cores, 32 GB of RAM, a 400 GB NVMe SSD, and a 10Gbps network. We used the default settings of TiKV and PD for this.

In order to achieve high concurrency and properly stress the system, we ran YCSB across three machines and set the following:

* 1KB Value Size
* 100 Field Length
* 10 Field Count
* 3000 Thread Count (for each machine, so a total of 9000)

| Workload              | operation | 2.1.12 Avg Latency | 3.0.0-rc.2 Avg Latency | 2.1.12 QPS | 3.0.0-rc.2 QPS | QPS Diff |
|-----------------------|-----------|--------------------|------------------------|------------|----------------|----------|
| A 50% read/50% update | read      | 4.908              | 1.971                  | 40645.7    | 43159.2        | +6.18%   |
|                       | update    | 206.649            | 197.140                | 40635.7    | 43186.5        | +6.28%   |
| B 95% read/5% update  | read      | 28.121             | 13.967                 | 247164.1   | 542027.0       | +119.30% |
|                       | update    | 132.953            | 43.307                 | 12988.6    | 28632.4        | +120.44% |
| C 100% read           | read      | 31.056             | 14.583                 | 282752.8   | 606659.5       | +114.55% |
| Load (10 MB)          | insert    | 198.764            | 217.901                | 44743.5    | 40819.9        | -8.77%   |

In the meantime, PingCAP has also published benchmarks that showcases the performance of TiKV paired with TiDB, the MySQL speaking query layer TiKV was originally created to compliment. You can find those benchmarks, and how to reproduce them, [**here**](https://github.com/pingcap/docs/tree/master/v3.0/benchmark).

## A big thanks

We'd especially like to thank our contributors who helped with this release. Whether you were a returning contributor or one of the many new folks we welcomed, **thank you**.

Not a contributor yet? [Let us know](https://github.com/tikv/tikv/issues) if you'd like to get involved with development and help drive forward the future of TiKV.