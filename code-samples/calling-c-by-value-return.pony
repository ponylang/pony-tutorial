// In C: struct Point point_make(double x, double y)
use @point_make[Point \by_value\](x: F64, y: F64)

struct Point
  var x: F64 = 0
  var y: F64 = 0

actor Main
  new create(env: Env) =>
    let p = @point_make(3, 4)
    env.out.print("x: " + p.x.string() + ", y: " + p.y.string())
