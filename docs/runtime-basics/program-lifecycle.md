# Program Lifecycle

A Pony program starts, runs, and stops differently from programs in most other languages. There is no main loop to exit, no explicit shutdown call, and no `System.exit()`. The runtime decides when the program is done.

## Startup

Every Pony program begins with the `Main` actor. The runtime creates a single instance of `Main` and calls its `create` constructor, passing in an `Env` object. The `create` constructor runs as a behavior, which means it is asynchronous, just like any other behavior.

When `create` finishes, the program does not exit. It continues running as long as there are still active actors.

## Actor States

Understanding when a program exits requires understanding actor states. An actor is in one of two fundamental states:

- **Alive**: the actor has messages in its queue, or it can still receive messages (including from [ASIO](asio.md) events).
- **Dead**: the actor has no messages in its queue and it cannot receive messages. No other actor holds a reference to it, and it has no active ASIO subscriptions.

Within these two states, an actor can also be:

- **Running**: actively executing a behavior on a scheduler thread.
- **Waiting**: has messages in its queue but is not currently scheduled.
- **Blocked**: has finished processing all messages in its queue and is waiting for new ones.
- **Muted**: temporarily removed from scheduling because it sent a message to an overloaded actor (see [Backpressure](backpressure.md)).

Blocked and muted are not exclusive to alive actors. A dead actor can also be blocked or muted, but since it cannot receive new messages, it will never become active again. Dead actors are candidates for garbage collection by the [cycle detector](garbage-collection.md).

## Self-Messages

An actor can send messages to itself. This is a common pattern for breaking up long-running work: instead of looping inside a single behavior, the actor processes one chunk and then sends itself a message to process the next chunk. As long as an actor has messages in its queue (including self-sent ones), it remains alive.

## Quiescence and Shutdown

The runtime shuts down when it reaches quiescence: a state where there is nothing left to do. Specifically, quiescence occurs when all of the following are true:

- Every actor is blocked (no actor has pending messages to process).
- There are no active ASIO subscriptions (no actor is waiting for I/O events, timers, or signals).
- No actors are muted (no actor is paused due to backpressure).

When these conditions are met, the runtime concludes that no actor can ever receive another message and shuts down the program.

This means you don't explicitly stop a Pony program. You stop it by arranging for all actors to finish their work. If an actor keeps sending messages to itself or other actors, or if a timer is still active, the program will keep running.

## Setting the Exit Code

By default, a Pony program exits with code 0. You can change this by calling `Env.exitcode`:

```pony
--8<-- "runtime-basics-exitcode.pony"
```

The exit code must be set before the program reaches quiescence. Once the runtime begins shutting down, it uses whatever exit code was last set. If no actor ever calls `Env.exitcode`, the exit code is 0.
