# Phase 6 — Deploy & Operations

Deployment should be boring. An incident should be diagnosable. A rollback should take under 5 minutes. These are engineering outcomes, not aspirations — they require intentional design before the first production deploy.

---

## Context Questions

Determine the sub-task first. Most common:

**CI/CD setup:** ask for stack details, cloud provider, container registry, and environments needed.

**Infrastructure:** ask for cloud provider, IaC tool preference, expected user scale, and data sensitivity.

**Incident triage:** ask for the symptom, timeline, user impact scope, recent changes, logs, and metric anomalies.

**Runbook:** ask for deployment mechanism, rollback strategy, and who needs to be notified.

Match your questions to the specific sub-task.

---

## Artifacts to Produce

### A — GitHub Actions CI/CD Pipeline

Generate complete, working YAML for all four workflow files. No placeholders — fill in real values based on the stack the user describes.

**`.github/workflows/ci.yml`** — triggers on every push and PR:
- Setup: checkout, Node version with `node_modules` cache keyed on `package-lock.json` hash
- Lint → type-check → unit tests → integration tests (PostgreSQL service container) → build
- Upload build artifact
- All jobs have `timeout-minutes` set
- Post test results as PR status check

**`.github/workflows/deploy-staging.yml`** — triggers on merge to `main`:
- Run full CI suite
- Build Docker image, tag with `${{ github.sha }}`
- Push to container registry (ECR / ACR / Artifact Registry)
- Deploy to staging
- Run smoke tests (Playwright) against staging URL
- Notify on success or failure; halt on failure (no auto-rollback for staging)

**`.github/workflows/deploy-production.yml`** — triggers on release tag (`v*.*.*`):
- Require manual approval via GitHub Environment protection rule
- Deploy the SAME image SHA that passed staging — do not rebuild
- Run smoke tests against production URL
- On success: create GitHub deployment record
- On failure: trigger rollback job automatically

**`.github/workflows/rollback.yml`** — manually triggered:
- Inputs: `environment` (staging/production) and `target_image_tag`
- Redeploy the specified previous image tag
- Run smoke tests; report result

Also output: a complete list of every GitHub secret required, with description and how to generate each one.

Secrets rule: never log secrets. Use `::add-mask::` for any dynamic secret values.

### B — Infrastructure as Code

Generate for the specified cloud provider and IaC tool. Optimize for: low cost at startup scale, low operational overhead, expandable to 50k users without architectural rewrite.

Include:
- **Compute**: ECS Fargate / Container Apps / Cloud Run with autoscaling (min 1, reasonable max, CPU-based trigger)
- **Database**: managed PostgreSQL with automated daily backups, private subnet, connection pooling recommendation
- **Networking**: VPC/VNET with public subnet (LB only) and private subnet (compute + DB); security groups with least-privilege rules
- **Load Balancer**: HTTPS with ACM/managed cert, HTTP→HTTPS redirect, health check config
- **Object Storage**: private bucket, signed URL access pattern, lifecycle rule for cost management
- **Secrets Management**: least-privilege IAM — compute role reads only its own secrets
- **Monitoring Alarms**: CPU >80% for 5min, 5xx error rate >1% for 5min, p99 latency >2s for 5min, DB connections >80% of max

Add comments explaining non-obvious choices. Flag any setting that should be revisited at 10k+ users.

Save to: `infra/` directory in the appropriate file structure for the chosen IaC tool.

### C — Incident Triage

Work quickly — this is live.

1. **Root cause hypothesis** — most probable cause given all signals, with stated confidence level and what makes you uncertain
2. **Next 3 diagnostic steps** — in order of speed and signal strength; for each: what to look for and what it would confirm
3. **Fastest mitigation path** — what stops user impact NOW, even if not the correct fix (rollback, feature flag, rate limit, traffic redirect)
4. **Blast radius check** — who else could be affected not yet identified (other services, downstream integrations, async jobs, specific user segments)
5. **Internal status update** — 3–4 sentences for the team: what's broken, who's affected, what's being done. Non-technical, factual, no speculation.

Think out loud. Reasoning matters more than a confident wrong answer.

### D — Deployment Runbook

Write so an engineer who has never deployed this app can execute it under pressure at 11pm.

Sections:
1. **Pre-deployment checklist**: CI green on the target commit, image promoted from staging (not rebuilt), staging smoke tests passed, migrations are backwards-compatible, baseline metrics recorded, rollback target confirmed, stakeholders notified
2. **Deployment steps**: exact commands or workflow triggers with expected state after each step
3. **Post-deploy verification (first 10 minutes)**: health check URLs, smoke test commands, key metrics to watch vs. baseline, specific log lines that confirm success
4. **Rollback procedure**: trigger condition (define the error rate threshold), exact rollback steps including DB migration reversal if needed, expected completion time, how to verify success
5. **Common failure modes**: the 4 most likely things to go wrong, each with: symptom → diagnosis → fix
6. **Post-deploy monitoring**: how long to watch, what "stable" looks like, what to communicate when done

Save to: `docs/deployment-runbook.md`

---

## Quality Gate (Production Readiness)

Before accepting production traffic, confirm:

- [ ] CI/CD pipeline tested end-to-end on staging — not just written, actually executed
- [ ] Production deploy requires human approval — no auto-deploy to production
- [ ] Rollback tested: time from "decision" to "rollback complete" measured and documented
- [ ] Monitoring alerts configured AND tested (verify they actually fire — don't assume)
- [ ] Deployment runbook reviewed by at least one engineer who didn't write it
- [ ] Incident response process defined: who gets paged, how, and what they do in the first 5 minutes
