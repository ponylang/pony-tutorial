class Foo is Equatable[Foo]

actor Main

  fun f(x: (Foo | None)): String =>
    match x
    | Foo => "foo"
    | None => "bar"
    else
      ""
    end

  new create(env: Env) =>
    f(Foo)