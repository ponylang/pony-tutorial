actor Main
  new create(env: Env) =>
    let x: String ref = "sailor".string()
    let y: Foo = x
    y._set(0, 'f')
    env.out.print("Hello, " + x)

interface Foo
  fun ref _set(i: USize, value: U8): U8