actor Main
  new create(env: Env) =>
    let friendly = false
    var x: (String | Bool) =
      if friendly then
        "Hello"
      else
        false
      end
    env.out.print(x.string())