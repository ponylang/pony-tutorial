actor Main
  new create(env: Env) =>
    let line = "Lorem ipsum"
    let i: ISize = 5
    let key = recover val line.substring(0, i).>strip() end
    env.out.print("key: " + key)