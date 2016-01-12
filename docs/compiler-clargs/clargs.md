# Compiler args

`ponyc`, the compiler, supports the following options:
  `ponyc [OPTIONS] <package directory>`

The package directory defaults to the current directory.

## Options

*  `--version`, `-v`   Print the version of the compiler and exit.
*  `--debug`, `-d`     Don't optimise the output.
*  `--define`, `-D`    Define the specified build flag.
    * =name
*  `--strip`, `-s`     Strip debug info.
*  `--path`, `-p`      Add an additional search path.
    *  =path         Used to find packages and libraries.
*  `--output`, `-o`    Write output to this directory.
    *  =path         Defaults to the current directory.
*  `--library`, `-l`   Generate a C-API compatible static library.
*  `--docs`, `-g`      Generate code documentation.

Rarely needed options:

*  `--safe`        Allow only the listed packages to use C FFI.
    *  =package      With no packages listed, only builtin is allowed.
*  `--ieee-math`   Force strict IEEE 754 compliance.
*  `--cpu`         Set the target CPU.
    * =name         Default is the host CPU. Use a name valid for `clang/gcc -mcpu=`
*  `--features`    CPU features to enable or disable.
    *  =+this,-that  Use `+` to enable, `-` to disable.
*  `--triple`      Set the target triple.
    *  =name         Defaults to the host triple.
*  `--stats`       Print some compiler stats.

# Debugging options

* `--pass`, `-r`      Restrict phases.
    *  `=parse`
    *  `=syntax`
    *  `=sugar`
    *  `=scope`
    *  `=import`
    *  `=name`
    *  `=flatten`
    *  `=traits`
    *  `=docs`
    *  `=expr`
    *  `=final`
    *  `=ir`           Output LLVM IR.
    *  `=bitcode`      Output LLVM bitcode.
    *  `=asm`          Output assembly.
    *  `=obj`          Output an object file.
    *  `=all`          The default: generate an executable.
*  `--ast`, `-a`       Output an abstract syntax tree for the whole program.
*  `--astpackage`    Output an abstract syntax tree for the main package.
*  `--trace`, `-t`     Enable parse trace.
*  `--width`, `-w`     Width to target when printing the AST.
    * =columns      Defaults to the terminal width.
*  `--immerr`        Report errors immediately rather than deferring.
*  `--verify`        Verify LLVM IR.
*  `--files`         Print source file names as each is processed.
*  `--bnf`           Print out the Pony grammar as human readable BNF.
*  `--antlr`         Print out the Pony grammar as an ANTLR file.

# Runtime options for Pony programs (not for use with ponyc)

* `--ponythreads=N`   Use N scheduler threads. Defaults to the number of
                  cores (not hyperthreads) available.
* `--ponycdmin=N`     Defer cycle detection until 2^N actors have blocked.
                  Defaults to 2^4.
*  `--ponycdmax=N`     Always cycle detect when 2^N actors have blocked.
                  Defaults to 2^18.
* `--ponycdconf=N`    Send cycle detection CNF messages in groups of 2^N.
                  Defaults to 2^6.
* `--ponygcinitial=N` Defer garbage collection until an actor is using at
                  least 2^N bytes. Defaults to 2^14.
* `--ponygcfactor=N`  After GC, an actor will next be GC'd at a heap memory
                  usage N times its current value. This is a floating
                  point value. Defaults to 2.0.
* `--ponynoyield`   Do not yield the CPU when no work is available.
                  
