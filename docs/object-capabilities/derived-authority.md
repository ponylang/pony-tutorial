# Delegating and restricting authority

Any interesting program will need to interact with the outside world, like accessing the network or the file system, or by creating and communicating with other programs.
We call __ambient authority__ all those rights implicitly granted to the program to make these things possible, and because Pony makes this concept *explicit*, we need to take
the time to talk about what it means and how it works. In other languages like for example C, you can always attempt to do an operation like I/O, and it will usually succeed
save some runtime checks (your disk being full might make an operation fail, for example). But in Pony, any piece of code interacting with the outside world needs the authority to do so.

The operating system essentially knows nothing about the structure of any program it runs, in particular it is ignorant of any Pony specific concepts.
In order to impose that some code is authorized for an operation like writing to disk, Pony requires a special argument to be passed, a capability bearing the authority required for the
task at hand. The type system guarantees that inadequate capabilities for a task fail at compile time.

Recall the definition of capability from the [Object Capabilities](/object-capabilities/object-capabilities.md) section:

> A capability is an unforgeable token that (a) designates an object and (b) gives the program the authority to perform a specific set of actions on that object.

In Pony, the `Main` actor is created with an `Env` object, which holds the unforgeable `AmbientAuth` token in its root field.
This value is the capability that represents the ambient authority given to us by the system.

Here is a program that connects to example.com via TCP on port 80 and quits:

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

The `Main` actor authorizes the `Connect` actor by passing the ambient authority token on to it. This token is unforgeable since the `AmbientAuth` constructor is private and the only existing
instance is provided by the runtime itself.

The `Connect` actor uses this authority when it creates a TCP connection:

```pony
TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")
```

The `TCPConnection` requires an authority as first parameter, and since the compiler checks that
the correct type was passed, this guarantees that a `TCPConnection` can only be created by an
actor holding the required authorization.

The implementation of the `TCPConnection` constructor does not even use the authorization parameter
at run time, all it does is require it to be of the right type. The type checking done by the compiler
is sufficient for this guarantee.

## Restrict, then delegate your authority

In order to handle our own code and that of others more safely, and also to understand our code better,
we want to split up the authority, and only grant the particular authority a piece of code actually
requires.

Imagine we don't trust the `Connect` actor, so we don't want to provide it with more authority
than needed. For example, there is no point in granting it filesystem access, since it is supposed
to do network things (specifically, TCP), not access the filesystem. To understand how we can achieve this,
let's look at the authority types involved.

The first parameter of the `TCPConnection` constructor has the type

```pony
type TCPConnectionAuth is (AmbientAuth | NetAuth | TCPAuth | TCPConnectAuth)
```

so instead of passing the entire `AmbientAuth` (the root of all authority), we can "downgrade" that to a
`TCPConnectAuth` (the most restrictive authority in `net`), pass it to the `Connect` actor, and have
that pass it to the `TCPConnection` constructor:

```pony
actor Connect
  new create(out: OutStream, auth: TCPConnectionAuth) =>
    TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")

actor Main
  new create(env: Env) =>
    try Connect(env.out, TCPConnectAuth(env.root as AmbientAuth)) end
```

Now we are sure it cannot access the filesystem or listen on a TCP or UDP port.

## Authorization-friendly interface

Consider the above example again, but this time let's think of the `Connect` actor being part
of a 3rd party package that we are building. Our goal is to write the actor in such a way that
users of our package can grant it only the authority necessary for it to function.

As the package author, it is then our responsibility to realize that the minimal authority
possible is the `TCPConnectAuth`. But anything that the `TCPConnection` constructor accepts
is valid, and a user of our package might be strict and pass a `TCPConnectAuth`, or might
be lax and just pass the `AmbientAuth`.

Our current implementation already satisfies all this, because `TCPConnectionAuth` is a union
type of all possible authorization types and we use that. If we want, we could also write

```pony
type ConnectActorAuth is TCPConnectionAuth
```

and use this type alias instead, signalling to the user that anything that is a `TCPConnectionAuth`
is allowed as the authority token passed to the `Connect` actor.

## Authority hierarchies

Looking again at the type of the authorization parameter to `TCPConnection`,

```pony
type TCPConnectionAuth is (AmbientAuth | NetAuth | TCPAuth | TCPConnectAuth)
```

you might notice that this looks like a hierarchy of authorities:

`AmbientAuth >> NetAuth >> TCPAuth >> TCPConnectAuth`

where in this paragraph, ">>" means "grants at least as much authority as". In fact, the `AmbientAuth`
encompasses all ambient authority and is a strictly larger authority than `NetAuth`, which grants
access to the network, which is more powerful than `TCPAuth` which is restricted to the TCP
protocol. Finally, `TCPConnectAuth` is good only for creating a `TCPConnection`.

This hierarchy is established by means of the constructor of the weaker authority accepting one
of the stronger authorities, for example

```pony
new val create(from: (AmbientAuth val | NetAuth val)) : TCPAuth val^
```
