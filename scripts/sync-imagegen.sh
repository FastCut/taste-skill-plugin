#!/usr/bin/env bash
# Copies the latest skills from Leonxlnx/imagegen-skills into imagegen/skills/
# and updates the plugin version.
# Usage: scripts/sync-imagegen.sh <path-to-upstream-checkout>
set -euo pipefail

UP="${1:?path to upstream checkout}"
DEST="imagegen/skills"

[ -d "$UP/skills" ] || { echo "Upstream skills/ not found"; exit 1; }
ls "$UP"/skills/*/SKILL.md >/dev/null 2>&1 || { echo "No SKILL.md files upstream"; exit 1; }

rm -rf "$DEST"
mkdir -p "$DEST"
for dir in "$UP"/skills/*/; do
  [ -f "$dir/SKILL.md" ] && cp -R "$dir" "$DEST/$(basename "$dir")"
done
[ -f "$UP/LICENSE" ] && cp "$UP/LICENSE" imagegen/LICENSE

VER=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['plugins'][0]['version'])" "$UP/.claude-plugin/marketplace.json")

python3 - "$VER" <<'EOF'
import json, sys
ver = sys.argv[1]
with open(".claude-plugin/marketplace.json") as f:
    data = json.load(f)
for p in data["plugins"]:
    if p["name"] == "imagegen-skills":
        p["version"] = ver
with open(".claude-plugin/marketplace.json", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
path = "imagegen/.claude-plugin/plugin.json"
with open(path) as f:
    data = json.load(f)
data["version"] = ver
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

git -C "$UP" rev-parse HEAD > .upstream-commit-imagegen
echo "Synced imagegen-skills $VER ($(ls "$DEST" | tr '\n' ' ')) from $(cut -c1-7 .upstream-commit-imagegen)"
