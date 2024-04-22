# Calling C from Pony

FFI is built into Pony and native libraries may be directly referenced in Pony code. There is no need to code or configure bindings, wrappers or interfaces.

## Safely does it

__It is VERY important that when calling FFI functions you MUST get the parameter and return types right__. The compiler has no way to know what the native code expects and will just believe whatever you do. Errors here can cause invalid data to be passed to the FFI function or returned to Pony, which can lead to program crashes.

To help avoid bugs, Pony requires you to specify the type signatures of FFI functions in advance. While the compiler will trust that you specify the correct types in the signature, it will check the arguments you provide at each FFI call site against the declared signature. This means that you must get the types right only once, in the declaration. A declaration won't help you if the argument types the native code expects are different to what you think they are, but it will protect you against trivial mistakes and simple typos.

Here's an example of an FFI signature and call from the standard library:

```pony
--8<-- "calling-c-file-path.pony"
```

FFI functions have the @ symbol before its name, and FFI signatures are declared using the `use` command. The types specified here are considered authoritative, and any FFI calls that use different parameter types will result in a compile error.

The use @ command can take a condition just like other `use` commands. This is useful in this case, since the `_mkdir` function only exists in Windows.

If the name of the C function that you want to call is also a [reserved keyword in Pony](/appendices/keywords.md) (such as `box`), you will need to wrap the name in double quotes (`@"box"`). If you forget to do so, your program will not compile.

An FFI signature is public to all Pony files inside the same package, so you only need to write them once.

## C types

Many C functions require types that don't have an exact equivalent in Pony. A variety of features is provided for these.

For FFI functions that have no return value (i.e. they return `void` in C) the return value specified should be `None`.

In Pony, a String is an object with a header and fields, while in C a `char*` is simply a pointer to character data. The `.cstring()` function on String provides us with a valid pointer to hand to C. Our `mkdir` example above makes use of this for the first argument.

Pony classes and structs correspond directly to pointers to the class or struct in C.

For C pointers to simple types, such as U64, the Pony `Pointer[]` polymorphic type should be used, with a `tag` reference capability. To represent `void*` arguments, you should use the `Pointer[None] tag` type, which will allow you to pass a pointer to any type, including other pointers. This is needed to write declarations for certain POSIX functions, such as `memcpy`:

```pony
--8<-- "calling-c-memcpy.pony"
```

When dealing with `void*` return types from C, it is good practice to try to narrow the type down to the most specific Pony type that you expect to receive. In the example above, we chose `Pointer[U8]` as the return type, since we can use such a pointer to construct Pony Arrays and Strings.

To pass pointers to values to C the `addressof` operator can be used (previously `&`), just like taking an address in C. This is done in the standard library to pass the address of a `U32` to an FFI function that takes a `int*` as an out parameter:

```pony
--8<-- "calling-c-addressof.pony"
```

### Get and Pass Pointers to FFI

If you want to receive a pointer to an opaque C type, using a pointer to a primitive can be useful:

```pony
--8<-- "calling-c-pointer-to-opaque-c-type.pony"
```

The above example would also work if we used `Pointer[None]` for all the pointer types. By using a pointer to a primitive, we are adding a level of type safety, as the compiler will ensure that we don't pass a pointer to any other type as a parameter to `eglGetDisplay`. It is important to note that these primitives should __not be used anywhere except as a type parameter__ of `Pointer[]`, to avoid misuse.

### Working with Structs: from Pony to C

Like we mentioned above, Pony classes and structs correspond directly to pointers to the class or struct in C. This means that in most cases we won't need to use the `addressof` operator when passing struct types to C. For example, let's imagine we want to use the `writev` function from Pony on Linux:

```pony
--8<-- "calling-c-writev-struct.pony"
```

As you saw, a `IOVec` instance in Pony is equivalent to `struct iovec*`. In some cases, like the above example, it can be cumbersome to define a `struct` type in Pony if you only want to use it in a single place. You can also use a pointer to a tuple type as a shorthand for a struct: let's rework the above example:

```pony
--8<-- "calling-c-writev-tuple.pony"
```

In the example above, the type `Pointer[(Pointer[U8] tag, USize)] tag` is equivalent to the `IOVec` struct type we defined earlier. That is, _a struct type is equivalent to a pointer to a tuple type with the fields of the struct as elements, in the same order as the original struct type defined them_.

**Can I pass struct types by value, instead of passing a pointer?** Not at the moment. This is a known limitation of the current FFI system, but it is something the Pony team is interested in fixing. If you'd like to work on adding support for passing structs by value, contact us [on the Zulip](https://ponylang.zulipchat.com/#narrow/stream/192795-contribute-to-Pony).

### Working with Structs: from C to Pony

A common pattern in C is to pass a struct pointer to a function, and that function will fill in various values in the struct. To do this in Pony, you make a `struct` and then use a `NullablePointer`, which denotes a possibly-null type:

```pony
--8<-- "calling-c-ioctl-struct.pony"
```

A `NullablePointer` type can only be used with `structs`, and is only intended for output parameters (like in the example above) or for return types from C. You don't need to use a `NullablePointer` if you are only passing a `struct` as a regular input parameter.

If you are using a C function that returns a struct, remember, that the C function needs to return a pointer to the struct. The following in Pony should be read as **returns a pointer to struct `Rect`**:

```pony
--8<-- "calling-c-from-c-struct.pony"
```

As we saw earlier, you can also use a `Pointer[(U16, U16)]` as well. It is the equivalent to our `Rect`.

**Can I return struct types by value, instead of passing a pointer?** Not at the moment. This is a known limitation of the current FFI system, but it is something the Pony team is interested in fixing. If you'd like to work on adding support for returning structs by value, contact us [on the Zulip](https://ponylang.zulipchat.com/#narrow/stream/192795-contribute-to-Pony).

### Return-type Polymorphism

We mentioned before that you should use the `Pointer[None]` type in Pony when dealing with values of `void*` type in C. This is very useful for function parameters, but when we use `Pointer[None]` for the return type of a C function, we won't be able to access the value that the pointer points to. Let's imagine a generic list in C:

```C
--8<-- "calling-c-generic-list.c"
```

Following the advice from previous sections, we can write the following Pony declarations:

```pony
--8<-- "calling-c-generic-list.pony"
```

We can use these declarations to create lists of different types, and insert elements into them:

```pony
--8<-- "calling-c-different-types-of-lists.pony"
```

We can also get elements out of the list, although we won't be able to do anything with them:

```pony
--8<-- "calling-c-access-list-entry-without-return-type.pony"
```

We can fix this problem by adding an explicit return type when calling `list_pop`:

```pony
--8<-- "calling-c-access-list-entry-with-explicit-return-type.pony"
```

Note that the declaration for `list_pop` is still needed: if we don't add an explicit return type when calling `list_pop`, the default type will be the return type of the declaration.

When specifying a different return type for an FFI function, make sure that the new type is [compatible](#type-signature-compatibility) with the type specified in the declaration.

### Variadic C functions

Some C functions are variadic, that is, they can take a variable number of parameters. To interact with these functions, you should also specify that fact in the FFI signature:

```pony
--8<-- "calling-c-variadic-c-functions.pony"
```

In the example above, the compiler will type-check the first argument to `printf`, but will not be able to check any other argument, since it lacks the necessary type information. It is __very__ important that you use `...` in the FFI signature if the corresponding C function is variadic: if you don't, the compiler might generate a program that is incorrect or crash on some platforms while appearing to work correctly on others.

## FFI functions raising errors

Some FFI functions might raise Pony errors. Functions in existing C libraries are very unlikely to do this, but support libraries specifically written for use with Pony may well do.

FFI calls to functions that __might__ raise an error __must__ mark it as such by adding a ? after its declaration. The FFI call site must mark it as well. For example:

```pony
--8<-- "calling-c-ffi-functions-raising-errors.pony"
```

If you're writing a C library that wants to raise a Pony error, you should do so using the `pony_error` function. Here's an example from the Pony runtime:

```C
--8<-- "calling-c-ffi-functions-raising-errors.c"
```

A function that calls the `pony_error` function should only be called from inside a `try` block in Pony. If this is not done, the call to `pony_error` will result in a call to C's `abort` function, which will terminate the program.

## Type signature compatibility

Since type signature declarations are scoped to a single Pony package, separate packages might define different FFI signatures for the same C function. In this case, as well as the case where you specify a different return type for an FFI call, the compiler will make sure that all calls and declarations are compatible with each other. Two functions are compatible if their arguments and return types are compatible. Two types are compatible with each other if they have the same ABI size and they can be safely cast to each other. The compiler allows the following type casts:

* Any `struct` type can be cast to any other `struct` (as they are both pointer types)
* Pointers and integers can be cast to each other.

Consider the following example:

```pony
--8<-- "calling-c-type-signature-compatibility.pony"
```

These two declarations have different types for the `src` and `len` parameters. In the case of `src`, the types are compatible since an integer can be cast as a pointer, and vice versa. For `len`, the types will not be compatible on 32 bit platforms, where `USize` is equivalent to `U32`. It is important to take the rules around casting into account when writing type declarations in libraries that will be used by others, as it will avoid any compatibility problems with other libraries.

## Calling FFI functions from Interfaces or Traits

We mentioned in the previous section that FFI declarations are scoped to a single Pony package, with separate packages possibly defining different FFI signatures for the same C function. Importing an external package will not import any FFI declarations, since any name collisions would produce multiple declarations for the same C function name, and thus deciding which declaration to use would be ambiguous.

Given the above fact, if you define any default methods (or behaviors) in an interface or trait, you will not be able to perform an FFI call from them. For example, the code below will fail to compile:

```pony
--8<-- "calling-c-default-method-in-trait.pony"
```

If the trait `Foo` above was part of the public API of a package, allowing its `apply` method to perform an FFI call would render `Foo` unusable for any external users, given that the declaration for `printf` would not be in scope.

Fortunately, avoiding this limitation is relatively painless. Whenever you need to call an FFI function from a default method implementation, consider moving said function to a separate type:

```pony
--8<-- "calling-c-default-method-in-primitive.pony"
```

By making the change above, we avoid exposing the call to `printf` to any consumers of our trait, thus making it usable by external users.
