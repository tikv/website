---
title: Scan
description: Learn how to use RawKV's Scan API.
menu:
    "6.1":
        parent: RawKV-v6.1
        weight: 2
        identifier: Scan-v6.1
---

This document walks you through how to use RawKV's `Scan` API.

## Java

### Scan with `limit`

Using the `Scan` API, you can scan key-value pairs from TiKV in a range (from a `startKey` to an `endKey`).

{{< info >}}
`startKey` is inclusive while `endKey` is exclusive.

To configure the `Scan` API to return a limited number of key-value pairs, you can use the `limit` argument as in the following example code:

{{< /info >}}

```java
import java.util.List;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.kvproto.Kvrpcpb;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

// prepare data
client.put(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("v1"));
client.put(ByteString.copyFromUtf8("k2"), ByteString.copyFromUtf8("v2"));
client.put(ByteString.copyFromUtf8("k3"), ByteString.copyFromUtf8("v3"));
client.put(ByteString.copyFromUtf8("k4"), ByteString.copyFromUtf8("v4"));

// scan with limit
int limit = 1000;
List<Kvrpcpb.KvPair> list = client.scan(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("k5"), limit);
for(Kvrpcpb.KvPair pair : list) {
    System.out.println(pair);
}

// close
client.close();
session.close();
```

### Scan all data

The `Scan` API only returns a limited number of key-value pairs. If you want to fetch all the data in the range from `startKey` to `endKey`, refer to the following example code for a simple demo: 

```java
import java.util.List;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.common.key.Key;
import org.tikv.kvproto.Kvrpcpb;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

// prepare data
String keyPrefix = "p";
for(int i = 1; i <= 9; i ++) {
    for(int j = 1; j <= 9; j ++) {
        client.put(ByteString.copyFromUtf8(keyPrefix + i + j), ByteString.copyFromUtf8("v" + i + j));
    }
}

// scan all data
ByteString startKey = ByteString.copyFromUtf8(keyPrefix + "11");
ByteString endKey = Key.toRawKey(ByteString.copyFromUtf8(keyPrefix + "99")).next().toByteString();
int limit = 4;
while(true) {
    List<Kvrpcpb.KvPair> list = client.scan(startKey, endKey, limit);
    Key maxKey = Key.MIN;
    for (Kvrpcpb.KvPair pair : list) {
        System.out.println(pair);
        Key currentKey = Key.toRawKey(pair.getKey());
        if(currentKey.compareTo(maxKey) > 0) {
            maxKey = currentKey;
        }
    }

    if(list.size() < limit) {
        break;
    }
    startKey = maxKey.next().toByteString();
}
```

To get the example code above, click [here](https://github.com/marsishandsome/tikv-client-examples/blob/main/java-example/src/main/java/example/rawkv/Scan.java).
