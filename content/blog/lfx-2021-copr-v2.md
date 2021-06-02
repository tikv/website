---
title: "Looking Back at the LFX Mentorship Program Spring '21: My Journey to Becoming a TiKV Contributor"
date: 2021-05-31
author: Andreas Zimmerer
tags: ['Community', 'CNCF']
---


I am a graduate student in the department of computer science at the Technical University of Munich (TUM), Germany.
This spring (2021), I had the pleasure to contribute a major part of the new coprocessor framework to [TiKV](https://github.com/tikv/tikv) under the LFX Mentorship Program together with my mentors [Andy Lok](https://github.com/andylokandy) and [Alex Chi](https://github.com/skyzh).


{{< figure src="/img/blog/lfx-2021-copr-v2/lfx.svg" caption="LFX Mentorship Program logo" >}}

# Background

Before I applied to the [LFX Mentorship Program](https://mentorship.lfx.linuxfoundation.org/), I had only contributed minor stuff to various open-source projects in my free time, like enhancing the documentation, fixing some small issues, and so on.
While this was certainly a plus when I applied to TiKV, it is by no means required! The LFX Mentorship Program is a perfect start into the world of open-source software and the community around it :)

Oftentimes I hear from other students that it's hard to get started with open-source development; sometimes people don't feel that they have the required skills or knowledge.
You might not be familiar with all technologies being used in a project or you don't feel you are proficient enough with the main programming language of the project.
But fear not: don't block yourself by finding unnecessary excuses, just start!
Contributing to open-source projects is the *perfect* opportunity to learn new technologies and get better at programming because you'll receive valuable feedback that you will not find easily elsewhere.
Start small by reporting bugs or other issues. If you are up for a challenge, ask the maintainers if you could fix a certain issue with their help.
Then create your first PR, get feedback, refine your code, and eventually your code will get merged!
You will feel great, and maybe you'll pick up perhaps next time you'll pick a slightly bigger issue.
After all, it's a fun journey and not a one-stop drive-through.

Overall, the LFX Mentorship Program is a perfect opportunity to get started with open-source software development.

I first heard about the LFX program on Twitter where TiKV posted their coprocessor challenge.


{{< tweet 1357043353360162817 >}}


I was immediately hooked when I read the tweet, because:

 * I *love* database internals! I took almost all courses offered at my university about the design and implementation of database systems including transactional theory.
 * I never had the chance to work on a production-quality database system.
 * It was written in Rust. There are two benefits from that: I know Rust okay-ish well, and the Rust ecosystem has the advantage that there is usually no weird setup required. Just a `cargo test` should do it and pull all dependencies. Also, the type system ensures that you can't completely mess up stuff when touching unknown parts of the code.



Be aware that, while you have to submit application documents like your CV and a cover letter via the LFX website, some individual projects might have their own, additional application process.
In the end, the project maintainers decide on who is accepted, so make sure to fulfill the required criteria.


# The Task

My task during the duration of the program was to implement a "pluggable coprocessor for TiKV".
When I applied for the project, I didn't quite know what a "pluggable coprocessor" would look like.

But first of all: What is TiKV?

According to [their GitHub repo](https://mentorship.lfx.linuxfoundation.org/#projects), "TiKV is an open-source, distributed, and transactional key-value database" developed by PingCAP.
It is written in Rust and was originally created to serve as the storage layer for a fully-fledged database system called [TiDB](https://github.com/pingcap/tidb).

TiKV is a graduate project of the [Cloud Native Computing Foundation](https://www.cncf.io/) (CNCF).


Now, what is a coprocessor, and why do we need it?

A key-value store usually has a very simplistic API with `GET(key)`, `PUT(key, value)`, and `DELETE(key)` requests.
This API is very general and works quite well, especially in a distributed setting.
Now let's assume you only want to fetch records that fulfill a certain predicate.
You would still need to fetch all data and filter it on your machine.
That's not good, because it

 * requires a lot of network bandwidth
 * doesn't make use of the available hardware resources on the storage server

And because TiKV is used as the storage layer of an SQL-compatible database, these types of operations are very common.
It would be much smarter if we could "push down" these operations to the storage nodes.
And this is exactly what a "coprocessor" makes possible: it provides a defined set of operators (like filters, mappings, count, sum, ...) that can be executed directly on the storage server, like a simplified query engine.
It can even do aggregates, but of course, the individual results of every node need to be combined in the end.
And this is also exactly what TiKV and most other database systems are currently doing.

However, we want to take this one step further.
A few years ago, Google came up with a "pluggable coprocessor" framework for BigTable (see [Jeff Dean's talk at LADIS '09, slide 66-67](https://de.scribd.com/doc/21631448/Dean-Keynote-Ladis2009)).
It's not exposed to the user, so unfortunately you can't use it, but they use it internally.
The idea is that you can deploy *arbitrary* programs that are run directly on storage nodes!
This can save a lot of network bandwidth and utilize the existing hardware resources of storage nodes.
This means that we go from *a fixed set of provided operators* that can be executed on storage nodes to *arbitrary code*.

How does this look like?
You first develop a "coprocessor" that follows a certain interface for the database.
The coprocessor has direct data access (so you have to be careful not to mess things up).
Then you deploy the "coprocessor plugin" to the database.
After it has been activated, you can send requests to the coprocessor, the coprocessor processes the request and returns the desired result.
But because we are dealing with a *distributed* database, you only get results from individual nodes; so you might need to merge them.

For example, you could develop a machine learning coprocessor that can perform distributed training directly in the database.
This gives you a huge speedup!

Later on, [Apache HBase adopted this approach](https://blogs.apache.org/hbase/entry/coprocessor_introduction) and now also provides the possibility to develop custom coprocessors for it.

And now, because of the LFX Mentorship Program, TiKV *also allows you to develop custom coprocessor plugins and deploy them to storage nodes*!



# Workflow and other Stuff

As mentioned before, some projects might have their own application process.
This was also the case for TiKV.
For TiKV, I had to complete one task from a given list and open a pull request with my solution.
It was possible to choose which task I wanted to complete (only one was necessary).
However, because the problems were small and quite fun, I did some more.
This certainly helped for my application as well.

The maintainers did choose the challenges very carefully because all of them were highly relevant for the LFX project later on.
The tasks were actual issues from the TiKV repository and the pull requests were actually merged upstream and deployed into production.
So that was already the first meaningful impact and the program hadn't even started!

I also had to join the [TiKV Slack](https://slack.tidb.io/invite?team=tikv-wg&channel=general).
The maintainers created a specific channel where applicants could ask for help:
How to setup the development environment, how everything works, and so on...
The people were very helpful and responded quickly.

A few days after the application deadline I got an informal private message via Slack that the maintainers decided to accept me.
Of course I was super happy about this! 🎉

At the very beginning, I had a welcome call with my mentors where we talked about the outline and scope of the project.
Throughout the three months of the project, most of our communication and discussion were via Slack or GitHub issues.
This worked exceptionally well for my mentors and me; and as far as I can tell, they were very happy with my work.

During the first week, we created a shared document where we wrote down the individual tasks in more detail based on the [corresponding RFC for the new coprocessor](https://github.com/andylokandy/rfcs/blob/plugin/text/2021-02-24-coprocessor-plugin.md).
I also created a [roadmap issue](https://github.com/tikv/tikv/issues/9747) on GitHub where we could easily keep track of the tasks that have already been finished and the tasks that are still open.
As you can see in the roadmap issue, the project involved opening many PRs, each of them was carefully reviewed.

Overall, I learned quite a lot about dynamic library loading, improved my programming skills with Rust, and deepened my knowledge about databases and distributed systems.
All thanks to my inspiring and helpful mentors [Andy Lok](https://github.com/andylokandy) and [Alex Chi](https://github.com/skyzh)!

All in all, I can highly recommend the LFX Mentorship Program and TiKV to everyone!

Oh, and the best part of all: **It just feels great to contribute to awesome open-source projects and become part of the community!**
