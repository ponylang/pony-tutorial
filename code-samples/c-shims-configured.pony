// main.pony
use "cdefine:ANSWER=42"
use "cincludedir:./include"

use @answer[I32]()
use @version[I32]()

actor Main
  new create(env: Env) =>
    env.out.print("answer: " + @answer().string())
    env.out.print("version: " + @version().string())
