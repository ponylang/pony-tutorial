# Sugar

Pony allows you to omit certain small details from your code and will put them back in for you. This is done to help make your code less cluttered and more readable. Using sugar is entirely optional, you can always write out the full version if you prefer.

## Create

To create an object you need to specify the type and call a constructor. Pony allows you to miss out the constructor and will insert a call to `create()` for you. So:

```
var foo = Foo
```

becomes:

```
var foo = Foo.create()
```

Normally types are not valid things to appear in expressions, so omitting the constructor call is not ambiguous. Remember that you can easily spot that a name is a type because it will start with a capital letter.

__What if I want to use a constructor that takes arguments or isn't named create?__ Then the sugar can't help you and you have to write it out yourself.

## Apply

Many Pony classes have a function called `apply` which performs whatever action is most common for that type. Pony allows you to omit the word `apply` and just attempt to do a call directly on the object. So:

```
var foo = Foo
foo(37)
```

becomes:

```
var foo = Foo.create()
foo.apply(37)
```

__Do I still need to provide the arguments to apply?__ Yes, only the `apply` will be added for you, the correct number and type of arguments must be supplied as normal.

## Update

The `update` sugar allows any class to use an assignment to accept data. Many languages allow this for assigning into collections, for example a simple C array, `a[3] = x;`.

In any assignment where the left hand side is a function call, Pony will translate this to a call to update, with the value from the right hand side as an extra argument. So:

```
foo(37) = x
```

becomes:

```
foo.update(37 where value = x)
```

The value from the right hand side of the assignment is always passed to a parameter named `value`. Any object can allow this syntax simply by providing an appropriate function `update`.

__Does my update function have to have a single parameter that takes an integer?__ No, you can define update to take whatever parameters you like, as long as there is one called `value`. The following are all fine:

```
foo1(2, 3) = x
foo2() = x
foo3(37, "Hello", 3.5 where a = 2, b = 3) = x
```

__Does it matter where `value` appears in my parameter list?__ Whilst it doesn't strictly matter it is good practice to put `value` as the last parameter. That way all of the others can be specified by position (ie without having to use `where name =`).
