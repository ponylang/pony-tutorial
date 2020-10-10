---
title: "Capability Subtyping"
section: "Reference Capabilities"
menu:
  toc:
    parent: "reference-capabilities"
    weight: 80
toc: true
---

## Simple subtypes

Subtyping is about _substitutability_. That is, if we need to supply a certain type, what other types can we substitute instead? Reference capabilities are one important component. We can start by going through a few simpler cases, and then we'll talk about the full chart.

First, let's focus on the four capabilities `ref`, `val`, `box`, and `tag`. These have a very useful property: they alias to themselves (and unalias to themselves, as well). This will make the subtyping a lot simpler to work with. Then we can talk about `iso` and `trn`.

To keep things brief, let's add a small shorthand. We'll use the `<:` symbol to mean "is a subtype of", or you can read it as "can be used as".

* `ref <: box`. A `ref` can be written to and read from, while `box` only has the permission to read.
* `val <: box`. A `val` can be read from and is globally immutable, while `box` only requires the ability to read.
* `box <: tag`. A `box` can be read from, while a `tag` doesn't have any permissions at all. In fact, anything can be used as `tag`.

That's pretty much all there is to those four. A `ref` could have other mutable aliases, so it can't become `val`, which requires global uniqueness. Likewise,
`val` can't become `ref` since it can't be used to write (and there could be other `val` aliases requiring immutability).

Also keep in mind, subtyping is _transitive_. That means that since `val <: box` and `box <: tag`, we also get `val <: tag`. The basic cases will be explained below, and transitivity can be used to derive all other subtyping relationships for capabilities.

## Subtypes of unique capabilities

When it comes to talking about unique capabilities, the situation is a bit more complex. With variables, we only had the six basic capabilities,
but we're talking about expressions here. We'll have to work with aliased and unaliased forms of the capabilities.

Let's get one thing settled right off the bat: `iso! = tag`, and `trn! = box`. Remember that `!` is the modifier for stable, named aliases. So it's the strongest capability that is compatible with the original. In the case of `iso`, nothing else is allowed access, so we get `tag`, and for `trn` we allow readable aliases,
so we get `box` (of course the original `trn` alias is mutable, so we can't have `val`).

From here, let's talk about ephemeral capabilities. Remember that the way to get an ephemeral capability is by _unaliasing_, that is, moving a value out of a
named location with `consume` or destructive read.

Subtyping here is surprisingly simple: `iso^` is a subcap of absolutely everything, and `trn^` is a subcap of `ref` and `val`. Let's go through the interesting cases again with these two:

* `iso^ <: trn^`. An `iso^` guarantees there's no readable or writable aliases, whereas `trn^` just needs no writable aliases.
* `trn^ <: ref`. A `trn^` reference can be used to read and write, which is enough for `ref`.
* `trn^ <: val`. A `trn^` reference has no writable aliases. A `val` requires global immutability, so we can forget our writable access in order to get `val`, since we know no other aliases can write.

## Temporary unique access

Above we've talked about stable aliases, and unaliasing, but what about when we just use a variable?
If `x` is `iso`, what's the type of the expression that's just `x`? It would be pretty useless if we could only use our `iso` variables as `tag`. We couldn't modify fields or call any methods.

What we get is the bare `iso` capabillity. Like `ref`, this allows us to read and write, *but* we'll have to keep the destination isolated. We'll get into what
kind of things we can do with it later, but for now, we'll talk about subtyping.

* `iso^` <: `iso`. As mentioned earlier, `iso^` can become *anything*. This isn't enormously useful, all told, but an `iso^` expression with no other names
is stronger than a expression pointing to an existing `iso` name.
* `trn^` <: `trn`. Similarly, we may use an expression that has no writable aliases, as an expression which has one unique writeable alias.
* `iso` <: `tag`. We can't coerce `iso` to anything else since the original name is still around, but we can always drop down to `tag` (which is just `iso!`).
* `trn` <: `box`. This is quite similar, we can forget our ability to write and just get a new `box` alias to store.
