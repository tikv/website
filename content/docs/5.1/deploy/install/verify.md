---
title: Verify Cluster Status
description: Check the cluster status and connect to the cluster
menu:
    "5.1":
        parent: Install TiKV
        weight: 3
---

After a TiKV cluster is deployed, you need to check whether the cluster runs normally. This document introduces how to check the cluster status using TiUP commands and Grafana, and how to connect to the TiKV cluster using a TiKV client to perform the simple `put` and `get` operations.

## Check the TiKV cluster status

This section describes how to check the TiKV cluster status using TiUP commands and Grafana.

### Use TiUP

Use the `tiup cluster display <cluster-name>` command to check the cluster status. For example:

```bash
tiup cluster display tikv-test
```

Expected output: If the `Status` information of each node is `Up`, the cluster runs normally.

### Use Grafana

1. Log in to the Grafana monitoring at `${Grafana-ip}:3000`. The default username and password are both `admin`.

2. Click **Overview** and check the TiKV port status and the load monitoring information.

## Connect to the TiKV cluster and perform simple operations

This section describes how to connect to the TiKV cluster using a TiKV client to perform the simple `put` and `get` operations.

1. Download jars

    ```bash
    curl -o tikv-client-java.jar https://download.pingcap.org/tikv-client-java-3.1.0-SNAPSHOT.jar
    curl -o slf4j-api.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar
    ```

2. Install `jshell` (include in JDK >= 9)

3. Try the `put` and `get` operations
    
    To connect the TiKV cluster and use the `put` and `get` RawKV API, save the following script to the file `verify_tikv.java`.


    ```java
    import java.util.*;
    import org.tikv.common.TiConfiguration;
    import org.tikv.common.TiSession;
    import org.tikv.raw.RawKVClient;
    import org.tikv.shade.com.google.protobuf.ByteString;

    TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
    TiSession session = TiSession.create(conf);
    RawKVClient client = session.createRawClient();

    // put
    client.put(ByteString.copyFromUtf8("key"), ByteString.copyFromUtf8("Hello, World!"));

    // get
    System.out.println(client.get(ByteString.copyFromUtf8("key")).toStringUtf8());
    ```

4. Run the test script

    ```bash
    jshell --class-path tikv-client-java.jar:slf4j-api.jar --startup verify_tikv.java

    Hello, World!
    ```
