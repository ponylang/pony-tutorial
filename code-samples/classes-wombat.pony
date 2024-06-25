actor Main
  new create(env: Env) =>
    let defaultWombat = Wombat("Fantastibat") // Invokes the create method by default
    let hungryWombat = Wombat.hungry("Nomsbat", 12) // Invokes the hungry method
    defaultWombat.set_hunger(5)
    env.out.print(defaultWombat.name + " has a hunger level of " + defaultWombat.hunger().string())
    env.out.print(hungryWombat.name + " has a hunger level of " + hungryWombat.hunger().string())

class Wombat
  let name: String
  var _hunger_level: U64
  var _thirst_level: U64 = 1

  new create(name': String) =>
    name = name'
    _hunger_level = 0

  new hungry(name': String, hunger': U64) =>
    name = name'
    _hunger_level = hunger'

  fun hunger(): U64 => _hunger_level

  fun ref set_hunger(to: U64 = 0): U64 => _hunger_level = to