# Phase 5 — Testing & QA

Tests are the machine-readable specification of your product's behavior. A well-instrumented suite is the highest-leverage investment a small team can make — it's what lets you move fast later without breaking things.

---

## Context Questions

Ask ALL of these before producing anything:

1. What code needs to be tested? (paste it, or describe the module/function/API route)
2. What testing frameworks are you using? (default: Jest + Supertest for API, React Testing Library for components, Playwright for E2E)
3. What mocking approach do you use? (Jest mocks, MSW, manual stubs)
4. Are there existing tests I should follow the pattern of? If so, paste an example.
5. What kind of tests do you need — unit, integration, E2E, or a coverage gap analysis?

---

## Artifacts to Produce

### A — Unit & Integration Tests

Write tests that cover every meaningful behavioral case. Organize:

**Unit tests (external deps mocked):**
- Happy path — specific input values, exact expected output
- Input validation — for each required field: missing, null, wrong type, empty string, boundary values; assert specific error codes
- Business rule branches — test both sides of every conditional; test zero, negative, decimal, and max values for calculations
- Error propagation — when a dependency throws, what should this function do? Test that exact behavior

**Auth and permission tests — always required, never skip:**
These are the most commonly missed and the highest-risk gaps. For every route or function that touches auth:
- Unauthenticated request: no token / no session / `req.user` is undefined — assert 401 and that no data operation was performed
- Expired or malformed token — assert 401 with appropriate error code
- Valid token but insufficient role/scope — assert 403, not 200 or 401
- Accessing another user's resource while authenticated — assert 403 or 404 (depending on your threat model), never 200

**Integration tests (for API routes — real DB, network mocked):**
- Full request → response cycle for happy path
- All auth failure cases above (unauthenticated, expired, wrong role, cross-user access)
- Correct HTTP status codes for every documented error case
- Response body matches the API contract

Test naming: `"should [expected behavior] when [condition]"`

After the suite, flag any code that is difficult to test in its current structure and recommend the specific refactoring.

Save to: the appropriate `__tests__/` directory or co-located test file, following existing project conventions.

### B — Playwright E2E Tests

For critical user workflows — the flows that must never break.

For each scenario:
- **Test name:** `"User can [complete action] when [precondition]"`
- **Preconditions:** exact DB state, auth state, feature flags
- **Steps:** exact Playwright interactions using accessible selectors (`getByRole`, `getByLabel`, `getByTestId` — in that preference order)
- **Assertions:** final URL, visible confirmation text, expected DB/API state
- **Teardown:** what to clean up

Playwright best practices:
- Use `expect(locator).toBeVisible()` with timeout, never `page.waitForTimeout()`
- Use `page.waitForResponse()` for API-dependent assertions
- Document any inherently non-deterministic steps and how to stabilize them

Also identify: the 3–5 smoke tests that must pass before every production deploy. These should run in under 2 minutes.

Save to: `tests/e2e/[workflow-name].spec.ts`

### C — Coverage Gap Analysis

Review existing coverage and recommend what to test next — prioritized by risk, not line count.

Produce:
1. **High-risk uncovered paths** — business-critical operations, auth/permission logic, payment flows, data mutations. Skip: simple getters, config, UI scaffolding.
2. **False coverage** — tests that inflate coverage without testing behavior: only asserting "it returns something," mocking away all interesting behavior, or only covering the happy path of a 5-branch function.
3. **Integration layer gaps** — units that work in isolation but interact incorrectly (e.g., service assumes DB returns `[]` for empty; DB actually returns `null`).
4. **Recommended next 8 tests** — prioritized list with: test name, type (unit/integration/E2E), what it covers, why it's high priority.

---

## Quality Gate

Before moving to Phase 6 (Deploy & Ops), confirm:

- [ ] Unit test coverage meets threshold for business-critical modules (define the threshold, don't leave it open)
- [ ] Every API endpoint has: happy path, auth failure, and validation error integration tests
- [ ] Smoke test suite covers 3–5 most critical user workflows
- [ ] CI enforces coverage thresholds — build fails below the floor
- [ ] No known flaky tests (a test that passes on retry is not green)
