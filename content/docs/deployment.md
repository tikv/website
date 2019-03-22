---
title: Deployment
description: Ways to Run TiKV
weight: 5
draft: true
---

There are a number of ways to use TiKV in either production or development:

Type                | Description | Use when...
:-------------------|:------------|:-----------
[Ansible](#ansible) | Production-ready batteries-included [Ansible](https://www.ansible.com/) playbooks. | You want a deployment that is fully tuned, configured, and instrumented.
[Docker](#docker) | Officially built and packaged containers ready for use. | You want to use your own configuration management and deployment tools.
[Binary](#binary) | Build-it-yourself binary deployment. | You don't use Docker, and want to use your own configuration management and deployment tools.

{{< info >}}
As with most distributed systems, it's highly recommended you use the official automated deployment tool (Ansible) for production.
{{< /info >}}

In order to run TiKV you will also need to deploy a Placement Driver (PD) cluster.

The minimum recommended topology of a production TiKV cluster includes:

* 3 PD Nodes
* 3 TiKV Nodes

## Ansible {#ansible}

The officially supported Ansible playbooks maintained by PingCAP is the most reliable and performant way to deploy TiKV.

This Ansible playbook can help you:

* Validate your target machines are appropriate hosts for TiKV
* Deploy arbitrary numbers of PD and TiKV nodes
* Properly configure secure node communication
* Perform safe rolling updates
* Safely expand and shrink the cluster
* configure monitoring
* (optionally) install TiDB, an SQL layer for TiKV made by PingCAP

To dive into deploying your first production TiKV cluster, consult the [Ansible deployment guide](https://github.com/tikv/tikv/blob/master/docs/op-guide/deploy-tikv-using-ansible.md).

## Docker containers {#docker}

Officially supported TiKV images are maintained and produced by PingCAP. The [`pingcap/tikv`](https://hub.docker.com/r/pingcap/tikv) image runs the `tikv-server` binary you can build yourself in the [Binary Guide](#binary)

We recommend chosing a the latest stable version from [the list on docker hub](https://hub.docker.com/r/pingcap/tikv/tags):

```bash
docker pull pingcap/tikv:v2.1.6
docker pull pingcap/pd:v2.1.6
```

You can use this image just like you would `tikv-server` or `pd-server`:

```bash
docker run pingcap/tikv:v2.1.6 # ...tikv-server arguments
docker run pingcap/pd:v2.1.6   # ...pd-server arguments
```

With the images in hand, it's time to proceed through the rest of [Docker Deployment Guide](deployment/docker#configure).

## Building a binary {#binary}

> TiKV is not currently publicly distributed as portable binary. This work is in progress as [issue #4426](https://github.com/tikv/tikv/issues/4426).

If you're integrating TiKV into part of a larger infrastructure that doesn't use Ansible or Docker you may wish to deploy TiKV yourself. This 

In order to deploy binaries of TiKV, we first need to build them. Ensure you have installed the [prerequisites](https://github.com/tikv/tikv/#checking-your-prerequisites) you move on. If you're using CentOS (our recommended host for TiKV) you can install these with:

```bash
yum install -y epel-release
yum install git go make unzip ugcc gcc-c++ cmake3 zlib-devel -y
ln -s /bin/cmake3 /bin/cmake

curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain none -y
source $HOME/.cargo/env

PROTOC_ZIP=protoc-3.3.0-linux-x86_64.zip
curl -OL https://github.com/google/protobuf/releases/download/v3.3.0/$PROTOC_ZIP
unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
rm -f $PROTOC_ZIP
```

To build a portable release of TiKV you will need to clone the repository and run `make portable_release`:

```bash
git clone https://github.com/tikv/tikv.git
cd tikv
git checkout v2.1.6 # Choose a version from `git tag`
make release
```

When complete you can find the resulting binary at `target/release/tikv-server`. Take a moment and send this binary to one of your target machines and try running `tikv-server --help`.

> In the future, we hope to install TiKV via `cargo install tikv-server`. You can track this in TODO

With portable binaries in hand, it's time to proceed through the rest of [Binary Deployment Guide](deployment/docker#configure).