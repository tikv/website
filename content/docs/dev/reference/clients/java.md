---
title: Java Client
description: Interact with TiKV using Java.
menu:
    "dev":
        parent: Clients
        weight: 3
---

This document, like our Java API, is still a work in progress. In the meantime, you can track development at [tikv/client-java](https://github.com/tikv/client-java/) repository.

{{< warning >}}
You should not use the Java client for production use until it is released.
{{< /warning >}}

## Parse SST file

```java
import java.io.File;
import java.util.Iterator;
import java.util.List;

import org.tikv.br.BackupDecoder;
import org.tikv.br.BackupMetaDecoder;
import org.tikv.br.SSTDecoder;
import org.tikv.common.util.Pair;

BackupMetaDecoder metaDecoder = BackupMetaDecoder.parse("/path/to/sst/backupmeta");
BackupDecoder sstBackup = new BackupDecoder(metaDecoder.getBackupMeta());
File folder = new File("/path/to/sst");
File[] listOfFiles = folder.listFiles();

for (File file : listOfFiles) {
    if (file.getName().endsWith("sst")) {
        SSTDecoder decoder = sstBackup.decodeSST(file.getAbsolutePath());
        Iterator<Pair<ByteString, ByteString>> iter = decoder.getIterator();
        // Do something with iter
    }
}
```

