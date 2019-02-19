---
title: "Overview"
section: "Reference Capabilities"
layout: overview
menu:
  toc:
    identifier: "reference-capabilities-overview"
    parent: "reference-capabilities"
    weight: 1
---

We've covered the basics of Pony's type system and then expressions, this chapter about reference capabilities will cover another feature of Pony's type system. There aren't currently any mainstream programming languages that feature refernce capabilities. What is a reference capability?

Well, a reference capability is built on the idea of "a capability".
A capability is the ability to do "something". Usually that "something" involves an external resource that you might want access to; like the filesystem or the network. This usage of capability is called an object capability and is discussed [in the next chapter](/object-capabilities.html).

Pony also features a different kind of capability, called a "reference capability". Where object capabilities are about being granted the ability to do things with objects, reference capabilities are about denying you the ability to do things with memory references. For example, "you can have access to this memory BUT ONLY for reading it. You can not write to it". That's a reference capability and it's denying you access to do things.

Reference capabilities are core to what makes Pony special. You might remember in the introduction to this tutorial we said that Pony is:

* It's type safe. Really type safe. There's a mathematical [proof](http://www.ponylang.org/media/papers/opsla237-clebsch.pdf) and everything.
* It's memory safe. Ok, this comes with type safe, but it's still interesting. There are no dangling pointers, no buffer overruns, heck, the language doesn't even have the concept of _null_!
* It's exception safe. There are no runtime exceptions. All exceptions have defined semantics, and they are _always_ handled.
* It's data-race-free. Pony doesn't have locks or atomic operations or anything like that. Instead, the type system ensures _at compile time_ that your concurrent program can never have data races. So you can write highly concurrent code and never get it wrong.
* It's deadlock free. This one is easy because Pony has no locks at all! So they definitely don't deadlock, because they don't exist.

Reference capabilities are what make all that awesome possible.

Code examples in this chapter might be kind of sparse, because we're largely dealing with higher-level concepts. Try to read through the chapter at least once before starting to put the ideas into practice. By the time you finish this chapter, you should start to have a handle on what reference capabilities are and how you can use them. Don't worry if you struggle with them at first. For most people, it's a new way of thinking about your code and takes a while to grasp. If you get stuck trying to get your capabilities right, definitely reach out for help. Once you've used them for a couple weeks, problems with capabilities start to melt away, but before that can be a real struggle. Don't worry, we all went that struggle. In fact, there's a section of the Pony website dedicated to resources that can help in [learning reference capabilities](https://www.ponylang.io/learn/#reference-capabilities). And by all means, reach out to the Pony community for help. We are here to help you get over the reference capabilities learning curve. It's not easy. We know that. It's a new way of thinking for folks, so do [please reach out](https://www.ponylang.io/get-slack-invite). We're waiting to hear from you.

Scared? Don't be. Ready? Good. Let's get started.
