actor Main
  new create(env: Env) =>
    env.out.print("add: " + C.add(1, 2).string())
    env.out.print("nop: " + C.nop().string())
    
class C
  fun add(x: U32, y: U32): U32 =>
    x + y

  fun nop() =>
    add(1, 2)  // Pointless, we ignore the result