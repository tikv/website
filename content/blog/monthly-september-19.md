---
title: This Month in TiKV - September 2019
date: 2019-10-18
author: Ana Hobden
---

Wonderful day! Welcome to the third edition of 'This Month in TiKV', covering September 2019.

## News

This month our team made one TiKV minor release! This minor releases include bug fixes and minor, backwards compatible features.

You can review the changelogs here:

* [3.0.4](https://github.com/tikv/tikv/releases/tag/v3.0.4)

Upgrading? Please take note of these things:

* There is a new batch split region command.
* There is a new `grpc-memory-pool-quota` configuration option.

## Reading materials

Here are some articles our contributors have published over the last month:

* [@AndreMouche] published an article teaching about [TiKV's MVCC implementation (Chinese)](https://pingcap.com/blog-cn/tikv-source-code-reading-13/).
* [@nrc] talked on his blog about [migrating projects from Futures 0.1 to 0.3](https://www.ncameron.org/blog/migrating-a-crate-from-futures-0-1-to-0-3/).
* [@yiwu-arbug] and [@pentium3] write about automatically tuning TiKV with [AutoTiKV (Chinese)](https://pingcap.com/blog-cn/autotikv/).

## Notable PRs

* [@overvenus] submitted a PR to add tests for our upcoming backup mechanism [#5486](https://github.com/tikv/tikv/pull/5486).
* [@overvenus] enabled the backup feature [#5476](https://github.com/tikv/tikv/pull/5476).
* [@5kbpers] added some traits related to our ongoing engine abstraction [#5445](https://github.com/tikv/tikv/pull/5445).
* [@5kbpers] allowed the handling of read index requests with a lease, saving 1 round trip [#5401](https://github.com/tikv/tikv/pull/5401).
* [@niedhui] forwarded our efforts to use new, more efficient codecs in our coprocessor [#5496](https://github.com/tikv/tikv/pull/5496).
* [@niedhui] updated some of our cryptographic dependencies [#3886](https://github.com/tikv/tikv/pull/3886).
* [@jing118] added some metrics regarding jemalloc [#5448](https://github.com/tikv/tikv/pull/5448).
* [@aknuds1] added a default `--pd-endpoint` pointing to `localhost` [#5427](https://github.com/tikv/tikv/pull/5427).
* [@nrc] improved our use of unsafe in TiKV [#5413](https://github.com/tikv/tikv/pull/5413).
* [@nrc] pruned around 11% of our dependencies, resulting in faster builds and no more warnings from `cargo audit` [#5454](https://github.com/tikv/tikv/pull/5454).
* [@brson] extracted the `sst_importer` module as part of our ongoing modularization efforts [#5438](https://github.com/tikv/tikv/pull/5438).
* [@hoverbear] re-enabled the use of `cargo run` by specifiying the `default-members` [#5439](https://github.com/tikv/tikv/pull/5439).
* [@hoverbear] made sure jemalloc was only a depedency if using the `jemalloc` feature [#5299](https://github.com/tikv/tikv/pull/5299)

## Notable issues

* [@disksing] opened an issue regarding how to best handle TiKV panics [#5564](https://github.com/tikv/tikv/issues/5564).
* [@nrc] posted an issue regarding TiKV adopting async/await [#5542](https://github.com/tikv/tikv/issues/5542).
* [@siddontang] suggested we use an independent arena for gRPC allocation [#5472](https://github.com/tikv/tikv/issues/5472).

## Current projects

Here's some of the things our contributors have been working on over the last month:

* [@brson], [@5kbpers], and [@akunds1] is continuing to work on our engine abstraction.
* [@zhouqiang-cl] and his team are working on further improving the sre-bot.
* [@overvenus] has been leading the efforts to finish the backup feature.


If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following [new contributors to TiKV](https://tikv.devstats.cncf.io/d/52/new-contributors-table?orgId=1&from=1564642800000&to=1567321140000) and thank them for their work!

* [@jadireddi]
* [@aknuds1]
* [@gengliqi]
* [@NingLin-P]
* [@it2911]
* [@guliangliangatpingcap]
* [@Jing118]
* [@pentium3]
* [@wshwsh12]

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover September,

* [2019-09-02](https://pingcap.com/weekly/2019-09-02-tidb-weekly/)
* [2019-09-08](https://pingcap.com/weekly/2019-09-02-tidb-weekly/)
* [2019-09-15](https://pingcap.com/weekly/2019-09-16-tidb-weekly/)
* [2019-09-22](https://pingcap.com/weekly/2019-09-23-tidb-weekly/)
* [2019-09-29](https://pingcap.com/weekly/2019-09-30-tidb-weekly/)

[@AndreMouche]: https://github.com/AndreMouche
[@hoverbear]: https://github.com/hoverbear/
[@sticnarf]: https://github.com/sticnarf/
[@akunds1]: https://github.com/aknuds1
[@nrc]: https://github.com/nrc/
[@pingcap]: https://github.com/pingcap/
[@zhouqiang-cl]: https://github.com/zhouqiang-cl
[@hoverbear]: https://github.com/hoverbear/
[@siddontang]: https://github.com/siddontang
[@c4pt0r]: https://github.com/c4pt0r
[@ethercflow]: https://github.com/ethercflow
[@zhangjinpeng1987]: https://github.com/zhangjinpeng1987
[@overvenus]: https://github.com/overvenus
[@MyonKeminta]: https://github.com/MyonKeminta
[@yiwu-arbug]: https://github.com/yiwu-arbug
[@connor1996]: https://github.com/connor1996
[@niedhui]: https://github.com/niedhui
[@disksing]: https://github.com/disksing
[@brson]: https://github.com/brson
[@5kbpers]: https://github.com/5kbpers
[@youjiali1995]: https://github.com/youjiali1995
[@pentium3]: https://github.com/pentium3
[@Jing118]: https://github.com/Jing118
[@zhouqiang-cl]: https://github.com/zhouqiang-cl
[@jadireddi]: https://github.com/jadireddi
[@aknuds1]: https://github.com/aknuds1
[@gengliqi]: https://github.com/gengliqi
[@NingLin-P]: https://github.com/NingLin-P
[@it2911]: https://github.com/it2911
[@guliangliangatpingcap]: https://github.com/guliangliangatpingcap
[@Jing118]: https://github.com/Jing118
[@pentium3]: https://github.com/pentium3
[@wshwsh12]: https://github.com/wshwsh12