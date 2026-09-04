from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
ATLAS = ROOT / "mod" / "DragonFantasyCity" / "assets" / "2x" / "Jokers.png"
OUT = ROOT / "screenshots"
CELL = (142, 190)


def card(atlas: Image.Image, index: int) -> Image.Image:
    x = (index % 10) * CELL[0]
    y = (index // 10) * CELL[1]
    return atlas.crop((x, y, x + CELL[0], y + CELL[1]))


def montage(atlas: Image.Image, indices: range, columns: int, path: Path) -> None:
    items = [card(atlas, i) for i in indices]
    rows = (len(items) + columns - 1) // columns
    gap = 14
    margin = 24
    canvas = Image.new(
        "RGBA",
        (margin * 2 + columns * CELL[0] + (columns - 1) * gap,
         margin * 2 + rows * CELL[1] + (rows - 1) * gap),
        (18, 24, 25, 255),
    )
    draw = ImageDraw.Draw(canvas)
    for position, image in enumerate(items):
        x = margin + (position % columns) * (CELL[0] + gap)
        y = margin + (position // columns) * (CELL[1] + gap)
        draw.rounded_rectangle(
            (x - 4, y - 4, x + CELL[0] + 3, y + CELL[1] + 3),
            radius=8,
            fill=(213, 169, 60, 70),
        )
        canvas.alpha_composite(image, (x, y))
    canvas.convert("RGB").save(path, quality=92, optimize=True)


def full_roster(atlas: Image.Image, path: Path) -> None:
    cards = [card(atlas, i) for i in range(46)]
    columns = 8
    rows = (len(cards) + columns - 1) // columns
    gap = 8
    margin = 18
    canvas = Image.new(
        "RGBA",
        (margin * 2 + columns * CELL[0] + (columns - 1) * gap,
         margin * 2 + rows * CELL[1] + (rows - 1) * gap),
        (17, 25, 27, 255),
    )
    for position, image in enumerate(cards):
        row = position // columns
        column = position % columns
        cards_in_row = min(columns, len(cards) - row * columns)
        row_offset = (columns - cards_in_row) * (CELL[0] + gap) // 2
        x = margin + row_offset + column * (CELL[0] + gap)
        y = margin + row * (CELL[1] + gap)
        canvas.alpha_composite(image, (x, y))
    canvas.convert("RGB").save(path, quality=91, optimize=True)


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    with Image.open(ATLAS).convert("RGBA") as atlas_image:
        montage(atlas_image, range(0, 4), 4, OUT / "legendary-showcase.png")
        montage(atlas_image, range(4, 18), 7, OUT / "rare-showcase.png")
        montage(atlas_image, range(18, 46), 7, OUT / "uncommon-showcase.png")
        full_roster(atlas_image, OUT / "full-roster.png")
    print("Built README showcase images in", OUT)

