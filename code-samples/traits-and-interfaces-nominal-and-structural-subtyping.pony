actor Main
  new create(env: Env) =>
    let bob: Bob = Bob
    let larry: Larry = Larry
    env.out.print("Their name is \"" + bob.name() + "\"")
    env.out.print("Their name is \"" + larry.name() + "\"")

interface HasName
  fun name(): String => "Bob"

class Bob is HasName

class Larry
  fun name(): String => "Larry"