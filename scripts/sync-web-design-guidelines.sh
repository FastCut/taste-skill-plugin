#!/usr/bin/env bash
# Copies the latest web-design-guidelines skill from vercel-labs/agent-skills
# into web-design-guidelines/skills/ and updates the plugin version.
# Usage: scripts/sync-web-design-guidelines.sh <path-to-upstream-checkout>
set -euo pipefail

UP="${1:?path to upstream checkout}"
SRC="$UP/skills/web-design-guidelines"
DEST="web-design-guidelines/skills/web-design-guidelines"

[ -f "$SRC/SKILL.md" ] || { echo "Upstream SKILL.md not found"; exit 1; }
grep -q '^name: web-design-guidelines' "$SRC/SKILL.md" || { echo "Unexpected skill name upstream"; exit 1; }

rm -rf "$DEST"
mkdir -p "$(dirname "$DEST")"
cp -R "$SRC" "$DEST"

VER=$(sed -n 's/^[[:space:]]*version:[[:space:]]*//p' "$SRC/SKILL.md" | head -1 | tr -d "\"'")
[ -n "$VER" ] || VER="1.0.0"

python3 - "$VER" <<'EOF'
import json, sys
ver = sys.argv[1]
with open(".claude-plugin/marketplace.json") as f:
    data = json.load(f)
for p in data["plugins"]:
    if p["name"] == "web-design-guidelines":
        p["version"] = ver
with open(".claude-plugin/marketplace.json", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
path = "web-design-guidelines/.claude-plugin/plugin.json"
with open(path) as f:
    data = json.load(f)
data["version"] = ver
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

git -C "$UP" rev-parse HEAD > .upstream-commit-web-design-guidelines
echo "Synced web-design-guidelines $VER from $(cut -c1-7 .upstream-commit-web-design-guidelines)"
