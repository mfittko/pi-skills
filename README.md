# skills

Reusable [Pi](https://github.com/earendil-works/pi-coding-agent) agent skills.

## Requirements

### presentation-builder

| Dependency | Purpose |
|-----------|---------|
| [pi-subagents](https://www.npmjs.com/package/pi-subagents) extension | Parallel variant generation and review passes via async workers |
| [Slidev](https://sli.dev) (`@slidev/cli`) | Deck rendering and dev server |
| [Playwright](https://playwright.dev) (`playwright-chromium`) | Automated screenshot capture for visual review |
| Node.js 20+ | Runtime for Slidev and capture scripts |

Install the pi-subagents extension:
```bash
pi extensions add pi-subagents
```

Install deck tooling in your project (or use the template `package.json`):
```bash
npm install -D @slidev/cli @slidev/theme-default playwright-chromium
npx playwright install chromium
```

### deslop

No external dependencies. Works with any Pi session. The skill is self-contained — load it for any writing, editing, or review task.

## Skills

### presentation-builder

Create polished Slidev pitch decks using a parallel-variant chain workflow:

1. **Briefing** — structured context from codebase/user input
2. **Variant generation** — 3 variants per slide via async worker, pick/combine best
3. **Story review** — coherence + deslop + tightening pass
4. **Assembly** — dark glass-card theme, Slidev frontmatter
5. **Visual review** — Playwright screenshots, fix overflow/spacing

See [presentation-builder/SKILL.md](presentation-builder/SKILL.md) for the full workflow.

### deslop

Remove AI writing patterns from prose and presentations. Combined general prose deslop (articles, memos, scientific writing) with presentation-specific rules (headlines, bullets, labels, layout).

Triggers: "deslop", "de-AI", "make it sound human", "remove AI patterns", "scrub this deck", "tighten slides"

See [deslop/SKILL.md](deslop/SKILL.md) for rules and references.

## Usage

### As global Pi skills

```bash
# Clone to your skills directory
git clone https://github.com/mfittko/skills.git ~/.pi/agent/skills-repo

# Or symlink individual skills
ln -s /path/to/skills/presentation-builder ~/.pi/agent/skills/presentation-builder
ln -s /path/to/skills/deslop ~/.pi/agent/skills/deslop
```

### As project-local skills

```bash
# In your project
mkdir -p .pi/skills
cp -r /path/to/skills/presentation-builder .pi/skills/
cp -r /path/to/skills/deslop .pi/skills/
```

## Skill interaction

The `presentation-builder` skill references `deslop` rules during Phase 2 (variant generation) and Phase 3 (story review). Both skills can be loaded simultaneously — the presentation-builder will apply deslop constraints automatically when generating and reviewing slide content.
