---
title: Documentation quest!
date: 2020-09-04
author: Nick Cameron
tags: ['Transactions', 'Community']
---

The [TiKV Transactions SIG](https://tikv.org/community/sig-transaction/)'s documentation quest begins today! It is our first community activity. There are tons of bite-size tasks and some more involved work, with the goal of making TiKV's transaction components well-documented, easy to understand, and a go-to resource for learning how to implement distributed transactions.

![Zelda pixel art](/blog/zelda.png)

Well-documented code is a joy to work with. Figuring out what undocumented code does is harder and takes longer, and you're more likely to miss some detail which causes a bug later on.

TiKV's transaction code is not well-documented. We've been working to improve that, and we're asking the community to help make it even better. I find writing docs a great way to learn about a codebase, so I hope the documentation quest will be useful as a learning experience for our questing contributors. We have experts on-hand to help you understand the code and to check that new documentation is correct.

If you want to learn about distributed transactions and their implementation in TiKV, and write up what you learn, then please join us on our quest! The kind of documentation we want to write is covered in [sig-transaction/25](https://github.com/tikv/sig-transaction/issues/25). We want to have high-level overviews of the transaction protocols, module-level documentation of major concepts in implementation, and code comments anywhere it might be helpful. Our goals are not limited to that list though, if you find anywhere that is poorly documented, we want docs there! You can write some documentation and send a PR, or add a request to the [issue](https://github.com/tikv/sig-transaction/issues/25).

We want to write three kinds of documentation: docs on the high-level concepts, module-level docs, and type/function-level docs.

The concepts docs should cover the algorithms and ideas of distributed transactions in general, such as what they can achieve, how 2pc works and why it is necessary, and how the TiDB/TiKV transaction protocol works. It's also a good place for documenting parts of the implementation which cover cover multiple, disjoint modules. We'd love to have documentation in English, Chinese, and any other language which is useful for our community. These docs should live in the the sig-transaction repo.

Module-level docs should cover the high-level view of what is in a module and how it works. For example, what the main algorithms are and how the important types and sub-modules have a role in those algorithms. Having an overview of how data flows around components is often useful. It is also a good place to cover invariants which involve multiple types (e.g., which states of the whole system are valid/invalid, and where the boundaries are where validity is checked), alternatives which have been tried or considered (and why they were not used), and performance or correctness concerns which must be considered when extending or changing the module.

Comments on types and functions should tell you things that the code doesn't. For complex functions or types that might include *what* it does. That's often not necessary for smaller/simpler items (`/// Returns a foo` on `fn get_foo` is just noise). Sometimes *how* something works is useful, again only when it is not obvious from the code. Good documentation often include pre- and postconditions, side-effects, footguns, performance considerations, alternatives (and when an item should not be used), examples, and *why* code is the way it is.

If you have any questions at all, you can ask on [sig-transaction/25](https://github.com/tikv/sig-transaction/issues/25), or on Slack. @sticnarf, @youjiali1995, and I (@nrc) are dedicated mentors for the documentation quest; we're happy to answer questions and review PRs (please @-mention us on any PRs you submit so that we can get them reviewed quickly).

I'm extremely excited about this work! I'm looking forward to writing some docs and to seeing what others come up with. I really hope we can make TiKV into a project that people use as example of 'well-documented', and which people go to to learn about distributed systems.

Please join us on our quest!

![Pixel art rupees (gems)](/blog/rupees.png)
