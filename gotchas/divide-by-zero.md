# Divide by Zero

What's 1 divided by 0? How about 10 divided by 0? What is the result you get in your favorite programming language?

In math, divide by zero is undefined. There is no answer to that question as the expression 1/0 has no meaning. In many programming languages, the answer is a runtime exception that the user has to handle. In Pony, things are a bit different.

## Divide by zero in Pony

In Pony, *integer division by zero results in zero*. That's right,

```pony
let x = I64(1) / I64(0)
```

results in `0` being assigned to `x`. Baffling right? Well, yes and no. From a mathematical standpoint, it is very much baffling. From a practical standpoint, it is very much not.

Similarly, *floating point division by zero results in `inf` or `-inf`*, depending on the sign of the numerator.

## Partial functions and math in Pony

As you might remember from the [exceptions portion of this tutorial](/expressions/exceptions.html), Pony handles extraordinary circumstances via the `error` keyword and partial functions. In an ideal world, you might imagine that a Pony divide method for `U64` might look like:

```pony
fun divide(n: U64, d: U64) ? =>
  if d == 0 then error end

  n / d
```

We indicate that our function is partial via the `?` because we can't compute a result for all inputs. In this case, having 0 as a denominator. In fact, originally, this is how division worked in Pony. And then practicality intervened.

## Death by a thousand `try`s

From a practical perspective, having division as a partial function is awful. You end up with code littered with `try`s attempting to deal with the possibility of division by zero. Even if you had asserted that your denominator was not zero, you'd still need to protect against divide by zero because, at this time, the compiler can't detect that value dependent typing. So, as of right now (ponyc v0.2), divide by zero in Pony does not result in `error` but rather `0`.
