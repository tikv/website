---
title: Deploy
description: Run TiKV using Ansible or Docker
menu:
    docs:
        parent: Tasks
        weight: 1
---


Typical deployments of TiKV include a number of components:

* 3+ TiKV nodes
* 3+ Placement Driver (PD) nodes
* 1 Monitoring node
* 1 or more client application or query layer (like [TiDB](https://github.com/pingcap/tidb))

{{< info >}}
TiKV is deployed alongside a [Placement Driver](https://github.com/pingcap/pd/) (PD) cluster. PD is the cluster manager of TiKV, which periodically checks replication constraints to balance load and data automatically.
{{< /info >}}

For your **first steps** into TiKV requires only a few things:

* A modest machine that fulfills the [system requirements](#system-requirements).
* A running [Docker](https://docker.com) service.

If you have those, follow through the [`docker-compose`](../docker-compose) guide to get a test setup of TiKV running on your machine.

**Production** usage is typically done via automation requiring:

* A control machine (it can be one of your target servers) with [Ansible](https://www.ansible.com/) installed.
* Several (6+) machines fulfilling the [system requirements](#system-requirements) and at least up to [production specifications](#production-specifications).
* The ability to configure your infrastructure to allow the ports from [network requirements](#network-requirements).

If you have these, follow through the [Ansible deployment](../ansible) guide. You may optionally choose unsupported manual [Docker deployment](../docker) or [binary deployment](../binary) strategies.

Finally, if you want to **develop** TiKV you should consult the [README](https://github.com/tikv/tikv/blob/master/README.md) of the repository.


## System requirements

The **minimum** specifications for testing or developing TiKV or PD are:

* 2+ core
* 8+ GB RAM
* An SSD

TiKV hosts must support the x86-64 architecture and the SSE 4.2 instruction set.

TiKV works well in VMWare, KVM, and Xen virtual machines.


## Production Specifications

The **suggested PD** specifications for production are:

* 3+ nodes
* 4+ cores
* 8+ GB RAM
* 200+ GB SSD
* 10 Gigabit ethernet (2x preferred)

The **suggested TiKV** specifications for production are:

* 3+ nodes
* 16+ cores
* 32+ GB RAM
* a less than 1.5 TB SSD


## Network requirements

TiKV requires the following network port configuration to run. Based on the TiKV deployment in actual environments, the administrator can open relevant ports in the network side and host side.

| Component | Default Port | Description |
| :--:| :--: | :-- |
| TiKV | 20160 | the TiKV communication port |
| PD | 2380 | the inter-node communication port within the PD cluster |
| Pump | 8250 | the Pump communication port |
| Drainer | 8249 | the Drainer communication port |
| Prometheus | 9090 | the communication port for the Prometheus service|
| Pushgateway | 9091 | the aggregation and report port for TiKV, and PD monitor |
| Node_exporter | 9100 | the communication port to report the system information of each TiKV cluster node |
| Blackbox_exporter | 9115 | the `Blackbox_exporter` communication port, used to monitor the ports in the TiKV cluster |
| Grafana | 3000 | the port for the external Web monitoring service and client (Browser) access|
| Grafana | 8686 | the `grafana_collector` communication port, used to export the Dashboard as the PDF format |
| Kafka_exporter | 9308 | the `Kafka_exporter` communication port, used to monitor the binlog Kafka cluster |


## Web browser requirements

Based on the Prometheus and Grafana platform, TiKV provides a visual data monitoring solution to monitor the TiKV cluster status. To access the Grafana monitor interface, it is recommended to use a higher version of Microsoft IE, Google Chrome or Mozilla Firefox.
