actor Main
  new create(env: Env) =>
    let lots = true
    var x: U32
    x = 1 + if lots then 100 else 2 end
    env.out.print("x = " + x.string() + "—that's " + (if lots then "lots" else "not a lot" end))