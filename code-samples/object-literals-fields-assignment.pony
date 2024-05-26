use "collections"

class Foo
  fun foo(str: String): Hashable =>
    object is Hashable
      let s: String = str
      fun apply(): String => s
      fun hash(): USize => s.hash()
    end

actor Main
  new create(env: Env) =>
    let x = "hello world"
    env.out.print(x + ": " + Foo.foo(x).hash().string())