---
title: Contribute to TiKV
description: How to contribute code for TiKV
menu:
    docs:
        parent: Contribute
        weight: 1
---

Thanks for your interest in contributing to TiKV! This document outlines some of the conventions on building, running, and testing TiKV, the development workflow, commit message formatting, contact points and other resources.

## Set up a development workspace

TiKV is mostly written in Rust, but has components written in C++ (RocksDB) and Go (gRPC). We are currently using the Rust nightly toolchain. To guarantee consistency in coding style, we use linters and automated formatting tools.

### Prerequisites

To build TiKV you'll need to at least have the following installed:

* `git` - Version control
* [`rustup`](https://rustup.rs/) - Rust installer and toolchain manager
* `make` - Build tool (run common workflows)
* `cmake` - Build tool (required for gRPC)
* `awk` - Pattern scanning/processing language

If you are targeting platforms other than x86_64 linux, you'll also need:

* [`llvm` and `clang`](http://releases.llvm.org/download.html) - Used to generate bindings for different platforms and build native libraries (required for grpcio, rocksdb).

### Get the repository

```
git clone https://github.com/tikv/tikv.git
cd tikv
# Future instructions assume you are in this directory
```

### Configure your Rust toolchain

`rustup` is the official toolchain manager for Rust, similar to `rvm` or `rbenv` from the Ruby world.

TiKV is pinned to a version of Rust using a `rust-toolchain` file. `rustup` and `cargo` will automatically use this file. We also use the `rustfmt` and `clippy` components, to install those:

```bash
rustup component add rustfmt
rustup component add clippy
```

### Build and test

TiKV includes a `Makefile` with common workflows. You can also use `cargo`, as you would in many other Rust projects.

At this point, you can build TiKV:

```bash
make build
```

During interactive development, you may prefer using `cargo check`, which will parse, borrow check, and lint your code, but not actually compile it:

```bash
cargo check --all
```

`cargo check` is particularly handy alongside `cargo-watch`, which runs a command each time you change a file.

```bash
cargo install cargo-watch
cargo watch -s "cargo check -all"
```

When you're ready to test out your changes, use the `dev` task. It formats your codebase, builds with `clippy` enabled, and runs tests. This should run without failure before you create a PR. Unfortunately, some tests might fail intermittently and others don't pass on all platforms. If you're unsure, just ask!

```bash
make dev
```

You can run the test suite alone, or just run a specific test:

```bash
# Run the full suite
make test
# Run a specific test
cargo test $TESTNAME
```

### Build issues

To reduce compilation time, TiKV builds do not include full debugging information by default &mdash; `release` and `bench` builds include no debuginfo; `dev` and `test` builds include line numbers only. The easiest way to enable debuginfo is to precede build commands with `RUSTFLAGS=-Cdebuginfo=1` (for line numbers), or `RUSTFLAGS=-Cdebuginfo=2` (for full debuginfo). For example,

```bash
RUSTFLAGS=-Cdebuginfo=2 make dev
RUSTFLAGS=-Cdebuginfo=2 cargo build
```

When building with `make`, cargo automatically uses [pipelined][p] compilation to increase the parallelism of the process. To turn on pipelining while using cargo directly, set `CARGO_BUILD_PIPELINING=true`.

[p]: https://internals.rust-lang.org/t/evaluating-pipelined-rustc-compilation/10199

## Contribution flow

This is a rough outline of what a contributor's workflow looks like:

1. Create a Git branch from where you want to base your work. This is usually the master branch.
2. Write code, add test cases, and commit your work (see [message format](#format-of-the-commit-message)).
3. Run tests and make sure all tests pass.
4. Push your changes to a branch in your fork of the repository and submit a pull request.
5. Your PR will be reviewed by two maintainers (who may request some changes).
6. Our CI systems automatically test all the pull requests.

## Finding something to work on

For beginners, we have prepared many suitable tasks for you. Check out our [Help Wanted issues](https://github.com/tikv/tikv/issues?q=is%3Aissue+is%3Aopen+label%3A%22S%3A+HelpWanted%22) for a list, in which we have also marked the difficulty level.
See below for some commonly used labels:

- **`D:EASY`** - Difficulty: Easy. Ideal for beginners, with mentoring available. 
- **`D:Medium`** - Difficulty: Medium. You need some kind of understanding of several components to work on this. 
- **`D:Mentor`** - This issue is currently mentored. 
- **`S:HelpWanted`** - Status: Help wanted. Contributions are very welcome!
- **`C:*`** - Component labels that indicate the component in question. For example, **`C:Raft`** indicates Raft, RaftStore, etc.
- **`S:Discussion`** - Status: Under discussion or need discussion

If you are planning something big, for example, relates to multiple components or changes current behaviors, make sure to open an issue to discuss with us before going on.

The TiKV team actively develops and maintains a bunch of dependencies used in TiKV, which you may be also interested in:

- [rust-prometheus](https://github.com/pingcap/rust-prometheus): The Prometheus client for Rust, our metrics collecting and reporting library
- [rust-rocksdb](https://github.com/pingcap/rust-rocksdb): Our RocksDB binding and wrapper for Rust
- [raft-rs](https://github.com/pingcap/raft-rs): The Raft distributed consensus algorithm implemented in Rust
- [grpc-rs](https://github.com/pingcap/grpc-rs): The gRPC library for Rust built on the gRPC C Core library and Rust Futures
- [fail-rs](https://github.com/pingcap/fail-rs): Fail points for Rust

## Follow the styles

There are three  categories of styles involved while coding for TiKV. Please follow these styles to make TiKV easy to review, maintain, and develop.

#### Rust community coding style

TiKV follows the Rust community coding style. We use Rustfmt and [Clippy](https://github.com/Manishearth/rust-clippy) to automatically format and lint our code. Using these tools is checked in our CI. These are included as a part of the `make dev` task. You can also run them alone:

```bash
# Run Rustfmt
cargo fmt --all
# Run Clippy (note that some lints are ignored, so `cargo clippy` will give many false positives)
make clippy
```

See the [style doc](https://github.com/rust-lang/rfcs/blob/master/style-guide/README.md) and the [API guidelines](https://rust-lang-nursery.github.io/api-guidelines/) for details on the conventions.

#### Code comment style

Well-written code comments can speed up the reviewing process improve the development efficiency of the whole team, and make the code easier to maintain. We follow a [Code Comment Style](https://github.com/tikv/tikv/blob/master/CODE_COMMENT_STYLE.md)that has been tailed for the Rust language.

#### Format of the commit message

We follow a rough convention for commit messages that is designed to answer two questions: what changed and why. The subject line should feature the what and the body of the commit should describe the why.

```
engine/raftkv: add comment for variable declaration.

Improve documentation.
```

The format can be described more formally as follows:

```
<subsystem>: <what changed>
<BLANK LINE>
<why this change was made>
<BLANK LINE>
Signed-off-by: <Name> <email address>
```

The first line is the subject and should be no longer than 50 characters, the other lines should be wrapped at 72 characters (see [this blog post](https://preslav.me/2015/02/21/what-s-with-the-50-72-rule/) for why).

If the change affects more than one subsystem, you can use comma to separate them like `util/codec,util/types:`.

If the change affects many subsystems, you can use ```*``` instead, like ```*:```.

The body of the commit message should describe why the change was made and at a high level, how the code works.

