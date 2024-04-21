use "pony_test"
use "pony_check"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(Property1UnitTest[String](_MyFirstProperty))