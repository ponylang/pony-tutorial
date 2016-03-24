When we talked about __reference capability composition__ and 
__viewpoint adaptation__, we dealt with cases where we know the reference 
capability of the origin. However, sometimes we don't know the precise 
reference capability of the origin.

When that happens, we can write a __viewpoint adapted type__, which we call an 
__arrow type__ because we write it with an `->`.

# Using `this->` as a viewpoint

A function with a `box` receiver can be called with a `ref` receiver or a `val` 
receiver as well, since those are both subtypes of `box`. Sometimes, we want to 
be able to talk about a type to take this into account. For example:

```pony
class Wombat
  var _friend: Wombat

  fun friend(): this->Wombat => _friend
```

Here, we have a `Wombat`, and every `Wombat` has a friend that's also a 
`Wombat` (lucky `Wombat`). In fact, it's a `Wombat ref`, since `ref` is the 
default reference capability for a `Wombat` (since we didn't specify one). We 
also have a function that returns that friend. It's got a `box` receiver 
(because `box` is the default receiver reference capability for a function if 
we don't specify it).

So the return type would normally be a `Wombat box`. Why's that? Because, as we 
saw earlier, when we read a `ref` field from a `box` origin, we get a `box`. In 
this case, the origin is the receiver, which is a `box`.

But wait! What if we want a function that can return a `Wombat ref` when the 
receiver is a `ref`, a `Wombat val` when the receiver is a `val`, and a 
`Wombat box` when the receiver is a `box`? We don't want to have to write the 
function three times.

We use `this->`! In this case, `this->Wombat`. It means "a `Wombat ref` as seen 
by the receiver".

We know at the _call site_ what the real reference capability of the receiver 
is. So when the function is called, the compiler knows everything it needs to 
know to get this right.

# Using a type parameter as a viewpoint

We haven't covered generics yet, so this may seem a little weird. We'll cover 
this again when we talk about generics (i.e. parameterised types), but we're 
mentioning it here for completeness.

Another time we don't know the precise reference capability of something is if 
we are using a type parameter. Here's an example from the standard library:

```pony
class ListValues[A, N: ListNode[A] box] is Iterator[N->A]
```

Here, we have a `ListValues` type that has two type parameters, `A` and `N`. In 
addition, `N` has a constraint: it has to be a subtype of `ListNode[A] box`. 
That's all fine and well, but we also say the `ListValues[A, N]` provides 
`Iterator[N->A]`. That's the interesting bit: we provide an interface that 
let's us iterate over values of the type `N->A`.

That means we'll be returning objects of the type `A`, but the reference 
capability will be the same as an object of type `N` would see an object of 
type `A`.

# Using `box->` as a viewpoint

There's one more way we use arrow types, and it's also related to generics. 
Sometimes we want to talk about a type parameter as it is seen by some unknown 
type, _as long as that type can read the type parameter_.

In other words, the unknown type will be a subtype of `box`, but that's all we 
know. Here's an example from the standard library:

```pony
interface Comparable[A: Comparable[A] box]
  fun eq(that: box->A): Bool => this is that
  fun ne(that: box->A): Bool => not eq(that)
```

Here, we say that something is `Comparable[A]` if and only if it has functions 
`eq` and `ne` and those functions have a single parameter of type `box->A` and 
return a `Bool`. In other words, whatever `A` is bound to, we only need to be 
able to read it.
