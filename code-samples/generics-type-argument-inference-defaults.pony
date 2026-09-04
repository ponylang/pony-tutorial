class Bar[A: Any box = USize val]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env: Env) =>
    let a = Bar(42)       // A is USize because the argument fits the default
    let b = Bar(F32(1.5)) // A is F32 because the argument overrides the default
