# Pony tutorial

Welcome to the Pony tutorial! If you're reading this, chances are you want to learn Pony. That's great, we're going to make that happen.

This tutorial is aimed at people who have some experience programming already. It doesn't really matter if you know a little Python, or a bit of Ruby, or you are a Javascript hacker, or Java, or Scala, or C/C++, or Haskell, or OCaml: as long as you've written some code before, you should be fine.

## More help

If you need more help than this tutorial gives you, you can always write to the developer's mailing list, <ponydev@lists.ponylang.org>, or [open an issue](https://github.com/CausalityLtd/ponyc/issues). Whatever your question is, it isn't dumb, and we won't get annoyed.

## What's Pony, anyway?

Pony is an object-oriented, actor-model, capabilities-secure programming language. It's __object-oriented__ because it has classes and objects, like Python, Java, C++, and many other languages. It's __actor-model__ because it has _actors_ (similar to Erlang or Akka). These behave like objects, but they can also execute code _asynchronously_. Actors make Pony awesome. 

When we say Pony is __capabilities-secure__, we mean a few things:

* It's type safe. Really type safe. There's a mathematical proof and everything.
* It's memory safe. Ok, this comes with type safe, but it's still interesting. There are no dangling pointers, no buffer overruns, heck, the language doesn't even have the concept of _null_!
* It's exception safe. There are no runtime exceptions. All exceptions have defined semantics, and they are _always_ caught.
* It's data-race free. Pony doesn't have locks or atomic operations or anything like that. Instead, the type system ensures _at compile time_ that your concurrent program can never have data races. So you can write highly concurrent code and never get it wrong.
* It's deadlock free. This one is easy, because Pony has no locks at all! So they definitely don't deadlock, because they don't exist.
