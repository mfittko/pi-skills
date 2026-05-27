---
name: presentation-builder
description: Create polished Slidev pitch decks using a parallel-variant chain workflow. Generates a contextual briefing, fans out 3 variants per slide, picks/combines the best, runs story-coherence and deslop review passes, and validates layout with Playwright screenshots. Use when the user asks to create a slide deck, presentation, pitch deck, or wants the parallel-loop deck creation process.
allowed-tools: bash write read edit subagent web_search fetch_content
---

# Presentation Builder

Create polished Slidev pitch decks through a deterministic multi-pass workflow. Each pass uses parallel subagents for variant generation, followed by review and visual validation.

## When to Apply

- User asks to create a slide deck, presentation, or pitch deck
- User asks for the "parallel loop chain" deck creation process
- User mentions "deck builder" or "presentation builder"
- User wants a Slidev-based presentation on any topic
- User says "build a deck about X"

## Workflow Overview

The workflow has 5 phases, each producing artifacts under `tmp/deck-build/`:

```
Phase 1: Briefing        → tmp/deck-build/briefing.md
Phase 2: Variant gen      → tmp/deck-build/variants.md  (3 per slide)
Phase 3: Story review     → tmp/deck-build/reviewed.md  (coherence + deslop)
Phase 4: Assembly         → docs/<deck-name>.md + docs/style.css
Phase 5: Visual review    → tmp/deck-build/screenshots/*.png (Playwright)
```

## Phase 1: Briefing

Before generating anything, build a structured briefing document. This is the single source of truth for all variant generators.

### Briefing template

```markdown
# Deck Briefing

## Purpose
[One sentence: what this deck argues or explains]

## Audience
[Who will see this, what they already know]

## Story arc (N slides)
1. [Slide role] — [what this slide establishes]
2. ...

## Visual structure
[CSS classes available, layout patterns, grid options]

## Constraints
- [Deslop rules]
- [Max bullets per slide]
- [Mermaid limits]
- [Technical terms to reference]

## Key terms / codebase references
- [Term]: [definition or module path]
```

### Briefing sources

Build the briefing from:
- User's stated goal and audience
- Codebase inspection (if technical deck): read relevant modules, extract constants, state names, function signatures
- Existing decks in the repo (if iterating)
- The `presentation-deslop` skill constraints

## Phase 2: Variant Generation (Parallel)

Launch a single async worker that generates 3 variants (A, B, C) per slide, then picks/combines the best into a final version per slide.

### Task prompt structure

The task prompt must include:
1. The full briefing from Phase 1
2. The slide structure constraints (CSS classes, layouts)
3. Output format specification:

```
For each slide:
## Slide N — [role]
### Variant A
(full Slidev HTML)
### Variant B
(full Slidev HTML)
### Variant C
(full Slidev HTML)
### Final
(chosen/combined version)

Then: ## MERGED DECK (all finals joined by ---)
```

### Variant generation principles

- Each variant should take a different angle on the same slide role
- Variant A: concise, maximum information density
- Variant B: narrative, strongest flow from previous slide
- Variant C: visual, diagram-first or chip/pill-heavy layout
- Final: combine the best elements across variants

## Phase 3: Story Coherence Review (Parallel)

Launch a second async worker that reviews the merged deck for:

1. **Story coherence** — does each slide build on the previous? Clear arc?
2. **Deslop** — catch AI patterns: contrast pairs, "Why this matters", filler
3. **Tightening** — max 3-4 bullets per slide, cut redundancy, punchier headings
4. **Layout** — flag potential overflow (Mermaid too wide, too many nodes LR)

### Review prompt must include:
- The merged deck from Phase 2
- The intended story arc (from briefing)
- Specific deslop patterns to catch
- Instruction to output the refined deck (slides only, separated by `---`)

## Phase 4: Assembly

Assemble the final deck file:

1. Add Slidev frontmatter (from template)
2. Combine refined slides
3. Ensure `docs/style.css` exists with the standard glass-card theme
4. Write to `docs/<deck-name>.md`

### Frontmatter template

```yaml
---
theme: default
colorSchema: dark
title: "<title>"
info: <one-line description>
class: text-left
transition: slide-left
mdc: true
css: ./style.css
---
```

## Phase 5: Visual Review (Playwright)

Start Slidev, capture screenshots of every slide, and visually inspect for:
- Mermaid overflow (nodes cut off at right edge)
- Text overflow (content below viewport)
- Spacing issues (heading too close to content)
- Glass-card rendering (borders visible, consistent)

### Capture workflow

```bash
# Start Slidev
npx slidev docs/<deck>.md --port 3031 --open false --log warn &
sleep 7

# Capture all slides
node tmp/deck-build/capture-slides.mjs
```

### Fix loop

If visual issues are found:
1. Identify the problem (overflow, spacing, etc.)
2. Fix in the deck markdown or CSS
3. Re-capture the affected slide(s)
4. Verify fix renders correctly

Common fixes:
- Mermaid overflow → reduce nodes, use shorter labels, decrease scale, or switch `direction LR` to `direction TB`
- Content overflow → reduce bullets, split into two columns
- Spacing → adjust CSS margins (h2 margin-bottom, kicker margin, card padding)

## CSS Theme

The skill includes a standard dark glass-card theme. Copy from the template if `docs/style.css` doesn't exist:

See [templates/style.css](templates/style.css)

### Available CSS classes

| Class | Purpose |
|-------|---------|
| `hero-card` | Large card for title slide |
| `hero-copy` | Subtitle text on title slide |
| `glass-card` | Rounded card with border, backdrop blur |
| `diagram-card` | Card for Mermaid diagrams (less padding) |
| `kicker` | Uppercase blue label above heading |
| `pill` | Rounded chip/tag |
| `chip-row` | Flex row of pills |
| `tight-list` | Compact bullet list |
| `mini-list` | Compact list for secondary panels |
| `section-lead` | Subtitle paragraph below heading |
| `metric-card` | Accented card for metrics |

### Layout patterns

```html
<!-- Two-column -->
<div class="grid grid-cols-2 gap-5 items-start">
  <div class="glass-card">...</div>
  <div class="glass-card">...</div>
</div>

<!-- Three-column (for metrics/impact) -->
<div class="grid grid-cols-3 gap-5 items-start">
  <div class="glass-card">...</div>
  <div class="glass-card">...</div>
  <div class="glass-card">...</div>
</div>

<!-- Diagram + text -->
<div class="grid grid-cols-2 gap-5 items-start">
  <div class="glass-card"><ul class="tight-list">...</ul></div>
  <div class="diagram-card">```mermaid...```</div>
</div>
```

### Mermaid constraints

- Max 5 nodes in `direction LR` before overflow risk
- Use `{scale: 0.6}` to `{scale: 0.72}` for fit
- Prefer short node labels (1-2 words)
- If >5 nodes needed LR, switch to `direction TB` or reduce the graph

## Slide Structure Rules

Each slide (except slide 1) follows this pattern:

```html
<p class="kicker">CATEGORY</p>

## Heading (concrete, active, specific)

<div class="grid grid-cols-2 gap-5 items-start">
<div class="glass-card">
<ul class="tight-list">
  <li>Bullet 1 (max 3-4 per card)</li>
  <li>Bullet 2</li>
  <li>Bullet 3</li>
</ul>
</div>
<div class="glass-card">
  <!-- Second panel: pills, mini-list, or diagram -->
</div>
</div>
```

Slide 1 uses:

```html
<div class="hero-card">
  <p class="kicker">label</p>
  <h1>Main Title</h1>
  <p class="hero-copy">Subtitle text.</p>
</div>
```

## Deslop Integration

Apply these rules throughout all phases:
- No contrast pairs ("X, not Y" or "This is X, not just Y")
- No "Why this matters" or generic framing headings
- No filler ("In this section", "Let's explore")
- Headings should be concrete claims or actions, not labels
- Each bullet carries one idea; no compound sentences
- Prefer code/module references over abstract descriptions

## Iteration

After the initial build, the user may request:
- **Content changes**: add/remove/reorder slides → re-run Phase 3-5
- **Another review pass**: run Phase 3 again with new focus
- **Layout fixes**: run Phase 5 fix loop
- **Full rebuild**: re-run from Phase 2 with updated briefing

For subsequent iterations, maintain the briefing as the source of truth. Update it first, then re-run downstream phases.

## Example Invocation

```
User: "Build a deck about how our conductor routing works"

→ Phase 1: Read conductor-routing.mjs, build briefing
→ Phase 2: Generate 3 variants × N slides via async worker
→ Phase 3: Story coherence review via async worker  
→ Phase 4: Assemble docs/conductor-routing-presentation.md
→ Phase 5: Start Slidev, capture screenshots, verify layout
→ Show user the screenshots, ask for feedback
```
