# Iftype Specialization

You sometimes want different behaviour from a generic type depending on what its type parameter turns out to be. With an [`iftype` expression](/expressions/control-structures.md#iftype), you can branch inside a method body. With iftype specialization, you can provide an entirely separate method body that the compiler selects at compile time. There is no runtime dispatch — the compiler picks the matching body and return type and discards the rest.

## A first example

```pony
--8<-- "iftype-specialization-basic.pony:1:13"
```

`Container` has two definitions of `describe`. The first has no guard — it is the __default__. The second has an `iftype` guard that matches when `A` is a subtype of `Stringable val`. When you create a `Container[U32]`, `U32 <: Stringable val` holds and the compiler selects the specialization. When you create a `Container[Opaque]`, the guard does not match, and the default is used.

```pony
--8<-- "iftype-specialization-basic.pony:15:21"
```

Every method group — the set of definitions sharing the same method name — must have exactly one unguarded definition, the default. Without it, there would be no body to use when no guard matches.

## Type narrowing

Inside a specialization, the guard is guaranteed to hold. You can call methods on values of that type that only exist on the constraining type:

```pony
--8<-- "iftype-specialization-narrowing.pony:1:11"
```

In the specialization, `A` is known to be a subtype of `Stringable val`, so calling `_data.string()` is valid even though the class constraint `Any val` does not provide `string()`.

## Multiple specializations

A method can have more than one specialization. The compiler checks the guards in declaration order and picks the first one that matches:

```pony
--8<-- "iftype-specialization-first-match.pony:8:22"
```

`Tagged` satisfies both `Stringable` and `Printable`. Because the `Stringable` guard appears first, `Container[Tagged]` uses that specialization. Order matters — put the more specific guard first.

__What happens if a later guard is always subsumed by an earlier one?__ The compiler rejects it. If two guards on the same type parameter are ordered so that anything matching the second must already match the first, the second is unreachable and the compiler reports an error.

## Method-level type parameters

The enclosing type does not have to be generic. A non-generic class with a generic method can use specialization on the method's own type parameters:

```pony
--8<-- "iftype-specialization-method-typeparam.pony:1:8"
```

`Formatter` itself has no type parameters. The method `format` introduces its own type parameter `A`, and the guard constrains that parameter. When you call `f.format[U32](42)`, the compiler selects the specialization because `U32 <: Stringable val` holds.

## Compound guards

### Conjunction

Use `and` to require multiple constraints at once:

```pony
--8<-- "iftype-specialization-conjunction.pony:3:18"
```

The specialization matches only when both `A` and `B` are subtypes of `Stringable val`. If either one is not, the default is used. Unlike `or` guards, an `and` guard can constrain different type parameters.

### Disjunction

Use `or` when any one of several constraints is enough:

```pony
--8<-- "iftype-specialization-disjunction.pony:9:22"
```

The specialization is selected when `A` is a subtype of `Stringable val` or a subtype of `Displayable val`. Every clause in an `or` guard must name the same type parameter on the left side of `<:` — you cannot write `A <: X or B <: Y`.

__Can I mix `and` and `or` in a single guard?__ No. A guard is either all `and` or all `or`. If you need a more complex condition, use multiple specializations.

## Constructors and behaviours

Specialization works for all three method kinds: functions, constructors, and behaviours. Here is a constructor example:

```pony
--8<-- "iftype-specialization-constructor.pony:1:14"
```

The same rules apply. Each constructor specialization must initialize every field, just as any constructor must. Behaviour specializations follow the same pattern — add an `iftype` guard after the return type on a `be` declaration.

## Partial methods

A specialization can be partial only when the default is partial. The `?` goes after the `iftype` guard:

```pony
--8<-- "iftype-specialization-partial.pony:1:12"
```

The caller compiles against the default's signature. A non-partial default promises the caller that no call can error, so a partial specialization would break that promise.

## Traits and interfaces

Traits can declare a method group — a default definition and one or more specializations — and concrete types inherit the entire group.

### Inheriting a method group

```pony
--8<-- "iftype-specialization-trait.pony"
```

`Container` provides `Describable[A]` and defines no `describe` of its own, so it inherits both the default and the specialization from the trait. When `A` is `U32`, the compiler selects the specialization.

### Trait chains

A class that provides a trait through an intermediate trait inherits the full method group:

```pony
--8<-- "iftype-specialization-trait-chain.pony:1:8"
```

`Impl` inherits the method group from `Base` through `Middle`, even though `Middle` adds nothing of its own.

### Overriding a method group

A concrete type can provide its own definitions, replacing the trait's:

```pony
--8<-- "iftype-specialization-trait-override.pony"
```

`Container` overrides both the default and the specialization. You can override any combination — just the default, just a specialization, or the entire group. Any definition you do not override is inherited from the trait unchanged.

### Interfaces

Interfaces can declare method groups too. An interface specialization has no body — it declares the signature that a conforming type must provide:

```pony
--8<-- "iftype-specialization-interface.pony"
```

A concrete type that provides `Describable` must have both a default `describe` and a matching specialization. Since interfaces use structural subtyping, the compiler checks that any type with the right shape matches the requirement, whether or not it names `Describable` in its `is` clause.

## Rules

Specializations are subject to several constraints:

- The left side of `<:` in a guard must be a type parameter (or a tuple of type parameters). You cannot use concrete types.
- The default and all specializations must have the same parameter types, the same receiver capability, the same method kind (`fun`, `be`, or `new`), and the same method-level type parameters.
- The return type of a specialization must be a subtype of the default's return type. When the type arguments are concrete and a guard matches, the caller sees the specialization's return type.
- A specialization can be partial (`?`) only if the default is also partial.
- If a later guard's constraint is subsumed by an earlier guard on the same type parameter, the later guard is unreachable and the compiler rejects it.

## Iftype specialization vs. iftype expressions

Pony uses `iftype` in two different places. An [iftype expression](/expressions/control-structures.md#iftype) is a control structure inside a method body — it branches on a type parameter at compile time, much like `if` branches on a value at runtime. Iftype specialization puts the guard on the method declaration itself, giving you a separate method body and return type for each case.

The two can be used together. A specialization provides a separate body; an `iftype` expression within that body can branch further. When each branch needs a completely different implementation, specialization keeps the bodies separate and applies type narrowing to the whole body rather than just one branch of an expression.
