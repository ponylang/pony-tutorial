A capability is a form of _type qualifier_. If you've used C/C++, you may be familiar with `const`, which is a _type qualifier_ that tells the compiler not to allow the programmer to _mutate_ something.

Pony capabilities provide a lot more guarantees than `const` does!

# The list of capabilities

There are six capabilities:

1. `iso`: an isolated type. No other variable can be used to read from or write to this object.
2. `trn`: a transition type. No other variable can be used to write to this object. Other variables can be used to read from it, but we are guaranteed that those variables are only held by the _same_ actor that has the `trn` variable.
3. `ref`: a reference type. Other variables can be used to both read from and write to this object, but we are guaranteed that those variables are only held by the _same_ actor that has the `ref` variable.
4. `val`: a value type. No variable, including this one, can be used to write to the object. Readable variables might be held by _any_ actor in the program.
5. `box`: a box type. This variable can be used to read from the object, but not write to it. If there is any variable that can be used to write to the object, it's guaranteed to be held by the _same_ actor that has the `box` variable.
6. `tag`: a tag type. This variable can't be used to read from the object or write to it, and no guarantees are made about other variables.

In Pony, every use of a type has a capability. These capabilities apply to variables, rather than to the type as a whole. In other words, when you define a `class Wombat`, you don't pick a capability for it. Instead, `Wombat` variables each have their own capability.

As an example, in some languages you have to define a type that represents a mutable `String` and another type that represents an immutable `String`. For example, in Java there is a `String` and a `StringBuilder`. In Pony, you can define a single `class String` and have some variables that are `String ref` and other variables that are `String val`.

# How to write a capability

A capability comes at the end of a type. So, for example:

```pony
String iso // An isolatated string, which is mutable and read/write unique.
String trn // A transition string, which is mutable and write unique.
String ref // A string reference, which is mutable.
String val // A string value, which is globally immutable.
String box // A string box, which is locally immutable.
String tag // A string tag, which is opaque.
```

__What does it mean when a type doesn't specify a capability?__ It means you are using the _default_ capability for that type. When you define a type, if you don't specify the default capability, it's `ref`, but you can set it to anything convenient. Here's an example from the standard library:

```pony
class String val
```

When we use a `String` we usually mean a string value, so we make `val` the default capability for `String`.
