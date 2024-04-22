# C ABI

The FFI support in Pony uses the C application binary interface (ABI) to interface with native code. The C ABI is a calling convention, one of many, that allow objects from different programming languages to be used together.

## Writing a C library for Pony

Writing your own C library for use by Pony is almost as easy as using existing libraries.

Let's look at a complete example of a C function we may wish to provide to Pony. Let's consider a pure Pony implementation of a [Jump Consistent Hash](https://arxiv.org/abs/1406.2294):

```pony
--8<-- "c-abi-jump-consistent-hashing.pony"
```

Let's say we wish to compare the pure Pony performance to an existing C function with the following header:

```c
--8<-- "c-abi-jump-consistent-hashing-header.c"
```

Note the use of `extern "C"`. If the library is built as C++ then we need to tell the compiler not to mangle the function name, otherwise, Pony won't be able to find it. For libraries built as C, this is not needed, of course.

The implementation of the previous header would be something like:

```c
--8<-- "c-abi-jump-consistent-hashing-implementation.c"
```

We need to compile the native code to a shared library. This example is for MacOS. The exact details may vary on other platforms.

```bash
--8<-- "c-abi-compile-jump-consistent-hashing-for-macos.sh"
```

The Pony code to use this new C library is just like the code we've already seen for using C libraries.

```pony
--8<-- "c-abi-pony-use-native-jump-consistent-hashing-c-implementation.pony"
```

We can now use ponyc to compile a native executable integrating Pony and our C library. And that's all we need to do.
