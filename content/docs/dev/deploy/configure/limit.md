---
title: Scheduling Limit Config
description: Learn how to configure scheduling rate limit on stores.
menu:
    "6.1":
        parent: Configure TiKV-v6.1
        weight: 7
        identifier: Scheduling Limit Config-v6.1
---

This document describes how to configure the scheduling rate limit at the store level.

TiKV balance regions by the commands sent by PD. These commands are called scheduling operators. PD makes the scheduling operators based on the information gathered from TiKV and scheduling configurations.

`*-schedule-limit` in `pd-ctl` is usually used to set limits of the total number of various operators. However, `*-schedule-limit` might cause performance bottlenecks, because it applies to the entire cluster. 

## Configure scheduling rate limits on stores

PD provides two methods to configure scheduling rate limits on stores as follows:

1. Permanently set the scheduling rate limits by [store-balance-rate](../pd-configuration-file/#store-balance-rate) in `pd-ctl`.

    {{< info >}}
The configuration change only applies to the stores that are started afterward. If you want to apply this change to all stores, you need to restart all TiKV stores. If you want to apply this change immediately, see the [workaround](#workaround) below.
    {{< /info >}}

    `store-balance-rate` specifies the maximum number of scheduling tasks allowed for each store per minute. The scheduling step includes adding peers or learners.

      ```bash
      » config set store-balance-rate 20
      ```

2. Temporarily set the scheduling rate limits by `limit` in `pd-ctl`.

    {{< info >}}
The scheduling rate limit set by this method is lost after restarting TiKV, and the value previously set by method 1 is used instead.
    {{< /info >}}

    - **`stores set limit <rate>`**

        ```bash
        # Set the maximum number of scheduling operators per minute to be 20. Apply to all stores.
        » stores set limit 20
        ```

    - **`store limit <store_id> <rate>`**

        ```bash
        # Set the maximum number of scheduling operators per minute to be 20. Apply to store 2.
        » store limit 2 10
        ```

## Read current scheduling rate limits on stores

  - **`store show limit`**

    ```bash
    » stores show limit
    {
        "4": {
            "rate": 15
        },
        "5": {
            "rate": 15
        },
        # ...
    }
    ```

## Workaround

By combining method 1 and method 2, you can permanently modify the rate limit to 20 and applies it immediately.

    ```bash
    » config set store-balance-rate 20
    » stores set limit 20
    ```
