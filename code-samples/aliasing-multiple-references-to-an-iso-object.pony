actor Main
  new create(env: Env) =>
    test(Wombat)

  fun test(a: Wombat iso) =>
    var b: Wombat iso = a // Not allowed!
    
class Wombat