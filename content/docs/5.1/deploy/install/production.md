---
title: Production Deployment
description: Deploy a TiKV Cluster for Production Using TiUP
menu:
    "5.1":
        parent: Install TiKV
        weight: 2
---

This guide describes how to install and deploy TiKV for production environment.

[TiUP](https://github.com/pingcap/tiup) is a cluster operation and maintenance tool. TiUP provides [TiUP cluster](https://github.com/pingcap/tiup/tree/master/components/cluster), a cluster management component written in Golang. By using TiUP cluster, you can easily perform daily operations, including deploying, starting, stopping, destroying, scaling, and upgrading a TiKV cluster, and managing cluster parameters.

## Step 1: Install TiUP on the control machine

Log in to the control machine using a regular user account (take the `tikv` user as an example). All the following TiUP installation and cluster management operations can be performed by the `tikv` user.

1. Install TiUP:

    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
    ```

2. Set the TiUP environment variables:

    1. Redeclare the global environment variables:

       ```bash
       source .bash_profile
       ```

    2. Confirm whether TiUP is installed:

       ```bash
       tiup
       ```

3. Install the TiUP cluster component:

    ```bash
    tiup cluster
    ```

4. If TiUP is already installed, update the TiUP cluster component to the latest version:

    ```bash
    tiup update --self && tiup update cluster
    ```

5. Verify the current version of your TiUP cluster:

    ```bash
    tiup --binary cluster
    ```

## Step 2: Initialize cluster topology file

According to the intended cluster topology, you need to manually create and edit the cluster initialization configuration file.

To create the cluster initialization configuration file, you can create a YAML-formatted configuration file on the control machine using TiUP:

```bash
tiup cluster template > topology.yaml
```

Execute `vi topology.yaml` to edit the configuration file content:

```yaml
global:
  user: "tikv"
  ssh_port: 22
  deploy_dir: "/tikv-deploy"
  data_dir: "/tikv-data"
server_configs: {}
pd_servers:
  - host: 10.0.1.1
  - host: 10.0.1.2
  - host: 10.0.1.3
tikv_servers:
  - host: 10.0.1.4
  - host: 10.0.1.5
  - host: 10.0.1.6
monitoring_servers:
  - host: 10.0.1.7
grafana_servers:
  - host: 10.0.1.7
```

{{< info >}}
- For parameters that should be globally effective, configure these parameters of corresponding components in the `server_configs` section of the configuration file.
- For parameters that should be effective on a specific node, configure these parameters in the `config` of this node.
- Use `.` to indicate the subcategory of the configuration, such as `storage.scheduler-concurrency`. For more formats, see [TiUP configuration template](https://github.com/pingcap/tiup/blob/master/embed/templates/examples/topology.example.yaml).
- For more parameter description, see [TiKV config.toml.example](https://github.com/tikv/tikv/blob/release-5.0/etc/config-template.toml) and [PD config.toml.example](https://github.com/tikv/pd/blob/release-5.0/conf/config.toml) configuration.
{{< /info >}}

## Step 3: Execute the deployment command

{{< info >}}
You can use secret keys or interactive passwords for security authentication when you deploy TiKV using TiUP:

- If you use secret keys, you can specify the path of the keys through `-i` or `--identity_file`;
- If you use passwords, add the `-p` flag to enter the password interaction window;
- If password-free login to the target machine has been configured, no authentication is required.

In general, TiUP creates the user and group specified in the `topology.yaml` file on the target machine, with the following exceptions:

- The user name configured in `topology.yaml` already exists on the target machine.
- You have used the `--skip-create-user` option in the command line to explicitly skip the step of creating the user.
{{< /info >}}

Before you execute the `deploy` command, use the `check` and `check --apply` commands to detect and automatically repair the potential risks in the cluster:

```bash
tiup cluster check ./topology.yaml --user root [-p] [-i /home/root/.ssh/gcp_rsa]
tiup cluster check ./topology.yaml --apply --user root [-p] [-i /home/root/.ssh/gcp_rsa]
```

Then execute the `deploy` command to deploy the TiKV cluster:

```shell
tiup cluster deploy tikv-test v5.0.1 ./topology.yaml --user root [-p] [-i /home/root/.ssh/gcp_rsa]
```

In the above command:

- The name of the deployed TiKV cluster is `tikv-test`.
- You can see the latest supported versions by running `tiup list tikv`. This document takes `v5.0.1` as an example.
- The initialization configuration file is `topology.yaml`.
- `--user root`: Log in to the target machine through the `root` key to complete the cluster deployment, or you can use other users with `ssh` and `sudo` privileges to complete the deployment.
- `[-i]` and `[-p]`: optional. If you have configured login to the target machine without password, these parameters are not required. If not, choose one of the two parameters. `[-i]` is the private key of the `root` user (or other users specified by `--user`) that has access to the target machine. `[-p]` is used to input the user password interactively.
- If you need to specify the user group name to be created on the target machine, see [this example](https://github.com/pingcap/tiup/blob/master/embed/templates/examples/topology.example.yaml#L7).

At the end of the output log, you will see ```Deployed cluster `tikv-test` successfully```. This indicates that the deployment is successful.

## Step 4: Check the clusters managed by TiUP

```bash
tiup cluster list
```

TiUP supports managing multiple TiKV clusters. The command above outputs information of all the clusters currently managed by TiUP, including the name, deployment user, version, and secret key information.

## Step 5: Check the status of the deployed TiKV cluster

For example, execute the following command to check the status of the `tikv-test` cluster:

```bash
tiup cluster display tikv-test
```

The command output should include the instance ID, role, host, listening port, and status (the status of the cluster is `Down`/`inactive` because it is not started yet), and directory information.

## Step 6: Start the TiKV cluster

```shell
tiup cluster start tikv-test
```

If the output log includes ```Started cluster `tikv-test` successfully```, the start is successful.

## Step 7: Verify the running status of the TiKV cluster
For the specific operations, see [Verify Cluster Status](../verify).

{{< info >}}
Refer to [TiUP cluster document](https://docs.pingcap.com/tidb/stable/tiup-cluster) to find more TiUP cluster commands and usages.
{{< /info >}}
