# Literals

***What do we want?***

Values!

**Where do we want them?***

In our pony programs!

**Say no more**

Every programming language has literals to encode values of certain types,
and so does Pony.

In pony you can express booleans, numeric types, characters, strings
and arrays as literals.

## Bool Literals

There is ``true``, there is ``false``. That's it.

## Numeric Literals

Numeric literals can be used to encode any signed or unsigned integer
or floating point number.

In most cases pony is able to infer the concrete type of the literal from
the context where it is used (Assignment to a field or local variable,
as argument to a method/behavior call).

It is possible to help the compiler determine the concrete type of the literal
using a constructor of one of the numeric types:

 * U8, U16, U32, U64, U128, USize, ULong
 * I8, I16, I32, I64, I128, ISize, ILong
 * F32, F64

```pony
let my_explicit_unsigned: U32 = 42_000
let my_constructor_unsigned = U8(1)
let my_constructor_float = F64(1.234)
```

Integer literals can be given as decimal, hexadecimal
or binary:

```pony
let my_decimal_int: I32 = 1024
let my_hexadecimal_int: I32 = 0x400
let my_binary_int: I32 = 0b10000000000
```

Floating Point literals are expressed as standard floating point 
or scientific notation:

```pony
let my_double_precision_float: F64 = 0.009999999776482582092285156250
let my_scientific_float: F32 = 42.12e-4
```

## Character Literals

Character literals are enclosed with single quotes (``'``).

They are used to encode single byte characters 
but can be coerced to any numeric type:

```pony
let big_a: U8 = 'A'
let hex_escaped_char: U8 = '\x41'
let newline: U32 = '\n'
```

The following escape sequences are supported:

* ``\x4F`` hex escape sequence for unicode letters with 2 hex digits (up to 0xFF)
* ``\a``, ``\b``, ``\e``, ``\f``, ``\n``, ``\r``, ``\t``, ``\v``, ``\\``, ``\0``, ``\"``

The empty character literal ``''`` is treated as ``0``.


## String Literals

String literals are enclosed by single quotes ``"`` or triple quotes ``"""``.
They can contain any unicode characters and various escape sequences:

* ``\u00FE`` unicode escape sequence with 4 hex digits encoding one code point
* ``\u10FFFE`` unicode escape sequence with 6 hex digits encoding one code point
* ``\x4F`` hex escape sequence for unicode letters with 2 hex digits (up to 0xFF)
* ``\a``, ``\b``, ``\e``, ``\f``, ``\n``, ``\r``, ``\t``, ``\v``, ``\\``, ``\0``, ``\"``

Each escape sequence encodes a full character, not byte.

```pony

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

### Triple quoted Strings

For embedding multi-line text in string literals,
there are triple quoted strings.

```pony
let triple_quoted_string_docs =
  """
  Triple quoted strings are the way to go for long multiline text.
  They are extensively used as docstrings which are turned into api documentation.

  They get some special treatment, in order to keep pony code readable:

  * The string literal starts on the line after the opening triple quote.
  * Common indentation is removed from the string literal
    so it can be conveniently aligned with the enclosing indentation
    e.g. each line of this literal will get its first two whitespaces removed
  * Whitespace after the opening and before the closing triple quote will be
    removed as well. The first line will be completely removed.
    if it only contains whitespace.
    e.g. this strings first character is ``T`` not ``\n``.
  """
```

## Array Literals

Array literals are enclosed by square brackets.
Array literal elements can be any kind of expressions.
They are separated by semicolon or newline:

```pony
let my_literal_array = [ "first"; "second"
  "third one on a new line"]
```

Empty array literals are not supported.
Use ``recover val Array(0) end`` instead.

### Type inference


The type of the literal array expression is Always ``Array[T] ref``
where ``T`` (the type of the elements) is inferred as 
the union type of all the element types:

```pony
let my_heterogenous_array: Array[(U64|String)] ref = [
  U64(42)
  "42"
  U64.min_value()
]
```

In the above example the resulting array type will be
``Array[(U64|String)] ref`` because the array contains
``String`` and ``U64`` elements.

It is possible to give the literal a hint on what kind of type it should
coerce the array literal to. In the above example
we might only want an ``Array[Stringable] ref``. ``Stringable`` is a trait
that both ``String`` and ``U64`` implement.

In order to do so, add an ``as`` Expression
defining the desired Array element type right after the opening square bracket
delimited by a colon:

```pony
let my_stringable_array: Array[Stringable] ref =
  [as Stringable:
    U64(0xFFEF)
    "0xFFEF"
    U64(1 + 1)
  ]
```

This Array literal is coerced to be an ``Array[Stringable] ref`` according to
the ``as`` expression.

Inferring the element type from the type of the local variable
or field it is assigned to is not yet possible:

```pony
// does not compile
let my_stringable_array: Array[Stringable] =
  [
    U64(0xA)
    "0xA"
  ]
```

### Arrays and References

*This section will lead you down the rabbit-hole of
[Reference capabilities](../capabilities/index.md).
It is advised to make yourself familiar with that concept first before reading this.*

To be 100% technically correct, array literal elements are inferred
to be the alias of the the actual element type.
If all elements are of type ``T`` the array literal will be inferred as
``Array[T!]`` that is as an array of aliases of the type ``T``.

***Why is that?***

Arrays store references to their elements, not the elements themselves.
There might exist another reference somewhere else to an array element.
In order to safely use ``Array`` with elements of all types and
reference capabilities (including ``iso``), the only possibility is to store
the elements as an alias to that type: ``T!``

To safely create an array literal of type ``Array[T]`` it is necessary
to use elements of type ``T^``, an ephemeral type of ``T``;
A ``T`` that is not assigned to any variable yet.
"Consuming" a variable returns an ephemeral type,
all constructors return ephemeral types, and other literal expressions work
the same:

```pony
let ref = U64(123)
let safe_array: Array[U64 val] =
  [
    consume ref     // consuming a variable
    U64.create(1)   // constructor
    U64.min_value() // constructor
  ]
```

Most of the time constructing array literals is not a problem,
especially when using only literal elements (Strings, Numbers).
These have the reference capability ``val`` which is safe to alias multiple
times and whose aliases are safe to also be ``val``.
So this just works:

```pony
let safe_array: Array[String val] = [
  "A"
  "B"
  "C"
]
```

Because it is equivalent to this:

```pony
let explicit_safe_array: Array[String val!] = [
  "A"
  "B"
  "C"
]
```

#### More Details

Consider the following example:

```pony
// does not compile
let s: String iso = recover iso String(0) end
let array: Array[String iso] = [s]
```

*It does not work. Why?*

The variable ``s`` is of type ``String iso``,
it has the reference capability ``iso`` which allows only 1 reference
to this object. The only way to safely refer to such an ``iso`` object
with another variable is as type ``String tag`` (technically ``String iso!``)
which only allows to get its identity, nothing more.

The Array literal is thus inferred as ``Array[String tag]``, not ``Array[iso]``
because it creates additional references/aliases to its elements.
This is not the type specified on the left-hand side, so it errors.

These are valid ways to construct Arrays of ``iso`` elements without
getting into trouble with the compiler:

```pony
let s: String iso = recover iso String(0) end
let tag_array: Array[String tag] = [s]          // use the alias type for the array

let iso_array: Array[String iso] = [consume s]  // consume the iso variable
```
