actor Main
  new create(env: Env) =>
    var a: U64 = 1
    var b: U64 = 2
    env.out.print("a = " + a.string() + ", b = " + b.string())
    a = b = a
    env.out.print("a = " + a.string() + ", b = " + b.string())