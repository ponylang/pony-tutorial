# Calling C

Pony supports integration with other native languages through the
Foreign Function Interface (FFI). The FFI library provides a stable
and portable API and high level programming interface allowing Pony
to integrate with native libraries easily.

# Using FFI

FFI is built into pony and native libraries may be directly referenced
in the pony language. There is no need to configure binding wrappers or code generate
wrapper interfaces.

For example, pony itself uses FFI to provide SSL support, so lets use that
as a motivating example.

```
// File: packages/net/ssl/sslinit.pony

 1 use "path:/usr/local/opt/libressl/lib" if osx
 2 use "lib:ssl" if not windows
 3 use "lib:crypto" if not windows
 4 use "lib:libssl-32" if windows
 5 use "lib:libcrypto-32" if windows
 6
 7 primitive _SSLInit
 8   """
 9   This initialises SSL when the program begins.
10   """
11   fun _init(env: Env) =>
12     @SSL_load_error_strings[None]()
13     @SSL_library_init[I32]()
``` 

* In line 1, we provide a path to the library we wish to integrate with
* On OS X, we use a fixed path to a brew installed fork of OpenSSL libressl
* On line 2, we use the standard path on linux or UNIX environments
* On line 3, we include the libcrypto dependency
* On line 4 and 5 we include the windows 32 bit flavors

If you are integrating with existing libraries, that is it.

# Safely does it

Pony will check the signatures used to make sure they are mapped and bound
correctly to the pony type system. In the example above, on line 13, we are calling the OpenSSL
SSL_library_init function and returning an ```I32``` or 32-bit signed integer.
We are not passing any arguments from pony into this function.
As this expression is the last in the function, the result of the call to SSL_library_init
will be returned to pony, and pony will return it to the caller.

If there are compiler issues (due to type mismatch) they will be reported.
If the library cannot be found and loaded, this will be reported.
If the function being called is not exported or found this will also be reported.

# Using the libraries

In order to use the libraries we use the FFI call expression form.

```

11   fun _init(env: Env) =>
12     @SSL_load_error_strings[None]()
13     @SSL_library_init[I32]()
```

In this case we are calling SSL_load_error_strings; which loads the error strings for all crypto functions, and SSL_library_init; which initializes available ciphers and digests.  at initialization (at program start).
