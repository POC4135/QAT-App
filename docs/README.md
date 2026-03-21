AI/LLM agents: start with this file, then read `architecture.md`,
`state_and_data.md`, `user_flows.md`, `configuration.md`, and
`testing_sop.md` before making non-trivial changes.

# Documentation Hub

This directory is the documentation package for the QAT client repository. It
is intended to help:
- a new engineer understand the app quickly
- an AI coding agent build accurate context before editing
- a reviewer or operator find the right source of truth for testing, release,
  support, and configuration

## Recommended Reading Order

### For engineers new to the repo
1. [`../README.md`](/Users/prakhar/Documents/QAT/qat/README.md)
2. [`architecture.md`](/Users/prakhar/Documents/QAT/qat/docs/architecture.md)
3. [`codebase_map.md`](/Users/prakhar/Documents/QAT/qat/docs/codebase_map.md)
4. [`state_and_data.md`](/Users/prakhar/Documents/QAT/qat/docs/state_and_data.md)
5. [`user_flows.md`](/Users/prakhar/Documents/QAT/qat/docs/user_flows.md)
6. [`configuration.md`](/Users/prakhar/Documents/QAT/qat/docs/configuration.md)
7. [`engineering_guide.md`](/Users/prakhar/Documents/QAT/qat/docs/engineering_guide.md)
8. [`testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)

### For AI / LLM coding agents
1. [`ai_agent_guide.md`](/Users/prakhar/Documents/QAT/qat/docs/ai_agent_guide.md)
2. [`architecture.md`](/Users/prakhar/Documents/QAT/qat/docs/architecture.md)
3. [`state_and_data.md`](/Users/prakhar/Documents/QAT/qat/docs/state_and_data.md)
4. [`user_flows.md`](/Users/prakhar/Documents/QAT/qat/docs/user_flows.md)
5. [`configuration.md`](/Users/prakhar/Documents/QAT/qat/docs/configuration.md)
6. [`testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)

## What Each Document Covers

### Product and runtime
- [`architecture.md`](/Users/prakhar/Documents/QAT/qat/docs/architecture.md)
  explains startup, scopes, routing, shell behavior, theming, and app-wide
  services.
- [`state_and_data.md`](/Users/prakhar/Documents/QAT/qat/docs/state_and_data.md)
  explains domain models, seeded data, persistence, and emergency transitions.
- [`user_flows.md`](/Users/prakhar/Documents/QAT/qat/docs/user_flows.md)
  explains how the app behaves screen by screen in both normal and accessibility
  modes.

### Code navigation
- [`codebase_map.md`](/Users/prakhar/Documents/QAT/qat/docs/codebase_map.md)
  maps directories, key files, and where to make common changes.
- [`engineering_guide.md`](/Users/prakhar/Documents/QAT/qat/docs/engineering_guide.md)
  explains implementation conventions and expected extension patterns.

### Configuration, testing, and ops
- [`configuration.md`](/Users/prakhar/Documents/QAT/qat/docs/configuration.md)
  explains runtime config, local prefs, build inputs, and platform packaging.
- [`testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)
  is the canonical testing standard.
- [`testing_trust_proof.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_trust_proof.md)
  is the short explanation of the trust-proof gate.
- [`emergency_flow_config.md`](/Users/prakhar/Documents/QAT/qat/docs/emergency_flow_config.md)
  explains the emergency countdown config.
- [`runbooks/client-release.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md)
  covers client release steps.
- [`runbooks/support-triage.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md)
  covers support and triage guidance.

## Scope Reminder

This documentation package describes the Flutter client repository only. It
does not describe a backend implementation because that code is not present in
this repo.
