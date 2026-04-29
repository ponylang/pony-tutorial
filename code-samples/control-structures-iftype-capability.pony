trait Animal

class Cat is Animal
  var _name: String = "Cat"

  fun box name(): String => _name
  fun ref set_name(name': String) => _name = name'

actor Main
  new create(env: Env) =>
    let cat: Cat ref = Cat
    maybe_rename[Cat ref](cat, env)

    let cat2: Cat val = Cat
    maybe_rename[Cat val](cat2, env)

  fun maybe_rename[A: Animal](a: A, env: Env) =>
    iftype A <: Cat ref then
      a.set_name("Kitty")
      env.out.print(a.name())
    elseif A <: Cat box then
      env.out.print(a.name())
    end
