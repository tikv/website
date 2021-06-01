---
title: TiKV in 5 Minutes
description: Get started using TiKV in 5 Minutes
menu:
    "5.1":
        parent: Get Started
        weight: 1
---

This page guides you through the quickest way to get started with TiKV, which includes:
- setting up a local TiKV cluster with the default options,
- monitoring the TiKV cluster,
- writing data to and reading data from the TiKV cluster.

## Prerequisites

Ensure that you are using MacOS or Linux.

{{< warning >}}
The following steps are only for test environments.
{{< /warning >}}
<!-- TODO: For production environments please refer to ??? -->

## Step 1: Install a Playground TiKV Cluster

1. Install TiUP by executing the following command:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
```

2. Set the TiUP environment variables:

Redeclare the global environment variables:

```bash
source .bash_profile
```

Confirm whether TiUP is installed:
```bash
tiup
```

3. If TiUP is already installed, update the TiUP playground component to the latest version:
```bash
tiup update --self && tiup update playground
```

4. Use TiUP playground to start a local TiKV cluster
```bash
tiup playground --mode tikv-slim
```

5. Press `Ctrl + C` to stop the local TiKV cluster

{{< info >}}
Refer to [TiUP playground document](https://docs.pingcap.com/tidb/stable/tiup-playground) to find more TiUP playground commands.
{{< /info >}}

## Step 2: Monitor the cluster

Open [http://127.0.0.1:3000](http://127.0.0.1:3000) and login to the Grafana (username: admin password: admin).

Open `TiKV-Summary` page on Grafana to find the metrics of your TiKV cluster.

## Step 3: Hello, World!

### Python

1. Install `tikv-client` python package

```bash
pip3 install -i https://test.pypi.org/simple/ tikv-client
```

{{< info >}}
This package requires Python 3.5+.
{{< /info >}}

2. Try `RAW KV` API

Save the following python script to file `test_raw.py`.

```python
from tikv_client import RawClient

client = RawClient.connect("127.0.0.1:2379")

# put
client.put(b"k1", b"Hello")
client.put(b"k2", b",")
client.put(b"k3", b"World")
client.put(b"k4", b"!")
client.put(b"k5", b"Raw KV")

# get
print(client.get(b"k1"))

# batch get
print(client.batch_get([b"k1", b"k3"]))

# scan
print(client.scan(b"k1", end=b"k5", limit=10, include_start=True, include_end=True))
```

Run the test script

```bash
python3 test_raw.py

b'Hello'
[(b'k3', b'World'), (b'k1', b'Hello')]
[(b'k1', b'Hello'), (b'k2', b','), (b'k3', b'World'), (b'k4', b'!'), (b'k5', b'Raw KV')]
```

3. Try `TXN KV` API

Save the following python script to file `test_txn.py`.

```python
from tikv_client import TransactionClient

client = TransactionClient.connect("127.0.0.1:2379")

# put
txn = client.begin()
txn.put(b"k1", b"Hello")
txn.put(b"k2", b",")
txn.put(b"k3", b"World")
txn.put(b"k4", b"!")
txn.put(b"k5", b"TXN KV")
txn.commit()

snapshot = client.snapshot(client.current_timestamp())

# get
print(snapshot.get(b"k1"))

# batch get
print(snapshot.batch_get([b"k1", b"k3"]))

# scan
print(snapshot.scan(b"k1", end=b"k5", limit=10, include_start=True, include_end=True))
```

Run the test script

```bash
python3 test_txn.py

b'Hello'
[(b'k3', b'World'), (b'k1', b'Hello')]
[(b'k1', b'Hello'), (b'k2', b','), (b'k3', b'World'), (b'k4', b'!'), (b'k5', b'TXN KV')]
```

### Java

1. Download jars

```bash
curl -o tikv-client-java.jar https://download.pingcap.org/tikv-client-java-3.1.0-SNAPSHOT.jar
curl -o slf4j-api.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar
```

2. Install `jshell` (include in JDK9)

3. Try `RAW KV` API

Save the following script to file `test_raw.java`.

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
client.put(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("Hello"));
client.put(ByteString.copyFromUtf8("k2"), ByteString.copyFromUtf8(","));
client.put(ByteString.copyFromUtf8("k3"), ByteString.copyFromUtf8("World"));
client.put(ByteString.copyFromUtf8("k4"), ByteString.copyFromUtf8("!"));
client.put(ByteString.copyFromUtf8("k5"), ByteString.copyFromUtf8("Raw KV"));

// get
System.out.println(client.get(ByteString.copyFromUtf8("k1")).toStringUtf8());

// batch get
System.out.println(client.batchGet(new ArrayList<ByteString>() {{
      add(ByteString.copyFromUtf8("k1"));
      add(ByteString.copyFromUtf8("k3"));
}}));

// scan
System.out.println(client.scan(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("k6"), 10));
```

Run the test script

```bash
jshell --class-path tikv-client-java.jar:slf4j-api.jar --startup test_raw.java

Hello
[key: "k1"
value: "Hello"
, key: "k3"
value: "World"
]
[key: "k1"
value: "Hello"
, key: "k2"
value: ","
, key: "k3"
value: "World"
, key: "k4"
value: "!"
, key: "k5"
value: "Raw KV"
]
```
