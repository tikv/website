---
title: NodeJS Client and CNCF LFX Mentorship Experience
date: 2021-11-24
author: Jiaxiao Zhou (Mossaka)
tags: ['Community', 'CNCF', 'NodeJS', 'Rust', 'Client']
---



## The project

The goal of the '21 summer TiKV LFX mentorship project is to implement a client library for TiKV using in NodeJs. TiKV client has existing [clients](https://tikv.org/docs/3.0/reference/clients/introduction/) for these languages: [C](https://github.com/tikv/client-c), [Python](https://github.com/tikv/client-py), [Go](https://github.com/tikv/client-go), [Rust](https://github.com/tikv/client-rust), and [Java](https://github.com/tikv/client-java). Among these clients, the clients for Go and Rust are the most stable, actively developed and feature-complete. The clients for C and Python are thin wrappers of the Rust client using Rust's [Foreign Function Interface](https://doc.rust-lang.org/nomicon/ffi.html). The ask of this project is to implement a similar thin wrapper using Nodejs.

## What's TiKV?

Before we dive into the technical details of how the NodeJS client is implemented, I want to briefly  introduce TiKV. There are more than a [hundred](https://dbdb.io/browse?data-model=keyvalue) distributed Key-Value databases. Arguably, some of the most famous ones are Etcd, Hbase, Redis, and TiKV. They all support a very simple abstraction over the data they internally stores and operators like query and update. What makes TiKV stand out from the rest of them is that it supports distributed transactions with ACID properties, inspired by the [Google Spanner](https://research.google/pubs/pub39966/) and F1 engine. The support of database transaction protocol makes developing applications on TiKV much more delightful and easier to reason about. Internally, TiKV replicates records using Raft groups geographically for fault-tolerance and persists data using RocksDB instances for durability. It is wroth to mention that TiKV is a CNCF graduated [project](https://www.cncf.io/announcements/2020/09/02/cloud-native-computing-foundation-announces-tikv-graduation/) and it is open source under the Apache 2.0 license. 

## What does Rust client do?

Since my task was to implement a Nodejs client on top of the exiting Rust client, I am motivated to explain what rust client provide to us in the first place. Like any [client-server architecture](https://en.wikipedia.org/wiki/Client%E2%80%93server_model), the Rust client allows users to connect to the TiKV clusters using either the Raw API or Transaction API. The difference between the two is that the former one provides simple query-update operations while the other provides transactional operations. Below is a simple example that uses the `TransactionClient`.

```jsx
use tikv_client::TransactionClient;

let txn_client = TransactionClient::new(vec!["127.0.0.1:2379"], None).await?;
let mut txn = txn_client.begin_optimistic().await?;
txn.put("key".to_owned(), "value".to_owned()).await?;
let value = txn.get("key".to_owned()).await?;
txn.commit().await?;
```

I will skip how to setup local cluster and install Rust client. You may find the official startup help [page](https://github.com/tikv/client-rust/blob/master/getting-started.md) to be helpful. One thing to notice is that the API is written in async syntax, the client does provide a synchronous API though. A side story - I took a whole week to learn asynchronous programming in Rust, such a wild ride and I believe it worth another blog post. The one biggest surprise of Rust's implementation of async is that there is no built-in runtime (see [here](https://rust-lang.github.io/async-book/01_getting_started/02_why_async.html#:~:text=Async%20in%20Rust%20vs%20other%20languages&text=Rust's%20implementation%20of%20async%20differs,make%20progress%20only%20when%20polled.&text=No%20built%2Din%20runtime%20is,provided%20by%20community%20maintained%20crates.)). A  runtime, which maintained by the community, is needed when you want to use the client. Theoretically, the implementation of the client can be independent of the async runtime, but the async ecosystem for Rust is still maturing and the current supported async runtime in Rust client is [Tokio](https://github.com/tokio-rs/tokio). You can read more about the API in this [documentation](https://github.com/tokio-rs/tokio). I personally found this syntax to be extremely familiar and simple to use. I can get started within an minutes, so kudos to the client [team](https://github.com/tikv/client-rust/graphs/contributors) on this. 

Hopefully now you have a basic understanding of what the TiKV Rust client does. Two questions remain unanswered - why do we want to develop Nodejs client on top of the Rust client and how to do that exactly? To answer the first question, we will need think outside of the technical world. The client team started the Rust client about 3 years ago from scratch, gradually adding new features and always set to be the highest standard across all 3 existing clients at that time (see [2021 plan](https://github.com/tikv/client-rust/discussions/272)).  Yes, TiKV already had 2 other clients when Rust client first started, in Java and Go respectively. All clients were developed in parallel. From an resource management point of view, the number of engineers and the amount of development time and resources are linear to the number of active projects. Thus adding one more client means that there is a huge engineering cost associated with it. Besides the benefits of sharing the same codebase and making it hard to be inconsistent, there is a real economic benefit to develop the new Nodejs client on top of the Rust client. 

## Language interoperability

To answer the second question, we need to introduce a few new concepts: language interoperability and foreign function interface (FFI). According to [wikipedia](https://en.wikipedia.org/wiki/Language_interoperability), language interoperability refers to the ability that two programming languages can operate on the same shared data structure. This description alone implies that we need to find some "common denominator" of the two language. If the two languages operate on the same runtime environment, like Clojure and Java on Java Virtual Machine, then the common denominator is the VM's memory model. The two languages can be compiled to a intermediate language that uses the memory model the VM understands. If not, in the case of Rust and C, then we need to pay more attention to bridging the gap of the different memory models the two language use. There are a lot of [engineering ingenuity](https://flameeyes.blog/2012/03/07/why-foreign-function-interfaces-are-not-an-easy-answer/) to make this work. For example, just think about how Rust's string representation could be modeled as that of C, they are completely different: C specifies null terminator at the end of the string and Rust does not. Fortunately, the community has contributed to various language bindings to C's `libffi`. For example, Rust already has a `std::ffi` crate that binds Rust types to C's. You can use `CString` to represent a owned, null-terminated C string. Further, you can use procedure macros to make sure that your Rust executable can be linked with C in runtime. Below is a simple example that exposes a Rust function:

```rust
use std::ffi::{CStr,CString};
#[no_mangle]
pub extern "C" fn rust_function() {
	let value = CString::new("world!").expect("CString::new failed");
}
```

 I won't go into the details of how this would work but the curious reader can learn everything how Rust FFI works from this great [book](https://doc.rust-lang.org/nomicon/ffi.html). 

The same language intermobility concept we described above also applies to C and Nodejs. There is a Nodejs' binding to C called `node-ffi`. With this binding, the two languages can call each other natively in runtime. Remember, I want to write a Nodejs client on top of the Rust client. With the knowledge we built, let's rephrase my goal a bit. I want to expose the Rust client functions as a C API, and then dynamically link the Rust executable with Nodejs's FFI.  In this case, Nodejs is the host language, and Rust is the guest language. There are many articles and tutorial online on related topic. See this [article](https://blog.logrocket.com/rust-and-node-js-a-match-made-in-heaven/). As for my task, I chose not to reinvent the wheel and leveraged on the existing open-source tools to help me achieve this goal. 

## Entering Neon

[Neon](https://github.com/neon-bindings/neon) is an open-source Rust bindings for Nodejs. It allows me to use JavaScript types within Rust. Here is a simple Neon program

```rust
use neon::prelude::*;

fn hello(mut cx: FunctionContext) -> JsResult<JsString> {
    Ok(cx.string("hello node"))
}

#[neon::main]
fn main(mut cx: ModuleContext) -> NeonResult<()> {
    cx.export_function("hello", hello)?;
    Ok(())
}
```

This program exposes a Rust function named "hello", which takes a `FunctionContext` and returns a `JsResult<JsString>`. The function context is a control stack that manages memory and throws exception if needed. It also protects a pointer to a JavaScript value that is managed by JavaScript's garbage collector, making sure that the value's lifetime is valid during Rust's interaction with it. In the above example, `cx.string("hello node")` is a pointer (aka Handle) to an owned JavaScript string, represented as `JsString` in Rust. 

After the program is compiled to a exeuctable "index.node", we can load it in nodejs runtime and call function "hello" like below: 

```
$ npm install
$ node
> require('.').hello()
"hello node"
```

This is really nice, right? You can learn more about Neon in their official [documentation](https://neon-bindings.com/docs/hello-world). They wrote a few [examples](https://github.com/neon-bindings/examples) that I personally think very helpful. I also found that their Slack community is extremely friendly and welcoming.

## Repo structure

I first started writing Rust wrappers on Raw client - a low level API for querying/updating individual key-value pairs. The NodeJS client has a dependency on Rust client because that's one of the benefits using Neon - to reuse the code in Rust client. 

The `client-node` repo structure looks like this:

```rust
├── Cargo.lock
├── Cargo.toml
├── index.node
├── package.json
├── src
    └── lib.rs
		... 
├── tikv_client
		└── index.js
```

The `[lib.rs](http://lib.rs)` implements the main logic that exposes the client functionalities. In each client method, the program parses all function arguments and pass them to native rust-client function. Then returns the result. Here is the an example:

```rust
pub fn put(mut cx: FunctionContext) -> JsResult<JsUndefined> {
	  let client = cx
	      .this()
	      .downcast_or_throw::<JsBox<RawClient>, _>(&mut cx)?;
	  let key = cx.argument::<JsString>(0)?.value(&mut cx);
	  let value = cx.argument::<JsString>(1)?.value(&mut cx);
	  let cf = cx.argument::<JsString>(2)?.value(&mut cx);
	  let callback = cx.argument::<JsFunction>(3)?.root(&mut cx);
	
	  let inner = client.inner.with_cf(cf.try_into().unwrap());
	  let channel = cx.channel();
	
	  RUNTIME.spawn(async move {
	      let result = inner.put(key, value).await;
	      send_result(channel, callback, result);
	  });
	
	  Ok(cx.undefined())	
}
```

The first variable "client" saves a pointer to the Client object living in the heap. It is a pointer to `JsBox`. The variables "key", "value", "cf" are string typed parameters required to call `put` method on rust client. The "callback" is the last parameter, also a function, for sending callbacks. The "inner" variable is the rust-client struct, which is initialized with the configuration. The "channel" variable provides a channel for sending events back to JavaScript. Then it uses a async runtime to drive spawn a new thread, and asynchronously calls the `put` method from rust-client, saves the result to "result" variable, and send it back to JavaScript channel. 

There are a lot to unpack from the above example. Before I talk about the details, let me show what the corresponding function in JavaScript looks like

```jsx
put(key: string, value: string, cf: string) {
  return put.call(this.boxed, key, value, cf);
}
```

The above JavaScript code a simple wrapper for `put` function, specifies all the arguments needed and passes them to the native Rust client `put_async` function. It does not have any logic of doing the actual work. Below is a usage example when the library is loaded to Nodejs:

```jsx
(async () => {
  const client = await new tikv.RawClient("127.0.0.1:2379");
  await client.put("k1", "v1", "default");
})();
```

To summarize, the runtime workflow starts with user's code using Nodejs client. Then the JavaScript code passes arguments to Rust executable using C FFI bindings. The Rust executable then converts JavaScript types to Rust types and passes the parameters to TiKV Rust client, its dependency. The Rust client then make a service call to the TiKV cluster, and desterilizes the result and return back to the Rust executable routine. The routine then converts the result to JavaScript type, and returns back to Nodejs client. Lastly, the Nodejs client returns the result back to user's application code. 

Since the Nodejs client does not implement any complex logic that does the service call, we call it a thin wrapper of the Rust client. 

## Challenges

When I started writing Nodejs client using Neon, I was facing this major challenge:

- How to convert structs in Rust to classes in JavaScript?

To provide an idiomatic JavaScript client to users, we designed the client to be a class and CRUD operations to be it's methods. In Rust, there is no notion of classes. Instead, rustaceans (people who use Rust) use struct and traits to replace objects and inheritance (See [here](https://doc.rust-lang.org/book/ch17-03-oo-design-patterns.html)). Then how can I define JavaScript classes in Rust?  I struggled on this question for a while, and decided to join the Slack channel and ask questions. One of the maintainers of Neon quickly replied, and pointed me to this [sample](https://github.com/neon-bindings/examples/blob/main/examples/async-sqlite/src/lib.rs). Then I realized I could use `Jsbox` , a smart pointer to refer to an object allocated in heap in JavaScript, which allows me to call methods defined on this shared data structure. 

```rust
pub struct RawClient {
    inner: Arc<tikv_client::RawClient>,
}

impl Finalize for RawClient {}
```

I defined a `RawClient` struct, which contains a inner reference to the rust-client `RawClient`, and implement the Finalize trait, which is needed and the `finalize` will be called before the object is garbage collected. 

In `connect` method, I pass the configuration parameters to inner connect method, and then receive a client struct back. Then I return the client as 

```rust
cx.boxed(RawClient { inner: Arc::new(client) })
```

`cx` is a FunctionContext, and JavaScript can reference this client. The following is the corresponding idiomatic implementation of `RawClient` class in JavaScript. 

```jsx
const {connect, put} = require('./index.node');

class RawClient {
    connect(config) { this.boxed = connect(config) }
    put(key, value, cf) { return put.call(this.boxed, key, value, cf) }
}
```

Notice how it saves the reference to boxed client object in `this.boxed` and passes it to rust `put` method. This way, the put method in Rust can get a reference to the client, and operate on it accordingly. 

```rust
pub fn put(mut cx: FunctionContext) -> JsResult<JsUndefined> {
    let client = cx.this().downcast_or_throw::<JsBox<RawClient>, _>(&mut cx)?;
		// do something with client
}
```

This construct provides a shared data structure in heap that both Rust and JavaScript could operate on, and minimizes the JavaScript wrapper code as much as possible. So I am very happy that this idea perfectly solves my problem.

## My thoughts

Alright that's enough of technical talk and now I want to briefly share my experience on the mentorship program. My early career at Microsoft focused on developing proprietary products. This is really the first time that I've contributed to a large open source and community maintained project. Because of this, I was able to collaborate with engineers outside of my employer and share insights in the field. Calling out to my great mentor [Andy Lok](https://github.com/andylokandy), who had helped me a lot in early designing and unblocking work items, and we had great talks about distributed systems, programming languages and coding. I was even more inspired to learn that he is a core maintainer for Idris, which is a cool dependently typed language and hopefully I will learn it one day. 

Back to the open source development experience. Compare with my career, there are a lot differences. For example, It is unimaginable for me to develop a completely new project on my own pace when I participated the CNCF TiKV mentorship. The amount of flexibility on project management, choosing the tools and communication with my mentor is unparallel. I've gone through a complete end-to-end project lifecycle, from designing the client, to choosing the right technologies, to the real implementation and finding ways to unblock myself, and finally to the release of the client to npm. More importantly, I own my work. Near the end of my mentorship journey, I told my Andy that I wanted to be a long-term contributor to TiKV. That is, I want to keep updating the NodeJS client with new features, track GitHub issues and review pull requests, and potentially even increase my scope to other TiKV clients. This sense of responsibility and attachment naturally comes from my initial efforts that establish this new project, and surely it trained me to be a better developer, and a more confident contributor to open source projects. At the end, TiKV community rewards my effort by [promoting](https://github.com/tikv/community/pull/148) me to become a official reviewer for the project. 

One specific challenge around open source projects, and I struggled a lot is losing track of progress or procrastination in general. This is not a new topic and a lot time management researches and books pointed out methods and practices to become better at it. Personally, I found discipline and consistency are the most important traits to become a good open source contributor, due to the fact that there is no tight deadlines or people who pushed me to complete work items. I tried and failed many times to at least code or learn something at least half an hour every day. It is just way easier to give up on the work and becomes surprisingly difficult to pick it up later. So keep this in mind: in open source community, you will be fighting procrastination much more often than your regular work and you must be motivated and passionate at the things you do.

If you are interested in contributing to the TiKV clients, please feel free to reach out to [me](https://github.com/Mossaka) or [Andy](https://github.com/andylokandy). I am looking forward to your feedback and suggestions.

## Reference

1. [https://blog.logrocket.com/rust-and-node-js-a-match-made-in-heaven/](https://blog.logrocket.com/rust-and-node-js-a-match-made-in-heaven/) This blog describes how we can use Rust FFI bindings to and a crate nodejs_sys to write native Nodejs code in Rust!
2. Programming in Rust 2rd teaches how to use C functions directly from Rust, and how to consutrct raw and safe interface for C libraries.
3. This [blog](https://bheisler.github.io/post/calling-rust-in-python/), and [video](https://www.youtube.com/watch?v=1KC43QuJKlE) provides a great resource for learning how to expose Rust API to Python