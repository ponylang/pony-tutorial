# Memory allocation at runtime

Pony is NULL-free, type-safe language, with no dangling pointers, no
buffer overruns, but with a **very fast garbage collector**, so you
don't have to worry about explicit memory allocation, if on the heap
or stack, if in a threaded actor, or not.

# Fast, Safe and Cheap

* An actor has ~240 bytes of memory overhead.
* No locks. No context switches. All mutation is local
* An idle actor consumes no resources ( other than memory )
* You can have millions of actors at the same time

# But Caveat Emptor

But pony can be used to create **C libraries** and pony can use
external C libraries via the **FFI** which does not have this luxury,

So you **can** use any external C library out there, but the question is if
you **need to** and if you **should**.

...

