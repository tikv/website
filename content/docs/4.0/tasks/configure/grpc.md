---
title: gRPC Config
description: Learn how to configure gRPC in TiKV.
menu:
    "4.0":
        parent: Configure
        weight: 11
---

This document describes the configuration parameters related to gRPC.

### `grpc-compression-type`

+ The compression algorithm for gRPC messages
+ Optional values: `none`, `deflate`, `gzip`
+ Default value: `none`

### `grpc-concurrency`

+ The number of gRPC worker threads
+ Default value: `4`
+ Minimum value: `1`

### `grpc-concurrent-stream`

+ The maximum number of concurrent requests allowed in a gRPC stream
+ Default value: `1024`
+ Minimum value: `1`

### `server.grpc-raft-conn-num`

+ The maximum number of links among TiKV nodes for Raft communication
+ Default: `10`
+ Minimum value: `1`

### `server.grpc-stream-initial-window-size`

+ The window size of the gRPC stream
+ Default: 2MB
+ Unit: KB|MB|GB
+ Minimum value: `1KB`

### `server.grpc-keepalive-time`

+ The time interval at which that gRPC sends `keepalive` Ping messages
+ Default: `10s`
+ Minimum value: `1s`

### `server.grpc-keepalive-timeout`

+ Disables the timeout for gRPC streams
+ Default: `3s`
+ Minimum value: `1s`
