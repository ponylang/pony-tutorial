use "collections"

class Foo
  fun foo(str: String): Hashable iso^ =>
    object iso is Hashable
      fun apply(): String => str
      fun hash(): USize => str.hash()
    end

actor Main
  new create(env: Env) =>
    let x = "hello world"
    env.out.print(x + ": " + Foo.foo(x).hash().string())