actor Main
  new create(env: Env) =>
    let bob: Bob = Bob
    env.out.print("Their name is \"" + bob.name() + "\"")

trait Named
  fun name(): String => "Bob"

class Bob is Named