# Skills Library

Repository-backed Codex plugin marketplace for personal workflow skills.

This repository is structured as a Codex plugin platform. Codex can add it through
the **Add platform** dialog by reading `.agents/plugins/marketplace.json`, then
installing the `skills-library` plugin from `plugins/skills-library`.

## Available Plugin

| Plugin | Version | Category | Description |
| --- | --- | --- | --- |
| Skills Library | 0.1.0 | Productivity | Personal Codex workflow skills for visual planning and bounded review loops. |

## Included Skills

| Skill | Version | Description |
| --- | --- | --- |
| Code Review Loop | 0.1.0 | Bounded review-fix-test cycles that rerun code review until changes are clean or a maximum iteration count is reached. |
| Visual Brainstorming | 0.1.0 | Diagram-first brainstorming, product specs, and DDD-oriented architecture planning for repo-backed changes. |

## Repository Structure

```text
.agents/
  plugins/
    marketplace.json
plugins/
  skills-library/
    .codex-plugin/
      plugin.json
    skills/
      code-review-loop/
        SKILL.md
      visual-brainstorming/
        SKILL.md
scripts/
  validate-marketplace.ps1
docs/
  superpowers/
    specs/
    plans/
```

## Add This Platform To Codex

Open Codex and choose **Add platform**.

Use:

```text
Source: C:\git\pf\skills-library\
Git reference: main
Sparse checkout paths:
.agents/plugins
plugins
```

For a local folder source, leaving sparse checkout empty should also work. If you
use sparse checkout, include both `.agents/plugins` and `plugins`, because the
marketplace file and plugin files live in separate top-level folders.

After adding the platform, install the `Skills Library` plugin from Codex. You may
need to start a new conversation or restart Codex before the newly installed
skills appear in the available skills list.

## Validate The Marketplace

Run:

```powershell
.\scripts\validate-marketplace.ps1
```

Expected:

```text
Plugin marketplace validation passed (1 plugins, 2 skills).
```

The validator checks that:

- `.agents/plugins/marketplace.json` parses.
- Every marketplace plugin entry has installation and authentication policy.
- Every plugin entry points to a real `.codex-plugin/plugin.json`.
- Every plugin manifest name matches its folder and marketplace entry.
- The plugin skills directory exists.
- Every skill has a `SKILL.md` whose frontmatter declares the matching skill name.

## Add A Skill

1. Create a new folder under `plugins/skills-library/skills/<skill-id>/`.
2. Add `SKILL.md` with frontmatter whose `name` matches `<skill-id>`.
3. Update `plugins/skills-library/.codex-plugin/plugin.json` if the plugin
   description, keywords, or starter prompts should change.
4. Run `.\scripts\validate-marketplace.ps1`.

## Add Another Plugin

1. Create a new folder under `plugins/<plugin-id>/`.
2. Add `plugins/<plugin-id>/.codex-plugin/plugin.json`.
3. Add a plugin entry to `.agents/plugins/marketplace.json`:

```json
{
  "name": "plugin-id",
  "source": {
    "source": "local",
    "path": "./plugins/plugin-id"
  },
  "policy": {
    "installation": "AVAILABLE",
    "authentication": "ON_INSTALL"
  },
  "category": "Productivity"
}
```

4. Run `.\scripts\validate-marketplace.ps1`.
