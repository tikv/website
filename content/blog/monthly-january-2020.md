---
title: This Month in TiKV - January 2020
date: 2020-02-19
author: TiKV Authors
---

<!-- Fill in the below from the API: https://developer.github.com/v4/explorer/ -->

Welcome to the first monthly wrap-up of 2020. In January, we had regular releases, some great articles, some great PRs and issues, and of course, new members of the community.

Let's take a look!

## Releases

This month our team made 2 TiKV releases:

- The [3.0.9](https://github.com/tikv/tikv/releases/tag/v3.0.9) release includes the configuration change to speed up the Region scattering, some optimized configuration items, and a [fixed issue](https://github.com/tikv/tikv/pull/6431) for Region Merge.
- The [4.0.0-beta](https://github.com/tikv/tikv/releases/tag/v4.0.0-beta) release includes major updates such as quick backup and restoration support, RocksDB version upgrade, and also bugs fixes.

{{< info >}}
4.0.0-beta is not ready for production use. Upgrade wth caution!
{{</ info >}}

## Reading materials

[@brson](https://github.com/brson) published his first episode of the Rust Compile time series, [The Rust Compilation Calamity](https://tikv.org/blog/rust-compilation-calamity/), and shared his research and experiences with Rust compile times, using the TiKV project as a case study.

[@BusyJay](https://github.com/BusyJay) together with [@zhexuany](https://github.com/zhexuany) and [@bb7133](https://github.com/bb7133) wrote [an overview on Raftstore in the series of A TiKV Source Code Walkthrough (in Chinese)](https://pingcap.com/blog-cn/tikv-source-code-reading-17/). This article uses the code of TiKV 3.0 version as an example to present the key definitions and designs in the raftstore source code.

## Notable PRs

- [@yiwu-arbug](https://github.com/yiwu-arbug) added S3 support in `external_storage` crate in [#6209](https://github.com/tikv/tikv/pull/6209). The `external_storage` crate provids a unified interface to read & write files in the local file system, S3 and GCS.

- [@NingLin-P](https://github.com/NingLin-P) made it possible to change TiKV configurations online in [#6331](https://github.com/tikv/tikv/pull/6331).

- [@breeswish](https://github.com/breeswish) integrated dashboard into PD in [#2086](https://github.com/pingcap/pd/pull/2086).

- [nolouch](https://github.com/nolouch) upgraded etcd to v3.4.3 for PD in [#2063](https://github.com/pingcap/pd/pull/2063).

- [@sticnarf](https://github.com/sticnarf) replaced all the readpools with [yatp](https://github.com/tikv/yatp) (a thread pool in Rust) in [#6375](https://github.com/tikv/tikv/pull/6375) and [#6401](https://github.com/tikv/tikv/pull/6401).

- [@MyonKeminta](https://github.com/MyonKeminta) implemented Green Garbage Collection (GC) in [#6138](https://github.com/tikv/tikv/pull/6138), [#6070](https://github.com/tikv/tikv/pull/6070) and [#6333](https://github.com/tikv/tikv/pull/6333). This enhancement changes the way to scan locks so that inactive regions won't be waken up from hibernating by GC.

## Notable issues

**Help wanted issues** (mentoring available)

- [@brson](https://github.com/brson) opened the issue [#6402](https://github.com/tikv/tikv/issues/6402) regarding organizing and tracking progress on abstracting TiKV over generic storage engines.

- [@yiwu-arbug](https://github.com/yiwu-arbug) created the issue [#6496](https://github.com/tikv/tikv/issues/6496), requesting a feature to make RocksDB issues easy to investigate.

- [@yiwu-arbug](https://github.com/yiwu-arbug) suggested enabling `rate-bytes-per-sec` in [#6484](https://github.com/tikv/tikv/issues/6484) because it would keep RocksDB background compaction steady, smoothing both IO and CPU usage.

**Call for participation**

- [@yeya24](https://github.com/yeya24) suggested in [#6407](https://github.com/tikv/tikv/issues/6407) that some counter metrics don’t follow  the [Prometheus Label Naming](https://prometheus.io/docs/practices/naming/) conventions and we should consider renaming them. While we agreed it is worth regulating the metrics, changing so many metrics in multiple places all at once is not easy. What do you think?

- [@sunxiaoguang](https://github.com/sunxiaoguang) created  [#6500](#6500) to ask if some students would be interested in participating in [GSoC](https://summerofcode.withgoogle.com/) by working on this project. Follow this issue if you are interested.

## New contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

* [@silathdiir](https://github.com/silathdiir)
* [@yeya24](https://github.com/yeya24)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover January:

*   [December 30 ~ January 05, 2020](https://pingcap.com/weekly/2020-01-06-tidb-weekly/)
*   [January 06 ~ January 12, 2020](https://pingcap.com/weekly/2020-01-14-tidb-weekly/)
*   [January 12 ~ January 19, 2020](https://pingcap.com/weekly/2020-01-20-tidb-weekly/)
