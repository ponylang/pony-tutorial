# Literals

***What do we want?***

Values!

***Where do we want them?***

In our Pony programs!

***Say no more***

Every programming language has literals to encode values of certain types, and so does Pony.

In Pony you can express booleans, numeric types, characters, strings and arrays as literals.

## Boolean Literals

There is `true`, there is `false`. That's it.

## Numeric Literals

Numeric literals can be used to encode any signed or unsigned integer or floating point number.

In most cases Pony is able to infer the concrete type of the literal from the context where it is used (e.g. assignment to a field or local variable or as argument to a method/behaviour call).

It is possible to help the compiler determine the concrete type of the literal using a constructor of one of the numeric types:

* `U8`, `U16`, `U32`, `U64`, `U128`, `USize`, `ULong`
* `I8`, `I16`, `I32`, `I64`, `I128`, `ISize`, `ILong`
* `F32`, `F64`

```pony
--8<-- "literals-numeric-typing.pony"
```

Integer literals can be given as decimal, hexadecimal or binary:

```pony
--8<-- "literals-number-types.pony:3:5"
```

Floating Point literals are expressed as standard floating point or scientific notation:

```pony
--8<-- "literals-floats.pony"
```

## Character Literals

Character literals are enclosed with single quotes (`'`).

Character literals, unlike String literals, encode to a single numeric value. Usually this is a single byte, a `U8`. But they can be coerced to any integer type:

```pony
--8<-- "literals-character-literals.pony:3:5"
```

The following escape sequences are supported:

* `\x4F` hex escape sequence with 2 hex digits (up to `0xFF`)
* `\a`, `\b`, `\e`, `\f`, `\n`, `\r`, `\t`, `\v`, `\\`, `\0`, `\'`

### Multibyte Character literals

It is possible to have character literals that contain multiple characters. The resulting integer value is constructed byte by byte with each character representing a single byte in the resulting integer, the last character being the least significant byte:

```pony
--8<-- "literals-multibyte-character-literals.pony"
```

## String Literals

String literals are enclosed with double quotes `"` or triple-quoted `"""`. They can contain any kind of bytes and various escape sequences:

* `\u00FE` Unicode escape sequence with 4 hex digits encoding one code point
* `\u10FFFE` Unicode escape sequence with 6 hex digits encoding one code point
* `\x4F` hex escape sequence for Unicode letters with 2 hex digits (up to `0xFF`)
* `\a`, `\b`, `\e`, `\f`, `\n`, `\r`, `\t`, `\v`, `\\`, `\0`, `\"`

Each escape sequence encodes a full character, not byte.

```pony
--8<-- "literals-string-literals.pony"
```

All string literals support multi-line strings:

```pony
--8<-- "literals-multi-line-string-literals.pony"
```

### String Literals and Encodings

String Literals contain the bytes that were read from their source code file. Their actual value thus depends on the encoding of their source.

Consider the following example:

```pony
--8<-- "literals-string-literals-encoding.pony:3:3"
```

If the file containing this code is encoded as `UTF-8` the byte-value of `u_umlaut` will be: `\xc3\xbc`. If the file is encoded with *ISO-8559-1* (Latin-1) its value will be `\xfc`.

### Triple quoted Strings

For embedding multi-line text in string literals, there are triple quoted strings.

```pony
--8<-- "literals-triple-quoted-string-literals.pony"
```

### String Literal Instances

When a single string literal is used several times in your Pony program, all of them will be converted to a single common instance. This means they will always be equal based on identity.

```pony
--8<--
literals-string-literals-instances.pony:3:6
literals-string-literals-instances.pony:10:10
--8<--
```

## Array Literals

Array literals are enclosed by square brackets. Array literal elements can be any kind of expressions. They are separated by semicolon or newline:

```pony
--8<-- "literals-array-literals.pony"
```

### Type inference

If the type of the array is not specified, the resulting type of the literal array expression is `Array[T] ref` where `T` (the type of the elements) is inferred as the union of all the element types:

```pony
--8<-- "literals-type-inference-union.pony"
```

In the above example the resulting array type will be `Array[(U64|String)] ref` because the array contains `String` and `U64` elements.

If the variable or call argument the array literal is assigned to has a type, the literal is coerced to that type:

```pony
--8<-- "literals-type-inference-coercion.pony"
```

Here `my_stringable_array` is coerced to `Array[Stringable] ref`. This works because `Stringable` is a trait that both `String` and `U64` implement.

It is also possible to return an array with a different [Reference Capability](/reference-capabilities/index.md) than `ref` just by specifying it on the type:

```pony
--8<-- "literals-type-inference-reference-capabilities.pony"
```

This way array literals can be used for creating arrays of any [Reference Capability](/reference-capabilities/index.md).

### `As` Expression

It is also possible to give the literal a hint on what kind of type it should coerce the array elements to using an `as` Expression. The expression with the desired array element type needs to be added right after the opening square bracket, delimited by a colon:

```pony
--8<-- "literals-as-expression.pony"
```

This array literal is coerced to be an `Array[Stringable] ref` according to the `as` expression.

If a type is specified on the left-hand side, it needs to exactly match the type in the `as` expression.

### Arrays and References

Constructing an array with a literal creates new references to its elements. Thus, to be 100% technically correct, array literal elements are inferred to be the alias of the actual element type. If all elements are of type `T` the array literal will be inferred as `Array[T!] ref` that is as an array of aliases of the type `T`.

It is thus necessary to use elements that can have more than one reference of the same type (e.g. types with `val` or `ref` capability) or use ephemeral types for other capabilities (as returned from [constructors](/types/classes.md#constructors) or the [consume expression](/reference-capabilities/consume-and-destructive-read.md)).
