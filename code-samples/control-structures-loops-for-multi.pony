actor Main
  new create(env: Env) =>
    let names = ["Alice"; "Bob"; "Carol"]
    let scores = [as U32: 95; 87; 91]
    for (name, score) in (names.values(), scores.values()) do
      env.out.print(name + ": " + score.string())
    end
