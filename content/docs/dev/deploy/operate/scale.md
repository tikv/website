---
title: Scale
description: Learn how to scale out/in TiKV using TiUP
menu:
    "dev":
        parent: Operate TiKV-dev
        weight: 2
        identifier: Scale-dev
---

The capacity of a TiKV cluster can be increased or decreased without interrupting online services.

This document describes how to scale a TiKV or PD cluster using TiUP.

For example, assume that the topology of the cluster is as follows:

| Host IP  | Service |
|:-------- |:------- |
| 10.0.1.1 | Monitor |
| 10.0.1.2 | PD      |
| 10.0.1.3 | PD      |
| 10.0.1.4 | PD      |
| 10.0.1.5 | TiKV    |
| 10.0.1.6 | TiKV    |
| 10.0.1.7 | TiKV    |

## Scale out a TiKV cluster

If you want to add a TiKV node to the `10.0.1.8` host, take the following steps.

1. Configure the scale-out topology

    Put the following contents in the `scale-out-tikv.yaml` file:

    ```yaml
    tikv_servers:
    - host: 10.0.1.8
      ssh_port: 22
      port: 20160
      status_port: 20180
      deploy_dir: /data/deploy/install/deploy/tikv-20160
      data_dir: /data/deploy/install/data/tikv-20160
      log_dir: /data/deploy/install/log/tikv-20160
    ```

    To view the configuration of the current cluster, run `tiup cluster edit-config <cluster-name>`. Because the parameter configuration of `global` and `server_configs` is inherited by `scale-out-tikv.yaml` and thus also takes effect in `scale-out-tikv.yaml`.

2. Run the scale-out command

    ```shell
    tiup cluster scale-out <cluster-name> scale-out-tikv.yaml
    ```

    If you see the message "Scaled cluster <cluster-name> out successfully", it means that the scale-out operation is successfully completed.

3. Check the cluster status

    ```shell
    tiup cluster display <cluster-name>
    ```

    Access the monitoring platform at <http://10.0.1.1:3000> using your browser to monitor the status of the cluster and the new node.

After the scale-out, the cluster topology is as follows:

| Host IP  | Service |
|:-------- |:------- |
| 10.0.1.1 | Monitor |
| 10.0.1.2 | PD      |
| 10.0.1.3 | PD      |
| 10.0.1.4 | PD      |
| 10.0.1.5 | TiKV    |
| 10.0.1.6 | TiKV    |
| 10.0.1.7 | TiKV    |
| 10.0.1.8 | **TiKV**|

## Scale out a PD cluster

If you want to add a PD node to the `10.0.1.9` host, take the following steps.

1. Configure the scale-out topology

    Put the following contents in the `scale-out-pd.yaml` file:

    ```yaml
    pd_servers:
    - host: 10.0.1.9
      ssh_port: 22
      client_port: 2379
      peer_port: 2380
      deploy_dir: /data/deploy/install/deploy/pd-2379
      data_dir: /data/deploy/install/data/pd-2379
      log_dir: /data/deploy/install/log/pd-2379
    ```

    To view the configuration of the current cluster, run `tiup cluster edit-config <cluster-name>`. Because the parameter configuration of `global` and `server_configs` is inherited by `scale-out-pd.yaml` and thus also takes effect in `scale-out-pd.yaml`.

2. Run the scale-out command

    ```shell
    tiup cluster scale-out <cluster-name> scale-out-pd.yaml
    ```

    If you see the message "Scaled cluster <cluster-name> out successfully", it means that the scale-out operation is successfully completed.

3. Check the cluster status

    ```shell
    tiup cluster display <cluster-name>
    ```

    Access the monitoring platform at <http://10.0.1.1:3000> using your browser to monitor the status of the cluster and the new node.

After the scale-out, the cluster topology is as follows:

| Host IP  | Service |
|:-------- |:------- |
| 10.0.1.1 | Monitor |
| 10.0.1.2 | PD      |
| 10.0.1.3 | PD      |
| 10.0.1.4 | PD      |
| 10.0.1.5 | TiKV    |
| 10.0.1.6 | TiKV    |
| 10.0.1.7 | TiKV    |
| 10.0.1.8 | TiKV    |
| 10.0.1.9 | **PD**  |

## Scale in a TiKV cluster

If you want to remove a TiKV node from the `10.0.1.5` host, take the following steps.

{{< info >}}
You can take similar steps to remove a PD node.
{{< /info >}}

1. View the node ID information:

    ```shell
    tiup cluster display <cluster-name>
    ```

2. Run the scale-in command:

    ```shell
    tiup cluster scale-in <cluster-name> --node 10.0.1.5:20160
    ```

    The `--node` parameter is the ID of the node to be taken offline.

    If you see the message "Scaled cluster in successfully", it means that the scale-in operation is successfully completed.
    
    Besides, if the status of the node to be taken offline becomes `Tombstone`, it also indicates that the scale-in operation is successfully completed because the scale-in process takes some time.
   
3. Check the cluster status:

    To check the scale-in status, run the following command:

    ```shell
    tiup cluster display <cluster-name>
    ```

    Access the monitoring platform at <http://10.0.1.1:3000> using your browser, and view the status of the cluster.

After the scale-in, the current topology is as follows:

| Host IP  | Service |
|:-------- |:------- |
| 10.0.1.1 | Monitor |
| 10.0.1.2 | PD      |
| 10.0.1.3 | PD      |
| 10.0.1.4 | PD      |
| 10.0.1.6 | TiKV    |
| 10.0.1.7 | TiKV    |
| 10.0.1.8 | TiKV    |
| 10.0.1.9 | PD      |
