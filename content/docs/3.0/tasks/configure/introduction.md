---
title: Configure
description: Configure a wide range of TiKV facets, including RocksDB, gRPC, the Placement Driver, and more
menu:
    "3.0":
        parent: Tasks
        weight: 3
---

TiKV features a large number of configuration options you can use to tweak TiKV's behavior. When getting started with TiKV, it's usually safe to start with the defaults, configuring only the `--pd` (`pd.endpoints`) configuration.

There are several guides that you can use to inform your configuration:

* [**Security**](../security): Use TLS security and review security procedures.
* [**Topology**](../topology): Use location awareness to improve resilency and performance.
* [**Namespace**](../namespace): Use namespacing to configure resource isolation.
* [**Limit**](../limit): Tweak rate limiting.
* [**Region Merge**](../region-merge): Tweak region merging.
* [**RocksDB**](../rocksdb): Tweak RocksDB configuration options.
* [**Titan**](../titan): Enable titan to improve performance with large values.

You can find an exhaustive list of all options, as well as what they do, in the documented [**full configuration template**](https://github.com/tikv/tikv/blob/release-3.0/etc/config-template.toml).

