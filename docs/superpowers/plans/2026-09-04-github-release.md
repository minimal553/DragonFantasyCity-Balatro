# Dragon Fantasy City GitHub Release Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a clean bilingual repository and downloadable v0.1.3 release for Dragon Fantasy City.

**Architecture:** Keep the installable mod isolated under `mod/DragonFantasyCity`, while the repository root provides documentation, accepted source art, deterministic asset tools, validation, and generated marketing previews. Exclude rejected/local artifacts with `.gitignore` and ship a release archive containing only the runtime folder.

**Tech Stack:** Lua, Steamodded, Python/Pillow, Markdown, GitHub Actions, GitHub Releases.

---

### Task 1: Curate public documentation

**Files:** `README.md`, `docs/CARD_GUIDE.zh-CN.md`, `docs/CARD_GUIDE.en.md`, `docs/DESIGN_NOTES.md`, `CHANGELOG.md`

- [ ] Write a bilingual landing page with an honest playtest status and clear download path.
- [ ] Document all 46 cards from the authoritative Lua specifications.
- [ ] Explain rarity hierarchy, combo axes, visual language, balance rules, and verification limits.

### Task 2: Build public previews and repository safeguards

**Files:** `tools/build_showcase.py`, `screenshots/*.png`, `.gitignore`, `.github/workflows/validate.yml`, `.github/ISSUE_TEMPLATE/bug_report.yml`

- [ ] Generate deterministic montages directly from the shipped 2x atlas.
- [ ] Exclude rejected concepts, local references, intermediate artifacts, logs, and release archives.
- [ ] Add CI validation and a structured bilingual bug report form.

### Task 3: Verify and package v0.1.3

**Files:** `release/DragonFantasyCity-v0.1.3.zip`

- [ ] Run `python tools/build_showcase.py`.
- [ ] Run `python tests/test_mod_structure.py` and require an OK result.
- [ ] Zip only `mod/DragonFantasyCity` with the install folder at the archive root.
- [ ] Inspect archive paths and ensure no local/development files are included.

### Task 4: Publish and verify

- [ ] Initialize git with a Lore-format initial commit.
- [ ] Create public repository `minimal553/DragonFantasyCity-Balatro`.
- [ ] Push `main`, set the repository description and topics, and create release `v0.1.3` with the ZIP asset.
- [ ] Open the public repository and release URLs and verify README rendering and asset availability.

