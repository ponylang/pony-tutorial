actor Main
  new create(env: Env) =>
    let wombat = Wombat("Fantastibat", 5)
    
class Wombat
  let name: String
  var _hunger_level: U64

  new ref create(name': String, level: U64) =>
    name = name'
    _hunger_level = level

  fun ref set_hunger_level(hunger_level: U64) =>
    _hunger_level = hunger_level // Ok, _hunger_level is of var type

  fun ref set_name(name' : String) =>
    name = name' // Error, can't assign to a let definition more than once