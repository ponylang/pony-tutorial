actor Main
  new create(env: Env) =>
    let bob: Person = Bob
    env.out.print(bob.name() + ", aged " + bob.age().string() + ", feels \"" + bob.feeling() + "\"")
    
trait HasName
  fun name(): String => "Bob"

trait HasAge
  fun age(): U32 => 42

trait HasFeelings
  fun feeling(): String => "Great!"

type Person is (HasName & HasAge & HasFeelings)

class Bob is Person