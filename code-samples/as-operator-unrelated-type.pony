trait Alive

trait Well

class Person is (Alive & Well)

class LifeSigns
  fun is_all_good(alive: Alive)? =>
    // if the instance 'alive' is also of type 'Well' (such as a Person instance). raises error if not possible
    let well: Well = alive as Well

class Dog is Alive

actor Main
  new create(env: Env) =>
    try
      LifeSigns.is_all_good(Person)?
    else
      env.err.print("Person is alive but not well")
    end
    try
      LifeSigns.is_all_good(Dog)?
    else
      env.err.print("Dog is alive but not well")
    end
