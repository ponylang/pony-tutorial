# Keywords

This listing explains the usage of every Pony keyword.

|Keyword | Usage|
| --- | --- |
| actor | defines an actor
| as | conversion of a value to another Type (can raise an error)
| be | behavior, executed asynchronously
| box | default reference capability – object is readable, but not writable
| break | to step out of a loop statement
| class | defines a class
| compile_error | will provoke a compile error 
| continue | continues a loop with the next iteration
| consume | move a value to a new variable, leaving the original variable empty
| do | loop statement, or after a with statement
| else | conditional statement in if, for, while, repeat, try (as a catch block), match 
| elseif | conditional statement, also used with ifdef
| embed | embed a class as a field of another class
| end | ending of: if then, ifdef, while do, for in, repeat until, try, object, lambda, recover, match
| error | raises an error
| for | loop statement
| fun | define a function, executed synchronously
| if  | (1) conditional statement
|     | (2) to define a guard in a pattern match
| ifdef | when defining a build flag at compile time:  ponyc –D "foo"
| in | used in a for in - loop statement
| interface | used in structural subtyping
| is | (1) used in nominal subtyping
|    | (2) in type aliasing
| iso | reference capability – read and write uniqueness
| lambda | to make a closure
| let | declaration of immutable variable: you can't rebind this name to a new value
| match | pattern matching
| new | constructor
| object | to make an object literal
| primitive | declares a primitive type
| recover | removes the reference capability of a variable
| ref | reference capability – object (on which function is called) is mutable
| repeat | loop statement
| return | to return early from a function
| tag | reference capability – neither readable nor writeable, only object identity
| then | (1) in if conditional statement 
|      | (2) as a (finally) block in try
| this | the current object
| trait | used in nominal subtyping:  class Foo is TraitName
| trn | reference capability – write uniqueness, no other actor can write to the object
| try | error handling
| type | to declare a type alias
| until | loop statement
| use | (1) using a package
|     | (2) using an external library foo: use "lib:foo"
|     | (3) declaration of an FFI signature
|     | (4) add a search path for external libraries: use "path:/usr/local/lib"
| var | declaration of mutable variable: you can rebind this name to a new value
| val | reference capability – globally immutable object
| where | when specifying named arguments 
| while | loop statement
| with  | ensure disposal of an object