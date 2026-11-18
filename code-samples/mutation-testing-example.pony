use "pony_test"

primitive Bounded
  fun apply(value: I64, low: I64, high: I64): I64 =>
    if value < low then low
    elseif value > high then high
    else value
    end

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestBoundBelow)
    test(_TestBoundAbove)
    test(_TestBoundWithin)

class iso _TestBoundBelow is UnitTest
  fun name(): String => "bound/below range"

  fun apply(h: TestHelper) =>
    h.assert_eq[I64](0, Bounded(-5, 0, 10))

class iso _TestBoundAbove is UnitTest
  fun name(): String => "bound/above range"

  fun apply(h: TestHelper) =>
    h.assert_eq[I64](10, Bounded(15, 0, 10))

class iso _TestBoundWithin is UnitTest
  fun name(): String => "bound/within range"

  fun apply(h: TestHelper) =>
    h.assert_eq[I64](5, Bounded(5, 0, 10))
