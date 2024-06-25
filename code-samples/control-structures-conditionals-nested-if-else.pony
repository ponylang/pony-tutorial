actor Main
  new create(env: Env) =>
    let a: U8 = 2
    let b: U8 = 2
    if a == b then
      env.out.print("they are the same")
    else
      if a > b then
        env.out.print("a is bigger")
      else
        env.out.print("b bigger")
      end
    end