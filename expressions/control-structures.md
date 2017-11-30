# Control Structures

To do real work in a program you have to be able to make decisions, iterate through collections of items and perform actions repeatedly. For this, you need control structures. Pony has control structures that will be familiar to programmers who have used most languages, such as `if`, `while` and `for`, but in Pony, they work slightly differently.

## Conditionals

The simplest control structure is the good old `if`. It allows you to perform some action only when a condition is true. In Pony it looks like this:

```pony
if a > b then
  env.out.print("a is bigger")
end
```

__Can I use integers and pointers for the condition like I can in C?__ No. In Pony `if` conditions must have type Bool, i.e. they are always true or false. If you want to test whether a number `a` is not 0, then you need to explicitly say `a != 0`. This restriction removes a whole category of potential bugs from Pony programs.

If you want some alternative code for when the condition fails just add an `else`:

```pony
if a > b then
  env.out.print("a is bigger")
else
  env.out.print("a is not bigger")
end
```

Often you want to test more than one condition in one go, giving you more than two possible outcomes. You can nest `if` statements, but this quickly gets ugly:

```pony
if a == b then
  env.out.print("they are the same")
else
  if a > b then
    env.out.print("a is bigger")
  else
    env.out.print("b bigger")
  end
end
```

As an alternative Pony provides the `elseif` keyword that combines an `else` and an `if`. This works the same as saying `else if` in other languages and you can have as many `elseif`s as you like for each `if`.

```pony
if a == b then
  env.out.print("they are the same")
elseif a > b then
  env.out.print("a is bigger")
else
  env.out.print("b bigger")
end
```

__Why can't I just say "else if" like I do in C? Why the extra keyword?__ The relationship between `if` and `else` in C, and other similar languages, is ambiguous. For example:

```C
// C code
if(a)
  if(b)
    printf("a and b\n");
else
  printf("not a\n");
```
Here it is not obvious whether the `else` is an alternative to the first or the second `if`. In fact here the `else` relates to the `if(b)` so our example contains a bug. Pony avoids this type of bug by handling `if` and `else` differently and the need for `elseif` comes out of that.

## Everything is an expression

The big difference for control structures between Pony and other languages is that in Pony everything is an expression. In languages like C++ and Java `if` is a statement, not an expression. This means that you can't have an `if` inside an expression, there has to be a separate conditional operator '?'.

In Pony there are no statements there are only expressions, everything hands back a value. Your `if` statement hands you back a value. Your `for` loop (which we'll get to a bit later) hands you back a value.

This means you can use `if` directly in a calculation:

```pony
x = 1 + if lots then 100 else 2 end
```

This will give __x__ a value of either 3 or 101, depending on the variable __lots__.

If the `then` and `else` branches of an `if` produce different types then the `if` produces a __union__ of the two.

```pony
var x: (String | Bool) =
  if friendly then
    "Hello"
  else
    false
  end
```

__But what if my if doesn't have an else?__ Any `else` branch that doesn't exist gives an implicit `None`.

```pony
var x: (String | None) =
  if friendly then
    "Hello"
  end
```

The same rules that apply to the value of an `if` expression applies to loops as well. Let's take a look at what a loop value would look like:

```pony
actor Main
  new create(env: Env) =>
    var x: (String | None) = 
      for name in ["Bob"; "Fred"; "Sarah"].values() do
        name
      end
    match x
    | let s: String => env.out.print("x is " + s)
    | None => env.out.print("x is None")
    end
```

This will give __x__ the value "Sarah" as it is the last name in our list. If our loop has 0 iterations, then the value of it's `else` block will be the value of __x__. Or if there is no `else` block, the value will be `None`.

```pony
actor Main
  new create(env: Env) =>
    var x: (String | None) = 
      for name in Array[String].values() do
        name
      else
        "no names!"
      end
    match x
    | let s: String => env.out.print("x is " + s)
    | None => env.out.print("x is None")
    end
```

Here the value of __x__ is "no names!"

```pony
actor Main
  new create(env: Env) =>
    var x: (String | None) = 
      for name in Array[String].values() do
        name
      end
    match x
    | let s: String => env.out.print("x is " + s)
    | None => env.out.print("x is None")
    end
```

And lastly, here __x__ would be `None`.

## Loops

`if` allows you to choose what to do, but to do something more than once you want a loop.

### While

Pony `while` loops are very similar to those in other languages. A condition expression is evaluated and if it's true we execute the code inside the loop. When we're done we evaluate the condition again and keep going until it's false.

Here's an example that prints out the numbers 1 to 10:

```pony
var count: U32 = 1

while count <= 10 do
  env.out.print(count.string())
  count = count + 1
end
```

Just like `if` expressions `while` is also an expression. The value returned is just the value of the expression inside the loop the last time we go round it. For this example that will be the value given by `count = count + 1` when count is incremented to 11. Since Pony assignments hand back the _old_ value our `while` loop will return 10.

__But what if the condition evaluates to false the first time we try, then we don't go round the loop at all?__ In Pony `while` expressions can also have an `else` block. In general, Pony `else` blocks provide a value when the expression they are attached to doesn't. A `while` doesn't have a value to give if the condition evaluates to false the first time, so the `else` provides it instead.

__So is this like an else block on a while loop in Python?__ No, this is very different. In Python, the `else` is run when the `while` completes. In Pony the `else` is only run when the expression in the `while` isn't.

### Break

Sometimes you want to stop part-way through a loop and give up altogether. Pony has the `break` keyword for this and it is very similar to its counterpart in languages like C++, C#, and Python.

`break` immediately exits from the innermost loop it's in. Since the loop has to return a value `break` can take an expression. This is optional and if it's missed out the value from the `else` block is returned.

Let's have an example. Suppose you want to go through a list of names you're getting from somewhere, looking for either "Jack" or "Jill". If neither of those appear you'll just take the last name you're given and if you're not given any names at all you'll use "Herbert".

```pony
var name =
  while moreNames() do
    var name' = getName()
    if name' == "Jack" or name' == "Jill" then
      break name'
    end
    name'
  else
    "Herbert"
  end
```

So first we ask if there are any more names to get. If there are then we get a name and see if it's "Jack" or "Jill". If it is we're done and we break out of the loop, handing back the name we've found. If not we try again.

The line `name'` appears at the end of the loop so that will be our value returned from the last iteration if neither "Jack" nor "Jill" is found.

The `else` block provides our value of "Herbert" if there are no names available at all.

__Can I break out of multiple, nested loops like the Java labeled break?__ No, Pony does not support that. If you need to break out of multiple loops you should probably refactor your code or use a worker function.

### Continue

Sometimes you want to stop part-way through one loop iteration and move onto the next. Like other languages, Pony uses the `continue` keyword for this.

`continue` stops executing the current iteration of the innermost loop it's in and evaluates the condition ready for the next iteration.

If `continue` is executed during the last iteration of the loop then we have no value to return from the loop. In this case, we use the loop's `else` expression to get a value. As with the `if` expression if no `else` expression is provided `None` is returned.

__Can I continue an outer, nested loop like the Java labeled continue?__ No, Pony does not support that. If you need to continue an outer loop you should probably refactor your code.

### For

For iterating over a collection of items Pony uses the `for` keyword. This is very similar to `foreach` in C#, `for`..`in` in Python and `for` in Java when used with a collection. It is very different to `for` in C and C++.

The Pony `for` loop iterates over a collection of items using an iterator. On each iteration, round the loop, we ask the iterator if there are any more elements to process and if there are we ask it for the next one.

For example to print out all the strings in an array:

```pony
for name in ["Bob"; "Fred"; "Sarah"].values() do
  env.out.print(name)
end
```

Note the call to `values()` on the array, this is because the loop needs an iterator, not an array.

The iterator does not have to be of any particular type, but needs to provide the following methods:
```pony
  fun has_next(): Bool
  fun next(): T?
```

where T is the type of the objects in the collection. You don't need to worry about this unless you're writing your own iterators. To use existing collections, such as those provided in the standard library, you can just use `for` and it will all work. If you do write your own iterators note that we use structural typing, so your iterator doesn't need to declare that it provides any particular type.

You can think of the above example as being equivalent to:

```pony
let iterator = ["Bob"; "Fred"; "Sarah"].values()
while iterator.has_next() do
  let name = iterator.next()?
  env.out.print(name)
end
```

Note that the variable __name__ is declared _let_, you cannot assign to the control variable within the loop.

__Can I use break and continue with for loops?__ Yes, `for` loops can have `else` expressions attached and can use `break` and `continue` just as for `while`.

### Repeat

The final loop construct that Pony provides is `repeat` `until`. Here we evaluate the expression in the loop and then evaluate a condition expression to see if we're done or we should go round again.

This is similar to `do` `while` in C++, C# and Java except that the termination condition is reversed, i.e. those languages terminate the loop when the condition expression is false, Pony terminates the loop when the condition expression is true.

The differences between `while` and `repeat` in Pony are:

1. We always go around the loop at least once with `repeat`, whereas with `while` we may not go round at all.
1. The termination condition is reversed.

Suppose we're trying to create something and we want to keep trying until it's good enough:

```pony
actor Main
  new create(env: Env) =>
    var counter = U64(1)
    repeat
      env.out.print("hello!")
      counter = counter + 1
    until counter > 7 end
```

Just like `while` loops the value given by a `repeat` loop is the value of the expression within the loop on the last iteration and `break` and `continue` can be used.

__Since you always go round a repeat loop at least once do you ever need to give it an else expression?__ Yes, you may need to. A `continue` in the last iteration of a `repeat` loop needs to get a value from somewhere and an `else` expression is used for that.
