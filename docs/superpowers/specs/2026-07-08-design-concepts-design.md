# EC Home Inspections — Design Concepts Presentation

**Date:** 2026-07-08
**Status:** Approved

## Purpose

Produce a client-facing presentation package of 4 clickable homepage mockups for
EC Home Inspections, a new home inspection business in Sinton, TX. The client
(Edna Cavazos, non-technical) will review the mockups and pick a visual
direction; the winning design becomes the foundation of the production site.

The mockups intentionally demonstrate more than the requested contact form —
online booking and online report access — to sell the full vision. Booking and
report access are UI demonstrations only; they will later be wired to whichever
inspection platform she adopts (Spectora, HomeGauge, ISN, or similar), which is
currently unknown.

## Client facts

- **Business:** EC Home Inspections — echomeinspectionstx.com
- **Owner:** Edna Cavazos, TREC License #27120, solo owner-operator
- **Location:** 10577 CR 2349, Sinton, Texas (Coastal Bend, near Corpus Christi)
- **Services:** the 11 components of the TREC Standards of Practice —
  Foundation; Grading/Drainage; Roof Covering; Roof Structure/Attics; Walls;
  Doors/Windows; Floors/Ceilings; HVAC; Electrical; Plumbing; Built-In
  Appliances
- **Required footer link:** TREC Consumer Protection Notice —
  https://www.trec.texas.gov/forms/consumer-protection-notice

## Logo

The client's reference is a watermarked Shutterstock image
(`docs/from-client/screenshot-logo.jpeg`) and cannot be copied. Instead, design
an **original SVG monogram**: a house-outline "EC" mark, bright blue "E" and
orange "C", inspired by the concept but original work. It ships royalty-free
with the site. Flag the licensing issue to the client during the presentation.

## Deliverables

All files are static, self-contained HTML (inline CSS, embedded SVG, no build
step, no external network dependencies) and mobile-responsive, since the client
will likely review on her phone.

- `mockups/index.html` — "EC Home Inspections — Design Concepts" landing page
  linking to each direction with a one-line description
- `mockups/01-established-trusted.html`
- `mockups/02-bright-approachable.html`
- `mockups/03-coastal-bend-local.html`
- `mockups/04-precision-thorough.html`

## Shared content skeleton

Every mockup contains the same sections in the same order, so aesthetics are
the only variable between them:

1. **Header** — EC monogram SVG, business name, phone placeholder, nav
2. **Hero** — value proposition + primary "Schedule Your Inspection" CTA
3. **Online booking teaser** — date/time request UI (non-functional demo)
4. **Services** — the 11 TREC components as a visual checklist
5. **How it works** — Book → Inspect → Get your report online
6. **Access Your Report** — entry point for retrieving completed reports
7. **About Edna** — owner-operator story, TREC #27120, service area
8. **Contact form** (non-functional demo) + footer with address and TREC
   Consumer Protection Notice link

Placeholder content rules: phone number and email use obvious placeholders
(e.g. "(361) 555-0100"). Photography (amended 2026-07-08, client-developer
request): mockups 01–03 may include a small number of curated photos sourced
only from permissive-license libraries (Pexels/Unsplash/Pixabay licenses —
free commercial use, no attribution required), stored locally in
`mockups/assets/` and referenced by relative path (strict single-file
self-containment was relaxed 2026-07-08: the client-developer will host the
mockups online, so the deliverable is now the self-contained `mockups/`
folder). Every photo's source URL and license is recorded in
`docs/image-credits.md`. No people presented as Edna or her staff. Mockup 04
stays photo-free — its blueprint aesthetic is the character. Paid-license
stock (e.g. Shutterstock) remains prohibited.

## The four directions

All four honor the blue/orange brand; they differ in personality:

1. **Established & Trusted** — deep navy base, generous white space, restrained
   orange accents, classic typography. Reads like a long-established firm.
2. **Bright & Approachable** — bright blue dominant, rounded friendly type,
   large orange CTAs, icon-driven. Aimed at first-time homebuyers.
3. **Coastal Bend Local** — airy, warm, light palette with gulf-coast
   character; leads with Edna and the local service area. Personal trust as
   the differentiator.
4. **Precision & Thorough** — dark slate, blueprint/technical motifs, the TREC
   checklist as the visual centerpiece. Sells rigor.

## Out of scope

- Production site build (follows after the client picks a direction)
- Working form submission, booking, or report retrieval
- Inspection-platform selection or integration
- Final logo refinement beyond the mockup SVG
- Hosting/domain setup for echomeinspectionstx.com

## Success criteria

- Each mockup opens correctly from the filesystem with no network access
- All four read as distinctly different at a glance, on a phone
- The index page lets a non-technical reviewer navigate the set unaided
- No assets appear anywhere without a license permitting free commercial use
  (permissive-license photos must be credited in `docs/image-credits.md`)
