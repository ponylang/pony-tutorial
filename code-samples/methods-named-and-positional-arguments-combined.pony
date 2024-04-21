class Foo
  fun f(a: U32 = 1, b: U32 = 2, c: U32 = 3, d: U32 = 4, e: U32 = 5): U32  =>
    0

  fun g() =>
    f(6, 7 where d = 8)
    // Equivalent to:
    f(6, 7, 3, 8, 5)