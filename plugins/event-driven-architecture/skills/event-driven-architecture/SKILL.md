---
name: event-driven-architecture
description: Plan and route event-driven architecture work. Use when designing systems around events, asynchronous messaging, CQRS, event sourcing, event stores, projections/read models, sagas, process managers, eventual consistency, outbox/inbox reliability, or event-driven microservices.
---

# Event-Driven Architecture

Use this as the front door for event-driven systems. Start by deciding whether events solve a real coordination, audit, scalability, or integration problem. Event-driven architecture pairs well with DDD, but it is not required by DDD.

## Core Workflow

1. Clarify why events are needed: integration, audit trail, decoupling, scale, long-running workflow, or read optimization.
2. Decide the event style: domain events, integration events, notification events, event-carried state transfer, or event-sourced facts.
3. Choose the reaction pattern: handler, policy, projection, choreography, saga orchestration, or process manager.
4. Design delivery reliability: outbox, inbox/idempotent consumers, retries, dead letters, correlation IDs, and observability.
5. Define consistency expectations and user-visible behavior during delays.
6. Validate rebuild, replay, versioning, and operational recovery paths.

## Routing

- Read/write separation and read-side optimization: `@cqrs-implementation`
- Event history as source of truth, stream modeling, versioning, snapshots, and replay: `@event-sourcing-architect`
- Event persistence, append/read APIs, stream naming, subscriptions, and storage technology choices: `@event-store-design`
- Read models, materialized views, projection rebuilds, idempotency, lag, and query models: `@projection-patterns`
- Long-running workflows, distributed transactions, compensations, timeouts, and orchestration/choreography tradeoffs: `@saga-orchestration`

## Pattern Selection

- Use a simple event handler for isolated side effects.
- Use a policy when one event should trigger a business decision and command.
- Use projections when queries need precomputed read models.
- Use choreography when multiple autonomous components can react without one owner of the full process.
- Use saga orchestration when the workflow is stateful, multi-step, has compensations, or needs timeout handling.
- Use event sourcing only when the event log itself is valuable as the source of truth, not just because events are fashionable.

## DDD Relationship

DDD can help name events, define aggregate boundaries, and separate bounded contexts. Keep DDD concerns in the `domain-driven-design` plugin:

- Strategic and tactical domain modeling belongs there.
- Event delivery, projections, event stores, and sagas belong here.

## Output

Always provide:

- Why events are justified or why a simpler approach is better
- Selected event and reaction patterns
- Consistency model and failure handling
- Reliability mechanisms: outbox, inbox, idempotency, retries, dead letters
- Operational risks: replay, versioning, lag, observability
- Next skill to use

