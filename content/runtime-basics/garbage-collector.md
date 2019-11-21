---
title: "Garbage Collector"
section: "Runtime Basics"
menu:
  toc:
    parent: "runtime-basics"
    weight: 10
toc: true
---

Pony uses a fully concurrent garbage collector called ORCA (yes, the _killer whale)_, which stands for **O**wnership and **R**eference **C**ounting-based Garbage collection in the **A**ctor World.

Pony-ORCA allows building programs with millions of small, cheap actors as garbage collection occurs fully concurrently. A single actor needs only 256 bytes on 64bit systems and no additional form of synchronization across actors is needed except those introduced through the actor paradigm, i.e. **message send** and **message receive**. Each actor is single-threaded and scheduled to run by the Pony scheduler, but an actor must relinquish control of its thread in order for another actor to use it.

Pony-ORCA is based on ideas from ownership and deferred, distributed, weighted **reference counting**. It adapts actor messaging systems to keep the reference count consistent. The main challenge in concurrent garbage collection is detecting cycles of sleeping actors. With ORCA's message passing, you get deferred direct reference counting, a dedicated actor for the detection of (cyclic) garbage, and a confirmation protocol which lead to the following guarantees.

1. _Soundness_: collects only dead actors.
2. _Completeness_: collects all dead actors eventually
3. _Concurrency_: does not require a stop-the-world step, clocks, timestamps, versioning, thread coordination, actor introspection, shared memory, read/write barriers, or cache coherency

Pony's type system, along its reference capabilities, ensures at compile time that your program can **never have data races**. As well, because Pony has no locks (really), this also means your program is **deadlock-free**! (Though **livelock** is still possible, so be careful.)

An actor can be in a variety of states: alive, blocked, and dead, to name a few. An actor which is currently executing or processing a message from its queue is considered _alive_. When an actor has completed execution and has no pending messages on its queue, it is _blocked_. Only if an actor is itself blocked, and all actors with a reference to it are blocked is the actor considered _dead_.

## Pony-ORCA Characteristics

1. An actor may perform garbage collection concurrently with other actors
2. An actor may garbage collect internally solely based on its own local state; no need for consultation with or inspecting the state of any other actor
3. An actor need not synchronization with other actors during garbage collection
4. An actor may garbage collect between its normal behaviors; it need not wait until its message queue is empty

## ORCA Beyond Pony

ORCA can be applied beyond Pony, provided that the follow requirements are satisfied:

* **Actor behaviors are [atomic](https://www.google.com/search?q=atomic+operation)**: a behavior appears to the rest of the system to be one uninterrupted action
* **Message delivery is [causal](https://www.google.com/search?q=causal+messaging+definition)**: a message arrives before any future messages it caused, provided the messages have the same destination.

### Further reading

* [Orca: GC and Type System Co-Design for Actor Languages](https://www.ponylang.io/media/papers/orca_gc_and_type_system_co-design_for_actor_languages.pdf)