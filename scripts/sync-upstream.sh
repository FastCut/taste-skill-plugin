#!/usr/bin/env bash
# Copies the latest design-taste-frontend skill from Leonxlnx/taste-skill
# into plugin/skills/ and updates the plugin version.
# Usage: scripts/sync-upstream.sh <path-to-upstream-checkout>
set -euo pipefail

UP="${1:?path to upstream checkout}"
DEST="plugin/skills/design-taste-frontend"

[ -f "$UP/skills/taste-skill/SKILL.md" ] || { echo "Upstream SKILL.md not found"; exit 1; }
grep -q '^name: design-taste-frontend' "$UP/skills/taste-skill/SKILL.md" || { echo "Unexpected skill name upstream"; exit 1; }

rm -rf "$DEST"
mkdir -p "$(dirname "$DEST")"
cp -R "$UP/skills/taste-skill" "$DEST"
[ -f "$UP/LICENSE" ] && cp "$UP/LICENSE" LICENSE

VER=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['plugins'][0]['version'])" "$UP/.claude-plugin/marketplace.json")

python3 - "$VER" <<'EOF'
import json, sys
ver = sys.argv[1]
for path in [".claude-plugin/marketplace.json", "plugin/.claude-plugin/plugin.json"]:
    with open(path) as f:
        data = json.load(f)
    if "plugins" in data:
        data["plugins"][0]["version"] = ver
    else:
        data["version"] = ver
    with open(path, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
EOF

git -C "$UP" rev-parse HEAD > .upstream-commit
echo "Synced design-taste-frontend $VER from $(cut -c1-7 .upstream-commit)"
