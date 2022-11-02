---
title: Security Config
description: Keep your TiKV secure
menu:
    "dev":
        parent: Configure TiKV-dev
        weight: 5
        identifier: Security Config-dev
---

This document describes how to use Transport Layer Security (TLS) to encrypt the connections between TiKV nodes.

## Transport Layer Security

Transport Layer Security is a standard protocol designed to protect network communications from network tampering or inspection. TiKV uses OpenSSL, an industry-standard toolkit for TLS, to implement its TLS encryption.

It is necessary to use TLS when TiKV is being deployed or accessed from outside of a secure Virtual Local Area Network (VLAN), such as the network across a Wide Area Network (WAN, also refers to a public internet), the network that is a part of an untrusted data center network, and the network where other untrustworthy users or services are active.

## Preparation

Before getting started, you need to check your infrastructure. Your organization might already use tools like the [Kubernetes certificates API](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/) to issue certificates. To successfully encrypt the connections between TiKV nodes, prepare the following certificates and keys:

-  A **Certificate Authority** (CA) certificate
-  Individual unique **certificates** and **keys** for each TiKV service and PD service
-  One or many **certificates** and **keys** for TiKV clients depending on your needs.

 If you already have them, you can skip the [optional section](#optional-generate-a-test-certificate-chain) below.

If your organization does not yet have a public key infrastructure (PKI), you can create a simple CA to issue certificates for the services in your deployment by following the below instructions:

### Optional: Generate a test certificate chain

You need to prepare certificates for each TiKV and Placement Driver (PD) node to be involved with the cluster. It is recommended to prepare a separate server certificate for TiKV and PD and ensure that they can authenticate each other. The clients of TiKV and PD can share one client certificate.

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

When running this script, you need to answer some questions and make some confirmations interactively. For the CA common name, you can use any desired name. While for the PD and TiKV nodes, you need to use the hostnames.

If you see the following output, it means that the script runs successfully:

```bash
$ ls easyrsa/pki/{ca.crt,issued,private}
easyrsa/pki/ca.crt

easyrsa/pki/issued:
client.crt  pd1.crt  pd2.crt  pd3.crt  tikv1.crt  tikv2.crt  tikv3.crt

easyrsa/pki/private:
ca.key  client.key  pd1.key  pd2.key  pd3.key  tikv1.key  tikv2.key  tikv3.key
```

## Step 1. Configure the TiKV server certificates

You need to set the certificates in the TiKV configuration file:

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

Besides, the **connection URL should be changed to `https://`** instead of a plain `ip:port`.

For the information about all TLS configuration parameters of TiKV, see [TiKV security-related parameters](../tikv-configuration-file/#security).

## Step 2. Configure the PD certificates

You need to set the certificates in the PD configuration file:

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

Besides, the **connection URL should be changed to `https://`** instead of a plain `ip:port`.

For the information about all TLS configuration parameters of PD, see [PD security-related parameters](../pd-configuration-file/#security).

## Step 3. Configure the TiKV client

You need to set TLS options for the TiKV client to connect to TiKV. Taking [Rust Client](https://github.com/tikv/client-rust) as an example, the TLS options are set as follows:

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

Besides, the **connection URL should be changed to `https://`** instead of a plain `ip:port`.

{{< warning >}}
Currently, TiKV Java Client does not support TLS.
{{< /warning >}}

## Step 4. Connect TiKV using `tikv-ctl` and `pd-ctl`

To use `pd-ctl` and `tikv-ctl`, set the relevant options as follows:

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
