---
title: RawKV CDC
description: How to use RawKV Change Data Capture
menu:
    "dev":
        parent: Features-dev
        weight: 8
        identifier: RawKV CDC-dev
---

This page introduces what's RawKV Change Data Capture and how to use it.

[中文使用手册]

## RawKV Change Data Capture

**RawKV Change Data Capture** (*abbr.* **RawKV CDC**) is a feature that providing [Change Data Capture] capability for RawKV, to meet high availability requirements.

Using RawKV CDC, you can build a storage system with **Cross Cluster Replication**, to implement financial-level disaster recovery.

RawKV CDC can also be used for integrating RawKV with other data systems.

To use RawKV CDC, you need to enable [TiKV API V2] and deploy a **TiKV-CDC** cluster. The minimal required version of TiKV is [v6.2.0].

{{< figure
    src="/img/docs/rawkv-cdc.png"
    caption="RawKV CDC"
    number="1" >}}

## TiKV-CDC

**TiKV-CDC** is [TiKV](https://docs.pingcap.com/tidb/dev/tikv-overview)'s change data capture framework. It supports replicating change data to another TiKV cluster.

It forks from [TiCDC](https://github.com/pingcap/tiflow/blob/master/README_TiCDC.md), but focus on NoSQL scenario that uses TiKV as a Key-Value storage.

{{< figure
    src="/img/docs/rawkv-cdc-arch-simple.png"
    caption="TiKV-CDC Architecture"
    number="2" >}}

## Instruction Manual

### Deployment

#### Deploy by TiUP

_Note: [TiUP] >= `v1.11.0` is required._

##### Deploy a new TiDB/TiKV cluster including TiKV-CDC

When you deploy a new TiDB/TiKV cluster using TiUP, you can also deploy TiKV-CDC at the same time. You only need to add the `kvcdc_servers` section in the initialization configuration file that TiUP uses to start the TiDB/TiKV cluster. Please refer to the configuration [template](https://github.com/tikv/migration/blob/main/cdc/deployments/tikv-cdc/config-templates/topology.example.yaml).

##### Add TiKV-CDC to an existing TiDB/TiKV cluster

You can also use TiUP to add the TiKV-CDC component to an existing TiDB/TiKV cluster. Take the following procedures:

1. Make sure that the current TiDB/TiKV version >= `6.2.0` and [TiKV API V2] is enabled.
2. Prepare a scale-out configuration file, refer to [template](https://github.com/tikv/migration/blob/main/cdc/deployments/tikv-cdc/config-templates/scale-out.example.yaml).
3. Scale out by `tiup cluster scale-out`. Also refer to [Scale a TiDB Cluster Using TiUP](https://docs.pingcap.com/tidb/stable/scale-tidb-using-tiup).
```
tiup cluster scale-out <cluster-name> scale-out.yaml
```

#### Deploy manually

1. Set up two TiKV clusters, one for upstream and another for downstream.
2. Start a TiKV-CDC cluster, which contains one or more TiKV-CDC servers. The command to start on TiKV-CDC server is `tikv-cdc server --pd <upstream PD endpoints>`.
3. Start a replication changefeed by `tikv-cdc cli changefeed create --pd <upstream PD endpoints> --sink-uri tikv://<downstream PD endpoints>`

#### Arguments for starting TiKV-CDC server
* `addr`: The listening address of TiKV-CDC, the HTTP API address, and the Prometheus address of the TiKV-CDC service. The default value is 127.0.0.1:8600.
* `advertise-addr`: The advertised address via which clients access TiKV-CDC. If unspecified, the value is the same as `addr`.
* `pd`: A comma-separated list of PD endpoints.
* `config`: The address of the configuration file that TiKV-CDC uses (optional).
* `data-dir`: Specifies the directory that TiKV-CDC uses to store temporary files for sorting. It is recommended to ensure that the free disk space for this directory is greater than or equal to 500 GiB (optional).
* `gc-ttl`: The TTL (Time To Live, in seconds) of the service level `GC safepoint` in PD set by TiKV-CDC (optional). It's the duration that replication tasks can suspend, defaults to 86400, i.e. 24 hours. Note that suspending of replication task will affect the progress of TiKV garbage collection. The longer of `gc-ttl`, the longer a changefeed can be paused, but at the same time more obsolete data will be kept and larger space will be occupied. Vice versa.
* `log-file`: The path to which logs are output when the TiKV-CDC process is running (optional). If this parameter is not specified, logs are written to the standard output (stdout).
* `log-level`: The log level when the TiKV-CDC process is running (optional). The default value is "info".
* `ca`: The path of the CA certificate file in PEM format for TLS connection (optional).
* `cert`: The path of the certificate file in PEM format for TLS connection (optional).
* `key`: The path of the private key file in PEM format for TLS connection (optional).
* `cert-allowed-cn`: Specifies to verify caller's identity (certificate Common Name, optional). Use comma to separate multiple CN.

### Maintenance

#### Manage TiKV-CDC service (`capture`)

##### Query the `capture` list
```
tikv-cdc cli capture list --pd=http://192.168.100.122:2379
```
```
[
  {
    "id": "07684765-52df-42a0-8dd1-a4e9084bb7c1",
    "is-owner": false,
    "address": "192.168.100.9:8600"
  },
  {
    "id": "aea1445b-c065-4dc5-be53-a445261f7fc2",
    "is-owner": true,
    "address": "192.168.100.26:8600"
  },
  {
    "id": "f29496df-f6b4-4c1e-bfa3-41a058ce2144",
    "is-owner": false,
    "address": "192.168.100.142:8600"
  }
]
```

In the result above:

* `id`: The ID of the service process.
* `is-owner`: Indicates whether the service process is the owner node.
* `address`: The address to access to.

If TLS is required:
```
tikv-cdc cli capture list --pd=http://192.168.100.122:2379 --ca=$TLS_DIR/ca.pem --cert=$TLS_DIR/client.pem --key=$TLS_DIR/client-key.pem
```

In the command above:
* `ca`: Specifies the path of the CA certificate file in PEM format for TLS connection.
* `cert`: Specifies the path of the certificate file in PEM format for TLS connection.
* `key`: Specifies the path of the private key file in PEM format for TLS connection.

#### Manage Replication Tasks (`changefeed`)

##### Create a replication task
```
tikv-cdc cli changefeed create --pd=http://192.168.100.122:2379 --sink-uri="tikv://192.168.100.61:2379/" --changefeed-id="rawkv-replication-task" --start-ts=434716089136185435
```
```
Create changefeed successfully!
ID: rawkv-replication-task
Info: {"sink-uri":"tikv://192.168.100.61:2379","opts":{},"create-time":"2022-07-20T15:35:47.860947953+08:00","start-ts":434714063103852547,"target-ts":0,"admin-job-type":0,"sort-engine":"unified","sort-dir":"","scheduler":{"type":"keyspan-number","polling-time":-1},"state":"normal","history":null,"error":null}
```

In the command and result above:

* `--changefeed-id`: The ID of the replication task. The format must match the `^[a-zA-Z0-9]+(\-[a-zA-Z0-9]+)*$` regular expression. If this ID is not specified, TiKV-CDC automatically generates a UUID (the version 4 format) as the ID.

* `--sink-uri`: The downstream address of the replication task. Configure `--sink-uri` according to the following format. Currently, the scheme supports `tikv` only. Besides, when a URI contains special characters, you need to process these special characters using URL encoding.

```
[scheme]://[userinfo@][host]:[port][/path]?[query_parameters]
```

* `--start-ts`: Specifies the starting TSO of the changefeed. TiKV-CDC will replicate RawKV entries starting from this TSO. The default value is the current time.

> Refer to [How to replicate TiKV cluster with existing data](#how-to-replicate-tikv-cluster-with-existing-data) if the replication is deployed on a existing cluster.

##### Configure sink URI with `tikv`
```
--sink-uri="tikv://192.168.100.61:2379/"
```
| Parameter/Parameter Value | Description                                                                    |
|---------------------------|--------------------------------------------------------------------------------|
| 192.168.100.61:2379       | The endpoints of the downstream PD. Multiple addresses are separated by comma. |

If TLS is required:
```
--sink-uri="tikv://192.168.100.61:2379/?ca-path=$TLS_DIR/ca.pem&cert-path=$TLS_DIR/client.pem&key-path=$TLS_DIR/client-key.pem"
```
| Parameter/Parameter Value | Description                                                                    |
|---------------------------|--------------------------------------------------------------------------------|
| 192.168.100.61:2379       | The endpoints of the downstream PD. Multiple addresses are separated by comma. |
| ca-path                   | The path of the CA certificate file in PEM format.                             |
| cert-path                 | The path of the certificate file in PEM format.                                |
| key-path                  | The path of the private key file in PEM format.                                |

##### Query the replication task list
```
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```
[
  {
    "id": "rawkv-replication-task",
    "summary": {
      "state": "normal",
      "tso": 434715745556889877,
      "checkpoint": "2022-07-20 17:22:45.900",
      "error": null
    }
  }
]
```

In the result above:

* `checkpoint` indicates that TiKV-CDC has already replicated data before this time point to the downstream.
* `state` indicates the state of the replication task.
  * `normal`: The replication task runs normally.
  * `stopped`: The replication task is stopped (manually paused).
  * `error`: The replication task is stopped (by an error).
  * `removed`: The replication task is removed. Tasks of this state are displayed only when you have specified the `--all` option. To see these tasks when this option is not specified, execute the `changefeed query` command.


##### Query a specific replication task
```
tikv-cdc cli changefeed query -s --changefeed-id=rawkv-replication-task --pd=http://192.168.100.122:2379
```
```
{
 "state": "normal",
 "tso": 434716089136185435,
 "checkpoint": "2022-07-20 17:44:36.551",
 "error": null
}
```

In the command and result above:

* `-s` shows simplified result.
* `state` is the replication state of the current changefeed. Each state must be consistent with the state in changefeed list.
* `tso` represents the largest TSO in the current changefeed that has been successfully replicated to the downstream.
* `checkpoint` represents the corresponding time of the largest TSO in the current changefeed that has been successfully replicated to the downstream.
* `error` records whether an error has occurred in the current changefeed.


```
tikv-cdc cli changefeed query --changefeed-id=rawkv-replication-task --pd=http://192.168.100.122:2379
```
```
{
  "info": {
    "sink-uri": "tikv://192.168.100.61:2379/",
    "opts": {},
    "create-time": "2022-07-20T17:21:54.115625346+08:00",
    "start-ts": 434715731964985345,
    "target-ts": 0,
    "admin-job-type": 0,
    "sort-engine": "unified",
    "sort-dir": "",
    "config": {
      "check-gc-safe-point": true,
      "scheduler": {
        "type": "keyspan-number",
        "polling-time": -1
      },
    },
    "state": "normal",
    "history": null,
    "error": null,
    "sync-point-enabled": false,
    "sync-point-interval": 600000000000,
  },
  "status": {
    "resolved-ts": 434715754364928912,
    "checkpoint-ts": 434715754103047044,
    "admin-job-type": 0
  },
  "count": 0,
  "task-status": [
    {
      "capture-id": "aea1445b-c065-4dc5-be53-a445261f7fc2",
      "status": {
        "keyspans": {
          "15137828009456710810": {
            "start-ts": 434715731964985345,
            "Start": "cg==",
            "End": "cw=="
          }
        },
        "operation": {},
        "admin-job-type": 0
      }
    }
  ]
}
```

In the result above:

* `info` is the replication configuration of the queried changefeed.
* `status` is the replication state of the queried changefeed.
* `resolved-ts`: The largest watermark received from upstream in the current changefeed. The **watermark** is a timestamp indicating that all RawKV entries earlier than it have been received.
* `checkpoint-ts`: The largest watermark written to downstream successfully in the current changefeed.
* `admin-job-type`: The status of a changefeed:
  * `0`: The state is normal.
  * `1`: The task is paused. When the task is paused, all replicated processors exit. The configuration and the replication status of the task are retained, so you can resume the task from `checkpoint-ts`.
  * `2`: The task is resumed. The replication task resumes from `checkpoint-ts`.
  * `3`: The task is removed. When the task is removed, all replicated processors are ended, and the configuration information of the replication task is cleared up. Only the replication status is retained for later queries.
* `task-status` indicates the state of each replication sub-task in the queried changefeed.


##### Pause a replication task
```
tikv-cdc cli changefeed pause --changefeed-id=rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```
[
  {
    "id": "rawkv-replication-task",
    "summary": {
      "state": "stopped",
      "tso": 434715759083521004,
      "checkpoint": "2022-07-20 17:23:37.500",
      "error": null
    }
  }
]
```

In the command above:

* `--changefeed-id=uuid` represents the ID of the changefeed that corresponds to the replication task you want to pause.


##### Resume a replication task
```
tikv-cdc cli changefeed resume --changefeed-id=rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```
[
  {
    "id": "rawkv-replication-task",
    "summary": {
      "state": "normal",
      "tso": 434715759083521004,
      "checkpoint": "2022-07-20 17:23:37.500",
      "error": null
    }
  }
]
```

##### Remove a replication task
```
tikv-cdc cli changefeed remove --changefeed-id=rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```
[]
```

#### Query processing units of replication sub-tasks (processor)
```
tikv-cdc cli processor list --pd=http://192.168.100.122:2379`
```
```
[
  {
    "changefeed_id": "rawkv-replication-task",
    "capture_id": "07684765-52df-42a0-8dd1-a4e9084bb7c1"
  }
]
```

## FAQs

### How to replicate TiKV cluster with existing data

Use [TiKV-BR] to migrate the existing data to downstream cluster (network shared storage, e.g. [NFS] or [S3], is required). Then start the changefeed for incremental replication.

We don't recommend replicating existing data by TiKV-CDC because:

- First, as life time of garbage collection is short (defaults to `10` minutes), in most circumstance it's not applicable to perform the replication. You can not create a changefeed with `start-ts` earlier than **GC Safe Point**.
- Second, if there are mass existing data, replication by TiKV-CDC is inefficiency, as all existing data must be gathered, hold, and sorted in TiKV-CDC, before finally write to downstream. By contrast, TiKV-BR can utilize the power of the whole cluster, as all regions are directly exported to and imported from the shared storage.

To replicate TiKV cluster with existing data:

1) Backup upstream cluster by TiKV-BR, with a long enough `--gcttl`. See [Backup Raw Data] for more details.
> NOTE: value of `gcttl` should include duration of backup, restoration, and other preparation work. If you are not sure about the value of `gcttl`, you can [disable GC] temporarily, and enable it after changefeed has started.
2) Record `backup-ts` from backup result in *Step 1*.
3) Restore to downstream cluster. Refer to [Restore Raw Data].
4) Create changefeed with `--start-ts=<backup-ts>`.


[Change Data Capture]: https://en.wikipedia.org/wiki/Change_data_capture
[TiKV API V2]: ../api-v2
[v6.2.0]: https://docs.pingcap.com/tidb/v6.2/release-6.2.0
[TiUP]: https://tiup.io
[TiKV-BR]: ../backup-restore
[NFS]: https://en.wikipedia.org/wiki/Network_File_System
[S3]: https://aws.amazon.com/s3/
[Backup Raw Data]: ../backup-restore/#backup-raw-data
[Restore Raw Data]: ../backup-restore/#restore-raw-data
[Disable GC]: https://docs.pingcap.com/tidb/stable/system-variables#tidb_gc_enable-new-in-v50
[中文使用手册]: ../cdc-cn
