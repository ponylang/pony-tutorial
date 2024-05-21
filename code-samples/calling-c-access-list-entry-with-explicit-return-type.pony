// OK
let point = @list_pop[Point](list_of_points)
let x_coord = point.x

// OK
let pointer = @list_pop[Pointer[U8]](list_of_strings)
let data = String.from_cstring(pointer)