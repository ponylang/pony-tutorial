actor Main
  new create(env: Env) =>
    let u_umlaut = "�"

    env.out.print(u_umlaut)