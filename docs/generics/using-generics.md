# Using Generics

## Generic Classes

A generic class is a class that can have parameters, much like a method has parameters. The parameters for a generic class are types, including their reference capability.
Parameters are introduced to a class using square brackets.

Take the following example of a non-generic class:

```pony
--8<-- "generics-foo-non-generic.pony"
```

This class only works for the type `U32`, a 32 bit unsigned integer. We can make this work over other types by making the type a parameter to the class. For this example it looks like:

```pony
--8<-- "generics-foo-with-any-val.pony"
```

The first thing to note here is that the `Foo` class now takes a type parameter in square brackets, `[A: Any val]`. That syntax for the type parameter is:

`Name: Constraint ReferenceCapability`

In this case, the name is `A`, the constraint is `Any` and the reference capability is `val`. `Any` is used to mean that the type can be any type - it is not constrained. The remainder of the class definition replaces `U32` with the type name `A`.

The user of the class provides a type when referencing the class name, or lets the compiler [infer it from the arguments](#type-argument-inference). Here the type is provided explicitly:

```pony
--8<--
generics-foo-with-any-val.pony:13:13
generics-foo-with-any-val.pony:18:18
generics-foo-with-any-val.pony:21:21
--8<--
```

That tells the compiler what specific class to create, replacing `A` with the type provided. For example, a `Foo[String]` usage becomes equivalent to:

```pony
--8<-- "generics-foo-string.pony:1:9"
```

## Type Parameter Defaults

Sometimes the same parameter type is used over and over again, and it is tedious to always specify it when using the generic class.
The class `Bar` expects its type parameter to be a `USize val` by default:

```pony
--8<-- "generics-type-parameter-defaults.pony:1:9"
```

Now, when the default type parameter is the desired one, it can simply be omitted. But it is still possible to be explicit or use a different type.

```pony
--8<-- "generics-type-parameter-defaults.pony:13:15"
```

Note that we could simply write `class Bar[A: Any box = USize]` because `val` is the default reference capability of the `USize` type.

## Generic Methods

Methods can be generic too. They are defined in the same way as normal methods but have type parameters inside square brackets after the method name:

```pony
--8<-- "generics-generic-methods.pony"
```

This example shows a constraint other than `Any`. The `Stringable` type is any type with a `string()` method to convert to a `String`.

## Type Argument Inference

When each type argument can be determined from the arguments at the call site, you can omit the type arguments. The generic methods example above includes explicit type arguments:

```pony
--8<-- "generics-generic-methods.pony:7:7"
```

With inference, `A` resolves to `U32` from the argument `U32(10)`, so the type argument can be omitted:

```pony
--8<-- "generics-type-argument-inference-method.pony:7:7"
```

The argument is `U32(10)` rather than the bare `10` from the explicit example — a bare integer literal defaults to `USize`, so `Foo.bar(10)` would resolve `A` to `USize`.

The same applies to constructor calls. The `Foo` class from earlier can be constructed without writing the type argument:

```pony
--8<--
generics-type-argument-inference-constructor.pony:13:13
generics-type-argument-inference-constructor.pony:16:16
generics-type-argument-inference-constructor.pony:19:19
--8<--
```

### Interaction with defaults

When a type parameter has a default and the argument fits the default type, the default is kept. When the argument does not fit, the inferred type replaces the default:

```pony
--8<-- "generics-type-argument-inference-defaults.pony:13:14"
```

In the first line, `42` fits `USize` (the default), so `A` stays `USize`. In the second line, `F32(1.5)` does not fit `USize`, so `A` becomes `F32`.

### When inference does not apply

At least one argument must determine each type parameter. When inference fails, the compiler reports an error — write the type arguments explicitly to resolve it. Cases where inference does not apply:

- The type parameter does not appear in any parameter type (it only appears in the return type, for example).
- The argument at the determining position is an array literal or lambda whose own type depends on the type parameter being inferred. This includes type parameters that appear only in a lambda's result type.
- The parameter type refers to the type parameter through a type alias.
- The parameter type is a union.
- The argument is passed with the `where` keyword (named-only arguments).
- A generic method is called on a type whose own type parameters use defaults and are written without type arguments — add explicit type arguments to either the type or the method.

You can always write the type arguments explicitly — inference is a convenience, not a requirement.
