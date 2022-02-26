# Errors

Pony doesn't feature exceptions as you might be familiar with them from languages like Python, Java, C++ et al. It does, however, provide a simple partial function mechanism to aid in error handling. Partial functions and the `error` keyword used to raise them look similar to exceptions in other languages but have some important semantic differences. Let's take a look at how you work with Pony's error and then how it differs from the exceptions you might be used to.

## Raising and handling errors

An error is raised with the command `error`. At any point, the code may decide to declare an `error` has occurred. Code execution halts at that point, and the call chain is unwound until the nearest enclosing error handler is found. This is all checked at compile time so errors cannot cause the whole program to crash.

Error handlers are declared using the `try`-`else` syntax.

```pony
try
  callA()
  if not callB() then error end
  callC()
else
  callD()
end
```

In the above code `callA()` will always be executed and so will `callB()`. If the result of `callB()` is true then we will proceed to `callC()` in the normal fashion and `callD()` will not then be executed.

However, if `callB()` returns false, then an error will be raised. At this point, execution will stop and the nearest enclosing error handler will be found and executed. In this example that is, our else block and so `callD()` will be executed.

In either case, execution will then carry on with whatever code comes after the `try end`.

__Do I have to provide an error handler?__ No. The `try` block will handle any errors regardless. If you don't provide an error handler then no error handling action will be taken - execution will simply continue after the `try` expression.

If you want to do something that might raise an error, but you don't care if it does you can just put in it a `try` block without an `else`.

```pony
try
  // Do something that may raise an error
end
```

__Is there anything my error handler has to do?__ No. If you provide an error handler then it must contain some code, but it is entirely up to you what it does.

__What's the resulting value of a try block?__ The result of a `try` block is the value of the last statement in the `try` block, or the value of the last statement in the `else` clause if an error was raised. If an error was raised and there was no `else` clause provided, the result value will be `None`.

## Partial functions

Pony does not require that all errors are handled immediately as in our previous examples. Instead, functions can raise errors that are handled by whatever code calls them. These are called partial functions (this is a mathematical term meaning a function that does not have a defined result for all possible inputs, i.e. arguments). Partial functions __must__ be marked as such in Pony with a `?`, both in the function signature (after the return type) and at the call site (after the closing parentheses).

For example, a somewhat contrived version of the factorial function that accepts a signed integer will error if given a negative input. It's only partially defined over its valid input type.

```pony
fun factorial(x: I32): I32 ? =>
  if x < 0 then error end
  if x == 0 then
    1
  else
    x * factorial(x - 1)?
  end
```

Everywhere that an error can be generated in Pony (an error command, a call to a partial function, or certain built-in language constructs) must appear within a `try` block or a function that is marked as partial. This is checked at compile time, ensuring that an error cannot escape handling and crash the program.

Prior to Pony 0.16.0, call sites of partial functions were not required to be marked with a `?`. This often led to confusion about the possibilities for control flow when reading code. Having every partial function call site clearly marked makes it very easy for the reader to immediately understand everywhere that a block of code may jump away to the nearest error handler, making the possible control flow paths more obvious and explicit.

## Partial constructors and behaviours

Class constructors may also be marked as partial. If a class constructor raises an error then the construction is considered to have failed and the object under construction is discarded without ever being returned to the caller.

When an actor constructor is called the actor is created and a reference to it is returned immediately. However, the constructor code is executed asynchronously at some later time. If an actor constructor were to raise an error it would already be too late to report this to the caller. For this reason, constructors for actors may not be partial.

Behaviours are also executed asynchronously and so cannot be partial for the same reason.

## Try-then blocks

In addition to an `else` error handler, a `try` command can have a `then` block. This is executed after the rest of the `try`, whether or not an error is raised or handled. Expanding our example from earlier:

```pony
try
  callA()
  if not callB() then error end
  callC()
else
  callD()
then
  callE()
end
```

The `callE()` will always be executed. If `callB()` returns true then the sequence executed is `callA()`, `callB()`, `callC()`, `callE()`. If `callB()` returns false then the sequence executed is `callA()`, `callB()`, `callD()`, `callE()`.

__Do I have to have an else error handler to have a then block?__ No. You can have a `try`-`then` block without an `else` if you like.

__Will my then block really always be executed, even if I return inside the try?__ Yes, your `then` expression will __always__ be executed when the `try` block is complete. The only way it won't be is if the `try` never completes (due to an infinite loop), the machine is powered off, or the process is killed (and then, maybe).

## With blocks

A `with` expression can be used to ensure disposal of an object when it is no longer needed. A common case is a database connection which needs to be closed after use to avoid resource leaks on the server. For example:

```pony
with obj = SomeObjectThatNeedsDisposing() do
  // use obj
end
```

`obj.dispose()` will be called whether the code inside the `with` block completes successfully or raises an error. To take part in a `with` expression, the object that needs resource clean-up must, therefore, provide a `dispose()` method:

```pony
class SomeObjectThatNeedsDisposing
  // constructor, other functions

  fun dispose() =>
    // release resources
```

Multiple objects can be set up for disposal:

```pony
with obj = SomeObjectThatNeedsDisposing(), other = SomeOtherDisposableObject() do
  // use obj
end
```

The value of a `with` expression is the value of the last expression in the block.

## Language constructs that can raise errors

The only language construct that can raise an error, other than the `error` command or calling a partial method, is the `as` command. This converts the given value to the specified type if it can be. If it can't then an error is raised. This means that the `as` command can only be used inside a try block or a partial method.

## Comparison to exceptions in other languages

Pony errors behave very much the same as those in C++, Java, C#, Python, and Ruby. The key difference is that Pony errors do not have a type or instance associated with them. This makes them the same as C++ exceptions would be if a fixed literal was always thrown, e.g. `throw 3;`. This difference simplifies error handling for the programmer and allows for much better runtime error handling performance.

The `else` handler in a `try` expression is just like a `catch(...)` in C++, `catch(Exception e)` in Java or C#, `except:` in Python, or `rescue` in Ruby. Since exceptions do not have types there is no need for handlers to specify types or to have multiple handlers in a single try block.

The `then` block in a `try` expression is just like a `finally` in Java, C#, or Python and `ensure` in Ruby.

If required, error handlers can "reraise" by using the `error` command within the handler.
