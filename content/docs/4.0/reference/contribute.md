---
title: Contribute
description: How to be a part of TiKV
menu:
    "4.0":
        parent: Reference
        weight: 6
aliases:
    - /docs/3.0/contribute/contribute-to-tikv/
---

As an open source project, TiKV cannot grow without support and participating of contributors from the community. If you would like to contribute to the TiKV code, our documentation, or even the website, we would appreciate your help. And we are glad to provide any support along the way.

## How to be a TiKV Contributor

If a PR (Pull Request) submitted to the TIKV related projects by you is approved and merged, then you become a TiKV Contributor.

## Pick an area to contribute

You can choose the one of the following areas to contribute:

- [TiKV core](https://github.com/tikv/tikv)

    This is where we host the core code base of the TiKV project, which is developed in Rust. See [Contribute to TiKV](https://github.com/tikv/tikv/blob/master/CONTRIBUTING.md) for details on how to make contributions to the TiKV core code base.

- [TiKV documentation](https://github.com/tikv/website/tree/master/content/docs)

    We host our documentation within the [TiKV website] repository. The documentation is generated via the Hugo framework. See [Contribute to Docs](../docs) for detailed steps of contribution.

- Libraries

    The TiKV team actively develops and maintains a bunch of dependencies used in TiKV, which you may be also interested in:

    - [rust-prometheus](https://github.com/pingcap/rust-prometheus): The Prometheus client for Rust, our metrics collecting and reporting library
    - [rust-rocksdb](https://github.com/pingcap/rust-rocksdb): Our RocksDB binding and wrapper for Rust
    - [raft-rs](https://github.com/pingcap/raft-rs): The Raft distributed consensus algorithm implemented in Rust
    - [grpc-rs](https://github.com/pingcap/grpc-rs): The gRPC library for Rust built on the gRPC C Core library and Rust Futures
    - [fail-rs](https://github.com/pingcap/fail-rs): Fail points for Rust
    
    For details on how to contribute to the above dependent libraries of TiKV, refer to the **README** file in the corresponding repository.


- [TiKV Clients](https://github.com/tikv)

    This is where we host TiKV clients in different languages, which are:

    - [Go client](https://github.com/tikv/client-go)
    - [Rust client](https://github.com/tikv/client-rust)
    - [Java client](https://github.com/tikv/client-java)
    - [C client](https://github.com/tikv/client-c)

    As the Go client came out the earliest, it has evolved into a stable shape. Clients like Rust and Java are not stable enough, while client C is still in early development phase, which is a good timing to get yourself involved with the development of TiKV clients. See [Contribute to TiKV](https://github.com/tikv/tikv/blob/master/CONTRIBUTING.md) for details on how to make contributions to the TiKV clients.

- [RFCs](https://github.com/tikv/rfcs)

    This is where the design process of a new feature starts. If you wish to contribute something major or substantial to TiKV, we would love to see that and will ask you to submit a Request for Change (RFC) to generate a consensus among the TiKV community. See the [README](https://github.com/tikv/rfcs/blob/master/README.md) file and existing RFCs for references on how to draft and submit an RFC.

- Meetups/Events

    As an open source project, we are passionate about meetups and events, where the community gather and share. Besides the official events hosted by TiKV, we would love to see you be the organizer or the participant of an event/meetup. Showing up, giving a talk, or joining in the discussions would all be a form of contribution in our eyes, and we appreciate that. Let us know if you have any ideas.

## Find an issue to work on

For beginners, we have prepared many suitable tasks for you. You can check out, for example, our [Help Wanted issues](https://github.com/tikv/tikv/issues?q=is%3Aissue+is%3Aopen+label%3A%22S%3A+HelpWanted%22) in the TiKV repository.

See below for some commonly used labels across major repositories listed in [Pick an area to contribute](#pick-an-area-to-contribute):

- **`bug`** Something is wrong; can be small or big in scope
- **`good first issue`** - An ideal first issue to work on for beginners, with mentoring available
- **`help wanted`** - Help wanted. Contributions are very welcome!
- **`discussion`** - Status: Under discussion or need discussion
- **`enhancement`** New feature or request
- **`question`** Further information is requested, or the question is to be answered.

## Ask a question

{{< info >}}
If you need any help or mentoring getting started, understanding the codebase, or making a PR (or anything else really), please ask on [Slack](https://join.slack.com/t/tikv-wg/shared_invite/enQtNTUyODE4ODU2MzI0LTgzZDQ3NzZlNDkzMGIyYjU1MTA0NzIwMjFjODFiZjA0YjFmYmQyOTZiNzNkNzg1N2U1MDdlZTIxNTU5NWNhNjk), or [WeChat](https://github.com/tikv/tikv#wechat).
{{< /info >}}