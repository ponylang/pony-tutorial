primitive ColourList
  fun apply(): Array[Colour] =>
    [Red; Green; Blue]

for colour in ColourList().values() do
  env.out.print(colour().string())
end