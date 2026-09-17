---
name: harness
description: Run a staged, spec-first workflow with isolated Pi subagents, external progress state, deterministic checks, and a final parallel review. Use for multi-task feature work.
---

# Staged Pi workflow

Use this workflow only when the task is large enough to benefit from explicit stages. Do not impose it on one-file fixes.

## Sources of truth

- The project specification defines what to build.
- Feature rules define constraints and take precedence over the specification when they conflict.
- `plans/pi-harness/progress.json` stores the current phase, short completed summaries, unresolved questions, and final review status.
- `plans/pi-harness/stages.json` stores the task list, acceptance conditions, referenced specification/rule paths, and one-line notes for the next task.
- Keep the JSON files local and ignored. Do not copy settled decisions into them; write settled specification to the specification and settled invariants to the rules.

Read the active stage only. Do not load the full specification, all completed stages, or all review output into every worker context.

## Preparation phase

Before implementation:

1. Read the relevant specification and rules.
2. Compare the user's request with those sources.
3. Record blocking ambiguities as questions and resolve them before task decomposition.
4. Split the work into the smallest independently verifiable tasks.
5. Give each task explicit acceptance conditions and exact source paths.

Do not start implementation while a blocking interpretation question remains unresolved.

## Repeating task phase

For each stage:

1. Update `progress.json` and `stages.json` to identify the active task.
2. Run one `worker` subagent for that task only. The subagent must use a fresh, sessionless Pi process.
3. Inspect the worker's first test and output for acceptance-condition drift.
4. Run the project's deterministic completion check from the main session, not through a reviewer agent.
5. If the check fails, give the failure to a fresh worker for repair. Stop after three failed attempts and report the blocker.
6. Record a one-line result and the next-task note, then continue.

Prefer TDD for non-trivial logic. Do not create commits or branches automatically; repository policy requires explicit user approval for those operations.

Use the project's documented check command. In this repository that command is `mise run check`; in other repositories use the repository's own check script when available.

## Final review phase

Only after all stages pass, run these four agents in one parallel subagent call:

- `reviewer-spec`
- `reviewer-concurrency`
- `reviewer-security`
- `reviewer-completeness`

The main session deduplicates findings, keeps unresolved findings when evidence is inconclusive, updates `progress.json`, and reports the result for human approval. Reviewers are read-only and must not fix their own findings.

Use the active model by default. Select a different configured model only when the task explicitly requires it and the model is available in the current Pi installation.
