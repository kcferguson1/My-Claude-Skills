# Phase 1 — Ideation & Discovery

The goal of this phase is to define the problem worth solving before a single line of code is written. You exit with a shared, written understanding of the problem, the user, and the go/no-go decision.

---

## Context Questions

Ask ALL of these before producing anything:

1. Describe your idea in 2–3 sentences. What does it do and who is it for?
2. What do users currently do instead — manual process, spreadsheet, competitor tool, nothing?
3. Do you have a specific target market or customer segment in mind?
4. Have you talked to any potential users? What did they say?
5. Do you have a rough sense of technical feasibility, or is that part of what you need figured out?
6. What's the desired output today — a problem statement, a competitive analysis, a feasibility check, or a full opportunity brief?

---

## Artifacts to Produce

### A — Problem Statement (always)

Write a single, precise sentence:
> "[User type] struggle to [do X] when [context/trigger], which causes [negative outcome]."

Validate the framing: restate the problem in user-centric terms (not solution terms), identify the core pain type (frequency / intensity / reach), and list the top 3 assumptions this idea depends on being true.

Save to: `docs/problem-statement.md`

### B — Opportunity Brief (if requested or if problem statement is solid)

A 1-page internal alignment document. Sections:
1. **The Problem** — 2–3 sentences, user-centric
2. **Why Now** — what has changed (technology, market, behavior) that makes this the right moment
3. **Target User** — a specific persona: name, role, context, the moment this product changes their day
4. **Our Approach** — what we're building and why it's different (value narrative, not feature list)
5. **Success Metrics** — 2–3 specific, measurable signals to track in the first 90 days
6. **What We're NOT Building** — explicit scope boundaries; if it's not here, it's implicitly in scope

Tone: direct, no fluff, no marketing language. 350–450 words. This is for internal alignment.

Save to: `docs/opportunity-brief.md`

### C — Competitive Landscape (if requested)

For each direct competitor:
- Core value proposition
- Pricing model
- Key strengths
- Known weaknesses (check G2, Reddit, App Store reviews)

Also cover: indirect competitors (current workarounds), emerging threats, differentiation opportunities, and a positioning recommendation for a 2–4 person team.

Save to: `docs/competitive-analysis.md`

### D — Feasibility Notes (if requested)

Break the product into components. Rate each Low / Medium / High complexity. Flag hard problems (real-time sync, ML inference, payment compliance, regulatory requirements). Estimate MVP timeline range. List top 3 technical risks with mitigations. Recommend a proof-of-concept spike (1–3 days) to validate the riskiest assumption.

Save to: `docs/feasibility-notes.md`

---

## Quality Gate

Before moving to Phase 2 (Requirements), confirm:

- [ ] Problem statement written in one precise sentence — no solution language
- [ ] Core assumption list exists; team agrees on the top 3
- [ ] Opportunity brief reviewed and agreed by all decision-makers
- [ ] Team has explicitly decided: build this, pivot the idea, or stop
- [ ] No-go criteria documented (what would change the decision)
