---
title: "Linking to C Libraries"
section: "C FFI"
menu:
  toc:
    parent: "c-ffi"
    weight: 20
toc: true
---

If Pony code calls FFI functions, then those functions, or rather the libraries containing them, must be linked into the Pony program.

## Use for external libraries

To link an external library to Pony code another variant of the use command is used. The "lib" specifier is used to tell the compiler you want to link to a library. For example:

```pony
use "lib:foo"
```

As with other `use` commands a condition may be specified. This is particularly useful when the library has slightly different names on different platforms.

Here's a real example from the standard library:

```pony
use "path:/usr/local/opt/libressl/lib" if osx
use "lib:ssl" if not windows
use "lib:crypto" if not windows
use "lib:libssl-32" if windows
use "lib:libcrypto-32" if windows

primitive _SSLInit
  """
  This initialises SSL when the program begins.
  """
  fun _init() =>
    @SSL_load_error_strings[None]()
    @SSL_library_init[I32]()
```

On Windows, we use the libraries "libssl-32" and "libcrypto-32" and on other platforms we use "ssl" and "crypto". These contain the FFI functions SSL_library_init and SSL_load_error_strings (amongst others).

By default the Pony compiler will look for the libraries to link in the standard places, however, that is defined on the build platform. However, it may be necessary to look in extra places. The `use "path:..."` command allows this. The specified path is added to the library search paths for the remainder of the current file. The example above uses this to add the path "/usr/local/opt/libressl/lib" for OSX. This is required because the library is provided by brew, which installs things outside the standard library search paths.

If you are integrating with existing libraries, that is all you need to do.
