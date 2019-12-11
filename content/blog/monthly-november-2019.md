---
title: This Month in TiKV - November 2019
date: 2019-12-11
author: Ana Hobden
---

As winter descends on the northern hemisphere, we encourage you to keep warm by compiling TiKV! In November we had new minor releases, a new crate release, and some community updates!

Let's take a look!

## Releases

This month our team made 2 minor TiKV releases!

You can review the changelogs here:

* [2.1.18](https://github.com/tikv/tikv/releases/tag/v2.1.18)
* [3.0.6](https://github.com/tikv/tikv/releases/tag/v3.0.6)

Upgrading? Things to note:

* In 3.0.6, [#5697](https://github.com/tikv/tikv/pull/5697) introduced the ability to generate flamegraphs of TiKV at runtime! This means the new [pprof](https://crates.io/crates/pprof) crate has reached stable!
* In 3.0.6, [#5769](https://github.com/tikv/tikv/pull/5769) introduced the ability to modify GC IO limits dynamically with `tikv-ctl`.
* In 3.0.6, [#5440](https://github.com/tikv/tikv/pull/5440) there are new metrics around commit logs duration.

The other changes were minor bugfixes.

## New Community Groups

After several discussions, our community has voted to adopt policies to support the founding of Special Interest Groups (SIGS) and Working Groups (WGs). Long-term SIGs are intended to focus on certain components of TiKV; WGs will focus on short-term, cross-component projects or goals.

[@breeswish] and [@lonng] founded a coprocessor SIG (named copr). Information about their group is [here](https://github.com/tikv/community/tree/master/sig/coprocessor). [@zhangjinpeng1987], [@yiwu-arbug], and [@sunxiaoguang] founded an Engine SIG. You can review their group [here](https://github.com/tikv/community/tree/master/sig/engine).

For WGs, the first WG is the multiple-dc-enhancement group organized by [@hicqu] to better support deployments spanning multiple datacenters and regions.

## `pprof` available

[@Yangkeo] released [pprof](https://github.com/tikv/pprof-rs)! This allows you to profile and collect reports from a running Rust program. It includes a `flamegraph` feature that TiKV now uses.

```rust
let guard = pprof::ProfilerGuard::new(100).unwrap();
// ...
if let Ok(report) = guard.report().build() {
    let file = File::create("flamegraph.svg").unwrap();
    report.flamegraph(file).unwrap();
};
```

{{< figure
    src="/img/blog/monthly-2019/flamegraph.png"
    caption="Generated flamegraph"
    number="" >}}

## Reading materials

* In [Case study: TiKV in JD Cloud](https://www.cncf.io/blog/2019/11/26/case-study-tikv-in-jd-cloud/), the CNCF talked to JD Cloud about how they use more than 10 TiKV clusters. The largest hosts 20 billion rows, and some clusters see workloads of 40k (50% read/ 50% write) operations per second with latencies under 10 milliseconds.
* PingCAP CTO and TiKV founding contributor [@c4pt0r] wrote about how TiKV scales horizonally effectively in [Building a Large-scale Distributed Storage System Based on Raft](https://pingcap.com/blog/building-a-large-scale-distributed-storage-system-based-on-raft/).

## Notable PRs

November was a busy month. Here are some highlights:

* [@nrc] submitted a great refactoring PR in [#5857](https://github.com/tikv/tikv/pull/5857), [#5935](https://github.com/tikv/tikv/pull/5935) and [#5964](https://github.com/tikv/tikv/pull/5964), helping us make TiKV more clean and understanable.
* [@little-wallace] submitted a PR to optimize the conflict check in `prewrite` in [#5846](https://github.com/tikv/tikv/pull/5846).
* [@little-wallace] also submitted a latches scheduler optimization in [#6094]https://github.com/tikv/tikv/pull/6094).
* Numerous vectorization PRs were submitted, enabling even faster coprocessor execution.
* [@wangwangwar] introduced in-place byte encoding in the codec, helping reduce the number of allocations needed in [#6061](https://github.com/tikv/tikv/pull/6061)
* [@brson] moved more code into engine traits as part of our ongoing engine abstraction in [#5790](https://github.com/tikv/tikv/pull/5790) and [#5901](https://github.com/tikv/tikv/pull/5901).
* [@breeswish] taught TiKV about `WriteRef` which helps avoid allocations in `PointGetter` and `ForwardScanner`.
* [@sticnarf] opened a PR to unify our read pools into a single multi-level thread pool in [#5828](https://github.com/tikv/tikv/pull/5828). Work is still early stage, but this PR is very exciting!
* [@hoverbear] implemented a suggestion from [@siddontang] to reduce our binary sizes while maintaining our backtraces and debugging info in [#5820](https://github.com/tikv/tikv/pull/5820).
* [@hunterlxt] taught TiKV to use GRPC's memory quota features in [#5818](https://github.com/tikv/tikv/pull/5818).
* [@glorv] and [@hoverbear] are working on packaging TiKV.

## Notable issues

> TLA+ was firstly used by PingCAP in 2017 to verify the feasibility of a variant of the Percolator transaction model. Different from the original Percolator, TiDB’s model has improved efficiency greatly by supporting primary key and secondary key prewriting concurrently in the prewrite phase. The implementation was problematic at first. Thanks to TLA+, the root cause was clearly identified and targeted changes were applied to enable this optimization. Another application of TLA+ at PingCAP is the correctness verification of the multi-raft region merge algorithm, which provided the necessary confidence before we implemented the feature. There were only 4 members invested in the TLA+ related work, but the rewards are far beyond that.
>
> Engineers at PingCAP believe that TLA+ is necessary when it comes to verifying the correctness of distributed systems and specifying the right system behaviors to avoid future patching. They agree that TLA+ is better at expressing the subtle details which natural languages are not good at.
>
> PingCAP has maintained a repo in Github that records all specifications they wrote and keeps aligning TLA+ specifications with the newly implemented database optimizations. Up to now, there're still active PRs and discussions on verifying new features and bugfixes. Speeches and posts on technical reflections and experience of TLA+ application have been shared with the infra community by PingCAP.


[@lance6716] made a great summary about how TiKV uses TLA+ in this [comment](https://github.com/tikv/tikv/issues/5784#issuecomment-550368389) in [#5784](https://github.com/tikv/tikv/issues/5784), the top discussed issue in November.

[@rleungx] and [@wangwangwar] discussed how we can record system events and DTrace probes in [%3799](https://github.com/tikv/tikv/issues/5799). Monitoring and diagnostics provide critical information to operators to help them undderstand how best to scale TiKV, prevent storage exhaustion, and detect potential network issues.

## Current projects

Here's some of the things our contributors have been working on over the last month:

* [@winkyao] has been coordinating with [@dcalvin], [@gingerkidney], and [@hoverbear] to help prepare TiKV's community structures and processes for future growth. We'd love feedback from contributors! You can see some of the recent changes in [`tikv/community`](https://github.com/tikv/community/).
* [@brson] has been pressing forward on Engine trait abstraction. Track progress on `#engine-trait` on our [chat](https://tikv.org/chat)!
* [@Yangkeo] been working on [`pprof`](https://github.com/tikv/pprof-rs).
* [@overvenus] is continuing work on building TiKV's backup & restore feature.
* [@yiwu-arbug] has been working to improve our RocksDB bindings as well as Titan.
* The `copr` SIG is working on new codecs and more function vectorization.

If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

* [@iswade](https://github.com/iswade)
* [@eminence](https://github.com/eminence)
* [@eminence](https://github.com/eminence)
* [@notginger](https://github.com/notginger)
* [@gauss1314](https://github.com/gauss1314)
* [@waynexia](https://github.com/waynexia)
* [@cireu](https://github.com/cireu)
* [@kornelski](https://github.com/kornelski)
* [@tony612](https://github.com/tony612)
* [@MaiCw4J](https://github.com/MaiCw4J)
* [@AerysNan](https://github.com/AerysNan)
* [@Renkai](https://github.com/Renkai)
* [@TommyCpp](https://github.com/TommyCpp)
* [@wangwangwar](https://github.com/wangwangwar)
* [@ty666](https://github.com/ty666)
* [@tw666](https://github.com/tw666)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover November:

* [2019-11-24](https://pingcap.com/weekly/2019-11-25-tidb-weekly/)
* [2019-11-18](https://pingcap.com/weekly/2019-11-18-tidb-weekly/)
* [2019-11-11](https://pingcap.com/weekly/2019-11-11-tidb-weekly/)
* [2019-11-04](https://pingcap.com/weekly/2019-11-04-tidb-weekly/)

[@breeswish]: https://github.com/
[@lonng]: https://github.com/
[@zhangjinpeng1987]: https://github.com/
[@yiwu-arbug]: https://github.com/
[@sunxiaoguang]: https://github.com/
[@hicqu]: https://github.com/
[@yangkeo]: https://github.com/
[@c4pt0r]: https://github.com/
[@nrc]: https://github.com/
[@little-wallace]: https://github.com/
[@wangwangwar]: https://github.com/
[@sticnarf]: https://github.com/
[@hoverbear]: https://github.com/
[@siddontang]: https://github.com/
[@hunterlxt]: https://github.com/
[@brson]: https://github.com/
[@glorv]: https://github.com/
[@lance6716]: https://github.com/
[@rleungx]: https://github.com/
[@winkyao]: https://github.com/
[@overvenus]: https://github.com/
[@dcalvin]: https://github.com/
[@gingerkidney]: https://github.com/