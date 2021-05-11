# Calling C from Pony

FFI is built into Pony and native libraries may be directly referenced in Pony code. There is no need to code or configure bindings, wrappers or interfaces.

## Safely does it

__It is VERY important that when calling FFI functions you MUST get the parameter and return types right__. The compiler has no way to know what the native code expects and will just believe whatever you do. Errors here can cause invalid data to be passed to the FFI function or returned to Pony, which can lead to program crashes.

To help avoid bugs, Pony requires you to specify the type signatures of FFI functions in advance. While the compiler will trust that you specify the correct types in the signature, it will check each the arguments you provide at each FFI call site against the declared signature. This means that you must get the types right only once, in the declaration. A declaration won't help you if the argument types the native code expects are different to what you think they are, but it will protect you against trivial mistakes and simple typos.

Here's an example of an FFI signature and call from the standard library:

```pony
use @_mkdir[I32](dir: Pointer[U8] tag) if windows
use @mkdir[I32](path: Pointer[U8] tag, mode: U32) if not windows

class val FilePath
  fun val mkdir(must_create: Bool = false): Bool =>
    // ...
      let r = ifdef windows then
        @_mkdir(element.cstring())
      else
        @mkdir(element.cstring(), 0x1FF)
      end
```

FFI functions have the @ symbol before its name, and FFI signatures are declared using the `use` command. The types specified here are considered authoritative, and any FFI calls that differ are considered to be an error.

The use @ command can take a condition just like other `use` commands. This is useful in this case, since the `_mkdir` function only exists in Windows.

If the name of the C function that you want to call is also a [reserved keyword in Pony](/appendices/keywords.md) (such as `box`), you will need to wrap the name in double quotes (`@"box"`). If you forget to do so, your program will not compile.

An FFI signature is public to all Pony files inside the same package, so you only need to write them once.

## C types

Many C functions require types that don't have an exact equivalent in Pony. A variety of features is provided for these.

For FFI functions that have no return value (i.e. they return `void` in C) the return value specified should be `None`.

In Pony, a String is an object with a header and fields, while in C a `char*` is simply a pointer to character data. The `.cstring()` function on String provides us with a valid pointer to hand to C. Our `mkdir` example above makes use of this for the first argument.

Pony classes and structs correspond directly to pointers to the class or struct in C.

For C pointers to simple types, such as U64, the Pony `Pointer[]` polymorphic type should be used, with a `tag` reference capability. To represent `void*` arguments, you should the `Pointer[None] tag` type, which will allow you to pass a pointer to any type, including other pointers. This is needed to write declarations for certain POSIX functions, such as `memcpy`:

```pony
// The C type is void* memcpy(void *restrict dst, const void *restrict src, size_t n);
use @memcpy[Pointer[U8]](dst: Pointer[None] tag, src: Pointer[None] tag, n: USize)

// Now we can use memcpy with any Pointer type
let out: Pointer[Pointer[U8] tag] tag = // ...
let outlen: Pointer[U8] tag = // ...
let ptr: Pointer[U8] tag = // ...
let size: USize = // ...
// ...
@memcpy(out, addressof ptr, size.bitwidth() / 8)
@memcpy(outlen, addressof size, 1)
```

When dealing with `void*` return types from C, it is good practice to try to narrow the type down to the most specific Pony type that you expect to receive. In the example above, we chose `Pointer[U8]` as the return type, since we can use such a pointer to construct Pony Arrays and Strings.

To pass pointers to values to C the `addressof` operator can be used (previously `&`), just like taking an address in C. This is done in the standard library to pass the address of a `U32` to an FFI function that takes a `int*` as an out parameter:

```pony
use @frexp[F64](value: F64, exponent: Pointer[U32])
// ...
var exponent: U32 = 0
var mantissa = @frexp(this, addressof exponent)
```

### Get and Pass Pointers to FFI

To pass and receive pointers to c structs you need to declare pointer to primitives

```pony
use @XOpenDisplay[Pointer[_XDisplayHandle]](name: Pointer[U8] tag)
use @eglGetDisplay[Pointer[_EGLDisplayHandle]](disp: Pointer[_XDisplayHandle])

primitive _XDisplayHandle
primitive _EGLDisplayHandle

let x_dpy = @XOpenDisplay(Pointer[U8])
if x_dpy.is_null() then
  env.out.print("XOpenDisplay failed")
end

let e_dpy = @eglGetDisplay(x_dpy)
if e_dpy.is_null() then
  env.out.print("eglGetDisplay failed")
end
```

### Read Struct Values from FFI

A common pattern in C is to pass a struct pointer to a function, and that function will fill in various values in the struct. To do this in Pony, you make a `struct` and then use a `NullablePointer`:

```pony
struct Winsize
  var height: U16 = 0
  var width: U16 = 0

  new create() => None

let size = Winsize

@ioctl(0, 21523, NullablePointer[Winsize](size))

env.out.print(size.height.string())
```

### Variadic C functions

Some C functions are variadic, that is, they can take a variable number of parameters. To interact with these functions, you should also specify that fact in the FFI signature:

```pony
use @printf[I32](fmt: Pointer[U8] tag, ...)
// ...
let run_ns: I64 = _current_t - _last_t
let rate: I64 = (_partial_count.i64() * 1_000_000_000) / run_ns
@printf("Elapsed: %lld,%lld\n".cstring(), run_ns, rate)
```

In the example above, the compiler will type-check the first argument to `printf`, but will not be able to check any other argument, since it lacks the necessary type information. It is __very__ important that you use `...` in the FFI signature if the corresponding C function is variadic: if you don't, the compiler might generate a program that is incorrect or crash on some platforms while appearing to work correctly on others.

## FFI functions raising errors

Some FFI functions might raise Pony errors. Functions in existing C libraries are very unlikely to do this, but support libraries specifically written for use with Pony may well do.

FFI calls to functions that __might__ raise an error __must__ mark it as such by adding a ? after its declaration. The FFI call site must mark it as well. For example:

```pony
use @pony_os_send[USize](event: AsioEventID, buffer: Pointer[U8] tag, size: USize) ?
// ...
// May raise an error
@pony_os_send(_event, data.cpointer(), data.size()) ?
```

If you're writing a C library that wants to raise a Pony error, you should do so using the `pony_error` function. Here's an example from the Pony runtime:

```C
// In pony.h
PONY_API void pony_error();

// In socket.c
PONY_API size_t pony_os_send(asio_event_t* ev, const char* buf, size_t len)
{
  ssize_t sent = send(ev->fd, buf, len, 0);

  if(sent < 0)
  {
    if(errno == EWOULDBLOCK || errno == EAGAIN)
      return 0;

    pony_error();
  }

  return (size_t)sent;
}
```

A function that calls the `pony_error` function should only be called from inside a `try` block in Pony. If this is not done, the call to `pony_error` will result in a call to C's `abort` function, which will terminate the program.

## Type signature compatibility

Since type signature declarations are scoped to a single Pony package, separate packages might define different FFI signatures for the same C function. In these cases, the compiler will make sure that all declarations are compatible with each other. Two declarations are compatible if their arguments and return types are compatible. Two types are compatible with each other if they have the same ABI size and they can be safely casted to each other. Currently, the compiler allows the following type casts:

* Any `struct` type can be casted to any other `struct`.
* Pointers and integers can be casted to each other.

Consider the following example:

```pony
// In library lib_a
use @memcmp[I32](dst: Pointer[None] tag, src: Pointer[None] tag, len: USize)

// In library lib_b
use @memcmp[I32](dst: Pointer[None] tag, src: USize, len: U64)
```

These two declarations have different types for the `src` and `len` parameters. In the case of `src`, the types are compatible since an integer can be casted as a pointer, and vice versa. For `len`, the types will not be compatible on 32 bit platforms, where `USize` is equivalent to `U32`. It is important to take the rules around casting into account when writing type declarations in libraries that will be used by others, as it will avoid any compatibility problems with other libraries.
