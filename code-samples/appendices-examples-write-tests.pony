use "pony_test"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestAddition)

class iso _TestAddition is UnitTest
  """
  Adding 2 numbers
  """
  fun name(): String => "u32/add"

  fun apply(h: TestHelper) =>
    h.assert_eq[U32](2 + 2, 4)