use "random"

actor Main
  new create(env: Env) =>
    let dice: Array[U32] = [1; 2; 3
      4
      5
      6
    ]
    Rand.shuffle[U32](dice)
    for numberOfSpots in dice.values() do
      env.out.print("You rolled a " + _ordinal(numberOfSpots))
    end
  
  fun _ordinal(number: U32): String =>
    match number
    | 1 => "one"
    | 2 => "two"
    | 3 => "three"
    | 4 => "four"
    | 5 => "five"
    | 6 => "six"
    else
      "out of range"
    end