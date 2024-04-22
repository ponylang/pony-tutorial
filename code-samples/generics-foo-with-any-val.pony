class Foo[A: Any val]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo[U32](42)
    env.out.print(a.get().string())
    a.set(21)

    env.out.print(a.get().string())
    let b = Foo[F32](1.5)
    env.out.print(b.get().string())

    let c = Foo[String]("Hello")
    env.out.print(c.get().string())