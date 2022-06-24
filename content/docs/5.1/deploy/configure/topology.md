---
title: Topology Label Config
description: Learn how to configure topology labels.
menu:
    "5.1":
        parent: Configure TiKV
        weight: 6
---

TiKV uses topology labels (hereafter referred to as the labels) to declare its location information, and PD scheduler uses the labels to optimize TiKV's failure tolerance capability. This document describes how to configure the labels.

## Declare the label hierarchy in PD

The labels are hierarchical, for example, `zone > rack > host`. You can declare their hierarchies in the PD configuration file or `pd-ctl`:

- PD configuration file:
    ```toml
    [replication]
    max-replicas = 3
    location-labels = ["zone", "rack", "host"]
    ```
- pd-ctl:

    ```toml
    pd-ctl >> config set location-labels zone,rack,host
    ```
    {{< warning >}}
The number of machines must be no less than the `max-replicas`.
    {{< /warning >}}

For the information of all replication configuration parameters, see [Replication-related parameters](../pd-configuration-file/#replication).

## Declare the labels for TiKV

Assume that the topology has three layers: `zone > rack > host`. You can set a label for each layer by command line parameter or configuration file, then TiKV reports its label to PD:

- TiKV command line parameter:

    ```bash
    tikv-server --labels zone=<zone>,rack=<rack>,host=<host>
    ```

- TiKV configuration file:

    ```toml
    [server]
    labels = "zone=<zone>,rack=<rack>,host=<host>"
    ```

## Example

PD makes optimal scheduling according to the topological information. You only need to care about what kind of topology can achieve the desired effect.

If you use 3 replicas and hope that the TiKV cluster is always highly available even when a data zone goes down, you need at least 4 data zones.

Assume that you have 4 data zones, each zone has 2 racks, and each rack has 2 hosts. You can start 2 TiKV instances on each host as follows:

Start TiKV:

```bash
# zone=z1
tikv-server --labels zone=z1,rack=r1,host=h1
tikv-server --labels zone=z1,rack=r1,host=h2
tikv-server --labels zone=z1,rack=r2,host=h1
tikv-server --labels zone=z1,rack=r2,host=h2

# zone=z2
tikv-server --labels zone=z2,rack=r1,host=h1
tikv-server --labels zone=z2,rack=r1,host=h2
tikv-server --labels zone=z2,rack=r2,host=h1
tikv-server --labels zone=z2,rack=r2,host=h2

# zone=z3
tikv-server --labels zone=z3,rack=r1,host=h1
tikv-server --labels zone=z3,rack=r1,host=h2
tikv-server --labels zone=z3,rack=r2,host=h1
tikv-server --labels zone=z3,rack=r2,host=h2

# zone=z4
tikv-server --labels zone=z4,rack=r1,host=h1
tikv-server --labels zone=z4,rack=r1,host=h2
tikv-server --labels zone=z4,rack=r2,host=h1
tikv-server --labels zone=z4,rack=r2,host=h2
```

Configure PD:

```bash
# use `pd-ctl` connect the PD:
$ pd-ctl
>> config set location-labels zone,rack,host
```

Now, PD schedules replicas of the same `Region` to different data zones.

- Even if one data zone goes down, the TiKV cluster is still highly available.
- If the data zone cannot recover within a period of time, PD removes the replica from this data zone.
