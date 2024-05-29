class Bar[A: Any box = USize val]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env:Env) =>
    let a = Bar(42)
    let b = Bar[USize](42)
    let c = Bar[F32](1.5)