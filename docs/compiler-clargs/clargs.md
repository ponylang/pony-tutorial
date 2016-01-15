# Compiler args

`ponyc`, the compiler, is usually called in the project directory,
where it finds the `.pony` files and its dependencies
automatically. There it will create the binary based on the directory
name. You can override this and tune the compilation with several
options as described via `ponyc --help` and you can pass a seperate
source directory as argument.

   `ponyc [OPTIONS] <package directory>`

The most useful options are `--debug`, `--path` or just `-p`,
`--output` or just `-o` and `--docs` or `-g`. With `-l` you can
generate a C library, `lib<directory>`.

`--debug` will skip the LLVM optimizations passes. This should not be
mixed up with `make config=debug`, the default make configuration
target. `config=debug` will create DWARF symbols, and add slower
assertions to ponyc, but not to the generated binaries. For those you
can omit DWARF symbols with the `--strip` or `-s` option.

`--path` or `-p` take a `:` seperated pathlist as argument, and adds
those to the compile-time library paths for the linker to find source
packages and the native libraries, static or dynamic, being linked at
compile-time or via the FFI at run-time. The system adds several paths
already, e.g. on windows it queries the registry to find the compiler
run-time paths, you can also use `use "lib:path"` statements in the
source code and as final possibility you can add `-p` paths. But if
you want the generated binary to accept such a path to find a dynamic
library at your client system, you need to handle that in your source
code by yourself. See the `options` package for this.

`--output` or `-o` takes a directory name where the final binary is
created.

`--docs` or -`g` dumps the list of classes, actors and types with some
warnings to stdout. This can be used to created documentation, but also
TAGS, or help the [editor](../getting-started/what-you-need-to-start).

Note that there is _no builtin debugger_ to interactively step through
your program and interpret the results. But ponyc creates proper DWARF
symbols and you can step through your programs with a conventional
debugger, such as gdb or lldb.


# Runtime options for Pony programs

Besides using the `options` package, there are also several builtin
options for the generated binary (_not for use with ponyc_) starting
with `--pony*`, see `ponyc --help`, to tweak runtime performance. You
can override the number of initial threads, tune cycle detection
(_CD_), the garbage collector and even turn off yield, which is not
really recommended.
