// main.pony
use @answer[I32]()

actor Main
  new create(env: Env) =>
    env.out.print(@answer().string())
