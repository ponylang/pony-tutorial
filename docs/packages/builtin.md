# Standard library

The Pony standard library is a collection of packages that can each be used as 
needed to provide a variety of functionality. For example the __files__ package 
provides file access and the __collections__ package provides generic lists, 
maps, sets and so on.

There is also a special package in the standard library called __builtin__. 
This contains various types that the compiler has to treat specially and are so 
common that all Pony code needs to know about them. All Pony source files have 
an implicit `use "builtin"` command. This means all the types defined in the 
package builtin are automatically available in the type namespace of all Pony 
source files.
