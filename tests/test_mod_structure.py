import json
import re
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "mod" / "DragonFantasyCity"

meta = json.loads((MOD / "json.json").read_text(encoding="utf-8"))
assert meta["id"] == "dragon_fantasy_city"
assert meta["prefix"] == "DFC"

lua = (MOD / "src" / "jokers.lua").read_text(encoding="utf-8")
spec_block = lua.split("local function e(card)", 1)[0]
keys = re.findall(r"\{\s*'([a-z0-9_]+)'\s*,\s*'", spec_block)
assert len(keys) == 46, (len(keys), keys)
assert len(set(keys)) == 46
assert "if id == 14 then return 11 end" in (MOD / "src" / "util.lua").read_text(encoding="utf-8")
assert "if id >= 11 and id <= 13 then return 10 end" in (MOD / "src" / "util.lua").read_text(encoding="utf-8")

for scale, expected in [(1, (710, 475)), (2, (1420, 950))]:
    atlas = MOD / "assets" / f"{scale}x" / "Jokers.png"
    assert atlas.is_file() and atlas.stat().st_size > 0
    with Image.open(atlas) as image:
        assert image.size == expected, (atlas, image.size)

# The in-game atlas must stay in the original game's brighter, flatter paper range.
with Image.open(MOD / "assets" / "2x" / "Jokers.png").convert("RGBA") as image:
    pixels = [(r, g, b) for r, g, b, a in image.getdata() if a > 0]
    luminance = [(0.2126*r + 0.7152*g + 0.0722*b) / 255 for r, g, b in pixels]
    saturation = []
    for r, g, b in pixels:
        hi, lo = max(r, g, b), min(r, g, b)
        saturation.append(0 if hi == 0 else (hi - lo) / hi)
    mean_luma = sum(luminance) / len(luminance)
    contrast = (sum((v - mean_luma) ** 2 for v in luminance) / len(luminance)) ** 0.5
    mean_sat = sum(saturation) / len(saturation)
    cell_contrasts = []
    for i in range(46):
        x, y = (i % 10) * 142, (i // 10) * 190
        cell = image.crop((x, y, x + 142, y + 190))
        cell_luma = [(0.2126*r + 0.7152*g + 0.0722*b) / 255 for r, g, b, a in cell.getdata() if a > 0]
        cell_mean = sum(cell_luma) / len(cell_luma)
        cell_contrasts.append((sum((v - cell_mean) ** 2 for v in cell_luma) / len(cell_luma)) ** 0.5)
    assert mean_luma >= 0.55
    # Preserve strong local separation without forcing saturated art toward a pale RGB target.
    assert sum(cell_contrasts) / len(cell_contrasts) >= 0.19
    assert sum(v < 0.20 for v in luminance) / len(luminance) <= 0.08
    assert 0.28 <= mean_sat <= 0.48

assert lua.count("SMODS.Joker {") == 1, "Jokers should be registered through the data loop"
assert "rarity=rarity" in lua
assert "loc_txt={name=name,text=text}" in lua

# Silver Walker must never call Card:open directly from reroll_shop; that bypasses
# the normal use-card state transition and can leave an empty, soft-locked pack.
silver = lua.split("function H.silver_walker", 1)[1].split("function H.genghis", 1)[0]
assert ":open(" not in silver and ".open" not in silver
assert "ability.couponed=true" in silver.replace(" ", "")
assert "set_cost()" in silver

# User-reported Great Wall contract: exactly five played cards, regardless of scoring count,
# permanently add +8 chips and pay the accumulated total.
assert "{ 'great_wall', '长城'" in lua and "{ chips = 0 }" in lua
assert "#(context.full_hand or {})==5" in lua
assert "e(card).chips=e(card).chips+8" in lua
assert "return {chips=e(card).chips}" in lua

# Equal-rarity deck contract: one starting Soul consumable and conditional 25% rarity polling.
deck = (MOD / "src" / "deck.lua").read_text(encoding="utf-8")
hooks = (MOD / "src" / "hooks.lua").read_text(encoding="utf-8")
util = (MOD / "src" / "util.lua").read_text(encoding="utf-8")
assert "SMODS.Back" in deck and "dfc_equal_rarities" in deck
assert "consumables={'c_soul'}" in deck.replace(" ", "")
assert "set='Joker',rarity=4" not in deck.replace(" ", "")
assert "灵魂" in deck
assert "SMODS.poll_rarity" in hooks

# Smaug counts every negative dollar spend, including purchases whose UI state
# changes before Card:open deducts money.
smaug_hook = hooks.split("local ease_dollars_ref", 1)[1].split("local add_to_deck_ref", 1)[0]
assert "mod and mod < 0" in smaug_hook
assert "G.STATE == G.STATES.SHOP" not in smaug_hook

# Gorn's Steel Red-Seal King must enter the current hand through SMODS.add_card,
# so other mods receive the standard playing-card-added flow.
gorn_add = util.split("function DFC.add_steel_king", 1)[1].split("function DFC.copy_to_area", 1)[0]
assert "area = G.hand" in gorn_add
assert "area = G.deck" not in gorn_add
assert "playing_card_joker_effects({c})" in gorn_add.replace(" ", "")

# Balance contract from playtest feedback.
assert "每累计主动花费 {C:money}$7{}" in lua
assert "math.floor(e.spent / 7)" in hooks
assert "e.spent - steps * 7" in hooks
assert "永久获得 {C:mult}+1{} 倍率" in lua
chinese = lua.split("function H.chinese_dragon", 1)[1].split("function H.captain_cook", 1)[0]
assert "e(card).mult = e(card).mult + 1" in chinese

# Equal Fortune rarity distribution: Common 60%, Uncommon 24%, Rare 13%, Legendary 3%.
rarity_hook = hooks.split("function SMODS.poll_rarity", 1)[1]
assert "roll < 0.60" in rarity_hook
assert "roll < 0.84" in rarity_hook
assert "roll < 0.97" in rarity_hook
assert "return 4" in rarity_hook
assert "60%" in deck and "24%" in deck and "13%" in deck and "3%" in deck

# Equal Fortune deck penalty starts exactly at the third selected blind.
assert "context.setting_blind" in deck
assert "dfc_blinds_started" in deck
assert ">= 3" in deck
assert "round_resets.hands" in deck and "round_resets.discards" in deck
for scale, expected in [(1, (71, 95)), (2, (142, 190))]:
    with Image.open(MOD / "assets" / f"{scale}x" / "Decks.png") as image:
        assert image.size == expected

# Public documentation must cover every shipped Joker in both languages and
# remain portable rather than leaking a developer-machine path.
readme = (ROOT / "README.md").read_text(encoding="utf-8")
guide_zh = (ROOT / "docs" / "CARD_GUIDE.zh-CN.md").read_text(encoding="utf-8")
guide_en = (ROOT / "docs" / "CARD_GUIDE.en.md").read_text(encoding="utf-8")
assert "Dragon Fantasy City: Forged by Fate" in readme
assert len(re.findall(r"^\|\s*\d+\s*\|", guide_zh, re.MULTILINE)) == 46
assert len(re.findall(r"^\|\s*\d+\s*\|", guide_en, re.MULTILINE)) == 46
for public_doc in (readme, guide_zh, guide_en):
    assert "C:\\Users\\" not in public_doc
for preview in ("full-roster.png", "legendary-showcase.png", "rare-showcase.png", "uncommon-showcase.png"):
    assert (ROOT / "screenshots" / preview).is_file()

print("OK: 46 unique Jokers, metadata, rank rules, and 1x/2x atlases verified")

