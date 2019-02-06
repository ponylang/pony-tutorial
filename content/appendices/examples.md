---
title: "Examples"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 40
toc: true
---

Small _how do I_ examples for Pony. These will eventually find another home. Until then, they live here.

## Enum with values
```pony
primitive Black fun apply(): U32 => 0xFF000000
primitive Red   fun apply(): U32 => 0xFFFF0000
```

## Enum with values with namespace
```pony
primitive Colours
  fun black(): U32 => 0xFF000000
  fun red(): U32 => 0xFFFF0000
```

## Enum which can be iterated
```pony
primitive Black
primitive Blue
primitive Red
primitive Yellow

type Colour is (Black | Blue | Red | Yellow)

primitive ColourList
  fun tag apply(): Array[Colour] =>
    [Black; Blue; Red; Yellow]

for colour in ColourList().values() do
end
```

## Read struct values from FFI
If you have a C struct which returns a struct with data like this
```c
typedef struct {
  uint8_t code;
  float x;
  float y;
} EGLEvent;

EGLEvent getEvent() {
    EGLEvent e = {1, ev.xconfigure.width, ev.xconfigure.height};
    return e;
}

```
the you can destructure it and get the values using a tuple
```pony
type EGLEvent is (U8, F32, F32)
(var code, var x, var y) = @getEvent[EGLEvent]()
```

## Get and pass pointers to FFI
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

## Pass an Array of values to FFI (TODO)
```pony
primitive _EGLConfigHandle
let a = Array[U16](8)
a.push(0x3040)
a.push(0x4)
a.push(0x3033)
a.push(0x4)
a.push(0x3022)
a.push(0x8)
a.push(0x3023)
a.push(0x8)
a.push(0x3024)
let config = Pointer[_EGLConfigHandle]
if @eglChooseConfig[U32](e_dpy, a, config, U32(1), Pointer[U32]) == 0 then
    env.out.print("eglChooseConfig failed")
end
```

## How to access command line arguments
```pony
actor Main
  new create(env: Env) =>
    // The no of arguments
    env.out.print(env.args.size().string())
    for value in env.args.values() do
      env.out.print(value)
    end
    // Access the arguments the first one will always be the application name
    try env.out.print(env.args(0)?) end
```

## How to use cli to parse command line arguments

```pony
use "cli"

actor Main
  new create(env: Env) =>
    let command_spec =
      try
        CommandSpec.leaf(
          "pony-embed",
          "sample program",
          [ OptionSpec.string("output", "output filename", 'o') ],
          [ ArgSpec.string("input", "source of input" where default' = "-") ]
        )? .> add_help()?
      else
        env.exitcode(1)
        return
      end
    let command =
      match CommandParser(command_spec).parse(env.args, env.vars)
      | let c: Command => c
      | let ch: CommandHelp =>
        ch.print_help(env.out)
        env.exitcode(0)
        return
      | let se: SyntaxError =>
        env.err.print(se.string())
        env.exitcode(1)
        return
      end
    let input_source = command.arg("input").string()
    let output_filename = command.option("output").string()
    env.out.print("Loading data from " + input_source + ". Writing output to " + output_filename)
    // ...
```

## How to write tests
Just create a test.pony file
```pony
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestAddition)

class iso _TestAddition is UnitTest
  """
  Adding 2 numbers
  """
  fun name(): String => "u32/add"

  fun apply(h: TestHelper): TestResult =>
    h.expect_eq[U32](2 + 2, 4)
```

Some assertions you can make with the TestHelper are
```pony
fun tag log(msg: String, verbose: Bool = false)
be fail() =>
be assert_failed(msg: String) =>
fun tag assert_true(actual: Bool, msg: String = "") ?
fun tag expect_true(actual: Bool, msg: String = ""): Bool
fun tag assert_false(actual: Bool, msg: String = "") ?
fun tag expect_false(actual: Bool, msg: String = ""): Bool
fun tag assert_error(test: ITest, msg: String = "") ?
fun tag expect_error(test: ITest box, msg: String = ""): Bool
fun tag assert_is (expect: Any, actual: Any, msg: String = "") ?
fun tag expect_is (expect: Any, actual: Any, msg: String = ""): Bool
fun tag assert_eq[A: (Equatable[A] #read & Stringable)]
  (expect: A, actual: A, msg: String = "") ?
fun tag expect_eq[A: (Equatable[A] #read & Stringable)]
  (expect: A, actual: A, msg: String = ""): Bool
```

## Operator overloading (easy for copy and paste)
```pony
fun add(other: A): A
fun sub(other: A): A
fun mul(other: A): A
fun div(other: A): A
fun rem(other: A): A
fun mod(other: A): A
fun eq(other: A): Bool
fun ne(other: A): Bool
fun lt(other: A): Bool
fun le(other: A): Bool
fun ge(other: A): Bool
fun gt(other: A): Bool
fun shl(other: A): A
fun shr(other: A): A
fun op_and(other:A): A
fun op_or(other: A): A
fun op_xor(othr: A): A
```

## Create empty functions in a class
```pony
class Test
  fun alpha() =>
    """
    """
  fun beta() =>
    """
    """
```

## How to create Arrays with values

Single values can be separated by semicolon or newline.

```pony
let dice: Array[U32] = [1; 2; 3
  4
  5
  6
]
```

## How to modify a lexically captured variable in a closure

```pony
actor Main
  fun foo(n:U32): {ref(U32): U32} =>
    var s: Array[U32] = Array[U32].init(n, 1)
    {ref(i:U32)(s): U32 =>
      try
        s(0) = s(0) + i
        s(0)
      else
        0
      end
    }

  new create(env:Env) =>
    var f = foo(5)
    env.out.print(f(10).string())
    env.out.print(f(20).string())
```
