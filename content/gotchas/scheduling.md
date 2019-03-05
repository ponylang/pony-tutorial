---
title: "Scheduling"
section: "Gotchas"
menu:
  toc:
    parent: "gotchas"
    weight: 30
toc: true
---

The Pony scheduler is not preemptive. This means that your actor has to yield control of the scheduler thread in order for another actor to execute. The normal way to do this is for your behavior to end. If your behavior doesn't end, you will continue to monopolize a scheduler thread and bad things will happen.

## FFI and monopolizing the scheduler

An easy way to monopolize a scheduler thread is to use the FFI facilities of Pony to kick off code that doesn't return for an extended period of time. You do not want to do this. Do not call FFI code that doesn't return in a reasonable amount of time.

## Long running behaviors

Another way to monopolize a scheduler thread is to write a behavior that never exits or takes a really long time to exit.

```pony
be bad_citizen() =>
  while true do
    _env.out.print("Never gonna give you up. Really gonna make you cry")
  end
```

That is some seriously bad citizen code that will hog a scheduler thread forever. Call that behavior a few times and your program will grind to a halt. If you find yourself writing code with loops that will run for a long time, stop and rethink your design. Take a look at the [Timer](https://stdlib.ponylang.io/time-Timer/) class from the standard library. Combine that together with a counter in your class and you can execute the same behavior repeatedly while yielding your scheduler thread to other actors.
