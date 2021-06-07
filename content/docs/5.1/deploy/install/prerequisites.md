---
title: Prerequisites
description: Prerequisites for deploying TiKV
menu:
    "5.1":
        parent: Install TiKV
        weight: 1
---

Typical deployments of TiKV include a number of components:

* 3+ TiKV nodes
* 3+ Placement Driver (PD) nodes
* 1 Monitoring node
* 1 or more client application

{{< info >}}
TiKV is deployed alongside a [Placement Driver](https://github.com/pingcap/pd/) (PD) cluster. PD is the cluster manager of TiKV, which periodically checks replication constraints to balance load and data automatically.
{{< /info >}}

**Production** usage is typically done via automation requiring:

* A control machine (it can be one of your target servers) with [TiUP](https://github.com/pingcap/tiup) installed.
* Several (6+) machines fulfilling the [production specifications](#production-specifications).
* The ability to configure your infrastructure to allow the ports from [network requirements](#network-requirements).

## Production Specifications

The **suggested PD** specifications for production are:

* 3+ nodes
* 4+ cores
* 8+ GB RAM, with no swap space.
* 200+ GB Optane, NVMe, or SSD drive
* 10 Gigabit ethernet (2x preferred)
* A Linux Operating System (PD is most widely tested on CentOS 7).

The **suggested TiKV** specifications for production are:

* 3+ nodes
* 16+ cores
* 32+ GB RAM, with no swap space.
* 200+ GB Optane, NVMe, or SSD drive (Under 1.5 TB capacity is ideal in our tests)
* 10 Gigabit ethernet (2x preferred)
* A Linux Operating System (TiKV is most widely tested on CentOS 7).

## Network requirements

TiKV deployments require **total connectivity of all services**. Each TiKV, PD, and client must be able to reach each all other and advertise the addresses of all other services to new services. This connectivity allows TiKV and PD to replicate and balance data resiliently across the entire deployment.

If the hosts are not already able to reach each other, it is possible to accomplish this through a Virtual Local Area Network (VLAN). Speak to your system administrator to explore your options.

TiKV requires the following network port configuration to run. Based on the TiKV deployment in actual environments, the administrator can open relevant ports in the network side and host side.

|     Component     | Default Port | Description                                                                              |
|:-----------------:|:------------:|:---------------------------------------------------------------------------------------- |
|       TiKV        |    20160     | The TiKV communication port.                                                             |
|       TiKV        |    20180     | Status port, Prometheus metrics at `/metrics`.                                           |
|        PD         |     2379     | The client port, for communication with clients.                                         |
|        PD         |     2380     | The inter-node communication port within the PD cluster.                                 |
|      Grafana      |     3000     | The port for the external Web monitoring service and client (Browser) access.            |
|    Prometheus     |     9090     | The communication port for the Prometheus service.                                       |
|   Node_exporter   |     9100     | The communication port to report the system information of every TiKV cluster node.      |
| Blackbox_exporter |     9115     | The Blackbox_exporter communication port, used to monitor the ports in the TiKV cluster. |

You can ensure your configuration is correct by creating echo servers on the ports/IPs by using `ncat` (from the `nmap` package):

```bash
ncat -l $PORT -k -c 'xargs -n1 echo'
```

Then from the other machines, verify that the echo server is reachable with `curl $IP:$PORT`.
