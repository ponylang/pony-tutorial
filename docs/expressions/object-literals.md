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

An object literal is always returned as a `ref`, like a default constructor on a class. To get another reference capability (`iso`, `val`, etc.), you can wrap the object literal in a `recover` expression.

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

The `lambda` keyword can be used to capture from lexical scope in the same way as object literals can assign from the lexical scope to a field. This is done by adding a second parameter list after the arguments:

```pony
class Foo
  new create(env:Env) =>
    foo(lambda(s: String)(env) => env.out.print(s) end)

  fun foo(f: {(String)}) =>
    f("Hello World")
```

The captured variables can be renamed if desired by assigning a new name in the capture parameter list:

```pony
  new create(env:Env) =>
    foo(lambda(s: String)(myenv=env) => myenv.out.print(s) end)
```

The type of a lambda is declared using curly brackets. Within the brackets the function parameter types are specified within parentheses followed by an optional colon and return type. The example above uses `{(String)}` to be the type of a lambda function that takes a `String` as an argument and returns nothing.

A lambda object is always returned as `val` if it does not close over any other variables. If it does capture values from the lexical scope then it is returned as a `ref`. The reference capability in the type declaration can be supplied by adding it before the closing curly bracket. If it is not provided it defaults to `ref`. The following is an example of a `val` lambda object:

```pony
actor Main
  new create(env:Env) =>
    let l = List[U32]
    l.push(10).push(20).push(30).push(40)
    let r = reduce(l, 0, lambda(a:U32,b:U32): U32 => a + b end)
    env.out.print("Result: " + r.string())

  fun reduce(l: List[U32], acc: U32, f: {(U32, U32): U32} val): U32 =>
    try
      let acc' = f(acc, l.shift())
      reduce(l, acc', f)
    else
      acc
    end
```

`reduce` in this example declares the lambda type to have reference capability `val`. It is required here as the default for the type declaration is `ref` and that would not match with the lambda object being used in the `reduce` call - that defaults to `val` as it isn't capturing anything from the lexical scope.

As mentioned previously the lambda desugars to an object literal with an `apply` method. The reference capability for the `apply` method defaults to `box` like any other method. In a lambda that captures this needs to be `ref` if the function needs to modify any of the captured variables or call `ref` methods on them. The reference capabiltity for the method (versus the reference capability for the object which was described above) is defined by putting the capability before the parenthesized argument list.

```pony
actor Main
  new create(env:Env) =>
    let l = List[String]
    l.push("hello").push("world")
    var count = U32(0)
    for_each(l, lambda ref(s:String)(env,count) =>
                    env.out.print(s)
                    count = count + 1
                end)
    // Displays '0' as the count
    env.out.print("Count: " + count.string())

  fun for_each(l: List[String], f: {ref(String)}) =>
    try
      f(l.shift())
      for_each(l, f)
    end
```

This example declares the type of the apply function that is generated by the lambda expression as being `ref`. The type declaration for it in the `for_each` method also declares it as `ref`. The lambda function captures some variables so the object that is generated is `ref` and the default for the type declaration is `ref` so everything type checks.

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
