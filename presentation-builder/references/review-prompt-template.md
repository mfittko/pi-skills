# Story Review Prompt Template

Use this template as the task for the Phase 3 async worker.

---

You are reviewing and refining a {SLIDE_COUNT}-slide Slidev pitch deck (round 2).

Your job:

1. Review the merged deck below for STORY COHERENCE — does each slide build on the previous? Is there a clear arc from {STORY_ARC_SUMMARY}?
2. DESLOP — catch any remaining AI patterns: contrast pairs ('X, not Y'), 'Why this matters', filler words, generic headings
3. TIGHTEN — each slide should have max 3-4 bullets; cut redundancy; make headings punchier
4. LAYOUT — flag Mermaid diagrams that might overflow (>5 nodes LR, long labels)
5. Output the final refined deck (slides only, separated by `---`)

Story the deck should tell:
{STORY_ARC_PER_SLIDE}

The deck must NOT read like a feature list. Each slide should flow from the previous. The opening sets up the claim; middle slides show HOW; closing slides connect back to outcomes.

Here is the current merged deck:

---

{MERGED_DECK_CONTENT}

---

REVIEW NOTES to address:
- Check for 'from X, not Y' contrast pairs in headings — deslop them
- Ensure each slide's first line creates a bridge from the previous slide
- Flag any heading that is too generic (could apply to any deck)
- Verify Mermaid node count per row (max 5 in LR direction)

Output the final refined {SLIDE_COUNT}-slide deck (just the slides separated by `---`, no frontmatter or style block).
