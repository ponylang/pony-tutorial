# C Shims

Sometimes the easiest way to call C from Pony is a small piece of C of your own that bridges the gap: a wrapper that flattens a macro into a function, fixes up a calling convention, or adapts a struct-heavy API into something the FFI can call directly. ponyc can compile that C for you.

A `.c` file placed in a package's directory — next to its `.pony` files — is a _C shim_. ponyc discovers it, compiles it with an embedded copy of clang, and links the resulting object directly into your program. There is no second build system, no separate compiler invocation, and no library to link with `use "lib:..."`.

A shim is for that kind of glue — code that helps your Pony talk to C — not for writing a C library. If you're writing a library's worth of C, build it as a library and link it like any other: see [Linking to C Libraries](/c-ffi/linking-c.md).

## A minimal shim

Put a `.c` file next to your Pony code:

```c
// answer.c
#include <stdint.h>

int32_t answer(void)
{
  return 42;
}
```

Declare the function's FFI signature and call it, exactly as you would for any other C function (see [Calling C from Pony](/c-ffi/calling-c.md)):

```pony
--8<-- "c-shims-minimal.pony"
```

Compile with `ponyc` as usual. The shim is discovered, compiled, and linked automatically — the build reports a `Compiling C shims` step — and the program prints `42`. There is nothing else to set up.

## ponyc headers on the include path

A shim can `#include <pony.h>` and call runtime APIs with no configuration. ponyc puts its own headers on the include path by default and locates them relative to the running compiler, the same way it finds the standard library. A shim that talks to the runtime keeps working across toolchain updates without hard-coding an installation path.

## Configuring the compile

The minimal shim above needed no configuration. When a shim needs a preprocessor macro or an external header, two `use` schemes supply them; each affects only the package it appears in, and both accept guards, just like platform-specific linking.

`use "cdefine:NAME"` or `use "cdefine:NAME=VALUE"` defines a C preprocessor macro (clang's `-D`). The macro name must be a plain C identifier; function-like macros such as `cdefine:CALLBACK(x)=...` are rejected — define a plain macro and let your C code do the rest. Defining the same name twice in one package is an error, even when the values match. Platform-specific values belong behind guards, where only the active target's definition counts:

```pony
use "cdefine:USE_EPOLL" if linux
```

`cdefine:` is unrelated to ponyc's own `--define`/`-D` flag, which drives Pony's `ifdef`. One sets a C preprocessor macro for your shims; the other selects Pony build flags.

`use "cincludedir:PATH"` adds an include search directory (clang's `-I`). A relative path is resolved against the package's directory.

A `cdefine:` or `cincludedir:` in a package that has no `.c` files is an error: it could never take effect. If you hit this, the scheme is probably in the wrong package — move it to the one that holds the `.c` it was meant to configure.

### Putting it together

This program defines a macro with `cdefine:` and adds a header directory with `cincludedir:`:

```pony
--8<-- "c-shims-configured.pony"
```

The shim reads both — the macro from `cdefine:`, and a constant from a header found via `cincludedir:`:

```c
// answer.c
#include <stdint.h>
#include "version.h"

int32_t answer(void)
{
  return ANSWER;
}

int32_t version(void)
{
  return VERSION;
}
```

```c
// include/version.h
#define VERSION 7
```

These files sit together, with the header in the `include/` directory named by `cincludedir:`:

```text
main.pony
answer.c
include/version.h
```

Building and running prints `answer: 42` and `version: 7`. `answer` returns the macro set by `cdefine:`; `version` returns the constant from the header found via `cincludedir:`.

That is everything you need to write and build a shim. The rest of this page is reference material — how shims are discovered and linked, how `--safe` applies, and which platforms are supported.

## How shims are discovered

ponyc scans only the top directory of each package — not its subdirectories — in sorted order for reproducible builds. Only `.c` files are treated as shims; C++ sources (`.cpp`, `.cc`) are not compiled this way, so for C++ you build a library and link it (see [Linking to C Libraries](/c-ffi/linking-c.md)).

Every `.c` in the package directory is compiled on every platform: the shim sources themselves have no per-file guard. A shim that should only exist on one platform wraps its whole body in `#ifdef` so it compiles to an empty object elsewhere:

```c
#ifdef __linux__
// ... the platform-specific shim ...
#endif
```

## How shims are linked

Shim objects are linked directly into your program, not archived into a library first. Two consequences are worth knowing:

* C constructors (`__attribute__((constructor))`) in a shim run at program start, like any directly linked object.
* Two shims that define the same symbol fail the link with a duplicate-definition error. But if a shim defines a symbol that a `use "lib:..."` library also provides, the shim wins silently — the library's version is never pulled in.

## Replacing a hand-built library

ponyc compiling a `.c` as a shim can silently shadow a library you built by hand. If you previously compiled a `.c` next to your Pony code into a library and linked it with `use "lib:..."`, ponyc now compiles that same file as a shim, and the shim object wins over your hand-built library. Either drop the manual build and the `use "lib:..."` that linked it — the shim path replaces both — or move the `.c` out of the package directory. Only the package's top directory is scanned, so a subdirectory is enough to keep it out.

## Restricting C with `--safe`

A C shim is the package doing C, so `--safe` governs it exactly like a C FFI call: compiling a shim requires the package to be allowed to do C FFI. A `.c` in a package that isn't on the `--safe` list is an error — the same reason you would get one for an FFI call there. The file may sit in the package; `--safe` gates compiling it.

This matters for dependencies, too. A package you depend on can ship a `.c`, and ponyc compiles and links it into your program just like your own shim — so `--safe` is also how you control whether a dependency's C is built into your program.

## Platform support

Windows targets are not supported yet. A package containing a `.c` fails on Windows with `C shims are not yet supported when targeting Windows: MSVC include discovery is not implemented`, until that discovery lands. This includes any dependency you pull in that ships a shim.

On macOS, shims resolve system headers through the SDK's `usr/include`; framework-style includes (clang's `-F`) are not supported.

## Build artifacts

Shims are recompiled on every build. Their object files live in the output directory during the build and are cleaned up after a successful link. Under a non-link mode (`--pass c`, `--pass obj`, and similar) or after a failed link they stay behind, and renaming or deleting a shim source can leave an old object in the output directory. They are plain files, safe to delete.

Because ponyc now carries clang inside it, the compiler binary is noticeably larger than before.
