class Foo
  var _c: String iso

  new create(c: String iso) =>
    _c = consume c

  fun get(): this->String iso => _c

  fun ref set(c: String iso) => _c = consume c

actor Main
  new create(env: Env) =>
    let a = Foo(recover iso String end)
    env.out.print(a.get().string())
    a.set(recover iso String end)
    env.out.print(a.get().string())