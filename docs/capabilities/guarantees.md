Since types are guarantees, it's useful to talk about what guarantees a capability makes.

# What is denied

We're going to talk about capability guarantees in terms of what's _denied_. By this, we mean: what can other variables _not_ do when you have a variable with a certain capability?

When we talk about what's denied and we say _this_ actor, we mean the actor that can reach the variable that has the type we're interested in. When we say _other_ actors, we mean any other possible actor. When we say _all_ actors we mean both _this_ actor and _other_ actors.

# Mutable capabilities

The __mutable__ capabilities are `iso`, `trn` and `ref`. These capabilities are __mutable__ because they can be used to both read from and write to an object.

* If an actor has an `iso` variable, no other variable can be used by _any_ actor to read from or write to that object. This means an `iso` variable is the only variable anywhere in the program that can read from or write to that object. It is _read and write unique_.
* If an actor has a `trn` variable, no other variable can be used by _any_ actor to write to that object, and no other variable can be used by _other_ actors to read from or write to that object. This means a `trn` variable is the only variable anywhere in the program that can write to that object, but other variables held by the the same actor may be able to read from it. Is is _write unique_.
* If an actor has a `ref` variable, no other variable can be used by _other_ actors to read from or write to that object. This means that other variables can be used to read from and write to the object, but only from within the same actor.

__Why can they be used to write?__ Because they all stop _other_ actors from reading from or writing to the object. Since we know no other actor will be reading, it's safe for us to write to the object, without having to worry about data-races. And since we know no other actor will be writing, it's safe for us to read from the object, too.

# Immutable capabilities

The __immutable__ capabilities are `val` and `box`. These capabilities are __immutable__ because they can be used to read from an object, but not to write to it.

* If an actor has a `val` variable, no other variable can be used by _any_ actor to write to that object. This means that the object can't _ever_ change. It is _globally immutable_.
* If an actor has a `box` variable, no other variable can be used by _other_ actors to write to that object. This means that other actors may be able to read the object and other variables in this actor may be able to write to it (although not both). In either case it is safe for us to read. The object is _locally immutable_.

__Why can they be used to read but not write?__ Because these capabilities only stop _other_ actors from writing to the object. That means there is no guarantee that _other_ actors aren't reading from the object, which means it's not safe for us to write to it. It's safe for more than one actor to read from an object at the same time though, so we're allowed to do that.

# Opaque capabilities

There's only one __opaque__ capability, which is `tag`. A `tag` variable makes no guarantees about other variables at all. As a result, it can't be used to either read from or write to the object.

It's still useful though: you can do identity comparison with it, you can call behaviours on it, and you can call functions on it that only need a `tag` receiver.

__Why can't `tag` be used to read or write?__ Because `tag` doesn't stop _other_ actors from writing to the object. That means if we tried to read, we would have no guarantee that there wasn't some other actor writing to the object, so we might get a race condition.
