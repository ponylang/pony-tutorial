# What You Need

To get started, you'll need a text editor and the [ponyc](https://github.com/ponylang/ponyc) compiler. Or if you are on a not supported platform or don't want to install the compiler you can use the [Pony's Playground](https://playground.ponylang.io/).

## The Pony compiler

Before you get started, please check out the [installation instructions](https://github.com/ponylang/ponyc/blob/main/INSTALL.md) for the Pony compiler.

## A text editor

While you can write code using any editor, it's nice to use one with some support for the language. We maintain a list of [editors supporting Pony](https://github.com/ponylang/ponyc/blob/main/EDITORS.md).

## The compiler

Pony is a _compiled_ language, rather than an _interpreted_ one. In fact, it goes even further: Pony is an _ahead-of-time_ (AOT) compiled language, rather than a _just-in-time_ (JIT) compiled language.

What this means is that once you build your program, you can run it over and over again without needing a compiler or a virtual machine or anything else. It's a complete program, all on its own.

But it also means you need to build your program before you can run it. In an interpreted language or a JIT compiled language, you tend to do things like this to run your program:

```bash
--8<-- "what-you-need-run-python.sh"
```

Or maybe you put a __shebang__ in your program (like `#!/usr/bin/env python`), then `chmod` to set the executable bit, and then do:

```bash
--8<-- "what-you-need-run-python-shebang.sh"
```

When you use Pony, you don't do any of that!

## Compiling your program

If you are in the same directory as your program, you can just do:

```bash
--8<-- "what-you-need-compile-pony.sh"
```

That tells the Pony compiler that your current working directory contains your source code, and to please compile it. If your source code is in some other directory, you can tell ponyc where it is:

```bash
--8<-- "what-you-need-compile-pony-other-directory.sh"
```

There are other options as well, but we'll cover those later.
