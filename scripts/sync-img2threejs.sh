#!/usr/bin/env bash
# Copies a release of img2threejs/img2threejs (the whole repository is the skill)
# into img2threejs/skills/img2threejs and updates the plugin version.
# Usage: scripts/sync-img2threejs.sh <path-to-upstream-checkout> <tag>
set -euo pipefail

UP="${1:?path to upstream checkout}"
TAG="${2:?release tag}"
DEST="img2threejs/skills/img2threejs"

[ -f "$UP/SKILL.md" ] || { echo "Upstream SKILL.md not found"; exit 1; }
grep -q '^name: img2threejs' "$UP/SKILL.md" || { echo "Unexpected skill name upstream"; exit 1; }

rm -rf "$DEST"
mkdir -p "$DEST"
tar -C "$UP" --exclude=./.git --exclude=./.github -cf - . | tar -C "$DEST" -xf -
cp "$UP/LICENSE" img2threejs/LICENSE

VER=$(sed -n 's/^version:[[:space:]]*//p' "$UP/SKILL.md" | head -1 | tr -d "\"'")
[ -n "$VER" ] || VER="${TAG#v}"

python3 - "$VER" <<'EOF'
import json, sys
ver = sys.argv[1]
with open(".claude-plugin/marketplace.json") as f:
    data = json.load(f)
for p in data["plugins"]:
    if p["name"] == "img2threejs":
        p["version"] = ver
with open(".claude-plugin/marketplace.json", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
path = "img2threejs/.claude-plugin/plugin.json"
with open(path) as f:
    data = json.load(f)
data["version"] = ver
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

echo "$TAG $(git -C "$UP" rev-parse HEAD)" > .upstream-commit-img2threejs
echo "Synced img2threejs $VER ($TAG)"
