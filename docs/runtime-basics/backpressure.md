# Backpressure

In an actor system, it's possible for one actor to produce messages faster than another actor can process them. Without intervention, the receiver's message queue grows without bound, consuming more and more memory.

Pony's runtime has a built-in backpressure mechanism that prevents this automatically.

## How It Works

When an actor's message queue grows large enough, the runtime marks that actor as overloaded. Any actor that sends a message to an overloaded actor gets muted: it is temporarily removed from scheduling and will not execute any more behaviors until it is unmuted.

When the overloaded actor catches up and its queue shrinks, the runtime unmutes the senders and they resume normal execution.

This creates a natural feedback loop. A fast sender is automatically slowed down to match the pace of a slow receiver, preventing unbounded memory growth from accumulating messages.

## What This Means for You

Backpressure is entirely automatic. You don't need to write any code to enable it, and there is no API to interact with it. The runtime handles the detection and response transparently.

The main thing to be aware of is that muted actors appear to pause: they stop executing behaviors until they are unmuted. If you observe an actor that seems to have stopped processing messages, it may be muted because it sent a message to an overloaded actor somewhere downstream.

Muting is also relevant to [program lifecycle](program-lifecycle.md): the program will not reach quiescence while any actors are muted. A muted actor may have more messages to send once it resumes, so the runtime cannot conclude that all work is done.
