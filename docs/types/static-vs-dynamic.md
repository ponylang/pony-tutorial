Pony is a _statically typed_ language, like Java, C#, C++, and many others. This means the compiler knows the type of everything in your program. This is different from _dynamically typed_ languages, such as Python, Lua, Javascript, and Ruby.

# What's the difference?

In both kinds of language, your data has a type. So what's the difference?

With a _dynamically typed_ language, a variable can point to objects of different types at different times. This is flexible, because if you have a variable `x`, you can assign an integer to it, then assign a string to it, and your compiler or interpreter doesn't complain.

__But what if I try to do a string operation on `x` after assigning an integer to it?__ Generally speaking, your program will raise an error. You might be able to catch the error in some way, depending on the language, but if you don't, your program will crash.

When you use a _statically typed_ language, a variable has a type. That is, it can only point to objects of a certain type (although in Pony, a type can actually be a collection of types, as we'll see later). If you have an `x` that expects to point to an integer, you can't assign a string to it. Your compiler complains, and it complains __before__ you ever try to run your program.

# Types are guarantees

When the compiler knows what types things are, it can make sure some things in your program work without you having to run it or test it. These things are the _guarantees_ that a language's type system provides.

The more powerful a type system is, the more things it can prove about your program without having to run it.

__Do dynamic types make guarantees too?__ Yes, but they do it at runtime. For example, if you call a method that doesn't exist, you will usually get some kind of exception. But you'll only find out when you try to run your program.

# What guarantees does Pony's type system give me?

The Pony type system offers a lot of guarantees, even more than other statically typed languages.

* If your program compiles, it won't crash.
* There will never be an uncaught exception.
* There's no such thing as `null`, so your program will never try to dereference `null`.
* There will never be a data race.
* Your program will never deadlock.
* Your code will always be capabilities-secure.
* All message passing is causal.

Some of those will make sense right now. Some of them may not mean much to you yet (like capabilities security and causal messaging), but we'll get to those concepts later on.

__If I use Pony's FFI to call code written in another language, does Pony magically make the same guarantees for the code I call?__ Sadly, no. Pony's type system guarantees only apply to code written in Pony. Code written in other languages gets only the guarantees provided by that language.
