# Function Call Side Effects

Consider the following code:

```pony
--8<-- "function-call-side-effects.pony"
```

What do you think it will print? Probably `0` right? Or maybe you realized this code is in the gotchas section so it must be `42`. If you went with `42`, you'd be right. Why?

Expressions for arguments in function calls are evaluated before the expression for the function receiver. The use of assignment expressions like `x = 42` is quite rare so we don't think many folks will be bitten by this. However, it's definitely something you want to be aware of. Also remember that if `fn` were to be called, it would be called with `0` (the result of the assignment expression).
