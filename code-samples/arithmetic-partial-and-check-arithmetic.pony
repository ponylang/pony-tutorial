actor Main
  new create(env: Env) =>
    partial(env)
    checked(env)
  
  fun partial(env: Env) =>
    // partial arithmetic
    let result =
      try
        USize.max_value() +? env.args.size()
      else
        env.out.print("overflow detected")
      end

  fun checked(env: Env) =>
    // checked arithmetic
    let result =
      match USize.max_value().addc(env.args.size())
      | (let result: USize, false) =>
        // use result
        env.out.print(result.string())/*
        ...
        */
      | (_, true) =>
        env.out.print("overflow detected")
      end