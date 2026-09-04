actor Main
  new create(env: Env) =>
    let names = ["Alice"; "Bob"; "Carol"]
    let scores = [as U32: 95; 87; 91]
    try
      let iter1 = names.values()
      let iter2 = scores.values()
      while iter1.has_next() and iter2.has_next() do
        (let name, let score) = (iter1.next()?, iter2.next()?)
        env.out.print(name + ": " + score.string())
      end
    end
