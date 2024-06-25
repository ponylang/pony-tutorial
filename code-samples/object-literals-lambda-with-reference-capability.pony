actor Main
  new create(env: Env) =>
    let lambda =
      {(s: String): String => "lambda: " + s } iso
    env.out.print(lambda("hello world"))