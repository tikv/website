---
title: Java Client
description: Interact with TiKV using Java.
menu:
    "5.1":
        parent: TiKV Clients
        weight: 1
---

This guide introduces how to interact with TiKV using [Java Client](https://github.com/tikv/client-java).

{{< warning >}}
TiKV Java Client is developed and released using Java8. The minimum supported version of TiKV is 2.0.0.
{{< /warning >}}

## Add the dependency

To start, open the `pom.xml` of your project, and add the `tikv-client-java` as dependencies if you are using Maven.

```xml
<dependency>
  <groupId>org.tikv</groupId>
  <artifactId>tikv-client-java</artifactId>
  <version>${latest_version}</version>
</dependency>
```

## Raw key-value API

Using a connected `org.tikv.raw.RawKVClient`, you can perform actions such as `put`, `get`, `delete` and `scan`:

```java
import com.google.protobuf.ByteString;
import java.util.List;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.kvproto.Kvrpcpb;
import org.tikv.raw.RawKVClient;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

ByteString key = ByteString.copyFromUtf8("Hello");
ByteString value = ByteString.copyFromUtf8("RawKV");

// put
client.put(key, value);

// get
ByteString result = client.get(key);
assert("RawKV".equals(result.toStringUtf8()));
System.out.println(result.toStringUtf8());

// delete
client.delete(key);

// get
result = client.get(key);
assert(result.toStringUtf8().isEmpty());
System.out.println(result.toStringUtf8());

// scan
int limit = 1000;
client.put(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("v1"));
client.put(ByteString.copyFromUtf8("k2"), ByteString.copyFromUtf8("v2"));
client.put(ByteString.copyFromUtf8("k3"), ByteString.copyFromUtf8("v3"));
client.put(ByteString.copyFromUtf8("k4"), ByteString.copyFromUtf8("v4"));

List<Kvrpcpb.KvPair> list = client.scan(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("k5"), limit);
for(Kvrpcpb.KvPair pair : list) {
  System.out.println(pair);
}
```


These functions also have batch variants (`batchPut`, `batchGet`, `batchDelete` and `batchScan`), which offer considerably reduced network overhead and can result in dramatic performance increases under certain workloads.

You can find all the functions that `RawKVClient` supports [here](https://github.com/tikv/client-java/blob/master/src/main/java/org/tikv/raw/RawKVClient.java).

## Transactional key-value API

Transactional key-value API is still in the stage of prove-of-concept and under heavy development.
