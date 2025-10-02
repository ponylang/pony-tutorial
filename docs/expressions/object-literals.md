# Object Literals

Sometimes it's really convenient to be able to write a whole object inline. In Pony, this is called an object literal, and it does pretty much exactly what an object literal in JavaScript does: it creates an object that you can use immediately.

But Pony is statically typed, so an object literal also creates an anonymous type that the object literal fulfills. This is similar to anonymous classes in Java and C#. In Pony, an anonymous type can provide any number of traits and interfaces.

## What's this look like, then?

It basically looks like any other type definition, but with some small differences. Here's a simple one:

```pony
--8<-- "object-literals-object-literal.pony:4:6"
```

Ok, that's pretty trivial. Let's extend it so that it explicitly provides an interface so that the compiler will make sure the anonymous type fulfills that interface. You can use the same notation to provide traits as well.

```pony
--8<-- "object-literals-object-literal-with-interface.pony:6:9"
```

What we can't do is specify constructors in an object literal, because the literal _is_ the constructor. So how do we assign to fields? Well, we just assign to them. For example:

```pony
--8<-- "object-literals-fields-assignment.pony:1:9"
```

When we assign to a field in the constructor, we are _capturing_ from the lexical scope the object literal is in. Pretty fun stuff! It lets us have arbitrarily complex __closures__ that can even have multiple entry points (i.e. functions you can call on a closure).

An object literal with fields is returned as a `ref` by default unless an explicit reference capability is declared by specifying the capability after the `object` keyword. For example, an object with sendable captured references can be declared as `iso` if needed:

```pony
--8<-- "object-literals-reference-capability.pony:1:9"
```

We can also implicitly capture values from the lexical scope by using them in the object literal. Sometimes values that aren't local variables, aren't fields, and aren't parameters of a function are called _free variables_. By using them in a function, we are _closing over_ them - that is, capturing them. The code above could be written without the field `s`:

```pony
--8<-- "object-literals-closing-over-values.pony:1:8"
```

## Lambdas

Arbitrarily complex closures are nice, but sometimes we just want a simple closure. In Pony, you can use the lambdas for that. A lambda is written as a function (implicitly named `apply`) enclosed in curly brackets:

```pony
--8<-- "object-literals-lambda.pony:4:4"
```

This produces the same code as:

```pony
--8<-- "object-literals-lambda-as-explicit-object-literal.pony:4:6"
```

The reference capability of the lambda object can be declared by appending it after the closing curly bracket:

```pony
--8<-- "object-literals-lambda-with-reference-capability.pony:4:4"
```

This produces the same code as:

```pony
--8<-- "object-literals-lambda-with-reference-capability-as-explicit-object-literal.pony:4:6"
```

Lambdas can be used to capture from the lexical scope in the same way as object literals can assign from the lexical scope to a field. This is done by adding a second argument list after the parameters:

```pony
--8<-- "object-literals-lambda-capture-values.pony:5:10"
```

It's also possible to use a _capture list_ to create new names for things. A capture list is a second parenthesised list after the parameters:

```pony
--8<-- "object-literals-lambda-capture-and-rename-values.pony:6:7"
```

The type of a lambda is also declared using curly brackets. Within the brackets, the function parameter types are specified within parentheses followed by an optional colon and return type. The example above uses `{(String)}` to be the type of a lambda function that takes a `String` as an argument and returns nothing.

If the lambda object is not declared with a specific reference capability, the reference capability is inferred from the structure of the lambda. If the lambda does not have any captured references, it will be `val` by default; if it does have captured references, it will be `ref` by default. The following is an example of a `val` lambda object:

```pony
--8<-- "object-literals-lambda-reference-capabilities.pony"
```

The `reduce` method in this example requires the lambda type for the `f` parameter to require a reference capability of `val`. The lambda object passed in as an argument does not need to declare an explicit reference capability because `val` is the default for a lambda that does not capture anything.

As mentioned previously the lambda desugars to an object literal with an `apply` method. The reference capability for the `apply` method defaults to `box` like any other method. In a lambda that captures references, this needs to be `ref` if the function needs to modify any of the captured variables or call `ref` methods on them. The reference capability for the method (versus the reference capability for the object which was described above) is defined by putting the capability before the parenthesized argument list.

```pony
--8<-- "object-literals-lambda-reference-capabilities-2.pony"
```

This example declares the type of the apply function that is generated by the lambda expression as being `ref`. The lambda type declaration for the `f` parameter in the `for_each` method also declares it as `ref`. The reference capability of the lambda type must also be `ref` so that the method can be called. The lambda object does not need to declare an explicit reference capability because `ref` is the default for a lambda that has captures.

The above example also notes a subtle reality of captured references. At first glance one might expect `count` to have been incremented by the application of `f`. However, reassigning a reference, `count = count + 1`, inside a lambda or object literal can never cause a reassignment in the outer scope. If `count` were an object with reference capabilities permitting mutation, the captured reference could be modified with for example `count.increment()`. The resulting mutation would be visible to any location holding a reference to the same object as `count`.

## Actor literals

Normally, an object literal is an instance of an anonymous class. To make it an instance of an anonymous actor, just include one or more behaviours in the object literal definition.

```pony
--8<-- "object-literals-actor-literal.pony:4:6"
```

An actor literal is always returned as a `tag`.

## Primitive literals

When an anonymous type has no fields and no behaviours (like, for example, an object literal declared as a lambda literal), the compiler generates it as an anonymous primitive, unless a non-`val` reference capability is explicitly given. This means no memory allocation is needed to generate an instance of that type.

In other words, in Pony, a lambda that doesn't close over anything has no memory allocation overhead. Nice.

A primitive literal is always returned as a `val`.
