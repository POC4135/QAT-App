# Trust Proof Testing

Use [`docs/testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)
as the canonical testing standard for QAT.

`tool/trust_proof.sh` remains the top-level verification entrypoint, but the
master SOP now defines:
- the unit, smoke, and regression suite structure
- the required local and CI commands
- failure triage rules
- manual release checks
- the current trust limits of this client-only repository
