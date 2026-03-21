# QAT Repo Manifest

This file is the authoritative cross-repo inventory for the production-readiness audit.

## Current Status
Only the client repository is available locally in this audit session. All other required repositories remain unsupplied and are active `BLOCKER` items.

| Component | Required Repo | Local Path | Remote URL | Default Branch | Environments | Owner | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| client/mobile-web | QAT-App | `/Users/prakhar/Documents/QAT/qat` | `https://github.com/POC4135/QAT-App` | `main` | local, web, android, apple platforms | Unknown | Available | Audit hub repo |
| backend/API | Not supplied | Not available | Not supplied | Unknown | Unknown | Unknown | BLOCKER | Required for auth, incident lifecycle, persistence |
| async workers/escalation | Not supplied | Not available | Not supplied | Unknown | Unknown | Unknown | BLOCKER | Required for escalation timing, retries, fan-out |
| AWS/IaC | Not supplied | Not available | Not supplied | Unknown | Unknown | Unknown | BLOCKER | Required for IAM, KMS, queues, alarms, networking |
| CI/CD definitions | Not supplied | Not available | Not supplied | Unknown | Unknown | Unknown | BLOCKER | Required for end-to-end gated verification |
| ops/runbooks/support docs | Not supplied | Not available | Not supplied | Unknown | Unknown | Unknown | BLOCKER | Client-only runbooks exist here, system runbooks do not |

## Required Fields Before A Go Decision
- exact repo URL for each component
- default branch and protected release branch
- deployment environments and environment owners
- secrets/config source for each repo
- build/test entrypoints for each repo
- rollout and rollback path for each deployable component
