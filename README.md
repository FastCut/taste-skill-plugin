# taste-skill-plugin

The `design-taste-frontend` skill from [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill), repackaged as a Claude plugin marketplace (plugin in `./plugin` with its own `plugin.json`), so it can be added in Claude under Customize → Plugins → Add marketplace.

All skill content is by Leonxlnx and is MIT licensed (see `LICENSE`). Nothing in the skill is changed.

## Updates

A GitHub Action (`.github/workflows/sync-upstream.yml`) runs daily, copies the latest `skills/taste-skill` from the upstream repository into `plugin/skills/design-taste-frontend`, updates the version and commits only when something changed. It can also be run by hand from the Actions tab. `.upstream-commit` records the upstream commit the skill came from.

## Install

- Claude (chat and Claude Code via account sync): Customize → Plugins → Add → Add marketplace → `FastCut/taste-skill-plugin`, with Sync automatically on.
- Claude Code CLI: `/plugin marketplace add FastCut/taste-skill-plugin`, then `/plugin install taste-skill@taste-skill-plugin`.
