# Generics and Reference Capabilities

In the examples presented previously we've explicitly set the reference capability to `val`:

```pony
class Foo[A: Any val]
```

If the capability is left out of the type parameter then the generic class or function can accept any reference capability. This would look like:

```pony
class Foo[A: Any]
```

It can be made shorter because `Any` is the default constraint, leaving us with:

```pony
class Foo[A]
```

This is what the example shown before looks like but with any reference capability accepted:

```pony
// Note - this won't compile
class Foo[A]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo[U32](42)
    env.out.print(a.get().string())
    a.set(21)
    env.out.print(c.get().string())
```

Unfortunately this doesn't compile. For a generic class to compile it must be compilable for all possible types and reference capabilities that satisfy the contraints in the type parameter. In this case that's any type with any reference capability. The class works for the specific reference capability of `val` as we saw earlier, but how well does it work for `ref`? Let's expand it and see:

```pony
class Foo
  var _c: String ref

  new create(c: String ref) =>
    _c = c

  fun get(): String ref => _c

  fun ref set(c: String ref) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo(recover ref String end)
    env.out.print(a.get().string())
    a.set(recover ref String end)
    env.out.print(a.get().string())
```

That compiles and runs, so `ref` is valid. The real test though is `iso`. Let's convert the class to `iso` and walk through what is needed to get it to compile. We'll then revisit our generic class to get it working:

## An `iso` specific class

```pony
// Note - this won't compile
class Foo
  var _c: String iso

  new create(c: String iso) =>
    _c = c

  fun get(): String iso => _c

  fun ref set(c: String iso) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo(recover iso String end)
    env.out.print(a.get().string())
    a.set(recover iso String end)
    env.out.print(a.get().string())
```

This fails to compile. The first error is:

```
main.pony:5:8: right side must be a subtype of left side
    _c = c
       ^
    Info:
    main.pony:4:17: String iso! is not a subtype of String iso: iso! is not a subtype of iso
      new create(c: String iso) =>
                ^
```

The error is telling us that we are aliasing the `String iso` - The `!` in `iso!` means it is an alias of an existing `iso`. Looking at the code shows the problem:

```pony
new create(c: String iso) =>
  _c = c
```

We have `c` as an `iso` and are trying to assign it to `_c`. This creates two aliases to the same object, something that `iso` does not allow. To fix it for the `iso` case we have to `consume` the parameter. The correct constructor should be:

```pony
new create(c: String iso) =>
  _c = consume c
```

A similar issue exists with the `get` method.

```pony
fun get(): String iso => _c
```

We can't return an `iso` alias to our internal `_c` field as we'd then have two aliases to an `iso` again. One in the class and one returned to the caller. We can't `consume` here because then our `_c` field has no value. Instead we can make the return reference capability be something that is a valid alias of `iso`. Looking at the [capability subtyping aliased substitution rules](../capabilities/capability-subtyping.html) the capability we need is a `tag`. Here is a corrected class definition:

```pony
class Foo
  var _c: String iso

  new create(c: String iso) =>
    _c = consume c

  fun get(): String tag => _c

  fun ref set(c: String iso) => _c = consume c

actor Main
  new create(env:Env) =>
    let a = Foo(recover iso String end)
//    env.out.print(a.get().string())
    a.set(recover iso String end)
//    env.out.print(a.get().string())
```

This compiles but we have a problem. We can't print the result of `get` because it's a `tag`. A `tag` doesn't allow read or write access. It can only be used for calling behaviours (ie. on an `actor`) or for object identity purposes. 

We can fix this by using [an arrow type](../capabilities/arrow-types.html). Defining `get' as:

```pony
fun get(): this->String iso => _c
```

An arrow type with "this->" states to use the capability of the actual receiver (`ref` in our case), not the capability of the method (which defaults to `box` here). According to [viewpoint adaption](../capabilities/combining-capabilities.html) this will be `ref->iso` which is `iso`. Through the magic of [automatic receiver recovery](../capabilities/recovering-capabilities.html) we can call the `string` method on it. The following class definition works:

```pony
class Foo
  var _c: String iso

  new create(c: String iso) =>
    _c = consume c

  fun get(): this->String iso => _c

  fun ref set(c: String iso) => _c = consume c

actor Main
  new create(env:Env) =>
    let a = Foo(recover iso String end)
    env.out.print(a.get().string())
    a.set(recover iso String end)
    env.out.print(a.get().string())
```

## A capability generic class

Now that we have `iso` working we know how to write a generic class that works for `iso` and it will work for other capabilities too:

```pony
class Foo[A]
  var _c: A

  new create(c: A) =>
    _c = consume c

  fun get(): this->A => _c

  fun ref set(c: A) => _c = consume c

actor Main
  new create(env:Env) =>
    let a = Foo[String iso]("Hello".clone())
    env.out.print(a.get().string())

    let b = Foo[String ref](recover ref "World".clone() end)
    env.out.print(b.get().string())

    let c = Foo[U8](42)
    env.out.print(c.get().string())
```

It's quite a bit of work to get a generic class or method to work across all capability types, in particular for `iso`. There are ways of restricting the generic to subsets of capabilities and that's the topic of the next section.
