---
title: Get, Put, and Delete
description: How to use RawKV's basic operations such as Get, Put, and Delete.
menu:
    "7.1":
        parent: RawKV-7.1
        weight: 1
        identifier: Get, Put, and Delete-7.1
---

This document walks you through how to use RawKV's basic operations such as `Get`, `Put`, and `Delete`.

## Java

### Import packages

First, import all necessary packages as shown in the example.

```java
import java.util.Optional;
import org.tikv.shade.com.google.protobuf.ByteString;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.raw.RawKVClient;
```

In the example above, `com.google.protobuf.ByteString` is used as the type of Key and Value.

To avoid conflict, `com.google.protobuf.ByteString` is shaded to `org.tikv.shade.com.google.protobuf.ByteString`, and is included in the client package.

### Create RawKVClient

To connect to TiKV, a PD address `127.0.0.1:2379` is passed to `TiConfiguration`.

{{< info >}}
A comma is used to separate multiple PD addresses. For example, `127.0.0.1:2379,127.0.0.2:2379,127.0.0.3:2379`.
{{< /info >}}

Using the connected `org.tikv.raw.RawKVClient`, you can perform actions such as `Get`, `Put`, and `Delete`.

```java
TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();
```

### Write data to TiKV

Using the `put` API, you can write a key-value pair to TiKV.

```java
ByteString key = ByteString.copyFromUtf8("Hello");
ByteString value = ByteString.copyFromUtf8("RawKV");
client.put(key, value);
```

### Read data from TiKV

Using the `get` API, you can get the value of a key from TiKV. If the key does not exist, `result.isPresent()` will be false.

```java
Optional<ByteString> result = client.get(key);
assert(result.isPresent());
assert("RawKV".equals(result.get().toStringUtf8()));
```

### Delete data from TiKV

Using the `delete` API, you can delete a key-value pair from TiKV.

```java
client.delete(key);
result = client.get(key);
assert(!result.isPresent());
```

### Close working instances

Finally, do not forget to close the `client` and `session` instance.

```java
client.close();
session.close();
```

The code example used in this chapter can be found [here](https://github.com/marsishandsome/tikv-client-examples/blob/main/java-example/src/main/java/example/rawkv/PutGetDelete.java).
