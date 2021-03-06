# Capability Subtyping

## Simple subtypes

Subtyping is about _substitutability_. That is, if we need to supply a certain type, what other types can we substitute instead? Reference capabilities are one important component. We can start by going through a few simpler cases, and then we will talk about the full chart.

First, let's focus on the four capabilities `ref`, `val`, `box`, and `tag`. These have a very useful property: they alias to themselves (and unalias to themselves, as well). This will make the subtyping a lot simpler to work with. Afterwards we can talk about `iso` and `trn`, whose subtyping is more intricate.

To keep things brief, let's add a small shorthand. We will use the `<:` symbol to mean "is a subtype of", or you can read it as "can be used as".

* `ref <: box`. A `ref` can be written to and read from, while `box` only needs the ability to read.
* `val <: box`. A `val` can be read from and is globally immutable, while `box` only requires the ability to read.
* `box <: tag`. A `box` can be read from, while a `tag` doesn't have any permissions at all. In fact, anything can be used as `tag`.

That's all there is to those four. A `ref` could have other mutable aliases, so it can't become `val`, which requires global uniqueness. Likewise,
`val` can't become `ref` since it can't be used to write (and there could be other `val` aliases requiring immutability).

Also keep in mind, subtyping is _transitive_. That means that since `val <: box` and `box <: tag`, we also get `val <: tag`. The basic cases will be explained below, and transitivity can be used to derive all other subtyping relationships for capabilities.

## Subtypes of unique capabilities

When it comes to talking about unique capabilities, the situation is a bit more complex. With variables, we only had the six basic capabilities,
but we're talking about expressions here. We will have to work with aliased and unaliased forms of the capabilities.

From here, let's talk about ephemeral capabilities. Remember that the way to get an ephemeral capability is by _unaliasing_, that is, moving a value out of a
named location with `consume` or destructive read.

Subtyping here is surprisingly simple: `iso^` is a sub-capability of absolutely everything, and `trn^` is a sub-capability of `ref` and `val`. Let's go through the interesting cases again with these two:

* `iso^ <: trn^`. An `iso^` guarantees there's no readable or writable aliases, whereas `trn^` just needs no writable aliases.
* `trn^ <: ref`. A `trn^` reference can be used to read and write, which is enough for `ref`.
* `trn^ <: val`. A `trn^` reference has no writable aliases. A `val` requires global immutability, so we can forget our writable access in order to get `val`, since we know no other aliases can write.

## Temporary unique access

We talked about aliasing and consuming, but what about when we just use a variable without making a new alias?
If `x` is `iso`, what type do we give to the expression `x`? It would be pretty useless if we could only use our `iso` variables as `tag`. We couldn't modify fields or call any methods.

What we get is the bare `iso` capability. Like `ref`, this allows us to read and write, *but* we will have to keep the destination isolated. We will get into what kind of things we can do with it later, but for now, we will talk about subtyping.

* `iso^` <: `iso`. As mentioned earlier, `iso^` can become *anything*. This isn't enormously useful, all told, but an `iso^` expression with no other names
is stronger than a expression pointing to an existing `iso` name.
* `trn^` <: `trn`. Similarly, we may use an expression that has no writable aliases, as an expression which has one unique writeable alias.
* `iso` <: `tag`. We can't coerce `iso` to anything else since the original name is still around, but we can always drop down to `tag` (which is just `iso!`).
* `trn` <: `box`. This is quite similar, we can forget our ability to write and just get a new `box` alias to store.
