interface Critter
  fun wash(): String

class Wombat is Critter
  fun wash(): String => "I'm a clean wombat!"

class Capybara is Critter
  fun wash(): String => "I feel squeaky clean!"
  fun swim(): String => "I'm swimming like a fish!"

actor Main
  new create(env: Env) =>
    let critters = Array[Critter].>push(Wombat).>push(Capybara)
    for critter in critters.values() do
      env.out.print(critter.wash())
      try
        env.out.print((critter as Capybara).swim())
      end
    end