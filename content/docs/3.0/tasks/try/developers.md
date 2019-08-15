---
title: Developers
description: Try docker locally
menu:
    docs:
        parent: Try
---

In this guide, you'll learn how to quickly get a tiny TiKV cluster running locally, then you'll use our Rust client to get, set, and scan data in TiKV. Then you'll learn how to quickly start and stop a TiKV cluster to accompany your development environment.

After the [overview](), where you'll learn the basics of how TiKV works, and what you need to complete this guide, you'll be able to start a cluster using Docker in several different ways, [containers](), [services](), and as a [stack]().

This guide won't worry about details such as security, resiliency, or production-readiness. (Those topics are covered more in the [Try for Administrators]() guide, and in detail in the [deploy]() guides.) Nor will this guide cover how to develop TiKV itself (See [`CONTRIBUTING.md`](https://github.com/tikv/tikv/blob/master/CONTRIBUTING.md).) Instead, this guide focuses on a good development experience and low resource consumption.

## Overview

In order to get a functioning TiKV service you will need to start a TiKV service and a PD service. PD works alongside TiKV to act as a coordinator and timestamp oracle.

Communication between TiKV, PD, and any services which use TiKV is done via gRPC. We provide clients for [several languages](../../../reference/clients/introduction/), and this guide will briefly show you how to use the Rust client.

Using Docker, you'll create pair of persistent services `tikv` and `pd` and learn to manage them easily. Then you'll write a simple Rust client application and run it from your local host. Finally, you'll learn how to quicky teardown and bring up the services, and review some basic limitations of this configuration.

{{< diagram >}}
graph LR
    client --- pd
    client --- tikv
    subgraph "Docker"
        tikv --- pd
    end
{{< /diagram >}}

{{< warning >}}
In a production deployment there would be **at least** three TiKV services and three PD services spread among 6 machines. Most deployments also include kernel tuning, sysctl tuning, robust systemd services, firewalls, monitoring with prometheus, grafana dashboards, log collection, and more. Even still, to be sure of your resilience and security, consider consulting our [maintainers](https://github.com/tikv/tikv/blob/master/MAINTAINERS.md).

If you are interested in deploying for production we suggest investigating the [administrator's getting started guide](../administrators) then the [deploy](../../deploy/introduction) guides.
{{< /warning >}}

While it's possible to use TiKV through a query layer, like [TiDB](https://github.com/pingcap/tidb) or [Titan](https://github.com/distributedio/titan), you should  refer to the user guides of those projects in order to set up test clusters. This guide only deals with TiKV, PD, and TiKV clients.

## Prerequisites

This guide assumes you have the following knowledge and tools at your disposal:

* Working knowledge of your system's command line tools,
* Working knowledge about Docker (eg how to run or stop a container),
* A modern Docker daemon which can support `docker service`, running on a machine with:
    + A modern (circa >2012) x86 64-bit processor (supporting SSE4.2)
    + At least 10 GB of free storage space
    + A modest amount of memory (4+ GB) available
    + A `ulimit.nofile` value higher than 82920 for the docker service

While this guide was written with Linux in mind, you can use any operating system as long as the Docker service is able to run Linux containers. You may need to make small adaptations to commands to suite your operating system, [let us know if you get stuck](https://github.com/tikv/website/issues/new) so we can fix it!

## Starting the services

The maintainers from PingCAP publish battle-tested release images of both `pd` and `tikv` on [Docker Hub](https://hub.docker.com/u/pingcap).

{{< info >}}
The TiKV authors are working to publish to the [TiKV organization](https://hub.docker.com/u/tikv) by 2020.
{{< /info >}}

To begin, you can use `docker service create` to create the services. A brief overview of the command we're using:

* `--name`: The name of the service.
* `--replica`: This configuration only supports 1 replica.
* `--network`: `host` means containers are addressable as `localhost`.
* `--init`: Provide a `tini` based init for the service containers.
* `--restart-condition`: `on-failure` configures the service to only restart when exit not zero.
* `--restart-delay`: Using a `5s` delay helps prevent many quick restarts.
* `--mount`: Using a volume means state will persist in case of restart.

Then the configuration for PD:

```bash
docker service create \
    --name "pd" \
    --replicas 1 \
    --network "host" \
    --init \
    --restart-condition "on-failure" \
    --restart-delay "5s" \
    --mount "type=volume,src=pd,target=/data" \
    pingcap/pd \
        --client-urls "http://0.0.0.0:2379" \
        --advertise-client-urls "http://localhost:2379" \
        --data-dir "/data"
```

* `--client-urls`: Listening on all ports keeps this configuration simple.
* `--advertise-client-urls`: Inform other services to look for this on `localhost`.
* `--data-dir`: Store data in `/data`, the volume created for it.

Finally, the configuration for TiKV:

```bash
docker service create \
    --name "tikv" \
    --replicas 1 \
    --network "host" \
    --init \
    --restart-condition "on-failure" \
    --restart-delay "5s" \
    --mount "type=volume,src=tikv,target=/data" \
    pingcap/tikv \
        --addr "0.0.0.0:20160" \
        --advertise-addr "localhost:20160" \
        --pd-endpoints "localhost:2379" \
        --data-dir "/data" \
        --status-addr "0.0.0.0:20180"
```

* `--addr`: Listening on all ports keeps this configuration simple.
* `--advertise-client-urls`: Inform other services to look for this on `localhost`.
* `--static-addr`: Serve metrics on port 20180.
* `--pd-endpoints`: Search for PD on the localhost.
* `--data-dir`: Store data in `/data`, the volume created for it.

When the services are successfully started, you'll see a message like:

```bash
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged
```

{{< warning >}}
If you're using Docker Desktop (for Mac or Windows), you'll need to add ports **20160** and **2379** to your allowed passthroughs.
{{</ warning >}}

## Managing Services

**Check the state of running services:**

```bash
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                 PORTS
qnld8dhk5lfx        pd                  replicated          1/1                 pingcap/pd:latest
p4uxyyyatjjo        tikv                replicated          1/1                 pingcap/tikv:latest
```

**Turn off the services:**

```bash
$ docker service scale pd=0 tikv=0
pd scaled to 0
tikv scaled to 0
overall progress: 0 out of 0 tasks
verify: Service converged
overall progress: 0 out of 0 tasks
verify: Service converged
```

**Turn services back on:**

```bash
$ docker service scale pd=1 tikv=1
pd scaled to 1
tikv scaled to 1
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
$ curl localhost:2379/metrics
# A lot of output...
$ curl localhost:20180/metrics
# A lot of output...
```

## Creating a project

Below, we'll use the Rust client, but you are welcome to use [any TiKV client](../../../reference/clients/introduction/).

Before you start, make sure you have **Rustup** installed through the recommended method on [`rustup.rs`](https://rustup.rs/) for your platform. You'll also need a version of the protobuf compiler. 

You can create a new example project with `cargo new tikv-example`, then, change into the directory.

{{< warning >}}
You will need to use a `nightly` toolchain that supports the `async`/`await` feature in order to use the TiKV client in the guide below. This is expected to become stable in Rust 1.38.0.

For now, please `echo 'nightly' > ./rust-toolchain` in the project directory.

We plan to publish the first stable version of the TiKV client shortly after.
{{< /warning >}}

Next, you'll need to add the TiKV client as a dependency in the `Cargo.toml` file:

```toml
[dependencies]
tikv-client = {
    git = "https://github.com/tikv/client-rust.git"
}
tokio = "0.2.0-alpha.4"
```

Then you can edit the `src/main.rs` file with the following:

```rust
use tikv_client::{Config, RawClient, Error};

#[tokio::main]
async fn main() -> Result<(), Error> {
    let config = Config::new(vec!["http://localhost:2379"]);
    let client = RawClient::new(config)?;
    let key = "TiKV".as_bytes().to_owned();
    let value = "Works!".as_bytes().to_owned();

    client.put(key.clone(), value.clone()).await?;
    println!(
        "Put: {} => {}",
        std::str::from_utf8(&key).unwrap(),
        std::str::from_utf8(&value).unwrap()
    );

    let returned: Vec<u8> = client.get(key.clone())
        .await?
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

Then, run a build on your local host, it should connect to the PD and TiKV service, and set, then get the key `TiKV` to associate with the value `Works!`.

```bash
cargo run
```

{{< info >}}
TiKV works with binary data to enable users to store arbitrary data such as binaries or non-UTF-8 encoded data.
{{< /info >}}

At this point, you're ready to start developing against TiKV!

Want to keep reading? You can explore [Deep Dive TiKV](../../../deep-dive/introduction) to learn more about how TiKV works at a technical level.
