# Policies described

[TOC]

<!--*
# Document freshness: For more information, see go/fresh-source.
freshness: { owner: 'migryz' reviewed: '2018-07-16' }
*-->

## Roll-back first {#rollback_first}

<!--*
# Document freshness: For more information, see go/fresh-source.
freshness: { owner: 'migryz' reviewed: '2018-07-11' }
*-->

Failures in post commit tests mean that there is bug in our project. The longer
this bug is out there, the harder it is to fix it because of changes that stack
up on top of it. Thus we want to get back to green state as soon as possible.

The approach we chose in Beam is rolling back culprit code change.

This approach has benefits of generally high reliability and short
implementation time, since we are returning to previously verified good state.

### Common process

1.  Revert culprit commit
1.  Re-run tests
1.  Push revert commit

### Changes history.

*   This policy was discussed in this mailing thread
    [link](https://lists.apache.org/thread.html/3bb4aa777751da2e2d7e22666aa6a2e18ae31891cb09d91718b75e74@%3Cdev.beam.apache.org%3E).
*   This policy was described in this design doc
    [link](https://docs.google.com/document/d/1sczGwnCvdHiboVajGVdnZL0rfnr7ViXXAebBAf_uQME/edit).

## Failing test is a Critical/P1 bug. {#failing_test_is_critical_bug}

Failing test means that our system does not perform as expected. Any changes
made on top of bugged system can not be verified properly and can only make
problem worse.

To deal with such situation we consider fixing failing tests our highest
priority.

## Flaky test is same as failing test. {#flake_is_failing}

<!--*
# Document freshness: For more information, see go/fresh-source.
freshness: { owner: 'migryz' reviewed: '2018-07-11' }
*-->

Flaky tests are tests that can succeed or fail randomly on the same code
version. These are usually one of the most dangerous things out there.

On one hand they are way too easy to ignore: just re-running flaky test will
give you green result.

On the other hand: they are very time consuming, they get bothersome to triage
every time, they are easy to ignore in general, they might hide real bugs, they
tend to accumulate.

On top of that, flaky tests are the hardest ones to fix, since all easy ones
were fixed already.

Because of reasons above, it is most important to be diligent and fix flakiness
in tests as soon as possible. And if it takes too much time to implement the fix
flakiness, it is safer to disable test until the fix arrives, since it does not
provide reliable quality signal.

Martin fowler has good
[article](https://martinfowler.com/articles/nonDeterminism.html) on
non-determinism in tests.

## If test can't be deflaked, it must be removed. {#remove_flake}

Flaky tests do not provide a reliable quality signal. Additionally, they make us
start ignoring test suite failures. This has a virulent effect on all tests and
can lead to tremendous loss of trust in tests.

We do want to trust our tests and to do that, we have to either deflake or
remove flaky tests.

## Add corresponding test to pre-commits as part of post-commit fix. {#precommit_for_postcommit}

Whenever you implement a fix for post-commit test failure, implement
corresponding pre-commit test that will detect similar failures in the future.
For example, you can implement unit test that will cover problematic code
branch.

Post-commit tests are good as failsafe. But we want to fail fast. In terms of
testing it means that we want to detect bugs in pre-commit tests, not in post
commit.
