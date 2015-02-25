Like most other programming language Pony allows you to store data in variables. There are a few different kinds of variables which have different life times andare used for slightly different purposes.

# Local variables

Local variables in Pony work very much as they do in other languages, allowing you to store temporary values whilst you perform calculations. Local variables live within a chunk of code (they are _local_ to that chunk), they are created every time that code chunk executes and disposed of when it completes. If the code chunk is run multiple times simultaneously each execution instance gets its own version of the variables.

To define a local variable the `var` keyword is used. (`let` can also be used, but we'll get to that later.) The variable must be given a name, must have a type and can be given an initial value. For example:

```
var x:String = "Hello"
```

You don't have to give a value to the variable when you define it, you can assign one later if you prefer. However you can't read the value from a variable until you have assigned one, there are no "default" values in Pony as there are in many other languages.

Every variable has a type, but you don't have to specify it in the declaration if you provide an initial value. The compiler will automatically use the type of the initial value for the variable. The `:` after the variable name tells the compiler you're explicitly specifying the type.

The following definitions of x, y and z are all effectively identical.

```
var x:String = "Hello"

var y = "Hello"

var z:String
z = "Hello"
```

__Can I miss out both the type and initial value for a variable? Can't the compiler work out what I mean later?__ No. You __must__ provide either the type or an initial value (or both) for every local variable.

All local variable names start with a lower case letter. If you want to you can end them with a tick `'` (or more than one) which is useful when you need a second variable with almost the same meaning as the first. For example you might have one variable called `time` and another called `time'`.

The chunk of code that a variable lives in is known as its __scope__. Exactly what its scope is depends on where it is defined. For example the scope of a variable defined within the `then` expression of an `if` statement is that `then` expression. (We haven't looked at `if` statements yet, but they're very similar to every other language.)

```
if a > b then
  var x = "a is bigger"
  env.out.print(x)  // OK
end

env.out.print(x)  // Illegal
```

Variables only exists from when they are defined until the end of the current scope. For our variable `x` this is the `end` at the end of the then expression, after that it cannot be used.

# Var vs Let

Local variables are declared with either a `var` or a `let`. `var` means the variable can be written to as many times as you like. `let` means the variable can only be written to once, effectively it is read-only.

```
var x: U32 = 3
let y: U32 = 4
x = 5  // OK
y = 6  // Error, y is let
```

It is never __required__ to declare variables as `let`, but if you know you're never going to change a variable using `let` is a good way to catch errors. It can also serve as the comment, indicating the value is not meant to be changed.

# Fields

In Pony fields are variables that live within objects. There are similar to fields in other object-oriented langauges.

Fields have the same lifetime as the containing object, they are setup by the object constructor and disposed of along with the object. The scope of a field is all the containing type, i.e. all the code in the containing type can use a field.

Just like local variables fields can be var or let. They can also have initial value assigned in their definition, just like local variables, or they can be given their initial value in the type constructor.

# Globals

Some programming languages have global variables that can be accessed from anywhere in the code. Pony does not have this, all variables live within types or methods.

# Masking (NO!)

TODO
