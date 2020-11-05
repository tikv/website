---
title: SIG-txn reading group, Nov + Dev 2020
author: Nick Cameron
date: 2020-11-04
tags: ['Research', 'Transactions', 'Community', "SIG"]
---
The [TiKV transactions SIG](https://tikv.org/community/sig-transaction/) is starting up its reading group. We'll try to read and discuss a paper each month. If you're interested in research in distributed transactions, come join in!

We'll start by reading 'Industrial-Strength OLTP Using Main Memory and Many Cores', by Avni et al. at Huawei Research Centre. It was published in the proceedings of VLDB 2020 and you can download it from [them](http://www.vldb.org/pvldb/vol13/p3099-avni.pdf).

The paper describes a new storage engine for GaussDB (an HTAP (OLTP + OLAP) database from Huawei), that includes a transaction system, and a JIT compiler for SQL processing. For the full abstract, see below. (I realise that's a brief summary, I haven't read it yet so I can discuss it in real time with the group).

Since we're just starting and there's the Christmas break next month, we'll be reading this paper through November and December. During that time anyone interested can discuss anything in the paper (or related to the paper) in a dedicated slack channel: [#sig-txn-reading-group-nov-dec-21](https://tikv-wg.slack.com/archives/C01DNV3LQSJ). If there is interest, then we'll have a live discussion on Zoom and/or a presentation hosted by the SIG in early January. We'll record any artefacts and some discussion highlights in the [sig-txn repo](https://github.com/tikv/sig-transaction).

If you'd like to nominate a paper to read next month (January 2021), please add it to this [issue](https://github.com/tikv/sig-transaction/issues/67). Any research paper or white paper which covers distributed transactions or related work are suitable, both recent work and classics. We'll choose one and let everyone know around the end of December.

This is our first time running a remote reading group, so we'll need to evolve things as we go along. If you have any suggestions please let us know!

Looking forward to discussing the paper with you in Slack!

## Paper abstract

> GaussDB, and its open source version named openGauss, are Huawei’s relational database management systems (RDBMS), featuring a primary disk-based storage engine. This paper presents a new storage engine for GaussDB that is optimized for main memory and many cores. We started from a research prototype which exploits the power of the hardware but is not useful for customers. This paper describes the details of turning this prototype to an industrial storage engine, including integration with GaussDB. Standard benchmarks show that the new engine provides more than 2.5x performance improvement to GaussDB for full TPC-C on Intel’sx86 many-cores servers, as well as on Huawei TaiShan servers powered by ARM64-based Kunpeng CPUs.
