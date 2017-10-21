# Standard library

The Pony standard library is a collection of packages that can each be used as needed to provide a variety of functionality. For example, the __files__ package provides file access and the __collections__ package provides generic lists, maps, sets and so on.

There is also a special package in the standard library called __builtin__. This contains various types that the compiler has to treat specially and are so common that all Pony code needs to know about them. All Pony source files have an implicit `use "builtin"` command. This means all the types defined in the package builtin are automatically available in the type namespace of all Pony source files.

Documentation for the standard library is [available online](http://stdlib.ponylang.org/)

## A quick glance at the standard library

There is some package in the standard library that are so useful that deserve to be presented here.

### The debug package

The debug package is useful when you want to do print something without having to pass the ```Env``` around. To use the debug package just import and use it this way:

```pony
actor Main
  new create(env: Env) =>
    Debug.out("This will only bee seen when configured for debug info")
```

Note that for the debug statement to show up you will need to compile your program with the ```-d``` option.


### The itertools package

The itertools package is a really useful package when dealing with collections. If the words filter, map, fold and zip speak to you then take a look at this package. 
Here is a quick example that from start with an array of numbers, add one to each, then only keep the even ones and finally print each value.

```pony
use "itertools"

actor Main
  new create(env: Env) =>
    Iter[I64]([1; 2; 3; 4; 5].values())
      .map[I64]({(x) => x + 1 })
      .filter({(x) => (x % 2) == 0 })
      .map[None]({(x) => env.out.print(x.string()) })
      .run()
```

### The collections package

Speaking about collections it is worth taking a look at the package of the same name. The collections package contains the generic common containers such as List, HasMap, HashSet.

```pony
use "collections"

actor Main
  new create(env: Env) =>
    var a_list = List[I64].from([1; 2; 3; 4; 5])
    a_list.push(6)
    for elem in a_list.values() do
      env.out.print(elem.string())
    end
```

```pony
use "collections"

primitive StringHasher
  fun hash(str : String) : U64 =>
    str.hash()

  fun eq(str1 : String, str2 : String) : Bool =>
    str1 == str2

actor Main
  new create(env: Env) =>
    var inhabitants_count_per_country = HashMap[String, F32, StringHasher]
    
    inhabitants_count_per_country.update("France" , F32(70_000_000))
    inhabitants_count_per_country.update("USA" , F32(323_000_000))
    
    for (key, value) in inhabitants_count_per_country.pairs() do
      env.out.print(key + " has " + value.string() + " inhabitants")
    end
```

### The format package

The format package is used to control how numbers are displayed

```pony
use "format"

actor Main
  new create(env: Env) =>
    let the_answer = I32(42)
    env.out.print(the_answer.string()) // 42
    env.out.print(Format.int[I32](the_answer, FormatDefault )) //42
    env.out.print(Format.int[I32](the_answer, FormatHex)) //0x2A
    env.out.print(Format.int[I32](the_answer, FormatOctal)) //0o52
    env.out.print(Format.int[I32](the_answer, FormatBinary)) //0b101010
```

### The regex package

Obviously, the regex package deals with regular expressions.

```pony
use "regex"

actor Main
  new create(env: Env) =>
    try
      let r = Regex("pony is .*")?
      let result = r.replace("pony is a kind of horse", "awesome")?
      env.out.print("pony is" + result.clone())
    end
```

### The file package

The file package is pretty much what you expect. It deals with files and directories.

```pony
use "files"

actor Main
  new create(env: Env) =>
    try
      for file_name in env.args.slice(1).values() do
        let path = FilePath(env.root as AmbientAuth, file_name)?
        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            env.out.write(file.read(1024))
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end
      end
    end
```

### The time package

The time package deals with date and time. This is interesting because scheduling is not preemptive in Pony.
So if you want an actor to do a bit of work regularly, timers provide a good foundation for that.

```pony
use "time"

// Count from 0 to 10 with a 1 second pause interleaved.

actor Main
  new create(env: Env) =>
    let timers = Timers
    let timer = Timer(Notify(env), 0, 1_000_000_000)
    timers(consume timer)

class Notify is TimerNotify
  let _env: Env
  var _counter: U32 = 0

  new iso create(env: Env) =>
    _env = env

  fun ref apply(timer: Timer, count: U64): Bool =>
    _env.out.print(_counter.string())
    _counter = _counter + 1
    if (_counter > 10) then
        false
    else
        true
    end
```

### Others packages

This is enough for an introduction but as you will explore Pony you may find other packages really helpful.
The different net packages are used for anything that is network related.
The promise package will help you collect result of work done by others actor. The options one will help you parse and manage arguments from the command line.
The random package allow you to play Russian roulette. The crypto package contains the common hashing function.
There is much more. Don't forget to check them out.
