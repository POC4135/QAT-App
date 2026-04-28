# QAT Mobile App — Design Review
**Reviewed:** 2026-04-28  
**Source:** `QAT Mobile app-2.pdf` (13 screens)  
**Reviewer:** Cowork AI (Senior Full-Stack / UX Review)

---

## ✅ What's Well Designed

**Strong SOS UX.** The home screen's red SOS card with "Hold for 3 seconds" is visually dominant and unmistakable — exactly right for an emergency app. The SOS Triggered screen is calm under pressure: large countdown, clear "I'M SAFE – CANCEL" in a ghost button (so it's hard to mis-tap), and a bold red "Call Ambulance" CTA.

**Onboarding progress is transparent.** The step counter ("Step 2 of 6") paired with a percentage label and a progress bar gives users a clear mental model of where they are and how much remains.

**Color system is well-differentiated.** Red/green/orange status dots on device cards immediately communicate criticality. The palette distinguishes primary actions (#117FED blue), success (#147F3D green), and danger (#991C1C red) without ambiguity.

**Device cards are information-dense but scannable.** Each card shows name, type label, battery level, connection status, and location in a compact row — all critical data at a glance.

**Alert History grouping is intuitive.** Separating events into "Today / Yesterday / Last Week" sections with a tab filter (All / Emergencies / System) is a strong pattern for an event log.

**Contact cards on Home are actionable.** Showing Doctor Lee with direct call and message buttons on the main screen is excellent for emergency use — no drilling into menus.

---

## ⚠️ Flaws & Issues

### 1. Onboarding Progress Percentages Are Wrong
- Step 1 → 15% (expected ~17%, minor)
- Step 2 → 33% ✓
- **Step 3 → 33%** ← Same as Step 2. Should be ~50%.
- Step 4 → 66% ✓
- Step 5 → 83% ✓
- Step 6 → 95% ← Should be 100% or show "Final Step"

**Fix:** Calculate as `Math.round((step / totalSteps) * 100)`. Step 3 = 50%, Step 6 = 100%.

---

### 2. Missing States for Every Interactive Component
None of the following states are designed:

| Component | Missing States |
|-----------|---------------|
| Primary Button | Loading (spinner), Disabled |
| OTP Input | Error (wrong code, red border), Success (all filled, green) |
| Text Inputs (onboarding) | Error (red border + error message), Focused |
| Device Cards | Offline/disconnected state |
| SOS Button | Press-and-hold progress animation (0→3s) |
| Alert History | Empty state ("No alerts yet") |
| Devices list | Empty state ("No devices paired") |
| Emergency Contacts | Empty state for onboarding step 5 before adding any |

**Fix:** Add at minimum: loading, error, empty, and disabled states before implementation.

---

### 3. OTP Input — 6th Box Cut Off
The OTP screen shows only 5 of 6 input boxes fully visible; the 6th is clipped at the right edge. This appears to be a layout overflow — the boxes are too wide for the container.

**Fix:** Use `flex: 1` on each OTP box within a fixed-width container, or reduce box width from ~60px to ~48px on a 390pt viewport.

---

### 4. Missing Screens (Referenced but Not Designed)
Several actions in the design lead to screens that don't exist in the file:

- **Notification screen** — Bell icon with badge on Home header
- **Edit Profile** — Pencil badge on profile photo
- **Device detail** — Tapping any device card
- **Alert detail** — Tapping any history item
- **Emergency contacts — Full list** — "View All" on Home
- **Onboarding completion** — No success screen after Step 6 before entering Home
- **Post-SOS cancelled** — No confirmation ("You're marked safe") after cancelling SOS
- **Find a doctor / hospital search** — Referenced in Health & Preferences step
- **Household member invite flow** — The "Send Invite" action in Step 6
- **Add device flow** — No design for pairing a new device

**Fix:** These flows need to be designed or explicitly scoped out before development. Assumptions logged in the Open Questions section below.

---

### 5. Accessibility — Contrast & Focus States
- **Placeholder text** (`#93A3B7` on `#FFFFFF`) has a contrast ratio of ~2.3:1, which **fails WCAG AA** (requires 4.5:1 for normal text, 3:1 for large text). This affects all onboarding form inputs.
- **No focus states** are designed for any interactive element — critical for keyboard/switch-access users.
- **No dark mode** variant exists.
- The `#6B727F` body text on `#F4F7F7` background achieves ~4.6:1 — just passes AA.
- **"EMERGENCY TRIGGER" text** on the red (#E05252) card: white text on red should be checked — estimate ~3.8:1, which passes large text AA but fails normal text.

**Fix:** Replace placeholder color with `#6B727F` at minimum. Add visible focus rings (2px blue outline). Treat dark mode as a future milestone.

---

### 6. Smart Lock Critical State Not Handled
The Devices screen shows "Smart Lock — 12% Battery — Unlocked — Front Door." This is a safety-critical combination (very low battery + unlocked front door) with no visual warning or alert — the orange status dot is the only signal, which is too subtle.

**Fix:** Add an inline warning banner or elevated alert color when a security device is below 20% battery AND in an unlocked/active state.

---

### 7. Welcome Screen Has No Status Bar
Every other screen shows the iOS status bar (9:41, battery, signal). The Welcome screen omits it, breaking visual consistency.

**Fix:** Add a standard status bar to the Welcome screen.

---

### 8. Step 3 (Medical) — "Add another doctor" Uses Dashed Border
The "Add another doctor" button uses a dashed border card style. This is the only place in the design that uses this pattern — it's inconsistent with how "Add Another Contact" (Step 5) and "Add Another Member" (Step 6) are handled.

**Fix:** Standardise the "add item" affordance to a single ghost-button style with `+` icon across all steps.

---

### 9. Onboarding Back Navigation Ambiguity
Steps 2–6 show a `←` back arrow in the header, but it's unclear whether tapping back discards data entered on the current step or preserves it. No design spec or interaction note exists.

**Fix:** Define behaviour (auto-save on back vs. discard confirmation dialog) and add a discard confirmation modal to the design if data would be lost.

---

### 10. No Offline / No-Network State
This is an emergency app. If the user has no internet when triggering SOS, the app should show a clear fallback (e.g., direct call to 108 without app-mediated notification). No offline state is designed anywhere.

**Fix:** Design an offline banner component and define fallback behaviour for the SOS flow specifically.

---

## 🔧 Recommendations (Priority Order)

1. **Fix progress percentages** — 10-minute code fix once caught.
2. **Define and design all missing screens** — at minimum the post-SOS cancel state and device detail before sprint 1.
3. **Add error + loading states to all inputs and buttons** — required before any form implementation.
4. **Fix OTP box layout overflow** — reduce box width or use flex layout.
5. **Raise placeholder text contrast** — use `#6B727F` instead of `#93A3B7`.
6. **Add a smart-lock low-battery warning** — safety-critical, should be in scope.
7. **Add status bar to Welcome screen** — 5-minute fix.
8. **Standardise the "add item" pattern** across all onboarding steps.
9. **Define and document back-navigation data behaviour** for onboarding.
10. **Design an offline/no-network banner** — essential for an emergency app.

---

## ⏸ Open Questions

These are ambiguities encountered during analysis. Reasonable assumptions are noted and will be used during implementation unless you clarify otherwise.

| # | Question | Assumption Used |
|---|----------|-----------------|
| 1 | What happens after onboarding Step 6 "Continue"? | Navigate to Home with a brief "You're all set!" toast |
| 2 | What happens when SOS is cancelled? | Navigate back to Home with a "You're marked safe" banner for 5s |
| 3 | Is the notification bell screen in scope? | Out of scope for MVP; bell icon renders but tapping shows "Coming soon" |
| 4 | What is "Exclamation Mode" exactly? | Override-silent + high-volume siren feature; toggles are saved to user preferences |
| 5 | Does "Continue with Email" lead to a password-based flow or magic link? | Magic link (email OTP), same verify pattern as phone OTP |
| 6 | Is the Google Maps integration live or a static address picker? | Static address input with Google Places Autocomplete API |
| 7 | What triggers an alert in History — only manual SOS or also sensor events? | Both manual SOS and connected device sensor events |
| 8 | Are device connections managed via BLE in-app or a separate hub app? | Hub manages connections; this app is the monitoring interface only |
| 9 | What is "108" — is this India-specific emergency number? | Yes, Indian emergency services. App is India-first; internationalize later |
| 10 | Is the "House Identifier" (A-203) editable or auto-assigned? | User-editable during onboarding, locked after save |
