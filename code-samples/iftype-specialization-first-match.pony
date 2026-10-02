trait val Printable
  fun show(): String

primitive Tagged is (Stringable & Printable)
  fun string(): String iso^ => "tagged".clone()
  fun show(): String => "tagged"

class Container[A: Any val]
  var _data: A

  new create(data: A) =>
    _data = data

  fun describe(): String =>
    "unknown"

  fun describe(): String iftype A <: Stringable val =>
    "stringable"

  fun describe(): String iftype A <: Printable val =>
    "printable"

actor Main
  new create(env: Env) =>
    // Tagged satisfies both Stringable and Printable.
    // The Stringable guard appears first and wins.
    let c = Container[Tagged](Tagged)
    env.out.print(c.describe())  // prints "stringable"
