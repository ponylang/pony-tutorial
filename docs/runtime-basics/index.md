# Overview

When you write Pony code, you work with actors, reference capabilities, and the type system. But underneath all of that is the Pony runtime: the engine that schedules your actors, manages memory, handles I/O, and decides when your program is done.

You don't need to understand the runtime to write Pony programs, but knowing how it works helps you write better ones. Understanding the scheduler explains why long-running behaviors are a problem. Understanding garbage collection explains why memory usage can spike unexpectedly. Understanding program lifecycle explains when and why your program exits.

This chapter covers:

- [The Scheduler](scheduler.md): how Pony schedules actors across CPU cores
- [Program Lifecycle](program-lifecycle.md): how programs start, run, and shut down
- [Garbage Collection](garbage-collection.md): how Pony manages memory within and across actors
- [The ASIO Subsystem](asio.md): how Pony handles asynchronous I/O events
- [Backpressure](backpressure.md): how Pony prevents fast senders from overwhelming slow receivers
- [Runtime Options](runtime-options.md): command-line flags and programmatic overrides for tuning the runtime
