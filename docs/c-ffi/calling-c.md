# Calling C from Pony

FFI is built into Pony and native libraries may be directly referenced in Pony code. There is no need to code or configure bindings, wrappers or interfaces.

## Safely does it

__It is VERY important that when calling FFI functions you MUST get the parameter and return types right__. The compiler has no way to know what the native code expects and will just believe whatever you do. Errors here can cause invalid data to be passed to the FFI function or returned to Pony, which can lead to program crashes.

To help avoid bugs, Pony requires you to specify the type signatures of FFI functions in advance. While the compiler will trust that you specify the correct types in the signature, it will check the arguments you provide at each FFI call site against the declared signature. This means that you must get the types right only once, in the declaration. A declaration won't help you if the argument types the native code expects are different to what you think they are, but it will protect you against trivial mistakes and simple typos.

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

FFI functions have the @ symbol before its name, and FFI signatures are declared using the `use` command. The types specified here are considered authoritative, and any FFI calls that use different types will result in a compile error.

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

If you want to receive a pointer to an opaque C type, using a pointer to a primitive can be useful:

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

The above example would also work if we used `Pointer[None]` for all the pointer types. By using a pointer to a primitive, we are adding a level of type safety, as the compiler will ensure that we don't pass a pointer to any other type as a parameter to `eglGetDisplay`. It is important to note that these primitives should __not be used anywhere except as a type parameter__ of `Pointer[]`, to avoid misuse.

### Working with Structs: from Pony to C

Like we mentioned above, Pony classes and structs correspond directly to pointers to the class or struct in C. This means that in most cases we won't need to use the `addressof` operator when passing struct types to C. For example, let's imagine we want to use the `writev` function from Pony on Linux:

```pony
// In C: ssize_t writev(int fd, const struct iovec *iov, int iovcnt)
use @writev[USize](fd: U32, iov: IOVec tag, iovcnt: I32)

// In C:
// struct iovec {
//     void  *iov_base;    /* Starting address */
//     size_t iov_len;     /* Number of bytes to transfer */
// };
struct IOVec
  var base: Pointer[U8] tag = Pointer[U8]
  var len: USize = 0

let data = "Hello from Pony!"
var iov = IOVec
iov.base = data.cpointer()
iov.len = data.size()
@writev(1, iov, 1) // Will print "Hello from Pony!"
```

As you saw, a `IOVec` instance in Pony is equivalent to `struct iovec*`. In some cases, like the above example, it can be cumbersome to define a `struct` type in Pony if you only want to use it in a single place. You can also use a pointer to a tuple type as a shorthand for a struct: let's rework the above example:

```pony
use @writev[USize](fd: U32, iov: Pointer[(Pointer[U8] tag, USize)] tag, iovcnt: I32)

let data = "Hello from Pony!"
var iov = (data.cpointer(), data.size())
@writev(1, addressof iov, 1) // Will print "Hello from Pony!"
```

In the example above, the type `Pointer[(Pointer[U8] tag, USize)] tag` is equivalent to the `IOVec` struct type we defined earlier. That is, _a struct type is equivalent to a pointer to a tuple type with the fields of the struct as elements, in the same order as the original struct type defined them_.

**Can I pass struct types by value, instead of passing a pointer?** Not at the moment. This is a known limitation of the current FFI system, but it is something the Pony team is interested in fixing.

### Working with Structs: from C to Pony

A common pattern in C is to pass a struct pointer to a function, and that function will fill in various values in the struct. To do this in Pony, you make a `struct` and then use a `NullablePointer`, which denotes a possibly-null type:

```pony
use @ioctl[I32](fd: I32, req: U32, ...)

struct Winsize
  var height: U16 = 0
  var width: U16 = 0

  new create() => None

let size = Winsize

@ioctl(0, 21523, NullablePointer[Winsize](size))

env.out.print(size.height.string())
```

A `NullablePointer` type can only be used with `structs`, and is only intended for output parameters (like in the example above) or for return types from C. You don't need to use a `NullablePointer` if you are only passing a `struct` as a regular input parameter.

### Return-type Polymorphism

We mentioned before that you should use the `Pointer[None]` type in Pony when dealing with values of `void*` type in C. This is very useful for function parameters, but when we use `Pointer[None]` for the return type of a C function, we won't be able to access the value that the pointer points to. Let's imagine a generic list in C:

```C
struct List;

struct List* list_create();
void list_free(struct List* list);

void list_push(struct List* list, void *data);
void* list_pop(struct List* list);
```

Following the advice from previous sections, we can write the following Pony declarations:

```pony
use @list_create[Pointer[_List]]()
use @list_free[None](list: Pointer[_List])

use @list_push[None](list: Pointer[_List], data: Pointer[None])
use @list_pop[Pointer[None]](list: Pointer[_List])

primitive _List
```

We can use these declarations to create lists of different types, and insert elements into them:

```pony
struct Point
  var x: U64 = 0
  var y: U64 = 0

let list_of_points = @list_create()
@list_push(list_of_points, NullablePointer[Point].create(Point))

let list_of_strings = @list_create()
@list_push(list_of_strings, "some data".cstring())
```

We can also get elements out of the list, although we won't be able to do anything with them:

```pony
// Compiler error: couldn't find 'x' in 'Pointer'
let point_x = @list_pop(list_of_points)
point.x

// Compiler error: wanted Pointer[U8 val] ref^, got Pointer[None val] ref
let head = String.from_cstring(@list_pop(list_of_strings))
```

We can fix this problem by adding an explicit return type parameter when calling `list_pop`:

```pony
// OK
let point = @list_pop[Point](list_of_points)
let x_coord = point.x

// OK
let pointer = @list_pop[Pointer[U8]](list_of_strings)
let data = String.from_cstring(pointer)
```

Note that the declaration for `list_pop` is still needed: if we don't add an explicit return type when calling `list_pop`, the default type will be the return type of the declaration.

You'll notice that this feature enables you to cast the return type of a C function to any other type, **making this feature potentially dangerous if you cast to the wrong type**. As we have noted before, when it comes to FFI, the Pony compiler trusts that you know what you are doing, so you MUST get the return type right.

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

Since type signature declarations are scoped to a single Pony package, separate packages might define different FFI signatures for the same C function. In these cases, the compiler will make sure that all declarations are compatible with each other. Two declarations are compatible if their arguments and return types are compatible. Two types are compatible with each other if they have the same ABI size and they can be safely cast to each other. Currently, the compiler allows the following type casts:

* Any `struct` type can be cast to any other `struct`.
* Pointers and integers can be cast to each other.

Consider the following example:

```pony
// In library lib_a
use @memcmp[I32](dst: Pointer[None] tag, src: Pointer[None] tag, len: USize)

// In library lib_b
use @memcmp[I32](dst: Pointer[None] tag, src: USize, len: U64)
```

These two declarations have different types for the `src` and `len` parameters. In the case of `src`, the types are compatible since an integer can be cast as a pointer, and vice versa. For `len`, the types will not be compatible on 32 bit platforms, where `USize` is equivalent to `U32`. It is important to take the rules around casting into account when writing type declarations in libraries that will be used by others, as it will avoid any compatibility problems with other libraries.
