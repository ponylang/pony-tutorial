use "format"
use "collections/persistent"

primitive Colours
  fun black(): U32 => 0xFF000000
  fun red(): U32 => 0xFFFF0000
  
interface val Applyable
  fun apply(): U32
  
actor Main
  new create(env: Env) =>
    let colorMap: Map[String, Applyable] = Map[String, Applyable].concat([
      ("red", Colours~red())
      ("black", Colours~black())
    ].values())

    for (colorName, color) in colorMap.pairs() do
      env.out.print(colorName + ": #" + Format.int[U32](color(), FormatHexBare))
    end