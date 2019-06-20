---
title: Distributed Systems Training in Rust and Go
date: 2019-06-20
author: Brian Anderson, Senior Database Engineer for TiKV
---

On the TiKV team we love the [Rust] and [Go] programming languages. They are the
languages in which we write most of our software, with TiKV in Rust, and its
sister project, [TiDB], in Go. They have empowered us to build these
fast and reliable distributed systems from the ground up, and iterate on them
quickly and confidently.

These languages are the future of systems programming.

Creating reliable distributed systems like TiKV demands a lot from contributors
&mdash; they not only need to be experts in storage and distributed systems, but
also to be comfortable expressing that knowledge in these modern languages.

The software we develop is on the cutting edge of distributed systems, storage
technology, software design, and programming language theory, and yet there are
few opportunities for students to gain hands-on experience with this
intersection of technologies.

As a CNCF project, we are committed to mentoring the next generation of systems
programmers, those who are beginning their careers in a world that is quickly
adopting next-generation systems languages.

To this end, PingCAP is creating a [series of training courses][c] on writing
distributed systems in Rust and Go. These courses consist of:

- **[Practical Networked Applications in Rust][c-rust]**. A series of projects
  that incrementally develop a single Rust project from the ground up into a
  high-performance, networked, parallel and asynchronous key/value store. Along
  the way various real-world and practical Rust development subject matter are
  explored and discussed.

- **[Distributed Systems in Rust][c-dss]**. Adapted from the [MIT 6.824]
  distributed systems coursework, this course focuses on implementing important
  distributed algorithms, including the [Raft] consensus algorithm, and
  the [Percolator] distributed transaction protocol.

- **[Distributed Systems in Go][c-go]**. A course on implementing implementing
  algorithms necessary in distributed databases, including map reduce, and
  parallel query optimization.

Today they are in an early state, but we would appreciate if you give them a
look and help us improve them over at our [PingCAP Talent Plan][c].

[Go]: https://golang.org/
[Rust]: https://www.rust-lang.org/
[TiDB]: http://github.com/pingcap/tidb
[TiKV]: https://github.com/tikv/tikv/
[c]: https://github.com/pingcap/talent-plan
[c-rust]: https://github.com/pingcap/talent-plan/tree/master/rust
[c-dss]: https://github.com/pingcap/talent-plan/tree/master/dss/
[c-go]: https://github.com/pingcap/talent-plan/tree/master/tidb/
[MIT 6.824]: http://nil.csail.mit.edu/6.824/2017/index.html
[Raft]: https://raft.github.io/
[Percolator]: https://storage.googleapis.com/pub-tools-public-publication-data/pdf/36726.pdf
