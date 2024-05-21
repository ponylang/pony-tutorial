primitive Foo
  fun bar[A: Stringable val](a: A): String =>
    a.string()

actor Main
  new create(env:Env) =>
    let a = Foo.bar[U32](10)
    env.out.print(a.string())

    let b = Foo.bar[String]("Hello")
    env.out.print(b.string())