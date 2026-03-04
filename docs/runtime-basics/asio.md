# The ASIO Subsystem

ASIO (Asynchronous I/O) is Pony's built-in event notification system. It is how the runtime knows when a network socket has data to read, when a timer fires, or when a signal arrives.

## How It Works

The ASIO subsystem runs on its own dedicated thread, separate from the [scheduler threads](scheduler.md) that execute actor behaviors. The ASIO thread never runs actor code. Its only job is to wait for I/O events from the operating system and notify the appropriate actors when those events occur.

When an actor needs to be notified about an I/O event (for example, a TCP listener waiting for incoming connections), it registers interest with the ASIO subsystem. When the event fires, the ASIO thread sends a message to the registered actor, which causes that actor to be scheduled for execution on a scheduler thread.

## Platform Backends

Under the hood, the ASIO subsystem uses the most efficient event notification mechanism available on each platform:

- **Linux**: `epoll`
- **macOS and BSD**: `kqueue`
- **Windows**: I/O Completion Ports (`IOCP`)

These are all OS-level facilities for efficiently monitoring large numbers of file descriptors, sockets, and other event sources. The ASIO subsystem abstracts over the platform differences so that Pony code works the same way everywhere.

## ASIO and Actor Lifetime

An actor with active ASIO subscriptions is considered alive, even if it has no messages in its queue. This prevents the runtime from garbage collecting an actor that is waiting for I/O events. For example, a TCP listener with no current connections but an active listening socket will not be collected.

This also affects [program shutdown](program-lifecycle.md): the program will not reach quiescence while any actor has active ASIO subscriptions. If you want your program to exit, you need to ensure that actors unsubscribe from ASIO events (for example, by closing listening sockets and cancelling timers).
