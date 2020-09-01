---
title: Announcing PD Transfer to TiKV Project
date: 2020-08-14
author: TiKV Authors
summary: We decide to move the Placement Driver library entirely to TiKV org, happening at 11 AM, UTC+8, August 17, 2020.
tags: ['Community', 'Announcement']
---

Dear fellow community members,

As you may already know, there have been debates in the community over [Placement Driver](https://github.com/pingcap/pd) (PD) regarding its affiliation to [TiDB](https://docs.pingcap.com/tidb/stable/overview) and TiKV. Currently it is under [PingCAP](https://pingcap.com/) organization, as a dependency library to many of the TiDB/TiKV eco-system projects. However, it's also indisputable that PD functions as the cluster manager, meta store, and scheduling center to TiKV, which is a CNCF project up for graduation. To clear the concern in the community, we decide to move the PD library entirely to [TiKV org](https://github.com/tikv), happening at 11 AM, UTC+8, August 17, 2020.

After an initial evaluation, this move doesn't impact how you use or develop PD/TiKV/TiDB in the long run, but please be aware of the process as follows:

1. Stop all CI activities related to PD, and update the import path in PD
2. Perform the transfer.
3. Reconfigure automation testing framework that includes CI, GitHub bot, etc under the TiKV org.
4. Update the import path for downstream projects that depend on PD.

We expect the transfer to be finished within 24 hours, and will keep you informed when it is completed.

**Important:** If the project you are working on depends on PD, you will need to modify the import path correspondingly next time you update PD.

Leave your comment on related issue/RFC if any, and let us know if you encounter any issues that are caused by the transfer.

* https://github.com/pingcap/pd/issues/2758
* https://github.com/tikv/rfcs/pull/55/files

Thanks.

Maintainers of TiDB & TiKV