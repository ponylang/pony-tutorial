class Container[A: Any val]
  var _data: A

  new create(data: A) =>
    _data = data

  fun describe(): String =>
    "opaque"

  fun describe(): String iftype A <: Stringable val =>
    "value is: " + _data.string()

actor Main
  new create(env: Env) =>
    let c = Container[U32](42)
    env.out.print(c.describe())  // prints "value is: 42"
