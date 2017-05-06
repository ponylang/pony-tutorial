# Equality in Pony

Pony features two forms of equality: by structure and by identity.  

## Identity equality

Identity equality checks in Pony are done via the `is` keyword. `is` verifies that the two items are the same.

```pony
if None is None then
  // TRUE!
  // There is only 1 None so the identity is the same
end

let a = Foo("hi")
let b = Foo("hi")

if a is b then
  // NOPE. THIS IS FALSE
end

let c = a
if a is c then
  // YUP! TRUE!
end
```

## Structural equality

Equality by structure check in Pony is done via `==`. It verifies that two items have the same value. If the identity of the items being compared is the same then, by definition they have the same value. You can define how equality is defined on your object by implementing `fun eq(that: box->A): Bool`

```pony
class Foo
  let _a: String

  new create(a: String) =>
    _a = a

  fun eq(that: box->Foo): Bool =>
    this._a == that._a

actor Main
  new create(e: Env) =>
    let a = Foo("hi")
    let b = Foo("bye")
    let c = Foo("hi")

    if a == b then
      // won't print
      e.out.print("1")
    end

    if a == c then
      // will print
      e.out.print("2")
    end

    if a is c then
      // won't print
      e.out.print("3")
    end
```

If you don't define your own `eq`, you will inherit the default implementation that defines equal by value as being the same as by identity.

```pony
interface Equatable[A: Equatable[A] #read]
  fun eq(that: box->A): Bool => this is that
  fun ne(that: box->A): Bool => not eq(that)
```

## Primitives and equality

As you might remember from [Chapter 2](http://tutorial.ponylang.org/types/primitives.html), primitives are the same as classes except for two important differences:

* A primitive has no fields.
* There is only one instance of a user-defined primitive.

This means, that every primitive of a given type, is always structurally equal and equal based on identity. So, for example, None is always None.

```pony
if None is None then
  // this is always true
end

if None == None then
  // this is also always true
end
```
