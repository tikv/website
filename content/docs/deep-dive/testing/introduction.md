---
title: Testing
weight: 9
menu:
    docs:
        parent: Deep Dive
        weight: 9
---

Testing is a crucial part of any large software project, and a distributed system like TiKV is designed to exist and function under many failure scenarios and degraded states, this dramatically increases testing surface. These states also must be tested in addition to the normal testing done on a project.

In futher sections we'll investigate how we can test distributed systems even with these nearly infinite variables affecting our system state. For now, let's investigate the basics required for almost every project. These simple tests form the foundation for many later tests, and can be run millions of times over the life of a project.

Often, these test are written before or alongside the code which they test, and they're used to guide the development process.

## Unit testing

TiKV includes many unit tests that are run using `cargo test`. These tests typically involve simple functionality and are tested using assertions.

These tests are most useful for testing expected errors (eg trying to open a config file that doesn't exist), and ensuring operations succeed given the correct initial state. These kinds of tests are also very helpful in testing for regressions in bugs that other testing methods have found.

Unit tests are notably able to test project internals. Unlike other testing methods which test the project as a *consumer* of it, unit tests allow you to make assertions about the internal state normally hidden from consumers of your project.

Many languages, like Rust, offer built in unit testing functionality:

```rust
#[test]
fn can_initialize_server() -> Result<(), Error> {
    let server = Server::new(Config::default())?;
    assert_eq!(server.private_field, true);
    Ok(())
}
```

One potential danger of unit tests is that it's very easy to accidently modify private fields, or call private functionality that a dependant project might not be able to use. When testing functionality covering more than a few functions, or more than one module, integration tests are more well suited.

## Integration testing

Projects like TiKV are used as components in larger infrastructure. When doing more complete, functional testing, integration tests offer an easy way to test public functionality of a project.

In Rust, integration tests can also exist as documentation, this means that it's possible to document your project and benefit from a full test suite at the same time.

```rust
/// Create a server with the given config
/// 
/// ```rust
/// let server = Server::new(Config::default()).unwrap();
/// ```
struct Server { /* ... */ }
```

These kinds of tests are useful for ensuring that a consumer of the project will be able to use it correctly. Having an documentation test suite that demonstrates how a consumer is expected to use the project is especially useful for determining functionality, API, or compatability breakage. These kinds of tests eliminate most trivial unit tests while making them worthwhile to write, since they will be readily used by people to learn the project.

While documentation-based integration tests cover *usability* and *functionality*, they're not always suited for testing corner cases or workloads. Rust's built in integration tests are most well suited to this task.

The [Rust Book](https://doc.rust-lang.org/book/ch11-01-writing-tests.html) has a great chapter on how to write tests in Rust, and which testing strategies are appropriate for which problems.

## Going further

Unit tests and integration tests cover the basics, but even with a comprehensive test suite there can be cases neglected, forgotten, or not even realized possible.

Here's just a few of the situations that can happen:

* A node disappears and is replaced by a new node at the same IP
* Messages between one node and another are simply lost
* The network partitions a cluster into two or more groups
* A network link becomes overloaded, and messages start to queue and eventually fail
* An expected service dependency suddenly disappears
* Thead scheduling and poor memory management leads to data integrity issues

Even this small list offers a nearly endless testing surface. It's not practical to test every possibility. Worse, many of these cases are very difficult to setup in a test.

In the rest of this chapter, we'll investigate how we can overcome this problem by using tools inject a variety of failures, introduce chaos to networks or other I/O, or introduce other chaos to tests.
