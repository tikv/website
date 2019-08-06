---
title: This Month in TiKV - July 2019
date: 2019-08-07
author: Nick Cameron
---

Hi! Welcome to the first ever edition of 'This Month in TiKV', covering July 2019. As the name suggests, this is a monthly newsletter covering interesting things happening in the world of [TiKV](https://tikv.org/), an open-source, distributed key-value store.

We're just getting started with the newsletter, and you should expect it to evolve as we go along. We hope to cover news and events of interest to TiKV contributors and users, significant PRs and issues in the TiKV [repo](https://github.com/tikv/tikv), and generally keep you informed of what is going on. Since this is the first issue we'll cover a few bits of news from before July.

You'll find the newsletter [on the TiKV blog](https://tikv.org/blog/) from the first week of each month.

[Let us know](https://github.com/tikv/website/issues/new) what you think!

## News

We [released version 3.0](https://tikv.org/blog/tikv-3.0ga/) of TiKV! This was a huge and exciting release, and is accompanied by the 3.0 release of [TiDB](https://pingcap.com/blog/tidb-3.0-announcement/).

Jepsen tested TiDB and TiKV in a detailed [analysis](https://pingcap.com/blog/tidb-passes-jepsen-test-for-snapshot-isolation-and-single-key-linearizability/). This focused on transaction guarantees and failure testing.

In other news, PingCAP also released 1.0 of TiDB Operator, a tool for deploying TiDB in the cloud. Release announcement in [English](https://pingcap.com/blog/database-cluster-deployment-and-management-made-easy-with-kubernetes/) and [Chinese](https://pingcap.com/blog-cn/tidb-operator-1.0-ga/)


## Reading material

Some blog posts and articles related to TiKV:

* The TiKV team launched a [training course](https://tikv.org/blog/talent-training/) covering Rust and distributed systems (English).
* Nick Cameron wrote about migrating the Rust TiKV client from [futures 0.1 to 0.3](https://www.ncameron.org/blog/migrating-a-crate-from-futures-0-1-to-0-3/) (English).
* Ana Hobden wrote on the PingCAP blog about [benchmarking distributed databases](https://www.pingcap.com/blog/why-benchmarking-distributed-databases-is-so-hard/) (English).
* Source code reading posts on [an analysis of control flow through service layers](https://pingcap.com/blog-cn/tikv-source-code-reading-9/), [Snapshot send and receive](https://pingcap.com/blog-cn/tikv-source-code-reading-10/), and [Storage and transaction control](https://pingcap.com/blog-cn/tikv-soucre-code-reading-11/) (Chinese).


## Current projects

There's lots going on in the TiKV ecosystem, here we'll try to highlight some of the interesting projects.

### Performance

There's ongoing work to measure and improve TiKV's performance in all areas. We hope to report more on specifics soon. We've been making heavy use of tools like Intel Vtune and flamegraphs to find the slowest parts of TiKV. We hope to report more on specifics soon.


### Titan

[Titan](https://github.com/pingcap/titan) is a storage engine which improves on RocksDB. It is part of TiKV already and you can try it out by following [these instructions](https://tikv.org/docs/3.0/tasks/configure/titan/). Note that you can't go back to RocksDB after enabling Titan. We're working to improve its performance and stability. You can read more in this [blog post](https://pingcap.com/blog/titan-storage-engine-design-and-implementation/).


### Docs

We are currently migrating [our documentation](https://tikv.org/docs/3.0/concepts/overview/) from the TiKV's wiki to the official website. We'll also be refactoring much of our documentation over the coming months. If you feel something is lacking please let us know!


### Replica read

Replica read allows a database to read from a Raft follower, not just the leader. This greatly improves read performance when the client is close to a follower, but far from the leader (e.g., in different data centres). This feature is implemented in TiKV and we are working on adding support to TiDB.


### Protobuf implementation

We're experimenting with different implementations of Protocol Buffers (which underpin all our RPC communication). We've added support for [Prost](https://github.com/danburkert/prost) to our supporting libraries, and are working on adding support to TiKV.


### Testing and stability

We're working on making testing more reliable, adding long-running tests to our CI, and monitoring performance.


### Adding RPN functions

TiKV supports executing SQL functions on the database using its coprocessor. We've been working to support RPN (reverse polish notation) functions, which are an optimisation technique for coprocessor. In the past month we've added support for `coalesce`, `in`, `case_when`, `if`, `abs`, `multiply`, `divide`, and `date_format`. There is [more information](https://pingcap.com/blog/adding-built-in-functions-to-tikv/) about implementing coprocessor functions.


### Rust client

We're working on implementing a [client library](https://github.com/tikv/client-rust/) for TiKV in Rust. This will support very high performance TiKV clients.


### Compile times

Waiting for code to compile is a pain, and TiKV can take quite a while to compile (especially in release mode). We've been working hard to improve that, for example in [#4996](https://github.com/tikv/tikv/pull/4996).


## RFCs

[RFCs](https://github.com/tikv/rfcs) (Request For Comments) are how the TiKV team engages with the wider community to do open design of new features and major changes.

Currently, the RFCs for a [Rust client](https://github.com/tikv/rfcs/pull/7) and a [command line client](https://github.com/tikv/rfcs/pull/21) are in the final stages of discussion. There is also an interesting [RFC](https://github.com/tikv/rfcs/pull/17) to add a dedicated thread to TiKV for reading from the local raftstore, which is almost ready to be accepted.


## Notable PRs

In [PR 5041](https://github.com/tikv/tikv/pull/5041) we added support for [Mimalloc](https://github.com/microsoft/mimalloc), a new allocator from Microsoft. You currently have to opt-in to use it using `MIMALLOC=1` when building. Benchmarking has been inconclusive so far.

In [PR 5155](https://github.com/tikv/tikv/pull/5155) we created a new crate inside the tikv repository called `tidb_query`, it contains large parts of the coprocessor which have been moved from `src/coprocessor/dag`. The PR also renames the `cop_xxx` crates to `tidb_query_xxx`. Due to increased parallelism, this improves compile times by up to 25%.

In [PR 5036](https://github.com/tikv/tikv/pull/5036) the tikv importer was moved out of the tikv repository and into its own repository.


## Notable issues

When running TiKV on older CPUs, a `sigill` could be triggered originating in Titan. This has been fixed on master and will be fixed in the next point release. In the meantime, you can resolve this issue by building from source. [Issue 4999](https://github.com/tikv/tikv/issues/4999).


## New contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

* [Luca Bruno](https://github.com/lucab)
* [Luffbee](https://github.com/Luffbee)
* [jiyingtk](https://github.com/jiyingtk)
* [divinerapier](https://github.com/divinerapier)
* [Pratyush Singhal](https://github.com/psinghal20)
* [Jacob Lerche](https://github.com/jlerche)
* [mwish](https://github.com/mapleFU)
* [uvd](https://github.com/uvd)

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.


## This Week in TiDB

For more rapid and detailed information about TiKV progress, PingCAP publishes weekly updates about TiDB and TiKV. The following cover July,

* [2019-07-08](https://pingcap.com/weekly/2019-07-08-tidb-weekly/)
* [2019-07-15](https://pingcap.com/weekly/2019-07-15-tidb-weekly/)
* [2019-07-22](https://pingcap.com/weekly/2019-07-22-tidb-weekly/)
* [2019-07-29](https://pingcap.com/weekly/2019-07-29-tidb-weekly/)

