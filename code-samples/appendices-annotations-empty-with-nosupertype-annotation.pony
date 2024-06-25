class \nosupertype\ Empty

class Foo
  fun foo[A: Any](a: (A | Empty val)) =>
    match consume a
    | let a': A => None
    end

actor Main
  new create(env: Env) =>
    let foo: Foo = Foo
    env.out.print(foo.foo[Any]("Something").string())