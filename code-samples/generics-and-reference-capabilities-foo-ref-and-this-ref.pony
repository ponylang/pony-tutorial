class Foo
  var _c: String ref

  new create(c: String ref) =>
    _c = c

  fun get(): this->String ref => _c

  fun ref set(c: String ref) => _c = c

actor Main
  new create(env: Env) =>
    let a = Foo(recover ref String end)
    env.out.print(a.get().string())
    a.set(recover ref String end)
    env.out.print(a.get().string())