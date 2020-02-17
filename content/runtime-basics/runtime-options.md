---
title: "Runtime Options"
section: "Runtime Basics"
menu:
  toc:
    parent: "runtime-basics"
    weight: 35
toc: true
---

The Pony runtime is configurable on execution via the `pony-*` commandline options. These include options to change how thread scaling is handled, deferring GC until a memory-usage threshold, and not yielding a thread for a current lack of work.

To facilitate understanding these options can be broken up into logical groups.

### Threading

Option         | Usage
---------------|--------
ponymaxthreads | Use N scheduler threads. Defaults to the number of cores (not hyperthreads) available. This can't be larger than the number of cores available.
ponyminthreads | Minimum number of active scheduler threads allowed. Defaults to 0, meaning that all scheduler threads are allowed to be suspended when no work is available. This can't be larger than --ponymaxthreads if provided, or the physical cores available.
ponypin | Pin scheduler threads to CPU cores. The ASIO thread can also be pinned if `--ponypinasio` is set.
ponypinasio | Pin the ASIO thread to a CPU the way scheduler threads are pinned to CPUs. Requires `--ponypin` to be set to have any effect.
ponynoyield | Do not yield the CPU when no work is available.

### Scaling

Option      | Usage
------------|--------
ponynoscale | Don't scale down the scheduler threads. See --ponymaxthreads on how to specify the number of threads explicitly. Can't be used with --ponyminthreads.
ponysuspendthreshold | Amount of idle time before a scheduler thread suspends itself to minimize resource consumption (max 1000 ms, min 1 ms). Defaults to 1 ms.

### Garbage Collection

Option         | Usage
---------------|--------
ponycdinterval | Run cycle detection every N ms (max 1000 ms, min 10 ms). Defaults to 100 ms.
ponygcinitial  | Defer garbage collection until an actor is using at least 2^N bytes. Defaults to 2^14.
ponygcfactor   | After GC, an actor will next be GC'd at a heap memory usage N times its current value. This is a floating point value. Defaults to 2.0.
ponynoblock | Do not send block messages to the cycle detector.

### Information

Option      | Usage
------------|--------
ponyversion | Print the version of the compiler and exit.
ponyhelp    | Print the runtime usage options and exit.
