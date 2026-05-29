---
name: code-review-loop
description: Use when finishing code changes and the user wants repeated review-fix-test cycles, especially when they ask to rerun code review until clean, repair only real findings, fix genuine test failures, or cap the loop after a fixed number of attempts.
---

# Code Review Loop

## Overview

Run a bounded review loop around `superpowers:requesting-code-review`: request review, fix only valid technical findings, repair real test failures, then request review again. Stop as soon as the work is clean or after 10 review attempts.

**Required sub-skill:** Use `superpowers:requesting-code-review` for every review pass. If the alias is not available, read and follow `C:\Users\Marek\.codex\superpowers\skills\requesting-code-review\SKILL.md`.

**Recommended companion:** Use `superpowers:receiving-code-review` when deciding whether feedback is valid, ambiguous, or wrong.

## Core Rule

The loop has a hard maximum of 10 iterations. Never start iteration 11. If valid problems remain after iteration 10, stop and report what remains.

## Loop

1. Set `MAX_ITERATIONS = 10` and start at iteration 1.
2. Capture the current git base/head or the relevant diff range.
3. Run `superpowers:requesting-code-review`.
4. Classify every finding:
   - `valid`: real bug, regression, missing requirement, security issue, performance issue, or maintainability problem with practical impact.
   - `invalid`: reviewer misunderstanding, already handled behavior, contradicted by tests or code, or stylistic preference outside the request.
   - `unclear`: plausible but needs code inspection before acting.
5. Fix all valid Critical and Important findings before continuing. Fix Minor findings when they are low-risk and aligned with the requested work.
6. For unclear findings, inspect the code and tests. Either convert them to valid and fix them, or document why they are not real problems.
7. Run the most relevant tests for the changed surface. Start targeted, then broaden when the change touches shared behavior.
8. Fix only real test failures:
   - Product or test failure caused by the current change: fix it.
   - Existing unrelated failure: document it, do not chase it unless the user asked.
   - Environmental/flaky failure: rerun or isolate once; if still not actionable, document it.
9. If tests pass and there are no valid unresolved review findings, stop successfully.
10. If valid findings or real test failures were fixed, increment the iteration and repeat from step 2.

## Stop Conditions

Stop immediately when one of these is true:

- A review pass returns no valid findings and relevant tests pass.
- Iteration 10 completed and valid findings or real test failures remain.
- A required external dependency, credential, or service blocks verification.
- The next fix would require changing scope or product behavior beyond the user's request.

## Handling Reviewer Feedback

Do not blindly implement review comments. Treat the reviewer as a sharp peer, not an authority.

For every rejected finding, keep a short note with the evidence:

```text
Rejected: <finding summary>
Reason: <why this is not a real problem>
Evidence: <file/test/behavior checked>
```

If a reviewer repeats the same invalid finding in later iterations, reference the prior evidence instead of re-investigating from scratch.

## Test Strategy

Choose the smallest verification that can prove the fix, then broaden according to risk:

| Change type | Verification |
| --- | --- |
| Single component/helper | Targeted unit test or nearest existing test |
| Redux/service flow | Relevant reducer/action/service tests |
| Shared helper or validation | Full affected test file, then broader test suite if cheap |
| Build/runtime wiring | Lint/build or dev-server smoke check when appropriate |

Never claim the loop is clean without concrete verification output from the final iteration.

## Final Report

When the loop stops, report:

- Number of iterations used.
- Final review status: clean, capped at 10, blocked, or scope stop.
- Tests run and their result.
- Valid findings fixed.
- Findings rejected as not real problems, with short reasons.
- Any remaining risks or unresolved valid findings.

Keep the report concise; the purpose is to show the user whether the work is safe to proceed, not to narrate every intermediate thought.

## Red Flags

- Starting an 11th review pass.
- Fixing stylistic preferences as if they were defects.
- Ignoring Critical or Important valid findings.
- Treating unrelated failing tests as part of the task without evidence.
- Declaring success without rerunning relevant tests after the last fix.
