# As Operator

The `as` operator in Pony has two related uses. First, it provides a safe way to increase the specificity of an object's type. Second, it gives the programmer a way to specify the type of the items in an array literal.

## Expressing a different type of an object

In Pony, each object is an instance of a single concrete type, which is the most specific type for that object. But the object can also be held as part of a "wider" abstract type such as an interface, trait, or type union which the concrete type is said to be a subtype of.

`as` (like `match`) allows a program to check the runtime type of a abstract-typed value to see whether or not the object matches a given type which is more specific. If it doesn't match the more specific type, then a runtime `error` is raised. For example:

```pony
  class Cat
    fun pet() =>
      ...

  type Animal is (Cat | Fish | Snake)

  fun pet(animal: Animal) =>
    try
      // raises error if not a Cat
      let cat: Cat = animal as Cat
      cat.pet()
    end
```

In the above example, within `pet` our current view of `animal` is via the type union `Animal`. To treat `animal` as a cat, we need to do a runtime check that the concrete type of the object instance is `Cat`. If it is, then we can pet it. This example is a little contrived, by hopefully elucidates how `as` can be used to take a type that is a union and get a specific concrete type from it.

Note that the type requested as the `as` argument must exist as a type of the object instance, unlike C casting where one type can be forced into become another type. Coercion from one concrete type to another is not possible using `as`, so one can not do `let value:F64 = F32(1.0) as F64`. `F32` and `F64` are both concrete types and each object can only have a single concrete type. Many concrete types do provide methods that allow you do convert them to another concrete type, for example, `F32(1.0).f64()` to convert an `F32` to an `F64` or `F32(1.0).string()` to convert to a string.

In addition to using to using `as` with a union of disjoint types, we can also express an intersected type of the object, meaning the object has a type that the alias we have for the object is not directly related to the type we want to express. Example;

```pony
  trait Alive

  trait Well

  class Person is (Alive & Well)

  class LifeSigns
    fun isAllGood(alive: Alive)? =>
      // if the instance 'alive' is also of type 'Well' (such as a Person instance). raises error if not possible
      let well: Well = alive as Well
```

`as` can also be used to get a more specific type of an object from an alias to it that is an interface or a trait. Let's say, for example, that you have a library for doing things with furry, rodent-like creatures. It provides a `Critter` interface which programmers can then use to create specific types of critters.

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

You can do the same with interfaces as well. In the example below, we have an Array of `Any` which is an interface where we want to try wash any entries that conform to the `Critter` interface.

```pony
actor Main
  new create(env: Env) =>
    let anys = Array[Any ref].>push(Wombat).>push(Capybara)
    for any in anys.values() do
      try
        env.out.print((any as Critter).wash())
      end
    end
```

Note, All the `as` examples above could be written using a `match` statement where a failure to match results in `error`. For example, our last example written to use `match` would be:

```pony
actor Main
  new create(env: Env) =>
    let anys = Array[Any ref].>push(Wombat).>push(Capybara)
    for any in anys.values() do
      try
        match any
        | let critter: Critter =>
          env.out.print(critter.wash())
        else
          error
        end
      end
    end
```

Thinking of the `as` keyword as "an attempt to match that will error if not matched" is a good mental model to have. If you don't care about handling the "not matched" case that causes an error when using `as`, you can rewrite an `as` to use match without an error like:

```pony
actor Main
  new create(env: Env) =>
    let anys = Array[Any ref].>push(Wombat).>push(Capybara)
    for any in anys.values() do
      match any
      | let critter: Critter =>
        env.out.print(critter.wash())
      end
    end
```

You can learn more about matching on type in the [captures section of the match documentation](/pattern-matching/match.md#captures).

## Specify the type of items in an array literal

The `as` operator can also be used to tell the compiler what type to use for the items in an array literal. In many cases, the compiler can infer the type, but sometimes it is ambiguous.

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
