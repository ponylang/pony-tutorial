# Equality in Pony

Pony features two forms of equality: by structure and by identity.

## Identity equality

Identity equality checks in Pony are done via the `is` keyword. `is` verifies that the two items are the same.

```pony
--8<-- "equality-identity-equality.pony"
```

## Structural equality

Structural equality checking in Pony is done via the infix operator `==`. It verifies that two items have the same value. If the identity of the items being compared is the same, then by definition they have the same value.

You can define how structural equality is checked on your object by implementing `fun eq(that: box->Foo): Bool`. Remember, since `==` is an infix operator, `eq` must be defined on the left operand, and the right operand must be of type `Foo`.

```pony
--8<-- "equality-structural-equality.pony"
```

If you don't define your own `eq`, you will inherit the default implementation that defines equal by value as being the same as by identity.

```pony
--8<-- "equality-equatable-default-implementation.pony"
```

## Primitives and equality

As you might remember from [Chapter 2](/types/primitives.md), primitives are the same as classes except for two important differences:

* A primitive has no fields.
* There is only one instance of a user-defined primitive.

This means, that every primitive of a given type, is always structurally equal and equal based on identity. So, for example, None is always None.

```pony
--8<-- "equality-primitives.pony"
```
