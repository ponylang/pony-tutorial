# Garbage Collection

Pony manages memory automatically. You never call `malloc` or `free`, and there is no explicit memory management API. But Pony's garbage collector works differently from most other languages, and understanding those differences helps you avoid common pitfalls.

There are two levels of garbage collection in Pony: collecting objects within an actor, and collecting actors themselves.

## Object Collection (Intra-Actor GC)

Each actor has its own private heap. When an actor's heap grows large enough, the runtime performs garbage collection on that actor's heap to reclaim unused objects.

The key property of intra-actor GC is that it only runs between behaviors, never during one. While an actor is executing a behavior, its heap will not be collected. This gives you completely predictable performance within a behavior: no GC pauses, no surprise interruptions.

The tradeoff is that a behavior that allocates a lot of memory will not get any of it back until the behavior finishes. This is why long-running behaviors that allocate in a loop can exhaust memory: the GC never gets a chance to run. The [garbage collection gotcha](../gotchas/garbage-collection.md) covers this anti-pattern in detail.

Because each actor has its own heap, there is no global stop-the-world pause. When one actor is being garbage collected, every other actor continues running normally. This is a significant advantage for latency-sensitive applications.

The GC's aggressiveness can be tuned with the `--ponygcinitial` and `--ponygcfactor` [runtime options](runtime-options.md).

## Actor Collection (Inter-Actor GC via ORCA)

Collecting dead actors is a harder problem than collecting objects. Actors can reference each other in cycles: actor A holds a reference to actor B, which holds a reference to actor A. Neither can be collected by simple reference counting because each keeps the other's count above zero.

Pony solves this with ORCA, a concurrent garbage collection protocol for actors. ORCA uses a combination of ownership tracking and deferred reference counting, adapted for message-passing concurrency. The important properties are:

- **Concurrent**: actor garbage collection runs concurrently with all other actors. There is no stop-the-world step.
- **Sound**: only dead actors are collected. A dead actor is one that is [blocked](program-lifecycle.md), has no pending messages, and cannot receive any new messages (including from [ASIO](asio.md) events).
- **Complete**: all dead actors are eventually collected, including cycles of dead actors.

A dedicated cycle detector actor periodically scans for groups of blocked actors that reference each other but are unreachable from any alive actor. When it finds such a group, it collects the entire cycle.

The cycle detector's scan interval can be tuned with the `--ponycdinterval` [runtime option](runtime-options.md), and it can be disabled entirely with `--ponynoblock` (though this means dead actor cycles will never be collected).

For the full details of the ORCA protocol, see [Orca: GC and Type System Co-Design for Actor Languages](https://www.ponylang.io/media/papers/orca_gc_and_type_system_co-design_for_actor_languages.pdf).
