# Operators

## Infix Operators

Infix operators take two operands and are written between those operands. Arithmetic and comparison operators are the most common:

```pony
--8<-- "operators-infix-operator.pony"
```

Pony has pretty much the same set of infix operators as other languages.

## Operator aliasing

Most infix operators in Pony are actually aliases for functions. The left operand is the receiver the function is called on and the right operand is passed as an argument. For example, the following expressions are equivalent:

```pony
--8<-- "operators-operator-aliasing.pony"
```

This means that `+` is not a special symbol that can only be applied to magic types. Any type can provide its own `add` function and the programmer can then use `+` with that type if they want to.

When defining your own `add` function there is no restriction on the types of the parameter or the return type. The right side of the `+` will have to match the parameter type and the whole `+` expression will have the type that `add` returns.

Here's a full example for defining a type which allows the use of `+`. This is all you need:

```pony
--8<--
operators-add.pony:8:19
operators-add.pony:23:29
--8<--
```

It is possible to overload infix operators to some degree using union types or f-bounded polymorphism, but this is beyond the scope of this tutorial. See the Pony standard library for further information.

You do not have to worry about any of this if you don't want to. You can simply use the existing infix operators for numbers just like any other language and not provide them for your own types.

The full list of infix operators that are aliases for functions is:

---

| Operator | Method         | Description                   | Note                           |
| -------- | -------------- | ----------------------------- | ------------------------------ |
| `+`      | `add()`          | Addition                      |
| `-`      | `sub()`          | Subtraction                   |
| `*`      | `mul()`          | Multiplication                |
| `/`      | `div()`          | Division                      |
| `%`      | `rem()`          | Remainder                     |
| `%%`     | `mod()`          | Modulo                        | Starting with version `0.26.1` |
| `<<`     | `shl()`          | Left bit shift                |
| `>>`     | `shr()`          | Right bit shift               |
| `and`    | `op_and()`       | And, both bitwise and logical |
| `or`     | `op_or()`        | Or, both bitwise and logical  |
| `xor`    | `op_xor()`       | Xor, both bitwise and logical |
| `==`     | `eq()`           | Equality                      |
| `!=`     | `ne()`           | Non-equality                  |
| `<`      | `lt()`           | Less than                     |
| `<=`     | `le()`           | Less than or equal            |
| `>=`     | `ge()`           | Greater than or equal         |
| `>`      | `gt()`           | Greater than                  |
| `>~`     | `gt_unsafe()`    | Unsafe greater than           |
| `+~`     | `add_unsafe()`   | Unsafe Addition               |
| `-~`     | `sub_unsafe()`   | Unsafe Subtraction            |
| `*~`     | `mul_unsafe()`   | Unsafe Multiplication         |
| `/~`     | `div_unsafe()`   | Unsafe Division               |
| `%~`     | `rem_unsafe()`   | Unsafe Remainder              |
| `%%~`    | `mod_unsafe()`   | Unsafe Modulo                 | Starting with version `0.26.1` |
| `<<~`    | `shl_unsafe()`   | Unsafe left bit shift         |
| `>>~`    | `shr_unsafe()`   | Unsafe right bit shift        |
| `==~`    | `eq_unsafe()`    | Unsafe equality               |
| `!=~`    | `ne_unsafe()`    | Unsafe non-equality           |
| `<~`     | `lt_unsafe()`    | Unsafe less than              |
| `<=~`    | `le_unsafe()`    | Unsafe less than or equal     |
| `>=~`    | `ge_unsafe()`    | Unsafe greater than or equal  |
| `+?`     | `add_partial()?` | Partial Addition              |
| `-?`     | `sub_partial()?` | Partial Subtraction           |
| `*?`     | `mul_partial()?` | Partial Multiplication        |
| `/?`     | `div_partial()?` | Partial Division              |
| `%?`     | `rem_partial()?` | Partial Remainder             |
| `%%?`    | `mod_partial()?` | Partial Modulo                | Starting with version `0.26.1` |

---

## Short circuiting

The `and` and `or` operators use __short circuiting__ when used with boolean variables. This means that the first operand is always evaluated, but the second is only evaluated if it can affect the result.

For `and`, if the first operand is __false__ then the second operand is not evaluated since it cannot affect the result.

For `or`, if the first operand is __true__ then the second operand is not evaluated since it cannot affect the result.

This is a special feature built into the compiler, it cannot be used with operator aliasing for any other type.

## Unary operators

The unary operators are handled in the same manner, but with only one operand. For example, the following expressions are equivalent:

```pony
--8<-- "operators-unary-operators.pony"
```

The full list of unary operators that are aliases for functions is:

---

| Operator | Method       | Description                   |
| -------- | ------------ | ----------------------------- |
| `-`        | `neg()`        | Arithmetic negation           |
| `not`      | `op_not()`     | Not, both bitwise and logical |
| `-~`       | `neg_unsafe()` | Unsafe arithmetic negation    |

---

## Precedence

In Pony, unary operators always bind stronger than any infix operators: `not a == b` will be interpreted as `(not a) == b` instead of `not (a == b)`.

When using infix operators in complex expressions a key question is the __precedence__, i.e. which operator is evaluated first. Given this expression:

```pony
--8<-- "operators-precedence-without-parentheses.pony:3:3"
```

We will get a value of 9 if we evaluate the addition first and 7 if we evaluate the multiplication first. In mathematics, there are rules about the order in which to evaluate operators and most programming languages follow this approach.

The problem with this is that the programmer has to remember the order and people aren't very good at things like that. Most people will remember to do multiplication before addition, but what about left bit shifting versus bitwise and? Sometimes people misremember (or guess wrong) and that leads to bugs. Worse, those bugs are often very hard to spot.

Pony takes a different approach and outlaws infix precedence. Any expression where more than one infix operator is used __must__ use parentheses to remove the ambiguity. If you fail to do this the compiler will complain.

This means that the example above is illegal in Pony and should be rewritten as:

```pony
--8<-- "operators-precedence-with-parentheses.pony"
```

Repeated use of a single operator, however, is fine:

```pony
--8<-- "operators-precedence-single-operator.pony"
```

Meanwhile, mixing unary and infix operators do not need additional parentheses as unary operators always bind more closely, so if our example above used a negative three:

```pony
--8<-- "operators-precedence-infix-and-unary-operators-without-parentheses.pony:3:3"
```

We would still need parentheses to remove the ambiguity for our infix operators like we did above, but not for the unary arithmetic negative (`-`):

```pony
--8<-- "operators-precedence-infix-and-unary-operators-with-parentheses.pony"
```

We can see that it makes more sense for the unary operator to be applied before either infix as it only acts on a single number in the expression so it is never ambiguous.

Unary operators can also be applied to parentheses and act on the result of all operations in those parentheses prior to applying any infix operators outside the parentheses:

```pony
--8<-- "operators-precedence-unary-operator-with-parentheses.pony"
```
