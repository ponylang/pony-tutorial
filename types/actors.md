# Actors

An __actor__ is similar to a __class__, but with one critical difference: an actor can have __behaviours__.

## Behaviours

A __behaviour__ is like a __function__, except that functions are _synchronous_ and behaviours are _asynchronous_. In other words, when you call a function, the body of the function is executed immediately, and the result of the call is the result of the body of the function. This is just like method invocation in any other object-oriented language.

But when you call a behaviour, the body is __not__ executed immediately. Instead, the body of the behaviour will execute at some indeterminate time in the future.

A behaviour looks like a function, but instead of being introduced with the keyword `fun`, it is introduced with the keyword `be`.

Like a function, a behaviour can have parameters. Unlike a function, it doesn't have a receiver capability (a behaviour can be called on a receiver of any capability) and you can't specify a return type.

__So what does a behaviour return?__ Behaviours always return `None`, like a function without explicit result type, because they can't return something they calculate (since they haven't run yet).

```pony
actor Aardvark
  let name: String
  var _hunger_level: U64 = 0

  new create(name': String) =>
    name = name'

  be eat(amount: U64) =>
    _hunger_level = _hunger_level - amount.min(_hunger_level)
```

Here we have an `Aardvark` that can eat asynchronously. Clever Aardvark.

## Concurrent

Since behaviours are asynchronous, The runtime might execute a bunch of behaviours at the same time. This is exactly what Pony does. The Pony runtime has its own scheduler, which by default has a number of threads equal to the number of CPU cores on your machine. Each scheduler thread can be executing an actor behaviour at any given time, so Pony programs are naturally concurrent.

for example, the following code:

```
actor A
  var name:String
  var env:Env
  new create(env':Env,name':String) =>
    name = name'
    env = env'

  be first() =>
    env.out.print(name+" first")
  be second() =>
    env.out.print(name+" second")
 
actor Main

  new create(env:Env) =>
     let a = A.create(env,"a")
     let b = A.create(env,"b")
     a.first()
     a.second()
     b.first()
     b.second()

```
might have the following resul:

```
b first
a first
b second
a second
```

## Sequential

Actors themselves, however, are sequential. That is, each actor will only execute one behaviour at a time. This means all the code in an actor can be written without caring about concurrency: no need for locks or semaphores or anything like that.

When you're writing Pony code, it's nice to think of actors not as a unit of parallelism, but as a unit of sequentiality. That is, the methods (function, behavior, constructor and finaliser) are exectuted in the order they are called. Anything else can be broken out into another actor, making it automatically parallel.

Taking the same example than before, the following result is garantee not to happen

```
b second // IMPOSSIBLE: b.first() is called before b.second()
a first
b first
a second
```

From an implentation point of view, the pony runtime has a queue which keep the calls already done and still not executed by an actor.

## Why is this safe?

Because of Pony's __capabilities secure type system__. We've mentioned reference capabilities briefly before when talking about function receiver reference capabilities. The short version is that they are annotations on a type that make all this parallelism safe without any runtime overhead.

We will cover reference capabilities in depth later.

## Actors are cheap

If you've done concurrent programming before, you'll know that threads can be expensive. Context switches can cause problems, each thread needs a stack (which can be a lot of memory), and you need lots of locks and other mechanisms to write thread-safe code.

But actors are cheap. Really cheap. The extra cost of an actor, as opposed to an object, is about 256 bytes of memory. Bytes, not kilobytes! And there are no locks and no context switches. An actor that isn't executing consumes no resources other than the few extra bytes of memory.

It's pretty normal to write a Pony program that uses hundreds of thousands of actors.

## Actor finalisers

Like classes, actors can have finalisers. The finaliser definition is the same (`fun _final()`). All guarantees and restrictions for a class finaliser are also valid for an actor finaliser. In addition, an actor will not receive any further message after its finaliser is called.
