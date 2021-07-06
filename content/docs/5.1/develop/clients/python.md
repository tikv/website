---
title: Python Client
description: Interact with TiKV using Python.
menu:
    "5.1":
        parent: TiKV Clients
        weight: 4
---

TiKV client for python is built on top of [TiKV Client in Rust](https://github.com/tikv/client-rust) via CFFI and [PyO3 Python binding](https://github.com/PyO3/pyo3).

Python client is still in the stage of prove-of-concept and under heavy development. You can track development at [tikv/client-py](https://github.com/tikv/client-py/) repository.

{{< warning >}}
You should not use the Python client for production use until it is released.
{{< /warning >}}
