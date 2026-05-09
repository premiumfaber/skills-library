# Skills Marketplace Design

## Summary
Create a small, repository-backed skills marketplace for Codex and Claude Code. The first published skill will be an adapted `Visual Brainstorming` skill. The repository will use a shared skill directory as the source of truth, plus a `marketplace.json` registry that records metadata, paths, versions, tags, and compatibility with both tools.

The adapted `Visual Brainstorming` skill must add an architecture-planning stage after the product/business spec is reviewed and before the detailed implementation plan begins. The spec answers what should be built and why; the architecture plan answers how the work should be shaped at the module, bounded-context, interface, domain-model, and data-model level; the detailed implementation plan then turns the approved architecture into concrete tasks, files, tests, commands, and commits.

The MVP is intentionally file-based: users browse the repository, inspect the registry, and copy or install skill folders through their own local tooling. Installer scripts, a web catalog, and full schema validation can come later after the registry shape has proven useful.

## Non-Goals
- Build a web marketplace UI.
- Build an automatic installer.
- Publish packages to an external registry.
- Add CI or a formal JSON Schema in the first release.
- Split Codex and Claude Code into separate skill source trees.

## Visual Model

### System Overview
```mermaid
flowchart TD
    Repo["skills-library repository"] --> Registry["marketplace.json"]
    Repo --> Skills["skills/"]
    Skills --> VisualBrainstorming["skills/visual-brainstorming/SKILL.md"]

    Registry --> CodexTarget["Codex compatibility metadata"]
    Registry --> ClaudeTarget["Claude Code compatibility metadata"]

    VisualBrainstorming --> SharedContent["Shared skill content"]
    SharedContent --> CodexTarget
    SharedContent --> ClaudeTarget
```

### Main Flow
```mermaid
sequenceDiagram
    participant Maintainer
    participant Repo as skills-library
    participant Registry as marketplace.json
    participant User
    participant Tool as Codex / Claude Code

    Maintainer->>Repo: Add skill folder
    Maintainer->>Registry: Add registry entry
    Maintainer->>Repo: Document install guidance
    User->>Repo: Browse available skills
    User->>Tool: Install or copy selected skill
    Tool->>Repo: Read SKILL.md and metadata
    Tool-->>User: Skill is available locally
```

### Visual Brainstorming Flow
```mermaid
flowchart TD
    A["Explore project context"] --> B["Brainstorm business goal, user flow, and visible data"]
    B --> C["Write diagram-first product spec"]
    C --> D["User reviews and approves spec"]
    D --> E["Write visual architecture plan"]
    E --> F["User reviews and approves architecture"]
    F --> G["Create detailed implementation plan"]
```

### Architecture Plan Model
```mermaid
flowchart TD
    ArchitecturePlan["Architecture Plan"] --> Modules["Modules"]
    ArchitecturePlan --> Contexts["Bounded contexts"]
    ArchitecturePlan --> Interfaces["Interfaces / contracts"]
    ArchitecturePlan --> DomainModels["Domain models"]
    ArchitecturePlan --> DataModels["Data models"]
    ArchitecturePlan --> ComponentModel["UI/component hierarchy when relevant"]

    Modules --> Existing["Existing modules to modify"]
    Modules --> New["New modules to introduce"]
    Interfaces --> Inputs["Inputs"]
    Interfaces --> Outputs["Outputs"]
    Interfaces --> Ownership["Owning context"]
```

### Registry Model
```mermaid
flowchart LR
    Marketplace["marketplace.json"] --> Skill["skill entry"]
    Skill --> Identity["id, name, version, description"]
    Skill --> Location["path, entrypoint"]
    Skill --> Targets["targets"]
    Targets --> Codex["codex.compatible"]
    Targets --> Claude["claudeCode.compatible"]
    Skill --> Discovery["tags"]
```

### Implementation Sequence
```mermaid
flowchart TD
    A["Create marketplace registry"] --> B["Add Visual Brainstorming skill folder"]
    B --> C["Adapt skill with visual architecture planning stage"]
    C --> D["Update README with purpose and install guidance"]
    D --> E["Validate JSON syntax"]
    E --> F["Verify registry path points to SKILL.md"]
```

## Requirements
- The repository must contain a top-level `marketplace.json`.
- `marketplace.json` must use `schemaVersion: 1`.
- `marketplace.json` must include a `visual-brainstorming` skill entry.
- Each skill entry must include `id`, `name`, `version`, `description`, `path`, `entrypoint`, `targets`, and `tags`.
- `targets.codex.compatible` and `targets.claudeCode.compatible` must both be present for the first skill.
- The first skill must live at `skills/visual-brainstorming/SKILL.md`.
- The first skill must include an `Architecture Plan` stage after spec review and before the detailed implementation plan.
- After the architecture plan is approved, the skill must transition to `superpowers:writing-plans` for a detailed implementation plan.
- The architecture stage must focus on module boundaries, bounded contexts, interfaces/contracts, domain models, and data models.
- For existing systems, the architecture stage must describe only the new or modified modules, contexts, interfaces, and models that matter for the requested change.
- The architecture stage must be visual by default, using Mermaid diagrams for module breakdowns, context maps, interface relationships, data models, flows, and UI/component hierarchy when relevant.
- The skill must keep the product/business spec focused on goal, user flow, visible client/user data, requirements, and behavior rather than low-level implementation mechanics.
- `README.md` must explain the marketplace purpose, the first skill, the file-based install model, and how to add future skills.
- The MVP must be understandable without custom tooling.

## Design Decisions

### Shared Source Tree
Use one shared `skills/` tree rather than separate Codex and Claude Code copies. This keeps the first marketplace small and prevents divergence between equivalent skill content.

### Single Registry File
Use a single top-level `marketplace.json` as the first registry format. Per-tool adapter files are deferred until either Codex or Claude Code needs metadata that does not fit the shared model.

### File-Based Installation
Start with repository/file-based installation. A user can clone the repository or copy `skills/visual-brainstorming` into their local skills directory. This avoids designing an installer before the registry format is validated by real use.

### Version 0.1.0 For First Skill
Publish `Visual Brainstorming` as `0.1.0` because this repository is a new distribution channel even though the source skill already exists elsewhere.

### Architecture Planning Between Spec And Plan
Adapt `Visual Brainstorming` so the workflow does not jump directly from approved spec to detailed implementation planning. Insert an `Architecture Plan` stage that turns the agreed product/business intent into a technical shape before detailed tasks are written.

The architecture plan is not the detailed implementation plan. It should define boundaries and contracts: modules, bounded contexts, interfaces, domain concepts, data models, and UI/component hierarchy when applicable. It should also state which existing parts are modified and which new parts are introduced.

After the user approves the architecture plan, the workflow must invoke `superpowers:writing-plans` to create the detailed implementation plan. That plan owns task sequencing, file-level changes, tests, verification commands, checkpoints, and commits.

### DDD-Oriented Visuals
Use DDD-oriented language and diagrams where useful: bounded contexts, context relationships, aggregates/entities/value objects when needed, service boundaries, public interfaces, and data ownership. Mermaid should be the default notation. For UI/component work, include a component hierarchy or interaction diagram instead of only prose.

## Error Handling
- If `marketplace.json` is invalid JSON, the release is not ready.
- If a registry `path` or `entrypoint` points to a missing file, the release is not ready.
- If a target is omitted, readers should treat compatibility as unknown rather than compatible.
- If Codex and Claude Code later need different packaging behavior, add explicit adapter metadata instead of duplicating the skill content.
- If an architecture plan would duplicate the detailed implementation plan, narrow it back to boundaries, contracts, models, and diagrams.
- If a requested change is tiny and architecture would add no clarity, the skill may include a short `Architecture Plan Omitted` note explaining why.

## Testing Strategy
- Parse `marketplace.json` with a standard JSON parser.
- Check that every skill entry resolves to an existing `SKILL.md`.
- Manually inspect `README.md` for install instructions and future-skill contribution guidance.
- Manually inspect `skills/visual-brainstorming/SKILL.md` to confirm it has the expected skill frontmatter and body.
- Manually inspect `skills/visual-brainstorming/SKILL.md` to confirm it inserts architecture planning after spec review and before detailed implementation planning.
- Use at least one skill pressure prompt during implementation review where a user asks for a feature and the expected behavior is: product spec first, visual architecture plan second, detailed implementation plan third.

## MVP Deliverables
- `marketplace.json`
- `skills/visual-brainstorming/SKILL.md`, adapted with visual architecture planning
- Updated `README.md`
- Basic validation through JSON parsing and path existence checks
