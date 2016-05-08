# Partial Application

Partial application lets us supply _some_ of the arguments to a constructor, function, or behaviour, and get back something that lets us supply the rest of the arguments later.

## A simple case

A simple case is to create a "callback" function. For example:

```pony
class Foo
  var _f: F64 = 0

  fun ref addmul(add: F64, mul: F64): F64 =>
    _f = (_f + add) * mul

class Bar
  fun apply() =>
    let foo: Foo = Foo
    let f = foo~addmul(3)
    f(4)
```

This is a bit of a silly example, but hopefully the idea is clear. We partially apply the `addmul` function on `foo`, binding the receiver to `foo` and the `add` argument to `3`. We get back an object, `f`, that has an `apply` method that takes a `mul` argument. When it's called, it in turn calls `foo.addmul(3, mul)`.

We can also bind all the arguments:

```pony
let f = foo~addmul(3, 4)
f()
```

Or even none of the arguments:

```pony
let f = foo~addmul()
f(3, 4)
```

## Out of order arguments

Partial application with named arguments allows binding arguments in any order, not just left to right. For example:

```pony
let f = foo~addmul(where mul = 4)
f(3)
```

Here, we bound the `mul` argument, but left `add` unbound.

## Partially applying a partial application

Since partial application results in an object with an apply method, we can partially apply the result!

```pony
let f = foo~addmul()
let f2 = f~apply(where mul = 4)
f2(3)
```

## Partial application is an object literal

Under the hood, we're assembling an object literal for partial application. It captures some of the lexical scope as fields, and has an `apply` method that takes some, possibly reduced, number of arguments. This is actually done as sugar, by rewriting the abstract syntax tree for partial application to be an object literal, before code generation.

That means partial application results in an anonymous class, and returns a `ref`. If you need another reference capability, you can wrap partial application in a `recover` expression.
