struct Point
  var x: U64 = 0
  var y: U64 = 0

let list_of_points = @list_create()
@list_push(list_of_points, NullablePointer[Point].create(Point))

let list_of_strings = @list_create()
@list_push(list_of_strings, "some data".cstring())