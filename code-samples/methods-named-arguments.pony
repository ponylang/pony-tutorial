class Coord
  var _x: U32
  var _y: U32

  new create(x: U32 = 0, y: U32 = 0) =>
    _x = x
    _y = y

class Bar
  fun f() =>
    var a: Coord = Coord.create(3, 4) // Contains (3, 4)
    var b: Coord = Coord.create(where y = 4, x = 3) // Contains (3, 4)