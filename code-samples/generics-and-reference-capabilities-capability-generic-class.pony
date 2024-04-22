class Foo[A]
  var _c: A

  new create(c: A) =>
    _c = consume c

  fun get(): this->A => _c

  fun ref set(c: A) => _c = consume c

actor Main
  new create(env: Env) =>
    let a = Foo[String iso]("Hello".clone())
    env.out.print(a.get().string())

    let b = Foo[String ref](recover ref "World".clone() end)
    env.out.print(b.get().string())

    let c = Foo[U8](42)
    env.out.print(c.get().string())