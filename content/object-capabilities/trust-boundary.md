---
title: "Trust Boundary"
section: "Object Capabilities"
menu:
  toc:
    parent: "object-capabilities"
    weight: 20
toc: true
---

We mentioned previously that the C FFI can be used to break pretty much every guarantee that Pony makes. This is because, once you've called into C, you are executing arbitrary machine code that can stomp memory addresses, write to anything, and generally be pretty badly behaved.

## Trust boundaries

When we talk about trust, we don't mean things you trust because you think they are perfect. Instead, we mean things you _have_ to trust in order to get things done, even though you know they are _imperfect_.

In Pony, when you use the C FFI, you are basically declaring that you trust the C code that's being executed. That's fine, because you may need it to get work done. But what about trusting someone else's code to use the C FFI? You may need to, but you definitely want to know that it's happening.

## Safe packages

The normal way to handle that is to be sure you're using just the code you need to use in your program. Pretty simple! Don't use some random package from the internet without looking at the code and making sure it doesn't do nasty FFI stuff.

But we can do better than that.

In Pony, you can optionally declare a set of _safe_ packages on the `ponyc` command line, like this:

```sh
ponyc --safe=files:net:net/ssl my_project
```

Here, we are declaring that only the `files`, `net` and `net/ssl` packages are allowed to use C FFI calls. We've established our trust boundary: any other packages that try to use C FFI calls will result in a compile-time error.
