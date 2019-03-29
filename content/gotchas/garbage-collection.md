---
title: "Garbage Collection"
section: "Gotchas"
menu:
  toc:
    parent: "gotchas"
    weight: 20
toc: true
---

There's a common GC anti-pattern that many new Pony programmers accidentally stumble across. Usually, this results in a skyrocketing memory usage in their test program and questions on Zulip as to why Pony isn't working correctly. It is, in fact, working correctly, albeit not obviously.

## Garbage Collection in the world at large

Garbage collection, in most languages, can run at any time. Your program can be paused so that memory can be freed up. This sucks if you want predictable completion of sections of code. Most of the time, your function will finish in less than a millisecond but every now and then, its paused during execution to GC. There are advantages to this approach. Whenever you run low on memory, the GC can attempt to free some memory and get you more. In general, this is how people expect Pony's garbage collector to work. As you might guess though, it doesn't work that way.

## Garbage Collection in Pony

Garbage collection is never attempted on any actor while it is executing a behavior. This gives you very predictable performance when executing behaviors but also makes it easy to grab way more memory than you intend to. Let's take a look at how that can happen via the "long-running behavior problem".

## Long running behaviors and memory

Here's a typical "I'm learning Pony" program:

```pony
actor Main
  new create(env: Env)
    for i in Range(1, 2_000_000) do
      ... something that uses up heap ... 
    end
```

This program will never garbage collect before exiting. `create` is run as a behavior on actors which means that no garbage collection will occur while it's running. Long loops in behaviors are a good way to exhaust memory. Don't do it. If you want to execute something in such a fashion, use a [Timer](https://stdlib.ponylang.io/time-Timer/).
