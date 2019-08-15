---
title: Try
description: Give TiKV a spin
menu:
    docs:
        parent: Tasks
        weight: 1
---

It's not always desirable to deploy a full production cluster of TiKV. If you just want to take TiKV for a spin, or get familiar with how it works, you may find yourself wanting to run TiKV locally.

In this section you'll find out two guides to get you started.

The first, [**for new developers building atop TiKV**](../developers), teaches you how to get a copy of TiKV running on your machine with Docker. Then you'll learn to connect a stateless query layer, TiDB. Finally, you'll connect and talk to the TiKV cluster using our [Rust client](../../../reference/clients/rust).

The second, [**for new administrators deploying TiKV**](../administrators), teaches you how to manually bootstrap, scale, and maintain a TiKV cluster on a single machine using Docker. After, you'll have the knowledge you need to start exploring the [Deploy](../deploy) guides for a production deployment.
