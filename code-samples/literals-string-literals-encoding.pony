actor Main
  new create(env: Env) =>
    let u_umlaut = "ü"

    env.out.print(u_umlaut)