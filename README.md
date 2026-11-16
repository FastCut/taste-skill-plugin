# taste-skill-plugin

Skills by Leonxlnx, repackaged as a Claude plugin marketplace so they can be added in Claude under Customize → Plugins → Add marketplace. Each plugin lives in its own folder with its own `plugin.json`.

| Plugin | Folder | Upstream | Skills |
|---|---|---|---|
| `taste-skill` | `plugin/` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | design-taste-frontend |
| `imagegen-skills` | `imagegen/` | [Leonxlnx/imagegen-skills](https://github.com/Leonxlnx/imagegen-skills) | imagegen-frontend-web, imagegen-frontend-mobile, brandkit, image-to-code |

All skill content is by Leonxlnx and is MIT licensed (see `LICENSE` and `imagegen/LICENSE`). Nothing in the skills is changed.

## Updates

A GitHub Action (`.github/workflows/sync-upstream.yml`) runs daily, copies the latest skills from both upstream repositories, updates the versions and commits only when something changed. It can also be run by hand from the Actions tab. `.upstream-commit` and `.upstream-commit-imagegen` record the upstream commits the skills came from.

## Install

- Claude (chat and Claude Code via account sync): Customize → Plugins → Add → Add marketplace → `FastCut/taste-skill-plugin`, with Sync automatically on, then install the plugins.
- Claude Code CLI: `/plugin marketplace add FastCut/taste-skill-plugin`, then `/plugin install taste-skill@taste-skill-plugin` and `/plugin install imagegen-skills@taste-skill-plugin`.
