class val Opaque

class Container[A: Any val]
  var _data: A

  new create(data: A) =>
    _data = data

  fun describe(): String =>
    "opaque value"

  fun describe(): String iftype A <: Stringable val =>
    _data.string()

actor Main
  new create(env: Env) =>
    let c1 = Container[Opaque](Opaque)
    env.out.print(c1.describe())  // prints "opaque value"

    let c2 = Container[U32](99)
    env.out.print(c2.describe())  // prints "99"
