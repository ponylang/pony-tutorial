use "mylib"
use @add_from_c[I64](adder: Adder, x: I64)

actor Main
  new create(env: Env) =>
    let adder = Adder(10)
    env.out.print(@add_from_c(adder, 5).string())
