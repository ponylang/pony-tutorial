class A
  fun ref sendable() =>
    None

class B
  fun ref update() =>
    None

actor Main
  var _x: (A iso | B ref | None)

  new create(env: Env) =>
    _x = None

  be f(a': A iso) =>
    match (_x = None) // type of this expression: (A iso^ | B ref | None)
    | let a: A iso => f(consume a)
    | let b: B ref => b.update()
    end