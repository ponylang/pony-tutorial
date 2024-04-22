// Compiler error: couldn't find 'x' in 'Pointer'
let point_x = @list_pop(list_of_points)
point.x

// Compiler error: wanted Pointer[U8 val] ref^, got Pointer[None val] ref
let head = String.from_cstring(@list_pop(list_of_strings))