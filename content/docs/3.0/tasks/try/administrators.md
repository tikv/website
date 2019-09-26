---
title: Administrators
description: Try docker locally
menu:
    docs:
        parent: Try
---

In this guide, you'll learn how to quickly get a tiny TiKV cluster running locally, then you'll learn how to do some basic administrative tasks with the cluster. You'll also learn some common configuration options and when you might want to use them.

This guide will talk briefly about security, resiliency, and production readiness, but these topics are covered much more in depth in the [deploy](../../deploy/introduction) guides. This guide won't discuss interacting with data within TiKV itself (see the [developers](../developers) guide) or developing TiKV itself (See [`CONTRIBUTING.md`](https://github.com/tikv/tikv/blob/master/CONTRIBUTING.md).) Instead, this guide will try to introduce you to what it's like to administrate TiKV.

## Overview

The simplest deployment of TiKV requires two interacting services, PD and TiKV. PD works alongside TiKV to act as a coordinator and timestamp oracle.

TODO: GRaph

Communication between TiKV, PD, and any services which use TiKV is done via gRPC. We provide clients for [several languages](../../../reference/clients/introduction/), and this guide will briefly show you how to use the Rust client.

Using Docker, you'll create pair of replicated persistent services `tikv` and `pd` and use them to explore how TiKV works. You'll learn how to add and remove nodes, check cluster health, collect metrics, and change the configuration of both services.

{{< warning >}}
In a production deployment there would be **at least** three TiKV services and three PD services spread among 6 machines. Most deployments also include kernel tuning, sysctl tuning, robust systemd services, firewalls, monitoring with prometheus, grafana dashboards, log collection, and more. Even still, to be sure of your resilience and security, consider consulting our [maintainers](https://github.com/tikv/tikv/blob/master/MAINTAINERS.md).

If you are interested in deploying for production we suggest investigating the [deploy](../../deploy/introduction) guides after this guide.
{{< /warning >}}

While it's possible to use TiKV through a query layer, like [TiDB](https://github.com/pingcap/tidb) or [Titan](https://github.com/distributedio/titan), you should  refer to the user guides of those projects in order to set up test clusters. This guide only deals with TiKV, PD, and their control planes.

