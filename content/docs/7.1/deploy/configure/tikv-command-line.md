---
title: TiKV Command Line Parameters
description: Learn some configuration flags of TiKV
menu:
    "7.1":
        parent: Configure TiKV-7.1
        weight: 3
        identifier: TiKV Command Line Parameters-7.1
---

TiKV supports readable units in command line parameters.

- File size (bytes by default, case-insensitive): KB, MB, GB, TB, PB
- Time (ms by default): ms, s, m, h

## `-A, --addr`

- The address that the TiKV server monitors
- Default: "127.0.0.1:20160"
- To deploy a cluster, you must use `--addr` to specify the IP address of the current host, such as "192.168.100.113:20160". If the cluster is running on Docker, specify the IP address of Docker as "0.0.0.0:20160".

## `--advertise-addr`

- The server advertise address for client traffic from outside
- Default: ${addr}
- If the client cannot connect to TiKV through the `--addr` address because of Docker or NAT network, you must manually set the `--advertise-addr` address.
- For example, the internal IP address of Docker is "172.17.0.1", while the IP address of the host is "192.168.100.113" and the port mapping is set to "-p 20160:20160". In this case, you can set `--advertise-addr` to "192.168.100.113:20160". The client can find this service through "192.168.100.113:20160".

## `--status-addr`

+ The port through which the TiKV service status is listened
+ Default: "20180"
+ The Prometheus can access this status information via "http://host:status_port/metrics".
+ The Profile can access this status information via "http://host:status_port/debug/pprof/profile".

## `--advertise-status-addr`

- The address through which TiKV accesses service status from outside.
- Default: The value of `--status-addr` is used.
- If the client cannot connect to TiKV through the `--status-addr` address because of Docker or NAT network, you must manually set the `--advertise-status-addr` address.
- For example, the internal IP address of Docker is "172.17.0.1", while the IP address of the host is "192.168.100.113" and the port mapping is set to "-p 20180:20180". In this case, you can set `--advertise-status-addr="192.168.100.113:20180"`. The client can find this service through "192.168.100.113:20180".

## `-C, --config`

- The config file
- Default: ""
- If you set the configuration using the command line, the same setting in the config file is overwritten.

## `--capacity`

- The store capacity
- Default: 0 (unlimited)
- PD uses this parameter to determine how to balance TiKV servers. (Tip: you can use 10GB instead of 1073741824)

## `--data-dir`

- The path to the data directory
- Default: "/tmp/tikv/store"

## `-L`

- The log level
- Default: "info"
- You can choose from trace, debug, info, warn, error, or off.

## `--log-file`

- The log file
- Default: ""
- If this parameter is not set, logs are written to stderr. Otherwise, logs are stored in the log file which will be automatically rotated every day.

## `--pd`

- The address list of PD servers
- Default: ""
- To make TiKV work, you must use the value of `--pd` to connect the TiKV server to the PD server. Separate multiple PD addresses using comma, for example "192.168.100.113:2379, 192.168.100.114:2379, 192.168.100.115:2379".
