# Overview

Often when writing code you want to create similar classes or functions that differ only in the type that they operate on. The classic example of this is collection classes. You want to be able to create an `Array` that can hold objects of a particular type without creating an `IntArray`, `StringArray`, etc. This is where generics step in.

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

The user of the class must provide a type when referencing the class name. This is done when creating it:

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

### Type parameter defaults

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

These examples show the basic idea behind generics and how to use them. Real world usage gets quite a bit more complex and the following sections will dive deeper into how to use them.
