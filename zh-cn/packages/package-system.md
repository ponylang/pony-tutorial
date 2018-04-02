# Package System

Pony code is organised into __packages__. Each program and library is a single package, possibly using other packages.

## The package structure

The package is the basic unit of code in Pony. It corresponds directly to a directory in the file system, all Pony source files within that directory are within that package. Note that this does not include files in any sub-directories.

Every source file is within exactly one package. Hence all Pony code is in packages.

A package is usually split into several source files, although it does not have to be. This is purely a convenience to allow better code organisation and the compiler treats all the code within a package as if it were from a single file.

The package is the privacy boundary for types and methods. That is:

1. Private types (those whose name starts with an underscore) can be used only within the package in which they are defined.
1. Private methods (those whose name starts with an underscore) can be called only from code within the package in which they are defined.

It follows that all code within a package is assumed to know and trust, all the rest of the code in the package.

There is no such concept as a sub-package in Pony. For example, the packages "foo/bar" and "foo/bar/wombat" will, presumably, perform related tasks but they are two independent packages. Package "foo/bar" does not contain package "foo/bar/wombat" and neither has access to the private elements of the other.
