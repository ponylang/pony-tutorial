actor Main
  new create(env: Env) =>
    let anys = Array[Any ref].>push(Wombat).>push(Capybara)
    for any in anys.values() do
      match any
      | let critter: Critter =>
        env.out.print(critter.wash())
      end
    end