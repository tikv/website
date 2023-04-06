---
title: Java Client
description: Interact with TiKV using Java.
menu:
    "6.5":
        parent: TiKV Clients-6.5
        weight: 1
        identifier: Java Client-6.5
---

This document guides you on how to use [Java Client](https://github.com/tikv/client-java) through some simple examples. For more details, please visit [TiKV Java Client User Documents].

{{< info >}}
TiKV Java Client is developed and released using Java8. The minimum supported version of TiKV is 2.0.0.
{{< /info >}}

## Add the dependency

To start, open the `pom.xml` of your project, and add the `tikv-client-java` as dependencies if you are using Maven.

```xml
<dependency>
  <groupId>org.tikv</groupId>
  <artifactId>tikv-client-java</artifactId>
  <version>3.2.0</version>
</dependency>
```

## Try the transactional key-value API

Below is the basic usages of `TxnKV`. Data should be written into TxnKV using [`TwoPhaseCommitter`](), and be read using [`org.tikv.txn.KVClient`]().

```java
import java.util.Arrays;
import java.util.List;

import org.tikv.common.BytePairWrapper;
import org.tikv.common.ByteWrapper;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.common.util.BackOffer;
import org.tikv.common.util.ConcreteBackOffer;
import org.tikv.kvproto.Kvrpcpb.KvPair;
import org.tikv.shade.com.google.protobuf.ByteString;
import org.tikv.txn.KVClient;
import org.tikv.txn.TwoPhaseCommitter;

public class App {
    public static void main(String[] args) throws Exception {
        TiConfiguration conf = TiConfiguration.createDefault("127.0.0.1:2379");
        try (TiSession session = TiSession.create(conf)) {
            // two-phase write
            long startTS = session.getTimestamp().getVersion();
            try (TwoPhaseCommitter twoPhaseCommitter = new TwoPhaseCommitter(session, startTS)) {
                BackOffer backOffer = ConcreteBackOffer.newCustomBackOff(1000);
                byte[] primaryKey = "key1".getBytes("UTF-8");
                byte[] key2 = "key2".getBytes("UTF-8");

                // first phase: prewrite
                twoPhaseCommitter.prewritePrimaryKey(backOffer, primaryKey, "val1".getBytes("UTF-8"));
                List<BytePairWrapper> pairs = Arrays
                        .asList(new BytePairWrapper(key2, "val2".getBytes("UTF-8")));
                twoPhaseCommitter.prewriteSecondaryKeys(primaryKey, pairs.iterator(), 1000);

                // second phase: commit
                long commitTS = session.getTimestamp().getVersion();
                twoPhaseCommitter.commitPrimaryKey(backOffer, primaryKey, commitTS);
                List<ByteWrapper> keys = Arrays.asList(new ByteWrapper(key2));
                twoPhaseCommitter.commitSecondaryKeys(keys.iterator(), commitTS, 1000);
            }

            try (KVClient kvClient = session.createKVClient()) {
                long version = session.getTimestamp().getVersion();
                ByteString key1 = ByteString.copyFromUtf8("key1");
                ByteString key2 = ByteString.copyFromUtf8("key2");

                // get value of a single key
                ByteString val = kvClient.get(key1, version);
                System.out.println(val);

                // get value of multiple keys
                BackOffer backOffer = ConcreteBackOffer.newCustomBackOff(1000);
                List<KvPair> kvPairs = kvClient.batchGet(backOffer, Arrays.asList(key1, key2), version);
                System.out.println(kvPairs);

                // get value of a range of keys
                kvPairs = kvClient.scan(key1, ByteString.copyFromUtf8("key3"), version);
                System.out.println(kvPairs);
            }
        }
    }
}
```

## Try the Raw key-value API

Below is the basic usages of `RawKV`.

```java
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.kvproto.Kvrpcpb;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

public class Main {
  public static void main(String[] args) throws Exception {
    // You MUST create a raw configuration if you are using RawKVClient.
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
    List<Kvrpcpb.KvPair> list = client.batchGet(new ArrayList<ByteString>() {{
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
  }
}
```

[TiKV Java Client User Documents]: https://tikv.github.io/client-java/introduction/introduction.html
