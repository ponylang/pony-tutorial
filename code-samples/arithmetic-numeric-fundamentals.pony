// Unsigned wrap-around: the value wraps from the maximum back to zero
U8(255) + 1 == 0

// Unsigned wrap-around: the value wraps from zero to the maximum
U8(0) - 1 == 255

// Signed integers: zero is in the middle of the range, not at the edge
// Compare with U8(0) - 1 above — for signed integers, this is just normal subtraction
I8(0) - 1 == -1

// Signed wrap-around: going past the maximum wraps to the minimum
I8(127) + 1 == -128

// Signed wrap-around: going past the minimum wraps to the maximum
I8(-128) - 1 == 127
