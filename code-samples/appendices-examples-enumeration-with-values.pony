use "format"
use "collections/persistent"

primitive Black fun apply(): U32 => 0xFF000000
primitive Red   fun apply(): U32 => 0xFFFF0000

type Color is (Red | Black)

actor Main
  new create(env: Env) =>

    let colorMap: Map[String, Color] = Map[String, Color].concat([
      ("red", Red)
      ("black", Black)
    ].values())

    for (colorName, color) in colorMap.pairs() do
      env.out.print(colorName + ": #" + Format.int[U32](color(), FormatHexBare))
    end