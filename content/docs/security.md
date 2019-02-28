---
title: Security
description: Securing TiKV 
weight: 7
draft: false
---

This page discusses how to secure your TiKV deployment. Learn how to:

* Use [Transport Layer Security](#transport-layer-security-tls) to encrypt connections between TiKV nodes
* Use [On-Disk Encryption](#on-disk-encryption) to encrypt the data that TiKV reads and writes to disk
* [Report vulnerabilities](#reporting-vulnerabilities)

## Transport Layer Security (TLS)

It is possible to use TLS encryption with TiKV. To start, you need to prepare the certificates for the deployment.

### Prepare Certificates

It is recommended to prepare a separate server certificate for TiKV and PD, and make sure that they can authenticate each other. The clients of TiKV and PD share one client certificate.

You can use multiple tools to generate self-signed certificates, such as `openssl`, `easy-rsa` and `cfssl`.

See an example of [generating self-signed certificates](https://github.com/pingcap/docs/blob/master/op-guide/generate-self-signed-certificates.md) using `cfssl`.

### Configure the TiKV Server Certificates

Specify the TLS options via command line or the configuration file.

The relevant options in the configuration file are:

```toml
# Using empty strings here means disabling secure connections.
[security]
# The path to the file that contains the PEM encoding of the server’s CA certificates.
ca-path = "/path/to/ca.pem"
# The path to the file that contains the PEM encoding of the server’s certificate chain.
cert-path = "/path/to/tikv-server-cert.pem"
# The path to the file that contains the PEM encoding of the server’s private key.
key-path = "/path/to/tikv-server-key.pem"
```

You'll also need to **change the corresponding URL to `https://`**.

### Configure the Placement Driver Certificates

```toml
[security]
# The path to the file that contains the PEM encoding of the server’s CA certificates.
cacert-path = "/path/to/ca.pem"
# The path to the file that contains the PEM encoding of the server’s certificate chain.
cert-path = "/path/to/pd-server-cert.pem"
# The path to the file that contains the PEM encoding of the server’s private key.
key-path = "/path/to/pd-server-key.pem"
```

You'll also need to **change the corresponding URL to `https://`**.

### Configure the Client

When connecting your TiKV Client, you'll need to specify the TLS options. In this example we build a configuration for the [Rust Client](https://github.com/tikv/client-rust):

```rust
let config = Config::new(/* ... */).with_security(
    // The path to the file that contains the PEM encoding of the server’s CA certificates.
    "/path/to/ca.pem",
    // The path to the file that contains the PEM encoding of the server’s certificate chain.
    "/path/to/tikv-client-cert.pem",
    // The path to the file that contains the PEM encoding of the server’s private key.
    "/path/to/tikv-client-key.pem"
);
```

You'll also need to **change the corresponding URL to `https://`**.

## On-Disk Encryption

TiKV currently does not offer built-in on disk encryption. If this is a requirement for your deployment you can consider creating an encrypted volume.

This feature is part of the planned [roadmap](https://github.com/tikv/tikv/blob/master/docs/ROADMAP.md#engine) under 'Pluggable Engine Interface'. *(See this [Issue #3680](https://github.com/tikv/tikv/issues/3680) if you want to help.)*

## Reporting Vulnerabilities

For virtually all vulnerabilities you are invited to open a ['Bug Report'](https://github.com/tikv/tikv/issues/new?template=bug-report.md) on our issue tracker.

For situations where the vulnerability must be kept secret to maintain data security or integrity, you can contact [a maintainer](https://github.com/tikv/tikv/blob/master/MAINTAINERS.md). They are best equipped to handle these critical situations.

Examples of critical situations:

* You discovered a bug in the TLS implementation of TiKV which could leak data.
* You discovered a way to retrieve more data than expected from TiKV with a command on a live, production deployment.