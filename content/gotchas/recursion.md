---
title: "Recursion"
section: "Gotchas"
menu:
  toc:
    parent: "gotchas"
    weight: 50
toc: true
---

Recursive functions in Pony can cause many problems. Every function call in a program adds a frame on the system call stack, which is bounded. If the stack grows too big it will overflow, usually crashing the program. This is an out-of-memory type of error and it cannot be prevented by the guarantees offered by Pony.

If you have a heavy recursive algorithm, you must take some precautions in your code to avoid stack overflows. Most recursive functions can be easily transformed into tail-recursive function which are less problematic. A tail-recursive function is a function in which the recursive call is the last instruction of the function. Here is an example with a factorial function:

```pony
fun recursive_factorial(x: U32): U32 =>
  if x == 0 then
    1
  else
    x * recursive_factorial(x - 1)
  end

fun tail_recursive_factorial(x: U32, y: U32): U32 =>
  if x == 0 then
    y
  else
    tail_recursive_factorial(x - 1, x * y)
  end
```

The compiler can optimise a tail-recursive function to a loop, completely avoiding call stack growth. Note that this is an _optimisation_ which is only performed in release builds (i.e. builds without the `-d` flag passed to ponyc.) If you need to avoid stack growth in debug builds as well then you have to write your function as a loop manually.

If the tail-recursive version of your algorithm isn't practical to implement, there are other ways to control stack growth depending on your algorithm. For example, you can implement your algorithm using an explicit stack data structure instead of implicitly using the call stack to store data.

Note that light recursion usually doesn't cause problems. Unless your amount of recursive calls is in the hundreds, you're unlikely to encounter this problem.
