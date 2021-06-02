---
title: TTL on RawKV
description: Time to Live
menu:
    "5.1":
        parent: Features
        weight: 3
---

This page walks you through a simple demonstration of how to use TTL on RawKV.

## Prerequisites

1. Install TiUP by executing the following command:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
```

2. If TiUP is already installed, update the TiUP playground component to the latest version:

```bash
tiup update --self && tiup update playground
```

3. Download jars

```bash
curl -o tikv-client-java.jar https://download.pingcap.org/tikv-client-java-3.1.0-SNAPSHOT.jar
curl -o slf4j-api.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar
```

4. Install `jshell` (include in JDK >= 9)


## Step 1. Config TiKV to enable TTL

TTL is disabled by default. Create a file `tikv.yaml` using the following content to enable TTL.

```yaml
[storage]
enable-ttl = true
```

## Step 2: Start TiKV Cluster

For the purpose of this tutorial, you need only one TiKV node, so use the `tiup playground` command.

Show TiUP version:

```bash
tiup -v
```

version >= 1.5.0:

```bash
tiup playground --mode tikv-slim  --kv.config tikv.yaml
```

version < 1.5.0:

```bash
tiup playground --kv.config tikv.yaml
```

## Step 3: Write the code to test TTL

Let's write an example to verify that TTL works.

Save the following script to file `test_raw_ttl.java`.

```java
import java.util.*;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

// write (k1, v1) with ttl=30 seconds
client.put(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("v1"), 30);

// write (k2, v2) without ttl
client.put(ByteString.copyFromUtf8("k2"), ByteString.copyFromUtf8("v2"));

// get k1 & k2 resturns v1 & v2
System.out.println(client.batchGet(new ArrayList<ByteString>() {{
      add(ByteString.copyFromUtf8("k1"));
      add(ByteString.copyFromUtf8("k2"));
}}));

// sleep 30 seconds
System.out.println("Sleep 30 seconds.")
Thread.sleep(30000);

// get k1 & k2 returns v2
// k1's ttl is expired
System.out.println(client.batchGet(new ArrayList<ByteString>() {{
      add(ByteString.copyFromUtf8("k1"));
      add(ByteString.copyFromUtf8("k2"));
}}));
```

## Step 4: Run the code

```bash
jshell --class-path tikv-client-java.jar:slf4j-api.jar --startup test_raw_ttl.java

[key: "k1"
value: "v1"
, key: "k2"
value: "v2"
]
Sleep 30 seconds.
[key: "k2"
value: "v2"
]
```

As we can see, `k1` is automatically deleted after it's TTL is expired.
