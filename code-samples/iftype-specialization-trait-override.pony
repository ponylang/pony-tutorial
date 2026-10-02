trait Describable[A: Any val]
  fun describe(): String =>
    "unknown"

  fun describe(): String iftype A <: Stringable val =>
    "stringable"

class Container[A: Any val] is Describable[A]
  var _data: A

  new create(data: A) =>
    _data = data

  fun describe(): String =>
    "container default"

  fun describe(): String iftype A <: Stringable val =>
    "container: " + _data.string()

actor Main
  new create(env: Env) =>
    let c = Container[U32](42)
    env.out.print(c.describe())  // prints "container: 42"
