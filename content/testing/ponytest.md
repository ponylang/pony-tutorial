---
title: "Testing with Ponytest"
section: "Testing"
menu:
  toc:
    parent: "testing"
    weight: 10
toc: true
---

PonyTest is Pony's unit testing framework. It is designed to be as simple as possible to use, both for the unit test writer and the user running the tests.

Each unit test is a class, with a single test function. By default, all tests run concurrently.

Each test run is provided with a helper object. This provides logging and assertion functions. By default log messages are only shown for tests that fail.

When any assertion function fails the test is counted as a fail. However, tests can also indicate failure by raising an error in the test function.

## Example program

To use PonyTest simply write a class for each test and a TestList type that tells the PonyTest object about the tests. Typically the TestList will be Main for the package.

The following is a complete program with 2 trivial tests.

```pony
use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestAdd)
    test(_TestSub)

class iso _TestAdd is UnitTest
  fun name(): String => "addition"

  fun apply(h: TestHelper) =>
    h.assert_eq[U32](4, 2 + 2)

class iso _TestSub is UnitTest
  fun name(): String => "subtraction"

  fun apply(h: TestHelper) =>
    h.assert_eq[U32](2, 4 - 2)
```
 The make() constructor is not needed for this example. However, it allows for easy aggregation of tests (see below) so it is recommended that all test Mains provide it.

Main.create() is called only for program invocations on the current package. Main.make() is called during aggregation. If so desired extra code can be added to either of these constructors to perform additional tasks.

## Test names

Tests are identified by names, which are used when printing test results and on the command line to select which tests to run. These names are independent of the names of the test classes in the Pony source code.

Arbitrary strings can be used for these names, but for large projects, it is strongly recommended to use a hierarchical naming scheme to make it easier to select groups of tests.

## Aggregation

Often it is desirable to run a collection of unit tests from multiple different source files. For example, if several packages within a bundle each have their own unit tests it may be useful to run all tests for the bundle together.

This can be achieved by writing an aggregate test list class, which calls the list function for each package. The following is an example that aggregates the tests from packages `foo` and `bar`.

```pony
use "ponytest"
use foo = "foo"
use bar = "bar"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    foo.Main.make().tests(test)
    bar.Main.make().tests(test)
```

Aggregate test classes may themselves be aggregated. Every test list class may contain any combination of its own tests and aggregated lists.

## Long tests

Simple tests run within a single function. When that function exits, either returning or raising an error, the test is complete. This is not viable for tests that need to use actors.

Long tests allow for delayed completion. Any test can call long_test() on its TestHelper to indicate that it needs to keep running. When the test is finally complete it calls complete() on its TestHelper.

The complete() function takes a Bool parameter to specify whether the test was a success. If any asserts fail then the test will be considered a failure regardless of the value of this parameter. However, complete() must still be called.

Since failing tests may hang, a timeout must be specified for each long test. When the test function exits a timer is started with the specified timeout. If this timer fires before complete() is called the test is marked as a failure and the timeout is reported.

On a timeout, the timed_out() function is called on the unit test object. This should perform whatever test specific tidy up is required to allow the program to exit. There is no need to call complete() if a timeout occurs, although it is not an error to do so.

Note that the timeout is only relevant when a test hangs and would otherwise prevent the test program from completing. Setting a very long timeout on tests that should not be able to hang is perfectly acceptable and will not make the test take any longer if successful.

Timeouts should not be used as the standard method of detecting if a test has failed.

## Exclusion groups

By default, all tests are run concurrently. This may be a problem for some tests, eg if they manipulate an external file or use a system resource. To fix this issue any number of tests may be put into an exclusion group.

No tests that are in the same exclusion group will be run concurrently.

Exclusion groups are identified by name, arbitrary strings may be used. Multiple exclusion groups may be used and tests in different groups may run concurrently. Tests that do not specify an exclusion group may be run concurrently with any other tests.

The command line option "--sequential" prevents any tests from running concurrently, regardless of exclusion groups. This is intended for debugging rather than standard use.

## Tear down

Each unit test object may define a tear_down() function. This is called after the test has finished allowing the tearing down of any complex environment that had to be set up for the test.

The tear_down() function is called for each test regardless of whether it passed or failed. If a test times out tear_down() will be called after timed_out() returns.

When a test is in an exclusion group, the tear_down() call is considered part of the tests run. The next test in the exclusion group will not start until after tear_down() returns on the current test.

The test's TestHelper is handed to tear_down() and it is permitted to log messages and call assert functions during tear down.

## Additional resources

You can learn more about PonyTest specifics by checking out the [API documentation](https://stdlib.ponylang.io/ponytest--index/). There's also a [testing section](http://patterns.ponylang.io/testing.html) in the [Pony Patterns](http://patterns.ponylang.io/) book.
