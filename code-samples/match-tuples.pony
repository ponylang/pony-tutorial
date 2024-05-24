actor Main
  new create(env: Env) =>
    env.out.print(f("one", 2))

  fun f(x: (String | None), y: U32): String =>
    match (x, y)
    | (None, let u: U32) => "none"
    | (let s: String, 2) => s + " two"
    | (let s: String, 3) => s + " three"
    | (let s: String, let u: U32) => s + " other integer"
    else
      "something else"
    end