---
title: RawKV BR
description: How to backup and restore RawKV Data
menu:
    "7.1":
        parent: Features-7.1
        weight: 7
        identifier: RawKV BR-7.1
---

This page introduces what's RawKV BR and how to use it.

[中文使用手册]

## RawKV Backup & Restore

**[TiKV Backup & Restore (TiKV-BR)]** is a command-line tool for distributed backup and restoration of the TiKV cluster data.

## Architecture

{{< figure
    src="/img/docs/tikv-br.png"
    caption="TiKV-BR architecture"
    number="1" >}}

### Installation

#### Install with TiUP
`tikv-br` is a component of [TiUP], so you can easily use `tikv-br` with [TiUP] as following:
```bash
tiup tikv-br:v1.1.0 <command> <subcommand> 
```
If `tikv-br` is not installed before, TiUP will download it automatically.

#### Install manually

Please find the latest release and download the binary from [GitHub].  

### Recommended Deployment Configuration
- In production environments, deploy `TiKV-BR` on a node with at least 4 cores CPU and 8 GB memory. Select an appropriate OS version by following [Linux OS version requirements].

- Save backup data to Amazon S3 or other shared storage, for example mounting a NFS on all `TiKV-BR` and `TiKV` nodes.

- Allocate sufficient resources for backup and restoration.

- TiKV-BR only supports raw data backup/restoration in TiKV cluster with version >= `5.0.0`.

TiKV-BR, TiKV nodes, and the backup storage system should provide network bandwidth that is greater than the backup speed. If the target cluster is particularly large, the threshold of backup and restoration speed highly depends on the bandwidth of storage system.  
The backup storage system should also provide sufficient write/read performance (IOPS). Otherwise, the IOPS might become a performance bottleneck during backup or restoration.  
TiKV nodes need to have at least two additional spare CPU cores and disk bandwidth (related to `ratelimit` parameter) for backups. Otherwise, the backup might have an impact on the services running on the cluster.

### Best practice
The following are some recommended operations for using `TiKV-BR` for backup and restoration:
- It is recommended that you perform the backup operation during off-peak hours to minimize the impact on applications.
- `TiKV-BR` supports restoration on clusters of different topologies. However, the online applications will be greatly impacted during the restoration operation. It is recommended that you perform restoration during the off-peak hours or use `ratelimit` to limit the rate.
- It is recommended that you execute multiple backup operations serially. Running different backup operations in parallel reduces backup performance and also affects the online application.
- It is recommended that you execute multiple restoration operations serially. Running different restoration operations in parallel increases Region conflicts and also reduces restoration performance.
- `TiKV-BR` supports checksum between `TiKV` cluster and backup files after backup or restoration with the config `--checksum=true`. Note that, if checksum is enabled, please make sure no data is changed or `TTL` expired in `TiKV` cluster during backup or restoration.
- TiKV-BR supports [api-version] conversion from V1 to V2 with config `--dst-api-version=V2`. Then restore the backup files to API v2 `TiKV` cluster. This is mainly used to upgrade from API V1 cluster to API v2 cluster.

### TiKV-BR Command Line Description
A tikv-br command consists of sub-commands, options, and parameters.

- Sub-command: the characters without `-` or `--`, including `backup`, `restore`, `raw` and `help`.
- Option: the characters that start with `-` or `--`.
- Parameter: the characters that immediately follow behind and are passed to the sub-command or the option.
#### Backup Raw Data
To backup the cluster raw data, use the `tikv-br backup raw` command. To get help on this command, execute `tikv-br backup raw -h` or `tikv-br backup raw --help`.
For example, backup raw data in TiKV cluster to s3 `/backup-data/2022-09-16` directory.

```bash
export AWS_ACCESS_KEY_ID=&{AWS_KEY_ID};
export AWS_SECRET_ACCESS_KEY=&{AWS_KEY};
tikv-br backup raw \
    --pd="&{PDIP}:2379" \
    --storage="s3://backup-data/2022-09-16/" \
    --ratelimit=128 \
    --dst-api-version=v2 \
    --log-file="/tmp/br_backup.log \
    --gcttl=5m \
    --start="a" \
    --end="z" \
    --format="raw"
```
Explanations for some options in the above command are as follows: 
- `backup`: Sub-command of `tikv-br`.
- `raw`: Sub-command of `backup`.
- `-s` or `--storage`: Storage of backup files.
- `"s3://backup-data/2022-09-16/"`: Parameter of `-s`, save the backup files in `"s3://backup-data/2022-09-16/"`.
- `--ratelimit`: The maximum speed at which a backup operation is performed on each `TiKV` node.
- `128`: The value of `ratelimit`, unit is MiB/s.
- `--pd`: Service address of `PD`.
- `"${PDIP}:2379"`:  Parameter of `--pd`.
- `--dst-api-version`: The `api-version`, please see [API v2].
- `v2`: Parameter of `--dst-api-version`, the optionals are `v1`, `v1ttl`, `v2`(Case insensitive). If no `dst-api-version` is specified, the `api-version` is the same with TiKV cluster of `--pd`.
- `gcttl`: The pause duration of GC. This can be used to make sure that the incremental data from the beginning of backup to [Creating a replication task] will NOT be deleted by GC. 5 minutes by default.
- `5m`: Parameter of `gcttl`. Its format is `number + unit`, e.g. `24h` means 24 hours, `60m` means 60 minutes.
- `start`, `end`: The backup key range. It's closed left and open right `[start, end)`.
- `format`: Format of `start` and `end`. Supported formats are `raw`、[hex] and [escaped].

A progress bar is displayed in the terminal during the backup. When the progress bar advances to 100%, the backup is complete. The progress bar is displayed as follows:
```bash
br backup raw \
    --pd="${PDIP}:2379" \
    --storage="s3://backup-data/2022-09-16/" \
    --log-file=backupraw.log
Backup Raw <---------/................................................> 17.12%.
```

After backup finish, the result message is displayed as follows:
```bash
[2022/09/20 18:01:10.125 +08:00] [INFO] [collector.go:67] ["Raw backup success summary"] [total-ranges=3] [ranges-succeed=3] [ranges-failed=0] [backup-total-regions=3] [total-take=5.050265883s] [backup-ts=436120585518448641] [total-kv=100000] [total-kv-size=108.7MB] [average-speed=21.11MB/s] [backup-data-size(after-compressed)=78.3MB]
```
Explanations for the above message are as follows: 
- `total-ranges`: Number of ranges that the whole backup task is split to. Equals to `ranges-succeed` + `ranges-failed`.
- `ranges-succeed`: Number of succeeded ranges.
- `ranges-failed`: Number of failed ranges.
- `backup-total-regions`: The tikv regions that backup takes.
- `total-take`: The backup duration.
- `backup-ts`: The backup start timestamp, only takes effect for API v2 TiKV cluster, which can be used as `start-ts` of `TiKV-CDC` when creating replication tasks. Refer to [Creating a replication task].
- `total-kv`: Total number of key-value pairs in backup files.
- `total-kv-size`: Total size of key-value pairs in backup files. Note that this is the original size before compression.
- `average-speed`: The backup speed, which approximately equals to `total-kv-size` / `total-take`.
- `backup-data-size(after-compressed)`: The backup file size.

#### Restore Raw Data

To restore raw data to the cluster, execute the `tikv-br restore raw` command. To get help on this command, execute `tikv-br restore raw -h` or `tikv-br restore raw --help`.
For example, restore the raw backup files in s3 `/backup-data/2022-09-16` to `TiKV` cluster.

```bash
export AWS_ACCESS_KEY_ID=&{AWS_KEY_ID};
export AWS_SECRET_ACCESS_KEY=&{AWS_KEY};
tikv-br restore raw \
    --pd="${PDIP}:2379" \
    --storage="s3://backup-data/2022-09-16/" \
    --ratelimit=128 \
    --log-file=restoreraw.log
```
Explanations for some options in the above command are as follows:

- `--ratelimit`: The maximum speed at which a restoration operation is performed (MiB/s) on each `TiKV` node.
- `--log-file`: Writing the TiKV-BR log to the `restoreraw.log` file.

A progress bar is displayed in the terminal during the restoration. When the progress bar advances to 100%, the restoration is complete. The progress bar is displayed as follows:
```bash
tikv-br restore raw \
    --pd="${PDIP}:2379" \
    --storage="s3://backup-data/2022-09-16/" \
    --ratelimit=128 \
    --log-file=restoreraw.log
Restore Raw <---------/...............................................> 17.12%.
```

After restoration finish, the result message is displayed as follows:
```bash
[2022/09/20 18:02:12.540 +08:00] [INFO] [collector.go:67] ["Raw restore success summary"] [total-ranges=3] [ranges-succeed=3] [ranges-failed=0] [restore-files=3] [total-take=950.460846ms] [restore-data-size(after-compressed)=78.3MB] [total-kv=100000] [total-kv-size=108.7MB] [average-speed=114.4MB/s]
```
Explanations for the above message are as follows: 
- `total-ranges`: Number of ranges that the whole backup task is split to. Equals to `ranges-succeed` + `ranges-failed`.
- `ranges-succeed`: Number of successful ranges.
- `ranges-failed`: Number of failed ranges.
- `restore-files`: Number of restored files.
- `total-take`: The restoration duration.
- `total-kv`: Total number of restored key-value pairs.
- `total-kv-size`: Total size restored key-value pairs. Note that this is the original size before compression.
- `average-speed`: The restoration speed, which approximately equals to `total-kv-size` / `total-take`.
- `restore-data-size(after-compressed)`: The restoration file size.


### Data Verification of Backup & Restore


TiKV-BR can do checksum between TiKV cluster and backup files after backup or restoration finishes with the config `--checksum=true`. Checksum is using the [checksum] interface in TiKV [client-go], which send checksum request to all TiKV regions to calculate the checksum of all **VALID** data. Then compare the checksum value of backup files which is calculated during the backup process.

Please note that if data is stored in TiKV with [TTL], and expiration happens during backup or restore, the persisted checksum in backup files must be different from the checksum of TiKV cluster. So checksum should **NOT** be enabled in this scenario.

### Security During Backup & Restoration

TiKV-BR supports TLS if [TLS config] in TiKV cluster is enabled.

Please specify the client certification with config `--ca`, `--cert` and `--key`.

### Performance

The backup and restoration are both distributed, so performance can increase linearly with the number of TiKV nodes, until the storage or network reach the limits. The following are some key metrics of TiKV-BR backup and restoration benchmark for reference.
- TiKV node: 4 cores CPU, 8 GB memory, v6.4.0
- PD node: 4 cores CPU, 8 GB memory, v6.4.0
- TiKV-BR node: 4 cores CPU, 8 GB memory, v1.1.0
- Data volume: 50 TB

|Metric|TiKV API v1|TiKV API v2|
|:-:|:-:|:-:|
|Backup speed|40MB/s per TiKV node|40MB/s per TiKV node|
|Restoration speed|70MB/s per TiKV node|70MB/s per TiKV node|
|Performance impact|20% on QPS/Latency|20% on QPS/Latency|

#### Performance tuning

If you want to reduce the business impact of backup tasks, you can enable the [auto-tune] feature. With this feature enabled, TiKV-BR performs backup tasks as fast as possible without excessively affecting the cluster. See [BR Auto-Tune] for details.

Alternatively, you can limit the backup speed by using the parameter `--ratelimit` of tikv-br.


[中文使用手册]: ../backup-restore-cn
[TiKV Backup & Restore (TiKV-BR)]: https://github.com/tikv/migration/tree/main/br
[Linux OS version requirements]: https://docs.pingcap.com/tidb/dev/hardware-and-software-requirements#linux-os-version-requirements
[TiUP]: https://tiup.io
[GitHub]: https://github.com/tikv/migration/releases
[api-version]: ../api-v2
[API v2]: ../api-v2
[hex]: https://en.wikipedia.org/wiki/Hexadecimal
[escaped]: https://en.wikipedia.org/wiki/Escape_character
[Creating a replication task]: ../cdc/cdc#manage-replication-tasks-changefeed
[checksum]: ../../../develop/rawkv/checksum
[client-go]: https://github.com/tikv/client-go
[TTL]: ../ttl
[TLS config]: https://docs.pingcap.com/tidb/dev/enable-tls-between-components
[auto-tune]: https://docs.pingcap.com/tidb/stable/tikv-configuration-file#enable-auto-tune-new-in-v540
[BR Auto-Tune]: https://docs.pingcap.com/tidb/dev/br-auto-tune