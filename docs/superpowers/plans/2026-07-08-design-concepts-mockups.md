# EC Home Inspections Design-Concepts Mockups Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a client-facing presentation package: 4 clickable, self-contained homepage mockups in distinct visual directions, plus an index page linking them.

**Architecture:** Every mockup is a single static HTML file with inline CSS and embedded SVG — no build step, no JavaScript required, no external network dependencies. All four share the exact same content skeleton (markup + copy, defined below); only the `<style>` block and decorative SVG/structural embellishments differ. A shell script validates each file.

**Tech Stack:** Hand-written HTML5 + CSS. System font stacks only. Bash for validation.

**Spec:** `docs/superpowers/specs/2026-07-08-design-concepts-design.md`

## Global Constraints

- Files must open correctly via `file://` with **zero network requests for assets**. External `href` on anchors is allowed only for the TREC Consumer Protection Notice link.
- **No web fonts, no CDN CSS/JS, no stock photos, no raster images.** All imagery is CSS or inline SVG.
- **System font stacks only** (each direction picks its own stacks).
- Every mockup must be mobile-responsive (client reviews on her phone). Test mentally at 375px and 1280px; no horizontal scroll at either.
- Executors of mockup tasks MUST load the `frontend-design:frontend-design` skill before writing HTML/CSS.
- Brand anchors (each direction may tint/shade but must clearly read blue + orange): brand blue `#1E6FD9`, brand orange `#F97316`.
- Placeholder contact info, used verbatim everywhere: phone `(361) 555-0100`, email `edna@echomeinspectionstx.com`.
- Commit after every task.

### Shared logo SVG (identical in all four mockups + index)

An original house-outline "EC" monogram — blue "E" whose top arm is the left roof slope; orange reversed-"C" formed by the right roof slope, right wall, and bottom arm. Do NOT copy the client's Shutterstock reference.

```html
<svg class="logo" viewBox="0 0 96 88" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="EC Home Inspections logo">
  <path fill="#1E6FD9" d="M48 4 L10 26 L10 84 L44 84 L44 72 L22 72 L22 56 L40 56 L40 44 L22 44 L22 32 L48 17 Z"/>
  <path fill="#F97316" d="M48 4 L86 26 L86 84 L52 84 L52 72 L74 72 L74 32 L48 17 Z"/>
</svg>
```

Directions may recolor the two `fill`s to their palette's blue/orange variants but may not alter the paths.

### Shared content skeleton (canonical markup + copy)

Every mockup contains exactly these sections, in this order, with this copy verbatim. Class names/wrappers may be adapted per direction; copy and section order may not. Forms are non-functional demos (no `action`).

```html
<header>
  [logo SVG] <span>EC Home Inspections</span>
  <nav><a href="#book">Book</a> <a href="#services">Services</a> <a href="#report">Your Report</a> <a href="#contact">Contact</a></nav>
  <a href="tel:+13615550100">(361) 555-0100</a>
</header>

<section id="hero">
  <h1>Know your home before you buy it.</h1>
  <p>Professional, TREC-licensed home inspections serving Sinton, Corpus Christi, and the Coastal Bend.</p>
  <a href="#book">Schedule Your Inspection</a>
</section>

<section id="book">
  <h2>Book online in minutes</h2>
  <form>
    Property address [text input]
    Preferred date [date input]
    Preferred time [select: Morning / Afternoon]
    Your name [text input] · Phone [tel input] · Email [email input]
    <button type="button">Request Appointment</button>
  </form>
  <p>You’ll receive a confirmation within one business day.</p>
</section>

<section id="services">
  <h2>What’s inspected</h2>
  <p>Every inspection covers all components in the TREC Standards of Practice:</p>
  <ul>
    <li>Foundation</li><li>Grading &amp; Drainage</li><li>Roof Covering</li>
    <li>Roof Structure &amp; Attics</li><li>Walls</li><li>Doors &amp; Windows</li>
    <li>Floors &amp; Ceilings</li><li>HVAC</li><li>Electrical</li>
    <li>Plumbing</li><li>Built-In Appliances</li>
  </ul>
</section>

<section id="how">
  <h2>How it works</h2>
  <ol>
    <li><strong>Book</strong> — Pick a day and time that works for you.</li>
    <li><strong>Inspect</strong> — Edna walks the property top to bottom, typically 2–3 hours.</li>
    <li><strong>Report</strong> — Your full digital report, usually within 24 hours.</li>
  </ol>
</section>

<section id="report">
  <h2>Already had your inspection?</h2>
  <p>Access your report online any time.</p>
  <form>
    Email address [email input]
    <button type="button">Find My Report</button>
  </form>
</section>

<section id="about">
  <h2>Meet Edna Cavazos</h2>
  <p>EC Home Inspections is owned and operated by Edna Cavazos, a TREC-licensed
  professional inspector (License #27120) serving Sinton and the greater Coastal
  Bend. When you book with EC, Edna is who shows up — no subcontractors, no
  hand-offs, and a report you can actually read.</p>
</section>

<section id="contact">
  <h2>Get in touch</h2>
  <form>
    Name [text] · Email [email] · Phone [tel]
    Message [textarea]
    <button type="button">Send Message</button>
  </form>
</section>

<footer>
  EC Home Inspections · 10577 CR 2349, Sinton, TX
  (361) 555-0100 · edna@echomeinspectionstx.com
  Texas Real Estate Commission License #27120
  <a href="https://www.trec.texas.gov/forms/consumer-protection-notice">TREC Consumer Protection Notice</a>
</footer>
```

`<head>` requirements for every file: `<meta charset="utf-8">`, `<meta name="viewport" content="width=device-width, initial-scale=1">`, and a `<title>` of the form `EC Home Inspections — <Direction Name> Concept` (index: `EC Home Inspections — Design Concepts`).

---

### Task 1: Validation script + Mockup 01 — Established & Trusted

**Files:**
- Create: `scripts/check-mockup.sh`
- Create: `mockups/01-established-trusted.html`

**Interfaces:**
- Produces: `scripts/check-mockup.sh <html-file>` — exits 0 when the file contains the viewport meta, a `<title>`, license #27120, the TREC notice link, all 11 services, and no external assets; exits 1 with a `MISSING …`/`EXTERNAL ASSET FOUND` line otherwise. Tasks 2–5 rely on this exact path and contract.

**Direction spec — "Established & Trusted":** The safe, been-around-20-years professional look. Background white / `#F7F9FC`; deep navy `#10284A` for the hero band, footer, and headings; brand blue `#1E6FD9` for links/focus; orange `#E8681C` used *sparingly* — primary CTA button and small rules only. Headings in Georgia (`Georgia, 'Times New Roman', serif`); body in `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`. Centered max-width ~1040px column, thin 1px hairline rules between sections, generous whitespace, no rounded corners beyond 4px, no shadows heavier than a whisper. Services as a tidy two/three-column checklist with small navy check glyphs.

- [ ] **Step 1: Write the validation script (the failing test)**

```bash
#!/usr/bin/env bash
# usage: scripts/check-mockup.sh <mockup.html>
f="$1"; fail=0
[ -f "$f" ] || { echo "MISSING file: $f"; exit 1; }
grep -q 'name="viewport"' "$f" || { echo "MISSING viewport meta"; fail=1; }
grep -q '<title>EC Home Inspections' "$f" || { echo "MISSING title"; fail=1; }
grep -q '27120' "$f" || { echo "MISSING license number"; fail=1; }
grep -q 'trec.texas.gov/forms/consumer-protection-notice' "$f" || { echo "MISSING TREC notice link"; fail=1; }
while IFS= read -r svc; do
  grep -q "$svc" "$f" || { echo "MISSING service: $svc"; fail=1; }
done <<'EOF'
Foundation
Grading &amp; Drainage
Roof Covering
Roof Structure &amp; Attics
Walls
Doors &amp; Windows
Floors &amp; Ceilings
HVAC
Electrical
Plumbing
Built-In Appliances
EOF
if grep -Eq 'src="https?://|<link[^>]+href="https?://|url\(["'"'"']?https?://|@import' "$f"; then
  echo "EXTERNAL ASSET FOUND"; fail=1
fi
[ "$fail" -eq 0 ] && echo "OK: $f"
exit $fail
```

Save, then `chmod +x scripts/check-mockup.sh`.

- [ ] **Step 2: Run it to verify it fails**

Run: `scripts/check-mockup.sh mockups/01-established-trusted.html`
Expected: `MISSING file: mockups/01-established-trusted.html`, exit 1.

- [ ] **Step 3: Load the frontend-design skill, then build the mockup**

Invoke `frontend-design:frontend-design`. Then write `mockups/01-established-trusted.html`: the shared content skeleton and logo SVG from Global Constraints, styled per the direction spec above. Title: `EC Home Inspections — Established & Trusted Concept`.

- [ ] **Step 4: Run the check to verify it passes**

Run: `scripts/check-mockup.sh mockups/01-established-trusted.html`
Expected: `OK: mockups/01-established-trusted.html`, exit 0.

- [ ] **Step 5: Visual sanity check**

Open the file in a browser (`open mockups/01-established-trusted.html`) or render a screenshot if headless tooling is available. Confirm: readable at phone width, hero CTA prominent, no horizontal scroll, navy/orange balance matches the direction spec.

- [ ] **Step 6: Commit**

```bash
git add scripts/check-mockup.sh mockups/01-established-trusted.html
git commit -m "feat: add validation script and Established & Trusted mockup"
```

---

### Task 2: Mockup 02 — Bright & Approachable

**Files:**
- Create: `mockups/02-bright-approachable.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh <html-file>` (exit 0 = pass).

**Direction spec — "Bright & Approachable":** Modern, friendly, aimed at first-time homebuyers. Brand blue `#1E6FD9` used confidently in large areas (hero, section bands); warm off-white `#F5F8FE` alternating sections; big pill-shaped orange `#F97316` CTA buttons. Rounded everything: 16–24px card radii, soft shadows. Type: `ui-rounded, 'SF Pro Rounded', -apple-system, 'Segoe UI', sans-serif`, large friendly heading sizes. "How it works" as three cards with oversized step numbers; services as rounded chips/tiles with simple inline-SVG check circles. Overall feel: energetic but trustworthy, not childish.

- [ ] **Step 1: Run the check to verify it fails**

Run: `scripts/check-mockup.sh mockups/02-bright-approachable.html`
Expected: `MISSING file: …`, exit 1.

- [ ] **Step 2: Load the frontend-design skill, then build the mockup**

Invoke `frontend-design:frontend-design`. Write `mockups/02-bright-approachable.html`: shared skeleton + logo SVG from Global Constraints, styled per the direction spec. Title: `EC Home Inspections — Bright & Approachable Concept`.

- [ ] **Step 3: Run the check to verify it passes**

Run: `scripts/check-mockup.sh mockups/02-bright-approachable.html`
Expected: `OK: …`, exit 0.

- [ ] **Step 4: Visual sanity check**

Open in browser; confirm phone-width layout, pill CTAs, distinctly different at a glance from mockup 01.

- [ ] **Step 5: Commit**

```bash
git add mockups/02-bright-approachable.html
git commit -m "feat: add Bright & Approachable mockup"
```

---

### Task 3: Mockup 03 — Coastal Bend Local

**Files:**
- Create: `mockups/03-coastal-bend-local.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh <html-file>` (exit 0 = pass).

**Direction spec — "Coastal Bend Local":** Airy, warm, personal — gulf-coast character; the differentiator is Edna herself and the local service area. Warm sand background `#FBF6EF`; softened brand blue `#2E7CD6` (sky/water) and sunset orange `#F2814D`. A decorative inline-SVG wave divider between hero and booking sections (simple two-tone sine-wave path — draw it, don't link it). Headings in `Palatino, 'Palatino Linotype', 'Book Antiqua', serif` with occasional italic accents; body in `'Avenir Next', Avenir, 'Segoe UI', sans-serif`, generous line-height (1.7). The About section gets extra visual weight: a soft card with an initials avatar (CSS circle with "EC") since no photography is allowed. Overall feel: sunlit, neighborly, unhurried.

- [ ] **Step 1: Run the check to verify it fails**

Run: `scripts/check-mockup.sh mockups/03-coastal-bend-local.html`
Expected: `MISSING file: …`, exit 1.

- [ ] **Step 2: Load the frontend-design skill, then build the mockup**

Invoke `frontend-design:frontend-design`. Write `mockups/03-coastal-bend-local.html`: shared skeleton + logo SVG from Global Constraints, styled per the direction spec. Title: `EC Home Inspections — Coastal Bend Local Concept`.

- [ ] **Step 3: Run the check to verify it passes**

Run: `scripts/check-mockup.sh mockups/03-coastal-bend-local.html`
Expected: `OK: …`, exit 0.

- [ ] **Step 4: Visual sanity check**

Open in browser; confirm the wave divider renders, warm palette reads clearly different from 01 and 02, no horizontal scroll at phone width.

- [ ] **Step 5: Commit**

```bash
git add mockups/03-coastal-bend-local.html
git commit -m "feat: add Coastal Bend Local mockup"
```

---

### Task 4: Mockup 04 — Precision & Thorough

**Files:**
- Create: `mockups/04-precision-thorough.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh <html-file>` (exit 0 = pass).

**Direction spec — "Precision & Thorough":** Technical rigor as the sell. Dark slate `#16202B` page background with a subtle blueprint grid (CSS `background-image: linear-gradient(...)` grid lines at low opacity — no image files); light text `#E8EEF6`. Luminous brand blue `#4C8DFF` for accents and links; orange `#F97316` for check marks and the primary CTA. Labels, step numbers, and the services checklist in `ui-monospace, 'SF Mono', Menlo, Consolas, monospace`; body/headings in `-apple-system, 'Segoe UI', sans-serif`. The 11-item TREC checklist is the visual centerpiece: styled as a technical punch list with orange inline-SVG checkboxes and hairline connector rules. Sharp corners (0–2px radii), 1px borders, no soft shadows. Ensure WCAG-reasonable contrast on the dark background.

- [ ] **Step 1: Run the check to verify it fails**

Run: `scripts/check-mockup.sh mockups/04-precision-thorough.html`
Expected: `MISSING file: …`, exit 1.

- [ ] **Step 2: Load the frontend-design skill, then build the mockup**

Invoke `frontend-design:frontend-design`. Write `mockups/04-precision-thorough.html`: shared skeleton + logo SVG from Global Constraints, styled per the direction spec. Title: `EC Home Inspections — Precision & Thorough Concept`.

- [ ] **Step 3: Run the check to verify it passes**

Run: `scripts/check-mockup.sh mockups/04-precision-thorough.html`
Expected: `OK: …`, exit 0.

- [ ] **Step 4: Visual sanity check**

Open in browser; confirm blueprint grid renders, text contrast is comfortable, checklist reads as the centerpiece, distinct from 01–03.

- [ ] **Step 5: Commit**

```bash
git add mockups/04-precision-thorough.html
git commit -m "feat: add Precision & Thorough mockup"
```

---

### Task 5: Concepts index page + full-set verification

**Files:**
- Create: `mockups/index.html`

**Interfaces:**
- Consumes: the four mockup files by exact relative filename (`01-established-trusted.html`, `02-bright-approachable.html`, `03-coastal-bend-local.html`, `04-precision-thorough.html`) and `scripts/check-mockup.sh`.

**Direction spec — index:** Neutral presentation page (must not visually favor any direction): white background, system sans, the logo SVG at top, `<h1>EC Home Inspections — Design Concepts</h1>`, a short intro line ("Four looks for your new website — tap any card to view it. Same content, different personality."), then four link cards. Each card: concept number + name, the one-liner below, styled as a large tap-friendly block (min 44px touch target). One-liners, verbatim:

1. **Established & Trusted** — Classic and professional, like a firm that's been at it for decades.
2. **Bright & Approachable** — Friendly and modern, built to put first-time buyers at ease.
3. **Coastal Bend Local** — Warm and personal, leading with Edna and the community she serves.
4. **Precision & Thorough** — Technical and exacting, with the inspection checklist front and center.

- [ ] **Step 1: Build the index page**

Write `mockups/index.html` per the spec above. Head requirements from Global Constraints apply (`<title>EC Home Inspections — Design Concepts</title>`). No forms, no services list on this page — it is navigation only.

- [ ] **Step 2: Verify index links resolve and page is self-contained**

```bash
for f in 01-established-trusted 02-bright-approachable 03-coastal-bend-local 04-precision-thorough; do
  grep -q "href=\"$f.html\"" mockups/index.html && echo "link OK: $f" || echo "MISSING link: $f"
done
grep -Eq 'src="https?://|<link[^>]+href="https?://|url\(["'"'"']?https?://|@import' mockups/index.html \
  && echo "EXTERNAL ASSET FOUND" || echo "self-contained OK"
```

Expected: four `link OK` lines and `self-contained OK`.

- [ ] **Step 3: Re-run the full validation suite**

```bash
for f in mockups/0*.html; do scripts/check-mockup.sh "$f"; done
```

Expected: four `OK:` lines, no failures.

- [ ] **Step 4: Final visual pass**

Open `mockups/index.html` in a browser; click through all four concepts; confirm each loads, looks distinct, and returns work via browser back. Check one mockup at phone width end-to-end.

- [ ] **Step 5: Commit**

```bash
git add mockups/index.html
git commit -m "feat: add design-concepts index page"
```
