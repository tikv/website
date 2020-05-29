---
title: This Month in TiKV - May 2020
date: 2020-05-28
author: TiKV Authors
---

As the summer tiptoed in, we were cheerful about everything it brings to us: sunshine, ice cream, and a busy but fulfilling May!

Let’s take a look at what we have accomplished.

## News

The first CNCF ambassador spotlight goes to Queeny Jin, who has been spreading the word about TiKV to English speakers since its inception in 2016. We appreciate Queeny’s contribution. "Together we can go further!" The full blog is available [here](https://www.cncf.io/blog/2020/05/01/cncf-ambassador-spotlight-queeny-jin-of-tikv/).

2 GSoC proposals and 1 Community Bridge project idea from TiKV project were accepted. Congratulations to accepted mentees and we look forward to working with them this summer.

*   GSoC projects
    *   [Cloud-Native KV-service](https://summerofcode.withgoogle.com/projects/#5083657930276864) 
        *   Mentor: Wei Liu ([@Little-Wallace](https://github.com/Little-Wallace))
        *   Student: Devdutt Shenoi ([@de-sh](https://github.com/de-sh))
    *   [Versioned rawKV](https://summerofcode.withgoogle.com/projects/#6520944794796032)<span style="text-decoration:underline;"> </span>
        *   Mentor: Fred Chen ([@fredchenbj](https://github.com/fredchenbj)) & Yi Wu ([@yiwu-arbug](https://github.com/yiwu-arbug))
        *   Student: Hyungsuk Kang ([@hskang9](https://github.com/hskang9))
*   Community bridge project
    *   Full Chunk-based Computing
        *   Mentor: Wish Shi ([@breeswish](https://github.com/breeswish)) & Tianyi Zhuang ([@TennyZhuang](https://github.com/TennyZhuang))
        *   Mentee: Chi Zhang ([@skyzh](https://github.com/skyzh))

KubeCon + CloudNativeCon Europe 2020 is now an online experience taking place on Aug. 17- 20 and TiKV speaking sessions on KubeCon EU are scheduled on Aug. 19-20. More information about TiKV speaking sessions is available [here](https://events.linuxfoundation.org/kubecon-cloudnativecon-europe/program/schedule/).

The TiKV community meeting time was moved to 07.00 p.m. PST ([Time zone converter](https://www.google.com/search?sxsrf=ALeKk01UVqm3BLWjN2AJxMSG73KiUqUdDw%3A1589771998935&ei=3v7BXuDQOJSl-QaKq62ICQ&q=7pm+PST&oq=7pm+PST&gs_lcp=CgZwc3ktYWIQAzIECAAQQzIECAAQQzIECAAQQzIECAAQQzIECAAQQzIECAAQQzICCAAyAggAMgYIABAHEB4yAggAOgQIABBHOggIABAHEAoQHlDQWFicXGC-ZWgAcAF4AIABmwGIAa4CkgEDMC4ymAEAoAEBqgEHZ3dzLXdpeg&sclient=psy-ab&ved=0ahUKEwjgt5SaurzpAhWUUt4KHYpVC5EQ4dUDCAw&uact=5)) on every 4th Wednesday of every month to involve more people in our monthly discussion.

TiKV logo was updated with "Ti" added before KV.

{{< figure src="/img/blog/monthly-may-2020/tikv logo.png" caption="The updated version of TiKV logo" number="" >}}

## Releases

This month our team made 2 releases!

You can review the changelogs here:

*   [3.0.14](https://github.com/tikv/tikv/releases/tag/v3.0.14)
    *   New features
        *   Improve the performance when many write conflicts and  `BatchRollback` condition occur in optimistic transactions in [#7650](https://github.com/tikv/tikv/pull/7605)
    *   Bug fixes
*   [4.0.0-rc.2](https://github.com/tikv/tikv/releases/tag/v4.0.0-rc.2)
    *   Compatibility Changes
        *   Move the encryption-related configuration to the security-related configuration in [#7810](https://github.com/tikv/tikv/pull/7810)
    *   New features
        *   Support encryption debugging for tikv-ctl in [#7698](https://github.com/tikv/tikv/pull/7698)
        *   Support encrypting the lock column family in snapshots in [#7712](https://github.com/tikv/tikv/pull/7712)
        *   Support heatmap in the Grafana dashboard for Raftstore latency summary to better diagnose the jitter issue in [#7717](https://github.com/tikv/tikv/pull/7717)
        *   Support setting the upper limit for the size of the gRPC message in [#7824](https://github.com/tikv/tikv/pull/7824)
        *   Add in Grafana dashboard the encryption-related monitoring metrics in [#7827](https://github.com/tikv/tikv/pull/7827)
        *   Support Application-Layer Protocol Negotiation (ALPN) in [#7825](https://github.com/tikv/tikv/pull/7825)
        *   Support using the task ID provided by the client as the identifier in the unified read pool in [#7814](https://github.com/tikv/tikv/pull/7814)
        *   Improve the performance of the batch insert request in [#7718](https://github.com/tikv/tikv/pull/7718)
    *   Bug fixes

## Reading materials

In [Implement Raft in Rust](https://tikv.org/blog/implement-raft-in-rust/), [@siddontang](https://github.com/siddontang) shares the design of raft-rs, a Raft implementation in Rust designed by TiKV community, and how to develop your own app using it.

In [TiKV in JD Cloud & AI](https://tikv.org/blog/tikv-in-jd-cloud-ai/), Can Cui, an Infrastructure Specialist at JD Cloud & AI, introduces how TiKV empowered JD Cloud & AI to manage huge amounts of OSS metadata with a simple and horizontally scalable architecture. 

[@nick_r_cameron](https://twitter.com/nick_r_cameron) wrote [Building, Running, and Benchmarking TiKV and TiDB](https://pingcap.com/blog/building-running-and-benchmarking-tikv-and-tidb/) to introduce how to build and run your own TiDB or TiKV, and how to run some benchmarks on those databases.

## Notable PRs

*   [@Little-Wallace](https://github.com/Little-Wallace) created [#6683](https://github.com/tikv/tikv/pull/6683) to support batching multiple write requests into an entry.
*   [@nrc](https://github.com/nrc) opened [#7676](https://github.com/tikv/tikv/pull/7676) to enable TiKV to split a region automatically if it contains many locks, which can improve the performance of the large transaction if it continues writing to a single region.
*   [@hicqu](https://github.com/hicqu) found that index-read requests can be out-of-order during configuration change, and fixed it in [#363](https://github.com/tikv/raft-rs/pull/363).

## Notable issues

**Call for participation**

[@cofyc](https://github.com/cofyc) proposed to add `--advertise-status-addr` flag to specify the status address to advertise in [#7920](https://github.com/tikv/tikv/issues/7920). Many comments under this issue show support to this proposal. What do you think?

[@zhangjinpeng1987](https://github.com/zhangjinpeng1987) suggested using RocksDB range deletion to truncate a continuously huge range of data in [#7803](https://github.com/tikv/tikv/issues/7803). [@siddontang](https://github.com/siddontang) and [@ajkr](https://github.com/ajkr) showed some concerns over this suggestion. What’s your opinion?


## New Contributors

We’d like to welcome the following new contributors to TiKV and thank them for their work!

*   [@crodjer](https://github.com/crodjer)
*   [@trabbart](https://github.com/trabbart)
*   [@skyzh](https://github.com/skyzh)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.