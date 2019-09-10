---
title: "A Short Guide to Pony Error Messages"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 90
toc: true
---

You've been through the tutorial, you've watched some videos, and now you're ready to write some Pony code. You fire up your editor, shovel coal into the compiler, and... you find yourself looking at a string of gibberish.

Don't panic! Pony's error messages try to be as helpful as possible and the ultimate goal is to improve them further. But, in the meantime, they can be a little intimidating.

This section tries to provide a short bestiary of Pony's error messages, along with a guide to understanding them.

Let's start with a simple one.

## left side must be something that can be assigned to

Suppose you wrote:

```pony
actor Main
  let x: I64 = 0
  new create(env: Env) =>
    x = 12
```

The error message would be:

```
Error:
.../a.pony:6:5: can't assign to a let or embed definition more than once
    x = 12
    ^
Error:
.../a.pony:6:7: left side must be something that can be assigned to
    x = 12
      ^
```

What happened is that you declared `x` as a constant, by writing `let x`, and then tried to assign a new value to it, 12. To fix the error, replace `let` with `var` or reconsider what value you want `x` to have.

That one error resulted in two error messages. The first, pointing to the `x`, describes the specific problem, that `x` was defined with `let`. The second, pointing to the `=` describes a more general error, that whatever is on the left side of the assignment is not something that can be assigned to. You would get that same error message if you attempted to assign a value to a literal, like `3`.

## cannot write to a field in a box function

Suppose you create a class with a mutable field and added a method to change the field:

```pony
class Wombat
  var color: String = "brown"
  fun dye(new_color: String) =>
    color = new_color
```

The error message would be:

```
Error:
.../a.pony:4:11: cannot write to a field in a box function. If you are trying to change state in a function use fun ref
    color = new_color
          ^
```

To understand this error message, you have to have some background. The field `color` is mutable since it is declared with `var`, but the method `dye` does not have an explicit receiver reference capability. The default receiver reference capability is `box`, which allows `dye` to be called on any mutable or immutable `Wombat`; the `box` reference capability says that the method may read from but not write to the receiver. As a result, it is illegal to attempt to modify the receiver in the method.

To fix the error, you would need to give the `dye` method a mutable reference capability, such as `ref`: `fun ref dye(new_color: String) => ...`.

## receiver type is not a subtype of target type

Suppose you made a related, but slightly different error:

```pony
class Rainbow
  let colors: Array[String] = Array[String]
  fun add_stripe(color: String) =>
    colors.push(color)
```

In this example, rather than trying to change the value of a field, the code calls a method which attempts to modify the object referred to by the field.

The problem is very similar to that of the last section, but the error message is significantly more complicated:

```
Error:
../a.pony:4:16: receiver type is not a subtype of target type
    colors.push(color)
               ^
    Info:
    .../a.pony:4:5: receiver type: this->Array[String val] ref
        colors.push(color)
        ^
    .../ponyc/packages/builtin/array.pony:252:3: target type: Array[String val] ref
      fun ref push(value: A): Array[A]^ =>
      ^
    .../a.pony:2:15: Array[String val] box is not a subtype of Array[String val] ref: box is not a subtype of ref
      let colors: Array[String] = Array[String]()
                  ^
```

Once again, Pony is trying to be helpful. The first few lines describe the error, in general terms that only a programming language maven would like: an incompatibility between the receiver type and the target type. However, Pony provides more information: the lines immediately after "Info:" tell you what it believes the receiver type to be and the next few lines describe what it believes the target type to be. Finally, the last few lines describe in detail what the problem is.

Unfortunately, this message does not locate the error as clearly as the previous examples.

Breaking it down, the issue seems to be with the call to `push`, with the receiver `colors`. The receiver type is `this->Array[String val] ref`; in other words, the view that this method has of a field whose type is `Array[String val] ref`. In the class `Rainbow`, the field `colors` is indeed declared with the type `Array[String]`, and the default reference capability for `String`s is `val` while the default reference capability for `Array` is `ref`. 

The "target type" in this example is the type declaration for the method `push` of the class `Array`, with its type variable `A` replaced by `String` (again, with a default reference capability of `val`). The reference capability for the overall array, as required by the receiver reference capability of `push`, is `ref`. It seems that the receiver type and the target type should be pretty close.

But take another look at the final lines: what Pony thinks is the actual receiver type, `Array[String val] box`, is significantly different from what it thinks is the actual target type, `Array[String val] ref`. And a type with a reference capability of `box`, which is immutable, is indeed not a subtype of a type with a reference capability of `ref`, which *is* mutable.

The issue must lie with the one difference between the receiver type and the target type, which is the prefix "this->". The type `this->Array[String val] ref` is a viewpoint adapted type, or arrow type, that describes the `Array[String val] ref` "as seen by the receiver". The receiver, in this case, has the receiver reference capability of the method `add_stripe`, which is the default `box`. *That* is why the final type is `Array[String val] box`.

The fundamental error in this example is the same as the last: the default receiver reference capability for a method is `box`, which is immutable. This method, however, is attempting to modify the receiver, by adding another color stripe. That is not legal at all.

As an aside, while trying to figure out what is happening, you may have been misled by the declaration of the `colors` field, `let colors...`. That declaration makes the `colors` binding constant. As a result, you cannot assign a new array to the field. On the other hand, the array itself can be mutable or immutable. In this example, it is mutable, allowing `push` to be called on the `colors` field in the `add_stripe` method.

## A note on compiler versions

The error messages shown in this section are from ponyc 0.2.1-1063-g6ae110f [release], the current head of the master branch at the time this is written. The messages from other versions of the compiler may be different, to a greater or lesser degree.
