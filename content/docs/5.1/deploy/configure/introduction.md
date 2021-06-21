---
title: Configure TiKV
description: Configure a wide range of TiKV facets, including RocksDB, gRPC, the Placement Driver, and more.
menu:
    "5.1":
        parent: Deploy
        weight: 2
---

Though it's recommended to start with the default configurations when getting started with TiKV, TiKV features a large number of configuration parameters to tweak its behavior, which enables users to config the cluster to fit for the special application requirement.

The following topics describes how to config different TiKV components:

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
