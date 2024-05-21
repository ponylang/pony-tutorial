actor Main
  new create(env: Env) =>
    var x: (String | None) =
      for name in Array[String].values() do
        name
      end
    match x
    | let s: String => env.out.print("x is " + s)
    | None => env.out.print("x is None")
    end