---
title: Monitoring a Cluster
description: Learn how to monitor the state of a TiKV cluster.
menu:
    docs:
        parent: Monitor
        weight: 1
---

Currently, you can use two types of interfaces to monitor the state of the TiKV cluster:

- [The component state interface](#the-component-state-interface): use the HTTP interface to get the internal information of a component, which is called the component state interface.
- [The metrics interface](#the-metrics-interface): use the Prometheus interface to record the detailed information of various operations in the components, which is called the metrics interface.

## The component state interface

You can use this type of interface to monitor the basic information of components. This interface can get the details of the entire TiKV cluster and can act as the interface to monitor Keepalive.

### The PD server

The API address of the Placement Driver (PD) is `http://${host}:${port}/pd/api/v1/${api_name}`

The default port number is 2379.

For detailed information about various API names, see [PD API doc](https://download.pingcap.com/pd-api-v1.html).

You can use the interface to get the state of all the TiKV instances and the information about load balancing. It is the most important and frequently-used interface to get the state information of all the TiKV nodes. See the following example for the information about a 3-instance TiKV cluster deployed on a single machine:

```bash
curl http://127.0.0.1:2379/pd/api/v1/stores
{
  "count": 3,
  "stores": [
    {
      "store": {
        "id": 1,
        "address": "127.0.0.1:20161",
        "version": "2.1.0-rc.2",
        "state_name": "Up"
      },
      "status": {
        "capacity": "937 GiB",
        "available": "837 GiB",
        "leader_weight": 1,
        "region_count": 1,
        "region_weight": 1,
        "region_score": 1,
        "region_size": 1,
        "start_ts": "2018-09-29T00:05:47Z",
        "last_heartbeat_ts": "2018-09-29T00:23:46.227350716Z",
        "uptime": "17m59.227350716s"
      }
    },
    {
      "store": {
        "id": 2,
        "address": "127.0.0.1:20162",
        "version": "2.1.0-rc.2",
        "state_name": "Up"
      },
      "status": {
        "capacity": "937 GiB",
        "available": "837 GiB",
        "leader_weight": 1,
        "region_count": 1,
        "region_weight": 1,
        "region_score": 1,
        "region_size": 1,
        "start_ts": "2018-09-29T00:05:47Z",
        "last_heartbeat_ts": "2018-09-29T00:23:45.65292648Z",
        "uptime": "17m58.65292648s"
      }
    },
    {
      "store": {
        "id": 7,
        "address": "127.0.0.1:20160",
        "version": "2.1.0-rc.2",
        "state_name": "Up"
      },
      "status": {
        "capacity": "937 GiB",
        "available": "837 GiB",
        "leader_count": 1,
        "leader_weight": 1,
        "leader_score": 1,
        "leader_size": 1,
        "region_count": 1,
        "region_weight": 1,
        "region_score": 1,
        "region_size": 1,
        "start_ts": "2018-09-29T00:05:47Z",
        "last_heartbeat_ts": "2018-09-29T00:23:44.853636067Z",
        "uptime": "17m57.853636067s"
      }
    }
  ]
}
```

## The metrics interface

You can use this type of interface to monitor the state and performance of the entire cluster. The metrics data is displayed in Prometheus and Grafana. See [Use Prometheus and Grafana](#use-prometheus-and-grafana) for how to set up the monitoring system.

You can get the following metrics for each component:

### The PD server

- the total number of times that the command executes
- the total number of times that a certain command fails
- the duration that a command succeeds
- the duration that a command fails
- the duration that a command finishes and returns result

### The TiKV server

- Garbage Collection (GC) monitoring
- the total number of times that the TiKV command executes
- the duration that Scheduler executes commands
- the total number of times of the Raft propose command
- the duration that Raft executes commands
- the total number of times that Raft commands fail
- the total number of times that Raft processes the ready state

## Use Prometheus and Grafana

This section introduces the deployment architecture of Prometheus and Grafana in TiKV, and how to set up and configure the monitoring system.

### The deployment architecture

See the following diagram for the deployment architecture:

{{< figure
    src="/img/docs/prometheus.svg"
    caption="Monitor architecture"
    number="1" >}}

{{< info >}}
You must add the Prometheus Pushgateway addresses to the startup parameters of the PD and TiKV components.
{{< /info >}}

### Set up the monitoring system

You can use your existing [Prometheus](https://prometheus.io/) server to pull metrics from TiKV, or quickly bootstrap a test server below. This pairs well with [Grafana](https://grafana.com/) for monitoring.

Use the following script to bootstrap Grafana and Prometheus on a local CentOS system:

```bash
cat <<EOT > /etc/yum.repos.d/prometheus.repo
[prometheus]
name=prometheus
baseurl=https://packagecloud.io/prometheus-rpm/release/el/\$releasever/\$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://packagecloud.io/prometheus-rpm/release/gpgkey
      https://raw.githubusercontent.com/lest/prometheus-rpm/master/RPM-GPG-KEY-prometheus-rpm
gpgcheck=1
metadata_expire=300
EOT
cat <<EOT > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOT
yum install -y prometheus grafana
systemctl enable --now prometheus grafana-server
```

Browse to [port 3000 on the host](http://127.0.0.1:3000) and you should be able to log in with `admin`/`admin`.

### Configure Prometheus

To configure Prometheus, edit the `/etc/prometheus/prometheus.yml` and the `scrape_configs` block:

```yaml
global:
  scrape_interval:     15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'test-cluster'
    monitor: "prometheus"

scrape_configs:
  - job_name: 'pd'
    honor_labels: true
    static_configs:
      - targets:
        - '127.0.0.1:2379'
  - job_name: 'tikv'
    honor_labels: true
    static_configs:
      - targets:
        - '127.0.0.1:20160'
```

Restart Prometheus with `systemctl restart prometheus`.

### Configure Grafana

 Visiting [Add a Data Source](http://127.0.0.1:3000/datasources/new), choose Prometheus and add the URL or your Prometheus server (`http://127.0.0.1:9090`). Finally, save & test it.

1. Log in to the [Grafana Web interface](http://127.0.0.1:3000/) (default login `admin`/`admin`).
2. Visit [Add a data source](http://127.0.0.1:3000/datasources/new).
3. Specify the data source information:
    - Specify the name for the data source.
    - For Type, select Prometheus.
    - For Url, specify the Prometheus address.
    - Specify other fields as needed.
4. Click 'Test & Save' to save the new data source.

#### Grafana Dashboard Templates

The TiKV community has developed several useful dashboards to get you started with Grafana. You may need to adjust some settings, particularly if you configured the `external_labels` option in the `prometheus.yml` configuration above.

* [TiKV Summary Dashboard](https://raw.githubusercontent.com/pingcap/tidb-ansible/master/scripts/tikv_summary.json).
* [TiKV Raw Dashboard](https://raw.githubusercontent.com/pingcap/tidb-ansible/master/scripts/tikv_raw.json)
* [TiKV Details Dashboard](https://raw.githubusercontent.com/pingcap/tidb-ansible/master/scripts/tikv_details.json)
* [TiKV Troubleshooting Dashboard](https://raw.githubusercontent.com/pingcap/tidb-ansible/master/scripts/tikv_trouble_shooting.json)
* [PD Dashboard](https://raw.githubusercontent.com/pingcap/tidb-ansible/master/scripts/pd.json)
