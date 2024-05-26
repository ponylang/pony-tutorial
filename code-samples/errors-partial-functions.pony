actor Main
  new create(env: Env) =>
    try
      let fac5 = factorial(5)?
      env.out.print("factorial(5) results in " + fac5.string())
    else
      env.err.print("factorial(5) failed")
    end
    try
      let facNeg5 = factorial(-5)?
      env.out.print("factorial(-5) results in " + facNeg5.string())
    else
      env.err.print("factorial(-5) failed")
    end
    
  fun factorial(x: I32): I32 ? =>
    if x < 0 then error end
    if x == 0 then
      1
    else
      x * factorial(x - 1)?
    end