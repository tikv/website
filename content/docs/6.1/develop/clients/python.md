---
title: Python Client
description: Interact with TiKV using Python.
menu:
    "6.1":
        parent: TiKV Clients-v6.1
        weight: 4
        identifier: Python Client-v6.1
---

TiKV client for python is built on top of [TiKV Client in Rust](https://github.com/tikv/client-rust) via CFFI and [PyO3 Python binding](https://github.com/PyO3/pyo3).

The Python client is still in the proof-of-concept stage and under development. You can track the development at [tikv/client-py](https://github.com/tikv/client-py/) repository.

{{< warning >}}
You should not use the Python client for production use until it is released.
{{< /warning >}}
