---
title: Consensus algorithm
menu:
    nav:
        parent: Deep Dive
        weight: 2
---

When building a distributed system, one principal goal is to build in fault-tolerance. That is, if one particular node in the network goes down, or if there is a network partition, the system should continue to operate in a consistent way, i.e., nodes in the system should have a consensus on the state (or simply "values") of the system. The consensus should be considered final once it is reached, even if some nodes were in faulty states at the time of decision.

Distributed consensus algorithms often take the form of a replicated state machine and log. Each state machine accepts inputs from its log, and represents the value(s) to be replicated, for example, a change to a hash table. They allow a collection of machines to work as a coherent group that can survive the failures of some of its members.

Two well known distributed consensus algorithms are [Paxos](https://lamport.azurewebsites.net/pubs/paxos-simple.pdf) and [Raft](https://raft.github.io/raft.pdf). Paxos is used in systems like [Chubby](http://research.google.com/archive/chubby.html) by Google, and Raft is used in systems like [TiKV](https://github.com/tikv/tikv) or [etcd](https://github.com/coreos/etcd/tree/master/raft). Raft is generally seen as a more understandable and simpler to implement than Paxos.

In TiKV we harness Raft for distributed consensus. We found it much easier to understand both the algorithm, and how it will behave in even truly perverse scenarios.

