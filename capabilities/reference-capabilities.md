# Reference Capabilities

So if the object _is_ the capability, what controls what we can do with the 
object? How do we express our _access rights_ on that object?

In Pony, we do it with _reference capabilities_.

## Rights are part of a capability

If you open a file in UNIX, and get a file descriptor back, that file 
descriptor is token that designates an object - but it isn't a capability. To 
be a capability, we need to open that file with some permission - some access 
right. For example:

```C
int fd = open("/etc/passwd", O_RDWR);
```

Now we have a token, and a set of rights.

In Pony, every reference has both a type and a reference capability. In fact, 
the reference capability is _part_ of its type. These allow you to specify 
which of your objects can be shared with other actors and allow the compiler to 
check that what you're doing is concurrency safe.

## Basic concepts

There are a few simple concepts you need to understand before reference 
capabilities will make any sense. We've talked about some of these already, and 
some may already be obvious to you, but it's worth recapping here.

__Shared mutable data is hard__

The problem with concurrency is shared mutable data. If two different threads 
have access to the same piece of data then they might try to update it at the 
same time. At best this can lead to the two threads having different versions 
of the data. At worst the updates can interact badly resulting in the data 
being overwritten with garbage. The standard way to avoid these problems is to 
use locks to prevent data updates from happening at the same time. This causes 
big performance hits and is very difficult to get right, so it causes lots of 
bugs.

__Immutable data can be safely shared__

Any data that is immutable (i.e. it cannot be changed) is safe to use 
concurrently. Since it is immutable it is never updated and it's the updates 
that cause concurrency problems.

__Isolated data is safe__

If a block of data has only one reference to it then we call it __isolated__. 
Since there is only one reference to it, isolated data cannot be __shared__ by 
multiple threads, so there are no concurrency problems. Isolated data can be 
passed between multiple threads. As long as only one of them has a reference to 
it at a time then the data is still safe from concurrency problems.

__Isolated data may be complex__

An isolated piece of data may be a single byte. But it can also be a large data 
structure with multiple references between the various objects in that 
structure. What matters for the data to be isolated is that there is only a 
single reference to that structure as a whole. We talk about the 
__isolation boundary__ of a data structure. For the structure to be isolated:

1. There must only be a single reference outside the boundary that points to an 
object inside.
1. There can be any number of references inside the boundary, but none of them 
must point to an object outside.

__Every actor is single threaded__

The code within a single actor is never run concurrently. This means that, 
within a single actor, data updates cannot cause problems. It's only when we 
want to share data between actors that we have problems.

__OK, safely sharing data concurrently is tricky. How do reference capabilities 
help?__

By sharing only immutable data and exchanging only isolated data we can have 
safe concurrent programs without locks. The problem is that it's very difficult 
to do that correctly. If you accidentally hang on to a reference to some 
isolated data you've handed over or change something you've shared as immutable 
then everything goes wrong. What you need is for the compiler to force you to 
live up to your promises. Pony reference capabilities allow the compiler to do 
just that.

## Type qualifiers

If you've used C/C++, you may be familiar with `const`, which is a _type 
qualifier_ that tells the compiler not to allow the programmer to _mutate_ 
something.

A reference capability is a form of _type qualifier_ and provides a lot more 
guarantees than `const` does!

In Pony, every use of a type has a reference capability. These capabilities 
apply to variables, rather than to the type as a whole. In other words, when 
you define a `class Wombat`, you don't pick a reference capability for it. 
Instead, `Wombat` variables each have their own reference capability.

As an example, in some languages you have to define a type that represents a 
mutable `String` and another type that represents an immutable `String`. For 
example, in Java there is a `String` and a `StringBuilder`. In Pony, you can 
define a single `class String` and have some variables that are `String ref` 
(which are mutable) and other variables that are `String val` (which are 
immutable).

## The list of reference capabilities

There are six reference capabilities in Pony and they all have strict 
definitions and rules on how they can be used. We'll get to all of that later, 
but for now here are their names and what you use them for:

__Isolated__, written `iso`. This is for references to isolated data 
structures. If you have an `iso` variable then you know that there are no other 
variables that can access that data. So you can change it however you like and 
give it to another actor.

__Value__, written `val`. This is for references to immutable data structures. 
If you have a `val` variable then you know that no-one can change the data. So 
you can read it and share it with other actors.

__Reference__, written `ref`. This is for references to mutable data structures 
that are not isolated, in other words "normal" data. If you have a `ref` 
variable then you can read and write the data however you like and you can have 
multiple variables that can access the same data. But you can't share it with 
other actors.

__Box__. This is for references to data that is read-only to you. That data 
might be immutable and shared with other actors or there may be other variables 
using it in your actor that can change the data. Either way the `box` variable 
can be used to safely read the data. This may sound a little pointless, but it 
allows you to write code that can work for both `val` and `ref` variables, as 
long as it doesn't write to the object.

__Transition__, written `trn`. This is used for data structures that you want 
to write to and give out read-only (`box`) variables to. You can also convert 
the `trn` variable to a `val` variable later if you wish, which stops anyone 
from changing the data and allows it be shared with other actors.

__Tag__. This is for references used only for identification. You cannot read 
or write data using a `tag` variable. But you can store and compare `tag`s to 
check object identity and share `tag` variables with other actors.

Note that if you have a variable referring to an actor then you can send 
messages to that actor regardless of what reference capability that variable 
has.

## How to write a reference capability

A reference capability comes at the end of a type. So, for example:

```pony
String iso // An isolated string
String trn // A transition string
String ref // A string reference
String val // A string value
String box // A string box
String tag // A string tag
```

__What does it mean when a type doesn't specify a reference capability?__ It 
means you are using the _default_ reference capability for that type, which is 
defined along with the type. Here's an example from the standard library:

```pony
class val String
```

When we use a `String` we usually mean a string value, so we make `val` the 
default reference capability for `String`.

__So do I have to specify a reference capability when I define a type?__ Only 
if you want to. There are sensible defaults that most types will use. These are 
`ref` for classes, `val` for primitives (i.e. immutable references) and `tag` 
for actors. So the default for any mutable reference capability is `iso` and the
default for any immutable reference capability is `val`.
