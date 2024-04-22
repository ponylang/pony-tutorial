primitive Black
primitive Blue
primitive Red
primitive Yellow

type Colour is (Black | Blue | Red | Yellow)

primitive ColourList
  fun tag apply(): Array[Colour] =>
    [Black; Blue; Red; Yellow]

for colour in ColourList().values() do
end