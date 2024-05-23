actor Main
  new create(env: Env) =>
    let wombat = Wombat(5)
    env.out.print(wombat.name + " has a hunger level of " + wombat.get_hunger().string())
    
class Wombat
  let name: String
  var _hunger_level: U32

  new create(hunger: U32) =>
    name = "Fantastibat"
    _hunger_level = hunger
  
  fun get_hunger(): U32 => _hunger_level