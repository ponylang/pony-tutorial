class val Opaque

class Pair[A: Any val, B: Any val]
  var _a: A
  var _b: B

  new create(a: A, b: B) =>
    _a = a
    _b = b

  fun describe(): String =>
    "generic pair"

  fun describe(): String
    iftype A <: Stringable val and B <: Stringable val
  =>
    _a.string() + ", " + _b.string()

actor Main
  new create(env: Env) =>
    let p1 = Pair[U32, U64](1, 2)
    env.out.print(p1.describe())  // prints "1, 2"

    let p2 = Pair[U32, Opaque](1, Opaque)
    env.out.print(p2.describe())  // prints "generic pair"
