# Skills Library

Repository-backed skills marketplace for Codex and Claude Code.

The marketplace is intentionally small: skill folders live in `skills/`, and the top-level `marketplace.json` file is the machine-readable index. The first published skill is `Visual Brainstorming`.

## Available Skills

| Skill | Version | Targets | Description |
| --- | --- | --- | --- |
| Visual Brainstorming | 0.1.0 | Codex, Claude Code | Diagram-first brainstorming, product specs, and DDD-oriented architecture planning for repo-backed changes. |

## Repository Structure

```text
marketplace.json
skills/
  visual-brainstorming/
    SKILL.md
scripts/
  validate-marketplace.ps1
docs/
  superpowers/
    specs/
    plans/
```

## Install A Skill

This MVP is file-based. Clone this repository or download the skill folder, then copy the selected skill folder into the local skills directory used by your agent.

For `Visual Brainstorming`, copy:

```text
skills/visual-brainstorming
```

The skill entrypoint is:

```text
skills/visual-brainstorming/SKILL.md
```

## Validate The Marketplace

Run:

```powershell
.\scripts\validate-marketplace.ps1
```

Expected:

```text
Marketplace validation passed (1 skills).
```

The validator checks that `marketplace.json` parses, required fields exist, Codex and Claude Code compatibility flags are present, and every skill entry points to a real `SKILL.md`.

## Add A Skill

1. Create a new folder under `skills/<skill-id>/`.
2. Add `SKILL.md` with frontmatter whose `name` matches `<skill-id>`.
3. Add a new entry to `marketplace.json`.
4. Include both target compatibility flags:

```json
"targets": {
  "codex": {
    "compatible": true
  },
  "claudeCode": {
    "compatible": true
  }
}
```

5. Run `.\scripts\validate-marketplace.ps1`.

## First Skill: Visual Brainstorming

`Visual Brainstorming` orchestrates visual, Mermaid-first discovery for repo-backed changes. This marketplace version adds an architecture-planning stage after the product/business spec is approved and before detailed implementation planning begins.

The architecture stage focuses on module boundaries, bounded contexts, interfaces, domain models, data models, and UI/component hierarchy when relevant.
