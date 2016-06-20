# Consume and Destructive Read

An important part of Pony's capabilities are being able to say "I'm done with this thing." We'll cover two means of handling this situation: consuming a variable and destructive reads.

## Consuming a variable

Sometimes, you want to _move_ an object from one variable to another. In other words, you don't want to make a _new_ name for the object, exactly, you want to move the object from some existing name to a different one.

You can do this by using `consume`. When you `consume` a variable you take the value out of it, effectively leaving the variable empty. No code can read from that variable again until a new value is written to it. Consuming a local variable or a parameter allows you to make an alias with the same type, even if it's an `iso` or `trn`. For example:

```pony
fun test(a: Wombat iso) =>
  var b: Wombat iso = consume a // Allowed!
```

The compiler is happy with that, because by consuming `a`, you've said the value can't be used again and the compiler will complain if you try to.

```pony
fun test(a: Wombat iso) =>
  var b: Wombat iso = consume a // Allowed!
  var c: Wombat tag = a // Not allowed!
```

Here's an example of that. When you try to assign `a` to `c`, the compiler will complain.

__Can I `consume` a field?__ Definitely not! Consuming something means it is empty, that is, it has no value. There's no way to be sure no other alias to the object will access that field. If we tried to access a field that was empty, we would crash. But there's a way to do what you want to do: _destructive read_.

## Destructive read

There's another way to _move_ a value from one name to another. Earlier, we talked about how assignment in Pony returns the _old_ value of the left-hand side, rather than the new value. This is called _destructive read_, and we can use it to do what we want to do, even with fields.

```pony
class Aardvark
  var buddy: Wombat iso

  fun test(a: Wombat iso) =>
    var b: Wombat iso = buddy = consume a // Allowed!
```

Here, we consume `a`, assign it to the field `buddy`, and assign the _old_ value of `buddy` to `b`.

__Why is it ok to destructively read fields when we can't consume them?__ Because when we do a destructive read, we assign to the field so it always has a value. Unlike `consume`, there's no time when the field is empty. That means it's safe and the compiler doesn't complain.
