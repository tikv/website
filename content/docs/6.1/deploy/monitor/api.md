---
title: Monitoring API
description: Learn the API of TiKV monitoring services.
menu:
    "6.1":
        parent: Monitor and Alert-v6.1
        weight: 2
        identifier: Monitoring API-v6.1
---

You can use the following two types of interfaces to monitor the TiKV cluster state:

- [The state interface](#use-the-state-interface): this interface uses the HTTP interface to get the component information.
- [The metrics interface](#use-the-metrics-interface): this interface uses Prometheus to record the detailed information of the various operations in components and views these metrics using Grafana.

## Use the state interface

The state interface monitors the basic information of a specific component in the TiKV cluster. It can also act as the monitor interface for Keepalive messages. In addition, the state interface for the Placement Driver (PD) can get the details of the entire TiKV cluster.

### PD server

- PD API address: `http://${host}:${port}/pd/api/v1/${api_name}`
- Default port: `2379`
- Details about API names: see [PD API doc](https://download.pingcap.com/pd-api-v1.html)

The PD interface provides the state of all the TiKV servers and the information about load balancing. See the following example for the information about a single-node TiKV cluster:

```bash
curl http://127.0.0.1:2379/pd/api/v1/stores
{
  "count": 1,  # The number of TiKV nodes.
  "stores": [  # The list of TiKV nodes.
    # The details about the single TiKV node.
    {
      "store": {
        "id": 1,
        "address": "127.0.0.1:20160",
        "version": "3.0.0-beta",
        "state_name": "Up"
      },
      "status": {
        "capacity": "20 GiB",  # The total capacity.
        "available": "16 GiB",  # The available capacity.
        "leader_count": 17,
        "leader_weight": 1,
        "leader_score": 17,
        "leader_size": 17,
        "region_count": 17,
        "region_weight": 1,
        "region_score": 17,
        "region_size": 17,
        "start_ts": "2019-03-21T14:09:32+08:00",  # The starting timestamp.
        "last_heartbeat_ts": "2019-03-21T14:14:22.961171958+08:00",  # The timestamp of the last heartbeat.
        "uptime": "4m50.961171958s"
      }
    }
  ]
```

## Use the metrics interface

The metrics interface monitors the state and performance of the entire TiKV cluster.

- If you use other deployment ways, [deploy Prometheus and Grafana](../deploy) before using this interface.

After Prometheus and Grafana are successfully deployed, [configure Grafana](../deploy#configure-grafana).
