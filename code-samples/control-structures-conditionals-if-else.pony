actor Main
  new create(env: Env) =>
    let a: U8 = 1
    let b: U8 = 2
    if a > b then
      env.out.print("a is bigger")
    else
      env.out.print("a is not bigger")
    end