---
title: Prerequisites
description: Learn the software and hardware recommendations for deploying and running TiKV
menu:
    "6.5":
        parent: Install TiKV-6.5
        weight: 1
        identifier: Prerequisites-6.5
---

TiKV can be deployed in the Intel architecture server, ARM architecture server, and major virtualization environments and runs well. TiKV supports most of the major hardware networks and Linux operating systems.

## Linux OS version requirements

|    Linux OS Platform     |          Version          |
|:------------------------:|:-------------------------:|
| Red Hat Enterprise Linux | 7.3 or later 7.x releases |
|          CentOS          | 7.3 or later 7.x releases |
| Oracle Enterprise Linux  | 7.3 or later 7.x releases |
|        Ubuntu LTS        |      16.04 or later       |

Other Linux OS versions such as Debian Linux and Fedora Linux might work but are not officially supported.


## Software recommendations

### Control machine

| Software | Version        |
|:-------- |:-------------- |
| sshpass  | 1.06 or later  |
| TiUP     | 1.4.0 or later |

{{< info >}}
It is required that you [deploy TiUP on the control machine](../production#step-1-install-tiup-on-the-control-machine) to operate and manage TiKV clusters.
{{< /info >}}

### Target machines

| Software | Version         |
|:-------- |:--------------- |
| sshpass  | 1.06 or later   |
| numa     | 2.0.12 or later |
| tar      | any             |

## Server recommendations

You can deploy and run TiKV on the 64-bit generic hardware server platform in the Intel x86-64 architecture or on the hardware server platform in the ARM architecture. The recommendations about server hardware configuration (ignoring the resources occupied by the operating system itself) for development, test, and production environments are as follows:

### Development and test environments

| Component |   CPU   | Memory | Local Storage |       Network        | Instance Number (Minimum Requirement) |
|:---------:|:-------:|:------:|:-------------:|:--------------------:|:-------------------------------------:|
|    PD     | 4 core+ | 8 GB+  | SAS, 200 GB+  | Gigabit network card |                   1                   |
|   TiKV    | 8 core+ | 32 GB+ | SAS, 200 GB+  | Gigabit network card |                   3                   |

{{< info >}}
- In the test environment, the TiKV and PD instances can be deployed on the same server.
- For performance-related test, do not use low-performance storage and network hardware configuration, in order to guarantee the correctness of the test result.
- For the TiKV server, it is recommended to use NVMe SSDs to ensure faster reads and writes.
{{< /info >}}

### Production environment

| Component |   CPU    | Memory | Hard Disk Type |                Network                | Instance Number (Minimum Requirement) |
|:---------:|:--------:|:------:|:--------------:|:-------------------------------------:|:-------------------------------------:|
|    PD     | 4 core+  | 8 GB+  |      SSD       | 10 Gigabit network card (2 preferred) |                   3                   |
|   TiKV    | 16 core+ | 32 GB+ |      SSD       | 10 Gigabit network card (2 preferred) |                   3                   |

{{< info >}}
- It is strongly recommended to use higher configuration in the production environment.
- It is recommended to keep the size of TiKV hard disk within 2 TB if you are using PCIe SSDs or within 1.5 TB if you are using regular SSDs.
{{< /info >}}


## Network requirements

TiKV uses the following network ports, and their default port numbers are listed below. Based on the actual environments, you can change the port number in the configuration.

|     Component     | Default Port | Description                                                                             |
|:-----------------:|:------------:|:--------------------------------------------------------------------------------------- |
|       TiKV        |    20160     | the TiKV communication port                                                             |
|       TiKV        |    20180     | the port for fetching statistics, used by Prometheus                                    |
|        PD         |     2379     | the client port, entrance for the clients to connect TiKV cluster                       | 
|        PD         |     2380     | the inter-node communication port within the PD cluster                                 |
|    Prometheus     |     9090     | the communication port for the Prometheus service                                       |
|   Node_exporter   |     9100     | the communication port to report the system information of every TiKV cluster node      |
| Blackbox_exporter |     9115     | the Blackbox_exporter communication port, used to monitor the ports in the TiKV cluster |
|      Grafana      |     3000     | the port for the external Web monitoring service and client (Browser) access            |

To ensure correct configuration, create echo servers on the ports/IP addresses by using `ncat` (from the `nmap` package):

```bash
ncat -l $PORT -k -c 'xargs -n1 echo'
```

Then, from the other machines, verify that the echo server is reachable with `curl $IP:$PORT`.

## Web browser requirements

TiKV relies on [Grafana](https://grafana.com/) to provide visualization of database metrics. A recent version of Internet Explorer, Chrome or Firefox with Javascript enabled is sufficient.
