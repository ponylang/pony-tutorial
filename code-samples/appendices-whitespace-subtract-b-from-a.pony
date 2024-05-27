use "format"
use "collections/persistent"

primitive Black fun apply(): U32 => 0xFF000000
primitive Red   fun apply(): U32 => 0xFFFF0000

type Color is (Red | Black)

actor Main
  new create(env: Env) =>
    let a: I8 = 1
    let b: I8 = 3
    let c: I8 = 
      a - b
    env.out.print(c.string())