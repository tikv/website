---
title: Get Started
description: TiKV Introduction
menu:
    "6.1":
        weight: 2
        identifier: Get Started-v6.1
---

**TiKV** is a highly scalable, low latency, and easy to use key-value database that delivers performance less than 10 ms at any scale.

TiKV is intended to fill the role of a unified distributed storage layer. TiKV excels at working with **large-scale data** by supporting petabyte-scale deployments spanning trillions of rows.

As a graduate project of the [Cloud Native Computing Foundation](https://www.cncf.io/), TiKV is originally created by [PingCAP](https://pingcap.com/en) to complement [TiDB](https://github.com/pingcap/tidb).

{{< info >}}
The **Ti** in TiKV stands for **titanium**. Titanium has the highest strength-to-density ratio than any other metallic elements and is named after the Titans of Greek mythology.
{{< /info >}}

## Architecture

A TiKV cluster consists of the following components:

- A group of TiKV nodes: store key-value pair data
- A group of Placement Driver (PD) nodes: work as the manager of the TiKV cluster

TiKV clients let you connect to a TiKV cluster and use raw (simple get/put) API or transaction (with transactional consistency guarantees) API to access and update your data. TiKV clients interact with PD and TiKV through gRPC.

{{< figure
    src="/img/basic-architecture.png"
    alt="TiKV architecture diagram"
    caption="Architecture of TiKV"
    width="70" >}}

For more information about the architecture, see [Core concepts and architecture behind TiKV](../../reference/architecture/overview/).

## What's Next

[TiKV in 5 Minutes](../tikv-in-5-minutes/) is strongly recommended if you want to try TiKV.
