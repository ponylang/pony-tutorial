use "pony_test"
use "pony_check"

class _MyFirstProperty is Property1[String]
  fun name(): String =>
    "my_first_property"

  fun gen(): Generator[String] =>
    Generators.ascii()

  fun property(arg1: String, ph: PropertyHelper) =>
    ph.assert_eq[String](arg1, arg1)

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(Property1UnitTest[String](_MyFirstProperty))