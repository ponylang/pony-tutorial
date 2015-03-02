A capability is a form of _type qualifier_. If you've used C/C++, you may be familiar with `const`. It's a _type qualifier_ that tells the compiler not to allow the programmer to _mutate_ something.

Pony capabilities provide a lot more guarantees than `const` does.

# List of capabilities

There are six capabilities:

1. `iso`: an isolated type. No other pointer to this object can read from it or write to it.
2. `trn`: a transition type. No other pointer to this object can write to it. Other pointers can read from it, but we are guaranteed that those pointers are only held by the _same_ actor that has the `trn` pointer.
3. `ref`: a reference type. Other pointers to this object can both read from it and write to it, but we are guaranteed that those pointers are only held by the _same_ actor that has the `ref` pointer.
4. `val`: a value type. No pointer, including this one, can write to the object. Readable pointers might be held by _any_ actor in the program.
5. `box`: a boxed type. This pointer can be used to read from the object, but not write to it. No guarantees are made about other pointers.
6. `tag`: a tag type. This pointer can only be used for identity comparison. It can't be used to either read from the object or write to it, and no guarantees are made about other pointers.

