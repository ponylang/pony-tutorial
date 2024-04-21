use "collections"

class Foo
  fun foo(str: String): Hashable iso^ =>
    object iso is Hashable
      fun apply(): String => str
      fun hash(): USize => str.hash()
    end