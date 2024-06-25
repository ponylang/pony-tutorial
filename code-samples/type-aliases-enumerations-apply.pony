use "format"
use "collections/persistent"

actor Main
  new create(env: Env) =>
    let colorMap = Map[U32, String].concat([
      (0xFF0000FF, "red")
      (0x00FF00FF, "green")
      (0x0000FFFF, "blue")
    ].values())
    for colour in ColourList().values() do
      env.out.print(colorMap.get_or_else(colour(), "color") + ": #" + Format.int[U32](colour(), FormatHexBare))
    end

primitive Red    fun apply(): U32 => 0xFF0000FF
primitive Green  fun apply(): U32 => 0x00FF00FF
primitive Blue   fun apply(): U32 => 0x0000FFFF

type Colour is (Red | Blue | Green)    

primitive ColourList
  fun apply(): Array[Colour] =>
    [Red; Green; Blue]