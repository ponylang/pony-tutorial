actor Main
  new create(env: Env) =>
    // the value of x is undefined
    let x = F64(1.5) /~ F64(0.5)
    env.out.print("1.5÷0.5 = " + x.string())