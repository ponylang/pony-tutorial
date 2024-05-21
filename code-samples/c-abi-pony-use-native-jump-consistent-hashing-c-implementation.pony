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