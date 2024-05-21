class Foo[A: Any #read]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): this->A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo[String ref](recover ref "hello".clone() end)
    env.out.print(a.get().string())

    let b = Foo[String val]("World")
    env.out.print(b.get().string())