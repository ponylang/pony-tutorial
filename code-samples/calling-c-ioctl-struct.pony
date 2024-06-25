use @ioctl[I32](fd: I32, req: U32, ...)

struct Winsize
  var height: U16 = 0
  var width: U16 = 0

  new create() => None
  
actor Main
  new create(env: Env) =>
    let size = Winsize
    
    @ioctl(0, 21523, NullablePointer[Winsize](size))
    
    env.out.print(size.height.string())