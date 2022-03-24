# C ABI

The FFI support in Pony uses the C application binary interface (ABI) to interface with native code. The C ABI is a calling convention, one of many, that allow objects from different programming languages to be used together.

## Writing a C library for Pony

Writing your own C library for use by Pony is almost as easy as using existing libraries.

Let's look at a complete example of a C function we may wish to provide to Pony. Let's consider a pure Pony implementation of a [Jump Consistent Hash](https://arxiv.org/abs/1406.2294):

```pony
// Jump consistent hashing in Pony, with an inline pseudo random generator
// https://arxiv.org/abs/1406.2294

fun jch(key: U64, buckets: U32): I32 =>
  var k = key
  var b = I64(0)
  var j = I64(0)

  while j < buckets.i64() do
    b = j
    k = (k * 2862933555777941757) + 1
    j = ((b + 1).f64() * (I64(1 << 31).f64() / ((k >> 33) + 1).f64())).i64()
  end

  b.i32()
```

Let's say we wish to compare the pure Pony performance to an existing C function with the following header:

```c
#ifndef __JCH_H_
#define __JCH_H_

extern "C"
{
  int32_t jch_chash(uint64_t key, uint32_t num_buckets);
}

#endif
```

Note the use of `extern "C"`. If the library is built as C++ then we need to tell the compiler not to mangle the function name, otherwise, Pony won't be able to find it. For libraries built as C, this is not needed, of course.

The implementation of the previous header would be something like:

```c
#include <stdint.h>

// A fast, minimal memory, consistent hash algorithm
// https://arxiv.org/abs/1406.2294
int32_t jch_chash(uint64_t key, uint32_t num_buckets)
{
  int b = -1;
  uint64_t j = 0;

  do {
    b = j;
    key = key * 2862933555777941757ULL + 1;
    j = (b + 1) * ((double)(1LL << 31) / ((double)(key >> 33) + 1));
  } while(j < num_buckets);

  return (int32_t)b;
}
```

We need to compile the native code to a shared library. This example is for MacOS. The exact details may vary on other platforms.

```bash
clang -fPIC -Wall -Wextra -O3 -g -MM jch.c >jch.d
clang -fPIC -Wall -Wextra -O3 -g  -c -o jch.o jch.c
clang -shared -lm -o libjch.dylib jch.o
```

The Pony code to use this new C library is just like the code we've already seen for using C libraries.

```pony
"""
This is an example of Pony integrating with native code via the built-in FFI
support
"""

use "lib:jch"
use "collections"
use @jch_chash[I32](hash: U64, bucket_size: U32)

actor Main
  var _env: Env

  new create(env: Env) =>
    _env = env

    let bucket_size: U32 = 1000000

    _env.out.print("C implementation:")
    for i in Range[U64](1, 20) do
      let hash = @jch_chash(i, bucket_size)
      _env.out.print(i.string() + ": " + hash.string())
    end

    _env.out.print("Pony implementation:")
    for i in Range[U64](1, 20) do
      let hash = jch(i, bucket_size)
      _env.out.print(i.string() + ": " + hash.string())
    end

  fun jch(key: U64, buckets: U32): I32 =>
    var k = key
    var b = I64(0)
    var j = I64(0)

    while j < buckets.i64() do
      b = j
      k = (k * 2862933555777941757) + 1
      j = ((b + 1).f64() * (I64(1 << 31).f64() / ((k >> 33) + 1).f64())).i64()
    end

    b.i32()
```

We can now use ponyc to compile a native executable integrating Pony and our C library. And that's all we need to do.
