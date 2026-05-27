# Visual Review Checklist

Use this checklist when inspecting Playwright screenshots in Phase 5.

## Per-slide checks

- [ ] All content within viewport (nothing cut off at bottom)
- [ ] Mermaid diagram fully visible (no nodes cut off at right edge)
- [ ] Glass-card borders render consistently
- [ ] Heading has adequate spacing from content below (~1rem gap)
- [ ] Kicker label visible and properly above heading
- [ ] Pills/chips render inline without wrapping awkwardly
- [ ] Text is readable (sufficient contrast against dark background)
- [ ] Grid columns balanced (no single column much taller)

## Common problems and fixes

### Mermaid overflow (nodes cut off right)
- Reduce to ≤5 nodes in `direction LR`
- Shorten node labels (e.g. `waiting_for_copilot_review` → `waiting`)
- Decrease scale: `{scale: 0.6}` or lower
- Switch to `direction TB` if horizontal doesn't work

### Content overflow (below viewport)
- Reduce bullets (max 3-4 per card)
- Remove one card from the grid
- Move verbose content to a mini-list
- Split into two slides if genuinely too much content

### Heading too close to content
- Add `margin-bottom` to `.slidev-layout h2` in style.css
- Typically 1rem is sufficient

### Pill/chip wrapping
- Shorten pill text
- Use fewer pills
- Ensure `chip-row` has `flex-wrap: wrap` and `gap: 0.65rem`

### Glass-card not visible
- Ensure style.css is loaded via frontmatter `css: ./style.css`
- Check that card classes match exactly (`glass-card`, not `glass_card`)
- Verify `border` and `background` CSS rules are present

## Full-deck coherence (after all slides pass)

- [ ] Consistent kicker style across all slides (uppercase, same color)
- [ ] Consistent grid layout pattern (don't mix grid styles randomly)
- [ ] Gradient background renders on every slide (check slide 1 and last)
- [ ] Overall vertical rhythm feels balanced (similar content density per slide)
