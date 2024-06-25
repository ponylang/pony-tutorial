actor Main
  new create(env: Env) =>
    test(Wombat)
    
  fun test(a: Wombat iso) =>
    var b: Wombat iso = consume a // Allowed!
    var c: Wombat tag = a // Not allowed!
    
class Wombat