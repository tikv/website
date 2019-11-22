---
title: This Month in TiKV - October 2019
date: 2019-11-20
author: Ana Hobden
---

It's time for a very non-spooky October edition of This month in TiKV! We have a few treats for you while we've been teaching TiKV some new tricks.

## News

This month our team made one TiKV minor release (v3.0.5)! This release includes bug fixes and minor, backwards compatible features.

You can review the changelogs here: [3.0.5](https://github.com/tikv/tikv/releases/tag/v3.0.5)

Upgrading? This release includes only bugfixes!

## Reading materials

PingCAP wrote ["INSERT INTO tidb.hackathon_2019 VALUES ("Hack", "Fun", "TiDB Ecosystem")"](https://pingcap.com/blog/insert-into-tidb-hackathon-2019-values-hack-fun-tidb-ecosystem/) talking about the recent Hackathon they held in China! Two of the top three winning projects were improving TikV! Great job!

See ["Using Raft to mitigate TiDB Cross-DC latency" (CN)](https://cdn2.hubspot.net/hubfs/4466002/Solution%20for%20Cross%20Datacenter%20Replication.pdf) and ["Unified Thread Pool" (EN)](https://cdn2.hubspot.net/hubfs/4466002/Unified%20Thread%20Pool.pdf) to more information!

## Notable PRs

<!-- https://github.com/tikv/tikv/pulls?q=is%3Apr+created%3A2019-10+sort%3Acomments-desc -->

* ["Batch (raw) get requests to same region across batch commands"](https://github.com/tikv/tikv/pull/5598) by [@tabokie] reduces pressure on the readpool and CPU.
* ["Generate flamegraph at runtime"](https://github.com/tikv/tikv/pull/5697) by [@YangKeao] introduces a new HTTP interface to get flamegraphs from TiKV at runtime.
* ["Coprocessor: v2 row format for decode"](https://github.com/tikv/tikv/pull/5725) by [@niedhui] furthers the implementation of the v2 row format.
* ["txn: protect primary locks of pessimistic transactions from being collapsed"](https://github.com/tikv/tikv/pull/5575) by [@sticnarf] adds some additional safety to pessimistic locks.
* ["Improve Coprocessor Table Lookup Performance"](https://github.com/tikv/tikv/pull/5682) by [@breeswish] introduces a new interface on the MVCC level which can reuse cursors when keys in ascending order, improving lookup performance.
* ["util: compare raw and encoded keys without explicit decoding"](https://github.com/tikv/tikv/pull/5613) by [@sticnarf] allows TiKV to determine if an encoded and raw format refer to the same key without needing to encode or decode.

## Notable issues

<!-- https://github.com/tikv/tikv/issues?utf8=%E2%9C%93&q=is%3Aissue+created%3A2019-10+sort%3Acomments-desc+ -->

* [@siddontang] found a [performance regression](https://github.com/tikv/tikv/issues/5578) in our upgrade to RocksDB 6.4.
* Many `Copr` and `PCP` tagged issues have appeared, `Copr` issues are related to the Coprocessor SIG that has started, and the PCP competition being facilitated by PingCAP in China.
* [@onitake] asked about [binary releases on Github](https://github.com/tikv/tikv/issues/5647) and we confirmed they're in progress!
* We begun talking with relevant parties about getting an [independent security audit](https://github.com/tikv/tikv/issues/5669).
* We were able to discover a [few](https://github.com/tikv/tikv/issues/5603) [new](https://github.com/tikv/tikv/issues/5614) [occasionally](https://github.com/tikv/tikv/issues/5611) failing tests as part of our ongoing efforts to rid TiKV's bugs.

## Current projects

Here's some of the things our contributors have been working on over the last month:

* [@winkyao] and [@dcalvin] lead a proposal to create additional community structure and processes to adapt to our growing community and where we hope to go in the future.
* New Special Interest Groups (SIG) are forming in November! November will bring a Coprocessor SIG as well as an Engine SIG. Interested in getting involved? Check their public channels (`#copr-sig` and `#engine-sig`) on our Community Chat to met the groups and see how you can help.
  * More info on SIGs soon! We're starting small, learning by experience, and figuring out the best way to do things!
* [@niedhui] contributed a milestone to the ongoing work to improve TiKV's row format.
* [@brson] has been leading the engine trait abstraction task, trying to allow TiKV to support other storage backends in addition to RocksDB.
* [@hicqu] and some of the team have been working on ensuring TiKV is free from memory leaks.
* [@overvenus] has lead more work on our upcoming backups feature to ensure it is reliable.
* [@zhangjinpeng1987] has been diligently working to reduce transient test failures.
* [@Connor1996] and [@yiwu-arbug] have been working to improve our RocksDB plugin, titan.

If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following [new contributors to TiKV](https://tikv.devstats.cncf.io/d/52/new-contributors-table?orgId=1&from=1564642800000&to=1567321140000) and thank them for their work!

* [@goandylok]
* [@zanmato1984]
* [@ming-relax]
* [@hk1997]
* [@3pointer]
* [@winkyao]
* [@loxp]
* [@samloveham]
* [@wangrzneu]

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover September,

* [2019-10-13](https://pingcap.com/weekly/2019-10-14-tidb-weekly/)
* [2019-10-21](https://pingcap.com/weekly/2019-10-21-tidb-weekly/)
* [2019-10-27](https://pingcap.com/weekly/2019-10-28-tidb-weekly/)

[@AndreMouche]: https://github.com/AndreMouche
[@breeswish]: https://github.com/breeswish/
[@hoverbear]: https://github.com/hoverbear/
[@sticnarf]: https://github.com/sticnarf/
[@akunds1]: https://github.com/aknuds1
[@nrc]: https://github.com/nrc/
[@pingcap]: https://github.com/pingcap/
[@zhouqiang-cl]: https://github.com/zhouqiang-cl
[@hoverbear]: https://github.com/hoverbear/
[@siddontang]: https://github.com/siddontang
[@c4pt0r]: https://github.com/c4pt0r
[@dcalvin]: https://github.com/dcalvin
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
[@hicqu]: https://github.com/hicqu
[@goandylok]: https://github.com/goandylok
[@zanmato1984]: https://github.com/zanmato1984
[@ming-relax]: https://github.com/ming-relax
[@hk1997]: https://github.com/hk1997
[@3pointer]: https://github.com/3pointer
[@winkyao]: https://github.com/winkyao
[@loxp]: https://github.com/loxp
[@samloveham]: https://github.com/samloveham
[@wangrzneu]: https://github.com/wangrzneu
[@onitake]: https://github.com/onitake