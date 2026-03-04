# The Scheduler

The [Actors](../types/actors.md) chapter introduced the idea that Pony runs actor behaviors concurrently using a cooperative scheduler. This page goes deeper into how that scheduler works.

## Cooperative, Not Preemptive

Pony's scheduler is cooperative. An actor that is executing a behavior will not be interrupted partway through. Instead, the actor runs its behavior to completion, then yields the scheduler thread so another actor can run.

This is different from preemptive schedulers (like OS thread schedulers), which can interrupt a running thread at any point. Cooperative scheduling gives you predictable performance within a behavior: no surprise pauses, no GC interruptions, no context switches. The tradeoff is that a behavior that takes a long time to finish will hold onto its scheduler thread for that entire duration.

This is why the [scheduling gotcha](../gotchas/scheduling.md) warns against long-running behaviors. A behavior that loops for a long time (or calls FFI code that blocks) monopolizes a scheduler thread and prevents other actors from making progress on that thread.

## Scheduler Threads

By default, the Pony runtime creates one scheduler thread per physical CPU core. Each scheduler thread can execute one actor behavior at a time. If you have 4 cores, you get 4 scheduler threads, and up to 4 actors can execute behaviors simultaneously.

There is also one additional thread dedicated to the [ASIO subsystem](asio.md), which handles I/O event notification. The ASIO thread never runs actor code.

The number of scheduler threads can be adjusted with the `--ponymaxthreads` and `--ponyminthreads` [runtime options](runtime-options.md).

## Work Stealing

Actors with pending messages are placed on per-thread run queues. When a scheduler thread finishes executing an actor's behavior and its own queue is empty, it steals work from another thread's queue. This keeps all cores busy even when work is unevenly distributed.

## Batch Processing

When an actor gets scheduled, it doesn't just process one message. It processes a batch of messages from its queue before yielding, which reduces scheduling overhead. After the batch, the actor goes back onto the run queue if it still has pending messages, giving other actors a chance to run.
