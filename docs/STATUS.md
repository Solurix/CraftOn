# STATUS — living progress tracker

> Update this file at the end of every work session. It is the first thing a new GenAI
> session reads after `CLAUDE.md`.

_Last updated: 2026-06-27_

## Current phase
**Phase 1 — feature-complete (dev).** The full cycle works end-to-end:
post job → apply → confirm → check-in → check-out → approve completion → reviews,
with admin vetting, the visa/insurance gates, server-side contact masking, and
the ¥3,000 fee record. Backend (`crafton-api`, build-order steps 1–7) and the
PWA (`crafton-web`, step 8) are built and green; happy-path E2E in place (step 9).
**Pushed to `main`** in both app repos. Remaining: `terraform apply` to deploy
(needs billing + state bucket), real Firebase wiring, and legal sign-off on terms.
with admin vetting, the visa/insurance gates, server-side contact masking, and
the ¥3,000 fee record. Backend (`crafton-api`, build-order steps 1–7) and the
PWA (`crafton-web`, step 8) are built and green; happy-path E2E in place (step 9).
**Pushed to `main`** in both app repos. Remaining: `terraform apply` to deploy
(needs billing + state bucket), real Firebase wiring, and legal sign-off on terms.

## Done
- ✅ Product overview, architecture, roadmap agreed (`docs/01`–`03`).
- ✅ Detailed Phase 1 spec (`docs/04`).
- ✅ Data model, API contract, config/flags (`docs/05`–`07`).
- ✅ Compliance/legal notes, testing strategy, repo strategy, glossary (`docs/08`–`10`, glossary).
- ✅ i18n policy: Japanese default + full English, English dev language (`docs/11`, ADR 0008).
- ✅ ADRs for the locked decisions (`docs/adr/`).
- ✅ Terraform skeleton (`infra/terraform/`) — not yet `apply`-ed (needs GCP project + billing).
- ✅ **`crafton-api` skeleton (build-order step 1)** on branch
  `claude/crafton-phase-1-dev-9d5sof`:
  - FastAPI app factory, structured logging, uniform `{error:{code,message}}` envelope.
  - **Config/flags layer** with precedence `app_config row > CRAFTON_CFG__<KEY> env >
    default`, registry mirroring `docs/07` (nothing hardcoded; compliance gates default ON).
  - **All Phase 1 DB models** (`docs/05`) + **initial Alembic migration**; `alembic check`
    reports no drift, upgrade→downgrade→re-upgrade verified clean.
  - **Firebase auth** behind a verifier abstraction (real + fake for dev/CI/tests; no GCP
    needed), `POST /auth/session` + `GET /me`, role guards.
  - **i18n catalog** on the API (`ja`/`en`) + parity check wired into CI.
  - `/healthz` + `/readyz`; CI (ruff, mypy, i18n parity, migration round-trip, pytest).
- ✅ **`crafton-api` Phase 1 backend (steps 2–7)** on `main`:
  - **Onboarding + documents + admin vetting** (step 2): worker/contractor onboarding,
    signed-URL document upload (storage abstraction: fake for dev/CI, GCS for prod),
    vetting queue + approve/reject/suspend with the **visa gate** (non-JP needs card +
    non-expired visa).
  - **Jobs** (step 3): post/list/detail/search/cancel with config-driven service-area &
    allowed-trades checks (permissive by default).
  - **Matching** (step 4): apply/confirm, **state machine** (legal transitions only),
    contract-type routing (employee→day-labor, freelance→subcontract), **freelance-insurance
    gate**, wage snapshot, generated placeholder terms.
  - **Chat + contact masking** (step 5): server-authoritative masking of phones/11-digit/
    email/LINE incl. full-width & kana edge cases.
  - **Check-in/out + completion + fee** (step 6): lifecycle endpoints; ¥3,000 fee recorded
    unpaid; admin matchings list + mark-fee-paid + config read/update. New
    `matchings.completion_requested_at` column (+ migration; docs/05 updated).
  - **Reviews + trust** (step 7): two-way reviews after completion; derived trust_score/rating.
  - **109 tests** (incl. all must-test rules + a full-cycle integration test); ruff + mypy clean.
- ✅ **`crafton-web` PWA (step 8)** on `main`: Next.js App Router PWA, next-intl (ja+en,
  parity in CI), Firebase-OTP auth abstraction (fake mode for dev/CI/E2E), typed client from
  the API OpenAPI, full worker/contractor/admin screens for the cycle, installability,
  empty/error states. Vitest + lint + typecheck + build green.
- ✅ **Hardening + E2E (step 9)**: API-level full-cycle test + Playwright browser smoke
  (signup→onboarding) verified against a running API.

## In progress
- (Phase 1 dev build complete — see "Next up" for deployment + go-live items.)

## Next up (in order)
1. **Owner:** link **billing** to `crafton-dev-500709` and create the versioned **GCS
   state bucket** `crafton-dev-500709-tfstate` (then uncomment `dev/backend.tf`).
2. ✅ App repos `crafton-api` and `crafton-web` created by owner.
   ✅ Dev Project ID confirmed (`crafton-dev-500709`) and wired into Terraform.
3. ✅ Phase 1 app built end-to-end in both repos (steps 1–9 above), pushed to `main`.
4. **Deploy:** `terraform apply` the `dev` environment (once #1 done); build/push the API +
   web containers to Cloud Run; wire Cloud SQL, Storage bucket, and the real Firebase project.
5. **Go-live prep:** swap `CRAFTON_AUTH_MODE`/`NEXT_PUBLIC_AUTH_MODE` to `firebase` and wire
   the Firebase web SDK; legal sign-off on the auto-generated terms wording; add app icons.

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
