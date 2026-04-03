trait Animal
class Cat is Animal
class Dog is Animal

actor Main
  new create(env: Env) =>
    greet[Cat](env)
    greet[Dog](env)

  fun greet[A: Animal](env: Env) =>
    iftype A <: Cat then
      env.out.print("meow")
    else
      env.out.print("woof")
    end
