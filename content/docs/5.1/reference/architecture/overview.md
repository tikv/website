---
title: Overview
description: Core concepts and architecture behind TiKV.
menu:
    "5.1":
        parent: Architecture
        weight: 1
---

This page discusses TiKV's architecture overview.

## APIs

TiKV provides two APIs that you can use to interact with it:

| API           | Description                                                                           | Atomicity     | Use when...                                                                   |
|:------------- |:------------------------------------------------------------------------------------- |:------------- |:----------------------------------------------------------------------------- |
| Raw           | A lower-level key-value API for interacting directly with individual key-value pairs. | Single key    | Your application requires low latency and doesn't use multi-key transactions. |
| Transactional | A higher-level key-value API that provides snapshot isolation transaction.            | Multiple keys | Your application requires distributed transactions.                           |

## System architecture

The overall architecture of TiKV is illustrated below:

{{< figure
    src="/img/basic-architecture.png"
    caption="The architecture of TiKV"
    alt="TiKV architecture diagram"
    width="70" >}}

## TiKV instance

The architecture of each TiKV instance is illustrated below:

{{< figure
    src="/img/tikv-instance.png"
    caption="TiKV instance architecture"
    alt="TiKV instance architecture diagram"
    width="60" >}}

## The origins of TiKV

TiKV was originally created by [PingCAP](https://pingcap.com) as the storage layer of [TiDB](https://github.com/pingcap/tidb), a distributed [HTAP](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing_(HTAP)) database compatible with the [MySQL protocol](https://dev.mysql.com/doc/dev/mysql-server/latest/PAGE_PROTOCOL.html).
