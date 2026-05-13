# Skills Library

Repository-backed Codex plugin marketplace for personal workflow skills.

This repository is structured as a Codex plugin platform. Codex can add it through
the **Add platform** dialog by reading `.agents/plugins/marketplace.json`, then
installing the desired plugins from `plugins/`.

## Available Plugins

| Plugin | Version | Category | Description |
| --- | --- | --- | --- |
| Skills Library | 0.1.0 | Productivity | Personal Codex workflow skills for visual planning and bounded review loops. |
| Domain-Driven Design | 0.1.0 | Development | Focused DDD toolkit for strategic design, context mapping, and tactical domain modeling. |
| Event-Driven Architecture | 0.1.0 | Development | CQRS, event sourcing, event stores, projections, and saga workflow skills. |

## Plugin Scope

The marketplace intentionally separates domain modeling from event-driven
architecture:

- **Domain-Driven Design** is for business language, subdomains, bounded
  contexts, context maps, aggregates, entities, value objects, and invariants.
- **Event-Driven Architecture** is for CQRS, event sourcing, event stores,
  projections/read models, sagas, delivery reliability, and eventual
  consistency.

This split keeps DDD from implying that event sourcing, sagas, or projections are
required for good domain modeling.

## Included Skills

### Skills Library

| Skill | Version | Description |
| --- | --- | --- |
| Code Review Loop | 0.1.0 | Bounded review-fix-test cycles that rerun code review until changes are clean or a maximum iteration count is reached. |
| Visual Brainstorming | 0.1.0 | Diagram-first brainstorming, product specs, and DDD-oriented architecture planning for repo-backed changes. |

### Domain-Driven Design

| Skill | Version | Description |
| --- | --- | --- |
| Domain-Driven Design | 0.1.0 | Main DDD router and viability gate, enriched with workflow and anti-pattern references. |
| DDD Strategic Design | 0.1.0 | Subdomains, bounded contexts, ubiquitous language, and strategic design artifacts. |
| DDD Context Mapping | 0.1.0 | Bounded context relationships, integration patterns, and contract decisions. |
| DDD Tactical Patterns | 0.1.0 | Entities, value objects, aggregates, repositories, domain services, and invariants. |

### Event-Driven Architecture

| Skill | Version | Description |
| --- | --- | --- |
| Event-Driven Architecture | 0.1.0 | Main event-driven architecture router for event reaction patterns and reliability choices. |
| CQRS Implementation | 0.1.0 | Read/write model separation, CQRS tradeoffs, and read-side synchronization. |
| Event Sourcing Architect | 0.1.0 | Event streams, event-sourced aggregates, replay, versioning, snapshots, and temporal queries. |
| Event Store Design | 0.1.0 | Event persistence, stream naming, append/read APIs, and subscription design. |
| Projection Patterns | 0.1.0 | Read models, materialized views, rebuilds, idempotency, and projection lag. |
| Saga Orchestration | 0.1.0 | Long-running workflows, compensation, choreography/orchestration, retries, and timeouts. |

## Repository Structure

```text
.agents/
  plugins/
    marketplace.json
plugins/
  domain-driven-design/
    .codex-plugin/
      plugin.json
    skills/
      domain-driven-design/
      ddd-context-mapping/
      ddd-strategic-design/
      ddd-tactical-patterns/
  event-driven-architecture/
    .codex-plugin/
      plugin.json
    skills/
      event-driven-architecture/
      cqrs-implementation/
      event-sourcing-architect/
      event-store-design/
      projection-patterns/
      saga-orchestration/
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

After adding the platform, install the desired plugin from Codex. You may need to
start a new conversation or restart Codex before the newly installed skills appear
in the available skills list.

## Validate The Marketplace

Run:

```powershell
.\scripts\validate-marketplace.ps1
```

Expected:

```text
Plugin marketplace validation passed (3 plugins, 12 skills).
```

The validator checks that:

- `.agents/plugins/marketplace.json` parses.
- Every marketplace plugin entry has installation and authentication policy.
- Every plugin entry points to a real `.codex-plugin/plugin.json`.
- Every plugin manifest name matches its folder and marketplace entry.
- The plugin skills directory exists.
- Every skill has a `SKILL.md` whose frontmatter declares the matching skill name.

## Add A Skill

1. Choose the plugin that owns the skill's scope.
2. Create a new folder under `plugins/<plugin-id>/skills/<skill-id>/`.
3. Add `SKILL.md` with frontmatter whose `name` matches `<skill-id>`.
4. Update `plugins/<plugin-id>/.codex-plugin/plugin.json` if the plugin
   description, keywords, or starter prompts should change.
5. Run `.\scripts\validate-marketplace.ps1`.

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
