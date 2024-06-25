actor Main
  new create(env: Env) =>
    let s = recover String end
    s.append("hi")
    env.out.print(consume s)