// In library lib_a
use @memcmp[I32](dst: Pointer[None] tag, src: Pointer[None] tag, len: USize)

// In library lib_b
use @memcmp[I32](dst: Pointer[None] tag, src: USize, len: U64)