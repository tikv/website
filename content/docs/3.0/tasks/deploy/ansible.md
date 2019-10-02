---
title: Ansible Deployment
description: Use TiDB-Ansible to deploy a TiKV cluster on multiple nodes.
menu:
    docs:
        parent: Deploy
        weight: 2
---

This guide describes how to install and deploy TiKV using Ansible. Ansible is an IT automation tool that can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.


PingCAP (the original authors of TiKV, and a maintaining organization of TiKV), develops and maintains
the Apache 2 licensed [TiDB-Ansible](https://github.com/pingcap/tidb-ansible). TiDB-Ansible is a collection of Ansible playbooks that enables you to quickly deploy fully featured TiDB (and TiKV) clusters along with comprehensive monitoring.

Here are some useful links to into the official guide to get you started:

* [Deploy a cluster with a given topology and optimal system parameters](https://pingcap.com/docs/dev/how-to/deploy/orchestrated/ansible/)
* [Stop a cluster](https://pingcap.com/docs/dev/how-to/deploy/orchestrated/ansible-operations/#stop-a-cluster)
* [Start a cluster](https://pingcap.com/docs/dev/how-to/deploy/orchestrated/ansible-operations/#start-a-cluster)
* [Modify TiKV, PD, and TiDB configurations](https://pingcap.com/docs/dev/how-to/upgrade/rolling-updates-with-ansible/#modify-component-configuration)
* [Scale a cluster in or out](https://pingcap.com/docs/dev/how-to/scale/with-ansible/)
* [Upgrade TiKV, PD, and TiDB versions](https://pingcap.com/docs/dev/how-to/upgrade/rolling-updates-with-ansible/#upgrade-the-component-version)
* [Destroy a cluster](https://pingcap.com/docs/dev/how-to/deploy/orchestrated/ansible-operations/#destroy-a-cluster)
