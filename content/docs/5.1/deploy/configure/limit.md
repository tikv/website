---
title: Scheduling Limit Config
description: Learn how to configure scheduling rate limit on stores.
menu:
    "5.1":
        parent: Configure TiKV
        weight: 7
---

This section describes how to configure the scheduling rate limit at the store level.

TiKV balance regions by the command sent by PD. The commands are called scheduling operators. PD makes scheduling operators based on the information gathered from TiKV and scheduling configurations.

`*-schedule-limit` in `pd-ctl` is usually used to set limits of the total number of various operators, but it may cause performance bottlenecks because it applies to the entire cluster. In this section, we will learn how to configure the rate limit at the store level.

## Configure scheduling rate limits on stores

PD provides two methods to configure scheduling rate limits on stores, listed below:

1. Permanently set scheduling rate limits by [store-balance-rate](../pd-configuration-file/#store-balance-rate) in `pd-ctl`.

    {{< info >}}
The configuration change only applies to the stores started afterward, thus will be applied to all stores in the cluster only if you restart all TiKV. If you want to apply this change immediately, see the [workaround](#workaround) below.
    {{< /info >}}

    `store-balance-rate` specifies the maximum number of scheduling tasks allowed for each store per minute. The scheduling step includes adding peers or learners.

      ```bash
      » config set store-balance-rate 20
      ```

2. Temporarily set scheduling rate limits by `limit` in `pd-ctl`.

    {{< info >}}
The scheduling rate limit set by this method will be lost after restarting TiKV, and then the value previously set by method 1 will be used.
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

- Combining method 1 and method 2, permanently modify the rate limit to 20 and applies immediately.

    ```bash
    » config set store-balance-rate 20
    » stores set limit 20
    ```
