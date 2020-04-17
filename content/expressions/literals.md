---
title: "Literals"
section: "Expressions"
toc: true
menu:
  toc:
    parent: "expressions"
    weight: 10
toc: true
---

***What do we want?***

Values!

***Where do we want them?***

In our Pony programs!

**Say no more**

Every programming language has literals to encode values of certain types, and so does Pony.

In Pony you can express booleans, numeric types, characters, strings and arrays as literals.

## Bool Literals

There is `true`, there is `false`. That's it.

## Numeric Literals

Numeric literals can be used to encode any signed or unsigned integer or floating point number.

In most cases Pony is able to infer the concrete type of the literal from the context where it is used (e.g. assignment to a field or local variable or as argument to a method/behaviour call).

It is possible to help the compiler determine the concrete type of the literal using a constructor of one of the numeric types:

 * U8, U16, U32, U64, U128, USize, ULong
 * I8, I16, I32, I64, I128, ISize, ILong
 * F32, F64

```pony
let my_explicit_unsigned: U32 = 42_000
let my_constructor_unsigned = U8(1)
let my_constructor_float = F64(1.234)
```

Integer literals can be given as decimal, hexadecimal or binary:

```pony
let my_decimal_int: I32 = 1024
let my_hexadecimal_int: I32 = 0x400
let my_binary_int: I32 = 0b10000000000
```

Floating Point literals are expressed as standard floating point or scientific notation:

```pony
let my_double_precision_float: F64 = 0.009999999776482582092285156250
let my_scientific_float: F32 = 42.12e-4
```

## Character Literals

Character literals are enclosed with single quotes (`'`).

Character literals, unlike String literals, encode to a single numeric value. Usually this is a single byte, a `U8`. But they can be coerced to any integer type:

```pony
let big_a: U8 = 'A'                 // 65
let hex_escaped_big_a: U8 = '\x41'  // 65
let newline: U32 = '\n'             // 10
```

The following escape sequences are supported:

* `\x4F` hex escape sequence with 2 hex digits (up to 0xFF)
* `\a`, `\b`, `\e`, `\f`, `\n`, `\r`, `\t`, `\v`, `\\`, `\0`, `\'`

### Multibyte Character literals

It is possible to have character literals that contain multiple characters. The resulting integer value is constructed byte by byte with each character representing a single byte in the resulting integer, the last character being the least significant byte:

```pony
let multiByte: U64 = 'ABCD' // 0x41424344
```


## String Literals

String literals are enclosed with double quotes `"` or triple-quoted `"""`. They can contain any kind of bytes and various escape sequences:

* `\u00FE` unicode escape sequence with 4 hex digits encoding one code point
* `\u10FFFE` unicode escape sequence with 6 hex digits encoding one code point
* `\x4F` hex escape sequence for unicode letters with 2 hex digits (up to 0xFF)
* `\a`, `\b`, `\e`, `\f`, `\n`, `\r`, `\t`, `\v`, `\\`, `\0`, `\"`

Each escape sequence encodes a full character, not byte.

```pony
use "format"

actor Main
  new create(env: Env) =>

    let pony = "🐎"
    let pony_hex_escaped = "p\xF6n\xFF"
    let pony_unicode_escape = "\U01F40E"

    env.out.print(pony + " " + pony_hex_escaped + " " + pony_unicode_escape)
    for b in pony.values() do
      env.out.print(Format.int[U8](b, FormatHex))
    end

```

All string literals support multiline strings:

```pony

let stacked_ponies = "
🐎
🐎
🐎
"
```

### String Literals and Encodings

String Literals contain the bytes that were read from their source code file. Their actual value thus depends on the encoding of their source.

Consider the following example:

```pony
let u_umlaut = "ü"
```

If the file containing this code is encoded as *UTF-8* the byte-value of `u_umlaut` will be: `\xc3\xbc`. If the file is encoded with *ISO-8559-1* (Latin-1) its value will be `\xfc`.

### Triple quoted Strings

For embedding multi-line text in string literals, there are triple quoted strings.

```pony
let triple_quoted_string_docs =
  """
  Triple quoted strings are the way to go for long multiline text.
  They are extensively used as docstrings which are turned into api documentation.

  They get some special treatment, in order to keep Pony code readable:

  * The string literal starts on the line after the opening triple quote.
  * Common indentation is removed from the string literal
    so it can be conveniently aligned with the enclosing indentation
    e.g. each line of this literal will get its first two whitespaces removed
  * Whitespace after the opening and before the closing triple quote will be
    removed as well. The first line will be completely removed if it only 
    contains whitespace. e.g. this strings first character is `T` not `\n`.
  """
```

### String Literal Instances

When a single string literal is used several times in your Pony program, all of them will be converted to a single common instance. This means they will always be equal based on identity.

```pony
let pony = "🐎"
let another_pony = "🐎"
if pony is another_pony then
  // True, therefore this line will run.
end
```

## Array Literals

Array literals are enclosed by square brackets. Array literal elements can be any kind of expressions. They are separated by semicolon or newline:

```pony
let my_literal_array =
  [
    "first"; "second"
    "third one on a new line"
  ]
```

### Type inference

If the type of the array is not specified, the resulting type of the literal array expression is `Array[T] ref` where `T` (the type of the elements) is inferred as the union of all the element types:

```pony
let my_heterogenous_array = 
  [
    U64(42)
    "42"
    U64.min_value()
  ]
```

In the above example the resulting array type will be `Array[(U64|String)] ref` because the array contains `String` and `U64` elements.

If the variable or call argument the array literal is assigned to has a type, the literal is coerced to that type:

```pony
let my_stringable_array: Array[Stringable] ref =
  [
    U64(0xA)
    "0xA"
  ]
```

Here `my_stringable_array` is coerced to `Array[Stringable] ref`. This works because `Stringable` is a trait that both `String` and `U64` implement.

It is also possible to return an array with a different [Reference Capability]({{< relref "reference-capabilities/_index.md" >}}) than `ref` just by specifying it on the type:

```pony
let my_immutable_array: Array[Stringable] val =
  [
    U64(0xBEEF)
    "0xBEEF"
  ]
```

This way array literals can be used for creating arrays of any [Reference Capability]({{< relref "reference-capabilities/_index.md" >}}).

### `As` Expression

It is also possible to give the literal a hint on what kind of type it should coerce the array elements to using an `as` Expression. The expression with the desired array element type needs to be added right after the opening square bracket, delimited by a colon:

```pony
let my_as_array =
  [ as Stringable:
    U64(0xFFEF)
    "0xFFEF"
    U64(1 + 1)
  ]
```

This array literal is coerced to be an `Array[Stringable] ref` according to the `as` expression.

If a type is specified on the left-hand side, it needs to exactly match the type in the `as` expression.

### Arrays and References

Constructing an array with a literal creates new references to its elements. Thus, to be 100% technically correct, array literal elements are inferred to be the alias of the actual element type. If all elements are of type `T` the array literal will be inferred as `Array[T!] ref` that is as an array of aliases of the type `T`. 

It is thus necessary to use elements that can have more than one reference of the same type (e.g. types with `val` or `ref` capability) or use ephemeral types for other capabilities (as returned from [constructors]({{< relref "types/classes.md#constructors" >}}) or the [consume expression]({{< relref "reference-capabilities/consume-and-destructive-read.md" >}})).
