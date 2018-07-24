# Best Practices for Writing Tests

We love tests. However sometimes we get frustrated and want guidelines on what
good test is. Below are some ideas that can help make your tests better.

## One test -- one fail scenario

Do your best to minimize potential reasons for test to fail. The less potential
options for test to fail, the easier and faster it is to find a bug. In ideal
case, developer should be able to know a place in code where the bug happens and
way to reproduce it by reading test name only.

## Avoid non-determinism prone methods

Good test should be predictable and deterministic. This is important, because
tests that contain non-deterministic code are generally hard to debug and are
often flaky.

Non-deterministic methods usually include: random, time, multithreading. Common
practice to avoid non-deterministic code is to mock corresponding methods or
classes.

## Give tests descriptive names

Test names should describe the reason why this test case fails. One good rule of
thumb is to name tests with following structure:

*   What is being tested
*   Under what circumstances
*   What is the expected result

For example, say you want to test division method.

```java
float Divide(float dividend, float divisor) {
  return dividend / divisor;
}

...

@Test
void <--TestMethodName-->() {
    assertThrows(Divide(10, 0))
}
```

Naming such test case “testDivide” is not best decision:

*   It doesn’t specify what expected action and parameters are
*   It doesn’t specify what expected result is

To triage such test, we have to go to the test implementation and see what test
does.

Better option might be “invokingDivideWithDivisorEqualToZeroThrowsException()”:

*   It specifies what method is called
*   It specifies information about important parameters
*   It specifies expected result

This means that if such test fails, just by looking at the test name, we already
know the most probable reason of failure.

The fact that the name of the test is long should not worry you, because this is
test code and it is not going to be used too often. On the other hand it is used
in frameworks to report tests failures, so the more descriptive it is, the
better it is.

## If you can make it pre-commit, do it pre-commit

Post-commit tests are the ones that can cover the most complex scenarios. This
makes them useful to cover broad variety of scenarios most of which are hard to
predict on the stage of designing code.

However, often, we are writing test to verify specific scenario. In these
situations it is usually possible to implement test in the form of unit test or
component test, and it is always better to do so. Unit or component tests can be
added pre-commit test suit and will give you much faster feedback at the stage
when it is cheap to fix.
