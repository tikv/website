---
title: CNCF TOC votes to move TiKV to Incubating Status
date: 2019-05-21
author: The TiKV Team
tags: ['Community', 'CNCF', 'Announcement']
---

Today, the [Cloud Native Computing Foundation](http://cncf.io/)’s (CNCF) [Technical Oversight Committee](https://github.com/cncf/toc) (TOC) voted to accept TiKV as an incubation-level hosted project.

**The full announcement can be found on the [CNCF blog](https://www.cncf.io/blog/2019/05/21/toc-votes-to-move-tikv-into-cncf-incubator/), and you can find us listed under the [CNCF Incubating Projects](https://www.cncf.io/projects/).**

We'd like to thank all of our contributors, users, and advocates over the last several years for helping us reach this very important milestone! Thank you!

As a CNCF incubating project we'll continue to enjoy many of the [benefits and services](https://www.cncf.io/services-for-projects/) the foundation offers, as well as greater worldwide visibility. This means a more vibrant contributor community, better tools, organizational support, and ultimately a better TiKV!

As part of our growth into this new position we've been steadily growing with the contributions from over 247 contributors (including companies like Samsung, Mobike, Ele.me, Tencent Cloud, and UCloud), maintainers from PingCAP and Zhihu, and an ecosystem of projects which use TiKV like TiDB, Tidis, Titan, Titea, and TiPrometheus.

Recently, we've been working on [evolving TiKV](https://github.com/tikv/tikv/blob/master/CHANGELOG.md) with features like:

* A new storage engine, optimized for larger values
* Increased across the board performance thanks to improved coprocessor, raftstore, and apply modules
* Supporting new operations like batch requests and reverse scanning
* A distributed garbage collector, allowing for more efficient and coordinated cleanup of old data
* Many small usability improvements like unified log formats
* Better time handling
* Monitoring information available over HTTP
* Improved and upgraded gRPC support
* Official Clients for Rust, Go, and Java

Want to test drive TiKV? You can follow our [Quick Start Guide](https://tikv.org/docs/tasks/quickstart/) to get a TiKV cluster running on your machine in minutes. Ready to go a step further? You can use [tidb-ansible](https://github.com/pingcap/tidb-ansible) to deploy a production ready cluster.

If you'd like to get involved with TiKV, or any related projects we invite you check out our [help wanted issues](https://github.com/tikv/tikv/labels/S%3A%20HelpWanted), see our [step-by-step coprocessor contribution guide](https://www.pingcap.com/blog/adding-built-in-functions-to-tikv/), or to join our [community chat](https://join.slack.com/t/tikv-wg/shared_invite/enQtNTUyODE4ODU2MzI0LTgzZDQ3NzZlNDkzMGIyYjU1MTA0NzIwMjFjODFiZjA0YjFmYmQyOTZiNzNkNzg1N2U1MDdlZTIxNTU5NWNhNjk) and introduce yourself!