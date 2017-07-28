# Case Functions

Case functions give the programmer a way to create different versions of a function; the case that is called is based on the arguments given when the function is called. As with `match` statements, the function can be selected by the value or the type of the arguments, and guard statements can be used for additional control. Different cases of a function have the same name and parameter list with the same number of arguments (though not necessarily the same parameter types or return types).

A classic example of this type of function is the a recursive function with a base case. For example, the factorial of `n` can be found using the following function:

```
       / f(0) => 1
f(n) = |
       \ f(n) => n * f(n - 1)
```

This could be implemented in Pony with an `if` statement to check whether to return 1 or make the recursive call, but it can also be implemented with a set of case functions. The `fac_case` function uses parameter matching to dispatch based on whether or not the argument is `0`, while the `fac_guard` function uses a guard statement to test the incoming argument. In both functions, there is a default case in which there are no match parameters nor guard statements.

```pony
primitive Factorial
  fun fac_conditional(n: U64): U64 =>
    if n == 0 then
      1
    else
      n * fac_conditional(n - 1)
    end

  // dispatch based on argument match
  fun fac_case(0): U64 => 1
  fun fac_case(n: U64): U64 ? => n * (fac_case(n - 1)? as U64)

  // dispatch based on guard function
  fun fac_guard(n: U64): U64 if n == 0 => 1
  fun fac_guard(n: U64): U64 ? => n * (fac_guard(n - 1)? as U64)

actor Main
  new create(env: Env) =>
    let n: U64 = try
      env.args(1)?.read_int[U64]()?._1
    else
      13
    end

    try
      env.out.print(n.string().add("! = ")
                              .add(Factorial.fac_conditional(n).string()))
      env.out.print(n.string().add("! = ")
                              .add((Factorial.fac_case(n)? as U64).string()))
      env.out.print(n.string().add("! = ")
                              .add((Factorial.fac_guard(n)? as U64).string()))
    end
```

Note that in the example above the return values of `fac_case(n)` and `fac_guard(n)` must explicitly be cast as `U64`. This is because the compiler does not check to make sure that all cases can be matched and instead creates an implicit base case that returns None if no match occurs. Therefore, if `T` is the union of all of the explicit return types for a case function, then the implied type of the function is actually `(T | None)`.

The parameter types for different cases do not have to match, but each case of the same function must have the same number of parameters, and the parameters must have the same names in each case of the function. Also, different cases of the same function can have different return types; as mentioned above, the return types are combined as a union (along with None) to create the final type for the function. The type and name of each parameter must be specified somewhere in the combination of case functions, though not necessarily all in the same case (see the `x`, `f`, and `b` parameters in the `_fizz_buzz` method below).

In the following implementation of [FizzBuzz](http://c2.com/cgi/wiki?FizzBuzzTest) `fizz_buzz` is a case function that takes either a `U64` or a `Range[U64]`, and consequently returns either a `String` or an `Array[String]`, while the helper function `_fizz_buzz` is a case function that determines what to return by matching the arguments that are passed to it:

```pony
use "collections"

class FizzBuzz
  // case functions for FizzBuzz
  fun _fizz_buzz(_, 0, 0): String => "FizzBuzz"
  fun _fizz_buzz(_, 0, b: U64): String => "Fizz"
  fun _fizz_buzz(_, f: U64, 0): String => "Buzz"
  fun _fizz_buzz(x: U64, _, _): String => x.string()

  // parameters are different, return types are different
  fun fizz_buzz(x: U64): String ? =>
    _fizz_buzz(x, x % 3, x % 5) as String
  fun fizz_buzz(x: Range[U64]): Array[String] ? =>
    let acc = Array[String]
    for z in x do
      acc.push(fizz_buzz(z)? as String)
    end

actor Main
  new create(env: Env) =>
    try
      for x in Range[U64](1, 101) do
        env.out.print(FizzBuzz.fizz_buzz(x)? as String)
      end
      let lines = FizzBuzz.fizz_buzz(Range[U64](1, 101))? as Array[String]
      env.out.print("\n".join(lines))
    end
```

It is important to note that case functions resolve overlapping cases by using the first function that matches. For example, the prints `foo bar` because the case of `foo` matching the type `Foo` is declared before the one that matches `Bar`, and the case of `bar` matching the type `Bar` is declared before the one that matches `Foo`:

```pony
interface Foo

class Bar is Foo
  new ref create() =>
    None

actor Main
  fun foo(x: Foo): String => "foo"
  fun foo(x: Bar): String => "bar"

  fun bar(x: Bar): String => "bar"
  fun bar(x: Foo): String => "foo"

  new create(env: Env) =>
    let x = Bar
    try
      env.out.print((foo(x) as String) + " " + (bar(x) as String))
    end
```

Case functions can improve readability by making it clear that certain argument will cause certain code paths to execute. They are currently implemented as sugar that translates to a `match` statement, so there is no more overhead than if the programmer had written the `match` themselves.

__Does Pony support overloaded functions?__ There is no strict definition of "overloaded function" so it is difficult to give a definitive answer to this question. Case functions provide a way to supply several functions of the same name with behavior that varies based on the types and values of their arguments; for some people, these look like overloaded functions. However, it is important to understand the differences between case functions and some of the traditional expectations of overloaded functions.
* The current implementation of case functions does not do an exhaustive match to determine the return type of the synthesized function, so the return type is always a union that includes `None` as one of the types.
* Case functions do not provide a way to specify functions with the same name but different argument counts.
* Overlapping matches are handled in the order in which the functions were declared.
Depending on your needs, case functions may or may not offer an acceptable alternative to overloaded functions.
