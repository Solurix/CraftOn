# Phase 1 — New-session kickoff prompt

Paste the block below into a fresh Claude Code session that has access to the app repos
(`crafton-api`, `crafton-web`). It is a condensed, self-contained brief; the full
authoritative specs live in this `crafton` repo's `docs/`.

---

```text
You are starting Phase 1 development of CRAFT-ON — an on-demand "spot matching" platform
for construction tradespeople in Japan ("Timee for construction sites"): a contractor who
is short a worker tomorrow posts a job; a worker applies and is confirmed in minutes;
the app then helps run the job. Workers use it free; contractors pay.

SOURCE OF TRUTH
- A core repo `solurix/crafton` holds all specs, ADRs, and Terraform infra. READ IT FIRST
  if you have access. Key files: CLAUDE.md, docs/04-phase-1-spec.md, docs/05-data-model.md,
  docs/06-api-contract.md, docs/07-config-and-flags.md, docs/08-compliance-legal.md,
  docs/09-testing-strategy.md, docs/10-repo-strategy.md, docs/11-i18n.md.
  Those docs are authoritative; this prompt is a summary. If they conflict, the docs win.
  If you change a decision, update the docs in the same change.
- App repos exist: `crafton-api` (backend) and `crafton-web` (frontend). Build Phase 1 in them.

LOCKED DECISIONS (do not re-litigate)
- Cloud: GCP, region asia-northeast1 (Tokyo). Dev project ID: crafton-dev-500709 (project
  number 784671749504). Infra is Terraform, already in the crafton repo — you don't recreate it.
- crafton-api: Python + FastAPI, SQLAlchemy + Alembic, Pydantic, PostgreSQL (Cloud SQL), pytest.
- crafton-web: Next.js (App Router, TypeScript), mobile-first installable PWA, with a gated
  /admin area. Tests: Vitest + React Testing Library + Playwright.
- Auth: Firebase Auth phone OTP. Frontend runs the OTP flow; the API verifies the Firebase
  ID token (Bearer) and maps it to a users row. Stateless API.
- i18n: Japanese is the DEFAULT locale; ship a COMPLETE English translation with 100% key
  parity, enforced by a CI check. Message KEYS are English. next-intl on web + a small
  catalog layer on the API for user-facing strings (errors, SMS/push, terms docs). Times
  display Asia/Tokyo; money is integer JPY.
- Everything configurable: area, fees, trades, caps, timings, penalties are config vars /
  feature flags with PERMISSIVE defaults. The ONE hard compliance gate in MVP is
  foreign-worker visa validity / work-permission. Keep contact-masking ON.
- Multi-repo: each app repo gets its own CLAUDE.md pointing back to the crafton repo and
  pinning these decisions.

PHASE 1 SCOPE — a real, working PWA where this full cycle works in dev:
  post job → worker applies → contractor confirms → check-in → check-out →
  contractor approves completion → both leave reviews.
- Roles: worker, contractor, admin (all phone-OTP auth).
- Onboarding + document upload (Cloud Storage signed URLs) + MANUAL admin vetting.
- Worker class: employee (side-job) vs freelance (一人親方). On confirm, record contract
  type (employee→day-labor employment; freelance→subcontract) + generate human-readable
  terms (placeholder wording, pending legal review).
- In-app chat with SERVER-SIDE contact masking: block/flag phone numbers, 11-digit
  sequences, "LINE", emails; handle full-width digits and kana variants.
- Residence-card (front+back) upload + visa-expiry fields present. A non-Japanese worker
  cannot be approved or confirmed without a card on file + a non-expired visa (manual check
  in P1; schema ready for P2 automation).
- Money handled OFF-APP: cash on site. Record the ¥3,000/match platform fee as "unpaid"
  for manual reconciliation. NO in-app payment.
- Two-way reviews after completion; derived trust-score display value.
- Service area = Greater Tokyo (default prefectures: Tokyo, Kanagawa, Saitama, Chiba) as a
  config var; area enforcement may start OFF (permissive).

EXPLICITLY OUT OF PHASE 1 (do NOT build): in-app payment/wallet/payout, auto withholding
tax, factoring, insurance auto-attach, AI instruction sheets, machine translation,
automated eKYC / visa auto-lock, QR/GPS auto check-in, automated no-show penalties &
recovery, subscriptions, spot-supervisor matching, native mobile app.

DATA MODEL (full columns in docs/05): users, worker_profiles, contractor_profiles,
documents, jobs, applications, matchings, reviews, messages, app_config/feature_flags.
UUID v4 PKs; integer JPY; timestamps UTC; all schema changes via Alembic migrations.

API (full list in docs/06): REST under /api/v1, Firebase Bearer auth. Implement:
auth/session + /me; onboarding (worker/contractor); profiles; documents (signed upload
URL + register); jobs (create/list/search/detail/cancel); applications (apply/confirm/
reject/withdraw); matching lifecycle (check-in, complete-request, approve-completion,
cancel); chat (POST applies masking server-side, authoritative); reviews; admin (vetting
queue, approve/reject/suspend, mark-fee-paid, config read/update); healthz/readyz.
FastAPI's auto OpenAPI is authoritative; crafton-web generates a typed client from /openapi.json.

MUST-TEST BUSINESS RULES (tests are not optional): contact-masking filter (incl. full-width/
kana edge cases); visa gate; freelance-insurance gate; matching state machine (legal
transitions only); fee recording on completion; contract-type routing; config precedence
(runtime override > env > default); per-role authorization; i18n ja/en key parity.

BUILD ORDER (from docs/04 §7):
1) crafton-api skeleton: FastAPI app, settings/config layer (env + app_config + flags), DB
   models + first Alembic migration, healthz/readyz, Firebase token auth middleware,
   .env.example, CI (ruff + mypy + pytest), README + CLAUDE.md.
2) Auth + users + onboarding + document upload + admin vetting.
3) Jobs (post/list/detail/search).
4) Matching (apply/confirm + status transitions).
5) Chat + contact masking (server authoritative).
6) Check-in/out + completion approval + fee record.
7) Reviews + trust display.
8) crafton-web: Next.js PWA shell, i18n (ja default + full en + parity check), Firebase
   auth, typed API client, then worker/contractor/admin screens consuming the API,
   installability, empty/error states, out-of-area waitlist.
9) Hardening: unit + integration tests, Playwright E2E happy-path, CI green in both repos.

WORKING AGREEMENT
- Keep the crafton docs as source of truth; update crafton/docs/STATUS.md as you progress
  (or note what needs updating if you lack access).
- Every feature ships with tests; CI must pass.
- Permissive defaults; never hardcode a tunable — read from config/flags.
- Don't pull Phase 2/3 features forward.
- Use the Firebase Auth emulator / fakes for local dev and tests; do not require real GCP
  for unit/integration tests.
- Commit in small, descriptive increments. Push per the repo's branch policy (owner
  currently prefers committing to main).
- If something is ambiguous or architecturally significant, ASK before a large refactor.

START BY: confirming repo access and exact repo names, reading the crafton docs, then
scaffolding crafton-api per build-order step 1, and share a short plan before going deep.
```
