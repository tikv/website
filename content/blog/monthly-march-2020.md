---
title: This Month in TiKV - March 2020
date: 2020-04-02
author: TiKV Authors
---

In this unprecedented global situation, we hope all of you could keep a positive attitude and stay healthy.  

Let’s take a look at what we have achieved in March!

## News

TiKV has finished[ a third-party security assessment](https://tikv.org/blog/tikv-pass-security-audit/)! This assessment of the TiKV scope, curated by CNCF and executed by Cure53 in early 2020, concludes with generally positive results. The full report is available [here](https://tikv.org/blog/TiKV-Security-Audit.pdf).

The TiKV community had the first-ever community meeting on March 26, 2020. Liu Tang ([@siddontang](https://github.com/siddontang)), one of our maintainers, kicked off the meeting, and the community manager, Calvin Weng ([@dcalvin](https://github.com/dcalvin)) shared about recent updates on community governance and membership. Also, a demo of Unified Read Pool, a thread pool in Rust to improve TiKV’s performance in allocating and scheduling resources, was presented by Yilin Chen ([@sticnarf](https://github.com/sticnarf)) at the end of the meeting. In case you missed it, the recording video is available [here](https://www.youtube.com/watch?v=hkDvakA-efA&feature=youtu.be) and the meeting notes are available [here](https://docs.google.com/document/d/1CWUAkBrcm9KPclAu8fWHZzByZ0yhsQdRggnEdqtRMQ8/edit#heading=h.ut5w82fnx9bc).

We have two new TiKV maintainers - Daobing Li ([@lidaobing](https://github.com/lidaobing)) from JD Cloud & AI and Fu Chen ([@fredchenbj](https://github.com/fredchenbj)) from Yidian Zixun. Congratulations! We look forward to working with them. The nominating PRs are here:

*   [Daobing Li](https://github.com/tikv/tikv/pull/7237)
*   [Fu Chen](https://github.com/tikv/tikv/pull/7259)

CNCF has confirmed the new event dates for [KubeCon + CloudNativeCon Europe 2020](https://events.linuxfoundation.org/kubecon-cloudnativecon-europe/) and TiKV speaking sessions are scheduled on August 15 and 16. We keep fingers crossed for those fighting against the Novel Coronavirus and expect to see you in TiKV speaking sessions by mid-summer. 

## Releases

This month our team made 5 TiKV releases!

You can review the changelogs here:

*   [3.0.11](https://github.com/tikv/tikv/releases/tag/v3.0.11)
    *   Bug fixes
*   [3.0.5-hotfix](https://github.com/tikv/tikv/releases/tag/v3.0.5-hotfix)
    *   Bug fixes
*   [3.1.0-beta.2](https://github.com/tikv/tikv/releases/tag/v3.1.0-beta.2)
    *   Bug fixes
    *   The usability improvement in [#6610](https://github.com/tikv/tikv/pull/6610) and the functionality improvement in [#6605](https://github.com/tikv/tikv/pull/6605)
    *   A new feature: to connect other stores using `peer_address` in [#6491](https://github.com/tikv/tikv/pull/6491)
*   [3.0.12](https://github.com/tikv/tikv/releases/tag/v3.0.12)
    *   Bug fixes
*   [4.0.0-beta.2](https://github.com/tikv/tikv/releases/tag/v4.0.0-beta.2)
    *   A new feature: to support the configuration of persistent dynamic update in [#6684](https://github.com/tikv/tikv/pull/6684)
    *   Bug fixes

## Reading materials

[@YangKeao](https://github.com/YangKeao) wrote [Quickly Find Rust Program Bottlenecks Online Using a Go Tool](https://pingcap.com/blog/quickly-find-rust-program-bottlenecks-online-using-a-go-tool/) to introduce the experience of using the Go tool pprof to visualize TiKV’s profiling data.

In the recap of [RocksDB in TiKV](https://tikv.org/blog/rocksdb-in-tikv/) in a 2017 meetup, [@siddontang](https://github.com/siddontang) shared about how the friendship between RocksDB and TiKV came into being and how it has developed. 

## Notable PRs

[@overvenus](https://github.com/overvenus) supported encryption at rest in [#6990](https://github.com/tikv/tikv/pull/6990).

[@zhangjinpeng1987](https://github.com/zhangjinpeng1987) calculated CPU quota and memory limit in the container environment in [#7074](https://github.com/tikv/tikv/pull/7074), and automatically adjusted related configurations in TiKV.

[@yiwu-arbug](https://github.com/yiwu-arbug) added utilities to enable AWS IAM in k8s in [#7201](https://github.com/tikv/tikv/pull/7201).

[@loxp](https://github.com/loxp) added swagger supports in [#2276](https://github.com/pingcap/pd/pull/2276).

[@innerr](https://github.com/innerr) implemented the pipelined pessimistic lock in [#6984](https://github.com/tikv/tikv/pull/6984), which can improve much performance of the pessimistic transaction.

## Notable issues

**Helped wanted issues (mentoring available)**

[@zhangjinpeng1987](https://github.com/zhangjinpeng1987) suggested improving the coverage of the components/codec module, the coverage of components/raftstore module and the coverage of the components/tidb_query_datatypes module separately in [#7186](https://github.com/tikv/tikv/issues/7186), [#7191](https://github.com/tikv/tikv/issues/7191) and [#7192](https://github.com/tikv/tikv/issues/7192).

[@breeswish](https://github.com/breeswish) created issue [#7039](https://github.com/tikv/tikv/issues/7039), requesting a feature to optimize the coprocessor analytical performance.

**Call for participation**

[@MyonKeminta](https://github.com/MyonKeminta) opened issue [#7153](https://github.com/tikv/tikv/issues/7153), requesting to avoid incorrect "engine" label to distinguish nodes with different engines. [@overvenus](https://github.com/overvenus) and [@disksing](https://github.com/disksing) presented their opinions on this issue, and what is yours?

[@5kbpers](https://github.com/5kbpers) suggested in [#7113](https://github.com/tikv/tikv/issues/7113) to support to delay the GC for delete record to relax the limitation of the GC interval. [@MyonKeminta](https://github.com/MyonKeminta) agreed with [@5kbpers](https://github.com/5kbpers). What do you think?

## New Contributors

We’d like to welcome the following new contributors to TiKV and thank them for their work!

*   [@ZiheLiu](https://github.com/ZiheLiu)
*   [@govardhangdg](https://github.com/govardhangdg)
*   [@Isampras](https://github.com/lsampras)
*   [@ziyi-yan](https://github.com/ziyi-yan)
*   [@SSebo](https://github.com/SSebo)

If you'd like to get involved, we’d love to invite you to participate in the [TiDB Challenge Program](https://pingcap.com/blog/tidb-usability-challenge-dare-to-dream-bigger/) and you might be interested in starting from some easy tasks at [the TiKV project](https://github.com/tikv/tikv/projects/20). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover late February and March.

*   [February 24 ~ March 01, 2020](https://pingcap.com/weekly/2020-03-02-tidb-weekly/)
*   [March 02 ~ March 08, 2020](https://pingcap.com/weekly/2020-03-09-tidb-weekly/)
*   [March 09 ~ March 15, 2020](https://pingcap.com/weekly/2020-03-16-tidb-weekly/)
*   [March 16 ~ March 22, 2020](https://pingcap.com/weekly/2020-03-23-tidb-weekly/)
*   [March 23 ~ March 29, 2020](https://pingcap.com/weekly/2020-03-30-tidb-weekly/)