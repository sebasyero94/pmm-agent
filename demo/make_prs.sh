#!/usr/bin/env bash
# Opens 3 demo PRs (T0, T2, T3) against main. Run from the repo root after pushing main.
set -euo pipefail

pr() { # branch, title, body
  git push -u origin "$1" >/dev/null
  gh pr create --base main --head "$1" --title "$2" --body "$3"
  git checkout main >/dev/null
}

# 1. T0: color tweak
git checkout -b demo/color-tweak main
sed -i '' 's/#7856ff/#6b4af0/' app/theme.css
git commit -qam "Slightly darken brand purple"
pr demo/color-tweak "Darken brand purple" "Tweaks the primary color for better contrast."

# 2. T2: new feature
git checkout -b demo/replay-filters main
sed -i '' 's/FILTERS = \["country", "device", "event_name"\]/FILTERS = ["country", "device", "event_name", "user_property", "rage_click"]/' app/session_replay.py
git commit -qam "Session Replay: filter by user property and rage clicks"
pr demo/replay-filters "Session Replay: filter by user property and rage clicks" "Adds two new filters so teams can find frustrated users and segment replays by any user property."

# 3. T3: pricing change
git checkout -b demo/pricing main
python3 - <<'PY'
import json
p = json.load(open("app/pricing.json"))
p["plans"]["free"]["monthly_events"] = 2000000
p["plans"]["growth"]["price_usd_per_month"] = 24
json.dump(p, open("app/pricing.json", "w"), indent=2); open("app/pricing.json", "a").write("\n")
PY
git commit -qam "Pricing: Free tier to 2M events, Growth to \$24/mo"
pr demo/pricing "Pricing: Free tier to 2M events, Growth drops to \$24/mo" "Doubles the Free plan event allowance and lowers Growth pricing. Effective next month."
