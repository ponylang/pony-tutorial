# Methods

All Pony code that actually does something, rather than defining types etc, appears in named blocks which are referred to as methods. There are three kinds of methods: functions, constructors, and behaviours. All methods are attached to type definitions (e.g. classes) - there are no global functions.

Behaviours are used for handling asynchronous messages sent to actors, which we've seen in the "Types" chapter [when we talked about actors](/types/actors.md#behaviours).

__Can I have some code outside of any methods like I do in Python?__ No. All Pony code must be within a method.

## Functions

Pony functions are quite like functions (or methods) in other languages. They can have 0 or more parameters and 0 or 1 return values. If the return type is omitted then the function will have a return value of `None`.

```pony
--8<-- "methods-functions.pony"
```

The function parameters (if any) are specified in parentheses after the function name. Functions that don't take any parameters still need to have the parentheses.

Each parameter is given a name and a type. In our example function `add` has 2 parameters, `x` and `y`, both of which are type `U32`. The values passed to a function call (the `1` and `2` in our example) are called arguments and when the call is made they are evaluated and assigned to the parameters. Parameters may not be assigned to within the function - they are effectively declared `let`.

After the parameters comes the return type. If nothing will be returned this is simply omitted.

After the return value, there's a `=>` and then finally the function body. The value returned is simply the value of the function body (remember that everything is an expression), which is simply the value of the last command in the function.

If you want to exit a function early then use the `return` command. If the function has a return type then you need to provide a value to return. If the function does not have a return type then `return` should appear on its own, without a value.

__Can I overload functions by argument type?__ No, you cannot have multiple methods with the same name in the same type.

## Constructors

Pony constructors are used to initialise newly created objects, as in many languages. However, unlike many languages, Pony constructors are named so you can have as many as you like, taking whatever parameters you like. By convention, the main constructor of each type (if there is such a thing for any given type) is called `create`.

```pony
--8<-- "methods-constructors.pony"
```

The purpose of a constructor is to set up the internal state of the object being created. To ensure this is done constructors must initialise all the fields in the object being constructed.

__Can I exit a constructor early?__ Yes. Just then use the `return` command without a value. The object must already be in a legal state to do this.

## Calling

As in many other languages, methods in Pony are called by providing the arguments within parentheses after the method name. The parentheses are required even if there are no arguments being passed to the method.

```pony
--8<-- "methods-functions-calling.pony"
```

Constructors are usually called "on" a type, by specifying the type that is to be created. To do this just specify the type, followed by a dot, followed by the name of the constructor you want to call.

```pony
--8<-- "methods-constructors-calling.pony"
```

Functions are always called on an object. Again just specify the object, followed by a dot, followed by the name of the function to call. If the object to call on is omitted then the current object is used (i.e. `this`).

```pony
--8<-- "methods-functions-calling-implicit-this.pony"
```

Constructors can also be called on an expression. Here an object is created of the same type as the specified expression - this is equivalent to directly specifying the type.

```pony
--8<-- "methods-constructors-calling-on-expression.pony"
```

We can even reuse the variable name in the assignment expression to call the constructor.

```pony
--8<-- "methods-constructors-calling-reuse-variable-name.pony"
```

Here we specify that `var a` is type `Foo`, then proceed to use `a` to call the constructor, `create()`, for objects of type `Foo`.

## Default arguments

When defining a method you can provide default values for any of the arguments. The caller then has the choice to use the values you have provided or to provide their own. Default argument values are specified with a `=` after the parameter name.

```pony
--8<-- "methods-default-arguments.pony"
```

__Do I have to provide default values for all of my arguments?__ No, you can provide defaults for as many, or as few, as you like.

## Named arguments

So far, when calling methods we have always given all the arguments in order. This is known as using __positional__ arguments. However, we can also specify the arguments in any order by specifying their names. This is known as using __named__ arguments.

To call a method using named arguments the `where` keyword is used, followed by the named arguments and their values.

```pony
--8<-- "methods-named-arguments.pony"
```

Note how in `b` above, the arguments were given out of order by using `where` followed using the name of the arguments.

__Should I specify `where` for each named argument?__ No. There must be only one `where` in a method call.

Named and positional arguments can be used together in a single call. Just start with the positional arguments you want to specify, then a `where` and finally the named arguments. But be careful, each argument must be specified only once.

Default arguments can also be used in combination with positional and named arguments - just miss out any for which you want to use the default.

```pony
--8<-- "methods-named-and-positional-arguments-combined.pony"
```

__Can I call using positional arguments but miss out the first one?__ No. If you use positional arguments they must be the first ones in the call.

## Chaining

Method chaining allows you to chain calls on an object without requiring the method to return its receiver. The syntax to call a method and chain the receiver is `object.>method()`, which is roughly equivalent to `(object.method() ; object)`. Chaining a method discards its normal return value.

```pony
--8<-- "methods-chaining.pony"
```

Note that the last `.>` in a chain can be a `.` if the return value of the last call matters.

```pony
--8<-- "methods-chaining-return-value.pony"
```

## Anonymous methods

Pony has anonymous methods (or Lambdas). They look like this:

```pony
--8<-- "methods-anonymous-methods.pony"
```

They are presented more in-depth in the [Object Literals section](/expressions/object-literals.md).

## Privacy

In Pony, method names start either with a lower case letter or with an underscore followed by a lowercase letter. Methods with a leading underscore are private. This means they can only be called by code within the same package. Methods without a leading underscore are public and can be called by anyone.

__Can I start my method name with 2 (or more) underscores?__ No. If the first character is an underscore then the second one MUST be a lower case letter.

## Precedence

We have talked about [precedence of operators](/expressions/ops.md#precedence) before, and in Pony, method calls and field accesses have higher precedence than any operators.

To sum up, in complex expressions,

1. Method calls and field accesses have higher precedence than any operators.
2. Unary operator have higher precedence than infix operators.
3. When mixing infix operators in complex expressions, we must use parentheses to specify any precedence explicitly.
