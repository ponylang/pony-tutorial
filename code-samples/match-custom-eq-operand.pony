class Foo
  var _x: U32

  new create(x: U32) =>
    _x = x

  fun eq(that: Foo): Bool =>
    _x == that._x

actor Main
  new create(env: Env) =>
    None

  fun f(x: Foo): String =>
    match x
    | Foo(1) => "one"
    | Foo(2) => "two"
    | Foo(3) => "three"
    | Foo(5) => "not four"
    else
      "something else"
    end