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

Pony-ORCA allows building programs with millions of actors as garbage collection occurs fully concurrently. A single actor needs only 256 bytes on 64bit systems making them small and cheap. No additional form of synchronization across actors is needed except those introduced through the actor paradigm, i.e. **message send** and **message receive**. Each actor is single-threaded and scheduled to run by the Pony scheduler -- an actor must relinquish control of its thread in order for another actor to use it. An overloaded actor which has not relinquished control for a long time (based on number of messages processed) begins applying backpressue to ensure actor access to threads is redistributed cooperatively.

Pony-ORCA manages scalability in actor system based on ideas from ownership and deferred, distributed, weighted **reference counting**. It adapts actor messaging to keep the reference count consistent no matter the number of running actors. The main challenge then becomes detecting cycles of sleeping actors. With ORCA's message passing, you get deferred direct reference counting, a dedicated actor for the detection of (cyclic) garbage, and a confirmation protocol which lead to the following guarantees:

1. _Soundness_: collects only dead actors
2. _Completeness_: collects all dead actors eventually
3. _Concurrency_: does not require a stop-the-world step, clocks, timestamps, versioning, thread coordination, actor introspection, shared memory, read/write barriers, or cache coherency

Pony's type system, along with its reference capabilities, ensures at compile time that your program can **never have data races**. As well, because Pony has no locks (really), your program is also **deadlock-free**! (Though **livelock** is still possible, so be careful.)

## Pony-ORCA Characteristics

1. An actor may perform garbage collection concurrently with other actors
2. An actor may garbage collect internally solely based on its own local state; no need for consultation with or inspecting the state of other actors
3. An actor need not synchronization with other actors during garbage collection
4. An actor garbage collects between its normal behaviors; it need not wait until its message queue is empty

## ORCA Beyond Pony

ORCA can be applied beyond Pony, provided that the follow requirements are satisfied:

* **Actor behaviors are [atomic](https://www.google.com/search?q=atomic+operation)**: a behavior appears to the rest of the system to be one uninterrupted action
* **Message delivery is [causal](https://www.google.com/search?q=causal+messaging+definition)**: a message arrives before any future messages it caused, provided the messages have the same destination.

### Further reading

* [Orca: GC and Type System Co-Design for Actor Languages](https://www.ponylang.io/media/papers/orca_gc_and_type_system_co-design_for_actor_languages.pdf)