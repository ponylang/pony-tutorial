---
title: "Overview"
section: "Capabilities"
layout: overview
menu:
  toc:
    identifier: "capabilities-overview"
    parent: "capabilities"
    weight: 1
---

We've covered the basics of Pony's type system and then expressions, this chapter about capabilities will cover another feature of Pony's type system. There aren't currently any mainstream programming languages that feature capabilities. What is a capability?

A capability is the ability to do "something". Usually that "something" involves an external resource that you might want access to; like the filesystem or the network. This is called an object capability. Object capabilities have appeared in a number of programming languages including [E](https://en.wikipedia.org/wiki/E_%28programming_language%29).

In addition to object capabilities, Pony also features another kind of capability, called a "reference capability". Where object capabilities are about being granted the ability to do things with objects, reference capabilities are about denying you the ability to do things with memory references. For example, "you can have access to this memory BUT ONLY for reading it. You can not write to it". That's a reference capability and it's denying you access to do things.

Capabilities are core to what makes Pony special. You might remember in the introduction to this tutorial we said that Pony is:

* It's type safe. Really type safe. There's a mathematical [proof](http://www.ponylang.org/media/papers/opsla237-clebsch.pdf) and everything.
* It's memory safe. Ok, this comes with type safe, but it's still interesting. There are no dangling pointers, no buffer overruns, heck, the language doesn't even have the concept of _null_!
* It's exception safe. There are no runtime exceptions. All exceptions have defined semantics, and they are _always_ handled.
* It's data-race-free. Pony doesn't have locks or atomic operations or anything like that. Instead, the type system ensures _at compile time_ that your concurrent program can never have data races. So you can write highly concurrent code and never get it wrong.
* It's deadlock free. This one is easy because Pony has no locks at all! So they definitely don't deadlock, because they don't exist.

Object and reference capabilities are what make all that awesome possible.

By the time you finish this chapter, you should start to have a handle on what capabilities are and how you can use them. Don't worry if you struggle with them at first. For most people, it's a new way of thinking about your code and takes a while to grasp. If you get stuck trying to get your capabilities right, definitely reach out for help. Once you've used them for a couple weeks, problems with capabilities start to melt away, but before that can be a real struggle. Don't worry, we all go through that struggle and the Pony community is waiting to help. Find us on IRC at #ponylang on Freenode or on the [mailing list](https://groups.io/g/pony+user).

Scared? Don't be. Ready? Good. Let's get started with object capabilities.
