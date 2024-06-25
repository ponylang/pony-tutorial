actor Main
  new create(env: Env) =>
    for name in ["Bob"; "Fred"; "Sarah"].values() do
      env.out.print(name)
    end