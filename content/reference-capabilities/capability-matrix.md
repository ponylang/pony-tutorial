---
title: "Reference Capability Matrix"
section: "Reference Capabilities"
menu:
  toc:
    parent: "reference-capabilities"
    weight: 110
toc: true
---

At this point, it's quite possible that you read the previous sections in this chapter and are still pretty confused about the relation between reference capabilities. It's okay! We have all struggled when learning this part of Pony, too. Once you start working on Pony code, you'll get a better intuition with them.

In the meantime, if you still feel like all these tidbits in the chapter are still scrambled in your head, there is one resource often presented with Pony that can give you a more visual representation: the __reference capability matrix__.

It is also the origin of the concept behind each capability in Pony, in the sense of how each capability denies certain properties to its reference -- in other words, which guarantees a capability makes. We will explain what that actually means before presenting the matrix.

## Local and global aliases

Before anything else, we want to clarify what we mean by "local" and "global" aliases.

A local alias is a reference to the same variable that exists in the same actor. Whenever you pass a value around, and it's not the argument of an actor's behavior, this is the kind of alias we are working with.

On the other hand, a global alias is a reference to the same variable that can exist in a _different_ actor. That is, it describes the properties of how two or more actors could interact with the same reference.

Each reference capability in Pony is actually a pair of local guarantees and global guarantees. For instance, `ref` doesn't deny any read/write capabilities inside the actor, but denies other actors from reading or writing to that reference.

You may recall from the [Reference Capability Guarantees](guarantees.md) section that mutable references cannot be safely shared between actors, while immutable references can be read by multiple actors. In general, global properties are always as restrictive or more restrictive than the local properties to that reference - what is denied globally must also be denied locally. For example, it's not possible to write to an immutable reference in either a global or local alias. It's also not possible to read from or write to an opaque reference, `tag`. Therefore, some combinations of local and global aliases are impossible, and have no designated capabilities.

## Reference capability matrix

Without further ado, here's the reference capability matrix:

---

&nbsp; | Deny global read/write aliases | Deny global write aliases | Don't deny any global aliases
----- | ----- | ----- | -----
__Deny local read/write aliases__ | __`iso`__ | |
__Deny local write aliases__ | `trn` | __`val`__ |
__Don't deny any local aliases__ | `ref` | `box` | __`tag`__
&nbsp; | _(Mutable)_ | _(Immutable)_ | _(Opaque)_

---

In the context of the matrix, "denying a capability" means that any other alias to that reference is not allowed to do that action. For example, since `trn` denies other local write aliases (but allows reads), this is the only reference that allows writing to the object; and since it denies both read and write aliases to other actors, it's safe to write inside this actor, thus being mutable. And since `box` does not break any guarantees that `trn` makes (local reads are allowed, but global writes are forbidden), we can create `box` aliases to a `trn` reference.

You'll notice that the top-right side is empty. That's because, as previously discussed, we cannot make any local guarantees that are more restrictive than the global guarantees, or we'd end up with invalid capabilities that could be written to in this actor but read somewehre else at the same time.

The matrix also helps visualizing other concepts previously discussed in this chapter:

* __Sendable capabilities__. If we want to send references to a different actor, we must make sure that the global and local aliases make the same guarantees. It'd be unsafe to send a `trn` to another actor, since we could possibly hold `box` references locally. Only `iso`, `val`, and `tag` have the same global and local restrictions – all of which are in the main diagonal of the matrix.
* __Ephemeral subtyping__. If we have an ephemeral capability (for instance, `iso^` after consuming an isolated variable), we can be more permissive for the new alias, i.e. remove restrictions, such as allowing local aliases with read capabilities, and receive the reference into a `trn^`; or both read and write, which gives us `ref`. The same is true for more global alias, and we can get `val`, `box`, or `tag`. Visually, this would be equivalent to walking downwards and/or to-the-right starting from the capability in the matrix.
* __Recovering capabilities__. This is when we "lift" a capability, from a mutable reference to `iso` or an immutable reference to `val`. The matrix equivalent would be walking upwards starting from the capability – quite literally lifting in this case.
* __Aliasing__. With a bit more of imagination, it's possible to picture aliasing `iso` and `trn` as reflecting them on the secondary diagonal of the matrix onto `tag` and `box`, respectively. The reason for that lies on which restrictions arise from the local guarantees. An `iso` doesn't allow different aliases to read or write, which `tag` enforces; and `trn` doesn't allow different aliases to write but allows them to do local reads, fitting `box`'s restrictions.

We want to emphasize that trying to apply the reference capability matrix to some capabilities problems is not guaranteed to work (viewpoint adaptation is one example). The matrix is the original definition of the reference capabilities, presented here as a mnemonic device. Whenever you struggle with reference capabilities, we recommend that you reread the corresponding section of this chapter to understand why something is not allowed by the compiler.
