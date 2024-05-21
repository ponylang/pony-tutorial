use @printf[I32](fmt: Pointer[None] tag, ...)

trait Foo
  fun apply() =>
    // Error: Can't call an FFI function in a default method or behavior
    @printf("Hello from trait Foo\n".cstring())

actor Main is Foo
  new create(env: Env) =>
    this.apply()