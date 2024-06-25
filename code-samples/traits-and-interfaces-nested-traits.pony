actor Main
  new create(env: Env) =>
    let bob: Bob = Bob
    env.out.print("Their name is \"" + bob.name() + "\" and they are " + (if bob.hair() then "bald" else "not bald" end))

trait Named
  fun name(): String => "Bob"

trait Bald is Named
  fun hair(): Bool => false

class Bob is Bald