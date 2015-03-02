Since types are guarantees, it's useful to talk about what guarantees a capability makes.

# What is denied

We're going to talk about capability guarantees in terms of what's _denied_. By this, we mean: what can other variables _not_ do when you have a variable with a certain capability?

When we talk about what's denied and we say _this_ actor, we mean the actor that can reach the variable that has the type we're interested in. When we say _other_ actors, we mean any other possible actor. When we say _all_ actors we mean both _this_ actor and _other_ actors.

# Mutable types

The __mutable__ types are `iso`, `trn` and `ref`.

* If an actor has an `iso` variable that points to an object, no other variable can be used by _any_ actor to read from or write to that object.
* If an actor has a `trn` variable that points to an object, no other variable can be used by _any_ actor to write to that object, and no other variable can be used by _other_ actors to read from or write to that object.
* If an actor has a `ref` variable that points to an object, no other variable can be used by _other_ actors to read from or write to that object.

These types are __mutable__ because they can be used to both read from and write to an object.

__Why can they be used to write?__ Because they all stop _other_ actors from reading from or writing to the object. Since we know no other actor will be reading, it's safe for us to write to the object, without having to worry about data-races. In other words, we know we won't be changing something while at the same time some other actor is trying to read coherent data from the object or, even worse, is trying to change the the object at the same time.

# Immutable types

The __immutable__ types are `val` and `box`.

* If an actor has a `val` variable that points to an object, no other variable can be used by _any_ actor to write to that object.
* If an actor has a `box` variable that points to an object, no other variable can be used by _other_ actors to write to that object.

These types are __immutable__ because they can be used to read from an object, but not to write to it.

__Why can they be used to read but not write?__ Because they only stop _other_ actors from writing to the object. That means they make no guarantee that _other_ actors aren't reading from the object. It's safe for more than one actor to read from an object at the same time though, so we're allowed to do that.

# Opaque types

There's only one __opaque__ type, which is `tag`. A `tag` variable makes no guarantees about other variables at all. As a result, it can't be used to either read from or write to the object.

It's still useful though: you can do identity comparison with it, you can call behaviours on it, and you can call functions on it that only need a `tag` receiver.

__Why can't they be used to read or write?__ Because they don't stop _other_ actors from writing to the object. That means if we tried to read, we would have no guarantee that there wasn't some other actor writing to the object, so we might get a race condition.__Why can't they be used to read or write?__ Because they don't stop _other_ actors from writing to the object. That means if we tried to read, we would have no guarantee that there wasn't some other actor writing to the object, so we might get a race condition.
