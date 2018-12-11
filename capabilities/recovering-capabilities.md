# Recovering Capabilities

A `recover` expression let's you "lift" the reference capability of the result. A mutable reference capability (`iso`, `trn`, or `ref`) can become _any_ reference capability, and an immutable reference capability (`val` or `box`) can become any immutable or opaque reference capability.

## Why is this useful?

This most straightforward use of `recover` is to get an `iso` that you can pass to another actor. But it can be used for many other things as well, such as:

* Creating a cyclic immutable data structure. That is, you can create a complex mutable data structure inside a `recover` expression, "lift" the resulting `ref` to a `val`.
* "Borrow" an `iso` as a `ref`, do a series of complex mutable operations on it, and return it as an `iso` again.
* "Extract" a mutable field from an `iso` and return it as an `iso`.

## What does this look like?

The `recover` expression wraps a list of expressions and is terminated by an `end`, like this:

```pony
recover Array[String].create() end
```

This expression returns an `Array[String] iso`, instead of the usual `Array[String] ref` you would get. The reason it is `iso` and not any of the other mutable reference capabilities is because there is a default reference capability when you don't specify one. The default for any mutable reference capability is `iso` and the default for any immutable reference capability is `val`.

Here's a more complicated example from the standard library:

```pony
recover
  var s = String((prec + 1).max(width.max(31)))
  var value = x

  try
    if value == 0 then
      s.push(table(0)?)
    else
      while value != 0 do
        let index = ((value = value / base) - (value * base))
        s.push(table(index.usize())?)
      end
    end
  end

  _extend_digits(s, prec')
  s.append(typestring)
  s.append(prestring)
  _pad(s, width, align, fill)
  s
end
```

That's from `format/_FormatInt`. It creates a `String ref`, does a bunch of stuff with it, and finally returns it as a `String iso`.

You can also give an explicit reference capability:

```pony
let key = recover val line.substring(0, i).>strip() end
```

That's from `net/http/_PayloadBuilder`. We get a substring of `line`, which is a `String iso^`, then we call strip on it, which returns itself. But since strip is a `ref` function, it returns itself as a `String ref^` - so we use a `recover val` to end up with a `String val`.

## How does this work?

Inside the `recover` expression, your code only has access to __sendable__ values from the enclosing lexical scope. In other words, you can only use `iso`, `val` and `tag` things from outside the `recover` expression.

This means that when the `recover` expression finishes, any aliases to the result of the expression other than `iso`, `val` and `tag` ones won't exist anymore. That makes it safe to "lift" the reference capability of the result of the expression.

If the `recover` expression could access __non-sendable__ values from the enclosing lexical scope, "lifting" the reference capability of the result wouldn't be safe. Some of those values could "leak" into an `iso` or `val` result, and result in data races.

## Automatic receiver recovery

When you have an `iso` or `trn` receiver, you normally can't call `ref` methods on it. That's because the receiver is also an argument to a method, which means both the method body and the caller have access to the receiver at the same time. And _that_ means we have to alias the receiver when we call a method on it. The alias of an `iso` is a `tag` (which isn't a subtype of `ref`) and the alias of a `trn` is a `box` (also not a subtype of `ref`).

But we can get around this! If all the arguments to the method (other than the receiver, which is the implicit argument being recovered) _at the call-site_ are __sendable__, and the return type of the method is either __sendable__ or isn't used _at the call-site_, then we can "automatically recover" the receiver. That just means we don't have to alias the receiver - and _that_ means we can call `ref` methods on an `iso` or `trn`, since `iso` and `trn` are both subtypes of `ref`.

Notice that this technique looks mostly at the call-site, rather than at the definition of the method being called. That makes it more flexible. For example, if the method being called wants a `ref` argument, and we pass it an `iso` argument, that's __sendable__ at the call-site, so we can still do automatic receiver recovery.

This may sound a little complicated, but in practice, it means you can write code that treats an `iso` mostly like a `ref`, and the compiler will complain when it's wrong. For example:

```pony
let s = recover String end
s.append("hi")
```

Here, we create a `String iso` and then append some text to it. The append method takes a `ref` receiver and a `box` parameter. We can automatically recover the `iso` receiver since we pass a `val` parameter, so everything is fine.
