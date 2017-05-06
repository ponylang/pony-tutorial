# Callbacks

Some C APIs let the programmer specify functions that should be called to do pieces of work. For example, the SQLite API has a function called `sqlite3_exec` that executes an SQL statement and calls a function given by the programmer on each row returned by that statement. The functions that are supplied by the programmer are known as "callback functions". Pony functions can be passed as callback functions, but there are a few conditions that must be met.

## Pony assumes that the receiver is the first argument to the C function

You can imagine the C library or framework that calling a callback function like this:

```
callback(arg1, arg2, arg3);
```

If that callback function calls a Pony function, then Pony acts as though the following happened:

```
arg1.callback(arg2, arg3)
```

That is to say, the first argument in the call to the callback function is treated as the receiver of the Pony function call, and the other arguments are passed to the Pony function as arguments.

In most cases the call that sets up the callback allows the programmer to specify some piece of data that will always be passed to the callback function. When calling this setup function, you should specify the Pony object and function. For example, if the library provides a setup function called `setup` that takes a callback function and a user data object, and a Pony program has an object called `cbo` with a function `callback` that handles the callback, then `setup` would be called like this:

```
setup(addressof cbo.callback, cbo)
```

It may seem redundant to use `cbo` twice, but the function must be associated with an object when it is referenced.

## An example

Consider SQLite, mentioned earlier. When the client code calls `sqlite3_exec`, an SQL query is executed against a database, and the callback function is called for each row returned by the SQL statement. Here's the signature for `sqlite3_exec`:

```
typedef int (*sqlite3_callback)(void*,int,char**, char**);

...

SQLITE_API int SQLITE_STDCALL sqlite3_exec(
sqlite3 *db,                /* The database on which the SQL executes */
const char *zSql,           /* The SQL to be executed */
sqlite3_callback xCallback, /* Invoke this callback routine */
void *pArg,                 /* First argument to xCallback() */
char **pzErrMsg             /* Write error messages here */
)
{
  ...
  xCallback(pArg, nCol, azVals, azCols)
  ...
}
```

`sqlite3_callback` is the type of the callback function that will be called by `sqlite3_exec` for each row returned by the `sql` statement. The first argument to the callback function is the pointer `pArg` that was passed to `sqlite3_exec`, the second argument is the number of columns in the row being processed, the third argument is data for each column, and the fourth argument is the name of each column.

Here's the skeleton of some Pony code that uses `sqlite3_exec` to query an SQLite database:

```pony
class SQLiteClient
  fun client_code() =>
    ...
    @sqlite3_exec[I32](db, sql.cstring(), addressof this.callback,
                       this, addressof zErrMsg)
    ...

  fun iso callback(argc: I32, argv: Pointer[Pointer[U8]],
    azColName: Pointer[Pointer[U8]]): I32
  =>
    ...
```

Focusing on the callback-related parts, the callback function is passed using `addressof this.callback` as the third argument to `sqlite3_exec`. The fourth argument is `this`, which will end up being the first argument when the callback function is called. The callback function is called in `sqlite3_exec` by the call to `xCallback`. Remember, as mentioned before, that the first argument to `xCallback` becomes the receiver in the call to the Pony function, all subsequent arguments are passed along to the Pony callback function in order. The parameters of `callback` are arranged to reflect this.

If the order of the arguments to the callback function are not such that the receiver object will be passed as the first argument, the programmer will need to write a "shim" function in C that accepts arguments in the order provided by the API and rearranges them to make a call to the Pony function with arguments in the order that Pony expects.
