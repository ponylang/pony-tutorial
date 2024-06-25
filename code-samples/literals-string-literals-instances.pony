actor Main
  new create(env: Env) =>
    let pony = "🐎"
    let another_pony = "🐎"
    if pony is another_pony then
      // True, therefore this line will run.
      env.out.print("Same pony")
    else
      env.out.print("A different pony")
    end