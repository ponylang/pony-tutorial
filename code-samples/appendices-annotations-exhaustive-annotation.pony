primitive Red
primitive Green
primitive Blue

type Colour is (Red | Green | Blue)

primitive Colours
  fun name(colour: Colour): String =>
    match \exhaustive\ colour
    | Red => "red"
    | Green => "green"
    | Blue => "blue"
    end

actor Main
  new create(env: Env) =>
    env.out.print(Colours.name(Red))
