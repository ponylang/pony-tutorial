---
title: "Hello World: How It Works"
section: "Getting Started"
menu:
  toc:
    parent: "getting-started"
    weight: 15
toc: true
---
Let's look at our `helloworld` code again:

```pony
actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")
```

Let's go through that line by line.

## Line 1

```pony
actor Main
```

This is a __type declaration__. The keyword `actor` means we are going to define an actor, which is a bit like a class in Python, Java, C#, C++, etc. Pony has classes too, which we'll see later.

The difference between an actor and a class is that an actor can have __asynchronous__ methods, called __behaviours__. We'll talk more about that later.

A Pony program has to have a `Main` actor. It's kind of like the `main` function in C or C++, or the `main` method in Java, or the `Main` method in C#. It's where the action starts.

## Line 2

```pony
  new create(env: Env) =>
```

This is a __constructor__. The keyword `new` means it's a function that creates a new instance of the type. In this case, it creates a new __Main__.

Unlike other languages, constructors in Pony have names. That means there can be more than one way to construct an instance of a type. In this case, the name of the constructor is `create`.

The parameters of a function come next. In this case, our constructor has a single parameter called `env` that is of the type `Env`.

In Pony, the type of something always comes after its name and is separated by a colon. In C, C++, Java or C#, you might say `Env env`, but we do it the other way around (like Go, Pascal, Rust, TypeScript, and a bunch of other languages).

It turns out, our `Main` actor __has__ to have a constructor called `create` that takes a single parameter of type `Env`. That's how all programs start! So the beginning of your program is essentially the body of that constructor.

__Wait, what's the body?__ It's the code that comes after the `=>`.

## Line 3

```pony
    env.out.print("Hello, world!")
```

This is your program! What the heck is it doing?

In Pony, a dot is either a field access or a method call, much like other languages. If the name after the dot has parentheses after it, it's a method call. Otherwise, it's a field access.

So here, we start with a reference to `env`. We then look up the field `out` on our object `env`. As it happens, that field represents __stdout__, i.e. usually it means printing to your console. Then, we call the `print` method on `env.out`. The stuff inside the parentheses are the arguments to the function. In this case, we are passing a __string literal__, i.e. the stuff in double quotes.

In Pony, string literals can be in double quotes, `"`, in which case they follow C/C++ style escaping (using stuff like \n), or they can be triple-quoted, `"""` like in Python, in which case they are considered raw data.

__What's an Env, anyway?__ It's the "environment" your program was invoked with. That means it has command line arguments, environment variables, __stdin__, __stdout__, and __stderr__. Pony has no global variables, so these things are explicitly passed to your program.

## That's it!

Really, that's it. The program begins by creating a `Main` actor, and in the constructor, we print "Hello, world!" to __stdout__. Next, we'll start diving into the Pony type system.
