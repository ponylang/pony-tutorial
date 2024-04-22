use "serialise"

use "lib:custser"

use @get_string[Pointer[U8]]()
use @serialise_space[USize](s: Pointer[U8] tag)
use @serialise[None](bytes: Pointer[U8] tag, str: Pointer[U8] tag)
use @deserialise[Pointer[U8] tag](bytes: Pointer[U8] tag)
use @printf[I32](fmt: Pointer[U8] tag, ...)

class CStringWrapper
  var _cstr: Pointer[U8] tag

  new create(cstr: Pointer[U8] tag) =>
    _cstr = cstr

  fun _serialise_space(): USize =>
    @serialise_space(_cstr)

  fun _serialise(bytes: Pointer[U8] tag) =>
    @serialise(bytes, _cstr)

  fun ref _deserialise(bytes: Pointer[U8] tag) =>
    _cstr = @deserialise(bytes)

  fun print() =>
    @printf(_cstr)

actor Main
  new create(env: Env) =>
    let csw = CStringWrapper(@get_string())
    csw.print()
    try
      let serialise = SerialiseAuth(env.root)
      let deserialise = DeserialiseAuth(env.root)

      let sx = Serialised(serialise, csw)?
      let y = sx(deserialise)? as CStringWrapper
      y.print()
    else
      env.err.print("there was an error")
    end