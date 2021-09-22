---
title: Upgrade
description: Learn how to upgrade TiKV using TiUP
menu:
    "5.1":
        parent: Operate TiKV
        weight: 1
---

This document is targeted for TiKV upgrade from 4.0 versions to 5.0 versions, or from 5.0 versions to a later version.

## Preparations

This section introduces the preparation works needed before upgrading your TiKV cluster, including upgrading TiUP and the TiUP Cluster component.

### Step 1: Upgrade TiUP

Before upgrading your TiKV cluster, you first need to upgrade TiUP.

1. Upgrade the TiUP version. It is recommended that the TiUP version be `1.4.0` or later.

    ```bash
    tiup update --self
    tiup --version
    ```

2. Upgrade the TiUP Cluster version. It is recommended that the TiUP Cluster version be `1.4.0` or later.

    ```bash
    tiup update cluster
    tiup cluster --version
    ```

### Step 2: Edit TiUP topology configuration file

{{< info >}}
Skip this step if one of the following situations applies:

+ You have not modified the configuration parameters of the original cluster. Or you have modified the configuration parameters using `tiup cluster` but no more modification is needed.
+ After the upgrade, you want to use default parameter values of v5.0 for the unmodified configuration items.
{{< /info >}}

1. Enter the `vi` editing mode to edit the topology file:

    ```bash
    tiup cluster edit-config <cluster-name>
    ```

2. Refer to the format of [topology](https://github.com/pingcap/tiup/blob/release-1.4/embed/templates/examples/topology.example.yaml) configuration template and fill the parameters you want to modify in the `server_configs` section of the topology file.

3. After the modification, <kbd>:</kbd> + <kbd>w</kbd> + <kbd>q</kbd> to save the change and exit the editing mode. Enter <kbd>Y</kbd> to confirm the change.

## Perform a rolling upgrade to the TiKV cluster

This section describes how to perform a rolling upgrade to the TiKV cluster and how to verify the version after the upgrade.

### Upgrade the TiKV cluster to a specified version

You can upgrade your cluster in one of the two ways: online upgrade and offline upgrade.

By default, TiUP Cluster upgrades the TiKV cluster using the online method, which means that the TiKV cluster can still provide services during the upgrade process. With the online method, the leaders are migrated one by one on each node before the upgrade and restart. Therefore, for a large-scale cluster, it takes a long time to complete the entire upgrade operation.

If your application has a maintenance window for the database to be stopped for maintenance, you can use the offline upgrade method to quickly perform the upgrade operation.

#### Online upgrade

```bash
tiup cluster upgrade <cluster-name> <version>
```

For example, if you want to upgrade the cluster to v5.0.1:

```bash
tiup cluster upgrade <cluster-name> v5.0.1
```

{{< info >}}
+ Performing a rolling upgrade to the cluster will upgrade all components one by one. During the upgrade of TiKV, all leaders in a TiKV instance are evicted before stopping the instance. The default timeout time is 5 minutes (300 seconds). The instance is directly stopped after this timeout time.

+ To perform the upgrade immediately without evicting the leader, specify `--force` in the command above. This method causes performance jitter but no data loss.

+ To keep a stable performance, make sure that all leaders in a TiKV instance are evicted before stopping the instance. You can set `--transfer-timeout` to a large value, for example, `--transfer-timeout 3600` (unit: second).
{{< /info >}}

#### Offline upgrade

1. Before the offline upgrade, stop the entire cluster.

    ```bash
    tiup cluster stop <cluster-name>
    ```

2. Use the `upgrade` command with the `--offline` option to perform the offline upgrade.

    ```bash
    tiup cluster upgrade <cluster-name> <version> --offline
    ```

3. After the upgrade, the cluster will not be automatically restarted. Execute the `start` command to restart it.

    ```bash
    tiup cluster start <cluster-name>
    ```

### Verify the cluster version

Execute the `display` command to view the latest cluster version `TiKV Version`:

```bash
tiup cluster display <cluster-name>

Cluster name:       <cluster-name>
Cluster version:    v5.0.1
```

## FAQ

This section describes common problems encountered when updating the TiKV cluster using TiUP.

### If an error occurs and the upgrade is interrupted, how to resume the upgrade after fixing this error?

Re-execute the `tiup cluster upgrade` command to resume the upgrade. The upgrade operation restarts the nodes that have been previously upgraded. If you do not want the upgraded nodes to be restarted, use the `replay` sub-command to retry the operation:

1. Execute the `tiup cluster audit` command to see the operation records:

    ```bash
    tiup cluster audit
    ```

    Find the failed upgrade operation record and keep the ID of this operation record.

2. Execute the `tiup cluster replay <audit-id>` command to retry the corresponding operation. The `<audit-id>` value is the ID obtained in the previous step:

    ```bash
    tiup cluster replay <audit-id>
    ```

### The evict leader has waited too long during the upgrade. How to skip this step for a quick upgrade?

Specify `--force` to skip transferring PD leader and evicting TiKV leader during the upgrade. The cluster is directly restarted to update the version, which has great impact on the cluster that runs online. Here is the command:

```bash
tiup cluster upgrade <cluster-name> <version> --force
```

### How to update the version of tools such as pd-ctl after upgrading the TiKV cluster?

Upgrade the tool version by using TiUP to install the `ctl` component of the corresponding version:

```bash
tiup install ctl:v5.0.0
```
