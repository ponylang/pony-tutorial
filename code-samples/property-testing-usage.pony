use "pony_test"

class _MyFirstProperty is Property[String]
  fun name(): String =>
    "my_first_property"

  fun gen(): Generator[String] =>
    Generators.ascii()

  fun ref property(arg1: String, ph: PropertyHelper) =>
    ph.assert_eq[String](arg1, arg1)

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test.property(_MyFirstProperty)
