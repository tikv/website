---
title: Tasks
description: How to accomplish common tasks with TiKV
menu:
    nav:
        parent: Docs
        weight: 2
    docs:
        weight: 2
---

Learn to try, deploy, configure, monitor, then scale TiKV as you adopt the service into your project and infrastructure.


## [Try](../try/introduction)

It's not always desirable to deploy a full production cluster of TiKV. If you just want to take TiKV for a spin, or get familiar with how it works, you may find yourself wanting to run TiKV locally.

In the [**try**](../try/introduction) section you'll find out two guides to get you started.

The first, [**for new developers building atop TiKV**](../try/developers), teaches you how to get a copy of TiKV running on your machine with Docker. Then you'll learn to connect a stateless query layer, TiDB. Finally, you'll connect and talk to the TiKV cluster using our [Rust client](../../reference/clients/rust).

The second, [**for new administrators deploying TiKV**](../try/administrators), teaches you how to manually bootstrap, scale, and maintain a TiKV cluster on a single machine using Docker. After, you'll have the knowledge you need to start exploring the [Deploy](../deploy) guides for a production deployment.


## [Deploy](../deploy/introduction)

In the [**deploy**](../deploy/introduction) section you'll find several guides to help you deploy & integrate TiKV into your infrastructure.

Currently the best supported and most comprehensive deployment solution is to [**Deploy TiKV using Ansible**](../deploy/ansible/). In this guide you'll learn to deploy and maintain TiKV using the same scripts PingCAP deploys TiKV with inside of many of our [adopters](/adopters).

If you're determined to strike it out on your own, we've done our best to provide you with the tools you need to build your own solution. Start by choosing between the [**Docker**](../deploy/docker) and [**Binary**](../deploy/binary) options.


## [Configure](../configure/introduction)

Learn about how you can configure TiKV to meet your needs in the [**configure**](../configure/introduction) section. There you'll find a number of guides including:

* [**Security**](../configure/security): Use TLS security and review security procedures.
* [**Topology**](../configure/topology): Use location awareness to improve resilency and performance.
* [**Namespace**](../configure/namespace): Use namespacing to configure resource isolation.
* [**Limit**](../configure/limit): Tweak rate limiting.
* [**Region Merge**](../configure/region-merge): Tweak region merging.
* [**RocksDB**](../configure/rocksdb): Tweak RocksDB configuration options.
* [**Titan**](../configure/titan): Enable titan to improve performance with large values.


## [Monitor](../monitor/introduction)

Learn how to inspect a TiKV cluster in the [**Monitor**](../monitor/introduction) section. You'll find out how to [**check the component state interface or collect Prometheus metrics**](../monitor/tikv-cluster/), as well as review the [**key metrics**](../monitor/key-metrics/) to be aware of.


## [Scale](../scale/introduction)

As your dataset and workload change you'll eventually need to scale TiKV to meet these new demands. In the [**Scale**](../scale/introduction) section you'll find out how to grow and shrink your TiKV cluster.

If you deployed using Ansible, please check the [**Ansible Scaling**](../scale/ansible) guide.