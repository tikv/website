---
title: CAS
description: How to use RawKV's CAS API 
menu:
    "6.1":
        parent: RawKV-v6.1
        weight: 3
        identifier: CAS-v6.1
---

This document walks you through how to use RawKV’s `CAS (Compare And Swap)` API.

In RawKV, compare-and-swap (CAS) is an atomic operation used to avoid data racing in concurrent write requests, which is atomically equivalent to:

```
prevValue = get(key);
if (prevValue == request.prevValue) {
    put(key, request.value);
}
return prevValue;
```

The atomicity guarantees that the new value is calculated based on up-to-date information. If the value had been updated by another thread at the same time, the write would fail.

{{< warning >}}
Normally, CAS can prevent problems from the concurrent access, but suffers from the [ABA problem](https://en.wikipedia.org/wiki/ABA_problem).
{{</ warning >}}

## Java

The following example shows how to use `CAS` API in Java.

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
ByteString value = ByteString.copyFromUtf8("CAS");
ByteString newValue = ByteString.copyFromUtf8("NewValue");

// put
client.put(key, value);

// get
Optional<ByteString> result = client.get(key);
assert(result.isPresent());
assert("CAS".equals(result.get().toStringUtf8()));
System.out.println(result.get().toStringUtf8());

// cas
client.compareAndSet(key, Optional.of(value), newValue);

// get
result = client.get(key);
assert(result.isPresent());
assert("NewValue".equals(result.get().toStringUtf8()));
System.out.println(result.get().toStringUtf8());

// close
client.close();
session.close();
```

{{< warning >}}
You must set `conf.setEnableAtomicForCAS(true)` to ensure linearizability of `CAS` when using with `put`, `delete`, `batch_put`, or `batch_delete`.

To guarantee the atomicity of CAS, write operations like `put` or `delete` in atomic mode are more expensive.
{{< /warning >}}

The code example used in this chapter can be found [here](https://github.com/marsishandsome/tikv-client-examples/blob/main/java-example/src/main/java/example/rawkv/CAS.java).
