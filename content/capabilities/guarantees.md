---
title: "Reference Capability Guarantees"
section: "Capabilities"
menu:
  toc:
    parent: "capabilities"
    weight: 30
---

Since types are guarantees, it's useful to talk about what guarantees a reference capability makes.

## What is denied

We're going to talk about reference capability guarantees in terms of what's _denied_. By this, we mean: what can other variables _not_ do when you have a variable with a certain reference capability?

We need to distinguish between the actor that contains the variable in question and _other_ actors.

This is important because data reads and writes from other actors may occur concurrently. If two actors can both read the same data and one of them changes it then it will change under the feet of the other actor. This leads to data-races and the need for locks. By ensuring this situation can never occur Pony eliminates the need for locks.

All code within any one actor always executes sequentially. This means that data accesses from multiple variables within a single actor do not suffer from data-races.

## Mutable reference capabilities

The __mutable__ reference capabilities are `iso`, `trn` and `ref`. These reference capabilities are __mutable__ because they can be used to both read from and write to an object.

* If an actor has an `iso` variable, no other variable can be used by _any_ actor to read from or write to that object. This means an `iso` variable is the only variable anywhere in the program that can read from or write to that object. It is _read and write unique_.
* If an actor has a `trn` variable, no other variable can be used by _any_ actor to write to that object, and no other variable can be used by _other_ actors to read from or write to that object. This means a `trn` variable is the only variable anywhere in the program that can write to that object, but other variables held by the same actor may be able to read from it. It is _write unique_.
* If an actor has a `ref` variable, no other variable can be used by _other_ actors to read from or write to that object. This means that other variables can be used to read from and write to the object, but only from within the same actor.

__Why can they be used to write?__ Because they all stop _other_ actors from reading from or writing to the object. Since we know no other actor will be reading, it's safe for us to write to the object, without having to worry about data-races. And since we know no other actor will be writing, it's safe for us to read from the object, too.

## Immutable reference capabilities

The __immutable__ reference capabilities are `val` and `box`. These reference capabilities are __immutable__ because they can be used to read from an object, but not to write to it.

* If an actor has a `val` variable, no other variable can be used by _any_ actor to write to that object. This means that the object can't _ever_ change. It is _globally immutable_.
* If an actor has a `box` variable, no other variable can be used by _other_ actors to write to that object. This means that other actors may be able to read the object and other variables in the same actor may be able to write to it (although not both). In either case, it is safe for us to read. The object is _locally immutable_.

__Why can they be used to read but not write?__ Because these reference capabilities only stop _other_ actors from writing to the object. That means there is no guarantee that _other_ actors aren't reading from the object, which means it's not safe for us to write to it. It's safe for more than one actor to read from an object at the same time though, so we're allowed to do that.

## Opaque reference capabilities

There's only one __opaque__ reference capability, which is `tag`. A `tag` variable makes no guarantees about other variables at all. As a result, it can't be used to either read from or write to the object.

It's still useful though: you can do identity comparison with it, you can call behaviours on it, and you can call functions on it that only need a `tag` receiver.

__Why can't `tag` be used to read or write?__ Because `tag` doesn't stop _other_ actors from writing to the object. That means if we tried to read, we would have no guarantee that there wasn't some other actor writing to the object, so we might get a race condition.
