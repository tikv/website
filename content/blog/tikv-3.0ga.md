---
title: TiKV 3.0 GA Release
date: 2019-07-17
tags: ['Release', 'Announcement']
---

Today we're proud to announce the general availability of TiKV 3.0! Whether spanning hundreds of nodes or storing over a trillion key-value pairs, we've seen our users put TiKV to the test in serious, real-world, production scenarios. In 3.0, we've applied the lessons learned from these deployments to bring a host of new features that can better support users' growing demands.

Before release, TiKV 3.0 additionally underwent an [**official Jepsen test**](https://www.pingcap.com/blog/tidb-passes-jepsen-test-for-snapshot-isolation-and-single-key-linearizability/) with TiDB. It was a huge pleasure to work with Kyle to find new ways to torture test our project!

## Steady at scale

For the 3.0 release, we've improved TiKV by:

* **Optimizing the Raft heartbeat mechanism.** With the [hibernate region](https://github.com/tikv/tikv/blob/118f141f69f961e1b0110fa234ffd75c18210dc5/docs/reference/configuration/raftstore-config.md#hibernate-region) feature, TiKV now adjusts the heartbeat frequency according to region activity. That means you'll see less CPU time and network traffic from idle regions.

* **Distributing Garbage Collection.** A new distributed garbage collector improves performance on large scale clusters dramatically, leading to better stability through more consistent performance.

* **Pessimistic Locking.** It's now possible for TiKV to enforce transactions using pessimistic locking. This means you can take exclusive ownership over a value for a duration, preventing other requests from modifying it.

* **Expanding our coprocessor.** With lots of new or improved functionalities such as vector operations, batch executor, [RPN](https://en.wikipedia.org/wiki/Reverse_Polish_notation) functions, and a work-stealing thread pool model our coprocessor continues to evolve accelerating increasingly powerful queries.

* **Enhancing operator friendliness.** Human or machine, we've empowered our operators to get more out of TiKV by unifying our log format, adding new features to `tikv-ctl`, adding even more in-depth metrics, and serving HTTP based metrics. This makes TiKV easier to operate, inspect, and monitor.

* **Refining request types.** While TiKV previously supported commands like `BatchGet`, 3.0 brings a new `BatchCommands` request type. This allows TiKV to handle batches of requests of differing kinds (such as `Get` and `Put`), leading to less data on the wire and better performance. We also added support for raw reversed scanning, and `Insert` semantics on prewrite.

* **Reducing write amplification.** Inspired by the great ideas from [WiscKey](https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf), we implemented Titan, a key-value plugin that improves write performance for scenarios with value sizes greater than 1KB, and relieves write amplification in certain degrees.

You can see all the changes in detail in the [changelog](https://github.com/tikv/tikv/blob/release-3.0/CHANGELOG.md).

## Improved Performance

Using [`go-ycsb`](https://github.com/pingcap/go-ycsb) we benchmarked TiKV 3.0.0 against TiKV 2.1.14. We benchmarked a cluster of 3 TiKV nodes, 1 PD node, and 1 node running YCSB. We used DigitalOcean `s-8vcpu-32gb` size machines, and you can reproduce the benchmark for yourself using the fully automated terraform script [here](https://github.com/tikv/terraform-tikv-bench).

The settings for YCSB we used were:

* 1KB Value Size
* 100 Field Length
* 10 Field Count
* 3000 Thread Count (per node, so 9000 total)

We're proud to say these results show that TiKV 3.0.0 is the fastest TiKV yet!

{{< figure
    src="/img/blog/tikv-3.0ga/ops.svg"
    caption=""
    number="" >}}

{{< figure
    src="/img/blog/tikv-3.0ga/latency.svg"
    caption=""
    number="" >}}

## A big thanks

We'd especially like to thank our [contributors](https://github.com/tikv/tikv/graphs/contributors) who helped with this release. Whether you were a returning contributor or one of the many new folks we welcomed, **thank you**.

Not a contributor yet? [Let us know](https://github.com/tikv/tikv/issues) if you'd like to get involved with development and help drive forward the future of TiKV.