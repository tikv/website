---
title: My CommunityBridge Mentorship with TiKV Project
date: 2020-08-12
author: Chi Zhang
tags: ['Community', 'CNCF']
---

[CommunityBridge](https://communitybridge.org/) is a 12-week full-time mentorship program developed by The Linux Foundation. It is designed to help developers with the necessary skills to experiment, learn, and contribute effectively to open source communities. This program is actively used by Cloud Native Computing Foundation as a mentorship platform across the CNCF projects. I was honored and lucky to participate in [the Full Chunk-based Computing project](https://github.com/cncf/mentoring/blob/master/communitybridge/2020/q2/selected_projects.md#tikv) proposed by [TiKV](https://tikv.org/), a CNCF incubating project. In this post, I would like to share my experience in the CommunityBridge Mentorship Program as a mentee to TiKV project. 

## Applying for the program

As a student majoring in Computer Science, I am always passionate about making toy projects, especially building applications with Rust. In this spring, I began to seek chances to work on a real-world Rust project. Luckily, I found someone posting the engaging process of the TiKV project in the CommunityBridge program to a Rust study group. After browsing through all the information, I realized that this program would allow me to work closely with the TiKV community and contribute to TiKV, so I decided to apply for the program without hesitation.

Every project in this program has a different selection process. As for the TiKV project, applicants are required to submit a resume, a cover letter, and two coding tasks. My coding tasks were to write a simplified version of TiKV coprocessor vectorization framework. The tasks were not difficult but were closely related to what the mentee would do in the next few months. Therefore, I took them with extra attention and efforts, by reading the TiKV source code and optimizing my code to make it more robust and efficient. Also, I helped other candidates who did not have any Rust background on Slack channel because I always think the process of sharing my ideas and helping others is a lot funnier than coding itself. This impressed the mentors a lot, so I was finally selected as a TiKV project mentee.

## The coding period

My project for the program is [Full Chunk-based Computing](https://github.com/tikv/tikv/issues/7724). It is about changing how data is stored in memory during the computation process. Previously, the memory layout of TiKV was very loose and not cache-friendly because all data was stored within a Rust vector. Using chunk format would make a more compact memory layout - there is a bitmap representation if a cell is null or not; strings are stored continuously. This makes the computation process more efficient. 

Replacing the Rust vector with a new data structure seems trivial at first glance, but is by no means easy to implement. After a week’s discussion with my mentors, we came up with a three-step migration plan. 

1. Modify the outside developer interface according to [RFC](https://github.com/tikv/rfcs/pull/43)
2. Refactor the coprocessor framework
3. Introduce the new chunk vector structure and complete the migration procedure

According to this plan, I made the following roadmap for this project to better manage and monitor my tasks.

{{< figure src="/img/blog/community-bridge/roadmap of full chunck based computing.png" caption="Roadmap of TiKV Full Chunk-based Computing" number="" >}}

During the coding period, I found that timely communication with the community and mentors was a crucial part of this project. Thus, I summarized some of my experience as below, hoping they can be helpful for anyone involved in the open source community.

**Plan ahead.** I spent about a week reading through the TiKV codebase to gain some basic ideas on how to implement “Chunk-based Computing”. After that, I laid out the plan and split them into small tasks. These tasks were then added to [my GitHub Project](https://github.com/skyzh/tikv/projects/1). I used the GitHub project board to keep  track of my progress. This way, my mentors would know well what I have done and what I will do next.

{{< figure src="/img/blog/community-bridge/github project board.png" caption="My GitHub Project of TiKV Full Chunk-based Computing" number="" >}}

**Get advice.** The coding process went smooth at first, until I found that something was overlooked: introducing the chunk vector requires refactoring two more modules, which was  beyond the plan! After a few trials, I still failed to compile the refactored code. I explained the obstacles to my mentors, and presented my failed attempts. Fortunately, my mentors came up with a solution in just a few minutes. Their advice inspired me a lot, and I finally succeeded in submitting this [PR](https://github.com/tikv/tikv/pull/8141) and continuing with the project.

**Keep synchronized.** Reviewing and merging a pull request may take a long time. Therefore, it’s important to communicate with the community, to get PRs merged into the upstream branch. Every week I posted unmerged PRs into the Slack channel and explained my changes in detail to make the review process faster. 

**Share ideas.** When I have new ideas, I always feel welcomed to discuss it with other contributors in the TiKV community. This process helps mature the idea and discover possible flaws in advance. Explaining ideas clearly help mentors and other collaborators know better about what I am doing so they can provide more specific advice.

## After the program

I had a wonderful time working with the TiKV project. My mentors are really experienced, and could always provide foresightful advice on making this project better. The TiKV community is very friendly. The review and merge process is clear and easy to follow. A lot of checks and evaluations can be done with an automation bot “ti-srebot”, which makes the process consistent and efficient.

When implementing the “Chunk-based Computing” RFC, I feel my coding skills have improved over time. Now I get a better understanding of the Rust type system, generics and procedural macro. Besides coding skills, I also have a clearer idea of how to collaborate in an open-source community. I applied some of the best practices in my own open-source project, which makes the code review process in my team much more efficient.

Finally, I would like to thank [@breeswish](https://github.com/breeswish) and [@TennyZhuang](https://github.com/TennyZhuang) for mentoring me - they have a good command of the TiKV project and helped me a lot. Also thank TiKV community and sig-copr members, which this project belongs to. Thank CNCF and Linux Foundation for organizing this CommunityBridge Program. And also Wenting, the project administrator at TiKV community who helped me with administrative stuff in this program.

**About the author:**

Chi Zhang is a mentee of the TiKV project at the CommunityBridge Mentorship Program. He is also a sophomore at Shanghai Jiao Tong University.