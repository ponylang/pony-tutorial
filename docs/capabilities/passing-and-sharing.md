Capabilities make it safe to both __pass__ mutable data between actors and to __share__ immutable data amongst actors. Not only that, they make it safe to do it with no copying, no locks, in fact no runtime overhead at all.

# Passing

For an object to be mutable, we need to be sure that no _other_ actor can read from or write to that object. The three mutable capabilities (`iso`, `trn`, and `ref`) all make that guarantee.

But what if we want to pass a mutable object from one actor to another? To do that, we need to be sure that the actor that is _sending_ the mutable object also _gives up_ the ability to both read from and write to that object.

This is exactly what `iso` does. It is _read and write unique_, so if you send an `iso` object to another actor, you will be giving up the ability to read from or write to that object.

__So I should use `iso` when I want to pass a mutable object between actors?__ Yes! If you don't need to pass it, you can just use `ref` instead.

# Sharing

If you want to __share__ an object amongst actors, then we have to make one of the following guarantees:

1. Either _no_ actor can write to the object, in which case _any_ actor can read from it, or
2. Only _one_ actor can write to the object, in which case _other_ actors can neither read from or write to the object.

The first guarantee is exactly what `val` does. It is _globally immutable_, so we know that _no_ actor can ever write to that object. As a result, you can freely send `val` objects to other actors, without needing to give up the ability to read from that object.

__So I should use `val` when I want to share an immutable object amongst actors?__ Yes! If you don't need to share it, you can just use `ref` instead.

The second guarantee is what `tag` does. Not the part about only one actor writing (that's guaranteed by any mutable capability), but the part about not being able to read from or write to an object. That means you can freely pass `tag` objects to other actors, without needing to give up the ability to read from or write to that object.

__So I should use `tag` when I want to share the identity of a mutable object amongst actors?__ Yes! Or, really, the identity of anything, whether it's mutable, immutable, or even an actor.

# Capabilities that can't be sent

You may have noticed we didn't mention `trn`, `ref`, or `box` as things you can send to other actors. That's because you can't do it. They don't make the guarantees we need in order to be safe.

So when should you use those capabilities?

* Use `ref` when you need to be able to change an object over time. On the other hand, if your program wouldn't be any slower if you used an immutable type instead, you may want to use a `val` anyway.
* Use `box` when you don't care whether the object is mutable or immutable. In other words, you want to be able to read from it, but you don't need to write to it or share it with other actors.
* Use `trn` when you want to be able to change an object for a while, but you also want to be able to make it _globally immutable_ later.
