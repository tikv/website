---
title: Deploy
description: Prerequisites for deploying TiKV
menu:
    "3.1-beta":
        parent: Tasks
        weight: 2
        name: Deploy
---


Typical deployments of TiKV include a number of components:

* 3+ TiKV nodes
* 3+ Placement Driver (PD) nodes
* 1 Monitoring node
* 1 or more client application or query layer (like [TiDB](https://github.com/pingcap/tidb))

{{< info >}}
TiKV is deployed alongside a [Placement Driver](https://github.com/pingcap/pd/) (PD) cluster. PD is the cluster manager of TiKV, which periodically checks replication constraints to balance load and data automatically.
{{< /info >}}

Your **first steps** into TiKV require only the following:

* A modest machine that fulfills the [system requirements](#system-requirements).
* A running [Docker](https://docker.com) service.

After you set up the environment, follow through the [Try](../try) guide to get a test setup of TiKV running on your machine.

**Production** usage is typically done via automation requiring:

* A control machine (it can be one of your target servers) with [Ansible](https://www.ansible.com/) installed.
* Several (6+) machines fulfilling the [system requirements](#system-requirements) and at least up to [production specifications](#production-specifications).
* The ability to configure your infrastructure to allow the ports from [network requirements](#network-requirements).

If you have your production environment ready, follow through the [Ansible deployment](../ansible) guide. You may optionally choose unsupported manual [Docker deployment](../docker) or [binary deployment](../binary) strategies.

Finally, if you want to **build your own binary** TiKV you should consult the [README](https://github.com/tikv/tikv/blob/master/README.md) of the repository.

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
* 8+ GB RAM, with no swap space.
* 200+ GB Optane, NVMe, or SSD drive
* 10 Gigabit ethernet (2x preferred)
* A Linux Operating System, PD is most widely tested on CentOS 7.

The **suggested TiKV** specifications for production are:

* 3+ nodes
* 16+ cores
* 32+ GB RAM, with no swap space.
* 200+ GB Optane, NVMe, or SSD drive (Under 1.5 TB capacity is ideal in our tests)
* 10 Gigabit ethernet (2x preferred)
* A Linux Operating System, PD is most widely tested on CentOS 7.

## Network requirements

TiKV deployments require **total connectivity of all services**. Each TiKV, PD, and client must be able to reach each all other and advertise the addresses of all other services to new services. This connectivity allows TiKV and PD to replicate and balance data resiliently across the entire deployment.

If the hosts are not already able to reach each other, it is possible to accomplish this through a Virtual Local Area Network (VLAN). Speak to your system administrator to explore your options.

TiKV requires the following network port configuration to run. Based on the TiKV deployment in actual environments, the administrator can open relevant ports in the network side and host side.

| Component | Default Port | Protocol | Description |
| :--:| :--: | :--: | :-- |
| TiKV | 20160 | gRPC | Client (such as Query Layers) port. |
| TiKV | 20180 | Text | Status port, Prometheus metrics at  `/metrics`. |
| PD | 2379 | gRPC | The client port, for communication with clients. |
| PD | 2380 | gRPC | The server port, for communication with TiKV. |

{{< info >}}
If you are deploying tools alongside TiKV you may need to open or configure other ports. For example, port 3000 for the Grafana service.
{{< /info >}}

You can ensure your confguration is correct by creating echo servers on the ports/IPs by using `ncat` (from the `nmap` package): 

```bash
ncat -l $PORT -k -c 'xargs -n1 echo'
```

Then from the other machines, verify that the echo server is reachable with `curl $IP:$PORT`.

## Optional: Configure Monitoring

TiKV can work with Prometheus and Grafana to provide a rich visual monitoring dashboard. This comes preconfigured if you use the [Ansible](../ansible) or [Docker Compose](../docker-compose) deployment methods.

We strongly recommend using an up-to-date version of Mozilla Firefox or Google Chrome when accessing Grafana.
