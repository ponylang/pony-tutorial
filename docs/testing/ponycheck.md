# Testing with `PonyCheck`

PonyCheck is Pony's property based testing framework. It is designed to work seamlessly with [PonyTest](ponytest.md), Pony's unit testing framework. How is property based testing different than unit testing? Why does Pony include both?

In traditional unit testing, it is the duty and burden of the developer to provide and craft meaningful input examples for the unit under test (be it a class, a function or whatever) and check if some output conditions hold. This is a tedious and error-prone activity.

Property based testing leaves generation of test input samples to the testing engine which generates random examples taken from a description how to do so, so called `Generators`. The developer needs to define a `Generator` and describe the condition that should hold for each and every input sample.

Property based Testing first came up as [`QuickCheck`](http://www.cse.chalmers.se/~rjmh/QuickCheck/) in Haskell. It has the nice property of automatically inferring `Generators` from the type of the property parameter, the test input sample.

PonyCheck is heavily inspired by QuickCheck and other great property based testing libraries, namely:

* [Hypothesis](https://github.com/HypothesisWorks/hypothesis-python)
* [Theft](https://github.com/silentbicycle/theft)
* [ScalaCheck](https://www.scalacheck.org/)

## Usage

Writing property based tests in PonyCheck is done by implementing the trait [`Property1`](https://stdlib.ponylang.io/pony_check-Property1). A [`Property1`](https://stdlib.ponylang.io/pony_check-Property1) needs to define a type parameter for the type of the input sample, a [`Generator`](https://stdlib.ponylang.io/pony_check-Generator) and a property function. Here is a minimal example:

```pony
use "pony_test"

class _MyFirstProperty is Property1[String]
  fun name(): String =>
    "my_first_property"

  fun gen(): Generator[String] =>
    Generators.ascii()

  fun property(arg1: String, h: PropertyHelper) =>
    h.assert_eq[String](arg1, arg1)
```

A `Property` needs a name for identification in test output. We created a `Generator` by using one of the many convenience factory methods and combinators defined in the [`Generators`](https://stdlib.ponylang.iok/PonyCheck-Generators) primitive and we used [`PropertyHelper`](https://stdlib.ponylang.io/PonyCheck-PropertyHelper) to assert on a condition that should hold for all samples

Below is a classical List reverse properties from the QuickCheck paper adapted to Pony Arrays:

```pony
use "pony_check"
use "collections"

class _ListReverseProperty is Property1[Array[USize]]
  fun name(): String => "list/reverse"

  fun gen(): Generator[Array[USize]] =>
    Generators.seq_of[USize, Array[USize]](Generators.usize())

  fun property(arg1: Array[USize], ph: PropertyHelper) =>
    ph.assert_array_eq[USize](arg1, arg1.reverse().reverse())

class _ListReverseOneProperty is Property1[Array[USize]]
  fun name(): String => "list/reverse/one"

  fun gen(): Generator[Array[USize]] =>
    Generators.seq_of[USize, Array[USize]](Generators.usize() where min=1,max=1)

  fun property(arg1: Array[USize], ph: PropertyHelper) =>
    ph.assert_array_eq[USize](arg1, arg1.reverse())
```

## Integration with PonyTest

PonyCheck properties need to be executed. The test runner for PonyCheck is [PonyTest](https://stdlib.ponylang.org/pony_test--index). To integrate [`Property1`](https://stdlib.ponylang.io/pony_check-Property1) into [PonyTest](https://stdlib.ponylang.org/pony_test--index), `Property1` needs to be wrapped inside a [`Property1UnitTest`](hhttps://stdlib.ponylang.io/pony_check-Property1UnitTest) and passed to the PonyTest `apply` method as all regular PonyTest [`UnitTests`](https://stdlib.ponylang.org/pony_test-UnitTest):

```pony
use "pony_test"
use "pony_check"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(Property1UnitTest[String](_MyFirstProperty))
```

It is also possible to integrate any number of properties directly into one
[`UnitTest`](https://stdlib.ponylang.org/pony_test-UnitTest) using the [`PonyCheck.forAll`](https://stdlib.ponylang.io/pony_check-ponycheck) convenience function:

```pony
class _ListReverseProperties is UnitTest
  fun name(): String => "list/properties"

  fun apply(h: TestHelper) ? =>
    let gen1 = Generators.seq_of[USize, Array[USize]](Generators.usize())
    PonyCheck.forAll[Array[USize]](gen1, h)({
      (arg1: Array[USize], ph: PropertyHelper) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse().reverse())
    })
    let gen2 = Generators.seq_of[USize, Array[USize]](1, Generators.usize())
    PonyCheck.forAll[Array[USize]](gen2, h)({
      (arg1: Array[USize], ph: PropertyHelper) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse())
    })
```

## Additional resources

You can learn more about PonyCheck specifics by checking out the [API documentation](https://stdlib.ponylang.io/PonyCheck--index/). You can also find some [example tests](https://github.com/ponylang/ponyc/tree/main/examples/ponycheck) in [ponyc GitHub repository](https://github.com/ponylang/ponyc).

To learn more about testing in Pony in general, there's a [testing section](http://patterns.ponylang.io/testing.html) in the [Pony Patterns](http://patterns.ponylang.io/) book which isn't specific to `PonyCheck`.
