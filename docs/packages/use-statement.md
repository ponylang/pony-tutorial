# Use Statement

To use a package in your code you need to have a __use__ command. This tells the compiler to find the package you need and make the types defined in it available to you. Every Pony file that needs to know about a type from a package must have a use command for it.

Use commands are a similar concept to Python and Java "import", C/C++ "#include" and C# "using" commands, but not exactly the same. They come at the beginning of Pony files and look like this:

```pony
--8<-- "use-statement-collections.pony"
```

This will find all of the publicly visible types defined in the _collections_ package and add them to the type namespace of the file containing the `use` command. These types are then available to use within that file, just as if they were defined locally.

For example, the standard library contains the package _time_. This contains the following definition (among others):

```pony
--8<-- "use-statement-time.pony"
```

To access the _now_ function just add a use command:

```pony
--8<-- "use-statement-time-now.pony"
```

## Use names

As we saw above the use command adds all the public types from a package into the namespace of the using file. This means that using a package may define type names that you want to use for your own types. Furthermore, if you use two packages within a file they may both define the same type name, causing a clash in your namespace. For example:

```pony
--8<-- "use-statement-use-names-conflict.pony"
```

The declarations of _x is an error because we don't know which `Foo` is being referred to. Actually using 'Foo' is not even required, simply using both `packageA` and `packageB` is enough to cause an error here.

To avoid this problem the use command allows you to specify an alias. If you do this then only that alias is put into your namespace. The types from the used package can then be accessed using this alias as a qualifier. Our example now becomes:

```pony
--8<-- "use-statement-use-names-resolution.pony"
```

If you prefer you can give an alias to only one of the packages. `Foo` will then still be added to your namespace referring to the unaliased package:

```pony
--8<-- "use-statement-use-names-resolution-alternative.pony"
```

__Can I just specify the full package path and forget about the use command, like I do in Java and C#?__ No, you can't do that in Pony. You can't refer to one package based on a `use` command for another package and you can't use types from a package without a use command for that package. Every package that you want to use must have its own `use` command.

__Are there limits on the names I can use for an alias?__ Use alias names have to start with a lower case letter. Other than that you can use whatever name you want, as long as you're not using that name for any other purpose in your file.

## Scheme indicators

The string we give to a `use` command is known as the _specifier_. This consists of a _scheme_ indicator and a _locator_, separated by a colon. The scheme indicator tells the `use` command what we want it to do, for example, the scheme indicator for including a package is "package". If no colon is found within the specifier string then the use command assumes you meant "package".

The following two use commands are exactly equivalent:

```pony
--8<-- "use-statement-scheme-indicators-optional-package-scheme-specifier.pony"
```

If you are using a locator string that includes a colon, for example, an absolute path in Windows, then you __have__ to include the "package" scheme specifier:

```pony
--8<-- "use-statement-scheme-indicators-required-package-scheme-specifier.pony"
```

To allow use commands to be portable across operating systems, and to avoid confusion with escape characters, '/' should always be used as the path separator in use commands, even on Windows.
