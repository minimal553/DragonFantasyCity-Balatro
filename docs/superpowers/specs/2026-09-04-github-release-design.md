# Dragon Fantasy City GitHub Release Design

## Goal

Publish a clean, attractive, bilingual GitHub repository for the playable v0.1.3 build without leaking rejected art, local logs, saves, or machine-specific files.

## Public positioning

- Repository: `minimal553/DragonFantasyCity-Balatro`
- Display title: **龙与奇幻城：命运铸牌 / Dragon Fantasy City: Forged by Fate**
- Promise: 46 original build-around Jokers, one risk-reward deck, a coherent rarity-based visual system, and Simplified Chinese-first gameplay.
- Honesty boundary: call v0.1.3 a playable public test build, not exhaustively bug-free.

## Repository contents

- Installable mod under `mod/DragonFantasyCity/`.
- High-resolution accepted source art under `assets/final/`.
- Build and validation tools under `tools/` and `tests/`.
- Bilingual landing page, full Chinese/English card guides, design notes, changelog, issue template, CI validation, and generated showcase images.
- Release asset containing only the installable `DragonFantasyCity` folder.

## Exclusions

Rejected concepts, local reference extractions, intermediate grades, logs, saves, editor state, and release archives are excluded from git history.

## Verification

Run the mod structure test, rebuild showcase images, inspect archive contents, initialize a clean git history, publish the repository and release, then verify the public repository and asset URL.

