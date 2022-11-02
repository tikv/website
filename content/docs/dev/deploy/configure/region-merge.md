---
title: Region Merge Config
description: Learn how to configure Region Merge in TiKV.
menu:
    "dev":
        parent: Configure TiKV-dev
        weight: 7
        identifier: Region Merge Config-dev
---

TiKV shards continuous ranges of keys into Regions, and replicates Regions through the Raft protocol. When data size increases until reaching a threshold, a Region splits into multiple. Conversely, if the size of the Region shrinks due to data deletion, two adjacent Regions can be merged into one.

## Region Merge

The Region Merge process is initiated by PD as follows:

1. PD polls the status of the Regions by the interval.

2. PD ensures all replicas of the two Regions to be merged must be stored on the same set of TiKV(s).

3. If the sizes of two adjacent regions are both less than `max-merge-region-size` and the numbers of keys within the regions are both less than `max-merge-region-keys`, PD starts the Region Merge process that merges the bigger region into the smaller region.

## Configure Region Merge

You can use `pd-ctl` or the PD configuration file to configure Region Merge.

The Region Merge feature is enabled by default. To disable Region Merge, you need to set the following parameters to zero:

- `max-merge-region-size`
- `max-merge-region-keys`
- `merge-schedule-limit`

{{< info >}}
- Newly split Regions are not merged within the period specified by `split-merge-interval`.
- Region Merge does not happen within the period specified by `split-merge-interval` after PD starts or restarts.
{{< /info >}}

For more information of other configuration parameters about scheduling, see [Scheduling-related parameters](../pd-configuration-file/#schedule).
