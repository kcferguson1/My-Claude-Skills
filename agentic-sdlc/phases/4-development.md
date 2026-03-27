# Phase 4 — Development

The agent is a pair programmer, reviewer, and documentation writer — not a replacement for understanding the code. Every AI-generated block gets the same human review as human-written code.

---

## Context Questions

Determine which sub-task the user needs. The most common are:

**Code review:** ask for the code diff or PR description, and which story it implements.

**Implementation planning:** ask for the user story + acceptance criteria, and which layers need to change (DB, API, frontend).

**Debugging:** ask for the exact symptom, reproduction steps, relevant code, and logs.

**Refactoring:** ask what problem the current structure causes, and what the desired end state looks like.

**Documentation:** ask which module or function, and who the audience is (new team member? external consumer?).

Do not ask generic questions — match your questions to the specific sub-task.

---

## Artifacts to Produce

### A — Implementation Plan (before any code is written)

When a user has a story to implement, produce a plan first. Do not write implementation code until they confirm the plan.

Structure:
1. **Implementation steps** — ordered from data layer → API → frontend → tests. Include "write tests" as explicit steps.
2. **Files to create or modify** — every file, with a one-line description of the change. Group by layer.
3. **Database changes** — new tables, columns, indexes, migrations (SQL or Prisma schema syntax).
4. **API changes** — new or modified endpoints with request/response schemas.
5. **Edge cases to handle** — permissions check, empty/null state, duplicate/idempotency, downstream failure.
6. **What NOT to do** — scope boundaries; common over-engineering traps for this type of feature.

Save to: nothing by default. Present in-conversation. Save to `docs/implementation-plans/[story-slug].md` if the user asks.

### B — Code Review

Review for substance only — not style (that's the linter's job).

Evaluate:
1. **Correctness** — fulfills all acceptance criteria? Logic errors? Missed edge cases?
2. **Security** — injection risks, auth bypass, authorization per-resource (not just "logged in"), sensitive data in logs or responses, secrets in code
3. **Error handling** — caught at the right level? Logged with context? Graceful degradation?
4. **Performance** — N+1 queries, unbounded list queries, missing async/await, unnecessary data fetching
5. **Testability** — what's hard to test in the current structure? What refactor would fix it?

Format each finding: `[file:line] [Critical/High/Medium/Low] — [description of problem] → [specific fix]`

### C — Debugging

Work systematically. Do not guess.

1. List root cause hypotheses in order of probability, with reasoning for each
2. For the top 2–3: give the minimum diagnostic step (log statement, null check, test) that confirms or rules it out
3. If intermittent: describe how to instrument the code to capture state when it next occurs
4. Once cause identified: give the correct fix and check if the same pattern exists elsewhere
5. Prevention: what test, type, or lint rule would have caught this earlier?

### D — Code + Documentation

When writing implementation code:
- Fill in ALL real values — never use generic placeholder names (not `myFunction`, `data`, `result`)
- Follow the existing patterns in the codebase (ask for examples if not visible)
- Write JSDoc/TSDoc for every exported function: what it does, params, return, throws, side effects
- Inline comments only for non-obvious logic — explain the "why," not the "what"
- If writing a new module, include a 3–5 sentence README section: purpose, when to use it, one common mistake to avoid

---

## Quality Gate (PR Merge Criteria)

Before merging any PR, confirm:

- [ ] All acceptance criteria from the story are demonstrably met
- [ ] At least one team member has reviewed the PR
- [ ] No Critical or High-severity review findings unresolved
- [ ] CI is green: lint, type-check, unit tests, integration tests
- [ ] No secrets, credentials, or debug code committed
- [ ] Non-obvious logic has inline comments; new modules have docstrings
