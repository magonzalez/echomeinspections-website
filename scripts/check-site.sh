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
