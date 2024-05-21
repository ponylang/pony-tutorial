use @frexp[F64](value: F64, exponent: Pointer[U32])
// ...
var exponent: U32 = 0
var mantissa = @frexp(this, addressof exponent)