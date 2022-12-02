---
title: RawKV CDC 使用手册
description: 如何使用 RawKV Change Data Capture
menu:
    "dev":
        parent: RawKV CDC-dev
        weight: 1
        identifier: RawKV CDC CN-dev
---

本文是 RawKV CDC 的使用手册。

## RawKV CDC 使用手册

### 部署

{{< info >}}
支持 RawKV CDC 的最小 TiKV 版本为 [v6.2.0](https://docs.pingcap.com/zh/tidb/v6.2/release-6.2.0)，并打开 [TiKV API V2](../../api-v2)
{{< /info >}}

#### 使用 TiUP 部署

{{< info >}}
支持 TiKV-CDC 的最小 TiUP 版本为 v1.11.0
{{< /info >}}

##### 使用 TiUP 部署包含 TiKV-CDC 组件的全新 TiKV 集群

在使用 [TiUP] 部署全新的 TiKV 集群时，支持同时部署 TiKV-CDC 组件。只需在 TiUP 的拓扑配置中加入 TiKV-CDC 部分即可。可参考[模板](https://github.com/tikv/migration/blob/main/cdc/deployments/tikv-cdc/config-templates/topology.example.yaml)。

##### 使用 TiUP 在现有 TiKV 集群上新增 TiKV-CDC 组件

目前也支持在现有的 TiKV 集群上使用 TiUP 新增 TiKV-CDC 组件，操作步骤如下：

1. 确认当前 TiKV 集群的版本 >= v6.2.0，并且已打开 [TiKV API V2]。
2. 根据[模板](https://github.com/tikv/migration/blob/main/cdc/deployments/tikv-cdc/config-templates/scale-out.example.yaml)创建扩容配置文件。
3. 通过 `tiup cluster scale-out` 扩容 TiKV-CDC 组件（TiUP 扩容可参考 [使用 TiUP 扩容缩容 TiDB 集群]）。
```bash
tiup cluster scale-out <cluster-name> scale-out.yaml
```

#### 手工部署

1. 部署两个 TiKV 集群，分别作为上游集群和下游集群。
2. 启动 TiKV-CDC 集群，可包含一个或多个 TiKV-CDC server。TiKV-CDC server 的启动命令是 `tikv-cdc server --pd <upstream PD endpoints>`。
3. 通过以下命令启动同步任务：`tikv-cdc cli changefeed create --pd <upstream PD endpoints> --sink-uri tikv://<downstream PD endpoints>`。

#### TiKV-CDC server 启动参数
* `addr`：TiKV-CDC 的监听地址，用于提供 HTTP API 和 Prometheus 查询，默认为 127.0.0.1:8600。
* `advertise-addr`：TiKV-CDC 供客户端访问的外部开放地址。如果未设置，默认与 `addr` 相同。
* `pd`：TiKV-CDC 监听的 PD 节点地址，多个地址用英文逗号（`,`）分隔。
* `config`：可选项，指定 TiKV-CDC 使用的配置文件路径。
* `data-dir`：可选项，指定 TiKV-CDC 存储运行时数据的目录，主要用于外部排序。建议确保该目录所在设备的可用空间大于等于 500 GiB。
* `gc-ttl`：可选项，TiKV-CDC 在 PD 设置服务级别 GC safepoint 的 TTL (Time To Live) 时长。同时也是 TiKV-CDC 同步任务暂停的最大时长。单位为秒，默认值为 86400，即 24 小时。注意：TiKV-CDC 同步任务的暂停会影响集群 GC safepoint 的推进。`gc-ttl` 越大，同步任务可以暂停的时间越长，但同时需要保留更多的过期数据、并占用更多的存储空间。反之亦然。
* `log-file`：可选项，TiKV-CDC 进程运行时日志的输出路径，未设置时默认为标准输出 (stdout)。
* `log-level`：可选项，TiKV-CDC 进程运行时的日志路径，默认为 info。
* `ca`：可选项，指定用于 TLS 连接的 CA 证书文件路径。仅支持 PEM 格式。
* `cert`：可选项，指定用于 TLS 连接的证书文件路径。仅支持 PEM 格式。
* `key`：可选项，指定用于 TLS 连接的私钥文件路径。仅支持 PEM 格式。
* `cert-allowed-cn`：可选项，指定允许的调用者标识（即证书 Common Name，CN）。多个 CN 用英文逗号（`,`）分隔。

### 运维管理

#### 必备条件

运维管理需要使用 **tikv-cdc** 二进制可执行文件。Linux x86-64 下的二进制可执行文件可以通过 TiUP 获取（如下所示），或者从 [releases](https://github.com/tikv/migration/releases) 页面下载。其他平台需要从[源代码](https://github.com/tikv/migration/tree/main/cdc)编译。

```bash
tiup install tikv-cdc
tiup tikv-cdc cli --help
```

#### 管理 TiKV-CDC 服务进程 (`capture`)

##### 查询 `capture` 列表
```bash
tikv-cdc cli capture list --pd=http://192.168.100.122:2379
```
```bash
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

在以上结果中：

* `id`：服务进程的 ID。
* `is-owner`：表示该服务进程是否为 owner 节点。
* `address`：该服务进程对外提供接口的地址。

如果要求使用 TLS 连接：
```bash
tikv-cdc cli capture list --pd=http://192.168.100.122:2379 --ca=$TLS_DIR/ca.pem --cert=$TLS_DIR/client.pem --key=$TLS_DIR/client-key.pem
```

在以上命令中：
* `ca`：指定 CA 证书文件路径。仅支持 PEM 格式。
* `cert`：指定证书文件路径。仅支持 PEM 格式。
* `key`：指定私钥文件路径。仅支持 PEM 格式。

#### 管理同步任务 (`changefeed`)

##### 创建同步任务
```bash
tikv-cdc cli changefeed create --pd=http://192.168.100.122:2379 --sink-uri="tikv://192.168.100.61:2379/" --changefeed-id="rawkv-replication-task"
```
```bash
Create changefeed successfully!
ID: rawkv-replication-task
Info: {"sink-uri":"tikv://192.168.100.61:2379","opts":{},"create-time":"2022-07-20T15:35:47.860947953+08:00","start-ts":434714063103852547,"target-ts":0,"admin-job-type":0,"sort-engine":"unified","sort-dir":"","scheduler":{"type":"keyspan-number","polling-time":-1},"state":"normal","history":null,"error":null}
```

在以上命令和结果中：

* `--changefeed-id`：同步任务的 ID，格式需要符合正则表达式 `^[a-zA-Z0-9]+(\-[a-zA-Z0-9]+)*$`。如果不指定该 ID，TiKV-CDC 会自动生成一个 UUID（version 4 格式）作为 ID。

* `--sink-uri`：同步任务下游的地址，需要按照以下格式进行配置。目前 scheme 仅支持 `tikv`。此外，如果 URI 中包含特殊字符，需要以 URL 编码对特殊字符进行处理。

```
[scheme]://[userinfo@][host]:[port][/path]?[query_parameters]
```

* `--start-ts`：指定 changefeed 的开始 TSO。TiKV-CDC 集群将从这个 TSO 开始拉取数据。默认为当前时间。

{{< info >}}
如果需要将现有集群中的存量数据同步到下游，请参考 [如何同步 TiKV 集群中的存量数据](#如何同步现有-tikv-集群中的存量数据)。
{{< /info >}}

##### Sink URI 配置 `tikv`
```bash
--sink-uri="tikv://192.168.100.61:2379/"
```
| 参数                       | 说明                                    |
|---------------------------|-----------------------------------------|
| 192.168.100.61:2379       | 下游 PD 地址。多个地址用英文逗号（`,`）分隔。 |

如果要求使用 TLS 连接：
```bash
--sink-uri="tikv://192.168.100.61:2379/?ca-path=$TLS_DIR/ca.pem&cert-path=$TLS_DIR/client.pem&key-path=$TLS_DIR/client-key.pem"
```
| 参数                       | 说明                                    |
|---------------------------|----------------------------------------|
| 192.168.100.61:2379       | 下游 PD 地址。多个地址用英文逗号（`,`）分隔。 |
| ca-path                   | CA 证书文件路径，仅支持 PEM 格式。          |
| cert-path                 | 证书文件路径，仅支持 PEM 格式。             |
| key-path                  | 私钥文件路径，仅支持 PEM 格式               |

##### 查询同步任务列表
```bash
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```bash
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

在以上结果中：

* `checkpoint` 表示 TiKV-CDC 已经将该时间点前的数据同步到了下游。
* `state` 为该同步任务的状态：
  * `normal`：正常同步
  * `stopped`：停止同步（手动暂停）
  * `error`：停止同步（出错）
  * `removed`：已删除任务（只在指定 --all 选项时才会显示该状态的任务）


##### 查询特定同步任务
```bash
tikv-cdc cli changefeed query -s --changefeed-id rawkv-replication-task --pd=http://192.168.100.122:2379
```
```bash
{
 "state": "normal",
 "tso": 434716089136185435,
 "checkpoint": "2022-07-20 17:44:36.551",
 "error": null
}
```

在以上命令和结果中：

* `-s` 代表仅返回简化后的同步状态。
* `state` 代表当前 changefeed 的同步状态，与 changefeed list 中的状态相同。
* `tso` 代表当前 changefeed 中已经成功写入下游的最大 TSO。
* `checkpoint` 代表当前 changefeed 中已经成功写入下游的最大 TSO 对应的时间。
* `error` 记录当前 changefeed 是否有错误发生。


```bash
tikv-cdc cli changefeed query --changefeed-id rawkv-replication-task --pd=http://192.168.100.122:2379
```
```bash
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

在以上结果中：

* `info`：代表当前 changefeed 的同步配置。
* `status`：代表当前 changefeed 的同步状态信息。
* `resolved-ts`：代表当前 changefeed 从上游 TiKV 接收到的最大水位线（watermark）。**水位线**是一个时间戳，表示所有早于这个时间戳的 RawKV 数据，都已经从上游 TiKV 接收到了。
* `checkpoint-ts`：代表当前 changefeed 中已经成功写入下游的最大水位线（watermark）。这个**水位线**表示所有早于这个时间戳的 RawKV 数据，都已经成功写入下游 TiKV。
* `admin-job-type`：代表当前 changefeed 的状态：
  * `0`：状态正常。
  * `1`：任务暂停，停止任务后所有同步 processor 会结束退出，同步任务的配置和同步状态都会保留，可以从 checkpoint-ts 恢复任务。
  * `2`：任务恢复，同步任务从 checkpoint-ts 继续同步。
  * `3`：任务已删除，所有同步 processor 结束退出，并清理同步任务配置信息。同步状态保留，只提供查询，没有其他实际功能。
* `task-status` 代表当前 changefeed 所分配的各个同步子任务的状态信息。


##### 停止同步任务
```bash
tikv-cdc cli changefeed pause --changefeed-id rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```bash
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

在以上命令中：

* `--changefeed-id=uuid` 为需要操作的 `changefeed` ID。


##### 恢复同步任务
```bash
tikv-cdc cli changefeed resume --changefeed-id rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```bash
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

##### 删除同步任务
```bash
tikv-cdc cli changefeed remove --changefeed-id rawkv-replication-task --pd=http://192.168.100.122:2379
tikv-cdc cli changefeed list --pd=http://192.168.100.122:2379
```
```bash
[]
```

#### 查询同步子任务处理单元 (processor)
```bash
tikv-cdc cli processor list --pd=http://192.168.100.122:2379`
```
```bash
[
  {
    "changefeed_id": "rawkv-replication-task",
    "capture_id": "07684765-52df-42a0-8dd1-a4e9084bb7c1"
  }
]
```

## 常见问题

### 如何同步现有 TiKV 集群中的存量数据

首先通过 [TiKV-BR] 将存量数据复制到下游（需要部署 [NFS]、[S3] 等网络共享存储），然后创建 changefeed 进行后续的增量数据同步。

不建议使用 TiKV-CDC 直接同步存量数据，原因包括：

- TiKV 集群垃圾回收的生命期（life time）较短（默认为 10 分钟），因此在大部分情况下，直接进行同步是不可行的。Changefeed 的 `start-ts` 不可小于 **GC Safe Point**。
- 如果存量数据较大，通过 TiKV-CDC 同步较为低效，因为所有的存量数据都需要首先拉取并暂存在 TiKV-CDC 中，然后按时间戳大小排序，才能最后写入下游集群。相比之下，TiKV-BR 可以充分利用整个 TiKV 集群的资源，因为在备份和恢复的过程中，每个 region 直接向共享存储导出或者导入数据，并且不需要排序。

同步存量数据的步骤：

1) 通过 TiKV-BR 备份上游集群数据，并指定足够长的 `--gcttl` 参数。参考 [备份 Raw 模式数据]。
> 注意：`--gcttl` 需要包括数据备份时长、数据恢复时长、以及其他准备工作的时长。如果无法预计这些时长，可以临时停止 GC（`SET GLOBAL tidb_gc_enable = "OFF";`，见 [tidb_gc_enable]），并在 changefeed 启动后恢复（`SET GLOBAL tidb_gc_enable = "ON";`）。

2) 记录步骤 1 备份结果中的 `backup-ts`。

3) 将备份数据恢复到下游集群。参考 [恢复 Raw 模式数据]。

4) 创建 changefeed，并指定 `--start-ts=<backup-ts>`。


[TiKV API V2]: ../../api-v2
[v6.2.0]: https://docs.pingcap.com/zh/tidb/v6.2/release-6.2.0
[TiUP]: https://docs.pingcap.com/zh/tidb/stable/production-deployment-using-tiup
[使用 TiUP 扩容缩容 TiDB 集群]: https://docs.pingcap.com/zh/tidb/stable/scale-tidb-using-tiup
[TiKV-BR]: ../../backup-restore-cn
[NFS]: https://en.wikipedia.org/wiki/Network_File_System
[S3]: https://aws.amazon.com/s3/
[备份 Raw 模式数据]: ../../backup-restore-cn/#%E5%A4%87%E4%BB%BD%E9%9B%86%E7%BE%A4-raw-%E6%A8%A1%E5%BC%8F%E6%95%B0%E6%8D%AE
[恢复 Raw 模式数据]: ../../backup-restore-cn/#%E6%81%A2%E5%A4%8D-raw-%E6%A8%A1%E5%BC%8F%E5%A4%87%E4%BB%BD%E6%95%B0%E6%8D%AE
[tidb_gc_enable]: https://docs.pingcap.com/zh/tidb/stable/system-variables#tidb_gc_enable-%E4%BB%8E-v50-%E7%89%88%E6%9C%AC%E5%BC%80%E5%A7%8B%E5%BC%95%E5%85%A5
