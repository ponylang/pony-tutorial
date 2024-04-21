use "collections"

actor Main
  new create(env: Env) =>
    let l = List[U32]
    l.>push(10).>push(20).>push(30).push(40)
    let r = reduce(l, 0, {(a:U32, b:U32): U32 => a + b })
    env.out.print("Result: " + r.string())

  fun reduce(l: List[U32], acc: U32, f: {(U32, U32): U32} val): U32 =>
    try
      let acc' = f(acc, l.shift()?)
      reduce(l, acc', f)
    else
      acc
    end