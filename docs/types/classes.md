Just like other object-oriented language, Pony has __classes__. A class is declared with the keyword `class`, and it has to have a name that starts with a capital letter, like this:

```pony
class Wombat
```

__Do all types start with a capital letter?__ Yes! And nothing else starts with a capital letter. So when you see a name in Pony code, you will instantly know whether it's a type or not.

# What goes in a class?

A class is composed of:

1. Fields.
2. Constructors.
3. Functions.

## Fields

These are just like fields in C structs or fields in classes in C++, C#, Java, Python, Ruby, or basically any language, really. There are two kinds of fields: var fields and let fields. A var field can be assigned to over and over again, but a let field is assigned to in the constructor and never again.

```pony
class Wombat
  let name: String
  var _hunger_level: U64
```

Here, a `Wombat` has a `name`, which is a `String`, and a `_hunger_level`, which is a `U64` (an unsigned 64 bit integer).

__What does the leading underscore mean?__ It means something is __private__. A __private__ field can only be accessed by code in the same type. A __private__ constructor, function, or behaviour can only be accessed by code in the same package. We'll talk more about packages later.

## Constructors

Pony constructors have names. Other than that, they are just like constructors in other languages. They can have parameters, and they always return a new instance of the type. Since they have names, you can have more than one constructor for a type.

Constructors are introduced with the __new__ keyword.

```pony
class Wombat
  let name: String
  var _hunger_level: U64

  new create(name': String) =>
    name = name'
    _hunger_level = 0

  new hungry(name': String, hunger: U64) =>
    name = name'
    _hunger_level = hunger
```

Here, we have two constructors, one that creates a `Wombat` that isn't hungry, and another that creates a `Wombat` that might be hungry or might not.

__What's with the single quote thing, i.e. name'?__ You can use single quotes in parameter and local variable names. In mathematics, it's called a _prime_, and it's used to say "another one of these, but not the same one". Basically, it's just convenient.

### Everything has to get set in a constructor

Every constructor has to set every field in an object. If it doesn't, the compiler will give you an error. Since there is no `null` in Pony, we can't do what Java, C# and many other languages do and just assign either `null` or zero to every field before the constructor runs, and since we don't want random crashes, we don't leave fields undefined (unlike C or C++).

### Field initialisers

Sometimes it's convenient to set a field the same way for all constructors.

```pony
class Wombat
  let name: String
  var _hunger_level: U64
  var _thirst_level: U64 = 1

  new create(name': String) =>
    name = name'
    _hunger_level = 0

  new hungry(name': String, hunger: U64) =>
    name = name'
    _hunger_level = hunger
```

Here, every `Wombat` begins a little bit thirsty, regardless of which constructor is called.

## Functions

Functions in Pony are like methods in Java, C#, C++, Ruby, Python, or pretty much any other object oriented language. They are introduced with the keyword `fun`. They can have parameters, like constructors do, and they can also have a result type (if no result type is given, it defaults to `None`).

```pony
class Wombat
  let name: String
  var _hunger_level: U64
  var _thirst_level: U64 = 1

  new create(name': String) =>
    name = name'
    _hunger_level = 0

  new hungry(name': String, hunger: U64) =>
    name = name'
    _hunger_level = hunger

  fun hunger(): U64 => _hunger_level

  fun ref set_hunger(to: U64 = 0): U64 => _hunger_level = to
```

The first function, `hunger`, is pretty straight forward. It has a result type of `U64`, and it returns `_hunger_level`, which is a `U64`. The only thing a bit different here is that no `return` keyword is used. This is because the result of a function is the result of the last expression in the function, in this case the value of `_hunger_level`.

__Is there a `return` keyword in Pony?__ Yes. It's used to return "early" from a function, i.e. to return something right away and not keep running until the last expression.

The second function, `set_hunger`, introduces a _bunch_ of new concepts all at once. Let's go through them one by one.

### The `ref` keyword right after `fun`

This is a __capability__. In this case, it means the _receiver_, i.e. the object on which the `set_hunger` function is being called, has to be a `ref` type. A `ref` type is a __reference type__, meaning that the object is __mutable__. We need this because we are writing a new value to the `_hunger_level` field.

__What's the receiver capability of the `hunger` method?__ The default receiver capability if none is specified is `box`, which means "I need to be able to read from this, but I won't write to it".

__What would happen if we left the `ref` keyword off the `set_hunger` method?__ The compiler would give you an error. It would see you were trying to modify a field and complain about it.

### The `= 0` after the parameter `to`

This is a __default argument__. It means that if you don't include that argument at the call site, you will get the default argument. In this case, `to` will be zero if you don't specify it.

### What does the function return?

It returns the _old_ value of `_hunger_level`.

__Wait, seriously? The _old_ value?__ Yes. In Pony, assignment is an expression rather than a statement. That means it has a result. This is true of a lot of languages, but they tend to return the _new_ value. In other words, given `a = b`, in most languages, the value of that is the value of `b`. But in Pony, the value of that is the _old_ value of `a`.

__...why?__ It's called a "destructive read", and it lets you do awesome things with a capabilities type system. We'll talk about that more later. For now, we'll just mention that you can also use it to implement a _swap_ operation. In most languages, to swap the values of `a` and `b` you need to do something like:

```pony
var temp = a
a = b
b = temp
```

In Pony, you can just do:

```pony
a = b = a
```

# What about inheritance?

In some object-oriented languages, a type can _inherit_ from another type, like how in Java something can __extend__ something else. Pony doesn't do that. Instead, Pony prefers _composition_ to _inheritence_. In other words, instead of getting code reuse by saying something __is__ something else, you get it by saying something __has__ something else.

On the other hand, Pony has a powerful __trait__ system (similar to Java 8 interfaces that can have default implementations) and a powerful __interface__ system (similar to Go interfaces, i.e. structurally typed).

We'll talk about all that stuff in detail later.
