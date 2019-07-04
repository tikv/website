---
title: Secure TiKV
weight: 4
menu:
    docs:
        parent: Tasks
---

This page discusses how to secure your TiKV deployment. Learn how to:

* Use [Transport Layer Security](#transport-layer-security-tls) to encrypt connections between TiKV nodes
* Use [On-Disk Encryption](#on-disk-encryption) to encrypt the data that TiKV reads and writes to disk
* [Report vulnerabilities](#reporting-vulnerabilities)

## Transport Layer Security (TLS)

Transport Layer Security protects TiKV communications from tampering or inspection. This is useful in data centers where there may be untrustworthy (or unpriviledged) users or binaries, when operating over a WAN, or fulfilling compliance demands.

To use TLS encryption with TiKV, you need to prepare the certificates for the deployment.

### Prepare Certificates

It is recommended to prepare a separate server certificate for TiKV and the Placement Driver (PD), and make sure that they can authenticate each other. The clients of TiKV and PD can share one client certificate.

You can use multiple tools to generate self-signed certificates, such as `openssl`, `easy-rsa`, and `cfssl`.

See an example of [generating self-signed certificates](https://github.com/pingcap/docs/blob/master/op-guide/generate-self-signed-certificates.md) using `cfssl`.

### Configure the TiKV Server Certificates

Specify the TLS options for TiKV certificate with the configuration file options:

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

You'll also need to **change the connection URL to `https://`**.

### Configure the PD Certificates

Specify the TLS options for PD certificate with the configuration file options:

```toml
[security]
# The path to the file that contains the PEM encoding of the server’s CA certificates.
cacert-path = "/path/to/ca.pem"
# The path to the file that contains the PEM encoding of the server’s certificate chain.
cert-path = "/path/to/pd-server-cert.pem"
# The path to the file that contains the PEM encoding of the server’s private key.
key-path = "/path/to/pd-server-key.pem"
```

You'll also need to **change the connection URL to `https://`**.

### Configure the Client

When connecting your TiKV Client, you'll need to specify the TLS options. In this example, we build a configuration for the [Rust Client](https://github.com/tikv/client-rust):

```rust
let config = Config::new(/* ... */).with_security(
    // The path to the file that contains the PEM encoding of the server’s CA certificates.
    "/path/to/ca.pem",
    // The path to the file that contains the PEM encoding of the server’s certificate chain.
    "/path/to/client-cert.pem",
    // The path to the file that contains the PEM encoding of the server’s private key.
    "/path/to/client-key.pem"
);
```

You'll also need to **change the connection URL to `https://`**.

### Connecting with `tikv-ctl` and `pd-ctl`

When using `pd-ctl` and `tikv-ctl` the relevant options will need to be specified:

```bash
pd-ctl                                    \
    --pd     "https://127.0.0.1:2379"     \
    # The path to the file that contains the PEM encoding of the server’s CA certificates.
    --cacert "/path/to/ca.pem"            \
    # The path to the file that contains the PEM encoding of the server’s certificate chain.
    --cert   "/path/to/client.pem"        \
    # The path to the file that contains the PEM encoding of the server’s private key.
    --key    "/path/to/client-key.pem"

tikv-ctl                                  \
    --host      "127.0.0.1:20160"         \
    # The path to the file that contains the PEM encoding of the server’s CA certificates.
    --ca-path   "/path/to/ca.pem"         \
    # The path to the file that contains the PEM encoding of the server’s certificate chain.
    --cert-path "/path/to/client.pem"     \
    # The path to the file that contains the PEM encoding of the server’s private key.
    --key-path  "/path/to/client-key.pem"
```

## On-Disk Encryption

TiKV currently does not offer built-in on disk encryption.

This means an actor with access to the directory could extract TiKV data from it. If TiKV offered build in on disk encryption, then an actor would not be able to access the data.

This feature is part of the planned [roadmap](https://github.com/tikv/tikv/blob/master/docs/ROADMAP.md#engine) under 'Pluggable Engine Interface'. *(See [Issue #3680](https://github.com/tikv/tikv/issues/3680) if you want to help.)*

If your use case only requires that the data be encrypted at the partition level, it is advised to use [`dm-crypt`](https://en.wikipedia.org/wiki/Dm-crypt). This will protect data if, for example, the disk is incorrectly disposed of or stolen.

## Reporting Vulnerabilities

For most vulnerabilities, you are invited to open a ['Bug Report'](https://github.com/tikv/tikv/issues/new?template=bug-report.md) on our issue tracker.

For situations where the vulnerability must be kept secret to maintain data security or integrity, you should contact a [maintainer](https://github.com/tikv/tikv/blob/master/MAINTAINERS.md), who are best equipped to handle these critical situations.

Examples of critical situations:

* You have discovered a bug in the TLS implementation of TiKV which could leak data.
* You have discovered a way to retrieve more data than expected from TiKV.

*Please do not disclose critical vulnerabilities publicly if you are unsure.*
