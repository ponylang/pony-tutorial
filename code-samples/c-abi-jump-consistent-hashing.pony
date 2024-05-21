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