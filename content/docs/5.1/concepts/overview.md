---
title: Get Started
description: TiKV Introduction
menu:
    "5.1":
        weight: 1
---

**TiKV** is a highly scalable, low latency, and easy to use key-value database that delivers single-digit millisecond performance at any scale.

TiKV is intended to fill the role of a unifying distributed storage layer. TiKV excels at working with **data in the large** by supporting petabyte scale deployments spanning trillions of rows.

As a graduate project of the [Cloud Native Computing Foundation](https://www.cncf.io/), TiKV is originally created by [PingCAP](https://pingcap.com/en) to complement [TiDB](https://github.com/pingcap/tidb).

{{< info >}}
The **Ti** in TiKV stands for **titanium**. Titanium has the highest strength-to-density ratio of any metallic element and is named after the Titans of Greek mythology.
{{< /info >}}

## Architecture

A TiKV cluster consists of the following components:

- A group of TiKV nodes: storing key-value pair data
- A Placement Driver (PD) node: working as the manager of the TiKV cluster

TiKV clients interact with PD and TiKV through gRPC.

{{< figure
    src="/img/basic-architecture.png"
    alt="TiKV architecture diagram"
    caption="The architecture of TiKV"
    width="70" >}}

You can read more in the [Core concepts and architecture behind TiKV](../../reference/architecture/overview/) documentation.

## What's Next

[TiKV in 5 Minutes](../tikv-in-5-minutes/) is strongly recommended if you want to try TiKV.