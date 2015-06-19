Sometimes it's really convenient to be able to write a whole object inline. In Pony, this is called an object literal, and it does pretty much exactly what an object literal in JavaScript does: it creates an object that you can use immediately.

But Pony is statically typed, so an object literal also creates an anonymous type that the object literal fulfills. This is similar to anonymous classes in Java and C#. In Pony, an anonymous type can provide any number of traits and interfaces.

# What's this look like, then?

It basically looks like any other type definition, but with some small differences. Here's a simple one:

```pony
object
  fun apply(): String => "hi"
end
```

Ok, that's pretty trivial. Let's extend it so that it explicitly provides an interface, so that the compiler will make sure the anonymous type fulfills that interface. You can use the same notation to provide traits as well.

```pony
object is Hashable
  fun apply(): String => "hi"
  fun hash(): U64 => this().hash()
end
```

What we can't do is specify constructors in an object literal, because literal _is_ the constructor. So how do we assign to fields? Well, we just assign to them. For example:

```pony
class Foo
  fun foo(str: String): Hashable =>
    object is Hashable
      let s: String = str
      fun apply(): String => s
      fun hash(): U64 => s.hash()
    end
```

When we assign to a field in the constructor, we are _capturing_ from the lexical scope the object literal is in. Pretty fun stuff! It lets us have arbitrarily complex __closures__ that can even have multiple entry points (i.e. functions you can call on a closure).

An object literal is always returned as a `ref`, like a default construtor on a class. To get another refrence capability (`iso`, `val`, etc.), you can wrap the object literal in a `recover` expression.

# Lambdas

Arbitrarily complex closures are nice, but sometimes we just want a simple closure. In Pony, you can use the `lambda` keyword for that.

```pony
lambda(s: String): String => "lambda: " + s end
```

This produces the same code as:

```pony
object
  fun apply(s: String): String => "lambda: " + s
end
```

# Actor literals

Normally, an object literal is an instance of an anonymous class. To make it an instance of an anonymous actor, just include one or more behaviours in the object literal definition.

```pony
object
  let stream: Stream = env.out
  be apply() => stream.print("hi")
end
```

An actor literal is always returned as a `tag`.

# Primitive literals

When an anonymous type has no fields and no behaviours (like, for example, an object literal declared with the `lambda` keyword), the compiler generates it as an anonymous primitive. This means no memory allocation is needed to generate an instance of that type.

In other words, a lambda in Pony has no memory allocation overhead. Nice.

A primitive literal is always returned as a `val`.
