# Linking to C libraries

The FFI support in pony uses the C application binary interface (ABI) to
interface with native code. The C ABI is a calling convention, one of many,
that allow objects from different programming languages to be used together.

In order to motivate discussion, let us look at a sample C function we may
wish to provide to pony. A Jump Consistent Hash, for example, could be provided
in pure pony as follows:

```
// Jump consistent hashing in pony, with an inline pseudo random generator

fun jch(key: U64, buckets: I64): I32 =>
  var k = key
  var b = I64(0)
  var j = I64(0)

  while j < buckets do
    b = j
    k = (k * 2862933555777941757) + 1
    j = ((b + 1).f64() * (U32(1 << 31).f64() / ((key >> 33) + 1).f64())).i64()
  end

  b.i32()
```

Let us say we wish to compare the pure pony performance to an existing C function with
the following header:

```

#ifndef __JCH_H_
#define __JCH_H_

int32_t jch_chash(uint64_t key, uint32_t num_buckets);

#endif
```

Implemented somewhat as follows:

```

#include <stdint.h>
#include <limits.h>
#include "math.h"

// a reasonably fast, good period, low memory use, xorshift64* based prng
double lcg_next(uint64_t* x)
{
    *x ^= *x >> 12; // a
    *x ^= *x << 25; // b
    *x ^= *x >> 27; // c
    return (double)(*x * 2685821657736338717LL) / ULONG_MAX;
}

// jump consistent hash
extern "C"
int32_t jch_chash(uint64_t key, uint32_t num_buckets)
{
    uint64_t seed = key; int b = -1; int32_t j = 0;

    do {
        b = j;
        double r = lcg_next(&seed);
        j = floor( (b + 1)/r );
    } while(j < num_buckets);

    return (int32_t)b;
}
```

We need to compile the native code to a shared library

```
clang++ -fPIC -Wall -Wextra -O3 -g -MM jch.c >jch.d
clang++ -fPIC -Wall -Wextra -O3 -g   -c -o jch.o jch.c
clang++ -shared -lm -o libjch.dylib jch.o
```

We can then integrate and use with pony through adding the library parent directory
to the path via the pony compiler or with a path statement in the use statement in
pony code, as we saw with the motivating OpenSSL example.

```
ponyc -path=. jchffi
Building jchffi
Building builtin
Building collections
Building random
Generating
Optimising
Writing ./jchffi.o
Linking ./jchffi1
```

We have now compiled a native executable integrating pony and our library.

```
./jchffi1
1: 883122
2: 116414
3: 565373
4: 9712
5: 898336
6: 717398
7: 170247
8: 406558
9: 282929
10: 405987
11: 21240
12: 909403
13: 385276
14: 674456
15: 100483
16: 182121
17: 926262
18: 206798
19: 898787
```

And the mainline that puts it all together:

```
""" This is an example of pony integrating with native code via the builtin FFI support """

use "lib:jch" if osx
use "collections"
use "random"
use @jch_chash[I32](hash : U64 , bucket_size : U32)

actor Main
  var _env : Env

  new create(env : Env) =>
    _env = env

    let bucket_size : U32 = 1000000
    var random = MT

    for i in Range[U64](1 , 20) do
        let r : U64 = random.next()
        let hash = @jch_chash[U32](i, bucket_size)
        _env.out.print(i.string() + ": " + hash.string())
    end
```

That was just a little too easy for comfort, amirite?
