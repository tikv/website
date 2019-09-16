---
title: Administrators
description: Try docker locally
menu:
    docs:
        parent: Try
---



## Using Docker Stack for interactive testing

Docker, when in Swarm mode, has a 'Stack' feature which is similar to `docker-compose` and offers more flexibility. It's possible to use this to easily test out new changes.

Combined with the tools learnt above, create a `dev-cluster.yml` file in your `tikv-example` folder that contains the following:

```yaml
version: "3.7"
services:
    # In order to smooth startup and ensure the cluster doesn't get too delayed with voting, we use a bootstrap node for PD,
    # it will always start as leader. Later it may lose it's leadership.
    pd-bootstrap:
        image: pingcap/pd
        hostname: "{{.Task.Name}}.tikv"
        deploy:
            replicas: 1
            restart_policy:
                condition: on-failure
                delay: 5s
        networks:
            tikv:
                aliases:
                    - pd-bootstrap.tikv
        ports:
            - "2377:2377"
            - "2378:2378"
        volumes:
            - pd:/data
        environment:
            - SLOT={{.Task.Slot}}
        entrypoint: /bin/sh
        command: -c './pd-server --name `cat /etc/hostname` --data-dir /data/`cat /etc/hostname` --client-urls http://0.0.0.0:2377 --peer-urls http://0.0.0.0:2378 --advertise-client-urls http://`cat /etc/hostname`:2377 --advertise-peer-urls http://`cat /etc/hostname`:2378'
    pd:
        image: pingcap/pd
        hostname: "{{.Task.Name}}.tikv"
        deploy:
            replicas: 2
            restart_policy:
                condition: on-failure
                delay: 5s
        networks:
            tikv:
                aliases:
                    - pd.tikv
        ports:
            - "2379:2379"
            - "2380:2380"
        volumes:
            - pd:/data
        environment:
            - SLOT={{.Task.Slot}}
        entrypoint: /bin/sh
        command: -c './pd-server --name default.`cat /etc/hostname` --data-dir /data/`cat /etc/hostname` --client-urls http://0.0.0.0:2379 --peer-urls http://0.0.0.0:2380 --advertise-client-urls http://`cat /etc/hostname`:2379 --advertise-peer-urls http://`cat /etc/hostname`:2380 --join http://pd-bootstrap.tikv:2377'
    tikv:
        image: pingcap/tikv
        hostname: "{{.Task.Name}}.tikv"
        deploy:
            replicas: 3
            restart_policy:
                condition: on-failure
                delay: 5s
        networks:
            tikv:
                aliases:
                    - tikv.tikv
        ports:
            - "20160:20160"
        volumes:
            - tikv:/data
        environment:
            - SLOT={{.Task.Slot}}
        entrypoint: /bin/sh
        command: -c './tikv-server --addr 0.0.0.0:20160 --data-dir /data/`cat /etc/hostname` --advertise-addr `cat /etc/hostname`:20160 --pd-endpoints pd-bootstrap.tikv:2377,pd.tikv:2378'
networks:
    tikv:
        name: "tikv"
        driver: "overlay"
        attachable: true
volumes:
    pd:
    tikv:

```

Then, alter the `src/main.rs` file to point to `http://pd.test:2379` and rebuild the image `docker build -t tikv-example .`

Deploy the stack:

```bash
docker stack deploy --compose-file dev-cluster.yml dev
```

Now give the cluster a minute to stablize. PD and TiKV nodes need to negioate a happy arrangement.

```bash
docker service ls
```

This should show you lots of happy nodes.

The following should show you successes:

```bash
docker service logs dev_example
```