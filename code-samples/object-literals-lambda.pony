actor Main
  new create(env: Env) =>
    let lambda =
      {(s: String): String => "lambda: " + s }
    env.out.print(lambda("hello world"))