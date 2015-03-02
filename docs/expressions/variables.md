Like most other programming language Pony allows you to store data in variables. There are a few different kinds of variables which have different lifetimes and are used for slightly different purposes.

# Local variables

Local variables in Pony work very much as they do in other languages, allowing you to store temporary values while you perform calculations. Local variables live within a chunk of code (they are _local_ to that chunk) and are created every time that code chunk executes and disposed of when it completes.

To define a local variable the `var` keyword is used (`let` can also be used, but we'll get to that later). Right after the `var` comes the variable's name, and then you can (optionally) put a `:` followed by the variable's type. For example:

```
var x: String = "Hello"
```

Here, we're assigning the __string literal__ `"Hello"` to `x`.

You don't have to give a value to the variable when you define it: you can assign one later if you prefer. If you try to read the value from a variable before you've assigned one, the compiler will complain instead of allowing the dreaded _uninitialised variable_ bug.

Every variable has a type, but you don't have to specify it in the declaration if you provide an initial value. The compiler will automatically use the type of the initial value for the variable.

The following definitions of `x`, `y` and `z` are all effectively identical.

```
var x: String = "Hello"

var y = "Hello"

var z: String
z = "Hello"
```

__Can I miss out both the type and initial value for a variable?__ No. The compiler will complain that it can't figure out a type for that variable.

All local variable names start with a lower case letter. If you want to you can end them with a _prime_ `'` (or more than one) which is useful when you need a second variable with almost the same meaning as the first. For example you might have one variable called `time` and another called `time'`.

The chunk of code that a variable lives in is known as its __scope__. Exactly what its scope is depends on where it is defined. For example, the scope of a variable defined within the `then` expression of an `if` statement is that `then` expression. We haven't looked at `if` statements yet, but they're very similar to every other language.

```
if a > b then
  var x = "a is bigger"
  env.out.print(x)  // OK
end

env.out.print(x)  // Illegal
```

Variables only exists from when they are defined until the end of the current scope. For our variable `x` this is the `end` at the end of the then expression: after that it cannot be used.

# Var vs. let

Local variables are declared with either a `var` or a `let`. Using `var` means the variable can be assigned and reassigned as many times as you like. Using `let` means the variable can only be assigned once.

```
var x: U32 = 3
let y: U32 = 4
x = 5  // OK
y = 6  // Error, y is let
```

You never have to declare variables as `let`, but if you know you're never going to change a variable then using `let` is a good way to catch errors. It can also serve as a useful comment, indicating the value is not meant to be changed.

# Fields

In Pony, fields are variables that live within objects. They work like fields in other object-oriented langauges.

Fields have the same lifetime as the object they're in, rather than being scoped. They are set up by the object constructor and disposed of along with the object.

If the name of a field starts with `_`, it's __private__. That means only the type the field is in can have code that reads or writes that field. Otherwise, the field is __public__, and can be read or written anywhere.

Just like local variables, fields can be `var` or `let`. They can also have initial value assigned in their definition, just like local variables, or they can be given their initial value in a constructor.

# Globals

Some programming languages have __global variables__ that can be accessed from anywhere in the code. What a bad idea! Pony doesn't have global variables at all.

# Shadowing

Some programming languages let you declare a variable with the same name as an existing variable, and then there are rules about which one you get. This is called _shadowing_, and it's a source of bugs. If you accidentally shadow a variable in Pony, the compiler will complain.

If you need a variable with _nearly_ the same name, you can use a prime `'`.
