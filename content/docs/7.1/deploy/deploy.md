---
title: Deploy
description: Learn how to deploy and operate a TiKV cluster
menu:
    "7.1":
        weight: 3
        identifier: Deploy-7.1
---

Learn to deploy, configure, monitor, and scale TiKV as you adopt the service into your project and infrastructure.

## [Install TiKV](../install/install/)

In the [Install TiKV](../install/install/) section you’ll find several guides to help you deploy and integrate TiKV into your infrastructure.

The best supported and most comprehensive deployment solution for production environment is to [Deploy TiKV using TiUP](../install/production/).

If you’re determined to strike it out on your own, we’ve done our best to provide you with the tools you need to build your own solution. Start with [Install binary manually](../install/test/#install-binary-manually).

If you want to try TiKV on your own Mac or Linux machine, please try [TiUP Playground](../install/test/#tiup-playground).

## [Configure TiKV](../configure/introduction/)

Learn about how you can configure TiKV to meet your needs in the [configure](../configure/introduction/) section. There you’ll find a number of guides including:

PD

- [PD Command Line Parameters](../pd-command-line): Learn configuration flags of PD.
- [PD Config](../pd-configuration-file): Learn the PD configuration file.

TiKV

- [TiKV Command Line Parameters](../tikv-command-line): Learn configuration flags of TiKV.
- [TiKV Config](../tikv-configuration-file): Learn the TiKV configuration file.
- [Security](../security): Use TLS security and review security procedures.
- [Topology Lable](../topology): Use location awareness to improve resiliency and performance.
- [Limit](../limit): Learn how to configure scheduling rate limit on stores.
- [Region Merge](../region-merge): Tweak region merging.
- [RocksDB](../rocksdb): Tweak RocksDB configuration parameters.
- [Raftstore](../raftstore): Learn how to configure Raftstore in TiKV.
- [Titan](../titan): Enable titan to improve performance with large values.
- [Storage](../storage): Learn how to configure storage in TiKV.
- [gRPC](../grpc): Learn how to configure gRPC in TiKV.
- [Coprocessor](../coprocessor): Learn how to configure Coprocessor in TiKV.


## [Benchmark and Performance](../benchmark/benchmark/)

## [Monitor and Alert](../monitor/monitor/)

Learn how to inspect a TiKV cluster in the [Monitor and Alert](../monitor/monitor/) section. You’ll find out 

- [Monitoring Framework](../monitor/framework/): Use Prometheus and Grafana to build the TiKV monitoring framework.
- [Monitoring API](../monitor/api/): Learn the API of TiKV monitoring services.
- [Deploy Monitoring Services](../monitor/deploy/): Learn how to deploy monitoring services for the TiKV cluster.
- [Export Grafana Shapshots](../monitor/grafana/): Learn how to export snapshots of Grafana Dashboard, and how to visualize these files.
- [Key Metrics](../monitor/key-metrics/): Learn some key metrics displayed on the Grafana Overview dashboard.
- [TiKV Cluster Alert Rules](../monitor/alert/): Learn the alert rules in a TiKV cluster.

## [Operate TiKV](../operate/operate/)

This section introduces how to maintain and operate a TiKV cluster.

- [Upgrade a TiKV cluster using TiUP](../operate/upgrade): Learn how to upgrade TiKV using TiUP
- [Scale out/in a TiKV cluster using TiUP](../operate/scale): How to grow and shrink your TiKV cluster.
- [Maintain a TiKV cluster using TiUP](../operate/maintain): Learn the common operations to operate and maintain a TiKV cluster using TiUP
