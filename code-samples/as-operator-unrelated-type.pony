  trait Alive

  trait Well

  class Person is (Alive & Well)

  class LifeSigns
    fun is_all_good(alive: Alive)? =>
      // if the instance 'alive' is also of type 'Well' (such as a Person instance). raises error if not possible
      let well: Well = alive as Well