---
title: C++ Client
description: Interact with TiKV using C++.
menu:
    "5.1":
        parent: TiKV Clients
        weight: 5
---

TiKV client for C++ is built on top of [TiKV Client in Rust](https://github.com/tikv/client-rust) via [cxx](https://github.com/dtolnay/cxx).

This client is still in the stage of prove-of-concept and under heavy development. You can track development at [tikv/client-cpp](https://github.com/tikv/client-cpp/) repository.

{{< warning >}}
You are not suggested to use the C++ client for production use until it is released.
{{< /warning >}}
