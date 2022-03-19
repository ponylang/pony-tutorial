# Default Reference Types

We've mentioned throughout this tutorial what the default reference capabilities are for types and classes. However, there's a good chance those defaults passed over your head while you were focused on understanding capabilities themselves.

First, there is nothing saying you have to use default capabilities. Especially as you start writing your first Pony programs, you'll probably find it very educational to explicitly specify the capabilities for all your classes, actors, functions, parameters and fields. However, it's not _writing_ code that makes default capabilities confusing; it's _reading_ that code. Hopefully keeping this summary open will help you navigate pony source code until you've become used to the defaults!

## Reference type summary

We go into detail of the default types below, but here's a table summarizing them:

| Item                    | Default Capability | Explanation                                                             |
| ----------------------- | ------------------ | ----------------------------------------------------------------------- |
| primitive               | `val`              | Primitives are immutable and can never be anything but `val`            |
| actor                   | `tag`              | Actors can neither be read nor written and are always `tag`             |
| class                   | `ref`              | Instances of classes default to ref type if unspecified                 |
| fields                  | default for type   | Whatever was specified on the _target_ class                            |
| variables               | default for type   | Whatever was specified on the _target_ class                            |
| parameter               | default for type   | Whatever was specified on the _target_ class                            |
| constructor (primitive) | `val`              | Only classes can have different constructor capabilities                |
| constructor (actor)     | `tag`              | Only classes can have different constructor capabilities                |
| constructor (class)     | `ref`              | Only classes can have different constructor capabilities                |
| receiver (function)     | `box`              | Functions cannot mutate class state by default (use `func ref`)         |
| receiver (behaviour)    | `ref`              | Actors can mutate their state from inside a behaviour                   |
| recover (immutable)     | `val`              | An immutable value (box or val) is recovered to `val` by default        |
| recover (mutable)       | `iso`              | An immutable value (box or val) is recovered to `val` by default        |
| literal (object)        | `ref`              | object literals default to same capabilities as their non-literal types |
| literal (actor)         | `tag`              | object literals default to same capabilities as their non-literal types |
| literal (primitive)     | `val`              | object literals default to same capabilities as their non-literal types |
| lambda (no captures)    | `val`              | lambda capabilities depend on whether they capture their environment    |
| lambda (captures)       | `ref`              | lambda capabilities depend on whether they capture their environment    |

## Primitive default capabilities

Let's start with primitives because they're easy. All primitives have `val` capabilities. They are immutable, they are read only, there is only one of each primitive, and they are accessible from all actors. So `val`.

In fact, defining a primitive as `primitive val MyPrimitive` is a syntax error. Primitives are so `val` that you can't even tell them they are `val`.

## Actor default capabilities

Similar to primitives, actors always have a `tag` default capability. Like primitives, it is not possible to specify a different default capability for tags.

```pony
actor Actor
```

has `tag` capabilities

```pony
actor ref Actor
```

is illegal

## Class default capabilities

By default, a class has `ref` capability. Therefore, these two class definitions are equivalent:

```pony
class ref RefClass
    ...

class RefClass
    ...
```

But whether specified by default or explicitly as `class ref` (or `class val` or any other capability) what does it actually mean? A class or actor's default capability only applies when you _define_ a field or local type. This can happen either as `let` or `var`, or when specifying a parameter on a function or behaviour.

## Field, Variable, and Parameter capabilities

For example, `String` is defined in the standard library as `class val String`. So it's default capability is the immutable shareable `val` capability. That means that all the `String`s in the following actor definition could be replaced with `String val`:

```pony
actor UsesStrings
    let s1: String
    var s2: String

    new create(s1': String, s2': String) =>
        s1 = s1'
        s2 = s2'

    be do_thing(s3: String) =>
        None

```

However `StringBytes` is defined as `class ref`, so all the `StringBytes`' in the following class definition are equivalent to `StringBytes ref`:

```pony
class UsesStringBytes
    let s1: StringBytes
    var s2: StringBytes

    new create(s1': StringBytes, s2': StringBytes) =>
        s1 = s1'
        s2 = s2'

    fun do_thing(s3: StringBytes) =>
        None
```

Notably, however, the default capability on a class **does not** influence the constructors for that class.

## Constructor capabilities

Let's start with the easy defaults first: A primitive constructor _always_ returns an object with `val` capabilities, and an actor constructor _always_ returns an object with `tag` capabilities. In fact, it is forbidden to put a capability after `new` when defining a primitive or actor.

Classes are a little more flexible. The capability returned by a `new` constructor default to a `ref` if you are constructing a `class`. This is true regardless of what the default capability for the class is, but you have the option to specify a different capability by explicitly typing the constructor as e.g `new var create` or `new iso create_iso`.

Consider the following class:

```pony
class val MyClass
    let foo: String

    new create_ref(foo': String) =>
        foo = foo'

    new val create_val(foo': String) =>
        foo = foo'
```

This class has two constructors. The first one, `create_ref` returns a `MyClass` with `ref` capabilities because `ref` is always default for class constructors. The second one `create_val` explicitly returns a `MyClass` with `val` capabilities.

_Tip_: Instead of using the default `ref` type for constructors, consider using `iso`. Recall that constructors, like `consume` return their values as an ephemeral type. That means that a constructor typed as `new iso` actually returns a `iso^`. And `iso^` has the terrific property of being convertible to any other type! Consider:

```pony
class MyIsoClass
    let foo: String

    new iso create(foo': String) =>
        foo = foo'
```

This class can be constructed as a ref or val or whatever else:

```pony
a_ref: MyIsoClass ref = MyIsoClass.create()
a_val: MyIsoClass val = MyIsoClass.create()
```

In fact, this is what happens if you do not specify a constructor at all. The hidden constructor for this class also returns an `iso^`:

```pony
class AllDefaults
    var foo: String = "hello"
```

You can construct instances of this class with a specific capability by specifying the type of the result:

```pony
let a = AllDefaults // a is iso
let b: AllDefaults ref = AllDefaults // b is ref
let c: AllDefaults val = AllDefaults // c is val
```

Constructors create objects, but what about when you access functions on those objects?

## Default receiver capabilities

Recall that when you call a function or behaviour, it always implicitly gets a reference to the `this` object.

The default receiver capability for a function is `box`, as shown in `get_foo` below:

```pony
class MyClass
    var foo: String = ""

    fun get_foo() => foo

    fun ref set_foo(foo': String) => foo = foo'
```

Notably, you can't mutate a `box`, so mutable methods must be defined as `fun ref` or `fun trn`.

The _only_ behavior capability for an actor is `ref`. You cannot specify a `be val` for example, or even `be ref`. This may be counter-intuitive since the _caller_ only has a tag to the actor, but the actor is totally free to reference its own fields from the behaviour.

## Default recover capabilities

If you are recovering a value, it will default to `val` if the value is immutable (`val` or `box`), and `iso` if it is mutable (`ref` or `trn`):

```pony
var i_am_iso = recover MyClass.create_ref("abc") end
var i_am_val = recover MyClass.create_box("def") end
```

You can, of course, change the capability using `recover ref` or similar.

## Default object literal capabilities

The default capabilities on an object literal depend on whether the object literal specifies a primitive, actor or class, and use the same defaults as the accompanying type:

```pony
let myObject = object
    let s: String = "hello"
end
```

has `ref` capabilities (it is an object of an anonymous class).

```pony
let myActor = object
    be apply() => None
end
```

has tag capabilities.

```pony
let myPrimitive = object
fun apply() => None
end
```

has `val` capabilities.

## Default lambda capabilities

Recall that a lambda creates an object literal with an `apply` function. That underlying object has `ref` capabilities if it captures any variables. If it does not capture variables, it defaults to `val` capabilities.

```pony
var myLambdaVal = {(s: String): String => "my Lambda" + s}
var myLambdaRef = {(s: String): String => myLambdaVal("here") + s}
```

`myLambdaVal` has `val` capabilities because it doesn't capture anything. `myLambdaRef` defaults to `ref` capabilities because it captures `myLambdaVal`.

You can specify different capabilities after the lambda:

```pony
var myOtherLambdaRef = {(): String => "hello"} ref
```

is a `ref` even though with no captures it would have defaulted to `val` capabilities.
