# Exporting Pony Methods to C

The `\c_api\` annotation on a type declaration generates C-callable wrapper functions for that type's public methods and a `.h` header that declares them. C code — including [C shims](/c-ffi/c-shims.md) — can then call Pony methods on Pony objects through these wrappers.

Without this annotation, calling a Pony method from C is not possible. Methods that are never called from Pony are not compiled at all, and methods that are compiled use LLVM's fast calling convention, which C cannot call. The annotation addresses both problems: it forces the methods to be compiled and generates a wrapper for each one that uses the C calling convention.

This feature is experimental and may change in future releases.

## A basic example

This example has two packages. The `Adder` class lives in a library package called `mylib/`, and the main package consumes it through a C shim.

Annotate the class with `\c_api\` to export its public methods:

```pony
--8<-- "c-ffi-exporting-basic.pony"
```

ponyc generates a wrapper function for each eligible public method (`add` and `base` in this example) and writes their declarations to `mylib_export.h`. A C shim in the main package can include that header and call the wrappers:

```c
// shim.c (in the main package directory)
#include "mylib_export.h"

int64_t add_from_c(void* adder, int64_t x) {
  return mylib_Adder_add(adder, x);
}
```

The main package's Pony code calls the shim function via FFI, which in turn calls the Pony method through the generated wrapper:

```pony
--8<-- "c-ffi-exporting-use-package.pony"
```

```text
mylib/
  mylib.pony      (the Adder class)
main.pony         (use "mylib", FFI declaration, Main)
shim.c            (calls mylib_Adder_add)
```

## Which types can be exported

The annotation is valid on `class`, `primitive`, `struct`, `actor`, and `type` (type alias) declarations. It is not valid on `trait` or `interface` declarations, on methods, or on private types (names starting with `_`). Annotating any of these produces a compile error.

Generic types cannot be exported directly. To export a concrete reification of a generic type, use a type alias — see [Exporting generic types](#exporting-generic-types) below.

## How C names are derived

The C-facing name of each wrapper function is `[prefix_]TypeName_method_name`.

The prefix comes from the `use` statement in the package that imports the exported type's package. With `use "mylib"`, the prefix is `mylib`. With an alias — `use math = "mylib"` — the prefix is the alias:

```pony
--8<-- "c-ffi-exporting-use-alias.pony"
```

| `use` statement | Wrapper name | Header file |
|---|---|---|
| `use "mylib"` | `mylib_Adder_add` | `mylib_export.h` |
| `use math = "mylib"` | `math_Adder_add` | `math_export.h` |
| Main package (no `use`) | `Adder_add` | `<binary>_export.h` |

Characters that are not valid in C identifiers are replaced with underscores.

## Which methods are exported

Only public, non-generic `fun` methods with no tuple parameters or return types and no `?` (partial) marker are exported. Everything else is excluded:

- **Constructors** (`new`) — C code cannot construct Pony objects through this mechanism.
- **Behaviors** (`be`) — asynchronous message sends with no return value meaningful to C.
- **Private methods** — names starting with `_`.
- **Partial methods** — Pony's error mechanism has no C equivalent.
- **Methods with tuple parameters or return types** — Pony tuples have no direct C representation.
- **Bare methods** (`@`) — already use the C calling convention by definition.
- **Generic methods** — there is no way to determine which concrete types to instantiate.

If every public method on an exported type falls into one of these categories, the compiler reports an error: the type has no exportable methods.

## Primitives

Pony primitives are stateless singletons. When the compiler generates a wrapper for a primitive method, it omits the `self` parameter from the C signature and supplies the singleton internally. The C caller does not need to obtain or pass a receiver:

```pony
--8<-- "c-ffi-exporting-primitive.pony"
```

The generated C declarations for `Math` have no `self` parameter:

```c
extern int64_t Math_add(int64_t x, int64_t y);
extern int64_t Math_mul(int64_t x, int64_t y);
```

For classes, structs, and actors, the first parameter is `void* pony_this` — the Pony object the method is called on:

```c
extern int64_t Adder_add(void* pony_this, int64_t x);
extern int64_t Adder_base(void* pony_this);
```

## Exporting generic types

A generic type cannot be annotated with `\c_api\` directly — there is no way to determine which type arguments to use. Instead, create a type alias that pins the type parameters to concrete types, and annotate the alias:

```pony
--8<-- "c-ffi-exporting-generic-alias.pony"
```

The alias name becomes the type name in the C symbols:

```c
extern int64_t BoxedI64_get(void* pony_this);
extern int64_t BoxedI64_add(void* pony_this, int64_t y);
```

The alias must refer to a single concrete type — not a union or intersection — and the underlying type must be a class, primitive, struct, or actor.

## Type mapping

Pony types map to C types in the generated header as follows:

| Pony type | C type |
|---|---|
| `Bool` | `bool` |
| `I8` / `I16` / `I32` / `I64` | `int8_t` / `int16_t` / `int32_t` / `int64_t` |
| `I128` | `__int128_t` |
| `ILong` | `long` |
| `ISize` | `intptr_t` |
| `U8` / `U16` / `U32` / `U64` | `uint8_t` / `uint16_t` / `uint32_t` / `uint64_t` |
| `U128` | `__uint128_t` |
| `ULong` | `unsigned long` |
| `USize` | `size_t` |
| `F32` / `F64` | `float` / `double` |
| `None` | `void` |
| Any other type | `void*` |

## Working with C shims

The generated header is written to the output directory before C shim files are compiled. Packages that `use` a package with exports get `-I<output-dir>` added to their C compiler flags automatically, so `#include "mylib_export.h"` resolves without any `cincludedir:` configuration.

A typical pattern: a Pony library package annotates its types with `\c_api\`, and a consuming package provides a C shim that includes the generated header, defines C functions, and calls the exported wrappers. The Pony code in the consuming package then calls those C functions via FFI.
