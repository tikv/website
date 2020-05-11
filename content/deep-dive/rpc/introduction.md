---
title: Remote Procedure Calls (RPC)
aliases: ['/docs/deep-dive/rpc/introduction']
menu:
    nav:
        parent: Deep Dive
        weight: 6
---

Communication between services occurs over remote procedure calls. RPCs happen
all the time in distributed systems. To obtain a webpage, your browser has to make at
least one RPC to this website.

TiKV, as a distributed system involving a number of nodes, uses RPCs to
communicate between nodes, as well as the Placement Driver and clients.

As it turns out, exposing functionality as a remote interface isn't a trivial.
Networks are unreliable, systems are diverse and evolving, a huge variety of
languages and formats exist, and even things like encoding are hard!

## On the shoulders of giants

Over the past decades the field of computing has largely settled on a few common
standards.

### Network Protocols

The vast majority of services work over the HTTP or HTTP/2 network protocols.
This solves problems such as:

* [URIs]
* [Sessions]
* [Status Codes] (e.g. 404 Not Found)
* [Methods] (e.g. GET, POST, PUT)
* [Headers] (e.g. Authorization, User-Agent)
* [Pipelining]

TiKV uses **HTTP/2**. HTTP/2 is more performant and capable than HTTP/1 for TiKV uses.

### Interfacing

With those abilities supported, there remains a need to work with structures of
data. Commonly this ends up being an *interface description language* format
like [Protocol Buffers] (protobufs), which TiKV uses. Unlike an *interchange*
*format*, an *interface description language* allows for the definition of
services and RPCs in addition to just data interchange. This solves the
following problems:

* [Encoding] (ASCII? UTF-8? UTF-16? WTF-8?)
* Serialization/Deserialization format (Text-to-`struct` and vice versa)
* Backward/Forward compatibility (e.g. Structure fields changing, being added, removed)
* Service & RPC definition

### Wrapping it all together

Simply having the pieces is not enough. Making it usable for all parties
involved is another story. [gRPC] does a great job wrapping
up the above technologies and providing usable interfaces.

Over the next chapter, we'll look at each of these technologies and how they work.

[gRPC]: https://grpc.io/
[Encoding]: https://en.wikipedia.org/wiki/Character_encoding
[Protocol Buffers]: https://developers.google.com/protocol-buffers/
[URIs]: https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
[Sessions]: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP_session
[Status Codes]: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
[Methods]: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods
[Headers]: https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
[Pipelining]: https://en.wikipedia.org/wiki/HTTP_pipelining