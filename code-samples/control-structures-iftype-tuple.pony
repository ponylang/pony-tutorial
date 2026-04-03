trait Animal
class Cat is Animal
class Dog is Animal

actor Main
  new create(env: Env) =>
    check[Cat, Dog](env)
    check[Cat, Cat](env)

  fun check[A: Animal, B: Animal](env: Env) =>
    iftype (A, B) <: (Cat, Dog) then
      env.out.print("cat and dog")
    else
      env.out.print("some other combination")
    end
