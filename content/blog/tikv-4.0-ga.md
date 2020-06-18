---
title: TiKV 4.0 GA Release
date: 2020-06-18
author: The TiKV Authors
---

We are excited to announce the general availability of TiKV 4.0! We're so glad and proud to have seen more than 1000 adopters use TiKV in production scenarios across multiple industries worldwide. Thanks to all users who have given us feedback, bug reports, and pull requests contributions over the past year. We’ve applied the lessons learned from these deployments to bring new features and better security to support users’ growing needs.

# New Features

For the 4.0 release, our team has kept polishing TiKV’s stability and creating new features. We’d like to highlight the following features which have brought TiKV better performance and functionality.

*   **Follower read**

With follower read, TiKV uses a series of load balancing mechanisms to offload read requests from the Raft leader to its followers. It ensures the linearizability of single-row data reads, helps reduce the load on the region leader, and substantially enhances the throughput of the entire system.

*   **Titan**

Titan is a RocksDB plugin for key-value separation. Compatible with all RocksDB features used by TiKV, it reduces write amplification by separating large values from the log-structured merge tree (LSM tree) and storing them independently. It improves range query performance and reduces its impact on write performance. Titan has previously been available as en experimental feature, and has reached general availability in TiKV 4.0. 

*   **Unified thread pool**

TiKV's unified thread pool is a unified adaptive thread pool for processing read requests. It unifies the point-get read pool and the coprocessor read pool to give priority to small requests, which improves resource utilization and limits the impact of large queries on small requests.

*   **Load-based Splitting** 

Load-based Splitting enables a Region to be automatically split into several small Regions when the Region remains a read hotspot continuously. After splitting, these small Regions can be evenly distributed to different TiKV nodes. Load-based Splitting solves the hot spots caused by the uneven distribution of Regions, such as full table scan and index query of small tables.

# Security

To ensure TiKV is protected from internal and external threats, our team has been working hard on data protection. TiKV completed [a third-party security assessment](https://tikv.org/blog/tikv-pass-security-audit/) in March and this assessment of the TiKV scope, commissioned by CNCF and executed by Cure53 concludes with generally positive results. Besides, we have made TiKV 4.0 reach a higher level of data security for TiKV clusters deployed in cloud environments by:

*   **Encryption at rest**

TiKV 4.0 encrypts data stored at rest to ensure data reliability and security. Encryption at rest prevents unauthorized access to the unencrypted data by ensuring the data is encrypted when on disk to provide data protection for stored data.

*   **TLS in the HTTP(status) port**

TiKV 4.0 supports TLS in the HTTP (status) port and dynamically updates the certificate online, making it safe to fetch TiKV’s internal status through the HTTP port. 

# What’s next

Going GA means that TiKV 4.0 is ready for usage in production environments, but there is still much more to come for us. We’d love to listen to feature requests from the community. Currently, the best way to make feature requests is to [open an issue](https://github.com/tikv/tikv/issues/new?template=feature-request.md) on GitHub. The TiKV team will surely take that information to heart when driving this project forward.

# Collaborate with TiKV Community

Most importantly, we’d like to thank our contributors who helped with this release. Whether you were a returning contributor or one of the many new folks we welcomed, thank you!

Not a contributor yet? We’d love to help you get started! If you’d like to get involved with the development and help drive forward the future of TiKV, you might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Adifficulty%2Feasy). If you don’t know how to begin, just leave a comment and our team will help you out. 

Also, don’t miss the chance to talk to us! You could reach us by:

*   [TiKV Community Meeting](https://docs.google.com/document/d/1CWUAkBrcm9KPclAu8fWHZzByZ0yhsQdRggnEdqtRMQ8/edit) to follow up with SIG updates
*   Twitter at [@tikvproject](https://twitter.com/tikvproject)
*   Slack at [#general](https://bit.ly/2ZcrVTI) on TiKV-WG
*   Github: [https://github.com/tikv/tikv](https://github.com/tikv/tikv)