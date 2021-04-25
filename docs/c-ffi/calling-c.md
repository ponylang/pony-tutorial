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

## C types

Many C functions require types that don't have an exact equivalent in Pony. A variety of features is provided for these.

For FFI functions that have no return value (ie they return `void` in C) the return value specified should be `[None]`.

In Pony String is an object with a header and fields, but in C a `char*` is simply a pointer to character data. The `.cstring()` function on String provides us with a valid pointer to hand to C. Our `fwrite` example above makes use of this for the first argument.

Pony classes correspond directly to pointers to the class in C.

For C pointers to simple types, such as U64, the Pony `Pointer[]` polymorphic type should be used, with a `tag` reference capability. `Pointer[U8] tag` should be used for void*.

To pass pointers to values to C the `addressof` operator can be used (previously `&`), just like taking an address in C. This is done in the standard library to pass the address of a `U64` to an FFI function that takes a `uint64_t*` as an out parameter:

```pony
var len = U64(0)
@pcre2_substring_length_bynumber_8[I32](_match, i.u32(), addressof len)
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

Some C functions are variadic, that is, they can take a variable number of parameters. To interact with these functions, you should also specify that the FFI declaration takes a variable number of parameters:

```pony
use @printf[I32](fmt: Pointer[U8] tag, ...)
// ...
let run_ns: I64 = _current_t - _last_t
let rate: I64 = (_partial_count.i64() * 1_000_000_000) / run_ns
@printf("Elapsed: %lld,%lld\n".cstring(), run_ns, rate)
```

In the example above, the compiler will type-check the first argument to `printf`, but will not be able to check any other argument, since it lacks the necessary type information. It is __very__ important that you use `...` if the corresponding C function is variadic: if you don't, the compiler might generate a program that is incorrect or crash, depending on the target platform.

## FFI functions raising errors

Some FFI functions might raise Pony errors. Functions in existing C libraries are very unlikely to do this, but support libraries specifically written for use with Pony may well do.

FFI calls to functions that __might__ raise an error __must__ mark it as such by adding a ? after its declaration. The FFI call site must mark it as well. For example:

```pony
use @pony_os_send[USize](event: AsioEventID, buffer: Pointer[U8] tag, size: USize) ?
// ...
// May raise an error
@pony_os_send(_event, data.cpointer(), data.size()) ?
```
