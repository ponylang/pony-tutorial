# Linking to C Libraries

If Pony code calls FFI functions, then those functions, or rather the libraries containing them, must be linked into the Pony program.

## Use for external libraries

To link an external library to Pony code another variant of the use command is used. The `lib` specifier is used to tell the compiler you want to link to a library. For example:

```pony
--8<-- "linking-c-use-lib-foo.pony"
```

As with other `use` commands a condition may be specified. This is particularly useful when the library has slightly different names on different platforms.

Here's a real example from the standard library:

```pony
--8<-- "linking-c-use-with-condition.pony"
```

On Windows, we use the libraries `libssl-32` and `libcrypto-32` and on other platforms we use `ssl` and `crypto`. These contain the FFI functions `SSL_library_init` and `SSL_load_error_strings` (amongst others).

By default the Pony compiler will look for the libraries to link in the standard places, however, that is defined on the build platform. However, it may be necessary to look in extra places. The `use "path:..."` command allows this. The specified path is added to the library search paths for the remainder of the current file. The example above uses this to add the path `/usr/local/opt/libressl/lib` for MacOS. This is required because the library is provided by brew, which installs things outside the standard library search paths.

If you are integrating with existing libraries, that is all you need to do.
