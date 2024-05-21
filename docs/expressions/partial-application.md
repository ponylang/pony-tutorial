# Partial Application

Partial application lets us supply _some_ of the arguments to a constructor, function, or behaviour, and get back something that lets us supply the rest of the arguments later.

## A simple case

A simple case is to create a "callback" function. For example:

```pony
--8<-- "partial-application-callback-function-with-some-arguments-bound.pony"
```

This is a bit of a silly example, but hopefully, the idea is clear. We partially apply the `addmul` function on `foo`, binding the receiver to `foo` and the `add` argument to `3`. We get back an object, `f`, that has an `apply` method that takes a `mul` argument. When it's called, it in turn calls `foo.addmul(3, mul)`.

We can also bind all the arguments:

```pony
--8<-- "partial-application-callback-function-with-all-arguments-bound.pony"
```

Or even none of the arguments:

```pony
--8<-- "partial-application-callback-function-with-no-arguments-bound.pony"
```

## Out of order arguments

Partial application with named arguments allows binding arguments in any order, not just left to right. For example:

```pony
--8<-- "partial-application-callback-function-with-out-of-order-arguments.pony"
```

Here, we bound the `mul` argument but left `add` unbound.

## Partial application is just a lambda

Under the hood, we're assembling an object literal for partial application, just as if you had written a lambda yourself. It captures aliases of some of the lexical scope as fields and has an `apply` function that takes some, possibly reduced, number of arguments. This is actually done as sugar, by rewriting the abstract syntax tree for partial application to be an object literal, before code generation.

That means partial application results in an anonymous class and returns a `ref`. If you need another reference capability, you can wrap partial application in a `recover` expression. It also means that we can't consume unique fields for a lambda, as the apply method might be called many times.

## Partially applying a partial application

Since partial application results in an object with an apply method, we can partially apply the result!

```pony
--8<-- "partial-application-partially-applying-a-partial-application.pony"
```
