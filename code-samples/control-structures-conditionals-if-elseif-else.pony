actor Main
  new create(env: Env) =>
    let a: U8 = 2
    let b: U8 = 1
    if a == b then
      env.out.print("they are the same")
    elseif a > b then
      env.out.print("a is bigger")
    else
      env.out.print("b bigger")
    end