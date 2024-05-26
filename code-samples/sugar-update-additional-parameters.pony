class Foo
  var _x: (U32|F32)
  
  new create(x: U32) =>
   _x = x

  fun ref update(x: U32 = 0, y: (String|U32) = "", z: F32 = 0.0, value: U32, b: U32 = 0, a: U32 = 0) =>
    _x = (value * x).f32() + (a * b).f32() + z
    match y
      | let u: U32 => _x = _x.f32() + u.f32()
    end
    
  fun get_value(): (U32|F32) =>
    _x

actor Main
  new create(env: Env) =>
    let foo1 = Foo(5)
    let foo2 = Foo(5)
    let foo3 = Foo(5)
    let x: U32 = 10
    env.out.print("foo = " + foo1.get_value().string())
    foo1(2, 3) = x
    foo2() = x
    foo3(37, "Hello", 3.5 where a = 2, b = 3) = x
    env.out.print("foo1 = " + foo1.get_value().string())
    env.out.print("foo2 = " + foo2.get_value().string())
    env.out.print("foo3 = " + foo3.get_value().string())