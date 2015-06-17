Pony code is organised into __packages__. Each program and library is a single package, possibly using other packages.

# The package structure

The package is the basic unit of code in Pony. It corresponds directly to a directory in the file system, all Pony source files within that directory are within that package. Note that this does not include files in any sub-directories.

Every source file is within exactly one package. Hence all Pony code is in packages.

A package is usually split into several source files, although it does not have to be. This is purely a convenience to allow better code organisation and the compiler treats all the code within a package as if it were from a single file.

The package is the privacy boundary for types and methods. That is:

1. Private types (those whose name starts with an underscore) can be used only within the package in which they are defined.
1. Private methods (those whose name starts with an underscore) can be called only from code within the package in which they are defined.

It follows that all code within a package is assumed to know of, and trust, all the rest of the code in the package.

There is no such concept as a sub-package in Pony. For example the packages "foo/bar" and "foo/bar/wombat" will, presumably, perform related tasks but they are two independent packages. Package "foo/bar" does not contain package "foo/bar/wombat" and neither has access to the private elements of the other.

# Use command

To use a package in your code you need to have a __use__ command. This tells the compiler to find the package you need and make the types defined in it available to you. Every Pony file that needs to know about a type from a package must have a use command for it.

Use commands are a similar concept to Python and Java "import", C/C++ "#include" and C# "using" commands, but not exactly the same. They come at the beginning of Pony files and look like this:

```pony
use "collections"
```

This will find all of the publicly visible types defined in the _collections_ package and add them to the type namespace of the file containing the use command. These types are then available to use within that file, just as if they were defined locally.

For example, the standard library contains the package _time_. This contains the following definition (among others):

```pony
primitive Time
  fun now(): (I64, I64)
```

To access the _now_ function just add a use command:

```pony
use "time"

class Foo
  fun f() =>
    (var secs, var nsecs) = Time.now()
```

## Use names

As we saw above the use command adds all the public types from a package into the namespace of the using file. This means that using a package may define type names that you want to use for your own types. Furthermore, if you use two packages within a file they may both define the same type name, causing a clash in your namespace. For example:

```pony
// In package A
class Foo

// In package B
class Foo

// In your code
use "packageA"
use "packageB"

class Bar
  var _x: Foo
```

The declarations of _x is an error because we don't know which `Foo` is being referred to. Actually using 'Foo' is not even required, simply using both package A and package B is enough to cause an error here.

To avoid this problem the use command allows you to specify an alias. If you do this then only that alias is put into your namespace. The types from the used package can then be accessed using this alias as a qualifier. Our example now becomes:

```pony
// In package A
class Foo

// In package B
class Foo

// In your code
use a = "packageA"
use b = "packageB"

class Bar
  var _x: a.Foo  // The Foo from package A
  var _y: b.Foo  // The Foo from package B
```

If you prefer you can give an alias to only one of the packages. `Foo` will then still be added to your namespace referring to the unaliased package:

```pony
// In package A
class Foo

// In package B
class Foo

// In your code
use "packageA"
use b = "packageB"

class Bar
  var _x: Foo  // The Foo from package A
  var _y: b.Foo  // The Foo from package B
```

__Can I just specify the full package path and forget about the use command, like I do in Java and C#?__ No, you can't do that in Pony. You can't refer to one package based on a use command for another package and you can't use types from a package without a use command for that package. Every package that you want to use must have its own use command.

__Are there limits on the names I can use for an alias?__ Use alias names have to start with a lower case letter. Other than that you can use whatever name you want, as long as you're not using that name for any other purpose in your file.

## Use conditions

Sometimes you may want a use command that only works under certain circumstances, most commonly only on a particular OS or only for debug builds. You can do this by specifying a condition for a use comamnd:

```pony
use "foo" if linux
use "bar" if (windows and debug)
```

Use conditions can use any of the methods defined in `builtin/Platform` as conditions. They can also use the operators `and`, `or`, `xor` and `not`. As with other expressions in Pony, parentheses __must__ be used to indicate precedence if more than one of `and`, `or` and `xor` is used.

Any use command whose condition evaluates to false is simply ignored.

## Scheme indicators

The string we give to a use command is known as the _specifier_. This consists of a _scheme_ indicator and a _locator_, separated by a colon. The scheme indicator tells the use command what we want it to do, for example the scheme indicator for including a package is "package". If no colon is found within the specifier string then the use command assumes you meant "package".

The following two use commands are exactly equivalent:

```pony
use "foo"
use "package:foo"
```

If you are using a locator string that includes a colon, for example an absolute path in Windows, then you __have__ to include the "package" scheme specifier:

```pony
use "C:/foo/bar"  // Error, scheme "C" is unknown
use "package:C:/foo/bar"  // OK
```

To allow use commands to be portable across operating systems, and to avoid confusion with escape characters, '/' should always be used as the path separator in use commands, even on Windows.

# Standard library

The Pony standard library is a collection of packages that can each be used as needed to provide a variety of functionality. For example the __files__ package provides file access and the __collections__ package provides generic lists, maps, sets and so on.

There is also a special package in the standard library called __builtin__. This contains various types that the compiler has to treat specially and are so common that all Pony code needs to know about them. All Pony source files have an implicit `use "builtin"` command. This means all the types defined in the package builtin are automatically available in the type namespace of all Pony source files.
