class Formatter
  new create() => None

  fun format[A: Any val](a: A): String =>
    "unknown"

  fun format[A: Any val](a: A): String iftype A <: Stringable val =>
    a.string()

actor Main
  new create(env: Env) =>
    let f = Formatter
    env.out.print(f.format[U32](42))        // prints "42"
    env.out.print(f.format[Bool](true))      // prints "true"
