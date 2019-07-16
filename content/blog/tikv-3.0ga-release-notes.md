---
title: TiKV 3.0 GA Release & Benchmarks
date: 2019-07-08
---

Today we're very proud to announce the general availability of TiKV 3.0! Before release, TiKV 3.0 underwent a rigorous testing regime, including the [official Jepsen test](https://www.pingcap.com/blog/tidb-passes-jepsen-test-for-snapshot-isolation-and-single-key-linearizability/) with TiDB.

In this version, we tackled many problems of stability at massive scales. Whether it's spanning hundreds of nodes or storing over a trillion key-value pairs, we've seen our users and contributors put TiKV to the test in serious, real world, production scenarios. With 3.0, we've taken our ideas and lessons to bring a host of features that can better support these growing demands.

## Steady at scale

In TiKV 3.0 we've improved our system by:

* **Optimizing the Raft heartbeat mechanism.** With the Hibernate Region feature, TiKV now adjusts the heartbeat frequency according to region activity. This means you'll see less CPU time and network traffic from idle regions.

* **Distributing Garbage Collection.** The introduction of a distributed garbage collector improves performance on large scale clusters dramatically, leading to better stability through more consistent performance.

* **Pessimistic Locking.** It's now possible to ask TiKV to treat your transactions pessimistically. This means you can take exclusive ownership over a value for a duration. As Rust developers, we really like the idea of ownership!

* **Expanding our coprocessor.** With lots of new or improved functionalities such as vector operations, batch executor, RPN functions, `work-stealing` thread pool model,  our coprocessor continues to evolve, allowing for more efficient ways to work with your data.

* **Enhancing operator friendliness.** Human or machine, we've empowered our operators to get more out of TiKV by unifying our log format, adding new features to `tikv-ctl`, adding even more in-depth metrics, and serving HTTP based metrics. This makes TiKV easier to operate, inspect, and enjoy.

* **Refining request types.** While TiKV previously supported commands like `BatchGet`, 3.0 brings a new `BatchCommands` request type. This allows TiKV to handle batches of requests of differing kinds (such as `Get` and `Put`), leading to less data on the wire and better performance. We also added support for raw reversed scanning, and `Insert` semantics on prewrite.

* **Reducing write amplification.** Inspired by the great ideas from [WiscKey](https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf), we implemented a storage engine plugin to RocksDB that we dubbed 'Titan'. It works best with larger (>1 KB) values.

You can see all the changes in detail [here](https://github.com/tikv/tikv/blob/release-3.0/CHANGELOG.md).

## Improved Performance

Using [`go-ycsb`](https://github.com/pingcap/go-ycsb) we benchmarked TiKV 3.0.0 against TiKV 2.1.14. We benchmarked a cluster of 3 TiKV nodes, 1 PD node, and 1 node running YCSB. We used DigitalOcean `s-8vcpu-32gb` size machines, and you can reproduce the benchmark for yourself using the fully automated terraform script [here](https://github.com/Hoverbear/tikv-bench).

* 1KB Value Size
* 100 Field Length
* 10 Field Count
* 3000 Thread Count (per node, so 9000 total)

According to these results below, and the real-world experience of our customers, we're proud to say that TiKV 3.0.0 is the fastest, most usable TiKV yet!

### Reading the benchmarks

Since we used 3 YCSB benchers running simultaneously, you can see the results of benchers 1 through 3 below.

For the results, `Takes(s)`, `Count`, and `OPS` are better if they are higher. The final fields detailing `us` units, lower is better.

### Load

2.1.14:

```
1 - INSERT - Takes(s): 27.6, Count: 332998, OPS: 12045.0, Avg(us): 244522, Min(us): 31613, Max(us): 1686185, 95th(us): 415000, 99th(us): 0
2 - INSERT - Takes(s): 28.0, Count: 332999, OPS: 11890.6, Avg(us): 242495, Min(us): 40928, Max(us): 2362282, 95th(us): 389000, 99th(us): 0
3 - INSERT - Takes(s): 30.2, Count: 333000, OPS: 11030.8, Avg(us): 252949, Min(us): 34649, Max(us): 3452374, 95th(us): 452000, 99th(us): 0
```

3.0.0:

```
1 - INSERT - Takes(s): 18.5, Count: 332999, OPS: 17966.8, Avg(us): 158305, Min(us): 1949, Max(us): 3812844, 95th(us): 479000, 99th(us): 1014000
2 - INSERT - Takes(s): 28.0, Count: 333000, OPS: 11885.8, Avg(us): 238947, Min(us): 16070, Max(us): 1212289, 95th(us): 559000, 99th(us): 923000
3 - INSERT - Takes(s): 20.1, Count: 333000, OPS: 16603.8, Avg(us): 180926, Min(us): 6183, Max(us): 1165298, 95th(us): 339000, 99th(us): 543000
```

$$ \frac{17966.8 + 11885.8 + 16603.8}{12045 + 1189.6 + 11030.8} = \frac{46454}{24264} = 1.9 $$

TiKV 3.0.0 has approximately **1.9x better under high pure blind write performance**.

### Workload A - 50% Read / 50% Update

2.1.14:

```
1 - READ - Takes(s): 72.8, Count: 499639, OPS: 6860.7, Avg(us): 90716, Min(us): 442, Max(us): 7438914, 95th(us): 269000, 99th(us): 728000
2 - READ - Takes(s): 73.1, Count: 498838, OPS: 6821.9, Avg(us): 85603, Min(us): 418, Max(us): 3648798, 95th(us): 263000, 99th(us): 795000
3 - READ - Takes(s): 70.0, Count: 499962, OPS: 7138.6, Avg(us): 84602, Min(us): 493, Max(us): 3537165, 95th(us): 277000, 99th(us): 745000
1 - UPDATE - Takes(s): 72.6, Count: 499361, OPS: 6874.1, Avg(us): 329769, Min(us): 8071, Max(us): 9178405, 95th(us): 705000, 99th(us): 0
2 - UPDATE - Takes(s): 73.0, Count: 500162, OPS: 6849.9, Avg(us): 323671, Min(us): 9191, Max(us): 5400125, 95th(us): 711000, 99th(us): 0
3 - UPDATE - Takes(s): 69.8, Count: 499037, OPS: 7151.3, Avg(us): 319998, Min(us): 9771, Max(us): 4611633, 95th(us): 721000, 99th(us): 0
```

3.0.0:

```
1 - READ - Takes(s): 67.2, Count: 499803, OPS: 7435.7, Avg(us): 49039, Min(us): 418, Max(us): 5944697, 95th(us): 98000, 99th(us): 407000
2 - READ - Takes(s): 60.4, Count: 499945, OPS: 8271.7, Avg(us): 36091, Min(us): 362, Max(us): 3075800, 95th(us): 98000, 99th(us): 310000
3 - READ - Takes(s): 62.1, Count: 499120, OPS: 8035.4, Avg(us): 41641, Min(us): 354, Max(us): 3054153, 95th(us): 107000, 99th(us): 327000
1 - UPDATE - Takes(s): 67.1, Count: 499197, OPS: 7434.4, Avg(us): 322869, Min(us): 2069, Max(us): 6116491, 95th(us): 896000, 99th(us): 0
2 - UPDATE - Takes(s): 60.4, Count: 499055, OPS: 8259.1, Avg(us): 300100, Min(us): 3042, Max(us): 5832169, 95th(us): 826000, 99th(us): 0
3 - UPDATE - Takes(s): 62.1, Count: 499880, OPS: 8054.1, Avg(us): 306264, Min(us): 2242, Max(us): 5717033, 95th(us): 831000, 99th(us): 0
```

$$ \frac{7435.7 + 8271.7 + 8035.4}{6860.7 + 6821.9 + 7138.6} = \frac{23742.8}{20821.2} = 1.14 $$

TiKV 3.0.0 has approximately **1.14x better read performance while under a 50% read / 50% update workload.**

$$ \frac{7434.4 + 8259.1 + 8054.1}{6874.1 + 6849.9 + 7151.3} = \frac{23747.6}{20875.3} = 1.14 $$

TiKV 3.0.0 has approximately **1.14x better update performance while under a 50% read / 50% update workload.**

### Workload B - 95% Read / 5% Update

2.1.14:

```
1 - READ - Takes(s): 36.2, Count: 949223, OPS: 26205.6, Avg(us): 93017, Min(us): 473, Max(us): 1898200, 95th(us): 202000, 99th(us): 384000
2 - READ - Takes(s): 38.3, Count: 948678, OPS: 24746.9, Avg(us): 94071, Min(us): 433, Max(us): 1310532, 95th(us): 198000, 99th(us): 373000
3 - READ - Takes(s): 41.2, Count: 948576, OPS: 23002.5, Avg(us): 101087, Min(us): 506, Max(us): 3573196, 95th(us): 217000, 99th(us): 412000
1 - UPDATE - Takes(s): 36.1, Count: 49777, OPS: 1378.2, Avg(us): 337220, Min(us): 10130, Max(us): 3153989, 95th(us): 679000, 99th(us): 0
2 - UPDATE - Takes(s): 38.2, Count: 50322, OPS: 1317.1, Avg(us): 361260, Min(us): 9240, Max(us): 2997818, 95th(us): 708000, 99th(us): 0
3 - UPDATE - Takes(s): 41.2, Count: 50424, OPS: 1224.5, Avg(us): 364278, Min(us): 8801, Max(us): 3719113, 95th(us): 716000, 99th(us): 0
```

3.0.0:

```
1 - READ - Takes(s): 24.1, Count: 948742, OPS: 39384.2, Avg(us): 60633, Min(us): 546, Max(us): 1945108, 95th(us): 150000, 99th(us): 351000
2 - READ - Takes(s): 19.8, Count: 949315, OPS: 47917.6, Avg(us): 46491, Min(us): 365, Max(us): 1820360, 95th(us): 118000, 99th(us): 290000
3 - READ - Takes(s): 23.5, Count: 948784, OPS: 40378.4, Avg(us): 56232, Min(us): 470, Max(us): 1700652, 95th(us): 146000, 99th(us): 320000
1 - UPDATE - Takes(s): 24.0, Count: 50256, OPS: 2094.5, Avg(us): 214978, Min(us): 6402, Max(us): 2080028, 95th(us): 488000, 99th(us): 721000
2 - UPDATE - Takes(s): 19.7, Count: 49685, OPS: 2520.7, Avg(us): 228188, Min(us): 11063, Max(us): 2081087, 95th(us): 592000, 99th(us): 0
3 - UPDATE - Takes(s): 23.4, Count: 50216, OPS: 2144.4, Avg(us): 234702, Min(us): 17188, Max(us): 1746959, 95th(us): 597000, 99th(us): 0
```

$$ \frac{39384.2 + 47917.6 + 40378.4}{26205.6 + 24746.9 + 23002.5} = \frac{127680.2}{73955} = 1.73 $$

TiKV 3.0.0 has approximately **1.73x better read performance while under a 95% read / 5% update workload.**

$$ \frac{2094.5 + 2520.7 + 2144.4}{1378.2 + 1317.1 + 1224.5} = \frac{6759.6}{3919.8} = 1.72 $$

TiKV 3.0.0 has approximately **1.72x better update performance while under a 95% read / 5% update workload.**

### Workload C - 100% Read

2.1.14:

```
1 - READ - Takes(s): 31.3, Count: 999000, OPS: 31967.8, Avg(us): 91216, Min(us): 495, Max(us): 2107986, 95th(us): 213000, 99th(us): 438000
2 - READ - Takes(s): 30.3, Count: 999000, OPS: 32946.6, Avg(us): 81638, Min(us): 384, Max(us): 1174158, 95th(us): 188000, 99th(us): 391000
3 - READ - Takes(s): 29.8, Count: 999000, OPS: 33495.9, Avg(us): 87190, Min(us): 491, Max(us): 1715646, 95th(us): 195000, 99th(us): 384000

```

3.0.0:

```
1 - READ - Takes(s): 24.0, Count: 999000, OPS: 41599.0, Avg(us): 64914, Min(us): 587, Max(us): 7320130, 95th(us): 137000, 99th(us): 466000
2 - READ - Takes(s): 18.0, Count: 999000, OPS: 55351.7, Avg(us): 51959, Min(us): 454, Max(us): 1070117, 95th(us): 140000, 99th(us): 333000
3 - READ - Takes(s): 21.0, Count: 999000, OPS: 47659.2, Avg(us): 59935, Min(us): 440, Max(us): 1768322, 95th(us): 157000, 99th(us): 385000
```

$$ \frac{41599.0 + 55351.7 + 47659.2}{31967.8 + 32946.6 + 33495.9} = \frac{144609.9}{98410.3} = 1.47 $$

TiKV 3.0.0 has approximately **1.47x better read performance while under a pure read workload.**

## A big thanks

We'd especially like to thank our contributors who helped with this release. Whether you were a returning contributor or one of the many new folks we welcomed, **thank you**.

Not a contributor yet? [Let us know](https://github.com/tikv/tikv/issues) if you'd like to get involved with development and help drive forward the future of TiKV.