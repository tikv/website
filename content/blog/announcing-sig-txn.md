---
title: Announcing the Transaction SIG
date: 2020-07-21
author: The transaction SIG
---

[TiKV](https://github.com/tikv/tikv) has been open source since almost its beginning. Over the past year or so we've been trying to build a better, more open community around TiKV. Recently, we've been forming *special interest groups* (SIGs) to better organize and govern our community. Today, we are pleased to announce the official launch of the [Transaction SIG](https://tikv.org/community/sig-transaction/).

## Transactions

Transactions have been part of database systems for decades. In distributed databases they are the key mechanism for supporting properties such as isolation and consistency (well known from the ACID property and the CAP theorem), in other words, making it possible to manage a distributed database in a similar way to a non-distributed one.

TiKV supports distributed transactions based on [Percolator](https://tikv.org/deep-dive/distributed-transaction/percolator/), and implemented using MVCC and a collaborative protocol between the TiKV server and its client. Using the transactional API, TiKV guarantees Snapshot Isolation and Linearizability. The transaction sub-system also handles the scheduling of command execution, local concurrency control, and efficient execution of reads and scans.

A strong transaction system is essential to making TiKV fast and correct.

## The Transaction SIG

The Transaction SIG is a group for people interested in transactions in TiKV or distributed transactions in general. In addition to working on the implementation in TiKV (including testing, modelling, documenting, and bug-finding, as well as writing code), the SIG aims to be a place for people to discuss how to use transactions, understand how transactions work and how to make the best use of them, and keep up to date with transaction-related research.

We plan to start with a focussed push to [improve documentation](https://github.com/tikv/sig-transaction/issues/25), discussing [the Cockroach DB paper](https://www.cockroachlabs.com/guides/cockroachdb-the-resilient-geo-distributed-sql-database-sigmod-2020/) in our [reading group](https://github.com/tikv/sig-transaction/issues/31), and an introductory-level [talk](https://github.com/tikv/sig-transaction/issues/30) on isolation and consistency properties (planned for some time in early August, join the mailing list or watch the repo to find out more).

If this sounds interesting, come and get involved! We hang out on the TiKV community Slack in the [#sig-transaction](https://slack.tidb.io/invite?team=tikv-wg&channel=sig-transaction&ref=community-sig) channel. We have a low-volume mailing list [you can join](https://groups.google.com/d/forum/tikv-sig-transaction) for announcements on what we're up to. We have a [repository](https://github.com/tikv/sig-transaction) for more information about the group, and where we do design work, etc.
