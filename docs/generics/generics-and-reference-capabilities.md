# Generics and Reference Capabilities

In the examples presented previously we've explicitly set the reference capability to `val`:

```pony
--8<-- "generics-foo-with-any-val.pony::1"
```

If the capability is left out of the type parameter then the generic class or function can accept any reference capability. This would look like:

```pony
--8<-- "generics-and-reference-capabilities-explicit-constraint-and-default-capability.pony"
```

It can be made shorter because `Any` is the default constraint, leaving us with:

```pony
--8<-- "generics-and-reference-capabilities-default-capability-and-constraint.pony"
```

This is what the example shown before looks like but with any reference capability accepted:

```pony
--8<-- "generics-and-reference-capabilities-accept-any-reference-capability.pony"
```

Unfortunately, this doesn't compile. For a generic class to compile it must be compilable for all possible types and reference capabilities that satisfy the constraints in the type parameter. In this case, that's any type with any reference capability. The class works for the specific reference capability of `val` as we saw earlier, but how well does it work for `ref`? Let's expand it and see:

```pony
--8<-- "generics-and-reference-capabilities-foo-ref.pony"
```

This does not compile. The compiler complains that `get()` doesn't actually return a `String ref`, but `this->String ref`. We obviously need to simply change the type signature to fix this, but what is going on here?
`this->String ref` is [an arrow type](/reference-capabilities/arrow-types.md). An arrow type with "this->" states to use the capability of the actual receiver (`ref` in our case), not the capability of the method (which defaults to `box` here). According to [viewpoint adaption](/reference-capabilities/combining-capabilities.md) this will be `ref->ref` which is `ref`. Without this [arrow type](/reference-capabilities/arrow-types.md) we would only see the field `_c` as `box` because we are in a `box` method.

So let's apply what we just learned:

```pony
--8<-- "generics-and-reference-capabilities-foo-ref-and-this-ref.pony"
```

That compiles and runs, so `ref` is valid now. The real test though is `iso`. Let's convert the class to `iso` and walk through what is needed to get it to compile. We'll then revisit our generic class to get it working:

## An `iso` specific class

```pony
--8<-- "generics-and-reference-capabilities-foo-iso.pony"
```

This fails to compile. The first error is:

```error
--8<-- "generics-and-reference-capabilities-foo-iso-error-message.txt"
```

The error is telling us that we are aliasing the `String iso` - The `!` in `iso!` means it is an alias of an existing `iso`. Looking at the code shows the problem:

```pony
--8<-- "generics-and-reference-capabilities-foo-iso.pony:5:6"
```

We have `c` as an `iso` and are trying to assign it to `_c`. This creates two aliases to the same object, something that `iso` does not allow. To fix it for the `iso` case we have to `consume` the parameter. The correct constructor should be:

```pony
--8<-- "generics-and-reference-capabilities-foo-iso-consume-iso-constructor-parameter.pony:4:5"
```

A similar issue exists with the `set` method. Here we also need to consume the variable `c` that is passed in:

```pony
--8<-- "generics-and-reference-capabilities-foo-iso-consume-iso-function-parameter.pony"
```

Now we have a version of `Foo` that is working correctly for `iso`. Note how applying the arrow type to the `get` method also works for `iso`. But here the result is a different one, by applying [viewpoint adaptation](/reference-capabilities/combining-capabilities.md) we get from `ref->iso` (with `ref` being the capability of the receiver, the `Foo` object referenced by `a`) to `iso`. Through the magic of [automatic receiver recovery](/reference-capabilities/recovering-capabilities.md) we can call the `string` method on it:

```pony
--8<-- "generics-and-reference-capabilities-foo-iso-consume-iso-constructor-parameter.pony"
```

## A capability generic class

Now that we have `iso` working we know how to write a generic class that works for `iso` and it will work for other capabilities too:

```pony
--8<-- "generics-and-reference-capabilities-capability-generic-class.pony"
```

It's quite a bit of work to get a generic class or method to work across all capability types, in particular for `iso`. There are ways of restricting the generic to subsets of capabilities and that's the topic of the next section.
