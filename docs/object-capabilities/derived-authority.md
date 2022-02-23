# Delegating and restricting authority

Any interesting program will need to interact with the outside world, like accessing the network or the file system, or by creating and communicating with other programs. We call __ambient authority__ all those rights implicitly granted to the program to make these things possible, and because Pony makes this concept *explicit*, we need to take the time to talk about what it means and how it works. In other languages like for example C, you can always attempt to do an operation like I/O, and it will usually succeed save some runtime checks (your disk being full might make an operation fail, for example). But in Pony, any piece of code interacting with the outside world needs the authority to do so.

The operating system essentially knows nothing about the structure of any program it runs, in particular it is ignorant of any Pony specific concepts. In order to impose that some code is authorized for an operation like writing to disk, Pony requires a special argument to be passed, a capability bearing the authority required for the task at hand. The type system guarantees that inadequate capabilities for a task fail at compile time.

Recall the definition of capability from the [Object Capabilities](/object-capabilities/object-capabilities.md) section:

> A capability is an unforgeable token that (a) designates an object and (b) gives the program the authority to perform a specific set of actions on that object.

In Pony, the `Main` actor is created with an `Env` object, which holds the unforgeable `AmbientAuth` token in its root field. This value is the capability that represents the ambient authority given to us by the system.

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
  new create(out: OutStream, auth: TCPConnectAuth) =>
    TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")

actor Main
  new create(env: Env) =>
    Connect(env.out, TCPConnectAuth(env.root))
```

The `Main` actor authorizes the `Connect` actor a `TCPConnectAuth` token created from ambient authority token in `env.root`. The ambient authority token is unforgeable since the `AmbientAuth` constructor is private and the only existing instance is provided by the runtime itself. The `TCPConnectAuth` token is derived from ambient authority token.

The `Connect` actor uses this derived authority when it creates a TCP connection:

```pony
TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")
```

The `TCPConnection` requires an authority as first parameter, and since the compiler checks that the correct type was passed, this guarantees that a `TCPConnection` can only be created by an actor holding the required authorization.

The implementation of the `TCPConnection` constructor does not even use the authorization parameter at run time, all it does is require it to be of the right type. The type checking done by the compiler is sufficient for this guarantee.

## Restrict, then delegate your authority

In order to handle our own code and that of others more safely, and also to understand our code better, we want to split up the authority, and only grant the particular authority a piece of code actually requires.

The first parameter of the `TCPConnection` constructor has the type `TCPConnectAuth`. This is what we call "the most specific authority". All classes in the standard library that require an authority token only accept a single type of token; the token of "most specific authority". In the case of `TCPConnection`, this is `TCPConnectAuth`.

Now imagine we don't trust the `Connect` actor, so we don't want to provide it with more authority than needed. For example, there is no point in granting it filesystem access, since it is supposed to do network things (specifically, TCP), not access the filesystem. Instead of passing the entire `AmbientAuth` (the root of all authority), we "downgrade" that to a `TCPConnectAuth` (the most restrictive authority in `net`), pass it to the `Connect` actor, and have that pass it to the `TCPConnection` constructor:

```pony
actor Connect
  new create(out: OutStream, auth: TCPConnectAuth) =>
    TCPConnection(auth, MyTCPConnectionNotify(out), "example.com", "80")

actor Main
  new create(env: Env) =>
    try Connect(env.out, TCPConnectAuth(env.root)) end
```

Now we are sure it cannot access the filesystem or listen on a TCP or UDP port. Pay close mind to the authority that code you are calling is asking for. Never give `AmbientAuth` to __any__ code you do not trust completely both now and in the future. You should always create the most specific authority and give the library that authority. If the library is asking for more authority than it needs, __do not use the library__.

## Authorization-friendly interface

Consider the above example again, but this time let's think of the `Connect` actor being part of a 3rd party package that we are building. Our goal is to write the actor in such a way that users of our package can grant it only the authority necessary for it to function.

As the package author, it is then our responsibility to realize that the minimal authority possible is the `TCPConnectAuth`. We should only request `TCPConnectAuth` from our users. Our current implementation already satisfies this requirement. Rather than requesting a less specific authority like `AmbientAuth` from our users and creating the `TCPConnectAuth` in our library, we only ask for the `TCPConnetAuth` that is required.

## Authority hierarchies

Let's have a look at the authorizations available in the standard library's `net` package.

```pony
primitive NetAuth
  new create(from: AmbientAuth) =>
    None

primitive DNSAuth
  new create(from: (AmbientAuth | NetAuth)) =>
    None

primitive UDPAuth
  new create(from: (AmbientAuth | NetAuth)) =>
    None

primitive TCPAuth
  new create(from: (AmbientAuth | NetAuth)) =>
    None

primitive TCPListenAuth
  new create(from: (AmbientAuth | NetAuth | TCPAuth)) =>
    None

primitive TCPConnectAuth
  new create(from: (AmbientAuth | NetAuth | TCPAuth)) =>
    None
```

Look at the constructor for `TCPConnectAuth`:

```pony
new create(from: (AmbientAuth | NetAuth | TCPAuth))
```

you might notice that this looks like a hierarchy of authorities:

`AmbientAuth >> NetAuth >> TCPAuth >> TCPConnectAuth`

where in this paragraph, ">>" means "grants at least as much authority as". In fact, the `AmbientAuth` encompasses all ambient authority and is a strictly larger authority than `NetAuth`, which grants access to the network, which is more powerful than `TCPAuth` which is restricted to the TCP protocol. Finally, `TCPConnectAuth` is good only for creating a `TCPConnection`.

This hierarchy is established by means of the constructor of the weaker authority accepting one of the stronger authorities, for example:

```pony
primitive TCPAuth
  new create(from: (AmbientAuth | NetAuth)) =>
    None
```

Where `TCPAuth` grants less authority than `NetAuth`. `NetAuth` can be used to create any of the derived authorities `DNSAuth`, `UDPAuth`, `TCPAuth`, `TCPListenAuth`, `TCPConnectAuth` whereas `TCPAuth` can only be used to derive `TCPListenAuth` and `TCPConnectAuth`.
