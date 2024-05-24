actor Main
  new create(env: Env) =>
    try
      let iterator = ["Bob"; "Fred"; "Sarah"].values()
      while iterator.has_next() do
        let name = iterator.next()?
        env.out.print(name)
      end
    end