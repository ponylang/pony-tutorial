actor Main
  new create(env: Env) =>
    test(Wombat)

  fun test(a: Wombat trn) =>
    var b: Wombat box = a // Allowed!
    
class Wombat