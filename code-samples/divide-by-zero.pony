actor Main
  new create(env: Env) =>
    let x = I64(1) / I64(0)
    env.out.print("1÷0 = " + x.string())