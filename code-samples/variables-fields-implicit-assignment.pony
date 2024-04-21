class Wombat
  let name: String
  var _hunger_level: U64

  new ref create(name': String, level: U64) =>
    name = name'
    set_hunger_level(level)
    // Error: field _hunger_level left undefined in constructor

  fun ref set_hunger_level(hunger_level: U64) =>
    _hunger_level = hunger_level