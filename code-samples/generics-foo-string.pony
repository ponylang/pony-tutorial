class FooString
  var _c: String val

  new create(c: String val) =>
    _c = c

  fun get(): String val => _c

  fun ref set(c: String val) => _c = c

actor Main
  new create(env:Env) =>
    let c = FooString("Hello")
    env.out.print(c.get())