actor Main
  new create(env: Env) =>
    let wombat = Wombat
    env.out.print(wombat.name + " has a hunger level of " + wombat.hunger().string())
    
class Wombat
  let name: String = "Fantastibat"
  var _hunger_level: U32 = 0
  
  fun hunger(): U32 => _hunger_level