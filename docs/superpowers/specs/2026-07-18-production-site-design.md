# EC Home Inspections — Production Site

**Date:** 2026-07-18
**Status:** Approved
**Predecessor:** `2026-07-08-design-concepts-design.md` (client chose concept 05 "Big Sky")

## Purpose

Turn the chosen Big Sky mockup (`mockups/05-big-sky.html`) into the launched
production website at **echomeinspectionstx.com**: real contact details,
working forms, honest report-access messaging, accessibility fixes, SEO/launch
hygiene, and custom-domain deployment — while keeping the concept mockups
reachable as an archive.

## Decisions (from client-developer, 2026-07-18)

- **Hosting/forms:** GitHub Pages (existing repo + Actions pipeline) +
  Web3Forms for all forms. Free tiers; no new platforms.
- **Inspection software:** still undecided → booking stays a request form;
  report access is an explainer + re-send request form. No fake portals.
- **Real contact info:** phone `(361) 558-6496`
  (`tel:+13615586496`), email `ecavazos30@yahoo.com`. These replace the
  placeholders everywhere on the production site (mockups keep placeholders).
- **Domain:** echomeinspectionstx.com is registered; the developer has DNS
  access and will add the records.

## Architecture

Single-page static site, zero dependencies, same repo:

```
site/
  index.html      production page (derived from mockups/05-big-sky.html)
  thanks.html     post-submission landing ("Thanks — Edna will be in touch")
  404.html        friendly not-found page
  robots.txt
  sitemap.xml
  CNAME           echomeinspectionstx.com
  assets/         copied/derived from mockups/assets (photos, logos, favicon,
                  og-image)
```

Deploy: the existing `.github/workflows/pages.yml` changes to assemble an
artifact of `site/` at the root **plus `mockups/` as a subfolder** (concept
archive stays browsable at `/mockups/`). Push to main → live.

DNS (at the registrar): four GitHub Pages apex A records
(185.199.108.153 / .109. / .110. / .111.) and `www` CNAME →
`magonzalez.github.io`; then set the custom domain on the Pages settings and
enforce HTTPS. The `*.github.io` URL keeps serving throughout the cutover.

## Page content (deltas from the Big Sky mockup)

The Big Sky layout, palette, typography, photography, and section order are
kept as approved by the client. Changes:

1. **Contact details** — real phone/email everywhere (header, booking note,
   footer, contact section). All `tel:` links use `+13615586496`.
2. **Forms → Web3Forms** — booking form, contact form, and report re-send
   form each POST to `https://api.web3forms.com/submit` with the project's
   access key (developer creates one Web3Forms account/key delivering to
   `ecavazos30@yahoo.com`), a hidden `subject` per form ("New booking
   request…", "Website contact…", "Report re-send request…"), a honeypot
   field, and `redirect` to `/thanks.html`. Buttons become real
   `type="submit"`. No JavaScript required.
3. **Report section rewrite** — headline copy stays; body becomes an honest
   explainer: your full digital report is emailed within 24 hours of the
   inspection; form lets a past client request a re-send (name, property
   address, email). When Edna picks her platform (Spectora/HomeGauge/ISN),
   this section swaps to that portal's real link — designed so the swap is a
   contained edit.
4. **Accessibility fix (from docs/production-notes.md)** — all text-bearing
   orange buttons use a darkened orange in the `#C2410C` range with white
   text verified ≥4.5:1; brand orange `#F97316` remains in the logo and
   non-text accents. The credential-badge style is not carried over (that was
   mockup 06).
5. **Wordmark hardening** — `logo-wordmark-inline.svg` (and the light variant
   used on the navy header) get their `<text>` converted to outlined paths so
   rendering is identical on every device. Original editable SVGs are kept
   under `docs/brand/` for future edits.
6. **Launch hygiene** — `<title>` and meta description naming Sinton, Corpus
   Christi, and the Coastal Bend; canonical URL; Open Graph/Twitter tags with
   a 1200×630 `og-image.jpg` derived from the hero photo; favicon (SVG + PNG
   fallback) from the EC monogram; `robots.txt` allowing all + sitemap
   pointer; `sitemap.xml` with the single page; `404.html` styled like the
   site with a link home.

## Verification

- `scripts/check-site.sh` (new, derived from check-mockup.sh): asserts
  viewport/title, TREC notice link, license #27120, all 11 services, real
  phone and email present, NO placeholder `555-0100` / `edna@` strings,
  every `<form>` has the Web3Forms action + access key + honeypot, CNAME
  file contents, and no external assets beyond the TREC anchor and the
  Web3Forms form action.
- Rendered checks at desktop and true-375px (iframe harness) as in prior
  rounds.
- Post-deploy: live-URL 200s for `/`, `/thanks.html`, `/404` behavior,
  `/mockups/` archive; one real test submission per form arriving in the
  inbox (developer verifies, then deletes test emails).

## Out of scope

- Inspection-platform integration (blocked on Edna's choice)
- Domain email forwarding (suggested to client; registrar-side setup)
- Analytics
- Additional pages/blog
- Replacing stock photography with real photos of Edna/her work (future
  content improvement)

## Success criteria

- echomeinspectionstx.com serves the site over HTTPS with the Big Sky design
- All three forms deliver to Edna's inbox and land on `/thanks.html`
- No placeholder contact info anywhere on the production page
- Concept archive still reachable at `/mockups/`
- `check-site.sh` passes; no WCAG AA text-contrast failures on the page
