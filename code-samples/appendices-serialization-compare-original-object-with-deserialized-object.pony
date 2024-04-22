use "serialise"

class Foo is Equatable[Foo box]
  let _s: String
  let _u: U32

  new create(s: String, u: U32) =>
    _s = s
    _u = u

  fun eq(foo: Foo box): Bool =>
    (_s == foo._s) and (_u == foo._u)

actor Main
  new create(env: Env) =>
    try
      // get serialization authorities
      let serialise = SerialiseAuth(env.root)
      let output = OutputSerialisedAuth(env.root)
      let deserialise = DeserialiseAuth(env.root)
      let input = InputSerialisedAuth(env.root)

      let foo1 = Foo("abc", 123)

      // serialisation
      let sfoo = Serialised(serialise, foo1)?
      let bytes_foo: Array[U8] val = sfoo.output(output)

      env.out.print("serialised representation is " +
        bytes_foo.size().string() +
        " bytes long")

      // deserialisation
      let dfoo = Serialised.input(input, bytes_foo)
      let foo2 = dfoo(deserialise)? as Foo

      env.out.print("(foo1 == foo2) is " + (foo1 == foo2).string())
    else
      env.err.print("there was an error")
    end