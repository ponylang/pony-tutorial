actor Main
  new create(env: Env) =>
    let friendly = false
    var x: (String | None) =
      if friendly then
        "Hello"
      end
    env.out.print(x.string())