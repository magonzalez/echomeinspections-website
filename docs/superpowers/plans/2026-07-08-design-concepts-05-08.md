# EC Home Inspections Concepts 05–08 + Logo Extraction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add four research-inspired homepage mockups (05–08), extract the EC logo to standalone SVG files used by every page, and update the concepts index to list all eight.

**Architecture:** Same as round one — each mockup is a static HTML file with inline CSS in `mockups/`, sharing the canonical content skeleton verbatim. Photos and logos live in `mockups/assets/` (already populated) and are referenced by relative path; the deliverable is the self-contained `mockups/` folder. `scripts/check-mockup.sh` validates every mockup.

**Tech Stack:** Hand-written HTML5 + CSS, system font stacks only, no JavaScript. Bash for validation.

**Spec:** `docs/superpowers/specs/2026-07-08-design-concepts-design.md` (see "Second round" deliverables)

## Global Constraints

- The deliverable is the self-contained `mockups/` folder: pages may reference files in `mockups/assets/` by relative path, but nothing outside the folder and **no network assets** (external `href` allowed only for the TREC Consumer Protection Notice anchor). No CDN CSS/JS, no web fonts, no `<script>`.
- **System font stacks only.** Mobile-responsive; no horizontal scroll at 375px or 1280px (headless Chrome floors window width at ~500px — verify at ~505px plus a CSS audit of fixed-width elements against a 375px budget).
- Brand anchors: blue `#1E6FD9`, orange `#F97316` (directions may tint/shade but each page must clearly read blue + orange).
- Placeholder contact info verbatim everywhere: phone `(361) 555-0100` (`tel:+13615550100`), email `edna@echomeinspectionstx.com`.
- **The canonical content skeleton is binding**: every mockup contains exactly the sections, order, and copy defined in round one (see `mockups/01-established-trusted.html` for a faithful reference, or the skeleton below). No invented copy — no eyebrow labels, badges, taglines, or stats beyond the skeleton (this was litigated in round-one reviews). Copy may be split across elements for layout, but every word and punctuation mark (including em-dashes and middle dots) must survive. HTML entities (`&mdash;`, `&rsquo;`, …) are equivalent to literal characters.
- Logo: pages reference the standalone SVG files in `mockups/assets/` (Task 1 creates them) via `<img>`; do not inline the logo SVG in new pages and do not alter the SVG paths.
- Photos: use ONLY the files already present in `mockups/assets/` as assigned per task (all Pexels License, credited in `docs/image-credits.md`). Do not hotlink or download new images. `<img>` photos need honest `alt` text; purely decorative treatments use `aria-hidden="true"` / CSS backgrounds.
- Every new page's `<head>`: `<meta charset="utf-8">`, viewport meta, `<title>EC Home Inspections — <Direction Name> Concept</title>` (index keeps `EC Home Inspections — Design Concepts`).
- Executors of mockup tasks MUST load the `frontend-design:frontend-design` skill before writing HTML/CSS.
- Validation: `scripts/check-mockup.sh <file>` must pass (exit 0, `OK:` line) for every mockup, run RED (missing file) before building and GREEN after.
- Commit after every task.

### Canonical content skeleton (sections, order, copy — verbatim)

1. **Header** — logo + `EC Home Inspections`, nav `Book / Services / Your Report / Contact`, phone `(361) 555-0100`
2. **#hero** — `Know your home before you buy it.` / `Professional, TREC-licensed home inspections serving Sinton, Corpus Christi, and the Coastal Bend.` / CTA `Schedule Your Inspection` → `#book`
3. **#book** — `Book online in minutes`; form: Property address, Preferred date, Preferred time (Morning/Afternoon), Your name, Phone, Email; button `Request Appointment` (`type="button"`, no action); `You’ll receive a confirmation within one business day.`
4. **#services** — `What’s inspected`; `Every inspection covers all components in the TREC Standards of Practice:`; the 11 items: Foundation; Grading & Drainage; Roof Covering; Roof Structure & Attics; Walls; Doors & Windows; Floors & Ceilings; HVAC; Electrical; Plumbing; Built-In Appliances
5. **#how** — `How it works`; `Book — Pick a day and time that works for you.` / `Inspect — Edna walks the property top to bottom, typically 2–3 hours.` / `Report — Your full digital report, usually within 24 hours.`
6. **#report** — `Already had your inspection?`; `Access your report online any time.`; email input + button `Find My Report` (`type="button"`)
7. **#about** — `Meet Edna Cavazos`; the owner-operator paragraph ending `…a report you can actually read.` (copy it verbatim from mockups/01, lines around the `#about` section — includes `(License #27120)`)
8. **#contact** — `Get in touch`; Name/Email/Phone/Message + button `Send Message` (`type="button"`)
9. **Footer** — `EC Home Inspections · 10577 CR 2349, Sinton, TX`; `(361) 555-0100 · edna@echomeinspectionstx.com`; `Texas Real Estate Commission License #27120`; anchor `TREC Consumer Protection Notice` → `https://www.trec.texas.gov/forms/consumer-protection-notice`

### Logo files (Task 1 creates; identical paths, fills vary)

Canonical paths (never alter):

```svg
<svg viewBox="0 0 96 88" xmlns="http://www.w3.org/2000/svg">
  <path fill="BLUE" d="M48 4 L10 26 L10 84 L44 84 L44 72 L22 72 L22 56 L40 56 L40 44 L22 44 L22 32 L48 17 Z"/>
  <path fill="ORANGE" d="M48 4 L86 26 L86 84 L52 84 L52 72 L74 72 L74 32 L48 17 Z"/>
</svg>
```

| File | BLUE | ORANGE | Used by |
|------|------|--------|---------|
| `mockups/assets/logo.svg` | `#1E6FD9` | `#F97316` | index, 02, 05, 06, 07 |
| `mockups/assets/logo-classic.svg` | `#1E6FD9` | `#E8681C` | 01 |
| `mockups/assets/logo-coastal.svg` | `#2E7CD6` | `#F2814D` | 03 |
| `mockups/assets/logo-slate.svg` | `#4C8DFF` | `#F97316` | 04, 08 |

Reference pattern: `<img class="logo" src="assets/logo.svg" alt="" width="48" height="44">` inside the existing brand link/span (the adjacent text `EC Home Inspections` already names the business, so the image is decorative: empty `alt` plus `aria-hidden="true"`; drop any now-redundant `aria-label`).

### Photo manifest (already in `mockups/assets/`, credited in `docs/image-credits.md`)

| File | Content | Assigned to |
|------|---------|-------------|
| `hero05.jpg` (1400×933) | suburban street, dramatic clouded sky | 05 hero background |
| `band05.jpg` (1200×800) | craftsman house at twilight | 05 dark #report band background |
| `photo06.jpg` (1100×733) | stone-and-siding ranch home, daylight | 06 supporting photo |
| `hero07.jpg` (1400×787) | top-down aerial rooftops | 07 duotone hero |
| `entry08.jpg` (600×900) | lantern-lit stone entrance, warm | 08 collage anchor |
| `moody08.jpg` (513×900) | brick house, deep teal sky, hard shadow | 08 collage |
| `dusk08.jpg` (600×900) | craftsman at dusk, lit windows | 08 collage |

---

### Task 1: Extract logo SVGs and retrofit existing pages

**Files:**
- Create: `mockups/assets/logo.svg`, `mockups/assets/logo-classic.svg`, `mockups/assets/logo-coastal.svg`, `mockups/assets/logo-slate.svg`
- Modify: `mockups/index.html`, `mockups/01-established-trusted.html`, `mockups/02-bright-approachable.html`, `mockups/03-coastal-bend-local.html`, `mockups/04-precision-thorough.html` (header logo only)

**Interfaces:**
- Produces: the four logo files exactly per the Global Constraints table — Tasks 2–5 reference them by these exact paths and must not recreate them.

- [ ] **Step 1: Create the four SVG files** — each is the canonical markup from Global Constraints with that row's BLUE/ORANGE fills, one file each, no other changes (no width/height attributes; keep the viewBox).
- [ ] **Step 2: Retrofit each existing page** — in each of the five files, replace the inline `<svg class="logo" …>…</svg>` in the header with `<img class="logo" src="assets/<file-per-table>" alt="" aria-hidden="true" width="48" height="44">`. Check each page's `.logo` CSS still sizes the element correctly (`img` needs `display:block`-ish treatment and explicit CSS width/height if the old rule targeted `svg`); adjust the `.logo` CSS rule if needed. Touch nothing else — a diff beyond the header logo markup + its CSS rule is out of scope. (01 also inlines a decorative license-seal SVG and 02 a sunrise SVG — leave those alone.)
- [ ] **Step 3: Verify** — `for f in mockups/0*.html; do scripts/check-mockup.sh "$f"; done` → four `OK:` lines. Then render each of the five pages in headless Chrome (505px is fine) and confirm the logo displays at the same size/position as before (compare against `git stash`-free screenshots or just judge visually — the mark must be visible and correctly colored per page).
- [ ] **Step 4: Commit** — `git add -A && git commit -m "refactor: extract EC logo to standalone SVG assets"`

---

### Task 2: Mockup 05 — Big Sky

**Files:**
- Create: `mockups/05-big-sky.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh`, `assets/logo.svg`, `assets/hero05.jpg`, `assets/band05.jpg`.

**Direction spec — "Big Sky"** (inspired by Gen X, Cap City, A-Pro, HomeTeam): photo-first and wide open. Hero: full-viewport (`min-height:clamp(560px, 92vh, 860px)`) background `assets/hero05.jpg` center/cover with a legibility scrim (`linear-gradient(rgba(9,20,38,.62), rgba(9,20,38,.30))`), content bottom-left-ish, H1 in condensed uppercase display type (`'Avenir Next Condensed','Arial Narrow',-apple-system,sans-serif`, `letter-spacing:.01em`, clamp up to ~4rem), white text, solid orange `#F97316` CTA. Header: transparent over the hero (absolute, white text) collapsing to solid navy on narrow screens is optional — a plain solid navy `#0F2038` header is also acceptable; pick one and keep it simple. Body sections white with ink `#16233B`; H2s condensed caps with a short orange rule. "How it works" as an icon-value-prop trio: numbered circles in blue `#1E6FD9`, generous spacing (HomeTeam's Fast/Trusted/Accurate energy — but the copy stays the skeleton's Book/Inspect/Report lines). Services: two-to-three-column checklist, blue check glyphs. **#report is the signature move**: full-width dark band, background `assets/band05.jpg` cover with navy scrim (`rgba(15,32,56,.80)`), white text, orange button — like HomeTeam's dark location band. Forms on white cards with 1px borders, 6px radii. Footer solid navy.

- [ ] **Step 1: RED** — `scripts/check-mockup.sh mockups/05-big-sky.html` → `MISSING file`, exit 1.
- [ ] **Step 2: Build** — invoke `frontend-design:frontend-design`, then write the page: canonical skeleton, logo via `<img src="assets/logo.svg" …>`, direction spec above. Title: `EC Home Inspections — Big Sky Concept`.
- [ ] **Step 3: GREEN** — check script → `OK`, exit 0.
- [ ] **Step 4: Visual check** — headless screenshots at 1280px and ~505px: hero photo + scrim legible, dark band renders, no horizontal scroll; CSS audit for 375px.
- [ ] **Step 5: Commit** — `git add mockups/05-big-sky.html && git commit -m "feat: add Big Sky mockup"`

---

### Task 3: Mockup 06 — Book It Now

**Files:**
- Create: `mockups/06-book-it-now.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh`, `assets/logo.svg`, `assets/photo06.jpg`.

**Direction spec — "Book It Now"** (inspired by GreenWorks, Crosstown): conversion-first franchise energy at solo scale. Palette: navy `#0F2A52`, brand blue `#1E6FD9`, orange `#F97316` for every primary action, white/#F4F7FB alternating bands. Type: strong system sans (`-apple-system,'Segoe UI',sans-serif`), bold headings, no serif. Hero: navy→blue gradient (`linear-gradient(135deg,#0F2A52,#1E6FD9)`), white H1 + lede on the left. **Signature move: the #book section's form card is pulled up into the hero** — white card, soft shadow, `margin-top` negative enough to overlap the hero band by roughly half the card (GreenWorks' in-hero quote form, but it IS the skeleton's booking form; DOM order stays hero → book). Two-column form layout inside the card at desktop. After #book: services as a compact chip grid with check icons; #how as three numbered tiles; #report as a navy panel with orange button (Crosstown's "Questions?" panel feel); **#about styled as a credential panel** — white card with a left border in orange, the `(License #27120)` phrase visually emphasized (e.g. `<strong>` or highlighted span — the words themselves unchanged), plus `assets/photo06.jpg` as a supporting image beside or behind the about card (rounded 8px, honest alt). Buttons: solid orange, 6–8px radius, slight hover lift. Footer navy with orange TREC-notice link.

- [ ] **Step 1: RED** — check script on the missing file → exit 1.
- [ ] **Step 2: Build** — invoke `frontend-design:frontend-design`, then write the page per spec. Title: `EC Home Inspections — Book It Now Concept`.
- [ ] **Step 3: GREEN** — check script → `OK`, exit 0.
- [ ] **Step 4: Visual check** — 1280px + ~505px screenshots: form card overlaps hero cleanly at both widths (at mobile the overlap may shrink but must not clip or overflow), no horizontal scroll; CSS audit for 375px.
- [ ] **Step 5: Commit** — `git add mockups/06-book-it-now.html && git commit -m "feat: add Book It Now mockup"`

---

### Task 4: Mockup 07 — Boutique Duotone

**Files:**
- Create: `mockups/07-boutique-duotone.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh`, `assets/logo.svg`, `assets/hero07.jpg`.

**Direction spec — "Boutique Duotone"** (inspired by DBL Check): calm, premium, understated — one wash of blue. Hero: `assets/hero07.jpg` (top-down rooftops) rendered as a **blue duotone**: e.g. a container with the image as background plus `filter:grayscale(1)` on an `img`/pseudo-element and an overlay `linear-gradient(rgba(23,58,110,.78), rgba(23,58,110,.55))`, or `background-blend-mode:multiply` over a desaturated image — pick the approach that renders in file:// Chrome without JS. Centered white H1 in a **light-weight** wide-tracking style (`font-weight:300`, `'Helvetica Neue',-apple-system`, `letter-spacing:.02em`), small quiet CTA (white outline pill or soft white button — NOT loud orange). **The hero's bottom edge is an organic curved SVG divider** into white (DBL Check's signature; inline `aria-hidden` SVG path, gentle asymmetric curve — not the wave from mockup 03). Body: extremely airy — max-width ~1040px, section padding ≥96px desktop, hairline `#E3E9F1` dividers, ink `#24303E`, muted deep blue `#2B5FA8` for links and small accents. H2s styled small and elegant (e.g. `1.15rem`, uppercase, `letter-spacing:.14em`, muted blue) with the section content given the visual weight instead. Services: single quiet two-column list, thin blue checks. Orange appears ONLY as a whisper: tiny dots/rule accents and the focus ring — nowhere dominant (the logo img carries the brand orange). Forms: minimal — bottom-border-only inputs, quiet navy button. Footer: white, hairline top rule, muted text.

- [ ] **Step 1: RED** — check script on the missing file → exit 1.
- [ ] **Step 2: Build** — invoke `frontend-design:frontend-design`, then write the page per spec. Title: `EC Home Inspections — Boutique Duotone Concept`.
- [ ] **Step 3: GREEN** — check script → `OK`, exit 0.
- [ ] **Step 4: Visual check** — 1280px + ~505px: duotone reads as one blue wash (not a plain photo), curve divider renders, whitespace holds at mobile without feeling empty, no horizontal scroll; CSS audit for 375px.
- [ ] **Step 5: Commit** — `git add mockups/07-boutique-duotone.html && git commit -m "feat: add Boutique Duotone mockup"`

---

### Task 5: Mockup 08 — Editorial Charcoal

**Files:**
- Create: `mockups/08-editorial-charcoal.html`

**Interfaces:**
- Consumes: `scripts/check-mockup.sh`, `assets/logo-slate.svg`, `assets/entry08.jpg`, `assets/moody08.jpg`, `assets/dusk08.jpg`.

**Direction spec — "Editorial Charcoal"** (inspired by NOMAD, HomeTeam's collages): moody magazine. Page background warm charcoal `#221D1A`, text warm cream `#F2E9DC`, terracotta `#E2653B` (shade of brand orange) for accents/numbering, brand orange `#F97316` for the primary CTAs, muted blue `#6C9BD1` for links + the logo (use `assets/logo-slate.svg`, whose luminous blue reads on dark). Type: serif display for headings (`'Iowan Old Style',Palatino,Georgia,serif`, large, occasional italic on the hero's em phrase is allowed via styling only), body in system sans at comfortable size, generous leading. **Signature move: overlapping photo collage in the hero** — `entry08.jpg` large with `moody08.jpg` overlapping its corner (rotated ~2°, offset, thin cream border) and `dusk08.jpg` tucked behind/below; collage on the right at desktop, stacked-with-overlap at mobile; honest alts. Sections alternate: #book sits on a **cream panel** (`#F2E9DC` background, charcoal text — form legibility on the dark page), services as an editorial two-column list with oversized terracotta index numbers (01–11 as CSS counters, not copy), #how as three serif entries with terracotta numerals, #report dark with a thin terracotta frame, #about pairs the paragraph with `dusk08.jpg` as a small portrait-style image. Footer nearly black `#171310` with cream text. Contrast: keep all body text WCAG-comfortable on charcoal.

- [ ] **Step 1: RED** — check script on the missing file → exit 1.
- [ ] **Step 2: Build** — invoke `frontend-design:frontend-design`, then write the page per spec. Title: `EC Home Inspections — Editorial Charcoal Concept`.
- [ ] **Step 3: GREEN** — check script → `OK`, exit 0.
- [ ] **Step 4: Visual check** — 1280px + ~505px: collage overlap renders without clipping at both widths, cream booking panel legible, contrast comfortable, no horizontal scroll; CSS audit for 375px.
- [ ] **Step 5: Commit** — `git add mockups/08-editorial-charcoal.html && git commit -m "feat: add Editorial Charcoal mockup"`

---

### Task 6: Index update + full-set verification

**Files:**
- Modify: `mockups/index.html`

**Interfaces:**
- Consumes: the eight mockup files by exact relative filename and `scripts/check-mockup.sh`.

The index stays neutral (white, system sans, logo via `assets/logo.svg` — Task 1 already switched it). Changes:

1. Intro line: replace the word `Four` with `Eight` (rest of the sentence unchanged).
2. Add four link cards after the existing four, same card markup/style, numbered 05–08, one-liners verbatim:
   - **05 Big Sky** — Photo-first and wide open, like a Texas afternoon.
   - **06 Book It Now** — Conversion-focused, with scheduling front and center from the first screen.
   - **07 Boutique Duotone** — Calm, premium, and understated in a single wash of blue.
   - **08 Editorial Charcoal** — Moody and magazine-styled: warm charcoal, terracotta, and dusk photography.

- [ ] **Step 1: Update the index** per the above; card links: `05-big-sky.html`, `06-book-it-now.html`, `07-boutique-duotone.html`, `08-editorial-charcoal.html`.
- [ ] **Step 2: Verify links + self-containment**

```bash
for f in 01-established-trusted 02-bright-approachable 03-coastal-bend-local 04-precision-thorough 05-big-sky 06-book-it-now 07-boutique-duotone 08-editorial-charcoal; do
  grep -q "href=\"$f.html\"" mockups/index.html && echo "link OK: $f" || echo "MISSING link: $f"
done
grep -Eq 'src="https?://|<link[^>]+href="https?://|url\(["'"'"']?https?://|@import' mockups/index.html \
  && echo "EXTERNAL ASSET FOUND" || echo "self-contained OK"
```

Expected: eight `link OK` lines + `self-contained OK`.

- [ ] **Step 3: Full suite** — `for f in mockups/0*.html; do scripts/check-mockup.sh "$f"; done` → eight `OK:` lines.
- [ ] **Step 4: Visual pass** — open the index at ~505px and 1280px: eight cards, tap-friendly, still neutral.
- [ ] **Step 5: Commit** — `git add mockups/index.html && git commit -m "feat: list concepts 05-08 on the index"`
