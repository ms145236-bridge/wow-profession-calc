# 產生插件 LOGO：打開的古書＋上方的治療聖光十字，金色圓環外框
# 用法（在 repo 根目錄）：python tools/make-logo.py
# 輸出：addon/HealHPS/Media/Logo.tga（64×64，遊戲用）、Logo256.png（預覽用）
import math
import os
from PIL import Image, ImageDraw, ImageFilter

S = 1024  # 先畫大圖再縮小，邊緣才平滑
C = S // 2
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
out_dir = os.path.join(root, 'addon', 'HealHPS', 'Media')
os.makedirs(out_dir, exist_ok=True)

img = Image.new('RGBA', (S, S), (0, 0, 0, 0))

# 背景：由中心往外變暗的深藍綠圓
bg = Image.new('RGBA', (S, S), (0, 0, 0, 0))
px = bg.load()
R = int(S * 0.47)
for y in range(S):
    for x in range(S):
        d = math.hypot(x - C, y - C * 0.92)
        if math.hypot(x - C, y - C) <= R:
            t = min(1.0, d / R)
            px[x, y] = (int(24 - 14 * t), int(44 - 28 * t), int(52 - 34 * t), 255)
img = Image.alpha_composite(img, bg)

# 聖光：十字後面的金色光暈與放射光
glow = Image.new('RGBA', (S, S), (0, 0, 0, 0))
g = ImageDraw.Draw(glow)
cx, cy = C, int(S * 0.36)
for i in range(12):
    a = i * math.pi / 6 + math.pi / 12
    w = 0.07
    p1 = (cx + math.cos(a - w) * 60, cy + math.sin(a - w) * 60)
    p2 = (cx + math.cos(a) * 330, cy + math.sin(a) * 330)
    p3 = (cx + math.cos(a + w) * 60, cy + math.sin(a + w) * 60)
    g.polygon([p1, p2, p3], fill=(255, 214, 120, 70))
g.ellipse([cx - 190, cy - 190, cx + 190, cy + 190], fill=(255, 200, 90, 110))
glow = glow.filter(ImageFilter.GaussianBlur(40))
img = Image.alpha_composite(img, glow)

# 打開的書
book = Image.new('RGBA', (S, S), (0, 0, 0, 0))
b = ImageDraw.Draw(book)
spine_top, spine_bot = (C, int(S * 0.60)), (C, int(S * 0.82))
L = [spine_top, (int(S * 0.17), int(S * 0.53)), (int(S * 0.17), int(S * 0.76)), spine_bot]
Rp = [spine_top, (int(S * 0.83), int(S * 0.53)), (int(S * 0.83), int(S * 0.76)), spine_bot]
# 書殼（深紅皮革）稍微大一圈
def grow(poly, dx, dy):
    return [(x + (dx if x < C else -dx if x > C else 0), y + dy) for x, y in poly]
b.polygon(grow([(C, int(S * 0.62)), (int(S * 0.14), int(S * 0.555)), (int(S * 0.14), int(S * 0.79)), (C, int(S * 0.855))], 0, 0), fill=(110, 30, 26, 255))
b.polygon(grow([(C, int(S * 0.62)), (int(S * 0.86), int(S * 0.555)), (int(S * 0.86), int(S * 0.79)), (C, int(S * 0.855))], 0, 0), fill=(110, 30, 26, 255))
b.polygon(L, fill=(244, 228, 186, 255), outline=(176, 136, 70, 255))
b.polygon(Rp, fill=(236, 218, 172, 255), outline=(176, 136, 70, 255))
# 書頁上的文字線
for k in range(4):
    t = 0.2 + k * 0.17
    for side in (-1, 1):
        x0 = C + side * int(S * 0.06)
        x1 = C + side * int(S * 0.28)
        y0 = int(S * (0.62 + t * 0.14)) - int(abs(x0 - C) * 0.18)
        y1 = int(S * (0.62 + t * 0.14)) - int(abs(x1 - C) * 0.18)
        b.line([(x0, y0), (x1, y1)], fill=(176, 140, 84, 255), width=10)
b.line([spine_top, spine_bot], fill=(140, 98, 44, 255), width=12)
img = Image.alpha_composite(img, book)

# 聖光十字
cross = Image.new('RGBA', (S, S), (0, 0, 0, 0))
c = ImageDraw.Draw(cross)
arm, half = 150, 46
c.rounded_rectangle([cx - half, cy - arm, cx + half, cy + arm], radius=22, fill=(255, 236, 170, 255))
c.rounded_rectangle([cx - arm, cy - half, cx + arm, cy + half], radius=22, fill=(255, 236, 170, 255))
inner = Image.new('RGBA', (S, S), (0, 0, 0, 0))
i2 = ImageDraw.Draw(inner)
i2.rounded_rectangle([cx - 20, cy - arm + 26, cx + 20, cy + arm - 26], radius=14, fill=(255, 255, 245, 255))
i2.rounded_rectangle([cx - arm + 26, cy - 20, cx + arm - 26, cy + 20], radius=14, fill=(255, 255, 245, 255))
cross = Image.alpha_composite(cross, inner.filter(ImageFilter.GaussianBlur(6)))
img = Image.alpha_composite(img, cross)

# 金色圓環外框
ring = Image.new('RGBA', (S, S), (0, 0, 0, 0))
r = ImageDraw.Draw(ring)
r.ellipse([C - R, C - R, C + R, C + R], outline=(120, 86, 30, 255), width=44)
r.ellipse([C - R + 8, C - R + 8, C + R - 8, C + R - 8], outline=(222, 178, 86, 255), width=24)
img = Image.alpha_composite(img, ring)

# 圓外全部透明
mask = Image.new('L', (S, S), 0)
ImageDraw.Draw(mask).ellipse([C - R - 2, C - R - 2, C + R + 2, C + R + 2], fill=255)
img.putalpha(Image.composite(img.getchannel('A'), Image.new('L', (S, S), 0), mask))

img.resize((256, 256), Image.LANCZOS).save(os.path.join(out_dir, 'Logo256.png'))
img.resize((64, 64), Image.LANCZOS).save(os.path.join(out_dir, 'Logo.tga'), compression=None, orientation=-1)  # 左下角原點（Pillow：-1＝左下），遊戲最穩
print('wrote', out_dir)
