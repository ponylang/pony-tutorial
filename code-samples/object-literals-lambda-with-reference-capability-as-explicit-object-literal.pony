actor Main
  new create(env: Env) =>
    let lambda =
      object iso
        fun apply(s: String): String => "lambda: " + s
      end
    env.out.print(lambda("hello world"))