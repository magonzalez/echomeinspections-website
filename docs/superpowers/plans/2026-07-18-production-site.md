# EC Home Inspections Production Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Launch the production echomeinspectionstx.com from the chosen Big Sky mockup: real contact info, working Web3Forms forms, honest report messaging, AA-compliant buttons, outlined wordmark, SEO/launch files, and the mockup archive preserved at `/mockups/`.

**Architecture:** Static single-page site in `site/` (zero dependencies, inline CSS) derived from `mockups/05-big-sky.html`. The existing GitHub Actions workflow assembles `site/` at the artifact root with `mockups/` as a subfolder. DNS cutover to the custom domain is the final, human-gated task.

**Tech Stack:** HTML/CSS, Web3Forms (form backend), GitHub Pages + Actions, Cloudflare DNS, Python `fontTools` (one-off wordmark outlining), bash validation.

**Spec:** `docs/superpowers/specs/2026-07-18-production-site-design.md`

## Global Constraints

- Production contact info, verbatim everywhere on site pages: phone `(361) 558-6496`, tel links `tel:+13615586496`, displayed email `edna@echomeinspectionstx.com` (mailto same). The strings `555-0100` and `ecavazos30@yahoo.com` must NOT appear anywhere under `site/`.
- The Big Sky design (layout, palette, type, photos, section order) is the client-approved look — carry it over from `mockups/05-big-sky.html` unchanged except for the deltas the tasks below specify. `mockups/` files are an archive: do not modify them.
- Text-bearing orange buttons use `--cta:#C2410C` with white text (verified ≥4.5:1). Brand orange `#F97316` stays for the logo and non-text accents.
- All forms POST to `https://api.web3forms.com/submit`, method POST, real `type="submit"` buttons, each with: hidden `access_key` (value from Task 1; sentinel `W3F_KEY_PENDING` until then), hidden `subject` (per-form, see Task 3), hidden `from_name` value `EC Home Inspections website`, hidden `redirect` value `https://echomeinspectionstx.com/thanks.html`, and a honeypot: `<input type="checkbox" name="botcheck" tabindex="-1" autocomplete="off" style="display:none" aria-hidden="true">`. No JavaScript.
- Self-contained: no network assets; allowed external references are ONLY the TREC notice anchor `https://www.trec.texas.gov/forms/consumer-protection-notice`, the Web3Forms form `action`, and the `redirect` hidden value. No `<script>`, no web fonts (the wordmark text becomes outlined paths — no font dependency).
- Every site page head: `<meta charset="utf-8">`, viewport meta. Mobile: no horizontal scroll at 375px (headless Chrome floors at ~500px; use the iframe harness pattern from prior rounds plus CSS audit).
- Executors of page-building tasks MUST load `frontend-design:frontend-design` before writing HTML/CSS.
- Validation: `scripts/check-site.sh` (Task 5) must pass before Task 6. Commit after every task.

---

### Task 1: Web3Forms access key (human-gated)

**Files:** none (produces a value)

**Interfaces:**
- Produces: the Web3Forms access key string (UUID format), used verbatim by Task 3's forms. Until provided, Task 3 uses the sentinel `W3F_KEY_PENDING` and `check-site.sh` fails loudly on it.

- [ ] **Step 1:** Controller asks the developer to create a free key: go to https://web3forms.com → "Create your Access Key" → enter `ecavazos30@yahoo.com` → the key arrives by email instantly (no account needed). The key is public-by-design (it ships in client-side HTML) — committing it is fine.
- [ ] **Step 2:** Record the key in the progress ledger and hand it to Task 3 (or note that the sentinel is in effect and Task 6 is blocked until replaced).

---

### Task 2: Outlined wordmark SVGs

**Files:**
- Create: `site/assets/logo-wordmark-outlined.svg`, `site/assets/logo-wordmark-outlined-light.svg`, `docs/brand/README.md`
- Copy (unchanged): `mockups/assets/logo-wordmark-inline.svg` and `-light.svg` → `docs/brand/` (editable originals archive)

**Interfaces:**
- Produces: the two outlined SVGs with the SAME viewBox `0 0 640 96` and same monogram paths/fills as the mockup wordmarks; text converted to `<path>` outlines. Task 3 references them as `assets/logo-wordmark-outlined.svg` (light headers — none on this site, but the file is canonical brand) and `assets/logo-wordmark-outlined-light.svg` (the site's navy header uses this one).

The mockup wordmarks render text with `-apple-system` at weights 800/650, which varies per device. Outline using **Inter** (SIL OFL licensed — outlines freely embeddable) at ExtraBold/SemiBold, the closest libre match to SF.

- [ ] **Step 1: Set up tooling in the scratchpad** (not the repo):

```bash
cd "$SCRATCHPAD"   # the session scratchpad directory
python3 -m venv w3venv && ./w3venv/bin/pip -q install fonttools
curl -sL -o inter.zip https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip
unzip -o -q inter.zip -d inter 'extras/ttf/Inter-ExtraBold.ttf' 'extras/ttf/Inter-SemiBold.ttf' || unzip -l inter.zip | head -30
# If the zip layout differs, locate the two TTFs with: unzip -l inter.zip | grep -iE 'extrabold|semibold'
```

- [ ] **Step 2: Write the outlining script** to `$SCRATCHPAD/outline_wordmark.py`:

```python
#!/usr/bin/env python3
"""Outline 'EC HOME' (ExtraBold) + 'INSPECTIONS' (SemiBold) as SVG paths
matching the mockup wordmark geometry: font-size 40, baseline y=61,
x1=112, x2=320, letter-spacing 0.2, viewBox 0 0 640 96."""
import sys
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.misc.transform import Transform

def run_text(font_path, text, x, y, size, letter_spacing):
    font = TTFont(font_path)
    glyph_set = font.getGlyphSet()
    cmap = font.getBestCmap()
    upem = font['head'].unitsPerEm
    scale = size / upem
    paths, cursor = [], x
    for ch in text:
        if ch == ' ':
            cursor += glyph_set[cmap[ord('n')]].width * scale * 0.55  # word space ~ n-width*0.55
            continue
        gname = cmap[ord(ch)]
        glyph = glyph_set[gname]
        spen = SVGPathPen(glyph_set)
        # y-flip: font coords are y-up, SVG is y-down; translate to baseline
        tpen = TransformPen(spen, Transform(scale, 0, 0, -scale, cursor, y))
        glyph.draw(tpen)
        d = spen.getCommands()
        if d:
            paths.append(d)
        cursor += glyph.width * scale + letter_spacing
    return paths, cursor

def main(eb_ttf, sb_ttf, blue, orange, text_fill_1, text_fill_2, out):
    p1, end1 = run_text(eb_ttf, 'EC HOME', 112, 61, 40, 0.2)
    p2, _ = run_text(sb_ttf, 'INSPECTIONS', 320, 61, 40, 0.2)
    monogram = f'''  <g transform="translate(0 4)">
    <path fill="{blue}" d="M48 4 L10 26 L10 84 L48 84 L48 72 L22 72 L22 56 L42 56 L42 44 L22 44 L22 32 L48 17 Z"/>
    <path fill="{orange}" d="M48 4 L86 26 L86 44 L74 44 L74 33 L72 32 L72 25 L62 25 L62 26 L48 17 Z M48 72 L74 72 L74 56 L86 56 L86 84 L48 84 Z"/>
  </g>'''
    t1 = '\n'.join(f'    <path fill="{text_fill_1}" d="{d}"/>' for d in p1)
    t2 = '\n'.join(f'    <path fill="{text_fill_2}" d="{d}"/>' for d in p2)
    svg = f'''<svg viewBox="0 0 640 96" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="EC Home Inspections">
{monogram}
  <g>
{t1}
  </g>
  <g>
{t2}
  </g>
</svg>
'''
    open(out, 'w').write(svg)
    print(f"wrote {out}; EC HOME ends at x={end1:.0f} (expect < 320)")

if __name__ == '__main__':
    main(*sys.argv[1:])
```

- [ ] **Step 3: Generate both variants** (fills copied from the current mockup wordmarks — dark: `#0F2A52`/`#4A5A72` text; light: `#FFFFFF`/`#AFC0D8` text; monogram `#1E6FD9`/`#F97316` in both):

```bash
EB=$(find "$SCRATCHPAD/inter" -name 'Inter-ExtraBold.ttf' | head -1)
SB=$(find "$SCRATCHPAD/inter" -name 'Inter-SemiBold.ttf' | head -1)
mkdir -p site/assets docs/brand
./w3venv/bin/python "$SCRATCHPAD/outline_wordmark.py" "$EB" "$SB" '#1E6FD9' '#F97316' '#0F2A52' '#4A5A72' site/assets/logo-wordmark-outlined.svg
./w3venv/bin/python "$SCRATCHPAD/outline_wordmark.py" "$EB" "$SB" '#1E6FD9' '#F97316' '#FFFFFF' '#AFC0D8' site/assets/logo-wordmark-outlined-light.svg
grep -c '<text' site/assets/logo-wordmark-outlined.svg || echo "no <text> - outlined OK"
```

Expected: both files written, zero `<text>` elements, "EC HOME ends at x=" under 320 (if ≥ 320, widen the gap by moving INSPECTIONS' x to end1+22 in the script and note it).

- [ ] **Step 4: Visual check** — render both in a small HTML harness side-by-side with the ORIGINAL mockup wordmark at the same 40px height in headless Chrome; confirm the outlined versions read as the same lockup (letterforms may differ subtly — Inter vs SF — but weight, spacing, and proportions must match closely).
- [ ] **Step 5: Archive editable originals** — copy `mockups/assets/logo-wordmark-inline.svg` and `logo-wordmark-inline-light.svg` to `docs/brand/`, and write `docs/brand/README.md`:

```markdown
# EC Home Inspections brand assets

- `logo-wordmark-inline.svg` / `-light.svg` — EDITABLE wordmark originals
  (SVG `<text>`, renders with the viewer's system font). Edit these, then
  re-run the outlining step in
  `docs/superpowers/plans/2026-07-18-production-site.md` (Task 2) to
  regenerate the production files.
- Production (outlined, device-independent) copies live in `site/assets/`.
- Monogram-only logos: `mockups/assets/logo*.svg`.
- Text outlined with Inter (SIL Open Font License) ExtraBold / SemiBold.
```

- [ ] **Step 6: Commit**

```bash
git add site/assets/logo-wordmark-outlined.svg site/assets/logo-wordmark-outlined-light.svg docs/brand/
git commit -m "feat: outlined production wordmark + editable brand archive"
```

---

### Task 3: site/index.html — the production page

**Files:**
- Create: `site/index.html`
- Create (copies): `site/assets/hero05.jpg`, `site/assets/band05.jpg`, `site/assets/logo.svg` (from `mockups/assets/`, unchanged)

**Interfaces:**
- Consumes: Task 1's access key (or sentinel `W3F_KEY_PENDING`); Task 2's `assets/logo-wordmark-outlined-light.svg`.
- Produces: the page Task 4's aux files link back to and Task 5 validates.

Start from a copy of `mockups/05-big-sky.html` and apply exactly these deltas:

- [ ] **Step 1: Copy the base and assets**

```bash
mkdir -p site/assets
cp mockups/05-big-sky.html site/index.html
cp mockups/assets/hero05.jpg mockups/assets/band05.jpg mockups/assets/logo.svg site/assets/
```

- [ ] **Step 2: Head/SEO block** — replace the `<title>` and add metas so the head contains (keeping charset/viewport):

```html
<title>EC Home Inspections — TREC-Licensed Home Inspector in Sinton & Corpus Christi, TX</title>
<meta name="description" content="Professional, TREC-licensed home inspections serving Sinton, Corpus Christi, and the Coastal Bend. Book online — full digital report within 24 hours. TREC #27120.">
<link rel="canonical" href="https://echomeinspectionstx.com/">
<meta property="og:type" content="website">
<meta property="og:title" content="EC Home Inspections — Sinton & Corpus Christi, TX">
<meta property="og:description" content="TREC-licensed home inspections for the Coastal Bend. Book online — full digital report within 24 hours.">
<meta property="og:url" content="https://echomeinspectionstx.com/">
<meta property="og:image" content="https://echomeinspectionstx.com/assets/og-image.jpg">
<meta name="twitter:card" content="summary_large_image">
<link rel="icon" href="assets/favicon.svg" type="image/svg+xml">
<link rel="icon" href="assets/favicon-32.png" sizes="32x32" type="image/png">
<link rel="apple-touch-icon" href="assets/apple-touch-icon.png">
```

- [ ] **Step 3: Header brand** — the header's wordmark img becomes `src="assets/logo-wordmark-outlined-light.svg"` with `alt="EC Home Inspections"` (it is now the sole brand element — not decorative; remove `aria-hidden`). Keep the existing `.brand-wordmark` sizing CSS.
- [ ] **Step 4: Contact info sweep** — replace every `(361) 555-0100` → `(361) 558-6496`, every `tel:+13615550100` → `tel:+13615586496`, every `edna@echomeinspectionstx.com` mailto/text stays as-is if present, and any placeholder email → `edna@echomeinspectionstx.com`. Then `grep -n '555-0100\|ecavazos30' site/index.html` must return nothing.
- [ ] **Step 5: CTA button color** — add `--cta:#C2410C;` to the root variables and switch text-bearing orange buttons (`.btn-primary` and any orange-filled button with label text) from `var(--orange)` background to `var(--cta)`. `#F97316` remains for the logo, the H2 orange rules, and non-text accents. Verify contrast computationally:

```bash
python3 - <<'EOF'
def L(hex):
    c=[int(hex[i:i+2],16)/255 for i in (1,3,5)]
    c=[x/12.92 if x<=0.04045 else ((x+0.055)/1.055)**2.4 for x in c]
    return 0.2126*c[0]+0.7152*c[1]+0.0722*c[2]
r=(L('#FFFFFF')+0.05)/(L('#C2410C')+0.05)
print(f"white on #C2410C = {r:.2f}:1"); assert r>=4.5
EOF
```

Expected: ≈4.7:1, assertion passes.

- [ ] **Step 6: Wire the booking form** — inside the existing `#book` form markup (fields and labels unchanged), set `action="https://api.web3forms.com/submit" method="POST"`, give the fields these `name`s: `property_address`, `preferred_date`, `preferred_time`, `name`, `phone`, `email`; make all six `required`; button becomes `type="submit"`; add the hidden inputs:

```html
<input type="hidden" name="access_key" value="W3F_KEY_PENDING">
<input type="hidden" name="subject" value="New booking request — echomeinspectionstx.com">
<input type="hidden" name="from_name" value="EC Home Inspections website">
<input type="hidden" name="redirect" value="https://echomeinspectionstx.com/thanks.html">
<input type="checkbox" name="botcheck" tabindex="-1" autocomplete="off" style="display:none" aria-hidden="true">
```

(Replace `W3F_KEY_PENDING` with the Task 1 key if available.)

- [ ] **Step 7: Rewrite the #report section** — keep the section's dark photo-band styling and the `Already had your inspection?` H2. Replace the body with exactly:

```html
<p>Your full digital report is emailed to you within 24 hours of your
inspection. Need another copy? Request a re-send and Edna will get it to
you.</p>
```

and the form: fields `name` (Your name, text, required), `property_address` (Property address, text, required), `email` (Email address, email, required); button text `Request My Report`, `type="submit"`; same Web3Forms wiring as Step 6 but `subject` value `Report re-send request — echomeinspectionstx.com`.

- [ ] **Step 8: Wire the contact form** — same Web3Forms wiring; field names `name`, `email`, `phone`, `message` (name/email/message `required`, phone optional); `subject` value `Website contact — echomeinspectionstx.com`; button `type="submit"`.
- [ ] **Step 9: Footer** — email line shows `edna@echomeinspectionstx.com` as a `mailto:` link; phone updated per Step 4; TREC notice link and license line unchanged.
- [ ] **Step 10: Verify + commit** — invoke `frontend-design:frontend-design` if any layout adjustment beyond these deltas proves necessary (it shouldn't); render at 1280px and the 375px iframe harness — no horizontal scroll, new CTA color looks intentional, report section reads cleanly. Then:

```bash
git add site/
git commit -m "feat: production page from Big Sky with real contact, forms, AA buttons"
```

---

### Task 4: Aux pages and launch files

**Files:**
- Create: `site/thanks.html`, `site/404.html`, `site/robots.txt`, `site/sitemap.xml`, `site/CNAME`, `site/assets/favicon.svg`, `site/assets/favicon-32.png`, `site/assets/apple-touch-icon.png`, `site/assets/og-image.jpg`

**Interfaces:**
- Consumes: `site/index.html` head references (exact filenames above).

- [ ] **Step 1: thanks.html** — minimal page in the Big Sky style (navy header with the light outlined wordmark linking to `/`, white body, navy footer). Content exactly: H1 `Thank you!` and `<p>Your message is on its way to Edna. You’ll hear back within one business day.</p>` plus an `<a class="btn" href="/">Back to the site</a>` styled with `--cta`. Title: `Thanks — EC Home Inspections`. Same charset/viewport; `<meta name="robots" content="noindex">`.
- [ ] **Step 2: 404.html** — same shell; H1 `Page not found.` and `<p>That page doesn’t exist — but the inspection info you need is one tap away.</p>` + `<a class="btn" href="/">Go to the homepage</a>`. Title: `Not found — EC Home Inspections`; `noindex`.
- [ ] **Step 3: robots.txt + sitemap.xml + CNAME**, exact contents:

```
User-agent: *
Allow: /
Sitemap: https://echomeinspectionstx.com/sitemap.xml
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://echomeinspectionstx.com/</loc></url>
</urlset>
```

`site/CNAME`: the single line `echomeinspectionstx.com`.

- [ ] **Step 4: favicon + og-image** — favicon.svg is a copy of `site/assets/logo.svg`. PNGs via a headless-Chrome harness (SVG centered on white at exact canvas size), screenshots at 32×32 → `favicon-32.png` and 180×180 → `apple-touch-icon.png`. og-image: `sips -z 800 1200 site/assets/hero05.jpg --out /tmp-scratch.jpg` then `sips --cropToHeightWidth 630 1200` → `site/assets/og-image.jpg` (≤300KB; requality with `-s formatOptions 60` if larger).
- [ ] **Step 5: Verify + commit** — open thanks/404 at 375px harness (no overflow, buttons tappable); confirm all four asset files exist with expected dimensions (`sips -g pixelWidth -g pixelHeight`). Then:

```bash
git add site/
git commit -m "feat: thanks/404 pages, robots, sitemap, CNAME, icons, og image"
```

---

### Task 5: check-site.sh + deploy workflow

**Files:**
- Create: `scripts/check-site.sh`
- Modify: `.github/workflows/pages.yml` (upload step)

**Interfaces:**
- Consumes: everything under `site/`. Produces: the gate Task 6 requires.

- [ ] **Step 1: Write `scripts/check-site.sh`** (chmod +x):

```bash
#!/usr/bin/env bash
# Validates the production site. Usage: scripts/check-site.sh
f=site/index.html; fail=0
[ -f "$f" ] || { echo "MISSING $f"; exit 1; }
grep -q 'name="viewport"' "$f" || { echo "MISSING viewport"; fail=1; }
grep -q '<title>EC Home Inspections' "$f" || { echo "MISSING title"; fail=1; }
grep -q 'trec.texas.gov/forms/consumer-protection-notice' "$f" || { echo "MISSING TREC link"; fail=1; }
grep -q '27120' "$f" || { echo "MISSING license"; fail=1; }
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
grep -q '(361) 558-6496' "$f" || { echo "MISSING real phone"; fail=1; }
grep -q 'tel:+13615586496' "$f" || { echo "MISSING tel link"; fail=1; }
grep -q 'edna@echomeinspectionstx.com' "$f" || { echo "MISSING domain email"; fail=1; }
grep -q '555-0100\|ecavazos30' site/*.html && { echo "PLACEHOLDER/PRIVATE INFO LEAK"; fail=1; }
[ "$(grep -c 'action="https://api.web3forms.com/submit"' "$f")" -eq 3 ] || { echo "EXPECTED 3 web3forms forms"; fail=1; }
[ "$(grep -c 'name="botcheck"' "$f")" -eq 3 ] || { echo "EXPECTED 3 honeypots"; fail=1; }
grep -q 'W3F_KEY_PENDING' "$f" && { echo "ACCESS KEY STILL SENTINEL"; fail=1; }
[ "$(cat site/CNAME)" = "echomeinspectionstx.com" ] || { echo "BAD CNAME"; fail=1; }
for p in site/thanks.html site/404.html site/robots.txt site/sitemap.xml \
         site/assets/favicon.svg site/assets/favicon-32.png \
         site/assets/apple-touch-icon.png site/assets/og-image.jpg \
         site/assets/logo-wordmark-outlined-light.svg; do
  [ -f "$p" ] || { echo "MISSING $p"; fail=1; }
done
if grep -E 'src="https?://|<link[^>]+href="https?://|url\(["'"'"']?https?://|@import' site/*.html \
   | grep -v 'api.web3forms.com' ; then echo "EXTERNAL ASSET FOUND"; fail=1; fi
[ "$fail" -eq 0 ] && echo "OK: production site"
exit $fail
```

- [ ] **Step 2: Run it** — expected: passes fully IF Task 1's key is in place; otherwise fails only with `ACCESS KEY STILL SENTINEL` (that single failure is acceptable until launch, and blocks Task 6).
- [ ] **Step 3: Update `.github/workflows/pages.yml`** — replace the upload step so the artifact is site-at-root + mockups subfolder:

```yaml
      - name: Assemble site
        run: |
          mkdir _site
          cp -r site/. _site/
          cp -r mockups _site/mockups
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site
```

(The checkout + configure-pages + deploy-pages steps stay as they are.)

- [ ] **Step 4: Commit, push, verify the github.io deployment**

```bash
git add scripts/check-site.sh .github/workflows/pages.yml
git commit -m "feat: site validation script; deploy site root + mockups archive"
git push
```

Watch the run (`gh run watch`), then confirm: `https://magonzalez.github.io/echomeinspections-website/` serves the PRODUCTION page (navy header, real phone), and `/mockups/` serves the concept index. NOTE: until DNS cutover, the Pages URL under a repo subpath means absolute-path links (`/`, `/thanks.html`) resolve against the domain root — verify the thanks/404 links by URL-editing rather than click-through, and re-verify properly after cutover.

---

### Task 6: Launch — DNS cutover + live verification (human-gated)

**Files:** none (operations + verifications)

Preconditions: `check-site.sh` fully green (real access key in place), Cloudflare Email Routing verified (test mail to `edna@echomeinspectionstx.com` landed), client aware the site is going live.

- [ ] **Step 1: Cloudflare DNS records** (developer, in the Cloudflare dashboard — all **DNS only / gray cloud**): four `A` records on `@` → `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`; one `CNAME` `www` → `magonzalez.github.io`.
- [ ] **Step 2: Pages custom domain**

```bash
gh api repos/magonzalez/echomeinspections-website/pages -X PUT -f cname=echomeinspectionstx.com
```

Wait for the DNS check + certificate (minutes to ~1h), then enforce HTTPS:

```bash
gh api repos/magonzalez/echomeinspections-website/pages -X PUT -F https_enforced=true
```

- [ ] **Step 3: Verify live** — `dig +short echomeinspectionstx.com` returns the four A records; `curl -sI https://echomeinspectionstx.com/` → 200 with the production title; `https://www.echomeinspectionstx.com` redirects to the apex; `/mockups/` serves the archive; `/thanks.html` renders; a bogus path renders 404.html.
- [ ] **Step 4: Real form tests** — submit one test through each of the three forms on the live site; confirm all three arrive in `ecavazos30@yahoo.com` (check spam the first time) and the browser lands on `/thanks.html`; delete the test emails.
- [ ] **Step 5: Wrap up** — update `docs/production-notes.md`: mark the CTA-contrast item DONE, add "swap report section to platform portal when Edna picks software" as the standing item. Commit `git commit -am "docs: launch complete; remaining platform integration noted"` and push.
