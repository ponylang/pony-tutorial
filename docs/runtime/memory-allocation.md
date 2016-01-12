# Memory allocation at runtime

Pony is NULL-free, type-safe language, with no dangling pointers, no
buffer overruns, but with a **very fast garbage collector**, so you
don't have to worry about explicit memory allocation, if on the heap
or stack, if in a threaded actor, or not. But since pony can be used
to create **C libraries** and pony can use external C libraries via the
**FFI** which does not have this luxury.

...

