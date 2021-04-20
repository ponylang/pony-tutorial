# Sugar

Pony allows you to omit certain small details from your code and will put them back in for you. This is done to help make your code less cluttered and more readable. Using sugar is entirely optional, you can always write out the full version if you prefer.

## Apply

Many Pony classes have a function called `apply` which performs whatever action is most common for that type. Pony allows you to omit the word `apply` and just attempt to do a call directly on the object. So:

```pony
var foo = Foo.create()
foo()
```

becomes:

```pony
var foo = Foo.create()
foo.apply()
```

Any required arguments can be added just like normal method calls.

```pony
var foo = Foo.create()
foo(x, 37 where crash = false)
```

becomes:

```pony
var foo = Foo.create()
foo.apply(x, 37 where crash = false)
```

__Do I still need to provide the arguments to apply?__ Yes, only the `apply` will be added for you, the correct number and type of arguments must be supplied. Default and named arguments can be used as normal.

__How do I call a function foo if apply is added?__ The `apply` sugar is only added when calling an object, not when calling a method. The compiler can tell the difference and only adds the `apply` when appropriate.

## Create

To create an object you need to specify the type and call a constructor. Pony allows you to miss out the constructor and will insert a call to `create()` for you. So:

```pony
var foo = Foo
```

becomes:

```pony
var foo = Foo.create()
```

Normally types are not valid things to appear in expressions, so omitting the constructor call is not ambiguous. Remember that you can easily spot that a name is a type because it will start with a capital letter.

If arguments are needed for `create` these can be provided as if calling the type. Default and named arguments can be used as normal.

```pony
var foo = Foo(x, 37 where crash = false)
```

becomes:

```pony
var foo = Foo.create(x, 37 where crash = false)
```

__What if I want to use a constructor that isn't named create?__ Then the sugar can't help you and you have to write it out yourself.

__If the create I want to call takes no arguments can I still put in the parentheses?__ No. Calls of the form `Type()` use the combined create-apply sugar (see below). To get `Type.create()` just use `Type`.

## Combined create-apply

If a type has a create constructor that takes no arguments then the create and apply sugar can be used together. Just call on the type and calls to create and apply will be added. The call to create will take no arguments and the call to apply will take whatever arguments are supplied.

```pony
var foo = Foo()
var bar = Bar(x, 37 where crash = false)
```

becomes:

```pony
var foo = Foo.create().apply()
var bar = Bar.create().apply(x, 37 where crash = false)
```

__What if the create has default arguments? Do I get the combined create-apply sugar if I want to use the defaults?__ The combined create-apply sugar can only be used when the `create` constructor has no arguments. If there are default arguments then this sugar cannot be used.

## Update

The `update` sugar allows any class to use an assignment to accept data. Many languages allow this for assigning into collections, for example, a simple C array, `a[3] = x;`.

In any assignment where the left-hand side is a function call, Pony will translate this to a call to update, with the value from the right-hand side as an extra argument. So:

```pony
foo(37) = x
```

becomes:

```pony
foo.update(37 where value = x)
```

The value from the right-hand side of the assignment is always passed to a parameter named `value`. Any object can allow this syntax simply by providing an appropriate function `update` with an argument `value`.

__Does my update function have to have a single parameter that takes an integer?__ No, you can define update to take whatever parameters you like, as long as there is one called `value`. The following are all fine:

```pony
foo1(2, 3) = x
foo2() = x
foo3(37, "Hello", 3.5 where a = 2, b = 3) = x
```

__Does it matter where `value` appears in my parameter list?__ Whilst it doesn't strictly matter it is good practice to put `value` as the last parameter. That way all of the others can be specified by position.
