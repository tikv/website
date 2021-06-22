---
title: CAS
description: How to use RawKV's CAS API 
menu:
    "5.1":
        parent: RawKV
        weight: 3
---

This document walks you through how to use RawKV’s `CAS (Compare And Swap)` API.

In RawKV, compare-and-swap (CAS) is an atomic instruction used in multithreading to achieve synchronization, which is the atomic equivalent of:

```
if get(key) == old_value {
	put(key, new_value);
	return true;
}
return false;
```

The atomicity guarantees that the new value is calculated based on up-to-date information; if the value had been updated by another thread in the meantime, the write would fail.

## Java

The following example shows a simple example of how to use the `CAS` API in java.

```java
import java.util.Optional;
import org.tikv.common.TiConfiguration;
import org.tikv.common.TiSession;
import org.tikv.raw.RawKVClient;
import org.tikv.shade.com.google.protobuf.ByteString;

TiConfiguration conf = TiConfiguration.createRawDefault("127.0.0.1:2379");
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

The code example used in this chapter can be found [here](https://github.com/marsishandsome/tikv-client-examples/blob/main/java-example/src/main/java/example/rawkv/CAS.java).