// In C: double point_sum(struct Point p)
use @point_sum[F64](p: Point \by_value\)

struct Point
  var x: F64 = 0
  var y: F64 = 0

actor Main
  new create(env: Env) =>
    let p = Point
    p.x = 3
    p.y = 4
    let sum = @point_sum(p)
    env.out.print("sum: " + sum.string())
