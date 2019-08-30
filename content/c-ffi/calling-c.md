---
title: "Calling C from Pony"
section: "C FFI"
menu:
  toc:
    parent: "c-ffi"
    weight: 10
toc: true
---

FFI is built into Pony and native libraries may be directly referenced in Pony code. There is no need to code or configure bindings, wrappers or interfaces.

Here's an example of an FFI call in Pony from the standard library. It looks like a normal method call, with just a few differences:

```pony
@fwrite[U64](data.cstring(), U64(1), data.size(), _handle)
```

The main difference is the @ symbol before the function name. This is what tells us it's an FFI call. Any time you see an @ in Pony there's an FFI going on.

The other key difference is that the return type of the function is specified after the function name, in square brackets. This is because the compiler needs to know what type the value returned is (if any), but has no way to determine that, so it needs you to explicitly tell it.

There are a few unusual things going on with the arguments to this FFI call as well. For the second argument, for which we're passing the value 1, we've had to specify that this is a U64. Again this is because the compiler needs to know what size argument to use, but has no way to determine this.

## Safely does it

__It is VERY important that when calling FFI functions you MUST get the parameter and return types right__. The compiler has no way to know what the native code expects and will just believe whatever you do. Errors here can cause invalid data to be passed to the FFI function or returned to Pony, which can lead to program crashes.

To help avoid bugs here Pony allows you to specify the type signatures of FFI functions in advance. Whilst you must still get the types correct the arguments you provide at each FFI call site are checked against the declared signature. This means that you must get a type wrong, in the same way, in at least 2 places for a bug to exist. This won't help if the argument types the native code expects are different to what you think they are, but it will protect you against trivial mistakes and simple typos.

FFI signatures are declared using the `use` command. Here's an example from the standard library:

```pony
use @SSL_CTX_ctrl[I32](ctx: Pointer[_SSLContext] tag, op: I32, arg: I32,
  parg: Pointer[U8] tag) if windows

use @SSL_CTX_ctrl[I64](ctx: Pointer[_SSLContext] tag, op: I32, arg: I64,
  parg: Pointer[U8] tag) if not windows

class SSLContext val
  new create() =>
    // set SSL_OP_NO_SSLv2
    @SSL_CTX_ctrl(_ctx, 32, 0x01000000, Pointer[U8])
```

The @ symbol tells us that the use command is an FFI signature declaration. The types specified here are considered authoritative and any FFI calls that differ are considered to be an error.

Note that we no longer need to specify the return type at the call site, since the signature declaration has already told us what it is. However, it is perfectly acceptable to specify it again if you want to.

The use @ command can take a condition just like other `use` commands. This is useful in this case, where the Windows version of SSL_CTX_ctrl has a slightly different signature to other platforms.

## C types

Many C functions require types that don't have an exact equivalent in Pony. A variety of features is provided for these.

For FFI functions that have no return value (ie they return `void` in C) the return value specified should be `[None]`.

In Pony String is an object with a header and fields, but in C a `char*` is simply a pointer to character data. The `.cstring()` function on String provides us with a valid pointer to hand to C. Our `fwrite` example above makes use of this for the first argument.

Pony classes correspond directly to pointers to the class in C.

For C pointers to simple types, such as U64, the Pony `Pointer[]` polymorphic type should be used, with a `tag` reference capability. `Pointer[U8] tag` should be used for void*. This can be seen in our `SSL_CTX_ctrl` example above.

To pass pointers to values to C the `addressof` operator can be used (previously `&`), just like taking an address in C. This is done in the standard library to pass the address of a `U64` to an FFI function that takes a `uint64_t*` as an out parameter:

```pony
var len = U64(0)
@pcre2_substring_length_bynumber_8[I32](_match, i.u32(), addressof len)
```

### Get and Pass Pointers to FFI
To pass and receive pointers to c structs you need to declare pointer to primitives
```pony
primitive _XDisplayHandle
primitive _EGLDisplayHandle

let x_dpy = @XOpenDisplay[Pointer[_XDisplayHandle]](U32(0))
if x_dpy.is_null() then
  env.out.print("XOpenDisplay failed")
end

let e_dpy = @eglGetDisplay[Pointer[_EGLDisplayHandle]](x_dpy)
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


## FFI functions raising errors

FFI functions can raise Pony errors. Functions in existing C libraries are very unlikely to do this, but support libraries specifically written for use with Pony may well do.

FFI calls to functions that __might__ raise an error __must__ mark it as such by adding a ? after the arguments. For example:

```pony
@os_send[U64](_event, data.cstring(), data.size()) ? // May raise an error
```

If a signature declaration is used then that must be marked as possibly raising an error in the same way. The FFI call site must mark it as well.

```pony
use @os_send[U64](ev: Event, buf: Pointer[U8] tag, len: U64) ?

@os_send(_event, data.cstring(), data.size())? // May raise an error
```
