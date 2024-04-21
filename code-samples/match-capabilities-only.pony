class A
  fun ref sendable() =>
    None

actor Main
  var _x: (A iso | A ref | None)

  new create(env: Env) =>
    _x = None

  be f() =>
    match (_x = None)
    | let a1: A iso => None
    | let a2: A ref => None
    end