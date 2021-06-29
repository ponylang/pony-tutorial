# Delegating and restricting authority

> ## [Plan]
>
> * demonstrate basic use in combination with file system access etc.
> * show how a derived authority can be constructed
> * refer to the patterns for more complex scenarios
>
> ## [TODO]
>
> * [ ] come up with a better title for the section
> * [ ] toc stuff and linking

Any interesting program will need to interact with the outside world by using operating system concepts, like accessing the network or the file system, or by creating and communicating with other programs.
The operating system has granted the right to do so to the program at startup (but it might do some checks at runtime, for example controlling access to a file). This is called __ambient authority__.

The operating system has no concept of how our program is composed inside, and it knows nothing about Pony specific concepts in particular. Pony requires operations which interact with the system
to be authorized, and allows us to restrict and delegate this authority inside our program.

Recall the definition of capability from [ref]:

> A capability is an unforgeable token that (a) designates an object and (b) gives the program the authority to perform a specific set of actions on that object.

In Pony, the Main actor is passed the environment object, which keeps an `AmbientAuth` in the `root` field. This value is the capability that represents the ambient authority given to us by the system.
Instead of allowing unfettered access to the outside world, Pony enforces the use of this authority.

Here is a simple program that connects to example.com via TCP on port 80 and quits:

```pony
use "net"

class MyTCPConnectionNotify is TCPConnectionNotify
  let _out: OutStream

  new iso create(out: OutStream) =>
    _out = out

  fun ref connected(conn: TCPConnection ref) =>
    _out.print("connected")
    conn.close()

  fun ref connect_failed(conn: TCPConnection ref) =>
    _out.print("connect_failed")

actor Connect
  new create(out: OutStream, auth: AmbientAuth) =>
    TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")

actor Main
  new create(env: Env) =>
    try Connect(env.out, env.root as AmbientAuth) end
```

The Main actor authorizes the Connect actor by passing the ambient authority token on to it. This token is not forgeable since the `AmbientAuth` constructor is private—only the runtime glue code
can create the one and only instance.

The Connect actor uses this authority when it creates a TCP connection:

```pony
TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")
```

The TCPConnection requires an authority as first parameter, and since the compiler checks that
the correct type was passed, this guarantees that a TCPConnection can only be created by an
actor holding the required authorization. If you look into the implementation of the `TCPConnection`
constructor, you will notice that the authorization is not even used beyond the declaration of the
parameter.

## Restrict, then delegate your authority

In order to handle our own code and that of others more safely, and also to understand our code better,
we want to split up the authority, and only grant the particular authority a piece of code actually
requires.

Imagine we don't trust the `Connect` actor, so we don't want to provide it with more authority
than needed. For example, there is no point in granting it filesystem access.

The first parameter of the `TCPConnection` constructor has the type

```pony
type TCPConnectionAuth is (AmbientAuth | NetAuth | TCPAuth | TCPConnectAuth)
```

This looks like a nice hierarchy of authority, in order of decreasing rights. We can pass
a reduced authority to our `Connect` actor like this:

```pony
actor Connect
  new create(out: OutStream, auth: TCPConnectionAuth) =>
    TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")

actor Main
  new create(env: Env) =>
    try Connect(env.out, TCPConnectAuth(env.root as AmbientAuth)) end
```

Now we are sure it cannot access the filesystem or listen on a TCP or UDP port. This is possible
because there is a `TCPConnectAuth` constructor which accepts the AmbientAuth.

You can see this pattern over and over in the standard library.

## Authorization-friendly interface

Consider the above example again, but this time let's treat the `Connect` actor as coming from
a 3rd party package. If the author of that package had not considered which authority exactly
was necessary, it would not be possible to restrict the authoritization given to its code.
A function with an `AmbientAuth` parameter will not accept a lesser auth token.

Therefore it is necessary to design your packages and functions with this in mind.
