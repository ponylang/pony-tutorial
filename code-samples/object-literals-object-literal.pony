actor Main
  new create(env: Env) =>
    let sayHi =
      object
        fun apply(): String => "hi"
      end
    env.out.print(sayHi())