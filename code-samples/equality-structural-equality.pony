class Foo
  let _a: String

  new create(a: String) =>
    _a = a

  fun eq(that: box->Foo): Bool =>
    this._a == that._a

actor Main
  new create(e: Env) =>
    let a = Foo("hi")
    let b = Foo("bye")
    let c = Foo("hi")

    if a == b then
      // won't print
      e.out.print("1")
    end

    if a == c then
      // will print
      e.out.print("2")
    end

    if a is c then
      // won't print
      e.out.print("3")
    end