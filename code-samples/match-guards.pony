actor Main
  new create(env: Env) =>
    env.out.print(f("one", 5))
    env.out.print(f("two", 42))

  fun f(x: (String | None), y: U32): String =>
    match (x, y)
    | (None, _) => "none"
    | (let s: String, 2) => s + " two"
    | (let s: String, 3) => s + " three"
    | (let s: String, let u: U32) if u > 14 => s + " other big integer"
    | (let s: String, _) => s + " other small integer"
    else
      "something else"
    end