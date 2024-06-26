# Divide by Zero

What's 1 divided by 0? How about 10 divided by 0? What is the result you get in your favorite programming language?

In math, divide by zero is undefined. There is no answer to that question as the expression 1/0 has no meaning. In many programming languages, the answer is a runtime exception that the user has to handle. In Pony, things are a bit different.

## Divide by zero in Pony

In Pony, *integer division by zero results in zero*. That's right,

```pony
--8<-- "divide-by-zero.pony:3:3"
```

results in `0` being assigned to `x`. Baffling right? Well, yes and no. From a mathematical standpoint, it is very much baffling. From a practical standpoint, it is very much not.

While Pony has [Partial division](/expressions/arithmetic.md#partial-and-checked-arithmetic):

```pony
--8<-- "divide-by-zero-partial.pony"
```

Defining division as partial leads to code littered with `try`s attempting to deal with the possibility of division by zero. Even if you had asserted that your denominator was not zero, you'd still need to protect against divide by zero because, at this time, the compiler can't detect that value dependent typing.

Pony also offers [Unsafe Division](/expressions/arithmetic.md#unsafe-integer-arithmetic), which declares division by zero as undefined, as in C:

```pony
--8<-- "divide-by-zero-unsafe.pony"
```

But declaring this case as undefined does not help us out here. As a programmer you'd still need to guard that case in order to not poison your program with undefined values or risking terminating your program with a `SIGFPE`. So, in order to maintain a practical API and avoid undefined behaviour, _normal_ division on integers in Pony is defined to be `0`. To avoid `0`s silently creeping through your divisions, use [Partial or Checked Division](/expressions/arithmetic.md#partial-and-checked-arithmetic).

### Divide by zero on floating points

In conformance with IEEE 754, *floating point division by zero results in `inf` or `-inf`*, depending on the sign of the numerator.

If you can assert that your denominator cannot be `0`, it is possible to use [Unsafe Division](/expressions/arithmetic.md#floating-point) to gain some performance:

```pony
--8<-- "divide-by-zero-floats.pony:4:4"
```
