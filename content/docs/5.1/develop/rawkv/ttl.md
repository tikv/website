---
title: TTL
description: How to use TTL via RawKV API.
menu:
    "5.1":
        parent: RawKV
        weight: 4
---

Time To Live (TTL) is ... TiKV provides the TTL support via the RawKV API. <!-- Please provide a short introduction of TTL or RawKV's TTL API. What is it? In what situations users might need to use it?  -->

This document provides two examples to show you how to set TTL via the RawKV API.

## Enable TTL

Before you set TTL via RawKV API, you must enable TTL in your TiKV cluster.

TTL is disabled by default. To enable it, set the following TiKV configuration to `true`.

```yaml
[storage]
enable-ttl = true
```

## Use TTL in Java client

After TTL is enabled in TiKV, you can set it in Java client via the `put` API or `CAS` API. The following two examples show how to set TTL via the `put` API and `CAS` API.

### Set TTL in the `put` API

In the following examples, these operations are performed:

1. Two key-value pairs, `(k1, v1)` and `(k2, v2)`, are written into TiKV via the `put` API. `(k1, v1)` is written with a TTL of 10 seconds. `(k2, v2)` is written without TTL.
2. Try to read `k1` and `k2` from TiKV. Both values are returned.
3. Let TiKV sleep for 10 seconds, which is the time of TTL.
4. Try to read `k1` and `k2` from TiKV. `v2` is returned, but `v1` is not returned because the TTL has expired.

```java
import java.util.Optional;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

// Writes the (k1, v1) into TiKV with a TTL of 10 seconds.
client.put(ByteString.copyFromUtf8("k1"), ByteString.copyFromUtf8("v1"), 10);

// Writes the (k2, v2) into TiKV without TTL.
client.put(ByteString.copyFromUtf8("k2"), ByteString.copyFromUtf8("v2"));

// Reads k1 from TiKV. v1 is returned.
Optional<ByteString> result1 = client.get(ByteString.copyFromUtf8("k1"));
assert(result1.isPresent());
assert("v1".equals(result1.get().toStringUtf8()));
System.out.println(result1.get().toStringUtf8());

// Reads k2 from TiKV. v2 is returned.
Optional<ByteString> result2 = client.get(ByteString.copyFromUtf8("k2"));
assert(result2.isPresent());
assert("v2".equals(result2.get().toStringUtf8()));
System.out.println(result2.get().toStringUtf8());

// Let TiKV sleep for 10 seconds.
System.out.println("Sleep 10 seconds.");
Thread.sleep(10000);

// Reads k1 from TiKV. NULL is returned, because k1's TTL has expired.
result1 = client.get(ByteString.copyFromUtf8("k1"));
assert(!result1.isPresent());

// Reads k2 from TiKV. v2 is returned.
result2 = client.get(ByteString.copyFromUtf8("k2"));
assert(result2.isPresent());
assert("v2".equals(result2.get().toStringUtf8()));
System.out.println(result2.get().toStringUtf8());

// Close
client.close();
session.close();
```

## Set TTL in the `CAS` API

You can also set TTL via the `CAS` API. See the following example:

```java
import java.util.Optional;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
// enable AtomicForCAS when using RawKVClient.compareAndSet or RawKVClient.putIfAbsent
conf.setEnableAtomicForCAS(true);
TiSession session = TiSession.create(conf);
RawKVClient client = session.createRawClient();

ByteString key = ByteString.copyFromUtf8("Hello");
ByteString value = ByteString.copyFromUtf8("CAS+TTL");
ByteString newValue = ByteString.copyFromUtf8("NewValue");

// put
client.put(key, value);

// cas with ttl = 10 seconds
client.compareAndSet(key, Optional.of(value), newValue, 10);

// get
Optional<ByteString> result = client.get(key);
assert(result.isPresent());
assert("NewValue".equals(result.get().toStringUtf8()));
System.out.println(result.get().toStringUtf8());

// sleep 10 seconds
System.out.println("Sleep 10 seconds.");
Thread.sleep(10000);

// get
result = client.get(key);
assert(!result.isPresent());

// close
client.close();
session.close();
```

The example code above is available [here](https://github.com/marsishandsome/tikv-client-examples/blob/main/java-example/src/main/java/example/rawkv/TTL.java).
