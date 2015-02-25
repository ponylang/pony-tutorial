An __actor__ is similar to a __class__, but there is one critical difference: an actor can have __behaviours__.

# Behaviours

A __behaviour__ is like a __function__, but instead of being introduced with the keyword `fun`, it is introduced with the keyword `be`.

Like a function, a behaviour can have parameters. Unlike a function, it doesn't have a receiver capability (a behaviour can be called on a receiver of any capability) and you can't specify a return type.

```
actor Aardvark
  let name: String
  var _hunger_level: U64 = 0

  new create(name': String) =>
    name = name'

  be eat(amount: U64) =>
    _hunger_level = (_hunger_level - amount).min(0)
```

Here we have an `Aardvark` that can eat asynchronously. Clever Aardvark.

# Asynchronocity

The difference between functions and behaviours is that functions are _synchronous_ and behaviours are _asynchronous_. In other words, when you call a function, the body of the function is executed immediately, and the result of the call is the result of the body of the function. This is just like method invocation in any other object-oriented language.

But when you call a behaviour, the body is __not__ immediately executed. Instead, the body of the behaviour will execute at some indeterminate time in the future.

__So what does a behaviour return?__ All behaviours always return the receiver. They can't return something they calculate (since they haven't run yet), so returning the receiver is a convenience to allow chaining calls on the receiver.

# Parallelism

Since behaviours are asynchronous, it's ok to run the body of a bunch of behaviours at the same time. This is exactly what Pony does. The Pony runtime has its own scheduler, which by default has a number of threads equal to the number of CPU cores on your machine. Each scheduler thread can be executing an actor behaviour at any given time, so Pony programs are naturally parallel.

# Sequentiality

Actors themselves, however, are sequential. That is, each actor will only execute one behaviour at a time. This means all the code in an actor can be written without caring about concurrency: no need for locks or semaphores or anything like that.

When you're writing Pony code, it's nice to think of actors not as a unit of parallelism, but as a unit of sequentiality. That is, an actor should do only what _has_ to be done sequentially. Anything else can be broken out into another actor, making it automatically parallel.

# Why is this safe?

Because of Pony's __capabilities secure type system__. We've mentioned capabilities briefly before, when talking about function receiver capabilities. The short version is that they are annotations on a type that make all this parallelism safe without any runtime overhead.

We will cover capabilities in depth later.

# Actors are cheap

If you've done concurrent programming before, you'll know that threads can be expensive. Context switches can cause problems, each thread needs a stack (which can be a lot of memory), and you need lots of locks and other mechanisms to write thread-safe code.

But actors are cheap. Really cheap. They extra cost of an actor as opposed to an object is about 256 bytes of memory. Bytes, not kilobytes! And there are no locks and no context switches. An actor that isn't executing consumes no resources other than the few extra bytes of memory.

It's pretty normal to write a Pony program that uses hundreds of thousands of actors.
