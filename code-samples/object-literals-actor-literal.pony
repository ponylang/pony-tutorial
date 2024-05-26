actor Main
  new create(env: Env) =>
    let lambda =
      object
        be apply() => env.out.print("hi")
      end
    lambda()