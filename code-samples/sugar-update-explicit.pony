class Foo
  var _x: U32 = 0
  
  new create(x: U32) =>
    update(x, 2)

  fun ref update(x: U32, value: U32) =>
    _x = value * x
    
  fun get_value(): U32 =>
    _x

actor Main
  new create(env: Env) =>
    let foo = Foo(5)
    let x: U32 = 10
    env.out.print("foo = " + foo.get_value().string())
    foo.update(37 where value = x)
    env.out.print("foo = " + foo.get_value().string())