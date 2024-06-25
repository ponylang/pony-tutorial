interface Critter
  fun wash(): String

class Wombat is Critter
  fun wash(): String => "I'm a clean wombat!"

class Capybara is Critter
  fun wash(): String => "I feel squeaky clean!"
  fun swim(): String => "I'm swimming like a fish!"

actor Main
  new create(env: Env) =>
    let anys = Array[Any ref].>push(Wombat).>push(Capybara)
    for any in anys.values() do
      try
        match any
        | let critter: Critter =>
          env.out.print(critter.wash())
        else
          error
        end
      end
    end