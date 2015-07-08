Infix operators take two operands and are written between those operands. Arithmetic and comparison operators are the most common:

```pony
1 + 2
a < b
```

Pony has pretty much the same set of infix operators as other languages.

# Precedence

When using infix operators in complex expressions a key question is the __precedence__, i.e. which operator is evaluated first. Given this expression:

```pony
1 + 2 * 3
```

We will get a value of 9 if we evaluate the addition first and 7 if we evaluate the multiplication first. In mathematics there are rules about the order in which to evaluate operators and most programming languages follow this approach.

The problem with this is that the programmer has to remember the order and people aren't very good at things like that. Most people will remember to do multiplication before addition, but what about left bit shifting versus bitwise and? Sometimes people misremember (or guess wrong) and that leads to bugs. Worse, those bugs are often very hard to spot.

Pony takes a different approach and outlaws infix precedence. Any expression where more than one infix operator is used __must__ use parentheses to remove the ambiguity. If you failure to do this the compiler will complain.

This means that the example above is illegal in Pony and should be rewritten as:

```pony
1 + (2 * 3)
```

Repeated use of a single operator however is fine:

```pony
1 + 2 + 3
```

# Operator aliasing

Most infix operators in Pony are actually aliases for functions. The left operand is the receiver the function is called on and the right operand is passed as an argument. For example the following expressions are equivalent:

```pony
x + y
x.add(y)
```

This means that `+` is not a special symbol that can only be applied to magic types. Any type can provide its own `add` function and the programmer can then use `+` with that type, if they want to.

When defining your own `add` function there is no restriction on the types of the parameter or the return type. The right side of the `+` will have to match the parameter type and the whole `+` expression will have the type that `add` returns.

Here's a full example for defining a type which allows use of `+`. This is all you need:

```pony
// Define a suitable type
class Pair
  var _x: U32 = 0
  var _y: U32 = 0
  
  new create(x: U32, y: U32) =>
    _x = x
	_y = y

  // Define a + function
  fun add(other: Pair): Pair =>
	Pair(_x + other._x, _y + other._y)

// Now let's use it
class Foo
  fun foo() =>
    var x = Pair(1, 2)
	var y = Pair(3, 4)
	var z = x + y
```

Since Pony does not allow overloading of functions by argument type, each type can only have a single `add` function. It is possible to overload infix operators to some degree using union types or f-bounded polymorphism, but this is beyond the scope of this tutorial. See the Pony standard library for further information.

You do not have to worry about any of this if you don't want to. You can simply use the existing infix operators for numbers just like any other language and not provide them for your own types.

The full list of infix operators that are aliases for functions is:

---

Operator | Method   | Description
---------|----------|------------
+        | add()    | Addition
-        | sub()    | Subtraction
*        | mul()    | Multiplication
/        | div()    | Division
%        | mod()    | Modulus
<<       | shl()    | Left bit shift
>>       | shr()    | Right bit shift
and      | op_and() | And, both bitwise and logical
or       | op_or()  | Or, both bitwise and logical
xor      | op_xor() | Xor, both bitwise and logical
==       | eq()     | Equality
!=       | ne()     | Non-equality
<        | lt()     | Less then
<=       | le()     | Less than or equal
>=       | ge()     | Greater than or equal
>        | gt()     | Greater than

---

# Short circuiting

The `and` and `or` operators use __short circuiting__ when used with Bool operators. This means that the first operand is always evaluated, but the second is only evaluated if it can affect the result.

For `and`, if the first operand is __false__ then the second operand is not evaluated, since it cannot affect the result.

For `or`, if the first operand is __true__ then the second operand is not evaluated, since it cannot affect the result.

This is a special feature built into the compiler, it cannot be used with operator aliasing for any other type.

# Unary operators

The unary operators are handled in the same manor, but with only one operand. For example the following expressions are equivalent:

```pony
-x
x.neg()
```

The full list of unary operators that are aliases for functions is:

---

Operator | Method   | Description
---------|----------|------------
-        | neg()    | Arithmetic negation
!        | op_not() | Not, both bitwise and logical

---
