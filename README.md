# taste-skill-plugin

Third-party skills, repackaged as a Claude plugin marketplace so they can be added in Claude under Customize → Plugins → Add marketplace. Each plugin lives in its own folder with its own `plugin.json`.

| Plugin | Folder | Upstream | Skills |
|---|---|---|---|
| `taste-skill` | `plugin/` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | design-taste-frontend |
| `imagegen-skills` | `imagegen/` | [Leonxlnx/imagegen-skills](https://github.com/Leonxlnx/imagegen-skills) | imagegen-frontend-web, imagegen-frontend-mobile, brandkit, image-to-code |
| `img2threejs` | `img2threejs/` | [img2threejs/img2threejs](https://github.com/img2threejs/img2threejs) (latest stable release) | img2threejs |

Skill content belongs to its authors: taste-skill and imagegen-skills by Leonxlnx (MIT, see `LICENSE` and `imagegen/LICENSE`), img2threejs by img2threejs (Apache-2.0, see `img2threejs/LICENSE`). Nothing in the skills is changed.

## Updates

A GitHub Action (`.github/workflows/sync-upstream.yml`) runs daily, copies the latest skills from the upstream repositories (for img2threejs, the newest stable `vX.Y.Z` release tag), updates the versions and commits only when something changed. It can also be run by hand from the Actions tab. The `.upstream-commit*` files record where each plugin's content came from.

## Install

- Claude (chat and Claude Code via account sync): Customize → Plugins → Add → Add marketplace → `FastCut/taste-skill-plugin`, with Sync automatically on, then install the plugins.
- Claude Code CLI: `/plugin marketplace add FastCut/taste-skill-plugin`, then `/plugin install taste-skill@taste-skill-plugin` and `/plugin install imagegen-skills@taste-skill-plugin` and `/plugin install img2threejs@taste-skill-plugin`. img2threejs needs Python 3.10+ (stdlib only) on the machine that runs it.
