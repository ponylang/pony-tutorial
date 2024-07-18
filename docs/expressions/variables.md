# Variables

Like most other programming languages Pony allows you to store data in variables. There are a few different kinds of variables which have different lifetimes and are used for slightly different purposes.

## Local variables

Local variables in Pony work very much as they do in other languages, allowing you to store temporary values while you perform calculations. Local variables live within a chunk of code (they are _local_ to that chunk) and are created every time that code chunk executes and disposed of when it completes.

To define a local variable the `var` keyword is used (`let` can also be used, but we'll get to that later). Right after the `var` comes the variable's name, and then you can (optionally) put a `:` followed by the variable's type. For example:

```pony
--8<-- "variables-local-variables.pony:1:1"
```

Here, we're assigning the __string literal__ `"Hello"` to `x`.

You don't have to give a value to the variable when you define it: you can assign one later if you prefer. If you try to read the value from a variable before you've assigned one, the compiler will complain instead of allowing the dreaded _uninitialised variable_ bug.

Every variable has a type, but you don't have to specify it in the declaration if you provide an initial value. The compiler will automatically use the type of the initial value of the variable.

The following definitions of `x`, `y` and `z` are all effectively identical.

```pony
--8<-- "variables-local-variables.pony"
```

__Can I miss out both the type and initial value for a variable?__ No. The compiler will complain that it can't figure out a type for that variable.

All local variable names start with a lowercase letter. If you want to you can end them with a _prime_ `'` (or more than one) which is useful when you need a second variable with almost the same meaning as the first. For example, you might have one variable called `time` and another called `time'`.

The chunk of code that a variable lives in is known as its __scope__. Exactly what its scope is depends on where it is defined. For example, the scope of a variable defined within the `then` expression of an `if` statement is that `then` expression. We haven't looked at `if` statements yet, but they're very similar to every other language.

```pony
--8<-- "variables-scope.pony:6:11"
```

Variables only exist from when they are defined until the end of the current scope. For our variable `x` this is the `end` at the end of the then expression: after that, it cannot be used.

## Var vs. let

Local variables are declared with either a `var` or a `let`. Using `var` means the variable can be assigned and reassigned as many times as you like. Using `let` means the variable can only be assigned once.

```pony
--8<-- "variables-var-vs-let.pony:3:6"
```

Using `let` instead of `var` also means the variable has to be assigned immediately.

```pony
--8<-- "variables-let-reassignment.pony:3:5"
```

Note that a variable having been declared with `let` only restricts reassignment, and does not influence the mutability of the object it references. This is the job of reference capabilities, explained later in this tutorial.

You never have to declare variables as `let`, but if you know you're never going to change what a variable references then using `let` is a good way to catch errors. It can also serve as a useful comment, indicating what is referenced is not meant to be changed.

## Fields

In Pony, fields are variables that live within objects. They work like fields in other object-oriented languages.

Fields have the same lifetime as the object they're in, rather than being scoped. They are set up by the object constructor and disposed of along with the object.

If the name of a field starts with `_`, it's __private__. That means only the type the field is in can have code that reads or writes that field. Otherwise, the field is __public__ and can be read or written from anywhere.

Just like local variables, fields can be `var` or `let`. Nevertheless, rules for field assignment differ a bit from variable assignment. No matter the type of the field (either `var` or `let`), either:

1. an initial value has to be assigned in their definition or
2. an initial value has to be assigned in the constructor method.

In the example below, the initial value of the two fields of the class `Wombat` is assigned at the definition level:

```pony
--8<-- "variables-fields-definition-assignment.pony:6:8"
```

Alternatively, these fields could be assigned in the constructor method:

```pony
--8<-- "variables-fields-constructor-assignment.pony:6:12"
```

If the assignment is not done at the definition level or in the constructor, an error is raised by the compiler. This is true for both `var` and `let` fields.

Please note that the assignment of a value to a field has to be explicit. The below example raises an error when compiled, even when the field is of `var` type:

```pony
--8<-- "variables-fields-implicit-assignment.pony"
```

We will see later in the Methods section that a class can have several constructors. For now, just remember that if the assignment of a field is not done at the definition level, it has to be done in each constructor of the class the field belongs to.

As for variables, using `var` means a field can be assigned and reassigned as many times as you like in the class. Using `let` means the field can only be assigned once.

```pony
--8<-- "variables-fields-let-reassignment.pony:5:17"
```

__Can field declarations appear after methods?__ No. If `var` or `let` keywords appear after a `fun` or `be` declaration, they will be treated as variables within the method body rather than fields within the type declaration. As a result, fields must appear prior to methods in the type declaration

## Embedded Fields

Unlike local variables, some types of fields can be declared using `embed`. Specifically, only classes or structs can be embedded - interfaces, traits, primitives and numeric types cannot. A field declared using `embed` is similar to one declared using `let`, but at the implementation level, the memory for the embedded class is laid out directly within the outer class. Contrast this with `let` or `var`, where the implementation uses pointers to reference the field class. Embedded fields can be passed to other functions in exactly the same way as `let` or `var` fields. Embedded fields must be initialised from a constructor expression.

__Why would I use `embed`?__ `embed` avoids a pointer indirection when accessing a field and a separate memory allocation when creating that field. By default, it is advised to use `embed` if possible. However, since an embedded field is allocated alongside its parent object, exterior references to the field forbids garbage collection of the parent, which can result in higher memory usage if a field outlives its parent. Use `let` if this is a concern for you.

## Global variables

Some programming languages have __global variables__ that can be accessed from anywhere in the code. What a bad idea! Pony doesn't have global variables at all.

## Shadowing

Some programming languages let you declare a variable with the same name as an existing variable, and then there are rules about which one you get. This is called _shadowing_, and it's a source of bugs. If you accidentally shadow a variable in Pony, the compiler will complain.

If you need a variable with _nearly_ the same name, you can use a prime `'`.
