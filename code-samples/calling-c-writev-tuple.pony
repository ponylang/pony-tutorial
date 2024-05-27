use @writev[USize](fd: U32, iov: Pointer[(Pointer[U8] tag, USize)] tag, iovcnt: I32)

actor Main
  new create(env: Env) =>
    let data = "Hello from Pony!"
    var iov = (data.cpointer(), data.size())
    @writev(1, addressof iov, 1) // Will print "Hello from Pony!"