actor Main
  new create(env: Env) =>
    var counter = U64(1)
    repeat
      env.out.print("hello!")
      counter = counter + 1
    until counter > 7 end