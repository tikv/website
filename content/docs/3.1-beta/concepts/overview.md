---
title: Concepts
description: Some basic facts about TiKV
menu:
    nav:
        name: Concepts
        parent: Docs
        weight: 1
    "3.1-beta":
        weight: 1
---

**TiKV** is a distributed transactional key-value database originally created by [PingCAP](https://pingcap.com/en) to complement [TiDB](https://github.com/pingcap/tidb).

As an incubating project of the [Cloud Native Computing Foundation](https://www.cncf.io/), TiKV is intended to fill the role of a unifying distributed storage layer. TiKV excels at working with **data in the large** by supporting petabyte scale deployments spanning trillions of rows.

It compliments other CNCF projects technologies like [etcd](https://etcd.io/) which is useful for low-volume metadata storage, and can be extended using [stateless query layers](../../reference/query-layers) which speak other protocols, like [TiDB](https://github.com/pingcap/tidb) speaking MySQL.

{{< info >}}
The **Ti** in TiKV stands for **titanium**. Titanium has the highest strength-to-density ratio of any metallic element and is named after the Titans of Greek mythology.
{{< /info >}}

## Notable Features

{{< features featured >}}

You can browse a complete list on the [features](../features) page.

## Architecture

{{< figure
    src="/img/basic-architecture.png"
    caption="The architecture of TiKV"
    alt="TiKV architecture diagram"
    width="70"
    number="1" >}}

You can read more in the [Concepts and architecture](../architecture/) documentation.

## Codebase, Inspiration, and Culture

TiKV is implemented in the [Rust](https://rust-lang.org) programming language. It uses technologies like [Facebook's RocksDB](https://rocksdb.org/) and [Raft](https://raft.github.io/).

The project was originally inspired by [Google Spanner](https://ai.google/research/pubs/pub39966) and [HBase](https://hbase.apache.org).