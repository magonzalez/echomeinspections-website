# Production Notes

## Launched 2026-07-18 — https://echomeinspectionstx.com

Resolved at launch:

- ~~**Orange CTA contrast (WCAG AA)**~~ — DONE: production text-bearing
  buttons use `--cta:#C2410C` (white ≈5.2:1); brand orange `#F97316` remains
  for the logo and non-text accents. The concept mockups (archived at
  `/mockups/`) intentionally keep the original color.
- ~~Forms~~ — DONE: booking, report re-send, and contact forms deliver via
  Web3Forms (key in `site/index.html`; free tier). Note: Web3Forms
  spam-filters test-shaped content (e.g. "testing" messages, rapid repeats) —
  flagged submissions sit in the Web3Forms dashboard Spam tab for 7 days
  without emailing. Realistic submissions verified delivering 2026-07-18.
- ~~Logo~~ — DONE: original wordmark (developer-designed), text outlined with
  Inter (OFL) for device-independent rendering. Editable sources in
  `docs/brand/`.

## Standing items

- **Inspection platform integration** — when Edna picks her software
  (Spectora / HomeGauge / ISN): replace the `#report` section's re-send form
  with the platform's real report-portal link, and optionally replace the
  booking request form with the platform's scheduler. Both are contained
  edits in `site/index.html`.
- **Web3Forms recipient swap** — submissions currently deliver to the
  developer (miguel@doesnotcompile.com). When Edna is ready, change
  Recipient Emails in the Web3Forms dashboard to her inbox — no site change
  needed.
- **Email forwarding** — `edna@echomeinspectionstx.com` forwards to Edna's
  personal inbox via Cloudflare Email Routing (receive-only; her replies
  come from the personal address).
- Optional future: `LocalBusiness` JSON-LD structured data; Google Business
  Profile + Search Console registration; real photography of Edna at work
  replacing the stock hero images.
