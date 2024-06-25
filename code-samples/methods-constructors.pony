actor Main
  new create(env: Env) =>
    env.out.print("create: " + Foo.get_x().string())
    env.out.print("from_int: " + Foo.from_int(42).get_x().string())
    
class Foo
  var _x: U32

  new create() =>
    _x = 0

  new from_int(x: U32) =>
    _x = x
    
  fun get_x(): U32 =>
    _x