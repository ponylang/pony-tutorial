actor Main
  new create(env: Env) =>
    let larry: Larry = Larry
    env.out.print("Their name is \"" + larry.name() + "\"")

class Larry
  fun name(): String => "Larry"