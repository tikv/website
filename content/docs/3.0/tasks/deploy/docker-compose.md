---
title: Docker Compose/Swarm
description: Use Docker Compose or Swarm to quickly deploy a TiKV testing cluster.
menu:
    docs:
        parent: Deploy
        weight: 5
---

This guide describes how to deploy a single-node TiKV cluster using Docker Compose, or a multi-node TiKV cluster using Docker Swarm.

{{< warning >}}
The TiKV team strongly recommends you use the [**Ansible Deployment**](../ansible/) method. It is the method our team uses when we assist with deployment.

Other methods are documented for informational purposes. We strongly recommend [consulting with our contributors](/chat) before depending on a cluster deployed without the Ansible scripts.
{{< /warning >}}

PingCAP (the original authors of TiKV, and a maintaining organization of TiKV), develops and maintains the Apache 2 licensed [TiDB docker-compose](https://github.com/pingcap/tidb-docker-compose). TiDB docker-compose is a collection of Docker Compose files which enable you to quickly 'test drive' TiKV as well as TiDB, TiSpark, and the monitoring tools.

TiDB docker-compose is compatible with Linux as well as Mac and Windows through [Docker Desktop](https://www.docker.com/products/docker-desktop).

We recommend using the [**Docker Swarm option**](https://github.com/pingcap/tidb-docker-compose#docker-swarm) option for using TiKV. If your Docker service is not able to support Swarm, the normal [Docker Compose](https://github.com/pingcap/tidb-docker-compose#quick-start) option requires some [manual configuration to interact with TiKV directly](https://github.com/pingcap/tidb-docker-compose#host-network-mode-linux) on non-Linux systems.