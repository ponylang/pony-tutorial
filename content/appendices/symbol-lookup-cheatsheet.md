---
title: "Symbol Lookup Cheatsheet"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 20
toc: true
---

Pony, like just about any other programming language, has plenty of odd symbols that make up its syntax. If you don't remember what one means, it can be hard to search for them. Below you'll find a table with various Pony symbols and what you should search the tutorial for in order to learn more about the symbol.

|Symbol | Search Keywords|
| --- | --- |
| `!`  | Alias |
| `->` | Arrow type, viewpoint |
| `.>` | Chaining |
| `^`  | Ephemeral |
| `@`  | FFI |
| `&`  | Intersection |
| `=>` | Match arrow |
| `~`  | Partial application |
| `?`  | Partial function |
| `'`  | Prime |
| `<:` | Subtype |


Here is a more elaborate explanation of Pony's use of special characters: (a line with (2) or (3) means an alternate usage of the symbol of the previous  line)

|Symbol | Usage|
| --- | --- |
| `,`  | to separate parameters in a function signature, or the items of a tuple |
| `.`  | (1) to call a field or a function on a variable (field access or method call) |
|    | (2) to qualify a type/method with its package name |
| `.>` | to call a method on an object and return the receiver (chaining) |
| `'`  | used as alternative name in parameters (prime) |
| `"`  | to delineate a literal string |
| `"""`  | to delineate a documentation string |
| `(` | (1) start of line: start of a tuple |
|    | (2) middle of line: method call |
| `()` | (1) parentheses, for function or behavior parameters |
|    | (2) making a tuple (values separated by `,`) |
|    | (3) making an enumeration (values separated by <code>&#124;</code>) |
| `[`  | (1) start of line: start of an array literal |
|    | (2) middle of line: generic formal parameters |
| `[]`  | (1) to indicate a generic type, for example `Range[U64]` |
|      | (2) to indicate the return type of an FFI function call |
| `{}`  | a function type |
| `:`  | (1) after a variable: is followed by the type name |
|    | (2) to indicate a function return type |
|    | (3) a type constraint |
| `;`  | only used to separate expressions on the same line |
| `=`  | (1) (destructive) assignment |
|    | (2) in: use alias = packname |
|    | (3) supply default argument for method |
|    | (4) supply default type for generics |
| `!`  | (1) boolean negation |
|    | (2) a type that is an alias of another type |
| `?`  | (1) partial functions |
|    | (2) a call to a C function that could raise an error |
| `-`  | (1) start of line: unary negation |
|    | (2) middle of line: subtraction |
| `_`  | (1) to indicate a private variable, constructor, function, behavior |
|    | (2) to ignore a tuple item in a pattern match |
| `~`  | partial application |
| `^`  | an ephemeral type |
| <code>&#124;</code> | (1) separates the types in an enumeration (the value can be any of these types) |
|    | (2) starts a branch in a match |
| `&`  | (1) separates the types in a complex type (the value is of all of these types) |
|    | (2) intersection |
| `@`  | FFI call |
| `//`  | comments |
| `/* */`  | multi-line or block comments |
| `=>`  | (1) start of a function body |
|     | (2) starts the code of a matching branch |
| `->`  | (1) arrow type |
|     | (2) viewpoint |
| `._i` | where `i = 1,2,…`  means the ith item of a tuple |
| `<:`  | "is a subtype of" or "can be substituted for" |
