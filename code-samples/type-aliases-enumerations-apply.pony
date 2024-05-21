actor Main
  new create(env: Env) =>
    for colour in ColourList().values() do
      env.out.print(colour().string())
    end

primitive Red    fun apply(): U32 => 0xFF0000FF
primitive Green  fun apply(): U32 => 0x00FF00FF
primitive Blue   fun apply(): U32 => 0x0000FFFF

type Colour is (Red | Blue | Green)

primitive ColourList
  fun apply(): Array[Colour] =>
    [Red; Green; Blue]