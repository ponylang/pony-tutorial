# Callbacks

Some C APIs let the programmer specify functions that should be called to do pieces of work. For example, the SQLite API has a function called `sqlite3_exec` that executes an SQL statement and calls a function given by the programmer on each row returned by that statement. The functions that are supplied by the programmer are known as "callback functions". Some specific Pony functions can be passed as callback functions.

## Bare functions

Classic Pony functions have a receiver, which acts as an implicit argument to the function. Because of this, classic functions can't be used as callbacks with many C APIs. Instead, you can use _bare functions_, which are functions with no receiver.

You can define a bare function by prefixing the function name with the @ symbol.

```pony
--8<-- "c-ffi-callbacks-bare-functions.pony"
```

The function can then be passed as a callback to a C API with the `addressof` operator.

```pony
--8<-- "c-ffi-callbacks-bare-functions-pass-to-c-api.pony"
```

Note that it is possible to use an object reference instead of a type as the left-hand side of the method access.

Since bare methods have no receiver, they cannot reference the `this` identifier in their body (either explicitly or implicitly through field access), cannot use `this` viewpoint adapted types, and cannot specify a receiver capability.

## Bare lambdas

Bare lambdas are special lambdas defining bare functions. A bare lambda or bare lambda type is specified using the same syntax as other lambda types, with the small variation that it is prefixed with the @ symbol. The underlying value of a bare lambda is equivalent to a C function pointer, which means that a bare lambda can be directly passed as a callback to a C function. The partial application of a bare method yields a bare lambda.

```pony
--8<-- "c-ffi-callbacks-bare-lambda-callback.pony"
```

Bare lambdas can also be used to define structures containing function pointers. For example:

```pony
--8<-- "c-ffi-callbacks-bare-lambda-struct.pony"
```

This Pony structure is equivalent to the following C structure:

```c
--8<-- "c-ffi-callbacks-struct-with-function-pointers.c"
```

In the same vein as bare functions, bare lambdas cannot specify captures, cannot use `this` neither as an identifier nor as a type, and cannot specify a receiver capability. In addition, a bare lambda object always has a `val` capability.

Classic lambda types and bare lambda types can never be subtypes of each other.

## An example

Consider SQLite, mentioned earlier. When the client code calls `sqlite3_exec`, an SQL query is executed against a database, and the callback function is called for each row returned by the SQL statement. Here's the signature for `sqlite3_exec`:

```c
--8<-- "c-ffi-callbacks-sqlite3-callback.c"
```

`sqlite3_callback` is the type of the callback function that will be called by `sqlite3_exec` for each row returned by the `sql` statement. The first argument to the callback function is the pointer `pArg` that was passed to `sqlite3_exec`, the second argument is the number of columns in the row being processed, the third argument is data for each column, and the fourth argument is the name of each column.

Here's the skeleton of some Pony code that uses `sqlite3_exec` to query an SQLite database, with examples of both the bare method way and the bare lambda way:

```pony
--8<-- "c-ffi-callbacks-sqlite3-callback.pony"
```

```pony
--8<-- "c-ffi-callbacks-sqlite3-callback-2.pony"
```

Focusing on the callback-related parts, the callback function is passed using `addressof this.method_callback` (resp. by directly passing the bare lambda) as the third argument to `sqlite3_exec`. The fourth argument is `this`, which will end up being the first argument when the callback function is called. The callback function is called in `sqlite3_exec` by the call to `xCallback`.
