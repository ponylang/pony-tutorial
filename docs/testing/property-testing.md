# Property-Based Testing

PonyTest includes property-based testing support.

In traditional unit testing, the developer must choose input examples for the unit under test and check whether the output meets expectations.

Property-based testing leaves generation of test input samples to the testing engine, which generates random examples taken from a description of how to do so, called `Generators`. The developer defines a `Generator` and describes the condition that should hold for every input sample.

## Usage

Writing property-based tests is done by implementing the trait [`Property`](https://stdlib.ponylang.io/pony_test-Property). A [`Property`](https://stdlib.ponylang.io/pony_test-Property) needs to define a type parameter for the type of the input sample, a [`Generator`](https://stdlib.ponylang.io/pony_test-Generator) and a property function. Here is a minimal example:

```pony
--8<-- "property-testing-usage.pony:3:11"
```

A `Property` needs a name for identification in test output. We created a `Generator` by using a factory method defined in the [`Generators`](https://stdlib.ponylang.io/pony_test-Generators) primitive, and we used [`PropertyHelper`](https://stdlib.ponylang.io/pony_test-PropertyHelper) to assert on a condition that should hold for all samples.

Below are two classic list reverse properties:

```pony
--8<-- "property-testing-quickcheck.pony"
```

## Integration with PonyTest

Register a [`Property`](https://stdlib.ponylang.io/pony_test-Property) with [PonyTest](https://stdlib.ponylang.io/pony_test--index) by calling `test.property` in the test list:

```pony
--8<--
property-testing-usage.pony:1:1
property-testing-usage.pony:13:18
--8<--
```

[`for_all`](https://stdlib.ponylang.io/pony_test-TestHelper) on `TestHelper` integrates any number of properties directly into one [`UnitTest`](https://stdlib.ponylang.io/pony_test-UnitTest):

```pony
--8<-- "property-testing-for-all.pony"
```

## Additional resources

The [API documentation](https://stdlib.ponylang.io/pony_test--index/) covers property-based testing in detail. The [ponyc GitHub repository](https://github.com/ponylang/ponyc) has [example tests](https://github.com/ponylang/ponyc/tree/main/examples/testing/property_testing).

The [Pony Patterns](http://patterns.ponylang.io/) book has a [testing section](http://patterns.ponylang.io/testing.html) covering testing more broadly.
