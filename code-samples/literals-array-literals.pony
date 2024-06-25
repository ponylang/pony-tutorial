actor Main
  new create(env: Env) =>
    let my_literal_array =
      [
        "first"; "second"
        "third one on a new line"
      ]

    try
      env.out.print(my_literal_array(0)? + ", " + my_literal_array(1)? + ", " + my_literal_array(2)?)
    end

    // or:
    for entry in my_literal_array.values() do
      env.out.print(entry)
    end

    // or:
    for pair in my_literal_array.pairs() do
      env.out.write(pair._2 + (if (pair._1 + 1) < my_literal_array.size() then ", " else "" end))
    end
    env.out.print("")
  
    // or:
    env.out.print(", ".join(my_literal_array.values()))

    // or:
    while my_literal_array.size() > 0 do
      let entry = try my_literal_array.shift()? end
      env.out.print(entry.string())
    end
