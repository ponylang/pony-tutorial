// In C:
// struct Point scale_point(struct Point p, double factor)
use @scale_point[Point \by_value\](p: Point \by_value\, factor: F64)

struct Point
  var x: F64 = 0
  var y: F64 = 0

actor Main
  new create(env: Env) =>
    let p = Point
    p.x = 3
    p.y = 4
    let scaled = @scale_point(p, 2)
    env.out.print("x: " + scaled.x.string() + ", y: " + scaled.y.string())
