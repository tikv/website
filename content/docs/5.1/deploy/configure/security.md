---
title: Security Config
description: Keeping your TiKV secure
menu:
    "5.1":
        parent: Configure TiKV
        weight: 5
---

This section discusses how to use `Transport Layer Security (TLS)` to encrypt connections between TiKV nodes.

## Transport Layer Security

Transport Layer Security is an standard protocol for protecting networking communications from tampering or inspection. TiKV uses OpenSSL, an industry standard, to implement it's TLS encryption.

It's often necessary to use TLS in situations where TiKV is being deployed or accessed from outside of a secure virtual local area network (VLAN). This includes deployments which cross the WAN (the public internet), which are part of an untrusted data center network, or where other untrustworthy users or services are active.

## Before you get started

Before you get started, review your infrastructure. Your organization may already use something like the [Kubernetes certificates API](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/) to issue certificates. You will need the following for your deployment:

-  A **Certificate Authority** (CA) certificate
-  Individual unique **certificates** and **keys** for each TiKV or PD service
-  One or many **certificates** and **keys** for TiKV clients depending on your needs.

 If you have these, you can skip the optional section below.

If your organization doesn't yet have a public key infrastructure (PKI), you can create a simple Certificate Authority to issue certificates for the services in your deployment. The instructions below show you how to do this in a few quick steps:

### Optional: Generate a test certificate chain

Prepare certificates for each TiKV and PD node to be involved with the cluster.

It is recommended to prepare a separate server certificate for TiKV and the Placement Driver (PD), and make sure that they can authenticate each other. The clients of TiKV and PD can share one client certificate.

You can use multiple tools to generate self-signed certificates, such as `openssl`, `easy-rsa`, and `cfssl`.

Here is an example of generating self-signed certificates using [`easyrsa`](https://github.com/OpenVPN/easy-rsa/):

```bash
#! /bin/bash
set +e

mkdir -p easyrsa
cd easyrsa
curl -L https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz \
    | tar xzv --strip-components=1

./easyrsa init-pki \
    && ./easyrsa build-ca nopass

NUM_PD_NODES=3
for i in $(seq 1 $NUM_PD_NODES); do
    ./easyrsa gen-req pd$i nopass
    ./easyrsa sign-req server pd$i
done

NUM_TIKV_NODES=3
for i in $(seq 1 $NUM_TIKV_NODES); do
    ./easyrsa gen-req tikv$i nopass
    ./easyrsa sign-req server tikv$i
done

./easyrsa gen-req client nopass
./easyrsa sign-req server client
```

If you run this script, you'll need to interactively answer some questions and make some confirmations. You can answer with anything for the CA common name. For the PD and TiKV nodes, use the hostnames.

If the script runs successfully, you should have something like this:

```bash
$ ls easyrsa/pki/{ca.crt,issued,private}
easyrsa/pki/ca.crt

easyrsa/pki/issued:
client.crt  pd1.crt  pd2.crt  pd3.crt  tikv1.crt  tikv2.crt  tikv3.crt

easyrsa/pki/private:
ca.key  client.key  pd1.key  pd2.key  pd3.key  tikv1.key  tikv2.key  tikv3.key
```

### Configure the TiKV Server Certificates

Set the certificate in TiKV configuration file:

```toml
# Using empty strings here means disabling secure connections.
[security]
# The path to the file that contains the PEM encoding of the server’s CA certificates.
ca-path = "/path/to/ca.pem"
# The path to the file that contains the PEM encoding of the server’s certificate chain.
cert-path = "/path/to/tikv-server-cert.pem"
# The path to the file that contains the PEM encoding of the server’s private key.
key-path = "/path/to/tikv-server-key.pem"
# The name list used to verify the common name in client’s certificates. Verification is
# not enabled if this field is empty.
cert-allowed-cn = ["tikv-server", "pd-server"]
```

You'll also need to **change the connection URL to `https://`** instead of plain `ip:port`.

You can find all the TiKV TLS configuration options [here](../tikv-configuration-file/#security).

### Configure the PD Certificates

Set the certificate in PD configuration file:

```toml
[security]
# The path to the file that contains the PEM encoding of the server’s CA certificates.
cacert-path = "/path/to/ca.pem"
# The path to the file that contains the PEM encoding of the server’s certificate chain.
cert-path = "/path/to/pd-server-cert.pem"
# The path to the file that contains the PEM encoding of the server’s private key.
key-path = "/path/to/pd-server-key.pem"
# The name list used to verify the common name in client’s certificates. Verification is
# not enabled if this field is empty.
cert-allowed-cn = ["tikv-server", "pd-server"]
```

You'll also need to **change the connection URL to `https://`** instead of plain `ip:port`.

You can find all the PD TLS configuration options [here](../pd-configuration-file/#security).

### Configure the Client

You need to set TLS options for TiKV Client in order to connect to the TiKV. Taking [Rust Client](https://github.com/tikv/client-rust) as example, TLS option is set like this:

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

You'll also need to **change the connection URL to `https://`** instead of plain `ip:port`.

{{< warning >}}
Currently TiKV Java Client does not support TLS.
{{< /warning >}}

### Connecting with `tikv-ctl` and `pd-ctl`

When using `pd-ctl` and `tikv-ctl` the relevant options will need to be set:

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
