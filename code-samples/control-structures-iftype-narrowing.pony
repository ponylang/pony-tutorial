trait Animal
  fun name(): String

class Cat is Animal
  fun name(): String => "Cat"
  fun purr(): String => "prrr"

class Dog is Animal
  fun name(): String => "Dog"

actor Main
  new create(env: Env) =>
    describe[Cat val](Cat, env)
    describe[Dog val](Dog, env)

  fun describe[A: Animal val](a: A, env: Env) =>
    env.out.print(a.name())
    iftype A <: Cat val then
      env.out.print(a.purr())
    end
