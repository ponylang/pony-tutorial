---
title: "Object Capabilities"
section: "Object Capabilities"
menu:
  toc:
    parent: "object-capabilities"
    weight: 10
toc: true
---

Pony's capabilities-secure type system is based on the object-capability model. That sounds complicated, but really it's elegant and simple. The core idea is this:

> A capability is an unforgeable token that (a) designates an object and (b) gives the program the authority to perform a specific set of actions on that object.

So what's that token? It's an address. A pointer. A reference. It's just... an object.

## How is that unforgeable?

Since Pony has no pointer arithmetic and is both type-safe and memory-safe, object references can't be "invented" (i.e. forged) by the program. You can only get one by constructing an object or being passed an object.

__What about the C FFI?__ Using the C FFI can break this guarantee. We'll talk about the __C FFI trust boundary__ later, and how to control it.

## What about global variables?

They're bad! Because you can get them without either constructing them or being passed them.

Global variables are a form of what is called _ambient authority_. Another form of ambient authority is unfettered access to the file system.

Pony has no global variables and no global functions. That doesn't mean all ambient authority is magically gone - we still need to be careful about the file system, for example. Having no globals is necessary, but not sufficient, to eliminate ambient authority.

## How does this help?

Instead of having permissions lists, access control lists, or other forms of security, the object-capabilities model means that if you have a reference to an object, you can do things with that object. Simple and effective.

There's a great paper on how the object-capability model works, and it's pretty easy reading:

[Capability Myths Demolished](http://srl.cs.jhu.edu/pubs/SRL2003-02.pdf)

## Capabilities and concurrency

The object-capability model on its own does not address concurrency. It makes clear _what_ will happen if there is simultaneous access to an object, but it does not prescribe a single method of controlling this.

Combining capabilities with the actor-model is a good start, and has been done before in languages such as [E](http://erights.org/) and Joule.

Pony does this and also uses a system of _reference capabilities_ in the type system.
