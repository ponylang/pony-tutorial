# As Operator

The `as` operator in Pony has two related uses. First, it provides a safe way to increase the specificity of an object's type (casting). Second, it gives the programmer a way to specify the type of the items in an array literal.

## Safely converting to a more specific type (casting)

The `as` operator can be used to create a reference to an object with a more specific type than the given reference, if possible. This can be applied to types that are related through inheritance, as well as unions and intersections. This is done at runtime, and if it fails then an error is raised.

Let's look at an example. The `json` package provides a type called `JsonDoc` that can attempt to parse strings as fragments of JSON. The parsed value is stored in the `data` field of the object, and that field's type is the union `(F64 | I64 | Bool | None | String | JsonArray | JsonObject)`. So if there is a `JsonDoc` object referenced by `jsonDoc` then `jsonDoc.parse("42")` will store an `I64` equal to `42` in `jsonDoc.data`. If the programmer wants to treat `jsonDoc.data` as an `I64` then they can get an `I64` reference to the data by using `jsonDoc.data as I64`.

In the following program, the command line arguments are parsed as Json. A running sum is kept of all of the arguments that can be parsed as `I64` numbers, and all other arguments are ignored.

```pony
use "json"

actor Main
  new create(env: Env) =>
    var jsonSum: I64 = 0
    let jd: JsonDoc = JsonDoc
    for arg in env.args.slice(1).values() do
      try
        jd.parse(arg)?
        jsonSum = jsonSum + (jd.data as I64)
      end
    end
    env.out.print(jsonSum.string())
```

When run with the arguments `2 and 4 et 7 y 15`, the program's output is `28`.

The same thing can be done with interfaces, using `as` to create a reference to a more specific interface or class. Let's say, for example, that you have a library for doing things with furry, rodent-like creatures. It provides a `Critter` interface which programmers can then use to create specific types of critters.

```pony
interface Critter
  fun wash(): String
```

The programmer uses this library to create a `Wombat` and a `Capybara` class. But the `Capybara` class provides a new method, `swim()`, that is not part of the `Critter` class. The programmer wants to store all of the critters in an array, in order to carry out actions on groups of critters. Now assume that when capybaras finish washing they want to go for a swim. The programmer can accomplish that by using `as` to attempt to use each `Critter` object in the `Array[Critter]` as a `Capybara`. If this fails because the `Critter` is not a `Capybara`, then an error is raised; the program can swallow this error and go on to the next item.

```pony
interface Critter
  fun wash(): String

class Wombat is Critter
  fun wash(): String => "I'm a clean wombat!"

class Capybara is Critter
  fun wash(): String => "I feel squeaky clean!"
  fun swim(): String => "I'm swimming like a fish!"

actor Main
  new create(env: Env) =>
    let critters = Array[Critter].>push(Wombat).>push(Capybara)
    for critter in critters.values() do
      env.out.print(critter.wash())
      try
        env.out.print((critter as Capybara).swim())
      end
    end
```

## Specify the type of items in an array literal

The `as` operator can be used to tell the compiler what type to use for the items in an array literal. In many cases, the compiler can infer the type, but sometimes it is ambiguous.

For example, in the case of the following program, the method `foo` can take either an `Array[U32] ref` or an `Array[U64] ref` as an argument. If a literal array is passed as an argument to the method and no type is specified then the compiler cannot deduce the correct one because there are two equally valid ones.

```pony
actor Main
  fun foo(xs: (Array[U32] ref | Array[U64] ref)): Bool =>
    // do something boring here
    true

  new create(env: Env) =>
    foo([as U32: 1; 2; 3])
    // the compiler would complain about this:
    //   foo([1; 2; 3])
```

The requested type must be a valid type for the items in the array. Since these types are checked at compile time they are guaranteed to work, so there is no need for the programmer to handle an error condition.
