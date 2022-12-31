---
title: TiUP Common Operations
description: Learn the common operations to operate and maintain a TiKV cluster using TiUP
menu:
    "6.5":
        parent: Operate TiKV-6.5
        weight: 3
        identifier: TiUP Common Operations-6.5
---

This document describes the following common operations when you operate and maintain a TiKV cluster using TiUP.

- [View the cluster list](./#view-the-cluster-list)
- [Start the cluster](./#start-the-cluster)
- [View the cluster status](./#view-the-cluster-status)
- [Modify the configuration](./#modify-the-configuration)
- [Rename the cluster](./#rename-the-cluster)
- [Stop the cluster](./#stop-the-cluster)
- [Clean up cluster data](./#clean-up-cluster-data)
- [Destroy the cluster](./#destroy-the-cluster)

## View the cluster list

You can manage multiple TiKV clusters with the TiUP cluster component.

To view all the deployed TiKV clusters, run the following command:

```shell
tiup cluster list
```

## Start the cluster

To start the cluster, run the following command:

```shell
tiup cluster start ${cluster-name}
```

{{< info >}}
The components in the TiKV cluster are started by TiUP in the following order:

**PD -> TiKV -> Prometheus -> Grafana -> Node Exporter -> Blackbox Exporter**
{{< /info >}}

You can start only some of the components by adding the `-R` or `-N` parameters in the command. For example:

- This command starts only the PD component:

    ```shell
    tiup cluster start ${cluster-name} -R pd
    ```

- This command starts only the PD components on the `1.2.3.4` and `1.2.3.5` hosts:

    ```shell
    tiup cluster start ${cluster-name} -N 1.2.3.4:2379,1.2.3.5:2379
    ```

{{< info >}}
If you start the components with `-R` or `-N` parameters, make sure the order of components is correct. For example, start the PD component before the TiKV component. Otherwise, the start might fail.
{{< /info >}}

## View the cluster status

After starting the cluster, check the status of each component to ensure that they are up and running. TiUP provides a `display` command to do so, and you don't have to log in to every machine to view the component status.

```shell
tiup cluster display ${cluster-name}
```

## Modify the configuration

When the cluster is in operation, if you need to modify the parameters of a component, run the `edit-config` command. The detailed steps are as follows:

1. Open the configuration file of the cluster in the editing mode:

    ```shell
    tiup cluster edit-config ${cluster-name}
    ```

2. Configure the parameters:

    - If the configuration is globally effective for a component, edit `server_configs`:

        ```
        server_configs:
          tikv:
            server.status-thread-pool-size: 2
        ```

    - If the configuration takes effect on a specific node, edit the configuration in `config` of the node:

        ```
        tikv_servers:
        - host: 10.0.1.11
            port: 4000
            config:
                server.status-thread-pool-size: 2
        ```

    For the parameter format, see the [TiUP parameter template](https://github.com/pingcap/tiup/blob/master/embed/templates/examples/topology.example.yaml).

    For more information on the configuration parameters of components, refer to [TiKV `config.toml.example`](https://github.com/tikv/tikv/blob/master/etc/config-template.toml), and [PD `config.toml.example`](https://github.com/tikv/pd/blob/master/conf/config.toml).

3. Rolling update the configuration and restart the corresponding components by running the `reload` command:

    ```shell
    tiup cluster reload ${cluster-name} [-N <nodes>] [-R <roles>]
    ```

### Example

If you want to set the status thread pool size parameter (`status-thread-pool-size` in the [server](https://github.com/tikv/tikv/blob/master/etc/config-template.toml) module) to `2` in tikv-server, edit the configuration as follows:

```
server_configs:
  tikv:
    server.status-thread-pool-size: 2
```

Then, run the `tiup cluster reload ${cluster-name} -R tikv` command to rolling restart the TiKV component.

## Rename the cluster

After deploying and starting the cluster, you can rename the cluster using the `tiup cluster rename` command:

```shell
tiup cluster rename ${cluster-name} ${new-name}
```

{{< info >}}
+ The operation of renaming a cluster restarts the monitoring system (Prometheus and Grafana).
+ After a cluster is renamed, some panels with the old cluster name might remain on Grafana. You need to delete them manually.
{{< /info >}}

## Stop the cluster

To stop the cluster, run the following command:

```shell
tiup cluster stop ${cluster-name}
```

{{< info >}}
The components in the TiKV cluster are stopped by TiUP in the following order:

**Grafana -> Prometheus -> TiKV -> PD -> Node Exporter -> Blackbox Exporter**
{{< /info >}}

Similar to the `start` command, the `stop` command supports stopping some of the components by adding the `-R` or `-N` parameters. For example:

- This command stops only the TiKV component:

    ```shell
    tiup cluster stop ${cluster-name} -R tikv
    ```

- This command stops only the components on the `1.2.3.4` and `1.2.3.5` hosts:

    ```shell
    tiup cluster stop ${cluster-name} -N 1.2.3.4:4000,1.2.3.5:4000
    ```

## Clean up cluster data

The operation of cleaning up cluster data stops all the services and cleans up the data directory or/and log directory. The operation cannot be reverted, so proceed **with caution**.

- Clean up the data of all services in the cluster, but keep the logs:

    ```shell
    tiup cluster clean ${cluster-name} --data
    ```

- Clean up the logs of all services in the cluster, but keep the data:

    ```shell
    tiup cluster clean ${cluster-name} --log
    ```

- Clean up the data and logs of all services in the cluster:

    ```shell
    tiup cluster clean ${cluster-name} --all
    ```

- Clean up the logs and data of all services except Prometheus:

    ```shell
    tiup cluster clean ${cluster-name} --all --ignore-role prometheus
    ```

- Clean up the logs and data of all services except the `172.16.13.11:9000` instance:

    ```shell
    tiup cluster clean ${cluster-name} --all --ignore-node 172.16.13.11:9000
    ```

- Clean up the logs and data of all services except the `172.16.13.12` node:

    ```shell
    tiup cluster clean ${cluster-name} --all --ignore-node 172.16.13.12
    ```

## Destroy the cluster

The destroy operation stops the services and clears the data directory and deployment directory. The operation cannot be reverted, so proceed **with caution**.

```shell
tiup cluster destroy ${cluster-name}
```
