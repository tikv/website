---
title: This Month in TiKV - December 2019
date: 2020-1-7
author: Ana Hobden
---

<!-- Fill in the below from the API: https://developer.github.com/v4/explorer/ -->

Happy new year and happy new decade! How did our contributors wrap up the decade? Let's take a look, and then take a peek at what's coming this year!

## Releases

This month our team made 4 TiKV releases - 3.0.x and 2.1.x releases are minor releases, and 3.1.0-beta is our upcoming next major release before 4.0.

You can review the changelogs here:

* [3.0.7](https://github.com/tikv/tikv/releases/tag/v3.0.7)
* [3.0.8](https://github.com/tikv/tikv/releases/tag/v3.0.8)
* [2.1.19](https://github.com/tikv/tikv/releases/tag/v2.1.19)
* [3.1.0-beta](https://github.com/tikv/tikv/releases/tag/v3.1.0-beta)

Upgrading? Here's things you should know:

* In **3.0.8** we reduced the severity of errors occuring in the coprocessor to `warn`.
* In **3.0.8** the default value of `split-region-on-table` is now `false` to help reduce region creation pressure during table creation/deletion.
* In **3.0.8** we now welcome you to experiment with a new feature to get flame graphs from a running TiKV. Try visiting `$SERVER:20180/debug/pprof/profile?seconds=10` to see a flamegraph of that TiKV. We'll be adding more details to our documentation about this soon!
* Version **3.1.0** is a beta and should not be adopted in production deployments. Please do try it out and let us know if you find issues. It includes new follower read and backup/restore features.

## News

TiKV 3.1.0 is now in beta, with a stable release coming soon! This includes new major features like follower read and distributed backup/restore.

Follower read will allow clients to read data from followers in a region, reducing pressure on the region leader. Distributed backup and restore are a long awaited feature to make it more practical and efficient to both prepare for the worst, and handle it if it does happen.

## Reading materials

Tang Liu wrote an in depth article about [how TiKV handles read and write operations](https://tikv.org/blog/how-tikv-reads-writes/) over on the TiKV blog.

Yuanli Wang wrote about recent work on [AutoTiKV](https://pingcap.com/blog/autotikv-tikv-tuning-made-easy-by-machine-learning/), an AI-powered tuning tool for DBAs to help them find the ideal workload settings for their TiKVs.

Back in October Dongxu Haung wrote about how TiDB is using TiKV's [pessimistic transaction feature](https://developpaper.com/talking-about-tidbs-new-features-pessimistic-transactions/). We missed it then, so as part of a "better late than never" idea, we've included it here.

## Notable PRs

* [@iosmanthus] taught TiKV about a new option, `log_rotation_size` as [#6148](https://github.com/tikv/tikv/pull/6148).
* [@rustin-liu] opened a number of coprocessor PRs to add new functionality like `instr`, `sha2`, and `round`.
* [@yiwu-arbug] added the beginnings of external S3 storage support in [#6209](https://github.com/tikv/tikv/pull/6209).
* [@brson] has been continuing work on the Engine abstraction. Including work like [#6122](https://github.com/tikv/tikv/pull/6122) which parameterizes parts TiKV over `Snapshot`.
* [@renkai] localized some server metrics in [#6258](https://github.com/tikv/tikv/pull/6258).
* [@sticnarf] taught the coprocessor to use [`yatp`](https://github.com/tikv/yatp) in [#6375](https://github.com/tikv/tikv/pull/6375).
* [@nrc] landed a sequence of PRs to do some refactoring in the transaction module. Including [#6272](https://github.com/tikv/tikv/pull/6272) and [#6246](https://github.com/tikv/tikv/pull/6246).

## Notable issues

* Several new issues like [#6281](https://github.com/tikv/tikv/issues/6281), [#6191](https://github.com/tikv/tikv/issues/6191), [#6316](https://github.com/tikv/tikv/issues/6316) and [#6368](https://github.com/tikv/tikv/issues/6368) were created, asking for help tackling several improvements in the coprocessor.
* [@zhouqiang-cl] noticed in [#6180](https://github.com/tikv/tikv/issues/6180) we weren't running some tests on the CI, but they were run with `make dev`.
* [@iosmanthus] found in [#6145](https://github.com/tikv/tikv/issues/6145) that some `cargo` commands were't working due to our use of features. [@koushiro] has some clever fixes in [#6317](https://github.com/tikv/tikv/pull/6317) to keep TiKV working with default `cargo` commands, what a great job!

## Predicting 2020

This January we'll be starting to hammer out our grand plans for 2020. This year will likely include both a 3.1 and 4.0 release of TiKV. 3.1.0 will include new features we wrote about above, and 4.0.0 will include even more things from the [roadmap](https://github.com/tikv/tikv/blob/master/docs/ROADMAP.md).

If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

* [@Rustin-Liu]
* [@hanahmily]
* [@Aloxaf]
* [@zhang555]
* [@chacha923]
* [@zhangmoon]
* [@lhy1024]
* [@fky2015]
* [@qrr1995]

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover $MONTH:

* [December 23-29](https://pingcap.com/weekly/2019-12-30-tidb-weekly/)
* [December 16-22](https://pingcap.com/weekly/2019-12-23-tidb-weekly/)
* [December 9-15](https://pingcap.com/weekly/2019-12-16-tidb-weekly/)
* [December 2-8](https://pingcap.com/weekly/2019-12-09-tidb-weekly/)
* [November 25-December 1](https://pingcap.com/weekly/2019-12-02-tidb-weekly/)