# Garbage collection with Pony-ORCA

Pony-ORCA is a fully concurrent protocol for garbage collection in the
actor paradigm. It allows cheap and small actors to perform garbage
collection concurrently with any number of other actors, and this
number can go into the millions, since one actor needs only 256 bytes
on 64bit systems. It does not require any form of synchronization
across actors except those introduced through the actor paradigm,
i.e. **message send** and **message receive**.

Pony-ORCA, yes _the killer whale_, is based on ideas from ownership
and deferred, distributed, weighted **reference counting**. It adapts
messaging systems of actors to keep the reference count
consistent. The main challenges in concurrent garbage collection is
the detection of cycles of sleeping actors in the actors graph, in the
presence of concurrent mutation of this graph. With message passing
you get deferred direct reference counting, a dedicated actor for the
detection of (cyclic) garbage, and a confirmation protocol (to deal
with the mutation of the actor graph).

1. _Soundness_: the technique collects only dead actors.

2. _Completeness_: the technique collects all dead actors eventually.

3. _Concurrency_: the technique does not require a stop-the-world
   step, clocks, timestamps, versioning, thread coordination, actor
   introspection, shared memory, read/write barriers or cache
   coherency.

The type system ensures at compile time that your program can 
**never have data races**. It's **deadlock free**... Because Pony has **no
locks**!

When an actor has completed local execution and has no pending
messages on its queue, it is _blocked_. An actor is _dead_, if it is
blocked and all actors that have a reference to it are blocked,
transitively. Collection of dead actors depends on being able to
collect closed cycles of blocked actors.

The Pony type system guarantees soundness and race and dead-lock
free concurrency by adhering to the following principles:

# Pony-ORCA characteristics

1. An actor may perform garbage collection concurrently other actors
   while they are executing and kind of behaviour.

2. An actor may decide whether to garbage collect an object solely
   based on its own local state, without consultation with, or
   inspecting the state of any other actor.

3. No synchronization between actors is required during garbage
   collection, other than potential message sends.

4. An actor may garbage collect between its normal behaviours, i.e. it
   need not wait untils its message queue is empty.

5. Pony-ORCA can be applied to several other programming languages,
   provided that the satisfy the following two requirements:

    * **Actor behaviours are atomic**.

    * **Message delivery is causal**. 
    [Causal](https://www.google.com/search?q=causal+definition): messages 
    arrive before any messages they may have caused, if they have the same
    destination. So there needs to be some kind of causal ordering guarantee,
    but less requirements than with comparable concurrent, fast garbage
    collectors.


