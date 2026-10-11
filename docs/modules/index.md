# Overview

Pony code is organised into __modules__. Each program is a single module, possibly using other modules. A reusable set of Pony source files is a __package__.

## The module structure

The module is the basic unit of code in Pony. It corresponds directly to a directory in the file system, all Pony source files within that directory are within that module. Note that this does not include files in any sub-directories.

Every source file is within exactly one module. Hence all Pony code is in modules.

A module is usually split into several source files, although it does not have to be. This is purely a convenience to allow better code organisation and the compiler treats all the code within a module as if it were from a single file.

The module is the privacy boundary for types and methods. That is:

1. Private types (those whose name starts with an underscore) can be used only within the module in which they are defined.
2. Private methods (those whose name starts with an underscore) can be called only from code within the module in which they are defined.

It follows that all code within a module is assumed to know and trust, all the rest of the code in the module.

There is no such concept as a sub-module in Pony. For example, the modules "foo/bar" and "foo/bar/wombat" will, presumably, perform related tasks but they are two independent modules. Module "foo/bar" does not contain module "foo/bar/wombat" and neither has access to the private elements of the other.
