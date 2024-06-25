actor Main
  new create(env: Env) =>
    env.out.print(recursive_factorial(42).string())
    env.out.print(tail_recursive_factorial(42, 24).string())

  fun recursive_factorial(x: U32): U32 =>
    if x == 0 then
      1
    else
      x * recursive_factorial(x - 1)
    end
  
  fun tail_recursive_factorial(x: U32, y: U32): U32 =>
    if x == 0 then
      y
    else
      tail_recursive_factorial(x - 1, x * y)
    end