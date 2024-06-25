actor Main
  new create(env: Env) =>
    let defaultWombat = Wombat("Fantastibat") // Invokes the create method by default
    let hungryWombat = Wombat.hungry("Nomsbat", 12) // Invokes the hungry method
    env.out.print("Your default wombat's name is \"" + defaultWombat.name + "\"")
    env.out.print("Your hungry wombat's name is \"" + hungryWombat.name + "\"")

class Wombat
  let name: String
  var _hunger_level: U64

  new create(name': String) =>
    name = name'
    _hunger_level = 0

  new hungry(name': String, hunger': U64) =>
    name = name'
    _hunger_level = hunger'