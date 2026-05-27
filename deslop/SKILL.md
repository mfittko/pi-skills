---
name: deslop
description: Remove AI writing patterns from prose and presentations. Use when writing, editing, reviewing, or scrubbing any text — articles, memos, decks, issues, PRs, scientific writing — to eliminate predictable AI tells, slop, and formulaic patterns. Trigger on "deslop", "de-AI", "make it sound human", "remove AI patterns", "scrub this deck", "tighten slides", or any request for natural-sounding prose.
---

# Deslop

Strip predictable AI patterns from writing. Make prose sound like a specific human wrote it. Works for general prose (articles, memos, reports, scientific writing) and presentation-specific content (slides, headlines, bullets, Mermaid labels).

## When to Apply

- Any request to "make it sound human", "deslop", or "remove AI patterns"
- Writing or editing prose, decks, issues, PRs, memos, blog posts, newsletters
- Reviewing text for AI tells
- Scrubbing slide decks for stronger headlines and shorter bullets
- Scientific writing (manuscripts, abstracts, cover letters, grant narratives)

## Core Rules

### 1. Cut filler phrases

Remove throat-clearing openers, emphasis crutches, business jargon, generic signpost headings, and meta-commentary. If a heading could fit almost any memo, blog post, or deck, replace it with a specific claim or cut it.

See [references/phrases.md](references/phrases.md) for the full catalog.

### 2. Break formulaic structures

State the point directly instead of:
- Binary contrasts ("Not X. Y." / "X, not Y" / "This is X, not just Y")
- Negation-by-contrast ("X can do A. It can't do B." / "X lowers A. It does not lower B.")
- Negative listings ("Not a X. Not a Y. A Z.")
- Dramatic fragmentation ("Speed. That's it. That's the tradeoff.")
- Self-posed rhetorical questions ("The result? Devastating.")
- Balanced concession-then-pivot ("Either answer is workable. The ambiguity is the problem.")

See [references/structures.md](references/structures.md) for patterns and fixes.

### 3. Eliminate AI tropes

Watch for: "quietly" and magic adverbs, "delve" and cousins, the "serves as" dodge, false ranges, superficial participle analyses, invented concept labels, grandiose stakes inflation, patronizing analogies, and false vulnerability.

See [references/tropes.md](references/tropes.md) for the complete list.

### 4. Use active voice with human subjects

Prefer active constructions with named actors. "The complaint becomes a fix" is wrong. "The team fixed it" is right. If no specific person fits, use "we" in scientific prose or "you" in blog posts.

### 5. Be specific

No vague declaratives ("The reasons are structural"). Name the specific thing. No lazy extremes doing vague work. No vague attributions. Domain terminology is fine; business buzzwords and AI vocabulary tells are not.

### 6. Match register to context

Blog/newsletter: put the reader in the room. Scientific: maintain appropriate formality, use "we" for your own work, cite specific authors.

### 7. Vary rhythm

Mix sentence lengths. Two items beat three. End paragraphs differently. No em dashes. Do not stack short punchy fragments for manufactured emphasis.

### 8. Trust readers

State facts directly. Skip softening, justification, hand-holding. No fractal summaries.

### 9. Watch formatting tells

No bold-first bullets. No unicode arrows. No em dashes. No signposted conclusions. No generic explainer headings.

### 10. Do not dilute

One point per section. Do not restate the same argument in ten different ways.

## Presentation Mode

When scrubbing decks or slides, apply these additional rules:

### Headlines

- Prefer 2-6 word headings
- Headlines carry the point, not announce a topic
- Replace generic section titles with specific claims
- If the heading could apply to any deck, it's too generic

### Bullets

- Max 3-4 per slide
- Avoid full-sentence bullets unless necessary
- One idea per bullet
- No bullets that repeat the title

### Labels

- Shorten labels before resizing fonts or visuals
- Mermaid node labels: 1-2 words max
- Pill/chip text: keep compact

### Layout

- Two-column layouts when a slide has two natural buckets
- Cut paragraphy setup lines
- Cut repeated thesis restatements

### Quick deck scan

```
- Can each slide title stand on its own?
- Are any bullets explaining the title again?
- Are any Mermaid labels too long for their container?
- Are there paired slides that should use two columns?
- Are there generic section titles that should become claims?
```

## Quick Checks (all prose)

Run these before delivering:

- Heavy adverbs or -ly words? Cut them.
- Passive voice? Find the actor.
- Inanimate thing doing a human verb? Name the person.
- "Here's what/this/that" throat-clearing? Cut.
- "Not X, it's Y" contrasts? State Y directly.
- Softer version of contrast ("X can do A. It can't do B.")? Direct claim.
- Self-posed rhetorical question answered immediately? Fold into statement.
- Three consecutive sentences same length? Break one.
- Em dash anywhere? Remove.
- Generic headings ("Why this matters")? Replace with specific claim.
- Same metaphor used more than twice? Cut repeats.
- Bold-first bullet pattern? Remove bold leads.
- Tricolon (three-item list)? Use two items or one.

## Scoring (when reviewing)

| Dimension | Question |
|-----------|----------|
| Directness | Statements or announcements? |
| Rhythm | Varied or metronomic? |
| Trust | Respects reader intelligence? |
| Authenticity | Sounds like a specific human wrote it? |
| Density | Anything cuttable? |

Below 35/50: revise.

## Working Style

1. Identify the worst recurring pattern first.
2. Fix the pattern globally, not one sentence at a time.
3. Prefer deletion over soft rewriting.
4. If the text still sounds templated, run another pass.
5. For decks, regenerate artifacts after wording changes.

## Reference Files

- [references/phrases.md](references/phrases.md): Phrases to remove or replace
- [references/structures.md](references/structures.md): Structural patterns to avoid
- [references/tropes.md](references/tropes.md): AI writing tropes catalog
- [references/examples.md](references/examples.md): Before/after transformations
- [references/presentation-patterns.md](references/presentation-patterns.md): Deck-specific smells and fixes
