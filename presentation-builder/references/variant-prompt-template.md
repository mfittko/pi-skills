# Variant Generation Prompt Template

Use this template as the task for the Phase 2 async worker. Replace placeholders with actual briefing content.

---

You are writing a {SLIDE_COUNT}-slide Slidev pitch deck. For each slide, produce 3 short variants (A, B, C), then pick the best or combine into a final version.

Here is the full briefing:

{BRIEFING_CONTENT}

## Visual structure (Slidev HTML)

Use these CSS classes for layout:
- `glass-card`: rounded card with border, padding, backdrop blur
- `diagram-card`: card specifically for Mermaid diagrams (less padding)
- `kicker`: uppercase blue label above heading
- `pill`: rounded chip/tag
- `chip-row`: flex row of pills
- `tight-list`: compact bullet list
- `mini-list`: compact list for secondary panels
- `section-lead`: subtitle paragraph below heading
- `hero-card`: large card for slide 1
- `hero-copy`: subtitle text on slide 1
- Grid layouts: `grid grid-cols-2 gap-5 items-start` or `grid grid-cols-3 gap-5 items-start`

## Constraints

- No AI slop: no contrast pairs ('X, not Y'), no 'Why this matters', no filler
- Keep headings concrete and active
- Mermaid diagrams max 5 nodes per row in `direction LR`, use `{scale: 0.6}` to `{scale: 0.72}`
- Each slide: one heading (h2 for inner slides), one optional kicker, 3-4 bullets max
- Slide 1 uses h1 in a hero-card

## Output format

For each slide, write:

```
## Slide N — [role]
### Variant A
(full Slidev HTML)
### Variant B
(full Slidev HTML)
### Variant C
(full Slidev HTML)
### Final
(the chosen/combined version)
```

Then at the end, output the full merged deck under `## MERGED DECK` — all {SLIDE_COUNT} final slides separated by `---` (no frontmatter, no style block — those will be added separately).
