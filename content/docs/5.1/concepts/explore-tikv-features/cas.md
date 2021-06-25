---
title: CAS on RawKV
description: Compare And Swap
menu:
    "5.1":
        parent: Features
        weight: 4
---

This page walks you through a simple demonstration of performing compare-and-swap (CAS) in TiKV.

In RawKV, compare-and-swap (CAS) is an atomic instruction used in multithreading to achieve synchronization, which is the atomic equivalent of:

```
if get(key) == old_value {
	put(key, new_value);
	return true;
}
return false;
```

The atomicity guarantees that the new value is calculated based on up-to-date information; if the value had been updated by another thread in the meantime, the write would fail.

## Prerequisites

Please install TiUP, jshell, download tikv-client jars and start a TiKV Cluster according to [TiKV in 5 Minutes](../../tikv-in-5-minutes).

## Step 1: Write the code to test CAS

Let's write an example to verify that CAS works.

Save the following script to file `test_raw_cas.java`.

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
System.out.println("put key=" + key.toStringUtf8() + " value=" + value.toStringUtf8());

// get
Optional<ByteString> result = client.get(key);
assert(result.isPresent());
assert("CAS".equals(result.get().toStringUtf8()));
System.out.println("get key=" + key.toStringUtf8() + " result=" + result.get().toStringUtf8());

// cas
client.compareAndSet(key, Optional.of(value), newValue);
System.out.println("cas key=" + key.toStringUtf8() + " value=" + value.toStringUtf8() + " newValue=" + newValue.toStringUtf8());

// get
result = client.get(key);
assert(result.isPresent());
assert("NewValue".equals(result.get().toStringUtf8()));
System.out.println("get key=" + key.toStringUtf8() + " result=" + result.get().toStringUtf8());

// close
client.close();
session.close();
```

## Step 2: Run the code

```bash
jshell --class-path tikv-client-java.jar:slf4j-api.jar --startup test_raw_cas.java

put key=Hello value=CAS
get key=Hello result=CAS
cas key=Hello value=CAS newValue=NewValue
get key=Hello result=NewValue
```

As we can see, after calling `compareAndSet` the value `CAS` is replaced by `newValue`.

{{< warning >}}
Users must set `conf.setEnableAtomicForCAS(true)` to ensure linearizability of `compare_and_swap` when used together with `put`, `delete`, `batch_put`, or `batch_delete`.

To guarantee the atomicity of CAS, write operations like `put` or `delete` in atomic mode are more expensive.
{{< /warning >}}
