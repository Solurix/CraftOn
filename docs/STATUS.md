# STATUS — living progress tracker

> Update this file at the end of every work session. It is the first thing a new GenAI
> session reads after `CLAUDE.md`.

_Last updated: 2026-06-27_

## Current phase
**Phase 0 → 1.** Foundation docs + infra skeleton in place. App not built yet.

## Done
- ✅ Product overview, architecture, roadmap agreed (`docs/01`–`03`).
- ✅ Detailed Phase 1 spec (`docs/04`).
- ✅ Data model, API contract, config/flags (`docs/05`–`07`).
- ✅ Compliance/legal notes, testing strategy, repo strategy, glossary (`docs/08`–`10`, glossary).
- ✅ i18n policy: Japanese default + full English, English dev language (`docs/11`, ADR 0008).
- ✅ ADRs for the locked decisions (`docs/adr/`).
- ✅ Terraform skeleton (`infra/terraform/`) — not yet `apply`-ed (needs GCP project + billing).

## In progress
- (nothing actively coding yet)

## Next up (in order)
1. **Owner:** link **billing** to `crafton-dev-500709` and create the versioned **GCS
   state bucket** `crafton-dev-500709-tfstate` (then uncomment `dev/backend.tf`).
2. ✅ App repos `crafton-api` and `crafton-web` created by owner.
   ✅ Dev Project ID confirmed (`crafton-dev-500709`) and wired into Terraform.
3. **Start a new session** to build Phase 1 using `docs/phase-1-kickoff-prompt.md`.
4. Scaffold FastAPI API (models + first migration + auth middleware + healthz), then build
   Phase 1 features in the order in `docs/04-phase-1-spec.md` §7.
5. `terraform apply` the `dev` environment (once #1 done) to deploy.

## Open questions / blockers
- [~] GCP **dev project** confirmed: **Project ID `crafton-dev-500709`** (number
  784671749504), wired into `infra/terraform/environments/dev/`. Remaining before
  `terraform apply`: link a **billing account** and create a versioned **GCS state
  bucket** (`crafton-dev-500709-tfstate`), then uncomment `backend.tf`.
  `crafton-prod` project is created later.
- [ ] Exact "Greater Tokyo" prefecture list (default: Tokyo, Kanagawa, Saitama, Chiba).
- [ ] Initial trade list (default: open free-text + suggestions).
- [ ] Legal sign-off owner for contract/tax/insurance/visa wording (Phase 2 lead time).
- [ ] Confirm Firebase project setup approach (within same GCP project).
- [ ] eKYC vendor decision (TRUSTDOCK vs defer) — needed before Phase 2.

## Decisions log (pointers)
All locked decisions are in `docs/adr/`. Summary table in `CLAUDE.md`.
