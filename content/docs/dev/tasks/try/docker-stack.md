---
title: Using Docker Stack
description: Try locally with Docker
menu:
    "dev":
        parent: Try
        weight: 2
---

In this guide, you'll learn how to quickly get a tiny TiKV cluster running locally, then you'll use our Rust client to get, set, and scan data in TiKV. Then you'll learn how to quickly start and stop a TiKV cluster to accompany your development environment.

This guide won't worry about details such as security, resiliency, or production-readiness. (Those topics are covered more in detail in the [deploy](../../deploy/introduction) guides.) Nor will this guide cover how to develop TiKV itself (See [`CONTRIBUTING.md`](https://github.com/tikv/tikv/blob/master/CONTRIBUTING.md).) Instead, this guide focuses on an easy development experience and low resource consumption.

## Overview

In order to get a functioning TiKV service you will need to start a TiKV service and a PD service. PD works alongside TiKV to act as a coordinator and timestamp oracle.

Communication between TiKV, PD, and any services which use TiKV is done via gRPC. We provide clients for [several languages](../../reference/clients/introduction/), and this guide will briefly show you how to use the Rust client.

Using Docker, you'll create pair of persistent services `tikv` and `pd` and learn to manage them easily. Then you'll write a simple Rust client application and run it from your local host. Finally, you'll learn how to quickly teardown and bring up the services, and review some basic limitations of this configuration.

{{< figure
    src="/img/docs/getting-started-docker.svg"
    caption="Docker Stack"
    alt="Docker Stack diagram"
    width="70"
    number="1" >}}

{{< warning >}}
In a production deployment there would be **at least** three TiKV services and three PD services spread among 6 machines. Most deployments also include kernel tuning, sysctl tuning, robust systemd services, firewalls, monitoring with Prometheus, Grafana dashboards, log collection, and more. Even still, to be sure of your resilience and security, consider consulting our [maintainers](https://github.com/tikv/tikv/blob/master/MAINTAINERS.md).

If you are interested in deploying for production we suggest investigating the [deploy](../../deploy/introduction) guides.
{{< /warning >}}

While it's possible to use TiKV through a query layer, like [TiDB](https://github.com/pingcap/tidb) or [Titan](https://github.com/distributedio/titan), you should  refer to the user guides of those projects in order to set up test clusters. This guide only deals with TiKV, PD, and TiKV clients.

## Prerequisites

This guide assumes you have the following knowledge and tools at your disposal:

* Working knowledge about Docker (e.g. how to run or stop a container),
* A modern Docker daemon which can support `docker stack` and the Compose File 3.7 version, running on a machine with:
    + A modern (circa >2012) x86 64-bit processor (supporting SSE4.2)
    + At least 10 GB of free storage space
    + A modest amount of memory (4+ GB) available
    + A `ulimit.nofile` value higher than 82920 for the docker service

While this guide was written with Linux in mind, you can use any operating system as long as the Docker service is able to run Linux containers. You may need to make small adaptations to commands to suite your operating system, [let us know if you get stuck](https://github.com/tikv/website/issues/new) so we can fix it!

## Starting the stack

The maintainers from PingCAP publish battle-tested release images of both `pd` and `tikv` on [Docker Hub](https://hub.docker.com/u/pingcap). These are used in their [TiDB Cloud](https://pingcap.com/tidb-cloud/) kubernetes clusters as well as opt-in via their [`tidb-ansible`](https://github.com/pingcap/tidb-ansible) project.

For a TiKV client to interact with a TiKV cluster, it needs to be able to reach each PD and TiKV node. Since TiKV balances and replicates data across all nodes, and any node may be in charge of any particular *Region* of data, your client needs to be able to reach every node involved. (Replicas of your clients do not need to be able to reach each other.)

In the interest of making sure this guide can work for all platforms, it uses `docker stack` to deploy an ultra-minimal cluster that you can quickly tear down and bring back up again. This cluster won't feature security, persistence, or have static hostnames.

**Unless you've tried using `docker stack` before**, you may need to run `docker swarm init`. If you're unsure, it's best just to run it and ignore the error if you see one.

To begin, create a `stack.yml`:

```yml
version: "3.7"

x-defaults: &defaults
    init: true
    volumes:
        - ./entrypoints:/entrypoints
    environment:
        SLOT: "{{.Task.Slot}}"
        NAME: "{{.Task.Name}}"
    entrypoint: /bin/sh
    deploy:
        replicas: 1
        restart_policy:
            condition: on-failure
            delay: 5s

services:
    pd:
        <<: *defaults
        image: pingcap/pd
        hostname: "{{.Task.Name}}.tikv"
        init: true
        networks:
            tikv:
                aliases:
                    - pd.tikv
        ports:
            - "2379:2379"
            - "2380:2380"
        command: /entrypoints/pd.sh
    tikv:
        <<: *defaults
        image: pingcap/tikv
        hostname: "{{.Task.Name}}.tikv"

        networks:
            tikv:
                aliases:
                    - tikv.tikv
        ports:
            - "20160:20160"
        command: /entrypoints/tikv.sh

networks:
    tikv:
        name: "tikv"
        driver: "overlay"
        attachable: true
```

Then create `entrypoints/pd.sh` with the following:

```bash
#! /bin/sh
set -e

if [ $SLOT = 1 ]; then 
    exec ./pd-server \
        --name $NAME \
        --client-urls http://0.0.0.0:2379 \
        --peer-urls http://0.0.0.0:2380 \
        --advertise-client-urls http://`cat /etc/hostname`:2379 \
        --advertise-peer-urls http://`cat /etc/hostname`:2380
else
    exec ./pd-server \
        --name $NAME \
        --client-urls http://0.0.0.0:2379 \
        --peer-urls http://0.0.0.0:2380 \
        --advertise-client-urls http://`cat /etc/hostname`:2379 \
        --advertise-peer-urls http://`cat /etc/hostname`:2380 \
        --join http://pd.tikv:2379
fi
```

Last, an `entrypoints/tikv.sh` with the following:

```bash
#!/bin/sh
set -e

exec ./tikv-server \
    --addr 0.0.0.0:20160 \
    --status-addr 0.0.0.0:20180 \
    --advertise-addr `cat /etc/hostname`:20160 \
    --pd-endpoints pd.tikv:2379
```

Next, you can deploy the stack to Docker:

```bash
docker stack deploy --compose-file stack.yml tikv
```

The output should look like this:

```bash
Creating network tikv
Creating service tikv_pd
Creating service tikv_tikv
```

## Managing services

**Check the state of running services:**

```bash
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                 PORTS
6ia0pefrd811        tikv_pd             replicated          1/1                 pingcap/pd:latest     *:2379-2380->2379-2380/tcp
26u77puqmw4d        tikv_tikv           replicated          1/1                 pingcap/tikv:latest   *:20160->20160/tcp
```

**Turn off the services:**

{{< warning >}}
This will delete data!
{{</ warning >}}

```bash
$ docker service scale tikv_pd=0 tikv_tikv=0
tikv_pd scaled to 0
tikv_tikv scaled to 0
overall progress: 0 out of 0 tasks 
verify: Service converged 
overall progress: 0 out of 0 tasks 
verify: Service converged
```

**Turn services back on:**

{{< info >}}
This creates brand new containers!
{{</ info >}}

```bash
$ docker service scale tikv_pd=1 tikv_tikv=1
tikv_pd scaled to 1
tikv_tikv scaled to 1
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged
```

**Inquire into the metrics:**

Normally, these would be pulled by Prometheus, but it is human readable and functions as a basic liveliness test.

```bash
$ docker run --rm -ti --network tikv alpine sh -c "apk add curl; curl http://pd.tikv:2379/metrics"
# A lot of output...
$ docker run --rm -ti --network tikv alpine sh -c "apk add curl; curl http://tikv.tikv:20180/metrics"
# A lot of output...
```

**Inquire into the resource consuption of the containers:**

```bash
$ docker stats
CONTAINER ID        NAME                                    CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
c4360f65ded3        tikv_tikv.1.a8sfm113yotkkv5klqtz5cvrn   0.36%               689MiB / 30.29GiB     2.22%               8.44kB / 7.42kB     0B / 0B             66
3f18cc8f415b        tikv_pd.1.r58jn3kolaxgqdbyb8w2mcx8r     1.56%               22.21MiB / 30.29GiB   0.07%               8.11kB / 7.75kB     0B / 0B             21
```

**Remove the stack entirely:**

{{< warning >}}
This will delete data!
{{</ warning >}}

```bash
$ docker stack rm tikv
```

## Creating a project

Below, you'll use the Rust client, but you are welcome to use [any TiKV client](../../reference/clients/introduction/).

Because you will eventually need to deploy the binary into the same network as the PD and TiKV nodes, 

You can create a new example project then change into the directory:

```bash
cargo new tikv-example
cd tikv-example
```

{{< warning >}}
You will need to use a `nightly` toolchain that supports the `async`/`await` feature in order to use the TiKV client in the guide below. This is expected to become stable in Rust 1.38.0.

For now, please `echo 'nightly-2019-08-25' > ./rust-toolchain` in the project directory.
{{< /warning >}}

Next, you'll need to add the TiKV client as a dependency in the `Cargo.toml` file:

```toml
[dependencies]
tikv-client = { git = "https://github.com/tikv/client-rust.git" }
tokio = "0.2.0-alpha.4"
```

Then you can edit the `src/main.rs` file with the following:

```rust
use tikv_client::{Config, RawClient, Error};

#[tokio::main]
async fn main() -> Result<(), Error> {
    let config = Config::new(vec!["http://pd.tikv:2379"]);
    let client = RawClient::new(config)?;
    let key = "TiKV".as_bytes().to_owned();
    let value = "Works!".as_bytes().to_owned();

    client.put(key.clone(), value.clone()).await?;
    println!(
        "Put: {} => {}",
        std::str::from_utf8(&key).unwrap(),
        std::str::from_utf8(&value).unwrap()
    );

    let returned: Vec<u8> = client.get(key.clone()).await?
        .expect("Value should be present.").into();
    assert_eq!(returned, value);
    println!(
        "Get: {} => {}",
        std::str::from_utf8(&key).unwrap(),
        std::str::from_utf8(&value).unwrap()
    );
    Ok(())
}
```

{{< info >}}
TiKV works with binary data to enable your project to store arbitrary data such as binaries or non-UTF-8 encoded data if necessary. While the Rust client accepts `String` values as well as `Vec<u8>`, it will only output `Vec<u8>`.
{{< /info >}}

Now, because the client needs to be part of the same network (`tikv`) as the PD and TiKV nodes, you must to build this binary into a Docker container. Create a `Dockerfile` in the root of your project directory with the following content:

```dockerfile
FROM ubuntu:latest
# Systemwide setup
RUN apt update
RUN apt install --yes build-essential protobuf-compiler curl cmake golang

# Create the non-root user.
RUN useradd builder -m -b /
USER builder
RUN mkdir -p ~/build/src

# Install Rust
COPY rust-toolchain /builder/build/
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain `cat /builder/build/rust-toolchain` -y
ENV PATH="/builder/.cargo/bin:${PATH}"

# Fetch, then prebuild all deps
COPY Cargo.toml rust-toolchain /builder/build/
RUN echo "fn main() {}" > /builder/build/src/main.rs
WORKDIR /builder/build
RUN cargo fetch
RUN cargo build --release
COPY src /builder/build/src
RUN rm -rf ./target/release/.fingerprint/tikv-example*

# Actually build the binary
RUN cargo build --release
ENTRYPOINT /builder/build/target/release/tikv-example
```

Next, build the image:

```bash
docker build -t tikv-example .
```

Then start the produced image:

```bash
docker run -ti --rm --network tikv tikv-example
```

At this point, you're ready to start developing against TiKV!

Want to keep reading? You can explore [Deep Dive TiKV](../../../deep-dive/introduction) to learn more about how TiKV works at a technical level.

Want to improve your Rust abilities? Some of our contributors work on creating [Practical Network Applications](https://github.com/pingcap/talent-plan/tree/master/rust), an open self guided study to master Rust while making fun distributed systems.
