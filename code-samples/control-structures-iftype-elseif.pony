trait Animal
class Cat is Animal
class Dog is Animal
class Fish is Animal

actor Main
  new create(env: Env) =>
    describe[Cat](env)
    describe[Dog](env)
    describe[Fish](env)

  fun describe[A: Animal](env: Env) =>
    iftype A <: Cat then
      env.out.print("I'm a cat")
    elseif A <: Dog then
      env.out.print("I'm a dog")
    else
      env.out.print("I'm something else")
    end
