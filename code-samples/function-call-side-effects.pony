class Foo
  fun fn(x: U64) => None

actor Main
  new create(env: Env) =>
    var x: U64 = 0
    try foo()?.fn(x = 42) end
    env.out.print(x.string())

  fun foo(): Foo ? => error