---
title: "Combining Capabilities"
section: "Reference Capabilities"
menu:
  toc:
    parent: "reference-capabilities"
    weight: 90
toc: true
---

When a field of an object is read, its reference capability depends both on the reference capability of the field and the reference capability of the __origin__, that is, the object the field is being read from.

This is because all the guarantees that the __origin__ reference capability makes have to be maintained for its fields as well.

# Viewpoint adaptation

The process of combining origin and field capabilities is called __viewpoint adaptation__. That is, the __origin__ has a __viewpoint__, and can "see" its fields only from that __viewpoint__.

Let's start with a table. This shows how __fields__ of each capability "look" to __origins__ of each capability.

---

| &#x25B7;        | iso field | trn field | ref field | val field | box field | tag field |
|-----------------|-----------|-----------|-----------|-----------|-----------|-----------|
| __iso origin__  | iso       | tag       | tag       | val       | tag       | tag       |
| __trn origin__  | iso       | box       | box       | val       | box       | tag       |
| __ref origin__  | iso       | trn       | ref       | val       | box       | tag       |
| __val origin__  | val       | val       | val       | val       | val       | tag       |
| __box origin__  | tag       | box       | box       | val       | box       | tag       |
| __tag origin__  | n/a       | n/a       | n/a       | n/a       | n/a       | n/a       |

---

For example, if you have a `trn` origin and you read a `ref` field, you get a `box` result:

```pony
class Foo
  var x: String ref

class Bar
  fun f() =>
    var y: Foo trn = get_foo_trn()
    var z: String box = y.x
```

## Explaining why

That table will seem totally natural to you, eventually. But probably not yet. To help it seem natural, let's walk through each cell in the table and explain why it is the way it is.

### Reading from an `iso` variable

Anything read through an `iso` origin has to maintain the isolation guarantee that the origin has. The key thing to remember is that the `iso` can be sent to another actor and it can also become any other reference capability. So when we read a field, we need to get a result that won't ever break the isolation guarantees that the origin makes, that is, _read and write uniqueness_.

An `iso` field makes the same guarantees as an `iso` origin, so that's fine to read. A `val` field is _globally immutable_, which means it's always ok to read it, no matter what the origin is (well, other than `tag`).

Everything else, though, can break our isolation guarantees. That's why other reference capabilities are seen as `tag`: it's the only type that is neither readable nor writable.

### Reading from a `trn` variable

This is like `iso`, but with a weaker guarantee (_write uniqueness_ as opposed to _read and write uniqueness_). That makes a big difference since now we can return something readable when we enforce our guarantees.

An `iso` field makes stronger guarantess than `trn`, and can't alias anything readable inside the `trn` origin, so it's perfectly safe to read.

On the other hand, `trn` and `ref` fields have to be returned as `box`. It might seem a bit odd that `trn` has to be returned as `box`, since after all it guarantees write uniqueness itself and we might expect it to behave like `iso`. The issue is that `trn`, unlike `iso`, *can* alias with some box variables in the origin. And that `trn` origin still has to make the guarantee that nothing else can write
to fields that it can read. On the other hand, `trn` still can't be returned as `val`, because then we might leave the original field
in place and create a `val` alias, while that field can still be used to write! So we have to view it as `box`.

Immutable and opaque capabilities, though, can never violate write uniqueness, so `val`, `box`, and `tag` are viewed as themselves.

### Reading from a `ref` variable

A `ref` origin doesn't modify its fields at all. This is because a `ref` origin doesn't make any guarantees that are incompatible with its fields.

### Reading from a `val` variable

A `val` origin is deeply and globally immutable, so all of its fields are also `val`. The only exception is a `tag` field. Since we can't read from it, we also can't guarantee that nobody can write to it, so it stays `tag`.

### Reading from a `box` variable

A `box` variable is locally immutable. This means it's possible that it may be mutated through some other variable (a `trn` or a `ref`), but it's also possible that our `box` variable is an alias of some `val` variable.

When we read a field, we need to return a reference capability that is compatible with the field but is also locally immutable.

An `iso` field is returned as a `tag` because no locally immutable reference capability can maintain its isolation guarantees. A `val` field is returned as a `val` because global immutability is a stronger guarantee than local immutability. A `box` field makes the same local immutability guarantee as its origin, so that's also fine.

For `trn` and `ref` we need to return a locally immutable reference capability that doesn't violate any guarantees the field makes. In both cases, we can return `box`.

### Reading from a `tag` variable

This one is easy: `tag` variables are opaque! They can't be read from.

## Writing to the field of an object

Like reading the field of an object, writing to a field depends on the reference capability of the object reference being stored and the reference capability of the origin object containing the field. The reference capability of the object being stored must not violate the guarantees made by the origin object's reference capability. For example, a val object reference can be stored in an iso origin. This is because the val reference capability guarantees that no alias to that object exists which could violate the guarantees that the iso capability makes.

Here's a simplified version of the table above that shows which reference capabilities can be stored in the field of an origin object.

---

| &#x25C1;       | iso object | trn object | ref object | val object | box object | tag object |
|----------------|------------|------------|------------|------------|------------|------------|
| __iso origin__ | &#x2714;   |            |            | &#x2714;   |            | &#x2714;   |
| __trn origin__ | &#x2714;   | &#x2714;   |            | &#x2714;   |            | &#x2714;   |
| __ref origin__ | &#x2714;   | &#x2714;   | &#x2714;   | &#x2714;   | &#x2714;   | &#x2714;   |
| __val origin__ |            |            |            |            |            |            |
| __box origin__ |            |            |            |            |            |            |
| __tag origin__ |            |            |            |            |            |            |

---

The bottom half of this chart is empty, since only origins with a mutable capability can have their fields modified.
