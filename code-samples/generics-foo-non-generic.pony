class Foo
  var _c: U32

  new create(c: U32) =>
    _c = c

  fun get(): U32 => _c

  fun ref set(c: U32) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo(42)
    env.out.print(a.get().string())
    a.set(21)
    env.out.print(a.get().string())