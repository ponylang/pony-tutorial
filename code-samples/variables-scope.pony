actor Main
  new create(env: Env) =>
    let a = 2
    let b = 1

    if a > b then
      var x = "a is bigger"
      env.out.print(x)  // OK
    end
    
    env.out.print(x)  // Illegal