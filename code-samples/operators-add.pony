actor Main
  new create(env: Env) =>
    var x = Pair(1, 2)
    var y = Pair(3, 4)
    var z = x + y
    env.out.print(z.string())
    
// Define a suitable type
class Pair
  var _x: U32 = 0
  var _y: U32 = 0

  new create(x: U32, y: U32) =>
    _x = x
    _y = y

  // Define a + function
  fun add(other: Pair): Pair =>
    Pair(_x + other._x, _y + other._y)
    
  fun string(): String =>
    "(" + _x.string() + ", " + _y.string() + ")"

// Now let's use it
class Foo
  fun foo() =>
    var x = Pair(1, 2)
    var y = Pair(3, 4)
    var z = x + y