---
title: This Month in TiKV - September 2020
date: 2020-09-30
author: TiKV Authors
tags: ['Monthly update', 'Community']
---

[TiKV graduated within CNCF in September 2020](https://tikv.org/blog/graduation-announcement/)! This is a piece of exceptionally exciting news for the community because it marks the CNCF’s recognition of TiKV’s maturity. 

Let’s take a look at what we have achieved in September!

## News

[@Siddontang](https://github.com/siddontang) shared [TiKV Graduation Journey in CNCF](https://docs.google.com/presentation/d/1-RflCXh93Ef4yKjsSvX2aR9z1PAFyij2Hgf0cb8Oh8M/edit#slide=id.g446c4deb4d_0_341) at our monthly community meeting, which wrapped up important moments in TiKV’s graduation journey. The recorded video is available [here](https://www.youtube.com/watch?v=bBYRvmWtdPk).

To celebrate TiKV’s CNCF graduation, we have made limited edition SWAGs for our contributors and adopters! Claim yours by filling this [form](https://forms.pingcap.com/f/tikv-graduation-swag). 

[@nrc](https://github.com/nrc) initiated Transaction SIG’s [Documentation quest](https://tikv.org/blog/docs-quest/)! Join the quest if you want to learn about distributed transactions in a fun and effective way!

We have two projects selected by CNCF CommunityBridge projects for Q3-Q4, as listed below. We have received several resumes and coding tasks sent by mentee candidates. The official confirmation on candidates selection will be released by CommunityBridge on September 21. Stay tuned.

*   [Support ENUM / SET push down for TiKV Coprocessor](https://github.com/tikv/tikv/issues/8605)
*   [Support rbac for data accessing in TiKV](https://github.com/tikv/tikv/issues/8621)

## Releases

This month our team made 2 releases!

You can review the changelogs here:

*   [4.0.6](https://github.com/tikv/tikv/releases/tag/v4.0.6)
    *   Improvements
        *   Reduce QPS drop when `DropTable` or `TruncateTable` is being executed in [#8627](https://github.com/tikv/tikv/pull/8627).
        *   Support generating metafile of error codes in [#8619](https://github.com/tikv/tikv/pull/8619)
        *   Add performance statistics for cf scan detail in [#8618](https://github.com/tikv/tikv/pull/8618).
        *   Add the `rocksdb perf context` panel in the Grafana default template in [#8467](https://github.com/tikv/tikv/pull/8467).
    *   Bug fixes
*   [3.0.19](https://github.com/tikv/tikv/releases/tag/v3.0.19)
    *   Improvement
        *   Set `sync-log` to `true` as a nonadjustable value in [#8636](https://github.com/tikv/tikv/pull/8636)
    *   Bug fixes

## Reading materials

[@brson](https://github.com/brson) shared [Generics and Compile-Time in Rust](https://tikv.org/blog/generics-compile-time-rust/), the episode 2 of Rust compile time series on monomorphization.

## Notable PRs

*   [@chux0519](https://github.com/chux0519) added dictionary compression support for blob file for titan in [#189](https://github.com/tikv/titan/pull/189).
*   [@NingLin-P](https://github.com/NingLin-P) added joint consensus support in [#8401](https://github.com/tikv/tikv/pull/8401).
*   [@Xuanwo](https://github.com/Xuanwo) implemented non-nullable support for variable argument RPN function in [#8740](https://github.com/tikv/tikv/pull/8740).
*   [@JmPotato](https://github.com/JmPotato) added basic election logic in [#2986](https://github.com/tikv/pd/pull/2986) and TSO generation logic for the local allocator in [#2894](https://github.com/tikv/pd/pull/2894).
*   [@HundunDM](https://github.com/HundunDM) implemented a joint consensus builder in [#2740](https://github.com/tikv/pd/pull/2740) and added some operator steps related to joint consensus in [#2895](https://github.com/tikv/pd/pull/2895).
*   [@Yisaer](https://github.com/Yisaer) created [#2905](https://github.com/tikv/pd/pull/2905) to support the scatter region by groups. 
*   [@xhebox](https://github.com/xhebox) added a set of commands to pd-ctl, which makes use of the new bundle API in [#2927](https://github.com/tikv/pd/pull/2927). 

## Notable issues

**Call for participation**

*   [@Connor1996](https://github.com/Connor1996) opened [#8722](https://github.com/tikv/tikv/issues/8722) to discuss solutions to the increasing Rocksdb write duration.
*   [@Connor1996](https://github.com/Connor1996) found the compression ratio of L6 is even smaller than L5/L4 and created [#8721](https://github.com/tikv/tikv/issues/8721) to discuss reasons and possible solutions.

## New contributors

We’d like to welcome the following new contributors to TiKV and thank them for their work!

*   [@wangggong](https://github.com/wangggong)

*   [@Xuanwo](https://github.com/Xuanwo)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.
