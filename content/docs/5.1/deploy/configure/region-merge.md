---
title: Region Merge
description: Learn how to configure Region Merge in TiKV.
menu:
    "5.1":
        parent: Configure TiKV
        weight: 7
---

TiKV shards continuous ranges of keys into Regions, and replicates Regions via the Raft protocol. When data size increases until reaching a threshold, a Region will be split into multiple. Conversely, if the size of the Region shrinks due to data deletion, two adjacent Regions can be merged into one.

## Region Merge

The Region Merge process is initiated by the PD. The steps are:

1. PD polls the Regions' status by the interval.

2. Ensure all replicas of the two Regions to be merged must be stored on the same set of TiKV(s).

2. If the two adjacent regions' sizes are both less than `max-merge-region-size` and the numbers of keys within the regions are both less than `max-merge-region-keys`, PD will start the Region Merge process that merges the bigger region into the smaller region.

## Configure Region Merge

You can use `pd-ctl` or the PD configuration file to configure Region Merge.

Region Merge is enabled by default. To disable Region Merge, set the following parameters to a zero:

- `max-merge-region-size`
- `max-merge-region-keys`
- `merge-schedule-limit`

{{< info >}}
- Newly split Regions won't be merged within the period of time specified by `split-merge-interval`.
- Region Merge won't happen within the period of time specified by `split-merge-interval` after PD starts or restarts.
{{< /info >}}

You can find all other configuration options for scheduling [here](../pd-configuration-file/#schedule).
