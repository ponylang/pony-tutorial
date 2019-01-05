---
title: "Whitespace"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 40
toc: true
---

Whitespace (e.g. spaces, tabs, newlines, etc.) in Pony isn't significant.

Well, it mostly isn't significant.

## Mostly insignificant whitespace

Pony reads a bit like Python, which is a _whitespace significant_ language. That is, the amount of indentation on a line means something in Python. In Pony, the amount of indentation is meaningless.

That means Pony programmers can format their code in whatever way suits them.

There are three exceptions:

1. A `-` at the beginning of a line starts a new expression (unary negation), whereas a `-` in the middle of an expression is a binary operator (subtraction).
2. A `(` at the beginning of a line starts a new expression (a tuple), whereas a `(` in the middle of an expression is a method call.
3. A `[` at the beginning of a line starts a new expression (an array literal), whereas a `[` in the middle of an expression is generic formal parameters.

That stuff may seem a little esoteric right now, but we'll explain it all later. The `-` part should make sense though.

```pony
a - b
```

That means "subtract b from a".

```pony
a
-b
```

That means "first do a, then, in a new expression, do a unary negation of b".

## Semicolons

In Pony, you don't end an expression with a `;`, unlike C, C++, Java, C#, etc. In fact, you don't need to end it at all! The compiler knows when an expression has finished, like Python or Ruby.

However, sometimes it's convenient to put more than one expression on the same line. When you want to do that, you __must__ separate them with a `;`.

__Why? Can't the compiler tell an expression has finished?__ Yes, it can. The compiler doesn't really need the `;`. However, it turns out the programmer does! By requiring a `;` between expressions on the same line, the compiler can catch some pretty common syntax errors for you.

## Docstrings

Including documentation in your code makes you awesome. If you do it, everyone will love you.

Pony makes it easy by allowing you to put a __docstring__ on every type, field, or method. Just put a string literal right after declaring the type or field, or right after the `=>` of a method, before writing the body. The compiler will know what to do with them.

For traits and interfaces that have methods without bodies, you can put the docstring after the method declaration, even though there is no `=>`.

By convention, a docstring should be a triple-quoted string, and it should use Markdown for any formatting.

```pony
actor Main
  """
  This is documentation for my Main actor
  """

  var count: USize = 0
    """
    This is documentation for my count field
    """

  new create(env: Env) =>
    """
    This is documentation for my create method
    """
    None

trait Readable
  fun val read()
    """
    This is documentation for my unimplemented read method
    """
```

## Comments

Use __docstrings__ first! But if you need to put some comments in the implementation of your methods, perhaps to explain what's happening on various lines, you can use C++ style comments. In Pony, block comments can be nested.

```pony
// This is a line comment.
/* This is a block comment. */
/* This block comment /* has another block comment */ inside of it. */
```
