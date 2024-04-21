actor Main
  new create(env: Env) =>
    var x: String =
      for name in Array[String].values() do
        name
      else
        "no names!"
      end
    env.out.print("x is " + x)