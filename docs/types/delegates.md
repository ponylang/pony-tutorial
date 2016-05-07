Like some other object-oriented languages, Pony has __delegates__. That is, some types serve as __mixins__ that other types can use.

# Delegates

Any __trait__ or __interface__ can be used as a _mixin_ by exploiting delegate type declarations.

```pony
trait Wombat
  fun box battle_call() : String val =>
    "Huzzah!"

class SimpleWombat is Wombat

actor Main is Wombat
  let w : SimpleWombat delegate Wombat = SimpleWombat

  new create(env : Env) =>
    env.out.print("Battle cry: " + battle_call())
```

In this example, we have defined a trait named `Wombat` with a function `battle_call` that returns a `String` value. A __trait__ looks a bit like a __class__ but it can't have  any fields. It can however have a default implementation such as it does in this case.

The class `SimpleWombat` supports this trait and the actor `Main`, also supports the `Wombat` trait. The actor `Main` delegates its __Wombat__ness to the `SimpleWombat`  class, which provides a default implementation of `battle_call`.

# Overrides

We can, of course, override this default behaviour simply by providing our own implementation of the `battle_call` function ourselves, as below:

```pony
class KungFuWombat is Wombat
  fun box battle_call() : String val =>
    "Bonzai!"
```

And adapting our delegate to use this alternative type of Wombat:

```pony
actor Main is Wombat
  let w : Wombat delegate Wombat = KungFuWombat

  new create(env : Env) =>
    env.out.print("Battle cry: " + battle_call())
```

However, now that we have two choices of Wombat, we can tune the type declaration to allow more flexibility at runtime:

```pony
use "time"

...pony

actor Main is Wombat
  let w : Wombat delegate Wombat

  new create(env : Env) =>
    w = match (Time.nanos() and 1) == 1
    | true => KungFuWombat
    else SimpleWombat
    end
    env.out.print("Battle cry: " + battle_call())
```

## Disambiguation

Above, we don't know what kind of `Wombat` we're going to get. But we know we're going to get either a `KungFuWombat` or a `SimpleWombat`. Sometimes though, things get a little more complicated in real code:

```pony
trait Drone
  fun box battle_call() : String val =>
    "Beep Boop!"

class DroneWombat is ( Drone & Wombat)
  fun box battle_call() : String val =>
    "Beep boop Huzzah!"
```

Here, even though both `Drone` and `Wombat` provide function `battle_call` we explicitly disambiguate that a `DroneWombat`'s battle call, is like a mechanized `SimpleWombat`. So we can use our `DroneWombat` just like a `Drone` or a `Wombat`.

```pony
actor Main is Wombat
  let w : Wombat delegate Wombat = DroneWombat

  new create(env : Env) =>
    env.out.print("Battle cry: " + battle_call())
```

Sometimes though, we won't be so lucky:

```
/WombatWars/troops.pony:26:1: clashing delegates for method battle_call, local
disambiguation required
actor Main is Wombat
^
/WombatWars/troops.pony:27:2: field d delegates to battle_call via $0
 let d : Wombat delegate Wombat = DroneWombat
 ^
/WombatWars/troops.pony:28:2: field k delegates to battle_call via $0
 let k : Wombat delegate Wombat = KungFuWombat
 ^
[Finished in 0.2s with exit code 255]
```

What just happened? Our main actor has two battle_call functions available and cannot unambiguously choose one. So we need to make disambiguate explicitly:

```pony
actor Main is Wombat
 let d : Wombat delegate Wombat = DroneWombat
 let k : Wombat delegate Wombat = KungFuWombat

  new create(env : Env) =>
    env.out.print("Battle cry: " + battle_call())

  fun box battle_call() : String val =>
    "Bonzai! Beep boop! Huzzah!"
```

We can also choose our wombat delegates based on custom logic in the constructor:

```pony
actor Main is Wombat
 let d : Wombat delegate Wombat = DroneWombat
 let k : Wombat delegate Wombat = KungFuWombat

  new create(env : Env) =>
    let x = Time.nanos() % 4

    let chosen_wombat = match x
    | 0 => SimpleWombat
    | 1 => k
    | 2 => d
    else
      this
    end
    env.out.print("Battle cry: " + chosen_wombat.battle_call())

  fun box battle_call() : String val =>
    "Bonzai! Beep boop! Huzzah!"
```

Delegates are a convenient and flexible way to reuse, mixin, and/or adapt code to different strategies or policies allowing for a very high degree of flexibility in composing reasonably complex software components from relatively simple parts.

In pony, delegates can benefit from _nominal_ ( via __traits__ ) or implicit or explicit _structural_ ( via __interfaces__ ) subtyping and local disambiguation where necessary, whilst sensible default implementations allow for maximizing code reuse.
