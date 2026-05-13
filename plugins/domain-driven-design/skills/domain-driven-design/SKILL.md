---
name: domain-driven-design
description: Plan and route focused Domain-Driven Design work. Use when designing complex business domains, deciding whether DDD is warranted, identifying subdomains, defining bounded contexts, building a ubiquitous language, context mapping, choosing modular monolith vs microservices from domain boundaries, or applying tactical DDD patterns such as aggregates, entities, value objects, repositories, domain services, and domain events.
---

# Domain-Driven Design

Use this as the front door for DDD work. Keep the scope focused: DDD is about aligning software boundaries and models with business reality. CQRS, event sourcing, projections, and sagas are adjacent architectural options, not proof that DDD is being done well.

## Core Workflow

1. Run the viability check before recommending full DDD.
2. Discover the problem space: business capabilities, subdomains, domain experts, events, terminology.
3. Define bounded contexts where language, ownership, rules, or data models diverge.
4. Map context relationships and integration contracts.
5. Choose architecture from the domain boundaries: modular monolith first unless deployment, scaling, or team ownership justify services.
6. Apply tactical patterns only where domain complexity warrants them.

For a step-by-step process, open `references/joaquim-workflow.md`. For deliverable templates, open `references/ddd-deliverables.md`.

## Viability Gate

Recommend full DDD only when at least two are true:

- Business rules are complex, nuanced, or fast-changing.
- Multiple teams or departments use conflicting language for shared concepts.
- The system is long-lived and represents competitive advantage.
- Domain experts or strong product proxies are available.
- Explicit invariants, auditability, or context boundaries matter.

Push back when the task is simple CRUD, a short-lived internal tool, mostly technical integration, or a domain with no expert access. Use simpler architecture and ordinary transaction scripts for supporting and generic subdomains.

## Routing

- Strategic model, subdomains, ubiquitous language, and bounded contexts: `@ddd-strategic-design`
- Context relationships, upstream/downstream roles, ACLs, published language, and integration contracts: `@ddd-context-mapping`
- Aggregates, entities, value objects, repositories, domain services, invariants, and domain events inside a model: `@ddd-tactical-patterns`

If the user asks for CQRS, event sourcing, event stores, projections, or sagas, switch to the `event-driven-architecture` plugin. Mention the relationship to DDD, but do not imply those patterns are required for DDD.

## Reference Selection

The Joaquim reference files include some Java/Spring examples because they came from a Spring Boot DDD skill. Treat those as examples of the pattern, not as required technology choices; translate framework-specific advice to the user's current stack.

- Read `references/joaquim-strategic-patterns.md` for subdomains, event storming, context maps, and strategic heuristics.
- Read `references/joaquim-tactical-patterns.md` for entities, value objects, aggregates, repositories, and services.
- Read `references/joaquim-architecture-alignment.md` for clean/hexagonal architecture, modular monoliths, and microservices decisions.
- Read `references/joaquim-anti-patterns.md` when reviewing an existing design for DDD pitfalls.
- Read `references/joaquim-examples.md` for scenario walkthroughs.
- Read `references/joaquim-troubleshooting.md` when a user reports an anemic model, god aggregate, unclear boundaries, or repository misuse.

## Output

Always provide:

- Scope and assumptions
- DDD viability verdict
- Current stage: discovery, strategic design, context mapping, architecture selection, or tactical modeling
- Artifacts produced or missing
- Recommended next step and the skill to use next

## Guardrails

- Strategic before tactical.
- Ubiquitous language before class names.
- Bounded contexts before service boundaries.
- Prefer value objects by default; use entities only when identity matters.
- Keep aggregates small and centered on true invariants.
- Do not use DDD terminology to justify needless complexity.

