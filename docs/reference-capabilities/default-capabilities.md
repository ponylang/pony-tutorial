# Default Reference Types

All instantiated types have capabilities, but you don't always have to specify them in your code. In some cases, the compiler can infer them, and in others, there are sensible defaults. As you write your first Pony programs, you might find it educational to explicitly specify the reference capabilities for all your classes, functions, parameters, and fields (especially those that are causing compiler errors). For example, consider the following class full of default values:

```pony
class MyPersonalString
  var _my_string: String

  new create(my_string: String) =>
    _my_string = my_string

  fun what_is_my_string(): String =>
    _my_string

  fun ref change_my_string(my_string: String) =>
    _my_string = my_string
```

If we put explicit values where the inferred capabilities are, this class looks like this:

```pony
class ref MyPersonalString
  var _my_string: String val

  new ref create(my_string: String val) =>
    _my_string = my_string

  fun box what_is_my_string(): String val =>
    _my_string

  fun ref change_my_string(my_string: String val) =>
    _my_string = my_string
```

Getting from the former to the latter isn't always obvious, so you may want to keep this document open as you read and write Pony source code. Let's start with a couple tables for quick reference:

## Permanent Reference Capability Types

Actors and primitives are required to be constructed with a certain capability and we aren't able to instruct the compiler otherwise.

| Item                    | Capability |
| ----------------------- | ---------- |
| primitive               | `val`      |
| constructor (primitive) | `val`      |
| literal (primitive)     | `val`      |
| actor                   | `tag`      |
| constructor (actor)     | `tag`      |
| receiver (behaviour)    | `ref`      |
| literal (actor)         | `tag`      |

## Default Reference Capability Types

| Item                         | Default Capability |
| ---------------------------- | ------------------ |
| class                        | `ref`              |
| fields                       | default for type   |
| variables                    | default for type   |
| parameter                    | default for type   |
| constructor (class)          | `ref`              |
| receiver (function)          | `box`              |
| recover (immutable)          | `val`              |
| recover (mutable)            | `iso`              |
| literal (class)              | `ref`              |
| lambda (no mutable captures) | `val`              |
| lambda (mutable captures)    | `ref`              |

## Primitive default capabilities

All primitives have `val` capabilities. Primitives are immutable, there is only one of each primitive, and it is accessible from all actors -- read-only and shareable means the default is `val`.

In fact, attempting to define a primitive as `primitive val MyPrimitive` is a syntax error.

Note: You can make a `tag` reference to a primitive, since it is a subtype of `val`, but all other reference types are denied.

## Actor default capabilities

Actors are always defined with `tag` capability. Other capabilities are denied because anything that can read or write an actor's state while it is running would lead to undefined behaviour. Like primitives, attempting to override the default reference capability is a syntax error.

```pony
actor Actor
```

means instances of Actor have the `tag` capability. No other capability is concurrency safe,.

## Class default capabilities

By default, a class has `ref` capability. Therefore, these two class definitions are equivalent:

```pony
class ref RefClass
  ...

class RefClass
   ...
```

But whether specified by default or explicitly as `class ref` (or `class val` or any other capability) what does it actually mean? A class's default capability only applies when you _define_ a field or local type that points to an instance of it. This can happen when using `let` or `var`, or when specifying a parameter on a function or behaviour.

## Field, variable, and parameter capabilities

For example, `String` is defined in the standard library as `class val String`. So its default capability is the immutable, shareable `val` capability. That means that all the `String`s in the following actor definition could be replaced with `String val`:

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

These defaults apply only when the type is specified, and not how it is constructed. The default capability on a class **does not** influence what is returned by the constructors for that class.

## Constructor capabilities

A primitive constructor _always_ returns an object with `val` capabilities, and an actor constructor _always_ returns an object with `tag` capabilities. In fact, it is forbidden to put a capability after `new` when defining a primitive or actor.

Classes are more flexible. The capability returned by a constructor defaults to `ref` if you are constructing a `class`. You have the option to specify a different capability by explicitly typing the constructor (e.g., `new iso create_iso`).

Consider the following class:

```pony
class val MyClass
  let foo: String

  new create_ref(foo': String) =>
    foo = foo'

  new val create_val(foo': String) =>
    foo = foo'
```

This class has two constructors. The first one, `create_ref` returns a `MyClass` with `ref` capability because `ref` is always default for class constructors. The second one `create_val` explicitly returns a `MyClass` with `val` capability.

_Tip_: Instead of using the default `ref` type for constructors, consider using `iso`. Recall that constructors, like `consume`, return their values as an ephemeral type. That means that a constructor typed as `new iso` actually returns a `iso^`. And `iso^` has the terrific property of being convertible to any other capability! Consider:

```pony
class MyIsoClass
  let foo: String

  new iso create(foo': String) =>
    foo = foo'
```

This class can be constructed as a `ref` or `val` (or any other capability) without use of `recover`:

```pony
a_ref: MyIsoClass ref = MyIsoClass.create()
a_val: MyIsoClass val = MyIsoClass.create()
```

Autogenerated constructors are also `ref`. The auto-generated constructor for the following class also returns a `ref^`:

```pony
class AllDefaults
  var foo: String = "hello"
```

You can construct instances of this class with a specific capability by specifying the type of the result:

```pony
let a = AllDefaults // a is ref
let b: AllDefaults iso = AllDefaults // b is iso
let c: AllDefaults val = AllDefaults // c is val
```

## Default receiver capabilities

Recall that when you call a function or behaviour, it always implicitly gets a reference to itself in the form of `this`.

The default receiver capability for a function is `box`, as shown in `get_foo` below:

```pony
class MyClass
  var foo: String = ""

  fun get_foo() => foo

  fun ref set_foo(foo': String) => foo = foo'
```

Notably, you can't mutate a `box`, so mutable methods _must_ be defined as `fun ref` or `fun trn`.

TO DO: THIS IS WRONG. The _only_ behavior capability for an actor is `ref`. You cannot specify a `be val` for example, or even `be ref`. This may be counter-intuitive since the _caller_ only has a tag to the actor, but the actor is totally free to reference its own fields from the behaviour.

## Default recover capabilities

If you are recovering a value, it will default to `val` if the value is immutable (`val` or `box`), and `iso` if it is mutable (`ref` or `trn`):

```pony
var i_am_iso = recover MyClass.create_ref("abc") end
var i_am_val = recover MyClass.create_box("def") end
```

You can still change the capability using `recover ref` or similar.

## Default object literal capabilities

The defaults for an object created by a literal are the same as if the object had been created with the correct `primitive`, `actor` or `class` keyword. The fun bit here is not that the capability is inferred, but that the kind of object is inferred!

For example:

```pony
let myActor = object
  be apply() => None
end
```

has `tag` capabilities as it is an anonymous actor because it defines at least one behaviour.

````pony
let myPrimitive = object
  fun apply() => None
end

has `val` capabilities as it is an anonymous primitive because it defines neither behaviours nor internal state.

```pony
let myObject = object
  let s: String = "hello"
end
```

has `ref` capabilities as it is an anonymous class due to having no behaviours and maintaining internal state.

## Default lambda capabilities

Recall that a lambda creates an object literal with an `apply` function. That underlying object has `ref` capability if it captures any mutable variables. If it does not capture variables or the variables it captures are immutable, it defaults to `val` capability.

```pony
var myLambdaVal = {(s: String): String => "my Lambda" + s}
var myLambdaRef = {(s: String): String => myLambdaVal("here") + s}
````

`myLambdaVal` has `val` capabilities because it doesn't capture anything. `myLambdaRef` defaults to `ref` capabilities because it captures `myLambdaVal`.

You can specify a different capability after the lambda:

```pony
var myOtherLambdaRef = {(): String => "hello"} ref
```

is a `ref` even though with no captures it would have defaulted to `val` capability.
