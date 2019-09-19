---
title: This Month in TiKV - August 2019
date: 2019-09-18
author: Ana Hobden
---

# This month in TiKV: August 2019

Happy day! Welcome to the second edition of 'This Month in TiKV', covering August 2019. (Yes we know it's later than the first week of September, sorry!)

The TiKV authors have been busy working on improving stability, fixing bugs, and laying out the foundations of TiKV 4.0. That is a lot to cover, so let's get started!

## News

This month our team made four TiKV minor releases! These minor releases include bug fixes and minor, backwards compatible features.

You can review the changelogs here:

* [3.0.3](https://github.com/tikv/tikv/releases/tag/v3.0.3)
* [3.0.2](https://github.com/tikv/tikv/releases/tag/v3.0.2)
* [2.1.17](https://github.com/tikv/tikv/releases/tag/v2.1.17)
* [2.1.16](https://github.com/tikv/tikv/releases/tag/v2.1.16)

Upgrading? Please take note of these things:

* In **2.1.17 and 3.0.3** a new `config-check` option allows you to verify a configuration is correct before trying to start a node with it.
* In **3.0.2** some logs which require no manual intervention (TiKV resolves them automatically) were reduced to `INFO` level.
* In **2.1.16** `raw_scan` and `raw_batch_scan` now supports reverse.

## Reading materials

Here are some articles our contributors have published over the last month:

* [@sunxiaoguang] published some details of the deployment including TiKV at Zhihu in [Lesson Learned from Queries over 1.3 Trillion Rows of Data Within Milliseconds of Response Time at Zhihu.com](https://pingcap.com/success-stories/lesson-learned-from-queries-over-1.3-trillion-rows-of-data-within-milliseconds-of-response-time-at-zhihu/). Some highlights from the article are:
    - 1.3 trillion records, growing ~3 billion per day.
    - 12 million queries processed per second at peak.
    - Sub-90ms response time.
* [@aknuds1] published [Practical Networked Applications in Rust, Part 2: Networked Key-Value Store](https://arveknudsen.com/posts/practical-networked-applications-in-rust/module-2/) where he explores the [Rust training course](https://github.com/pingcap/talent-plan/tree/master/rust) created by [@brson] and [@sticnarf].
* [@siddontang] published [Porting TiDB to ARM64 for Greater Flexibility](https://pingcap.com/blog/porting-tidb-to-arm64-for-greater-flexibility/) where he explores building and benchmarking TiKV and TiDB on ARM64 architectures.
* [@ethercflow] published a follow up article how [TCP Small Queues become a bottleneck for our test deployments on ARM64 architectures](https://pingcap.com/blog/how-tsq-becomes-a-performance-bottleneck-for-tikv-in-aws-arm-environment/).
* [@c4pt0r] published [(CN) A Talk about the New Features of TiDB: From Follower Read](https://pingcap.com/blog-cn/follower-read-the-new-features-of-tidb/) where he discusses follower read, a new feature we're planning for TiKV to be leveraged by query layers like TiDB.
* [@zhangjinpeng1987] published a new [(CN) Source Code Reading: Distributed Transactions](https://pingcap.com/blog-cn/tikv-source-code-reading-12/) discussing the transaction model powering TiKV.

## Roadmap

We've also began nailing down which features we want to include in a future TiKV 4.0 release. Here's a few of our hopes and dreams:

> (This is not an official list and may be subject to change)

* Publish our RocksDB wrapper as `tirocks` on [crates.io](https://crates.io/crates/tirocks/).
* Abstract our engine so that we adapt to other storage technologies and offer more flexibility.
* Begin adopting Joint Consensus, first to allow our clusters to more safely replace nodes in running deployments.
* Further battle-hardening and improvements to the Titan storage backend.
* Follower Snapshot, allowing new follows to catch up to the rest of a cluster without placing load on the current leaders.
* Support Quiescent Region, reducing the heartbeats of inactive ('cold') regions.
* Further coprocessor support and better documentation around coprocessor functionality, making it even easier to [make your first contribution to TiKV](https://pingcap.com/blog/adding-built-in-functions-to-tikv/).
* A 1.0.0 release of our Rust client, along with more improvements to our other clients.
* Reduce WAL usage to lower write pressure.

## Notable PRs

* In TiKV 2.1.17 gRPC was upgraded to fix a segfault causing abnormal exits [#5441](https://github.com/tikv/tikv/pull/5441).
* In TiKV 2.1.17 and 3.0.3 incorrect timestamps should no longer be reported from a Region [#5296](https://github.com/tikv/tikv/pull/5296).
* In TiKV 3.0.3 a possible request drop from ReadIndex when there is no leader was fixed [#5316](https://github.com/tikv/tikv/pull/5316).
* TiKV 2.1.16 now returns region errors when closing so the client will retry on other nodes [#4820](https://github.com/tikv/tikv/pull/4820).
* In TiKV 3.0.2 we fixed a bug in constraint checking during insertion when pessimistic transactions are enabled [#5128](https://.github.com/tikv/tikv/pull/5128).
* In TiKV 3.0.2 we fixed the problem that TiKV loses some logs while panicking [#5174](https://github.com/tikv/tikv/pull/5174).
* [@fullstop000] has a draft of Follower Replication for Raft [pingcap/raft#249](https://github.com/pingcap/raft-rs/issues/136).
* [@nrc] opened a PR to enable both prost and rust-protobuf to be used in TiKV [#5379](https://github.com/tikv/tikv/pull/5379).
* [@sticnarf] opened a series of PRs to begin enabling transaction support in the Rust client [tikv/client-rust#108](https://github.com/tikv/client-rust/pull/108), [tikv/client-rust#97](https://github.com/tikv/client-rust/pull/97), [tikv/client-rust#92](https://github.com/tikv/client-rust/pull/92).
* [@MyonKeminta] opened [#5497](https://github.com/tikv/tikv/pull/5407) and [#5390](https://github.com/tikv/tikv/pull/5390) to forward larger transaction support.

## Notable issues

* In TiKV 2.1.15 and 2.1.16, region statistics may not be correct [#5306](https://github.com/tikv/tikv/issues/5306). Fixed in [#5415](https://github.com/tikv/tikv/pull/5415) and released as part of 2.1.17.
* In TiKV 3.0 rc2 to 3.0.2, ReadIndex might fail to respond to requests due to a duplicate context [#4764](https://github.com/tikv/tikv/issues/4764). Fixed in [#5213](https://github.com/tikv/tikv/pull/5213) and released as part of 3.0.3.
* In TiKV [#5291](https://github.com/tikv/tikv/pull/5291) we discovered a possible panic during region merge. Fixed in [#5291](https://github.com/tikv/tikv/pull/5291) and released in 3.0.3.
* In [#4560](https://github.com/tikv/tikv/issues/4560) and [#4581](https://github.com/tikv/tikv/issues/4581) we discovered a possible panic while catching up after a restart. Fixed in [#4595](https://github.com/tikv/tikv/pull/4595) and released in 3.0.2.

## Current projects

Here's some of the things our contributors have been working on over the last month:

* [@sticnarf] and [@nrc] have been working on transaction support in our Rust Client.
* [@fullstop000] has been working to implement follower replication in Raft, for future use in TiKV.
* [@hicqu]has been leading the effort on supporting Joint Consensus in TiKV.
* Several members of the [@pingcap] team have been working on further shrinking and optimizing TiKV's build graph, resulting in faster compile times and less dependencies.
* [@zhouqiang-cl] and [@hoverbear] have been working on improving our release process and docker containers.
* [@dcalvin] and [@hoverbear] have been overhauling the TiKV.org documentation to better support our users.
* [@busyjay] and [@nrc] have been collaborating to land the final PRs to support using [Prost](https://github.com/danburkert/prost) library.
* [@nrc] has been working on Prost to help land some optimizations.
* [@overvenus] has been driving forward our new backup and restore process for TiKV.
* [@MyonKeminta] has been leading on refining and hardening our experimental pessimistic transaction support.
* [@zhouqiang-cl]'s team at [@pingcap] has been working to improve our CI and automation to help reduce time-to-merge, expand testing, and improve automation.
* [@yiwu-arbug] and [Connor1996] are battle hardening Titan and incorporating feedback from some of our users.
* [@sunxiaoguang] has been battle testing TiKV on massive, China-scale workloads at Zhihu ([See his article!](https://pingcap.com/success-stories/lesson-learned-from-queries-over-1.3-trillion-rows-of-data-within-milliseconds-of-response-time-at-zhihu/))
* [@busyjay] and [@zhangjinpeng1987] have been evaluating bloom filters.
* [@5kbpers], [@brson] and [@aknuds1] have begun work on the engine abstraction project.
* [@MyonKeminta] has been driving a project to facilitate larger transactions.

If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following [new contributors to TiKV](https://tikv.devstats.cncf.io/d/52/new-contributors-table?orgId=1&from=1564642800000&to=1567321140000) and thank them for their work!

* [@jiyingtk]
* [@eurekaka]
* [@jarifibrahim]
* [@ethan-daocloud]
* [@marsishandsome]
* [@you06]
* [@wujy-cs]
* [@928234269]
* [@lucklove]

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover August,

* [2019-08-04](https://pingcap.com/weekly/2019-08-05-tidb-weekly/)
* [2019-08-12](https://pingcap.com/weekly/2019-08-12-tidb-weekly/)
* [2019-08-19](https://pingcap.com/weekly/2019-08-19-tidb-weekly/)
* [2019-08-26](https://pingcap.com/weekly/2019-08-26-tidb-weekly/)

[@sunxiaoguang]: https://github.com/sunxiaoguang
[@hoverbear]: https://github.com/hoverbear/
[@sticnarf]: https://github.com/sticnarf/
[@akunds1]: https://github.com/aknuds1
[@nrc]: https://github.com/nrc/
[@fullstop000]: https://github.com/Fullstop000
[@hicqu]: https://github.com/hicqu
[@pingcap]: https://github.com/pingcap/
[@zhouqiang-cl]: https://github.com/zhouqiang-cl
[@hoverbear]: https://github.com/hoverbear/
[@dcalvin]: https://github.com/dcalvin/
[@busyjay]: https://github.com/busyjay/
[@jiyingtk]: https://github.com/jiyingtk/
[@eurekaka]: https://github.com/eurekaka/
[@jarifibrahim]: https://github.com/jarifibrahim
[@ethan-daocloud]: https://github.com/ethan-daocloud
[@marsishandsome]: https://github.com/marsishandsome
[@you06]: https://github.com/you06
[@wujy-cs]: https://github.com/wujy-cs
[@928234269]: https://github.com/928234269
[@lucklove]: https://github.com/lucklove
[@siddontang]: https://github.com/siddontang
[@c4pt0r]: https://github.com/c4pt0r
[@ethercflow]: https://github.com/ethercflow
[@zhangjinpeng1987]: https://github.com/zhangjinpeng1987
[@overvenus]: https://github.com/overvenus
[@MyonKeminta]: https://github.com/MyonKeminta
[@yiwu-arbug]: https://github.com/yiwu-arbug
[@connor1996]: https://github.com/connor1996
[@brson]: https://github.com/brson
[@aknuds1]: https://github.com/aknuds1
[@5kbpers]: https://github.com/5kbpers
[@youjiali1995]: https://github.com/youjiali1995