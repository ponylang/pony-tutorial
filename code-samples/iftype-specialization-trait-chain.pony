trait Base[A: Any val]
  fun describe(): String => "base"
  fun describe(): String iftype A <: Stringable val => "stringable"

trait Middle[A: Any val] is Base[A]

class Impl[A: Any val] is Middle[A]
  var _a: A
  new create(a: A) => _a = a

actor Main
  new create(env: Env) =>
    let x = Impl[U32](42)
    env.out.print(x.describe())  // prints "stringable"
