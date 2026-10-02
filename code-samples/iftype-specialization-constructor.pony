class Container[A: Any val]
  var _data: A
  var _label: String

  new create(data: A) =>
    _data = data
    _label = "opaque"

  new create(data: A) iftype A <: Stringable val =>
    _data = data
    _label = _data.string()

  fun label(): String => _label

actor Main
  new create(env: Env) =>
    let c = Container[U32](42)
    env.out.print(c.label())  // prints "42"
