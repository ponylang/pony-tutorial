actor Main
  new create(env: Env) =>
    let forest = Forest
    
class Forest
  let _owl: Owl = Owl
  let _hawk: Hawk = Hawk

class Hawk
  var _hunger_level: U64 = 0

class Owl
  var _hunger_level: U64

  new create() =>
    _hunger_level = 42