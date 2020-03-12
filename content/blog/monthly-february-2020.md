---
title: This Month in TiKV - February 2020
date: 2020-03-12
author: TiKV authors
---

As the cold winter has passed, we are welcoming a beautiful spring with blossoms, gentle breeze, and of course our monthly TiKV update, covering February 2020.

Let’s get started!

### Releases

This month our team made 2 TiKV releases!

You can review the changelogs here:

- [3.0.10](https://github.com/tikv/tikv/releases/tag/v3.0.10)
  - bug fixes
- [4.0.0-beta.1](https://github.com/tikv/tikv/releases/tag/v4.0.0-beta.1)
  - bug fixes 
  - compatibility improvements
  - new features including supporting fetching configuration items from the status port via HTTP API in [#6480](https://github.com/tikv/tikv/pull/6480) and optimizing the performance of `Chunk Encoder` in Coprocessor in [#6341](https://github.com/tikv/tikv/pull/6341)

### Reading materials

For raft-based implementations like TiKV, stale read may happen due to a brain split in the Raft group. [@siddontang](https://github.com/siddontang) wrote [How TiKV Uses "Lease Read" to Guarantee High Performances, Strong Consistency and Linearizability](https://tikv.org/blog/lease-read/) to share with you several approaches to this problem and why TiKV chooses Lease Read. 

As a long-time Rust programmer, [@nrc](https://github.com/nrc) wrote [Early Impressions of Go from a Rust Programmer](https://pingcap.com/blog/early-impressions-of-go-from-a-rust-programmer/), talking about his early impressions of Go. 

[@c4pt0r](https://github.com/c4pt0r) published [Doubling System Read Throughput with Only 26 Lines of Code](https://pingcap.com/blog/doubling-system-read-throughput-with-only-26-lines-of-code/) where he introduced Follower Read, a new feature that TiDB and TiKV have.

[@TennyZhuang](https://github.com/TennyZhuang) together with [Fullstop000](https://github.com/Fullstop000), [haoxiang47](https://github.com/haoxiang47) and [@hicqu](https://github.com/hicqu) wrote the article [How We Reduced Multi-region Read Latency and Network Traffic by 50%](https://pingcap.com/blog/how-we-reduced-multi-region-read-latency-and-network-traffic-by-50/), introducing their project of optimizing multi-region network bandwidth and read latency in TiKV server at TiDB Hackathon 2019. 

### Notable PRs

*   [@BusyJay](https://github.com/BusyJay) upgraded thread pool to support yield in [#6487](https://github.com/tikv/tikv/pull/6487), making tasks handled more fairly.

*   [@kennytm](https://github.com/kennytm) added backup data support to S3 storage on 3.1 version in[ #6536](https://github.com/tikv/tikv/pull/6536).

*   [@BusyJay](https://github.com/BusyJay) introduced pre-transfer leader to make raft leadership transfer more smoothly in [#6539](https://github.com/tikv/tikv/pull/6539).

*   [@5kbpers](https://github.com/5kbpers) added command observer to observe executed command in the apply thread pool in[ #6602](https://github.com/tikv/tikv/pull/6602). This is in preparation for CDC (capture data changes).

*   [@sticnarf](https://github.com/sticnarf) used the unified thread pool in [#6593](https://github.com/tikv/tikv/pull/6593) to handle point get requests and coprocessor requests.

*   [@nolouch](https://github.com/nolouch) verified online reload new [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate in [#2162](https://github.com/pingcap/pd/pull/2162).

*   [@Luffbee](https://github.com/Luffbee) introduced a solution-based balance solver in [#2141](https://github.com/pingcap/pd/pull/2141).

*   [@iosmanthus](https://github.com/iosmanthus) upgraded DAG framework in [#5871](https://github.com/tikv/tikv/pull/5817), making TiKV never fallback to the volcano model mode.

*   [@TennyZhuang](https://github.com/TennyZhuang) supported new index encoding with collation support in [#6685](https://github.com/tikv/tikv/pull/6685).

*   [@youjiali1995](https://github.com/youjiali1995) made it possible to return values with successful pessimistic lock responses to reduce network traffic in [#6696](https://github.com/tikv/tikv/pull/6696).

### Notable issues

**Help wanted issues** (mentoring available)

[@yiwu-arbug](https://github.com/yiwu-arbug) suggested setting `write_global_seqno=false` for file ingestion in [#6501](https://github.com/tikv/tikv/issues/6501) and he opened the issue [#6502](https://github.com/tikv/tikv/issues/6502), requesting to evaluate dictionary compression for RocksDB.

**Call for participation**

[@overvenus](https://github.com/overvenus) opened issue [#6734](https://github.com/tikv/tikv/issues/6734), requesting to update PD member information every 10 minutes in order to minimize the time window of holding stale information.

[@hicqu](https://github.com/hicqu) suggested in [#6666](https://github.com/tikv/tikv/issues/6666) to remove `shared_block_cache` from `engine_trait::KvEngines` to simplify `KvEngine::flush_metrics` and he clarified 2 reasons for this suggestion. We have seen one vote up. What’s your opinion?

[@yiwu-arbug](https://github.com/yiwu-arbug) and [@Little-Wallace](https://github.com/Little-Wallace) created [#6506](https://github.com/tikv/tikv/issues/6506), [#6507](https://github.com/tikv/tikv/issues/6507), and [#6508](https://github.com/tikv/tikv/issues/6508) to ask if students would be interested in participating in [GSoC](https://summerofcode.withgoogle.com/) by working on these projects. Follow these issues if you are interested.

### New Contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

*   [@silathdiir](https://github.com/silathdiir)
*   [@xinhua5](https://github.com/xinhua5)
*   [@Poytr1](https://github.com/Poytr1)

If you'd like to get involved, we’d love to invite you to participate in the[ TiDB Challenge Program](https://pingcap.com/blog/tidb-usability-challenge-dare-to-dream-bigger/) and you might be interested in starting from some easy tasks at [the TiKV project](https://github.com/tikv/tikv/projects/20). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

### This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover February.

- [January 20 ~ February 02, 2020](https://pingcap.com/weekly/2020-02-03-tidb-weekly/)

- [February 03 ~ February 09, 2020](https://pingcap.com/weekly/2020-02-10-tidb-weekly/)

- [February 10 ~ February 16, 2020](https://pingcap.com/weekly/2020-02-17-tidb-weekly/)

- [February 17 ~ February 23, 2020](https://pingcap.com/weekly/2020-02-24-tidb-weekly/)

<!-- Docs to Markdown version 1.0β19 -->
