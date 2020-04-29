---
title: This Month in TiKV - April 2020
date: 2020-04-30
author: TiKV Authors
---

April 1st marked TiKV’s 4th birthday. We are grateful for the support and contribution of the community while focusing on making better TiKV.

Let’s take a look at what we have achieved in April!

## News

We're working on another API- VerKV, a multi-versioned KV between RawKV and TxnKV, to help TiKV expand application scenarios. The work plan proposed by [@fredchenbj](https://github.com/fredchenbj) is available [here](https://github.com/tikv/tikv/issues/7295) and join us by picking the task you are interested in.

It is halfway through the [TiDB Usability Challenge](https://pingcap.com/blog/tidb-usability-challenge-dare-to-dream-bigger/) and we are glad to see TiKV related projects are popular. Congratulations to the teams that grabbed scores and let’s take a look at the top 5 most scored projects in TiKV repo.

*   [Extract tidb_query into different workspaces](https://github.com/tikv/tikv/issues/5706) by team [SSebo](https://github.com/tidb-challenge-program/register/issues/72)
*   [Support auto flush metrics](https://github.com/tikv/tikv/issues/7062) by team [BABAIsWatchingYou](https://github.com/tidb-challenge-program/register/issues/15)
*   [Add WAL write duration metric](https://github.com/tikv/tikv/issues/6541) by team [hawking&chacha](https://github.com/tidb-challenge-program/register/issues/31)
*   [Output slow logs to a dedicated file](https://github.com/tikv/tikv/issues/6735) by team [.*](https://github.com/tidb-challenge-program/register/issues/7) 
*   [Support slow log in log searching](https://github.com/tikv/tikv/issues/7069) by team [.*](https://github.com/tidb-challenge-program/register/issues/7) 

>**Note:**
>
>* The team name of [.*](https://github.com/tidb-challenge-program/register/issues/7) is originally with a star sign.

## Releases

This month our team made 5 TiKV releases!

You can review the changelogs here:

*   [3.1.0-rc](https://github.com/tikv/tikv/releases/tag/v3.1.0-rc)
    *   New features
        *   Support backing up data with the Raw KV API in [#7051](https://github.com/tikv/tikv/pull/7051)
        *   Support the Transport Layer Security (TLS) authentication for the status server in [#7142](https://github.com/tikv/tikv/pull/7142)
        *   Support the TLS authentication for the KV server in [#7305](https://github.com/tikv/tikv/pull/7305)
    *   Bug fixes
*   [4.0.0-rc](https://github.com/tikv/tikv/releases/tag/v4.0.0-rc)
    *   New features
        *   Support the `pipelined` feature in pessimistic transactions in [#6984](https://github.com/tikv/tikv/pull/6984)
        *   Support TLS in the HTTP port in [#5393](https://github.com/tikv/tikv/pull/5393)
        *   Enable the `unify-read-pool` configuration item in new clusters by default in [#7059](https://github.com/tikv/tikv/pull/7059)
    *   Bug fixes
*   [3.1.0](https://github.com/tikv/tikv/releases/tag/v3.1.0)
    *   Bug fixes
*   [3.0.13](https://github.com/tikv/tikv/releases/tag/v3.0.13)
    *   Bug fixes
*   [4.0.0-rc.1](https://github.com/tikv/tikv/releases/tag/v4.0.0-rc.1)
    *   Compatibility changes
        *   Disable the Hibernate Region feature by default in [#7618](https://github.com/tikv/tikv/pull/7618)
    *   New feature
        *   Support using the user-owned Key Management Service (KMS) key for the server-side encryption when backing up data to S3 in [#7630](https://github.com/tikv/tikv/pull/7630)
        *   Enable the load-based `split region` operation in [#7623](https://github.com/tikv/tikv/pull/7623)
        *   Support validating common names in [#7468](https://github.com/tikv/tikv/pull/7468)
        *   Add the file lock check to avoid starting multiple TiKV instances that are bound to the same address in [#7447](https://github.com/tikv/tikv/pull/7447)
        *   Support AWS KMS in encryption at rest in [#7465](https://github.com/tikv/tikv/pull/7465)
    *   Bug fixes

## Reading materials

[@YangKeao](https://github.com/YangKeao) wrote [Quickly Find Rust Program Bottlenecks Online Using a Go Tool](https://tikv.org/blog/quickly-find-rust-program-bottlenecks-online-using-a-go-tool/) to introduce his experience of using the Go tool pprof to visualize TiKV’s profiling data, which helps analyze Rust program’s performance online.

In [Tick or Tock? Keeping Time and Order in Distributed Databases](https://tikv.org/blog/time-in-distributed-systems/), [@siddontang](https://github.com/siddontang) analyzes some existing solutions to time synchronization and why TiKV chooses the timestamp oracle (TSO).

## Notable PRs

*   [@busyJay](https://github.com/BusyJay) supported replication mode control in [#7586](https://github.com/tikv/tikv/pull/7586).
*   [@yiwu-arbug](https://github.com/yiwu-arbug) fixed wrong key being read on ingested file for Raw KV in [#7420](https://github.com/tikv/tikv/pull/7420).
*   [@overvenus](https://github.com/overvenus) supported AWS KMS backend for encryption in [#7173](https://github.com/tikv/tikv/pull/7173).
*   [@wangrzneu](https://github.com/wangrzneu) supported rate control for removing peer in [#2226](https://github.com/pingcap/pd/pull/2226). 
*   [@innerr](https://github.com/innerr) fixed the correctness issue of coprocessor cache in [#7095](https://github.com/tikv/tikv/pull/7095). 

## Notable issues

**Helped wanted issues** (mentoring available)

[@youjiali1995](https://github.com/youjiali1995) created issue [#7652](https://github.com/tikv/tikv/issues/7652), requesting to always enable pessimistic transactions.

[@BusyJay](https://github.com/BusyJay) suggested adding metrics for channels of peer Finite-state machine (FSM) and apply FSM in [#7686](https://github.com/tikv/tikv/issues/7686).

**Call for participation**

[@Connor1996](https://github.com/Connor1996) opened [#7615](https://github.com/tikv/tikv/issues/7615) to discuss how to support change `rate_bytes_per_sec` dynamically. 

## New Contributors

We’d like to welcome the following new contributors to TiKV and thank them for their work!

*   [@de-sh](https://github.com/de-sh)

If you'd like to get involved, we’d love to invite you to participate in the [TiDB Usability Challenge](https://pingcap.com/blog/tidb-usability-challenge-dare-to-dream-bigger/) and you might be interested in starting from some easy tasks at [the TiKV project](https://github.com/tikv/tikv/projects/20). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover April.

*   [March 30 ~ April 05](https://pingcap.com/weekly/2020-04-07-tidb-weekly/)
*   [April 06 ~ April 12](https://pingcap.com/weekly/2020-04-13-tidb-weekly/)
*   [April 13~ April 19](https://pingcap.com/weekly/2020-04-20-tidb-weekly/)
*   [April 20~ April 26](https://pingcap.com/weekly/2020-04-27-tidb-weekly/)
