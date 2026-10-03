class Container[A: Any val]
  var _data: A

  new create(data: A) =>
    _data = data

  fun get(): String ? =>
    error

  fun get(): String iftype A <: Stringable val ? =>
    _data.string()

actor Main
  new create(env: Env) =>
    let c = Container[U32](42)
    try
      env.out.print(c.get()?)  // prints "42"
    end
