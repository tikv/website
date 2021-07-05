---
title: TiKV in 5 Minutes
description: Get started using TiKV in 5 Minutes
menu:
    "5.1":
        parent: Get Started
        weight: 1
---

This tutorial provides you a quick way to get started with TiKV, including the following operations:

- [Set up a local TiKV cluster with the default options](#set-up-a-local-tikv-cluster-with-the-default-options)
- [Monitor the TiKV cluster](#monitor-the-cluster)
- [Write data to and read data from the TiKV cluster](#write-data-to-and-read-data-from-the-tikv-cluster)
- [Stop and delete a TiKV cluster](#stop-and-delete-the-tikv-cluster)

## Prerequisites

Before you start, ensure that you are using macOS or Linux.

{{< warning >}}
This quick-start tutorial is only for test environments. For production environments, refer to [Install TiKV](../../deploy/install/install/).
{{< /warning >}}

## Set up a local TiKV cluster with the default options

1. Install TiUP by executing the following command:

    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
    ```

2. Set the TiUP environment variables:

    1. Redeclare the global environment variables:

        ```bash
        source .bash_profile
        ```

    2. Confirm whether TiUP is installed:

        ```bash
        tiup
        ```

3. If TiUP is already installed, update the TiUP Playground component to the latest version:

    ```bash
    tiup update --self && tiup update playground
    ```

4. Use TiUP Playground to start a local TiKV cluster. Before you do that, check your TiUP version using the following command:

    ```bash
    tiup -v
    ```

    - If your TiUP version is v1.5.2 or later, execute the following command to start a local TiKV cluster:

        ```bash
        tiup playground --mode tikv-slim
        ```

    - If your TiUP version is earlier than v1.5.2, execute the following command to start a local TiKV cluster:

        ```bash
        tiup playground
        ```

    {{< info >}}
Refer to [TiUP playground document](https://docs.pingcap.com/tidb/stable/tiup-playground) for more TiUP Playground commands.
    {{< /info >}}

## Monitor the TiKV cluster

After the TiKV cluster is started using TiUP Playground, to monitor the cluster metrics, perform the following steps:

1. Open your browser, access [http://127.0.0.1:3000](http://127.0.0.1:3000), and then log in to the Grafana Dashboard. 

    By default, the username is `admin` and the password is `admin`.

2. Open the `TiKV-Summary` page on the Grafana Dashboard and find the monitoring metrics of your TiKV cluster.

## Write data to and read data from the TiKV cluster

To write to and read from the TiKV cluster, you can use Java, Go, Rust, C, or Python script. 

The following two examples use Java and Python respectively to show how to write "Hello World!" to TiKV.

### Use Java

1. Download the JAR files using the following commands:

    ```bash
    curl -o tikv-client-java.jar https://download.pingcap.org/tikv-client-java-3.2.0-SNAPSHOT.jar && \
    curl -o slf4j-api.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar
    ```

2. Install `jshell`. The JDK version should be 9.0 or later.

3. Try the `RAW KV` API.

    1. Save the following script to the `test_raw.java` file.

        ```java
        import java.util.ArrayList;
        import java.util.List;
        import java.util.Optional;
        import org.tikv.common.TiConfiguration;
        import org.tikv.common.TiSession;
        import org.tikv.kvproto.Kvrpcpb;
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
        Optional<ByteString> result = client.get(ByteString.copyFromUtf8("k1"));
        System.out.println(result.get().toStringUtf8());

        // batch get
        List<Kvrpcpb.KvPair> list =client.batchGet(new ArrayList<ByteString>() {{
        add(ByteString.copyFromUtf8("k1"));
        add(ByteString.copyFromUtf8("k3"));
        }});
        System.out.println(list);

        // scan
        list = client.scan(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("k6"), 10);
        System.out.println(list);

        // close
        client.close();
        session.close();
        ```

    2. Run the `test_raw.java` script to write "Hello World!" to TiKV:

        ```bash
        jshell --class-path tikv-client-java.jar:slf4j-api.jar --startup test_raw.java
        ```

        The output is as follows:

        ```bash
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

### Use Python

1. Install the `tikv-client` python package.

    ```bash
    pip3 install -i https://test.pypi.org/simple/ tikv-client
    ```

    {{< info >}}
This package requires Python 3.5+.
    {{< /info >}}

2. Use either the `RAW KV` API or `TXN KV` API to write data to TiKV.

    - Try the `RAW KV` API.

        1. Save the following Python script to the `test_raw.py` file.

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

        2. Run the `test_raw.py` script to write "Hello World!" to TiKV:

            ```bash
            python3 test_raw.py
            ```

            The output is as follows:

            ```bash
            b'Hello'
            [(b'k3', b'World'), (b'k1', b'Hello')]
            [(b'k1', b'Hello'), (b'k2', b','), (b'k3', b'World'), (b'k4', b'!'), (b'k5', b'Raw KV')]
            ```

    - Try the `TXN KV` API.

        1. Save the following Python script to the `test_txn.py` file.

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

        2. Run the `test_txn.py` script to write "Hello World!" to TiKV:

            ```bash
            python3 test_txn.py
            ```

            The output is as follows:

            ```bash
            b'Hello'
            [(b'k3', b'World'), (b'k1', b'Hello')]
            [(b'k1', b'Hello'), (b'k2', b','), (b'k3', b'World'), (b'k4', b'!'), (b'k5', b'TXN KV')]
            ```

## Stop and delete the TiKV cluster

If you do not need the local TiKV cluster anymore, you can stop and delete it.

1. To stop the TiKV cluster, get back to the terminal session in which you have started the TiKV cluster. Press <kbd>Ctrl</kbd> + <kbd>C</kbd> and wait for the cluster to stop.

2. After the cluster is stopped, to delete the cluster, execute the following command:

    ```sh
    tiup clean --all
    ```
