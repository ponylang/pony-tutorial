# Arithmetic

Pony focusses on two goals, performance and safety. From time to time, these two goals collide. This is true especially for arithmetic on integers and floating point numbers. Safe code should check for overflow, division by zero and other error conditions on each operation where it can happen. Pony tries to enforce as much safety invariants at compile time as it possibly can, but checks on arithmetic operations can only happen at runtime. Performant code should execute integer arithmetic as fast and with as few CPU cycles as possible. Checking for overflow is expensive, doing plain dangerous arithmetic that is possibly subject to overflow is cheap.

Pony provides different ways of doing arithmetic to give the programmer the freedom to chose which operation suits best for him, the safe but slower operation or the fast one, because performance is crucial for the use case.

## Integers

### Ponys default Arithmetic

### Unsafe Arithmetic

Unsafe integer arithmetic comes close to what you can expect from integer arithmetic in C. No checks, raw speed, possibilities of overflow, underflow or division by zero.
Like in C, overflow, underflow and division by zero scenarios are undefined. Don't rely on the results in these cases. It could be anything and is highly platform specific.
Our suggestion is to use these operators only if you can make sure you can exclude these cases.

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

For each conversion operation there exists an unsafe counterpart, that is much faster when converting from and to floating point numbers.
All these unsafe conversion between numeric types are undefined if the target type is smaller than the source type, e.g. if we convert from `I64` to `F32`.

```pont
// converting an I32 to a 32 bit floating point, the unsafe way
I32(12).f32_unsafe()

// an example for an undefined unsafe conversion
I64.max_value().f32_unsafe()

// an example for an undefined unsafe conversion, that is actually safe
I64(1).u8_unsafe()
```

Safe conversion | Unsafe conversion
----------------|------------------
u8
u16


### Partial and Checked Arithmetic

## Floating Point

Additionally for Floating Point numbers, the following unsafe methods are defined

Operator | Methid        | Undefined in case of
---------|---------------|---------------------
`<~`     | lt_unsafe()   |
`>~`     | gt_unsafe()   |
`<=~`    | le_unsafe()   |
`>=~`    | ge_unsafe()   |
`=~`     | eq_unsafe()   |
`!=~`    | ne_unsafe()   |

## Numeric Primitives

As introduced in [Primitives](../primitives.md#built-in-primitive-types) numeric types in Pony are represented as a special kind of primitive that maps to machine words. Both integer types and floating point types support a rich set of arithmetic and bit-level operations.
These are expressed as infix operators that are implemented as plain functions on the numeric primitive types.



