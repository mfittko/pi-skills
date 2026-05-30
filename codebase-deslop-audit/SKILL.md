---
name: codebase-deslop-audit
description: Run a rigorous full-codebase declutter audit for redundancies, contradictions, stale guidance, needless wrappers, overbuilt architecture, and other accumulated slop. Use when the user wants an honest deletion-first repo audit, a DRY review, a complete file-by-file necessity check, or an assignable cleanup issue.
---

# Codebase Deslop Audit

Run a thorough, deletion-first audit of a repository.

This skill is for situations where the user wants more than a normal review:
- full codebase redundancy analysis
- file-by-file necessity checks
- architectural simplification opportunities
- guidance/docs contradiction detection
- “what should we delete, merge, archive, or demote?”
- an assignable cleanup issue or declutter plan

The goal is not to admire the codebase. The goal is to identify accumulated **slop**:
- duplicated logic
- duplicated guidance
- stale docs
- compatibility seams that no longer earn their keep
- wrappers with no real behavior
- test duplication caused by structural over-splitting
- architecture that is bigger than the core functionality needs

## Operating stance

Be honest and deletion-first.

Prefer these decisions, in order:
1. **delete**
2. **merge**
3. **demote/archive**
4. **keep only if justified**

Do **not** default to “preserve and document”.
Do **not** reward historical layering just because it already exists.
Do **not** confuse “has tests/docs around it” with “is still necessary”.

## When to use this skill

Use this skill when the user asks for any of the following:
- full codebase audit
- redundancy audit
- DRY audit
- slop audit
- declutter plan
- architecture simplification review
- guidance/docs contradiction scan
- assignable cleanup issue
- “go through every file and tell me what is necessary”

## Core rules

### 1. Audit the whole tracked repo unless the user narrows scope

Start from tracked files, not from a guessed subset.

Preferred inventory source:
```bash
git ls-files
```

Group the repo into major areas and make sure every tracked area is covered.
A good default split is:
- root docs and repo contract
- runtime/package/extension/CLI surface
- shared/core package
- GitHub or external integration scripts
- loop/orchestration/viewer surfaces
- root tests and repo hygiene
- skill/package-local internals

### 2. Use subagents to preserve main-context quality

For non-trivial repos, do **not** keep the entire audit in the main agent context.
Use properly briefed subagents with sharply separated scopes.

Preferred pattern:
- one parallel pass per major area
- each subagent gets an explicit file set and explicit audit criteria
- one synthesis pass merges findings
- one final writing pass produces the deliverable issue

Good subagent tasks are area-specific and read-only.
Bad subagent tasks are vague (“review the repo”).

### 3. Treat docs, skills, and markdown as first-class audit targets

Be especially rigorous with:
- `README.md`
- `AGENTS.md`
- workflow docs
- skills
- prompt templates
- phase docs
- contract docs
- internal process docs

Look for:
- contradictions
- multiple files claiming authority over the same rule
- stale commands or old workflow names
- repeated policy text that should have one canonical home
- templates that encode obsolete posture
- docs that are historical artifacts but still look current

### 4. Distinguish four categories clearly

For each file or cluster, decide whether it is primarily:
- **necessary**
- **excessive**
- **mergeable**
- **removable**

Do not hide behind generic language like “could be improved”.
Force a posture.

### 5. Separate high-confidence deletions from decision-gated ones

Two buckets:

#### High confidence now
Safe to delete, merge, or trim based on current evidence.

#### Requires product/contract decision
Needs an explicit decision first because it may still be an intended public surface, compatibility contract, or valuable product boundary.

This prevents timid audits and also prevents reckless deletion.

### 6. Prefer architectural simplification over local tidying

Do not stop at micro-duplication.
Also ask:
- why does this layer exist?
- why are there two boundaries here?
- why does this subsystem have this many moving parts?
- is this module runtime-used or mostly documented/tested into existence?
- is the viewer/tooling surface bigger than the problem it solves?

### 7. Do not mutate code unless the user asked for implementation

This skill is primarily an **audit** skill.
Default to read-only analysis.
If the user wants implementation, produce the plan/issue first, then ask or proceed only if clearly authorized.

## Recommended workflow

### Phase 1 — Inventory and split

1. List tracked files with `git ls-files`.
2. Bucket them into major surfaces.
3. Check for obviously large or suspicious files.
4. Identify special guidance surfaces and generated-artifact pressure points.

Useful commands:
```bash
git ls-files
find . -maxdepth 3 -type f | sort
rg -n "single public workflow entrypoint|acceptance criteria|definition of done|non-goals" .
```

### Phase 2 — Parallel audit fan-out

Launch parallel read-only subagents, one per area.
Each brief should include:
- exact file scope
- what “slop” means for that area
- explicit output sections
- read-only constraint
- requirement to assess necessity, mergeability, and removability

Strong area prompts include language like:
- redundant wrappers
- dead seams
- stale guidance
- contradictions
- overbuilt architecture
- duplicated test coverage
- artifact accumulation and missing hygiene guardrails

### Phase 3 — Synthesis

Merge the area memos into one repo-wide view.
Do **not** concatenate them.
Synthesize across areas:
- repo-wide slop themes
- biggest contradictions
- strongest DRY opportunities
- architectural cleanup opportunities
- prioritized workstreams
- highest-confidence deletion candidates

### Phase 4 — Deliverable

Produce one or both of:

#### A. Full audit
Include:
- executive summary
- coverage section proving the repo was comprehensively audited
- major slop themes
- contradictions/misconceptions
- DRY opportunities
- architectural simplification opportunities
- prioritized workstreams
- high-confidence removals/merges
- acceptance criteria
- definition of done
- non-goals
- validation plan

#### B. Assignable issue
Include:
- title
- summary
- why now
- audit coverage
- scope
- out of scope
- workstreams
- highest-confidence removals/merges
- architectural cleanup opportunities
- acceptance criteria
- definition of done
- risks/guardrails
- validation
- suggested labels
- suggested assignee profile

## Output quality bar

The audit is not done unless it is:
- blunt
- specific
- evidence-backed
- deletion-first
- complete enough to assign

Avoid weak language like:
- “might be nice”
- “could potentially”
- “consider maybe”

Prefer:
- “delete this”
- “merge these”
- “archive this historical doc”
- “this module is over-surfaced relative to runtime adoption”
- “this rule has too many authority sources”

## File-by-file expectations

For major files or file clusters, state one of:
- keep
- keep but trim
- merge into X
- archive
- delete
- decision required first

When possible, explain **why the file exists now** and **why that is or is not still justified**.

## Red flags to actively search for

### Code / runtime
- one-line wrappers
- re-export-only files
- duplicate subprocess helpers
- duplicate CLI arg parsers
- duplicate state interpretation seams
- helpers used by tests/docs more than by runtime
- package exports that exceed real active commitments

### Docs / skills / prompts
- multiple files claiming authority over the same rule
- stale commands and old workflow names
- local-first vs GitHub-first posture drift
- historical docs that still read like current operator guidance
- templates with broken placeholders or duplicated steps
- large copied policy blocks across skills and docs

### Tests / hygiene
- same behavior asserted at core + wrapper + integration layer without clear boundary
- giant catch-all contract tests
- nested dead test harnesses
- generated artifacts accumulating with no cleanup path
- local verification not matching CI expectations

## Suggested artifact paths

For substantial audits, store intermediate artifacts under:
- `tmp/slop-audit/...`

Keep area memos separate, then write final outputs to stable paths such as:
- `areas/*.md`
- `final/*.md`

## Example end state

A strong final answer usually gives the user:
1. a concise verdict on the repo’s main slop patterns
2. the best deletion/merge candidates
3. the biggest architecture simplifications worth doing
4. an assignable issue body

## Bottom line

This skill is for saying the quiet part out loud.

If the repo is bloated, say so.
If the docs contradict each other, say so.
If a subsystem has grown beyond its value, say so.
If the right move is deletion, recommend deletion.
