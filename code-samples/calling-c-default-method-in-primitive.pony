use @printf[I32](fmt: Pointer[None] tag, ...)

trait Foo
  fun apply() =>
    // OK
    Printf("Hello from trait Foo\n")

primitive Printf
  fun apply(str: String) =>
    @printf(str.cstring())

actor Main is Foo
  new create(env: Env) =>
    this.apply()