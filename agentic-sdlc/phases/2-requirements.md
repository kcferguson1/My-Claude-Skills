# Phase 2 — Requirements & Specification

Translate the opportunity brief into a developer-ready specification. Every story must be independently implementable, testable, and scoped to a single behavior. Ambiguity here compounds in every phase that follows.

---

## Context Questions

Ask ALL of these before producing anything:

1. Do you have an opportunity brief or problem statement I can read? (If yes, read it from `docs/`)
2. Who are the 2–3 primary user types this product serves?
3. What is the core workflow — walk me through what a user does from first login to their main goal
4. What's the MVP timeline goal? (weeks/months)
5. Are there any non-negotiable technical or compliance requirements (GDPR, HIPAA, SSO, etc.)?
6. What do you need today — a full PRD, just user stories, scope prioritization, or NFR checklist?

---

## Artifacts to Produce

### A — Product Requirements Document (PRD)

Sections:
1. **Overview**
   - Problem (1 paragraph, user-centric)
   - Solution (1 paragraph — core value mechanism, not feature list)
   - MVP Goals (3–5 measurable outcomes)

2. **User Personas** (2–3)
   Each: name, role, primary goal, key frustration this product resolves, representative scenario

3. **User Stories** — organized by epic
   Format: *"As a [user], I want to [action] so that [outcome]."*
   Minimum 10–15 stories for a complete MVP. Label each MUST / SHOULD / COULD.
   Flag stories where a product decision is needed before dev can start.

4. **Acceptance Criteria** — BDD format for every MUST story
   Given [initial context] / When [action taken] / Then [expected outcome]
   Include: happy path, empty/zero state, at least one error case per story.

5. **Non-Functional Requirements**
   - Performance: LCP target, API p50/p99 response time
   - Security: auth standard, encryption at rest and in transit
   - Accessibility: WCAG 2.1 AA
   - Browser support
   - Uptime SLA

6. **Out of Scope** — explicit list; if it's not here, it's implicitly in scope

7. **Open Questions** — table: question | blocks what | owner | deadline

Save to: `docs/PRD.md`

### B — MVP Scope Cut (if backlog is too large)

For each feature: evaluate core necessity (can the product be user-tested without it?), build cost in developer-days, learning value, and deferral risk. Output three tiers:

- **MUST ship**: without this, the product can't be meaningfully evaluated
- **v1.1**: high value, safely deferrable; note what feedback to watch for
- **Cut**: low signal-to-cost ratio; one sentence on why

End with: Tier 1 total estimated build days vs. timeline. If over budget, flag it.

Save to: `docs/scope-prioritization.md`

---

## Quality Gate

Before moving to Phase 3 (Architecture), confirm:

- [ ] PRD reviewed and approved by all team members and stakeholders
- [ ] Every MUST story has at least one testable acceptance criteria (Given/When/Then)
- [ ] Out-of-scope list is explicit and agreed
- [ ] All open questions have an assigned owner and deadline
- [ ] No XL-complexity stories remain unbroken into smaller pieces
- [ ] NFRs defined — no "TBD" on security or performance targets
