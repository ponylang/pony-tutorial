# Arithmetic

Arithmetic is about the stuff you learn to do with numbers in primary school: Addition, Subtraction, Multiplication, Division and so on. Piece of cake. We all know that stuff. We nonetheless want to spend a whole section on this topic, because when it comes to computers the devil is in the details.

As introduced in [Primitives](/types/primitives.md#built-in-primitive-types) numeric types in Pony are represented as a special kind of primitive that maps to machine words. Both integer types and floating point types support a rich set of arithmetic and bit-level operations. These are expressed as [Infix Operators](/expressions/ops.md#infix-operators) that are implemented as plain functions on the numeric primitive types.

Pony focuses on two goals, performance and safety. From time to time, these two goals collide. This is true especially for arithmetic on integers and floating point numbers. Safe code should check for overflow, division by zero and other error conditions on each operation where it can happen. Pony tries to enforce as many safety invariants at compile time as it possibly can, but checks on arithmetic operations can only happen at runtime. Code focused on performance should execute integer arithmetic as fast and with as few CPU cycles as possible. Checking for overflow is expensive, doing plain dangerous arithmetic that is possibly subject to overflow is cheap.

Pony provides different ways of doing arithmetic to give programmers the freedom to chose which operation suits best for them, the safe but slower operation or the fast one, because performance is crucial for the use case.

## Numeric Fundamentals

Already familiar with integer widths, signed vs. unsigned, and overflow? [Skip ahead](#integers).

### Integer Widths

The number in a type name like `U8` or `I32` is the number of bits used to store the value. More bits means a wider range of representable values:

| Type  | Bits | Minimum | Maximum |
| ----- | ---- | ------- | ------- |
| `U8`  | 8    | 0       | 255     |
| `I8`  | 8    | -128    | 127     |
| `U32` | 32   | 0       | 4294967295 |
| `I32` | 32   | -2147483648 | 2147483647 |

The pattern: an N-bit unsigned type can hold values from 0 to 2<sup>N</sup> - 1. An N-bit signed type splits its range roughly in half, covering -2<sup>N-1</sup> to 2<sup>N-1</sup> - 1.

### Signed vs. Unsigned

Unsigned integer types (`U8`, `U16`, `U32`, etc.) represent only non-negative values. All N bits contribute to the magnitude, so the maximum value for a `U8` is 255 (2<sup>8</sup> - 1).

Signed integer types (`I8`, `I16`, `I32`, etc.) use two's complement representation, which gives them an asymmetric range. For example, `I8` covers -128 to 127, not -127 to 127. There is one more negative value than positive because zero takes up one of the non-negative slots.

### Overflow and Underflow

When an arithmetic operation produces a result outside the representable range, it overflows (too large) or underflows (too small). With fixed-width integers, wrap-around can occur:

```pony
--8<-- "arithmetic-numeric-fundamentals.pony"
```

This wrap-around behaviour is a consequence of how fixed-width binary arithmetic works — the result is computed and then only the low N bits are kept. Different languages handle this differently: some leave it undefined, some throw an exception, and Pony wraps around by default. The next section covers Pony's specific approach in detail.

## Integers

### Pony's default Integer Arithmetic

Doing arithmetic on integer types in Pony with the well known operators like `+`, `-`, `*`, `/` etc. tries to balance the needs for performance and correctness. All default arithmetic operations do not expose any undefined behaviour or error conditions. That means it handles both the cases for overflow/underflow and division by zero. Overflow and underflow are handled with wrap-around semantics, using two's complement representation for signed integers. In that respect we get behaviour like:

```pony
--8<-- "arithmetic-default-integer-arithmetic.pony"
```

Division by zero is a special case, which affects the division `/` and remainder `%` operators. In Mathematics, division by zero is undefined. In order to avoid either defining division as partial, throwing an error on division by zero or introducing undefined behaviour for that case, the _normal_ division is defined to be `0` when the divisor is `0`. This might lead to silent errors, when used without care. Choose [Partial and checked Arithmetic](#partial-and-checked-arithmetic) to detect division by zero.

In contrast to [Unsafe Arithmetic](#unsafe-integer-arithmetic) default arithmetic comes with a small runtime overhead because unlike the unsafe variants, it does detect and handle overflow and division by zero.

---

| Operator | Method | Description                                   |
| -------- | ------ | --------------------------------------------- |
| `+`      | `add()`  | wrap around on over-/underflow                |
| `-`      | `sub()`  | wrap around on over-/underflow                |
| `*`      | `mul()`  | wrap around on over-/underflow                |
| `/`      | `div()`  | `x / 0 = 0`                                   |
| `%`      | `rem()`  | `x % 0 = 0`                                   |
| `%%`     | `mod()`  | `x %% 0 = 0`                                  |
| `-`      | `neg()`  | wrap around on over-/underflow                |
| `>>`     | `shr()`  | filled with zeros, so `x >> 1 == x/2` is true |
| `<<`     | `shl()`  | filled with zeros, so `x << 1 == x*2` is true |

---

### Unsafe Integer Arithmetic

Unsafe integer arithmetic comes close to what you can expect from integer arithmetic in C. No checks, _raw speed_, possibilities of overflow, underflow or division by zero. Like in C, overflow, underflow and division by zero scenarios are undefined. Don't rely on the results in these cases. It could be anything and is highly platform specific. Division by zero might even crash your program with a `SIGFPE`. Our suggestion is to use these operators only if you can make sure you can exclude these cases.

Here is a list with all unsafe operations defined on Integers:

---

| Operator | Method       | Undefined in case of                                          |
| -------- | ------------ | ------------------------------------------------------------- |
| `+~`     | `add_unsafe()` | Overflow  E.g. `I32.max_value() +~ I32(1)`                    |
| `-~`     | `sub_unsafe()` | Overflow                                                      |
| `*~`     | `mul_unsafe()` | Overflow.                                                     |
| `/~`     | `div_unsafe()` | Division by zero and overflow. E.g. `I32.min_value() / I32(-1)` |
| `%~`     | `rem_unsafe()` | Division by zero and overflow.                                |
| `%%~`    | `mod_unsafe()` | Division by zero and overflow.                                |
| `-~`     | `neg_unsafe()` | Overflow. E.g. `-~I32.max_value()`                            |
| `>>~`    | `shr_unsafe()` | If non-zero bits are shifted out. E.g. `I32(1) >>~ U32(2)`    |
| `<<~`    | `shl_unsafe()` | If bits differing from the final sign bit are shifted out.    |

---

#### Unsafe Conversion

Converting between integer types in Pony needs to happen explicitly. Each numeric type can be converted explicitly into every other type.

```pony
--8<-- "arithmetic-explicit-numeric-conversion.pony"
```

For each conversion operation there exists an unsafe counterpart, that is much faster when converting from and to floating point numbers. All these unsafe conversion between numeric types are undefined if the target type is smaller than the source type, e.g. if we convert from `I64` to `F32`.

```pony
--8<-- "arithmetic-unsafe-conversion.pony"
```

Here is a full list of all available conversions for numeric types:

---

| Safe conversion | Unsafe conversion |
| --------------- | ----------------- |
| `u8()`            | `u8_unsafe()`       |
| `u16()`           | `u16_unsafe()`      |
| `u32()`           | `u32_unsafe()`      |
| `u64()`           | `u64_unsafe()`      |
| `u128()`          | `u128_unsafe()`     |
| `ulong()`         | `ulong_unsafe()`    |
| `usize()`         | `usize_unsafe()`    |
| `i8()`            | `i8_unsafe()`       |
| `i16()`           | `i16_unsafe()`      |
| `i32()`           | `i32_unsafe()`      |
| `i64()`           | `i64_unsafe()`      |
| `i128()`          | `i128_unsafe()`     |
| `ilong()`         | `ilong_unsafe()`    |
| `isize()`         | `isize_unsafe()`    |
| `f32()`           | `f32_unsafe()`      |
| `f64()`           | `f64_unsafe()`      |

---

### Partial and Checked Arithmetic

If overflow or division by zero are cases that need to be avoided and performance is no critical priority, partial or checked arithmetic offer great safety during runtime. Partial arithmetic operators error on overflow/underflow and division by zero. Checked arithmetic methods return a tuple of the result of the operation and a `Boolean` indicating overflow or other exceptional behaviour.

```pony
--8<--
arithmetic-partial-and-check-arithmetic.pony:7:14
arithmetic-partial-and-check-arithmetic.pony:16:20
arithmetic-partial-and-check-arithmetic.pony:22:22
arithmetic-partial-and-check-arithmetic.pony:24:26
--8<--
```

Partial as well as checked arithmetic comes with the burden of handling exceptions on every case and incurs some performance overhead, be warned.

| Partial Operator | Method        | Description                                       |
| ---------------- | ------------- | ------------------------------------------------- |
| `+?`             | `add_partial()` | errors on overflow/underflow                      |
| `-?`             | `sub_partial()` | errors on overflow/underflow                      |
| `*?`             | `mul_partial()` | errors on overflow/underflow                      |
| `/?`             | `div_partial()` | errors on overflow/underflow and division by zero |
| `%?`             | `rem_partial()` | errors on overflow/underflow and division by zero |
| `%%?`            | `mod_partial()` | errors on overflow/underflow and division by zero |

---

Checked arithmetic functions all return the result of the operation and a `Boolean` flag indicating overflow/underflow or division by zero in a tuple.

| Checked Method | Description                                                                               |
| -------------- | ----------------------------------------------------------------------------------------- |
| `addc()`         | Checked addition, second tuple element is `true` on overflow/underflow.                   |
| `subc()`         | Checked subtraction, second tuple element is `true` on overflow/underflow.                |
| `mulc()`         | Checked multiplication, second tuple element is `true` on overflow.                       |
| `divc()`         | Checked division, second tuple element is `true` on overflow or division by zero.         |
| `remc()`         | Checked remainder, second tuple element is `true` on overflow or division by zero.        |
| `modc()`         | Checked modulo, second tuple element is `true` on overflow or division by zero.           |
| `fldc()`         | Checked floored division, second tuple element is `true` on overflow or division by zero. |

---

## Floating Point

Pony default arithmetic on floating point numbers (`F32`, `F64`) behave as defined in the floating point standard IEEE 754.

That means e.g. that division by `+0` returns `Inf` and by `-0` returns `-Inf`.

### Unsafe Floating Point Arithmetic

Unsafe Floating Point operations do not necessarily comply with IEEE 754 for every input or every result. If any argument to an unsafe operation or its result are `+/-Inf` or `NaN`, the result is actually undefined.

This allows more aggressive optimizations and for faster execution, but only yields valid results for values different that the exceptional values `+/-Inf` and `NaN`. We suggest to only use unsafe arithmetic on floats if you can exclude those cases.

---

| Operator | Method       |
| -------- | ------------ |
| `+~`     | `add_unsafe()` |
| `-~`     | `sub_unsafe()` |
| `*~`     | `mul_unsafe()` |
| `/~`     | `div_unsafe()` |
| `%~`     | `rem_unsafe()` |
| `%%~`    | `mod_unsafe()` |
| `-~`     | `neg_unsafe()` |
| `<~`     | `lt_unsafe()`  |
| `>~`     | `gt_unsafe()`  |
| `<=~`    | `le_unsafe()`  |
| `>=~`    | `ge_unsafe()`  |
| `=~`     | `eq_unsafe()`  |
| `!=~`    | `ne_unsafe()`  |

---

Additionally `sqrt_unsafe()` is undefined for negative values.
