---
title: Celebrating TiKV’s CNCF Graduation
date: 2020-09-02
author: TiKV Authors
tags: ['Community', 'CNCF']
---
{{< figure src="/img/blog/graduation/TiKV-graduation.jpg" caption="" number="" >}}

Today we are excited to announce that TiKV is now a [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/) graduated project! This marks CNCF’s recognition of TiKV, including its growing adoption, governance processes, project maturity, commitment to the community, and sustainability as well as inclusivity.

“TiKV was one of our first Rust based projects and is truly a flexible and extensible cloud native key-value store,” said Chris Aniszczyk, CTO/COO of the Cloud Native Computing Foundation. “Since the project joined CNCF, we have been impressed with the project growth and desire to cultivate a global open source community.”

TiKV was originally created by PingCAP to complement TiDB, a distributed HTAP database compatible with the MySQL protocol. As the maintainers of TiKV, we realized TiKV should be a lot more than just that when we created it 5 years ago, that’s why we brought it under the realm and stewardship of CNCF, to enable and empower the next generation of databases by providing a reliable, high quality, practical storage foundation. In August 2018, TiKV[ was accepted as a CNCF sandbox project](https://www.cncf.io/blog/2018/08/28/cncf-to-host-tikv-in-the-sandbox/). In May 2019, [TiKV was moved into incubation-level projects](https://tikv.org/blog/cncf-incubating/). 

Designed to be cloud-native, TiKV integrates well into CNCF ecosystems. TiKV uses Prometheus for metrics reporting and gRPC for communication. In addition, it is complementary to existing CNCF projects, such as Vitess, etcd, gRPC, and Prometheus. TiKV can also be deployed on top of Kubernetes with TiKV Operator to ease installation, upgrades, and maintenance.

## A continuously improved TiKV

TiKV has been continuously improved on performance, stability, security, and functionalities. In July 2019, we released TiKV 3.0, and two months ago, we announced its 4.0 version. These two major version releases mark TiKV’s growth with some highlighted features, including:

*   Follower Read, which ensures the linearizability of single-row data reads, helps reduce the load on the region leader, and substantially enhances the throughput of the entire system.
*   Hot region balancing, which handles more hot regions now and eliminates excessive scheduling problems. 
*   Titan, which reduces write amplification and improves range query performance and reduces its impact on write performance. 
*   Hibernate Region, which reduces the extra overhead caused by heartbeat messages between the Raft leader and the followers for idle Regions. 

## A vibrant open-source community

Most importantly, TiKV’s graduation would not have been possible without the support, contributions, and commitment from the community. We’d like to thank all users who have given us feedback, bug reports, and pull requests contributions and of course our contributors who helped with TiKV’s improvement.

With the joint efforts from community members,  we have a vibrant community with rich activities. Holding TiDB Performance Challenges and Bug Hunting program with PingCAP, and joining GSoC and CommunityBridge mentorship programs under CNCF brought us more friends to drive the TiKV project forward.

Let’s take a look at some stats that illustrate how the community has come:

*   7920+ GitHub stars
*   250+ contributors
*   1,220+ forks
*   750+ Slack members

## Voices from end-users

Connecting with our users and listening to their stories are always pleasures for us because their requests and feedback navigate us on product polishing. Seeing TiKV eliminates their database bottlenecks and troubleshooting problems, we could not be more proud and glad.

Here listed some of our users’ stories with congratulations on TiKV’s graduation:

> “TiKV has provided such an excellent foundation to build versatile cloud-native stateful services. TiDB and Zetta Table Store which are all built on top of TiKV jointly support all the large table application scenarios of Zhihu and solve many problems caused by the limited scalability of MySQL. We are very proud to be part of the community and we believe TiKV will benefit more users with the efforts of community members.”
>*   Xiaoguang Sun, TiKV maintainer, and director of Infrastructure at Zhihu.com

>“TiKV is a very stable and performant distributed key-value database. Its intelligent and efficient cluster management functions provide great support for our online recommendation service. We adopted TiKV in 2018 and it has become an essential part of our storage system.”
>*   Fu Chen, TiKV maintainer, and distributed storage engineer at Yidian Zixun

>“We were amazed by the level of maturity of the ecosystem around this solution. The Kubernetes operator is pretty simple to get started with and helps with common operation tasks. The observability tools are rich. This level of resiliency can be achieved thanks to the rock-solid TiKV implementation. Its graduation is well deserved.”
>*   Smaïne Kahlouch, DevOps Team Leader at Dailymotion

>“We have been using TiKV in production on the ARM platform since December 2019. The scalability and high performance of TiKV enabled us through the unpredictable traffic increase through COVID-19. We are constantly impressed by how active the TiKV community is and would love to contribute back! Congratulations on the graduation!”
>*   Birong Huang, Senior Engineer at U-Next

## What’s next

With TiKV’s graduation, we will be continuously dedicated to creating a collaborative community atmosphere of research, development, and engineering excellence for the community, where you and TiKV can grow together. We couldn’t be happier with members’ participation, contribution, and feedback. 

There are many different ways to continue getting involved in the TiKV project!

*   [TiKV website](https://tikv.org/)
*   [Github](https://github.com/tikv/tikv)
*   [TiKV Community Meeting](https://docs.google.com/document/d/1CWUAkBrcm9KPclAu8fWHZzByZ0yhsQdRggnEdqtRMQ8/edit)
*   [Twitter](https://twitter.com/tikvproject)
*   [Slack](https://bit.ly/2ZcrVTI)