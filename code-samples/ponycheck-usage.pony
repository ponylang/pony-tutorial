use "pony_test"

class _MyFirstProperty is Property1[String]
  fun name(): String =>
    "my_first_property"

  fun gen(): Generator[String] =>
    Generators.ascii()

  fun property(arg1: String, ph: PropertyHelper) =>
    ph.assert_eq[String](arg1, arg1)