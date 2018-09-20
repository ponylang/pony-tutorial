# Arithmetic

Arithmetic is about the stuff you learn to do with numbers in primary school: Addition, Subtraction, Multiplication, Division and so on. Piece of cake. We all know that stuff. We nonetheless want to spend a whole section on this topic, because when it comes to computers the devil is in the details.

As introduced in [Primitives](../primitives.md#built-in-primitive-types) numeric types in Pony are represented as a special kind of primitive that maps to machine words. Both integer types and floating point types support a rich set of arithmetic and bit-level operations. These are expressed as [Infix Operators](../infix-ops.md) that are implemented as plain functions on the numeric primitive types.

Pony focuses on two goals, performance and safety. From time to time, these two goals collide. This is true especially for arithmetic on integers and floating point numbers. Safe code should check for overflow, division by zero and other error conditions on each operation where it can happen. Pony tries to enforce as many safety invariants at compile time as it possibly can, but checks on arithmetic operations can only happen at runtime. Performant code should execute integer arithmetic as fast and with as few CPU cycles as possible. Checking for overflow is expensive, doing plain dangerous arithmetic that is possibly subject to overflow is cheap.

Pony provides different ways of doing arithmetic to give programmers the freedom to chose which operation suits best for them, the safe but slower operation or the fast one, because performance is crucial for the use case.

## Integers

### Ponys default Arithmetic

Doing arithmetic on integer types in Pony with the well known operators like `+`, `-`, `*`, `/` etc. tries to balance the needs for performance and correctness. All default arithmetic operations do not expose any undefined behaviour or error conditions. That means it handles both the cases for overflow/underflow and division by zero. Overflow/Underflow are handled with proper wrap around semantics, using one's completement on signed integers. In that respect we get behaviour like:

```pony
// unsigned wrap-around on overflow
U32.max_value() + 1 == 0

// signed wrap-around on overflow/underflow
I32.min_value() - 1 == I32.max_value()
```

Division by zero is a special case, which affects the division `/` and modulo `%` operators. In Mathematics, division by zero is undefined. In order to avoid either defining division as partial, throwing an error on division by zero or introducing undefined behaviour for that case, the _normal_ division is defined to be `0` when the divisor is `0`. This might lead to silent errors, when used without care. Choose [Partial and checked Arithmetic](#partial-and-checked-arithmetic) to detect division by zero.

In contrast to [Unsafe Arithmetic](#unsafe-arithmetic) default arithmetic comes with a small runtime overhead because unlike the unsafe variants, it does detect and handle overflow and division by zero.

---

Operator | Method | Description
---------|--------|------------
`+`      | add()  | wrap around on over-/underflow
`-`      | sub()  | wrap around on over-/underflow
`*`      | mul()  | wrap around on over-/underflow
`/`      | div()  | `x/0 = 0`
`%`      | mod()  | `x%0 = 0`
`-`      | neg()  | wrap around on over-/underflow
`>>`     | shr()  | filled with zeros, so `x >> 1 == x/2` is true
`<<`     | shl()  | filled with zeros, so `x << 1 == x*2` is true

---

### Unsafe Arithmetic

Unsafe integer arithmetic comes close to what you can expect from integer arithmetic in C. No checks, _raw speed_, possibilities of overflow, underflow or division by zero. Like in C, overflow, underflow and division by zero scenarios are undefined. Don't rely on the results in these cases. It could be anything and is highly platform specific. Our suggestion is to use these operators only if you can make sure you can exclude these cases.

Here is a list with all unsafe operations defined on Integers:

---

Operator | Method        | Undefined in case of
---------|---------------|---------------------
`+~`     | add_unsafe()  | Overflow  E.g. `I32.max_value() +~ I32(1)`
`-~`     | sub_unsafe()  | Overflow
`*~`     | mul_unsafe()  | Overflow.
`/~`     | div_unsafe()  | Division by zero and Overflow. E.g. I32.min_value() / I32(-1)
`%~`     | mod_unsafe()  | Division by zero and OverFlow.
`-~`     | neg_unsafe()  | Overflow. E.g. `-~I32.max_value()`
`>>~`    | shr_unsafe()  | If non-zero bits are shifted out. E.g. `I32(1) >>~ U32(2)`
`<<~`    | shl_unsafe()  | If bits differing from the final sign bit are shifted out.

---

#### Unsafe Conversion

Converting between integer types in Pony needs to happen explicitly. Each numeric type can be converted explicitly into every other type.

```pony
// converting an I32 to a 32 bit floating point
I32(12).f32()
```

For each conversion operation there exists an unsafe counterpart, that is much faster when converting from and to floating point numbers. All these unsafe conversion between numeric types are undefined if the target type is smaller than the source type, e.g. if we convert from `I64` to `F32`.

```pont
// converting an I32 to a 32 bit floating point, the unsafe way
I32(12).f32_unsafe()

// an example for an undefined unsafe conversion
I64.max_value().f32_unsafe()

// an example for an undefined unsafe conversion, that is actually safe
I64(1).u8_unsafe()
```

Here is a full list of all available conversions for numeric types:

---

Safe conversion | Unsafe conversion
----------------|------------------
u8()            |  u8_unsafe()
u16             |  u16_unsafe()
u32()           |  u32_unsafe()
u64()           |  u64_unsafe()
u128()          |  u128_unsafe()
ulong()         |  ulong_unsafe()
usize()         |  usize_unsafe()
i8()            |  i8_unsafe()
i16()           |  i16_unsafe()
i32()           |  i32_unsafe()
i64()           |  i64_unsafe()
i128()          |  i128_unsafe()
ilong()         |  ilong_unsafe()
isize()         |  isize_unsafe()
f32()           |  f32_unsafe()
f64()           |  f64_unsafe()

---

### Partial and Checked Arithmetic

If overflow or division by zero are cases that need to be avoided and performance is no critical priority, partial or checked arithmetic offer great safety during runtime. Partial arithmetic operators error on overflow/underflow and division by zero. Checked arithmetic methods return a tuple of the result of the operation and a `Boolean` indicating overflow or other exceptional behaviour.

```pony
// partial arithmetic
let result =
  try
    I32.max_value() +? env.args.size()
  else
    env.out.print("overflow detected")
  end

// checked arithmetic
let result =
  match U64.max_value().addc(env.args.size())
  | (let result: U64, false) => 
    // use result
    ...
  | (_, true) =>
    env.out.print("overflow detected")
  end
```

Partial as well as checked arithmetic comes with the burden of handling exceptions on every case and incurs some performance overhead, be warned.

---

Partial Operator | Method        | Description
-----------------|---------------|------------
`+?`             | add_partial() | errors on overflow/underflow
`-?`             | sub_partial() | errors on overflow/underflow
`*?`             | mul_partial() | errors on overflow/underflow
`/?`             | div_partial() | errors on overflow/underflow and division by zero
`%?`             | mod_partial() | errors on overflow/underflow and division by zero

---

Checked Method | Description
---------------|------------
addc()         | returns a `Boolean` flag indicating overflow/underflow and the result in a tuple.
subc()         | returns a `Boolean` flag indicating overflow/underflow and the result in a tuple.
mulc()         | returns a `Boolean` flag indicating overflow/underflow and the result in a tuple.

---

## Floating Point

Pony default arithmetic on floating point numbers (`F32`, `F64`) behave as defined in the floating point standard `IEEE 754`.

That means e.g. that division by `+0` returns `Inf` and by `-0` returns `-Inf`.


### Unsafe Arithmetic

Unsafe Floating Point operations do not necessarily comply with `IEEE 754` for every input or every result. If any argument to an unsafe operation is or its result would expected to be `+/-Inf` or `NaN`, the result is actually undefined.

This allows more aggressive optimizations and for faster execution, but only yields valid results for values differend that the exceptional values `+/-Inf` and `NaN`. We suggest to only use these if you can exclude those cases.

---

Operator | Method        
---------|---------------
`+~`     | add_unsafe()  
`-~`     | sub_unsafe()  
`*~`     | mul_unsafe()  
`/~`     | div_unsafe()  
`%~`     | mod_unsafe()  
`-~`     | neg_unsafe()  
`<~`     | lt_unsafe()   
`>~`     | gt_unsafe()  
`<=~`    | le_unsafe()   
`>=~`    | ge_unsafe()   
`=~`     | eq_unsafe()   
`!=~`    | ne_unsafe()   

---

Additionally `sqrt_unsafe()` is undefined for negative values.



