actor Main
  new create(env: Env) =>
    env.out.print(f(2))
    env.out.print(f(42))

  fun f(x: U32): String =>
    match x
    | 1 => "one"
    | 2 => "two"
    | 3 => "three"
    | 5 => "not four"
    else
      "something else"
    end