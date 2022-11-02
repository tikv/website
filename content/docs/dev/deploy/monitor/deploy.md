---
title: Deploy Monitoring Services
description: Learn how to deploy monitoring services for the TiKV cluster.
menu:
    "dev":
        parent: Monitor and Alert-dev
        weight: 3
        identifier: Deploy Monitoring Services-dev
---

This document is intended for users who want to manually deploy TiKV monitoring and alert services.

If you deploy the TiKV cluster using TiUP, the monitoring and alert services are automatically deployed, and no manual deployment is needed.

## Deploy Prometheus and Grafana

Assume that the TiKV cluster topology is as follows:

| Name  | Host IP         | Services                              |
|:----- |:--------------- |:------------------------------------- |
| Node1 | 192.168.199.113 | PD1, node_export, Prometheus, Grafana |
| Node2 | 192.168.199.114 | PD2, node_export                      |
| Node3 | 192.168.199.115 | PD3, node_export                      |
| Node4 | 192.168.199.116 | TiKV1, node_export                    |
| Node5 | 192.168.199.117 | TiKV2, node_export                    |
| Node6 | 192.168.199.118 | TiKV3, node_export                    |

### Step 1: Download the binary package

```bash
# Downloads the package.
wget https://download.pingcap.org/prometheus-2.8.1.linux-amd64.tar.gz
wget https://download.pingcap.org/node_exporter-0.17.0.linux-amd64.tar.gz
wget https://download.pingcap.org/grafana-6.1.6.linux-amd64.tar.gz
```

```bash
# Extracts the package.
tar -xzf prometheus-2.8.1.linux-amd64.tar.gz
tar -xzf node_exporter-0.17.0.linux-amd64.tar.gz
tar -xzf grafana-6.1.6.linux-amd64.tar.gz
```

### Step 2: Start `node_exporter` on all nodes

```bash
cd node_exporter-0.17.0.linux-amd64

# Starts the node_exporter service.
$ ./node_exporter --web.listen-address=":9100" \
    --log.level="info" &
```

### Step 3: Start Prometheus on Node1

Edit the Prometheus configuration file:

```bash
cd prometheus-2.8.1.linux-amd64 &&
vi prometheus.yml
```

```ini
...

global:
  scrape_interval:     15s  # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s  # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default value (10s).
  external_labels:
    cluster: 'test-cluster'
    monitor: "prometheus"

scrape_configs:
  - job_name: 'overwritten-nodes'
    honor_labels: true  # Do not overwrite job & instance labels.
    static_configs:
    - targets:
      - '192.168.199.113:9100'
      - '192.168.199.114:9100'
      - '192.168.199.115:9100'
      - '192.168.199.116:9100'
      - '192.168.199.117:9100'
      - '192.168.199.118:9100'

  - job_name: 'pd'
    honor_labels: true  # Do not overwrite job & instance labels.
    static_configs:
    - targets:
      - '192.168.199.113:2379'
      - '192.168.199.114:2379'
      - '192.168.199.115:2379'

  - job_name: 'tikv'
    honor_labels: true  # Do not overwrite job & instance labels.
    static_configs:
    - targets:
      - '192.168.199.116:20180'
      - '192.168.199.117:20180'
      - '192.168.199.118:20180'

...

```

Start the Prometheus service:

```bash
$ ./prometheus \
    --config.file="./prometheus.yml" \
    --web.listen-address=":9090" \
    --web.external-url="http://192.168.199.113:9090/" \
    --web.enable-admin-api \
    --log.level="info" \
    --storage.tsdb.path="./data.metrics" \
    --storage.tsdb.retention="15d" &
```

### Step 4: Start Grafana on Node1

Edit the Grafana configuration file:

```bash
cd grafana-6.1.6 &&
vi conf/grafana.ini
```

```init
...

[paths]
data = ./data
logs = ./data/log
plugins = ./data/plugins
[server]
http_port = 3000
domain = 192.168.199.113
[database]
[session]
[analytics]
check_for_updates = true
[security]
admin_user = admin
admin_password = admin
[snapshots]
[users]
[auth.anonymous]
[auth.basic]
[auth.ldap]
[smtp]
[emails]
[log]
mode = file
[log.console]
[log.file]
level = info
format = text
[log.syslog]
[event_publisher]
[dashboards.json]
enabled = false
path = ./data/dashboards
[metrics]
[grafana_net]
url = https://grafana.net

...

```

Start the Grafana service:

```bash
$ ./bin/grafana-server \
    --config="./conf/grafana.ini" &
```

## Configure Grafana

This section describes how to configure Grafana.

### Step 1: Add a Prometheus data source

1. Log in to the Grafana Web interface.

    - Default address: [http://localhost:3000](http://localhost:3000)
    - Default account: admin
    - Default password: admin

    {{< info >}}
For the **Change Password** step, you can choose **Skip**.
    {{< /info >}}

2. In the Grafana sidebar menu, click **Data Source** within the **Configuration**.

3. Click **Add data source**.

4. Specify the data source information.

    - Specify a **Name** for the data source.
    - For **Type**, select **Prometheus**.
    - For **URL**, specify the Prometheus address.
    - Specify other fields as needed.

5. Click **Add** to save the new data source.

### Step 2: Import a Grafana dashboard

To import a Grafana dashboard for the PD server and the TiKV server, take the following steps respectively:

1. Click the Grafana logo to open the sidebar menu.

2. In the sidebar menu, click **Dashboards** -> **Import** to open the **Import Dashboard** window.

3. Click **Upload .json File** to upload a JSON file (Download [TiKV Grafana configuration file](https://github.com/tikv/tikv/tree/release-5.0/metrics/grafana) and [PD Grafana configuration file](https://github.com/tikv/pd/tree/release-5.0/metrics/grafana)).

4. Click **Load**.

5. Select a Prometheus data source.

6. Click **Import**. A Prometheus dashboard is imported.

## View component metrics

Click **New dashboard** in the top menu and choose the dashboard you want to view.
