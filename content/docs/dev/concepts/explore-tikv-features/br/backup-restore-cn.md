---
title: RawKV BR 使用手册
description: 如何使用 RawKV BR
menu:
    "dev":
        parent: RawKV BR-dev
        weight: 1
        identifier: RawKV BR CN-dev
---

本文是 RawKV BR 的使用手册。


**[TiKV Backup & Restore (TiKV-BR)]** 是 TiKV 分布式备份恢复的命令行工具，用于对 TiKV 集群进行数据备份和恢复。 

## 工作原理
TiKV-BR 将备份或恢复操作命令下发到各个 TiKV 节点。TiKV 收到命令后执行相应的备份或恢复操作。 在一次备份或恢复中，各个 TiKV 节点都会有一个对应的备份路径，TiKV 备份时产生的备份文件将会保存在该路径下，恢复时也会从该路径读取相应的备份文件。  
{{< figure
    src="/img/docs/tikv-br.png"
    caption="TiKV-BR 工作原理"
    number="1" >}}


### 推荐部署配置
- 生产环境中，推荐 TiKV-BR 运行在（4 核+/8 GB+）的节点上。操作系统版本要求可参考 [操作系统及平台的要求]。
- 推荐使用 Amazon s3 存储 或者 SSD 网盘，挂载到 TiKV-BR 节点和所有 TiKV 节点上，网盘推荐万兆网卡，否则带宽有可能成为备份恢复时的性能瓶颈。
- TiKV-BR 只支持版本大于 v5.0.0 的 TiKV 集群中 RawKV 模式数据的备份和恢复。
- 建议为备份和恢复配置足够的资源：
    - TiKV-BR、TiKV 节点和备份存储系统需要提供大于备份速度的的网络带宽。当集群特别大的时候，备份和恢复速度上限受限于备份网络的带宽。
    - 备份存储系统还需要提供足够的写入/读取性能（IOPS），否则它有可能成为备份恢复时的性能瓶颈。
    - TiKV 节点需要为备份准备至少额外的两个 CPU core 和高性能的磁盘，否则备份将对集群上运行的业务产生影响。

### 最佳实践
下面是使用 TiKV-BR 进行备份恢复的几种推荐操作：  
- 推荐在业务低峰时执行备份操作，这样能最大程度地减少对业务的影响。
- TiKV-BR 支持在不同拓扑的集群上执行恢复，但恢复期间对在线业务影响很大，建议低峰期或者限速 (rate-limit) 执行恢复。
- TiKV-BR 备份最好串行执行。不同备份任务并行会导致备份性能降低，同时也会影响在线业务。
- TiKV-BR 恢复最好串行执行。不同恢复任务并行会导致 Region 冲突增多，恢复的性能降低。
- 可以通过指定 `--checksum=true`，在备份、恢复完成后进行一轮数据校验。数据校验将分别计算备份数据与 TiKV 集群中数据的 checksum，并对比二者是否相同。请注意，如果需要进行数据校验，请确保在备份或恢复的全过程，TiKV 集群没有数据变更和 TTL 过期。
- TiKV-BR 可用于实现 [`api-version`] 从 V1 到 V2 的集群数据迁移。通过指定 `--dst-api-version V2` 将 `api-version=1` 的 TiKV 集群备份为 V2 格式，然后将备份文件恢复到新的 `api-version=2` TiKV 集群中。

### TiKV-BR 命令行描述
一条 `tikv-br` 命令是由子命令、选项和参数组成的。子命令即不带 `-` 或者 `--` 的字符。选项即以 `-` 或者 `--` 开头的字符。参数即子命令或选项字符后紧跟的、并传递给命令和选项的字符。
#### 备份集群 Raw 模式数据
要备份 TiKV 集群中 Raw 模式数据，可使用 `tikv-br backup raw` 命令。该命令的使用帮助可以通过 `tikv-br backup raw --help` 来获取。
用例：将 TiKV 集群中 Raw 模式数据备份到 s3 `/backup-data/2022-09-16/` 目录中。
```bash
export AWS_ACCESS_KEY_ID=&{AWS_KEY_ID};
export AWS_SECRET_ACCESS_KEY=&{AWS_KEY};
tikv-br backup raw \
    --pd="&{PDIP}:2379" \
    --storage="s3://backup-data/2022-09-16/" \
    --dst-api-version v2 \
    --log-file="/tmp/backupraw.log \
    --gcttl=5m \
    --start="a" \
    --end="z" \
    --format="raw"
```
命令行各部分的解释如下：
- `backup`：`tikv-br` 的子命令。
- `raw`：`backup` 的子命令。
- `-s` 或 `--storage`：备份保存的路径。
- `"s3://backup-data/2022-09-16/"`：`--storage` 的参数，保存的路径为各个 TiKV 节点本地磁盘的 s3 的 `/backup-data/2022-09-16/` 目录。
- `--pd`：`PD` 服务地址。
- `"${PDIP}:2379"`：`--pd` 的参数。
- `--dst-api-version`: 指定备份文件的 `api-version`，请见 [tikv-server 配置文件]。
- `v2`: `--dst-api-version` 的参数，可选参数为 `v1`，`v1ttl`，`v2`(不区分大小写)，如果不指定 `dst-api-version` 参数，则备份文件的 `api-version` 与指定 `--pd` 所属的 TiKV 集群 `api-version` 相同。  
- `gcttl`: GC 暂停时长。可用于确保从存量数据备份到 [创建 TiKV-CDC 同步任务] 的这段时间内，增量数据不会被 GC 清除。默认为 5 分钟。
- `5m`: `gcttl` 的参数，数据格式为`数字 + 时间单位`, 例如 `24h` 表示 24 小时，`60m` 表示 60 分钟。
- `start`, `end`: 用于指定需要备份的数据区间，为左闭右开区间 `[start, end)`。默认为`["", "")`， 即全部数据。
- `format`：`start` 和 `end` 的格式，支持 `raw`、[`hex`] 和 [`escaped`] 三种格式。

备份期间会有进度条在终端中显示，当进度条前进到 100% 时，说明备份已完成。

备份完成后，会显示如下所示的信息:
```bash
[2022/09/20 18:01:10.125 +08:00] [INFO] [collector.go:67] ["Raw backup success summary"] [total-ranges=3] [ranges-succeed=3] [ranges-failed=0] [backup-total-regions=3] [total-take=5.050265883s] [backup-ts=436120585518448641] [total-kv=100000] [total-kv-size=108.7MB] [average-speed=21.11MB/s] [backup-data-size(after-compressed)=78.3MB]
```
以上信息的解释如下: 
- `total-ranges`: 备份任务切分成的分片个数， 与 `ranges-succeed` + `ranges-failed` 相等.
- `ranges-succeed`: 成功分片的个数。
- `ranges-failed`: 失败分片的个数。
- `backup-total-regions`: 执行备份任务的 TiKV region 个数。
- `total-take`: 备份任务执行时长。
- `backup-ts`: 备份时间点，只对 API V2 的 TiKV 集群生效。可以用于 [创建 TiKV-CDC 同步任务] 时的 `start-ts`.
- `total-kv`: 备份文件中键值对的个数。
- `total-kv-size`: 备份文件中键值对的大小。请注意，这是指压缩前的大小。
- `average-speed`: 备份速率，约等于 `total-kv-size` / `total-take`。
- `backup-data-size(after-compressed)`: 备份文件的大小。

#### 恢复 Raw 模式备份数据

要将 Raw 模式备份数据恢复到集群中来，可使用 `tikv-br restore raw` 命令。该命令的使用帮助可以通过 `tikv-br restore raw --help` 来获取。  
用例：将 s3 `/backup-data/2022-09-16/` 路径中的 Raw 模式备份数据恢复到集群中。
```bash
export AWS_ACCESS_KEY_ID=&{AWS_KEY_ID};
export AWS_SECRET_ACCESS_KEY=&{AWS_KEY};
tikv-br restore raw \
    --pd "${PDIP}:2379" \
    --storage "s3://backup-data/2022-09-16/" \
    --log-file restoreraw.log
```
以上命令中，`--log-file` 选项指定把 `TiKV-BR` 的 log 写到 `restoreraw.log` 文件中。
恢复期间会有进度条在终端中显示，当进度条前进到 100% 时，说明恢复已完成。  

恢复完成后，会显示如下所示的信息:
```bash
[2022/09/20 18:02:12.540 +08:00] [INFO] [collector.go:67] ["Raw restore success summary"] [total-ranges=3] [ranges-succeed=3] [ranges-failed=0] [restore-files=3] [total-take=950.460846ms] [restore-data-size(after-compressed)=78.3MB] [total-kv=100000] [total-kv-size=108.7MB] [average-speed=114.4MB/s]
```
以上信息的解释如下:  
- `total-ranges`: 恢复任务切分成的分片个数， 与 `ranges-succeed` + `ranges-failed` 相等.
- `ranges-succeed`: 成功分片的个数。
- `ranges-failed`: 失败分片的个数。
- `restore-files`: 执行恢复的文件个数。
- `total-take`: 恢复时长。
- `total-kv`: 恢复文件中键值对的个数。
- `total-kv-size`: 恢复文件中键值对的大小。请注意，这是指压缩前的大小。
- `average-speed`: 恢复速率，约等于 `total-kv-size` / `total-take`。
- `restore-data-size(after-compressed)`: 恢复文件的大小。


### 备份文件的数据校验

TiKV-BR 可以在 TiKV 集群备份和恢复操作完成后执行 `checksum` 来确保备份文件的完整性和正确性。 checksum 可以通过 `--checksum` 来开启。

checksum 开启时，备份或恢复操作完成后，会使用 [client-go] 的 [checksum] 接口来计算 TiKV 集群中有效数据的 checksum 结果，并与备份文件保存的 checksum 结果进行对比。

在某些场景中，TiKV 集群中的数据具有 [TTL] 属性，如果在备份和恢复过程中，数据的 TTL 过期，此时 TiKV 集群的 checksum 结果跟备份文件的 checksum 会不相同，因此不建议在此场景中开启 `checksum`。客户可以选择使用 [client-go] 的 [scan] 接口，在恢复操作完成后扫描出需要校验的数据，来确保备份文件的正确性。

### 备份恢复操作的安全性

TiKV-BR 支持在开启了 [TLS 配置] 的 TiKV 集群中执行备份和恢复操作，用户可以通过设置 `--ca`， `--cert` 和 `--key` 参数来指定客户端证书。

### 性能

TiKV-BR 的备份和恢复都是分布式的，因此在存储和网络没有达到瓶颈的时候，性能可以随着 TiKV 节点的增长而增长。下面提供了 TiKV-BR 的关键性能指标供参考。
- TiKV 节点：4 核 CPU， 8G 内存，v6.4.0
- PD 节点：4 核 CPU， 8G 内存，v6.4.0
- TiKV-BR 节点：4 核 CPU， 8G 内存，v1.1.0
- 存储容量： 50TB

|指标|TiKV API V1|TiKV API V2|
|:-:|:-:|:-:|
|备份速度|每 TiKV 节点 40MB/s|每 TiKV 节点 40MB/s|
|恢复速度|每 TiKV 节点 70MB/s|每 TiKV 节点 70MB/s|
|性能影响|QPS 降低 20%，时延增加 20%|QPS 降低 20%，时延增加 20%|

#### 性能调优

如果你希望减少备份对集群的影响，你可以开启[自动调节]功能。开启该功能后，备份功能会在不过度影响集群的前提下，以最快的速度进行数据备份。  
或者，你也可以使用参数 `--ratelimit` 进行备份限速。


[TiKV Backup & Restore (TiKV-BR)]: https://github.com/tikv/migration/tree/main/br
[操作系统及平台的要求]: https://docs.pingcap.com/zh/tidb/dev/hardware-and-software-requirements
[`api-version`]: https://docs.pingcap.com/zh/tidb/stable/tikv-configuration-file#api-version-%E4%BB%8E-v610-%E7%89%88%E6%9C%AC%E5%BC%80%E5%A7%8B%E5%BC%95%E5%85%A5
[tikv-server 配置文件]: https://docs.pingcap.com/zh/tidb/stable/tikv-configuration-file#api-version-%E4%BB%8E-v610-%E7%89%88%E6%9C%AC%E5%BC%80%E5%A7%8B%E5%BC%95%E5%85%A5
[创建 TiKV-CDC 同步任务]: ../../cdc/cdc-cn/#%E7%AE%A1%E7%90%86%E5%90%8C%E6%AD%A5%E4%BB%BB%E5%8A%A1-changefeed
[`hex`]: https://zh.wikipedia.org/wiki/%E5%8D%81%E5%85%AD%E8%BF%9B%E5%88%B6
[`escaped`]: https://zh.wikipedia.org/wiki/%E8%BD%AC%E4%B9%89%E5%AD%97%E7%AC%A6
[checksum]: ../../../../develop/rawkv/checksum
[client-go]: https://github.com/tikv/client-go
[TTL]: ../../ttl
[scan]: ../../../../develop/rawkv/scan
[TLS 配置]: https://docs.pingcap.com/zh/tidb/dev/enable-tls-between-components
[自动调节]: https://docs.pingcap.com/zh/tidb/dev/br-auto-tune