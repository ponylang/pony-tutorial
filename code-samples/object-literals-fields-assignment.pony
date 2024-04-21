use "collections"

class Foo
  fun foo(str: String): Hashable =>
    object is Hashable
      let s: String = str
      fun apply(): String => s
      fun hash(): USize => s.hash()
    end