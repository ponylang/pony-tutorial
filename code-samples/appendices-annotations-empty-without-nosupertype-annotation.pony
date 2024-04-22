class Empty

class Foo
  fun foo[A: Any](a: (A | Empty val)) =>
    match consume a
    | let a': A => None
    end