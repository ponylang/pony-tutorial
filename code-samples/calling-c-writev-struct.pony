// In C: ssize_t writev(int fd, const struct iovec *iov, int iovcnt)
use @writev[USize](fd: U32, iov: IOVec tag, iovcnt: I32)

// In C:
// struct iovec {
//     void  *iov_base;    /* Starting address */
//     size_t iov_len;     /* Number of bytes to transfer */
// };
struct IOVec
  var base: Pointer[U8] tag = Pointer[U8]
  var len: USize = 0

actor Main
  new create(env: Env) =>
    let data = "Hello from Pony!"
    var iov = IOVec
    iov.base = data.cpointer()
    iov.len = data.size()
    @writev(1, iov, 1) // Will print "Hello from Pony!"