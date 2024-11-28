# Match Expressions

If we want to compare an expression to a value then we use an `if`. But if we want to compare an expression to a lot of values this gets very tedious. Pony provides a powerful pattern matching facility, combining matching on values and types, without any special code required.

## Matching: the basics

Here's a simple example of a match expression that produces a string.

```pony
--8<-- "match-expression.pony"
```

If you're used to functional languages this should be very familiar.

For those readers more familiar with the C and Java family of languages, think of this like a switch statement. But you can switch on values other than just integers, like Strings. In fact, you can switch on any type that provides a comparison function, including your own classes. And you can also switch on the runtime type of an expression.

A match starts with the keyword `match`, followed by the expression to match, which is known as the match __operand__. In this example, the operand is just the variable `x`, but it can be any expression.

Most of the match expression consists of a series of __cases__ that we match against. Each case consists of a pipe symbol ('|'), the __pattern__ to match against, an arrow ('=>') and the expression to evaluate if the case matches.

We go through the cases one by one until we find one that matches. (Actually, in practice the compiler is a lot more intelligent than that and uses a combination of sequential checks and jump tables to be as efficient as possible.)

Note that each match case has an expression to evaluate and these are all independent. There is no "fall through" between cases as there is in languages such as C.

If the value produced by the match expression isn't used then the cases can omit the arrow and expression to evaluate. This can be useful for excluding specific cases before a more general case.

### Else cases

As with all Pony control structures, the else case for a match expression is used if we have no other value, i.e. if none of our cases match. The else case, if there is one, __must__ come at the end of the match, after all of the specific cases.

If the value the match expression results in is used then you need to have an else case, except in cases where the compiler recognizes that the match is exhaustive and that the else case can never actually be reached. If you omit it a default will be added which evaluates to `None`.

The compiler recognizes a match as exhaustive when the union of the types for all patterns that match on type alone is a supertype of the matched expression type. In other words, when your cases cover all possible types for the matched expression, the compiler will not add an implicit `else None` to your match statement.

## Matching on values

The simplest match expression just matches on value.

```pony
--8<-- "match-values.pony:6:14"
```

For value matching the pattern is simply the value we want to match to, just like a C switch statement. The case with the same value as the operand wins and we use its expression.

The compiler calls the `eq()` function on the operand, passing the pattern as the argument. This means that you can use your own types as match operands and patterns, as long as you define an `eq()` function.

```pony
--8<-- "match-custom-eq-operand.pony"
```

## Matching on type and value

Matching on value is fine if the match operand and case patterns have all the same type. However, match can cope with multiple different types. Each case pattern is first checked to see if it is the same type as the runtime type of the operand. Only then will the values be compared.

```pony
--8<-- "match-type-and-value.pony:6:14"
```

In many languages using runtime type information is very expensive and so it is generally avoided whenever possible.

In Pony it's cheap. Really cheap. Pony's "whole program" approach to compilation means the compiler can work out as much as possible at compile time. The runtime cost of each type check is generally a single pointer comparison. Plus of course, any checks which can be fully determined at compile time are. So for upcasts there's no runtime cost at all.

__When are case patterns for value matching evaluated?__ Each case pattern expression that matches the type of the match operand, needs to be evaluated __each time__ the `match` expression is evaluated until one case matches (further case patterns are ignored). This can lead to creating lots of objects unintentionally for the sole purpose of checking for equality. If case patterns actually only need to differentiate by type, [Captures](#captures) should be used instead, these boil down to simple type checks at runtime.

At first sight it is easy to confuse a value matching pattern for a type check. Consider the following example:

```pony
--8<-- "match-value-pattern-matching-vs-type-check.pony"
```

Both case patterns actually __do not__ check for the match operand `x` being an instance of `Foo` or `None`, but check for equality with the instance created by evaluating the case pattern (each time). `None` is a primitive and thus there is only one instance at all, in which case this value pattern kind of does the expected thing, but not quite. If `None` had a custom `eq` function that would not use [identity equality](/expressions/equality.md#identity-equality), this could lead to surprising results.

Remember to always use [Captures](#captures) if all you need is to differentiate by type. Only use value matching if you need a full blown equality check, be it for [structural equality](/expressions/equality.md#structural-equality) or [identity equality](/expressions/equality.md#identity-equality).

## Captures

Sometimes you want to be able to match the type, for any value of that type. For this, you use a __capture__. This defines a local variable, valid only within the case, containing the value of the operand. If the operand is not of the specified type then the case doesn't match.

Captures look just like variable declarations within the pattern. Like normal variables, they can be declared as var or let. If you're not going to reassign them within the case expression it is good practice to use let.

```pony
--8<-- "match-captures.pony:6:13"
```

__Can I omit the type from a capture, like I can from a local variable?__ Unfortunately no. Since we match on type and value the compiler has to know what type the pattern is, so it can't be inferred.

## Implicit matching on capabilities in the context of union types

In union types, when we pattern match on individual classes or traits, we also implicitly pattern match on the corresponding capabilities. In the example provided below, if `_x` has static type `(A iso | B ref | None)` and dynamically matches `A`, then we also know that it must be an `A iso`.

```pony
--8<-- "match-capabilities.pony"
```

Note that using a match expression to differentiate solely based on capabilities at runtime is not possible, that is:

```pony
--8<-- "match-capabilities-only.pony"
```

does not type check.

## Matching tuples

If you want to match on more than one operand at once then you can simply use a tuple. Cases will only match if __all__ the tuple elements match.

```pony
--8<-- "match-tuples.pony:5:13"
```

__Do I have to specify all the elements in a tuple?__ No, you don't. Any tuple elements in a pattern can be marked as "don't care" by using an underscore ('_'). The first and fourth cases in our example don't actually care about the U32 element, so we can ignore it.

```pony
--8<-- "match-tuples-ignore-elements.pony:5:13"
```

## Guards

In addition to matching on types and values, each case in a match can also have a guard condition. This is simply an expression, evaluated __after__ type and value matching has occurred, that must give the value true for the case to match. If the guard is false then the case doesn't match and we move onto the next in the usual way.

Guards are introduced with the `if` keyword.

A guard expression may use any captured variables from that case, which allows for handling ranges and complex functions.

```pony
--8<-- "match-guards.pony:6:15"
```
