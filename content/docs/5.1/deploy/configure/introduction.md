---
title: Configure TiKV
description: Configure a wide range of TiKV facets, including RocksDB, gRPC, the Placement Driver, and more.
menu:
    "5.1":
        parent: Deploy
        weight: 2
---

It is recommended to get started with TiKV with default configurations. However, TiKV features a large number of configuration parameters to tweak its behavior, allowing you to configure the cluster to suit your special application requirements.

The following documents guide you on how to configure different TiKV components:

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
- [Titan](../titan): Enable Titan to improve performance with large values.
- [Storage](../storage): Learn how to configure storage in TiKV.
- [gRPC](../grpc): Learn how to configure gRPC in TiKV.
- [Coprocessor](../coprocessor): Learn how to configure Coprocessor in TiKV.
