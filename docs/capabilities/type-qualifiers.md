A capability is a form of _type qualifier_. If you've used C/C++, you may be familiar with `const`. It's a _type qualifier_ that tells the compiler not to allow the programmer to _mutate_ something.

Pony capabilities provide a lot more guarantees than `const` does!

# The list of capabilities

There are six capabilities:

1. `iso`: an isolated type. No other pointer to this object can read from it or write to it.
2. `trn`: a transition type. No other pointer to this object can write to it. Other pointers can read from it, but we are guaranteed that those pointers are only held by the _same_ actor that has the `trn` pointer.
3. `ref`: a reference type. Other pointers to this object can both read from it and write to it, but we are guaranteed that those pointers are only held by the _same_ actor that has the `ref` pointer.
4. `val`: a value type. No pointer, including this one, can write to the object. Readable pointers might be held by _any_ actor in the program.
5. `box`: a boxed type. This pointer can be used to read from the object, but not write to it. No guarantees are made about other pointers.
6. `tag`: a tag type. This pointer can only be used for identity comparison. It can't be used to either read from the object or write to it, and no guarantees are made about other pointers.

# How to write a capability

A capability comes at the end of a type. So, for example:

```
String iso // An isolatated string, which is read/write unique.
String trn // A transition string, which is write unique.
String ref // A string reference, which is mutable.
String val // A string value, which is globally immutable.
String box // A string box, which is locally immutable.
String tag // A string tag, which is opaque.
```

__What does it mean when a type has no capability?__ It means you are using the _default_ capability for that type. When you define a type, if you don't specify the default capability, it's `ref`, but you can set it to anything convenient. Here's an example from the standard library:

```
class String val
```

When we use a `String` we usually mean a string value, so we make `val` the default capability for `String`.
