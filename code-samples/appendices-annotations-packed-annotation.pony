struct \packed\ MyPackedStruct
  var x: U8
  var y: U32

  new create() =>
    x = 0
    y = 1

actor Main
  new create(env: Env) =>
    env.out.print("{\n\t\"x\": " + MyPackedStruct.x.string() + ",\n\t\"y\": " + MyPackedStruct.y.string() + "\n}")