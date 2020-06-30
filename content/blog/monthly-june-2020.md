---
title: This Month in TiKV - June 2020
date: 2020-07-01
author: TiKV Authors
---

How time flies! It’s halfway through the year already! We are expecting the next 6 months of this year to be as fruitful as the first 6 months this year.

Let’s take a look at what we have achieved in June!

## News

[TiKV has reached general availability](https://tikv.org/blog/tikv-4.0-ga/)! Thanks to all users and contributors who helped with release, TiKV has been used by more than 1,000 adopters in production scenarios across multiple industries worldwide. Currently, we’re planning future versions of TiKV; let us know what you’d like to have in TiKV 5.0 by [opening an issue](https://github.com/tikv/tikv/issues/new?template=feature-request.md) on Github to make feature requests.

Our first CNCF project webinar, [How We Doubled System Read Throughput with Only 26 Lines of Code](https://www.cncf.io/webinars/how-we-doubled-system-read-throughput-with-only-26-lines-of-code/), is scheduled on July 31, at 10 am PT. Minghua Tang will share how we introduced Follower Read, and how we implemented it at this webinar. [Register](https://zoom.us/webinar/register/WN_UobO7CidQWShiPE-HreKXA) if you’re interested.

The transaction special interest group (SIG-transaction) has built a [repo](https://github.com/tikv/sig-transaction) in the TiKV project! They have a focus on transactions in TiKV and TiDB, but discuss academic work and other implementations too. Recently, [@sticnarf](https://github.com/sticnarf), [@MyonKeminta](https://github.com/MyonKeminta) and [@nrc](https://github.com/nrc) have drafted a [design document](https://github.com/tikv/sig-transaction/blob/master/design/parallel-commit/initial-design.md) for Parallel Commit. Join them if you have an interest in it.

Our official [YouTube channel](https://www.youtube.com/channel/UCXyuUR4qEm0HLDniz46k6sg/featured?view_as=subscriber) is available! Previously, our community meeting videos were uploaded to CNCF’s channel. Now, we have our own channel for TiKV information with two playlists, community meetings and technical demos. Subscribe to it if you’re interested in keeping up with our video information.

## Releases

This month our team made 4 releases!

You can review the changelogs here:

*   **[4.0.0](https://github.com/tikv/tikv/releases/tag/v4.0.0)**
    *   Bug fixes
*   [3.1.2](https://github.com/tikv/tikv/releases/tag/v3.1.2)
    *   Bug fixes
*   [3.0.15](https://github.com/tikv/tikv/releases/tag/v3.0.15)
    *   Bug fixes
*   [4.0.1](https://github.com/tikv/tikv/releases/tag/v4.0.1)
    *   New features
        *   Add the `--advertise-status-addr` start flag to specify the status address to advertise in [#8046](https://github.com/tikv/tikv/pull/8046)
    *   Bug fixes

## Reading materials

In [TiKV Performance Tuning with Massive Regions](https://tikv.org/blog/tune-with-massive-regions-in-tikv/), [@Connor1996](https://github.com/Connor1996) introduces the workflow of Raftstore, explains why a massive amount of Regions affect the performance and offers 5 methods for tuning TiKV’s performance.

[@lucperkins](https://github.com/lucperkins) wrote [Rust at CNCF](https://www.cncf.io/blog/2020/06/22/rust-at-cncf/) to shed light on how TiKV and Linkerd are contributing to the Rust ecosystem.

In episodes 2, 3 and 4 of Rust compile time series, [@brson](https://github.com/brson) focuses on monomorphization, compilation units and some factors that cause Rust to build slow respectively. Read more in [Generics and Compile-Time in Rust](https://pingcap.com/blog/generics-and-compile-time-in-rust), [Rust's Huge Compilation Units](https://pingcap.com/blog/rust-huge-compilation-units) and [A Few More Reasons Rust Compiles Slowly](https://pingcap.com/blog/reasons-rust-compiles-slowly).

## Notable PRs

*   [@skyzh](https://github.com/skyzh) opened[ #8141](https://github.com/tikv/tikv/pull/8141) to migrate executor and aggregator to be compatible with `ChunkedVec`, which would lay a solid foundation for [the Chunk Format coprocessor framework](https://github.com/tikv/rfcs/pull/43).
*   [@yiwu-arbug](https://github.com/yiwu-arbug) created [#8115](https://github.com/tikv/tikv/pull/8115) to support region guard, namely splitting SST by region boundaries to reduce write amplification.
*   [@sticnarf](https://github.com/sticnarf) opened [#7983](https://github.com/tikv/tikv/pull/7983) to make `tikv-ctl recover-mvcc` be compatible with pessimistic transactions.
*   [@dimstars](https://github.com/dimstars) added priority supports for election in [#361](https://github.com/tikv/raft-rs/pull/361).
*   [@BusyJay](https://github.com/BusyJay) created [#379](https://github.com/tikv/raft-rs/pull/379) and [#380](https://github.com/tikv/raft-rs/pull/380) to start porting joint consensus from etcd.

## Notable issues

**Help wanted issues (mentoring available)**

*   [@yiwu-arbug](https://github.com/yiwu-arbug) created [#8140](https://github.com/tikv/tikv/issues/8140), requesting a feature to support in-memory compaction in RocksDB and use it to lock CF.

*   [@breeswish](https://github.com/breeswish) suggested enabling TiKV to search RocksDB logs in [#8062](https://github.com/tikv/tikv/issues/8062).

*   [@xieqiang2020](https://github.com/xieqiang2020) opened issue [#8041](https://github.com/tikv/tikv/issues/8041), requesting a feature to support big-endian.

## Collaborate with TiKV Community

We’d like to thank all our contributors who helped with the TiKV project. Whether you were a returning contributor or one of the many new folks we welcomed, thank you.

Not a contributor yet? We’d love to help you get started if you’d like to get involved with the development and help drive forward the future of TiKV! You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don’t know how to begin, just leave a comment and our team will help you out. 

Also, don’t miss the chance to talk to us! You could reach us by:

*   [TiKV Community Meeting](https://docs.google.com/document/d/1CWUAkBrcm9KPclAu8fWHZzByZ0yhsQdRggnEdqtRMQ8/edit) to follow up with SIG updates
*   Twitter at [@tikvproject](https://twitter.com/tikvproject)
*   Slack at [#general](https://bit.ly/2ZcrVTI) on TiKV-WG
*   Github: [https://github.com/tikv/tikv](https://github.com/tikv/tikv)