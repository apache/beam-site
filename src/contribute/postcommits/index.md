# Post-commit policies

Post-commit tests are tests that are executed against HEAD master branch, are
time consuming (talking about hours) and are generally hard to triage in case of
failures. This is the place where most of integration tests live.

The purpose of post-commit tests is validate that our product works in a live
environment and to catch errors that are hard to predict in design and
implementation stage.

Even though these tests run after the code gets into repository, it is still
important to keep these tests green. If any of post-commit tests is failing,
that means that our product does not perform as expected.

On this page we outlined policies that our community came up with for
maintaining post-commit tests green.

## Policies {#policies}

*   [Roll-back first](policies/index.md#rollback_first)
*   [Failing test is a critical bug](policies/index.md#failing_test_is_critical_bug)
*   [Flaky tests are treated same as failing tests and treated as critical bug](policies/index.md#flake_is_failing)
*   [If test can't be deflaked it must be removed](policies/index.md#remove_flake)
*   [Fix for post-comit failure should contain corresponding pre-commit test](policies/index.md#precommit_for_postcommit)

## Process for fixing failing test

Below is outline of actions that should taken by in case of failing post-commit
test by different participants.

### If you found failing test: {#found-failing-test}

1.  Create JIRA ticket and assign it to yourself. Creation of ticket will be
    automated.
1.  Do high-level (or better) triage of the failure.
1.  [Assign ticket to relevant person.](guides/index.md#find_specialist)

### If you were assigned JIRA ticket: {#assigned-failing-test}

1.  [Rollback culprit change](guides/index.md#rollback).
1.  [If rollback is not possible in short amount of time, decide on disabling
    test for the time of shipping a fix](guides/index.md#disabling). This step
    should be taken in consideration if your estimate of rollback is longer than
    8 hours.

Rollback is our main line of action, if fix is trivial, feel free to propose a
PR with implementation right away.

### If your change was rolled back due to test failure: {#pr-rolled-back}

1.  Find information on rollback reasons in JIRA ticket.
1.  Fix your code, re-run post-commit tests.
1.  Implement corresponding pre-commit test(s) that will catch similar bugs
    before code gets into repository.
1.  Send new PR.

## Useful links

*   [Best practices for writing tests](tests_best_practices.md)

## References

1.  [Keeping post-commit tests green](https://lists.apache.org/thread.html/3bb4aa777751da2e2d7e22666aa6a2e18ae31891cb09d91718b75e74@%3Cdev.beam.apache.org%3E)
    thread
