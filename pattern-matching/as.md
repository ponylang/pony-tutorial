# As Operator

The `as` operator in Pony has two related uses. First, it provides a safe way to increase the specificity of an object's type (casting). Second, it gives the programmer a way to specify the type of the items in an array literal.

## Safely converting to a more specific type (casting)

The `as` operator can be used to create a reference to an object with a more specific type than the given reference, if possible. This can be applied to types that are related through inheritance, as well as unions and intersections. This is done at runtime, and if it fails then an error is raised.

Let's look at an example. The `json` package provides a type called `JsonDoc` that can attempt to parse strings as fragments of JSON. The parsed value is stored in the `data` field of the object, and that field's type is the union `(F64 | I64 | Bool | None | String | JsonArray | JsonObject)`. So if there is a `JsonDoc` object referenced by `jsonDoc` then `jsonDoc.parse("42")` will store an `I64` equal to `42` in `jsonDoc.data`. If the programmer want to treat `jsonDoc.data` as an `I64` then they can get an `I64` reference to the data by using `jsonDoc.data as I64`.

In the following program, the commandline arguments are parsed as Json. A running sum is kept of all of the arguments that can be parsed as `I64` numbers, and all other arguments are ignored.

```
use "json"

actor Main
  new create(env: Env) =>
    var jsonSum: I64 = 0
    let jd: JsonDoc = JsonDoc
    for arg in env.args.slice(1).values() do
      try
        jd.parse(arg)
        jsonSum = jsonSum + (jd.data as I64)
      end
    end
    env.out.print(jsonSum.string())
```

When run with the arguments `2 and 4 et 7 y 15`, the program's output is `28`.

The same thing can be done with interfaces, using `as` to create a reference to a more specific interface or class. Let's say, for example, that you have a library for doing things with rodents. It provides a `Rodent` interface which programmers can then use to create specific types of rodents.

```pony
interface Rodent
  fun wash(): String
```

The programmer uses this library to create a `Wombat` and a `Capybara` class. But the `Capybara` class provides a new method, `swim()`, that is not part of the `Rodent` class. The programmer wants to store all of the rodents in an array, in order to carry out actions on groups of rodents. Now assume that when capybaras finish washing they want to go for a swim. The programmer can accomplish that by using `as` to attempt to use each `Rodent` object in the `Array[Rodent` as a `Capybara`. If this fails because the `Rodent` is not a `Capybara`, then an error is raised; the program can swallow this error and go on to the next item.

```pony
class Wombat is Rodent
  fun wash(): String => "I'm a clean wombat!"

class Capybara is Rodent
  fun wash(): String => "I feel squeaky clean!"
  fun swim(): String => "I'm swimming like a fish!"

actor Main
  new create(env: Env) =>
    let rodents = Array[Rodent].push(Wombat).push(Capybara)
    for rodent in rodents.values() do
      env.out.print(rodent.wash())
      try
        env.out.print((rodent as Capybara).swim())
      end
    end
```

## Specify the type of items in an array literal

The `as` operator can be used to tell the compiler what type to use for the items in an array literal. In many cases the compiler can infer the type, but sometimes it is ambiguous.

For example, in the case of the following program, the method `foo` can take either an `Array[U32] ref` or an `Array[U64] ref` as an argument. If a literal array is passed as an argument to the method and no type is specified then the compiler cannot deduce the correct one because there are two equally valid ones.

```
actor Main
  actor Main
  fun foo(xs: (Array[U32] ref | Array[U64] ref)): Bool =>
    // do something boring here

  new create(env: Env) =>
    foo([as U32: 1, 2, 3])
    // the compiler would complain about this:
    //   foo([1, 2, 3])
```

The requested type must be a valid type for the items in the array. Since these types are checked at compile time they are guaranteed to work, so there is no need for the programmer to handle an error condition.
