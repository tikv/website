---
title: This Month in TiKV - July 2020
date: 2020-07-30
author: TiKV Authors
---
The warmest month in the Northern Hemisphere comes to an end soon. It’s time to wrap up everything we have achieved in this month!

Let’s get started.

## News

TiKV is up for graduation from CNCF! This is a milestone that would not be possible without you! If you would like to support TiKV in the vote, follow the [instructions](https://lists.cncf.io/g/cncf-toc/join) to join TOC and post your replies [here](https://lists.cncf.io/g/cncf-toc/message/4902)!

[@breeswish](https://github.com/breeswish) has talked about TiKV’s development path and new features in the 4.0 GA version at Kubernetes Paris meetup. In case you missed it, the recorded video is available [here](https://www.youtube.com/watch?v=pAattr8cwSY&list=PLfR-valDYipfVN7ICQF_DnlZHcTY7O1F3&index=10&t=0s).

[Cloud Native and Open Source Virtual Summit China 2020](https://cncf.lfasiallc.cn/) is going to happen from July 30 to August 1. We have three TiKV-related talks scheduled. These talks will be delivered in Chinese and the timezone displayed is UTC+8. Mark your calendars to join them! 

*   [Intro: Backup and Restore in TiKV](https://sched.co/cpAn) - Jay Lee (16:20, Jul 31)
*   [TiFlash: Make TiKV 10x Faster and HTAP-able](https://sched.co/cp9v) - Xiaoyu Ma (15:40, Aug 1)
*   [BPF for Chaos and Tracing in Kubernetes](https://sched.co/cp9I) - Wenbo Zhang (20:50, Aug 1)

Our first CNCF project webinar, [How We Doubled System Read Throughput with Only 26 Lines of Code](https://www.cncf.io/webinars/how-we-doubled-system-read-throughput-with-only-26-lines-of-code/), is scheduled on at 10 am PT, July 31. Minghua Tang will share why we introduced Follower Read, and how we implemented it. [Register](https://zoom.us/webinar/register/WN_UobO7CidQWShiPE-HreKXA) if you’re interested.

## Releases

This month our team made 3 releases!

You can review the changelogs here:

*   [4.0.2](https://github.com/tikv/tikv/releases/tag/v4.0.2)
    *   New features
        *   Support the `encryption-meta` command in TiKV control in [#8103](https://github.com/tikv/tikv/pull/8103)
        *   Add a perf context metric for `RocksDB::WriteImpl` in [#7991](https://github.com/tikv/tikv/pull/7991)
    *   Bug fixes
*   [3.0.16](https://github.com/tikv/tikv/releases/tag/v3.0.16)
    *   Improvements
        *   Avoid sending store heartbeats to PD after snapshots are received in [#8145](https://github.com/tikv/tikv/pull/8145)
        *   Improve PD client log in [#8091](https://github.com/tikv/tikv/pull/8091)
    *   Bug fixes
*   [4.0.3](https://github.com/tikv/tikv/releases/tag/v4.0.3)
    *   Improvements
        *   Introduce the new `backup.num-threads` configuration to control the size of the backup thread pool in [#8199](https://github.com/tikv/tikv/pull/8199)
        *   Support dynamically changing the shared block cache's capacity in [#8232](https://github.com/tikv/tikv/pull/8232)
    *   Bug fixes

## Reading materials

[@nrc](https://github.com/nrc) wrote [Announcing the Transaction SIG](https://tikv.org/blog/announcing-sig-txn/) to introduce the distributed transactions SIG formed recently within the TiKV community and its focuses and plan.

## Notable PRs

*   [@skyzh](https://github.com/skyzh) implemented the Chunk memory format for all TiKV Coprocessor data types in [#8214](https://github.com/tikv/tikv/pull/8214) and [#8239](https://github.com/tikv/tikv/pull/8239).
*   [@de-sh](https://github.com/de-sh) created [rust-rocksdb#517](https://github.com/tikv/rust-rocksdb/pull/517) to add support of rocksdb-cloud for rust-rocksdb.
*   [@little-wallace](https://github.com/Little-Wallace) created [#7878](https://github.com/tikv/tikv/pull/7878) to support acquiring  RocksSnapshot once for different regions.
*   [@Busyjay](https://github.com/BusyJay) synchronized raft-rs with upstream etcd/raft in [#382](https://github.com/tikv/raft-rs/pull/382) and [#383](https://github.com/tikv/raft-rs/pull/383).
*   [@Busyjay](https://github.com/BusyJay) introduced joint consensus into raft-rs in [#386](https://github.com/tikv/raft-rs/pull/386).
*   [@sticnarf](https://github.com/sticnarf) created [#8258](https://github.com/tikv/tikv/pull/8258) to support async commit in `CheckTxnStatus`.
*   [@nrc](https://github.com/nrc) implemented async commit prewrite in [#8205](https://github.com/tikv/tikv/pull/8205).
*   [@longfangsong](https://github.com/longfangsong) created [#8228](https://github.com/tikv/tikv/pull/8228) to refactor command module.
*   [@youjiali1995](https://github.com/youjiali1995) fixed `min_commit_ts` overflow in [#7639](https://github.com/tikv/tikv/pull/7639).

## Notable issues

**Help wanted issues**

*   [@nrc](https://github.com/nrc) opened [#8336](https://github.com/tikv/tikv/issues/8336), suggesting fixing Clippy warnings. 
*   [@youjiali1995](https://github.com/youjiali1995) posted an issue regarding `MvccTxn` in [#8229](https://github.com/tikv/tikv/issues/8229).

**Call for participation**

*   [@sticnarf](https://github.com/sticnarf) created [#8170](https://github.com/tikv/tikv/issues/8170) to discuss whether we should audit specialization usage in the coprocessor.

## New Contributors

We’d like to welcome the following new contributors to TiKV community and thank them for their work!

*   [@weihanglo](https://github.com/weihanglo)
*   [@abbccdda](https://github.com/abbccdda)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.