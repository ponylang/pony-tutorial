---
title: "Memory Allocation at Runtime"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 60
toc: true
---

Pony is a null-free, type-safe language, with no dangling pointers, no buffer overruns, but with a **very fast garbage collector**, so you don't have to worry about explicit memory allocation, if on the heap or stack, if in a threaded actor, or not.

## Fast, Safe and Cheap

* An actor has ~240 bytes of memory overhead.
* No locks. No context switches. All mutation is local.
* An idle actor consumes no resources (other than memory).
* You can have millions of actors at the same time.

## But Caveat Emptor

But Pony can be used to create **C libraries** and Pony can use external C libraries via the **FFI** which does not have this luxury.

So you **can** use any external C library out there, but the question is if you **need to** and if you **should**.

The biggest problem is external heap memory, created by an external FFI call, or created to support an external call. But external stack space might also need some thoughts, esp. when being created from actors.

Pony does have **finalisers** (callbacks which are called by the garbage collector which may be used to free resources allocated by an FFI call); However, the garbage collector is _not timely_ (as with pure reference counting), it is not triggered immediately when some object goes out of scope.

A blocked actor will keep its memory allocated, only a dead actor will release it eventually.

## And, long-running actors

Might cause unexpected out of memory errors, since the GC is not yet triggered on an out-of-memory segfault or stack exhaustion.

...
