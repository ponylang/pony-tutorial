class Foo[A: Any val]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env: Env) =>
    let a = Foo(42)
    env.out.print(a.get().string())

    let b = Foo(1.5)
    env.out.print(b.get().string())

    let c = Foo("Hello")
    env.out.print(c.get().string())
