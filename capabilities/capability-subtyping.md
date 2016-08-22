# Capability Subtyping

Subtyping is about _substitutability_. That is, if we need to supply a certain type, what other types can we substitute instead? Reference capabilities factor into this.

## Simple substitution

First, let's cover substitution without worrying about ephemeral types (`^`) or alias types (`!`). The `<:` symbol means "is a subtype of" or alternatively "can be substituted for".

* `iso <: trn`. An `iso` is _read and write unique_, and a `trn` is just _write unique_, so it's safe to substitute an `iso` for a `trn`.
* `trn <: ref`. A `trn` is mutable and also _write unique_. A `ref` is mutable, but makes no uniqueness guarantees. It's safe to substitute a `trn` for a `ref`.
* `trn <: val`. This one is interesting. A `trn` is _write unique_ and a `val` is _globally immutable_, so why is it safe to substitute a `trn` for a `val`? The key is that, in order to do so, you have to _give up_ the `trn` you have. If you give up the _only_ variable that can write to an object, you know that no variable can write to it. That means it's safe to consider it _globally immutable_.
* `ref <: box`. A `ref` guarantees no _other_ actor can read from or write to the object. A `box` just guarantees no _other_ actor can write to the object, so it's safe to substitute a `ref` for a `box`.
* `val <: box`. A `val` guarantees _no_ actor, not even this one, can write to the object. A `box` just guarantees no _other_ actor can write to the object, so it's safe to substitute a `val` for a `box`.
* `box <: tag`. A `box` guarantees no other actor can write to the object, and a `tag` makes no guarantees at all, so it's safe to substitute a `box` for a `tag`.

Subtyping is _transitive_. That means that since `iso <: trn` and `trn <: ref` and `ref <: box`, we also get `iso <: box`.

## Aliased substitution

Now let's consider what happens when we have an alias of a reference capability. For example, if we have some `iso` and we alias it (without doing a `consume` or a destructive read), the type we get is `iso!`, not `iso`.

* `iso! <: tag`. This is a pretty big change. Instead of being a subtype of everything like `iso`, the only thing an `iso!` is a subtype of is `tag`. This is because the `iso` still exists, and is still _read and write unique_. Any alias can neither read from nor write to the object. That means an `iso!` can only be a subtype of `tag`.
* `trn! <: box`. This is a change too, but not as big a change. Since `trn` is only _write unique_, it's ok for aliases to read from the object, but it's not ok for aliases to write to the object. That means we could have `box` or `val` aliases - except `val` guarantees that _no_ alias can write the the object! Since our `trn` still exists, and can write to the object, a `val` alias would break the guarantees that `val` makes. So a `trn!` can only be a subtype of `box` (and, transitively, `tag` as well).
* `ref! <: ref`. Since a `ref` only guarantees that _other_ actors can neither read from nor write to the object, it's ok to make more `ref` aliases within the same actor.
* `val! <: val`. Since a `val` only guarantees that _no_ actor can write to the object, its ok to make more `val` aliases, since they can't write to the object either.
* `box! <: box`. A `box` only guarantees that _other_ actors can't write to the object. Both `val` and `ref` make that guarantee too, so why can `box` only alias as `box`? It's because we can't make _more_ guarantees when we alias something. That means `box` can only alias as `box`.
* `tag! <: tag`. A `tag` doesn't make any guarantees at all. Just like with a `box`, we can't make more guarantees when we make a new alias, so a `tag` can only alias as a `tag`.

## Ephemeral substitution

The last case to consider is when we have an ephemeral reference capability. For example, if we have some `iso` and we `consume` it or do a destructive read, the type we get is `iso^`, not `iso`.

* `iso^ <: iso`. This is pretty simple. When we give an `iso^` a name, by assigning it to something or passing it as an argument to a method, it loses the `^` and becomes a plain old `iso`. We know we gave up our previous `iso`, so it's safe to have a new one.
* `trn^ <: trn`. This works exactly like `iso^`. The guarantee is weaker (_write uniqueness_ instead of _read and write uniqueness_), but it works the same way.
* `ref^ <: ref^` and `ref^ <: ref` and `ref <: ref^`. Here, we have another case. Not only is a `ref^` a subtype of a `ref`, it's also a subtype of a `ref^`. What's going on here? The reason is that an ephemeral reference capability is a way of saying "a reference capability that, when aliased, results in the base reference capability". Since a `ref` can be aliased as a `ref`, that means `ref` and `ref^` are completely interchangeable.
* `val^`, `box^`, `tag^`. These all work the same way as `ref`, that is, they are interchangeable with the base reference capability. It's for the same reason: all of these reference capabilities can be aliased as themselves.

__Why do `ref^`, `val^`, `box^`, and `tag^` exist if they are interchangeable with their base reference capabilities?__ It's for two reasons: __reference capability recovery__ and __generics__. We'll cover both of those later.
