trait val Displayable
  fun display(): String

primitive MyDisplay is Displayable
  fun display(): String => "my display"

class val Opaque

class Container[A: Any val]
  var _data: A

  new create(data: A) =>
    _data = data

  fun describe(): String =>
    "opaque"

  fun describe(): String
    iftype A <: Stringable val or A <: Displayable val
  =>
    "has a text representation"

actor Main
  new create(env: Env) =>
    let c1 = Container[U32](42)
    env.out.print(c1.describe())  // prints "has a text representation"

    let c2 = Container[MyDisplay](MyDisplay)
    env.out.print(c2.describe())  // prints "has a text representation"

    let c3 = Container[Opaque](Opaque)
    env.out.print(c3.describe())  // prints "opaque"
