  class Cat
    fun pet() =>
      ...

  type Animal is (Cat | Fish | Snake)

  fun pet(animal: Animal) =>
    try
      // raises error if not a Cat
      let cat: Cat = animal as Cat
      cat.pet()
    end