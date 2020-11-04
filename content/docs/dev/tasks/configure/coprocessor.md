---
title: Coprocessor Config
description: Learn how to configure Coprocessor in TiKV.
menu:
    "dev":
        parent: Configure
        weight: 12
---

This document describes the configuration parameters related to Coprocessor.

### `split-region-on-table`

+ Determines whether to split Region by table. It is recommended to use the feature only in the TiDB mode.
+ Default value: `true`

### `batch-split-limit`

+ The threshold of Region split in batches. Increasing this value speeds up Region split.
+ Default value: `10`
+ Minimum value: `1`

### `region-max-size`

+ The maximum size of a Region. When the value is exceeded, the Region splits into many.
+ Default value: `144MB`
+ Unit: KB|MB|GB

### `region-split-size`

+ The size of the newly split Region. This value is an estimate.
+ Default value: `96MB`
+ Unit: KB|MB|GB

### `region-max-keys`

+ The maximum allowable number of keys in a Region. When this value is exceeded, the Region splits into many.
+ Default value: `1440000`

### `region-split-keys`

+ The number of keys in the newly split Region. This value is an estimate.
+ Default value: `960000`
