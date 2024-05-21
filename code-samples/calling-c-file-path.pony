use @_mkdir[I32](dir: Pointer[U8] tag) if windows
use @mkdir[I32](path: Pointer[U8] tag, mode: U32) if not windows

class val FilePath
  fun val mkdir(must_create: Bool = false): Bool =>
    // ...
      let r = ifdef windows then
        @_mkdir(element.cstring())
      else
        @mkdir(element.cstring(), 0x1FF)
      end