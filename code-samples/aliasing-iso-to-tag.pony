actor Main
  new create(env: Env) =>
    test(Wombat)

  fun test(a: Wombat iso) =>
    var b: Wombat tag = a // Allowed!
    
class Wombat