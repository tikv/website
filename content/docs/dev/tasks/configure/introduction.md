---
title: Configure
description: Configure a wide range of TiKV facets, including RocksDB, gRPC, the Placement Driver, and more.
menu:
    "dev":
        parent: Tasks
        weight: 3
---

TiKV features a large number of configuration parameters you can use to tweak TiKV's behavior. When getting started with TiKV, it's usually safe to start with the defaults, configuring only the `--pd` (`pd.endpoints`) option.

There are several guides that you can use to inform your configuration:

* [**Security**](../security): Use TLS security and review security procedures.
* [**Topology**](../topology): Use location awareness to improve resiliency and performance.
* [**Namespace**](../namespace): Use namespacing to configure resource isolation.
* [**Limit**](../limit): Tweak rate limiting.
* [**Region Merge**](../region-merge): Tweak region merging.
* [**RocksDB**](../rocksdb): Tweak RocksDB configuration parameters.
* [**Raftstore**](../raftstore): Tweak Raftstore configuration parameters.
* [**Titan**](../titan): Enable titan to improve performance with large values.
* [**PD**](../pd): Tweak PD parameters that are not included in command-line parameters.
* [**Storage**](../storage): Tweak storage configuration parameters.
* [**gRPC**](../grpc): Tweak gRPC configuration parameters.
* [**Coprocessor**](../coprocessor): Tweak Coprocessor configuration parameters.

You can find an exhaustive list of all parameters, as well as what they do, in the documented [**full configuration template**](https://github.com/tikv/tikv/blob/master/etc/config-template.toml).
