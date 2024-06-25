actor Main
  new create(env: Env) =>
    let bob: Person = Bob
    env.out.print(bob.name() + ", aged " + bob.age().string() + ", feels \"" + bob.feeling() + "\"")

interface HasName
  fun name(): String

interface HasAge
  fun age(): U32

interface HasFeelings
  fun feeling(): String

type Person is (HasName & HasAge & HasFeelings)

class Bob is Person
  fun name(): String => "Bob"
  fun age(): U32 => 42
  fun feeling(): String => "Great!"