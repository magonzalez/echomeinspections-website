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
