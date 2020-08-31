---
title: This Month in TiKV - August 2020
date: 2020-08-31
author: TiKV Authors
tags: ['Monthly update', 'Community']
---

August ends with the completion of KubeCon + CloudNative Con EU Virtual and our mentorship programs. We can’t wait to see more to come in the future months!

Let’s take a look at what we have achieved!

## News

To clear the concern of the community, we [transferred Placement Driver (PD) from PingCAP to TiKV side](https://tikv.org/blog/announcing-pd-transfer/). Following this migration, Scheduling SIG joined the TiKV community at #sig-scheduling on the [Slack channel](hubs.ly/H0tZbxf0). 

Hope all attendees had a great time at KubeCon + CloudNativeCon EU Virtual! We had two TiKV related talks presented. If you missed these talks, they are on-demand for anyone registered or check out YouTube Channel in early September.

*   [TiKV: A Cloud Native KeyValue Database](https://sched.co/a3vq)
*   [Serving Trillion-Record Table on TiKV](sched.co/bRVh)

## Releases

This month our team made 1 major release!

You can review the changelogs here:

*   [4.0.5](https://github.com/tikv/tikv/releases/tag/v4.0.5)
    *   New feature
        *   Define error code for errors in [#8387](https://github.com/tikv/tikv/pull/8387)
    *   Bug fixes

## Reading materials

In [Doubling System Read Throughput with Only 26 Lines of Code](https://tikv.org/blog/double-system-read-throughput/), [@c4pt0r](https://github.com/c4pt0r) introduced Follower Read, a feature that lets any follower replica in a Region serve a read request under the premise of strongly consistent reads.

[@nrc](https://github.com/nrc) blogged a post about talks at 2020 Virtual RustCon in [Rustconf 2020](https://tikv.org/blog/rustconf-20/). If you missed these talks, catch them up!

[@skyzh](https://github.com/skyzh) wrote [My CommunityBridge Mentorship with TiKV Project](https://tikv.org/blog/communitybridge-mentorship/) to share his experience in the CommunityBridge mentorship program with TiKV project as well as tips on collaborating with an opensource community.

## Notable PRs

*   [@Renkai](https://github.com/Renkai) implemented server-side streaming requests in coprocessor batch executors in [#8322](https://github.com/tikv/tikv/pull/8322).
*   [@skyzh](https://github.com/skyzh) added merge_null support for rpn_fn in [#8345](https://github.com/tikv/tikv/pull/8345).
*   [@de-sh](https://github.com/de-sh) added support for the cloud data store in [#517](https://github.com/tikv/rust-rocksdb/pull/517).
*   [@accelsao](https://github.com/accelsao) conducted port data-driven tests from CockroachDB in [#388](https://github.com/tikv/raft-rs/pull/388).
*   [@hicqu](https://github.com/hicqu) added the global entry cache to Raft engine in [#21](https://github.com/tikv/raft-engine/pull/21).
*   [@longfangsong](https://github.com/longfangsong) refactored the mod structure of txn commands in [#8296](https://github.com/tikv/tikv/pull/8296).
*   [@xhebox](https://github.com/xhebox) forbade adding multiple leaders over the same range in [#2761](https://github.com/tikv/pd/pull/2761).
*   [@disksing](https://github.com/disksing) supported the `RuleGroup` configuration in placement rules in [#2740](https://github.com/tikv/pd/pull/2740).
*   [@xhebox](https://github.com/xhebox) supported the batch deletion and insertion in [#2699](https://github.com/tikv/pd/pull/2699).
*   [@hskang9](https://github.com/hskang9) implemented part of VerKV functionalities in [#8282](https://github.com/tikv/tikv/pull/8282).

## Notable issues

**Help wanted issues**

*   [@nolouch](https://github.com/nolouch) created [#2843](https://github.com/tikv/pd/issues/2843), requesting to fix the issue that many heartbeat update operations might cause `GetRegion` timeout. 
*   [@JmPotato](https://github.com/JmPotato) added the roadmap of the cross-DC deployment of the local/global transaction in [#2759](https://github.com/tikv/pd/issues/2759). Join him if you are interested in Local/Global Transaction in Cross-DC Deployment.
*   [@Connor1996](https://github.com/Connor1996) suggested adding blob cache usage metrics for Titan in [#8552](https://github.com/tikv/tikv/issues/8552).

**Call for participation**

*   [@Connor1996](https://github.com/Connor1996) opened [#8486](https://github.com/tikv/tikv/issues/8486) to discuss solutions to the problem that too many RocksDB tombstones may slow batch-get.

## New Contributors

We’d like to welcome the following new contributors to TiKV and thank them for their work!

*   [@xxchan](https://github.com/xxchan)
*   [@mantuliu](https://github.com/mantuliu)
*   [@SASUKE40](https://github.com/SASUKE40)
*   [@Phosphorus15](https://github.com/Phosphorus15)
*   [@maoueh](https://github.com/maoueh)
*   [@xiongjiwei](https://github.com/xiongjiwei)
*   [@gentcys](https://github.com/gentcys)
*   [@tehbrut](https://github.com/tehbrut)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute to documentation, tests, optimizations, benchmarks, refactoring, or other useful things.