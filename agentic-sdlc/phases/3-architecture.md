# Phase 3 — Architecture & Design

Make key structural decisions explicit — recorded, reasoned, and reversible where possible. The most expensive rework a small team faces comes from structural decisions that weren't written down.

---

## Context Questions

Ask ALL of these before producing anything:

1. What are you building — describe the main components (frontend, API, workers, integrations)?
2. What's the team's existing tech stack familiarity? Any strong preferences or hard constraints?
3. What's the expected load profile at launch? At scale?
4. Is there any sensitive data (PII, financial, health)? Any regulatory requirements?
5. What's the specific decision or artifact you need today — ADR, data model, API contract, full architecture review?

---

## Artifacts to Produce

### A — Architecture Decision Record (ADR)

Use this format for any hard-to-reverse technical decision. Write one ADR per decision — do not bundle multiple decisions.

```markdown
# ADR-NNN: [Short title]
**Status:** Proposed
**Date:** [DATE]

## Context
[What situation forces this decision? What constraints are at play? What happens if we defer?]

## Decision Drivers
[4–6 criteria, ranked by importance — be specific, not abstract.
Not "scalability" but "must handle 10k concurrent users with a 2-person ops team."]

## Options Considered

### Option A: [Name]
[1-paragraph description]
**Pros:** [specific to our context]
**Cons:** [honest — include cost, complexity, operational burden]
**Effort estimate:** [developer-days]

### Option B: [Name]
[same format]

## Decision
[Which option and the primary reason — 2–3 sentences.]

## Rationale
[Why this option wins on what matters most at our stage. What tradeoffs are explicitly accepted.]

## Consequences
- Easier: [what gets easier]
- Harder: [what gets harder]
- Accepted tradeoff: [what we're living with]

## Revisit Trigger
[Specific condition — load threshold, team growth, feature requirement — that should prompt revisiting this decision.]
```

Save to: `docs/adr/ADR-NNN-[slug].md`

### B — Data Model

For each entity:
- Name, purpose, and fields (PostgreSQL types + constraints)
- Primary key approach (UUID recommended — justify if using serial)
- Foreign key relationships
- Indexes (which fields, why, composite if needed)
- Soft vs. hard delete recommendation
- Audit fields (created_at, updated_at, created_by where needed)
- Multi-tenancy isolation approach (row-level tenant_id recommended for startup scale)

Flag the 3 entities most likely to change shape as you learn from users. Identify any schema decisions that will become painful migrations after data accumulates.

Output as both a Prisma schema block AND a plain-language ER description.

Save to: `docs/data-model.md`

### C — API Contract

For each endpoint:
- Method + path
- Description (behavior, not implementation)
- Path params, query params, request body (types + required/optional + validation rules)
- Success response (status code + schema + example)
- Error responses (one per failure case — not generic 400/500)
- Auth requirement
- Idempotency

Also define:
- Standard error envelope: `{ error: { code, message, details?, requestId? } }`
- Pagination strategy (cursor-based recommended for feeds; offset for simple admin lists)
- Rate limiting headers
- API versioning rule (what constitutes a breaking change → version bump)

Save to: `docs/api-contract.md`

### D — Architecture Review

Evaluate against: single points of failure, data consistency risks, security perimeter gaps, scalability bottlenecks, operational complexity (2am incident diagnosis), developer experience (new engineer productive on day 1). For each issue: describe the risk, severity (Critical/High/Medium/Low), and mitigation. Skip low-risk issues for an early-stage product.

Save to: `docs/architecture-review.md`

---

## Quality Gate

Before moving to Phase 4 (Development), confirm:

- [ ] ADRs written for: database, API layer, auth, and any other hard-to-reverse decision
- [ ] No Critical-severity architecture issues unresolved
- [ ] Data model reviewed; all entities have indexing strategy and multi-tenancy approach
- [ ] API contract defined for all MVP endpoints with standardized error envelope
- [ ] At least two team members have reviewed the architecture
