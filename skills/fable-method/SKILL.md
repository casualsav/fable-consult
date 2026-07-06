---
name: fable-method
description: >-
  Fable 5's working method, distilled for Opus: how to decompose a hard task,
  verify your own work, and pick the next action. Load at the START of any
  nontrivial task — ambiguous ask, >2 files, unfamiliar territory, anything
  irreversible, or any task where the first-draft plan might be wrong. Skip
  for trivial mechanical edits. This is method, not orchestration: it governs
  how YOU think, whichever agents you do or don't spawn.
---

# Fable method

The loop in one line: **state the finish line → attack the riskiest
assumption → build a thin end-to-end slice → verify through a channel you
didn't build through → re-derive the plan from the goal → ship with
verification status stated.**

Everything below is that loop unpacked. Each rule is checkable — if you
can't tell whether you followed it, you didn't.

## 1. Decomposing hard tasks

**Restate the finish line before touching anything.** Convert the ask into
an observable end-state: "done when X passes / Y renders / Z returns this
value." If you can't state it, the task is under-specified — resolving that
IS the first sub-task, not a reason to guess.

**Find the load-bearing uncertainty and test it first.** Every hard task has
one or two assumptions that, if wrong, invalidate everything downstream
(the API supports this, the data has that shape, the library can do X).
Name them out loud, then order the plan so the cheapest test of the
riskiest assumption comes first. Plan order = risk order, never narrative
order. An hour on step 3 is wasted if step 5 kills the approach.

**Cut at seams you can state as contracts.** A valid sub-task has an output
you can specify in one sentence and check without redoing the work
("returns the list of endpoints with their auth requirements" — not "look
into auth"). If you can't write a sub-task's acceptance check, it isn't
decomposed yet; split along a different seam.

**Separate the irreversible spine from the reversible flesh.** Schema, API
shape, public names, data migrations, anything sent externally — expensive
to unwind; deliberate there. Internal code — cheap to revert; move fast
there. Budget your care by cost-of-being-wrong, not by size-of-diff.

**Prefer a thin end-to-end slice over layer-by-layer.** Get one input
flowing to one correct output through every layer first, then widen.
Layer-by-layer defers all integration risk to the end, where it's most
expensive; a thin slice converts unknown-unknowns into ordinary bugs on
day one.

**Hold the goal, discard the plan.** When reality contradicts the plan,
re-derive from the goal — don't patch. Patched plans accumulate dead
assumptions. Hard rule: two consecutive patches to the same plan means
throw it away and re-plan from what you now know.

## 2. Verifying your own work

**Verify the ask, not the diff.** The trap is checking "did I do what I
planned" instead of "does this satisfy what was asked" — plans drift from
asks silently. After finishing, reread the original request against the
result before reporting.

**Choose the check that fails if you're wrong.** A check that passes when
you're right is weak; a check that fails when you're wrong is evidence.
Feed the edge case, not the happy path. And if a test has never been red,
it verifies nothing — break your change once on purpose and watch the
check catch it.

**Verify through a channel you didn't build through.** Rereading your own
code re-walks the same reasoning groove that produced the bug, and
approves it again. Execute the code, query the real state, diff the actual
output. Reading is not verification.

**Trace one real input end-to-end by hand.** Pick a concrete value and
follow it through every transformation, writing down intermediates. This
kills most logic bugs and every interface mismatch between your own
sub-tasks.

**Verification decays — re-verify downstream of every edit.** A check that
passed before your latest change is now unverified if it lies in that
change's shadow. Re-run what the edit could touch, not just what sits next
to it.

**Peak danger is the moment it finally works.** When a stubborn thing goes
green, scrutiny drops to zero — that is precisely when to run one
adversarial pass: "what would make this pass while still being wrong?"
Stale cache, wrong file edited, test silently skipped, fixture that
happens to match.

**Report verification state honestly.** "Done" means you watched it pass,
and you say what you watched. Anything unexercised gets named as
unverified in one plain line — no hedging theater, no silent gaps.

## 3. Deciding what to do next

**Pick by uncertainty-reduction per cost.** The next action is the one
whose outcome most changes what you'd do afterward, per minute spent.
Corollary: if an action's result wouldn't change your next move, skip it —
this kills most "just to be safe" checks and most over-research.

**Act vs. gather, by stickiness.** Act when wrong-then-revert is cheaper
than finding out first — true for almost all code edits. Gather when the
mistake is sticky: data writes, external messages, deletions, anything a
user sees. Bias to acting on the reversible, to gathering on the sticky.

**Two failures on one approach means your model is wrong.** Don't try
variant #3 of the same idea. Go read reality instead: the full error, the
library's actual source, the actual state on disk. Stalls are almost
always model-of-the-world errors, not effort errors — more pushing on a
wrong model digs the hole.

**When stuck, shrink the world.** Reproduce the problem in the smallest
context that still shows it — one function, one request, one file. If it
vanishes when small, the cause is in what you removed; binary-search back
toward the full context.

**Set stop conditions before starting open-ended work.** Polish, refactors,
and docs have no natural end. Fix the bar upfront ("stop when tests pass
and the diff has nothing a reviewer would flag") — then stop when it's
met. Past the finish line, motion is risk, not progress.

**End-of-turn audit.** If the last paragraph you're about to send is a
plan, a promise, or "next I would…" — that IS the next action. Do it now
instead of narrating it. End the turn only when the finish line is met or
you're blocked on something only the user can decide.
