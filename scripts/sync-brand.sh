#!/usr/bin/env bash
# Copies the selected brand skills from rampstackco/claude-skills into
# brand/skills/ and updates the plugin version.
# Usage: scripts/sync-brand.sh <path-to-upstream-checkout>
set -euo pipefail

UP="${1:?path to upstream checkout}"
DEST="brand/skills"
SKILLS="brand-discovery brand-ideation brand-archetype-system brand-identity logo-design brand-style-guide brand-voice"

for s in $SKILLS; do
  [ -f "$UP/skills/$s/SKILL.md" ] || { echo "Upstream skill $s not found"; exit 1; }
done

rm -rf "$DEST"
mkdir -p "$DEST"
for s in $SKILLS; do
  cp -R "$UP/skills/$s" "$DEST/$s"
done
cp "$UP/LICENSE" brand/LICENSE

VER=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['version'])" "$UP/.claude-plugin/plugin.json")

python3 - "$VER" <<'EOF'
import json, sys
ver = sys.argv[1]
with open(".claude-plugin/marketplace.json") as f:
    data = json.load(f)
for p in data["plugins"]:
    if p["name"] == "rampstack-brand":
        p["version"] = ver
with open(".claude-plugin/marketplace.json", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
path = "brand/.claude-plugin/plugin.json"
with open(path) as f:
    data = json.load(f)
data["version"] = ver
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

git -C "$UP" rev-parse HEAD > .upstream-commit-brand
echo "Synced rampstack-brand $VER ($SKILLS) from $(cut -c1-7 .upstream-commit-brand)"
