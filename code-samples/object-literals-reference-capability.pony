use "collections"

class Foo
  fun foo(str: String): Hashable iso^ =>
    object iso is Hashable
      let s: String = str
      fun apply(): String => s
      fun hash(): USize => s.hash()
    end