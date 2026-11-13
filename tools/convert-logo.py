# 把 LOGO 原圖轉成插件用的圖：去掉圓外的白底、裁成圓形
# 用法（在 repo 根目錄）：python tools/convert-logo.py [原圖路徑]
# 沒給路徑就用 addon/ShengHealing/Media/LogoSource.png
# 輸出：addon/ShengHealing/Media/Logo.tga（64×64，遊戲用）、Logo256.png（預覽用）
import os
import sys
from PIL import Image, ImageDraw

root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
media = os.path.join(root, 'addon', 'ShengHealing', 'Media')
src_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(media, 'LogoSource.png')
im = Image.open(src_path).convert('RGBA')

# 找出不是白底的範圍（圓形 LOGO 本體）
W, H = im.size
px = im.load()
xs, ys = [], []
for y in range(0, H, 2):
    for x in range(0, W, 2):
        r, g, b, a = px[x, y]
        if a > 0 and max(r, g, b) - min(r, g, b) > 60:  # 有顏色的才算（白底、灰色雜點不算）
            xs.append(x); ys.append(y)
xs.sort(); ys.sort()
k = len(xs) // 500  # 去掉最外圍 0.2% 的零星點
x0, x1, y0, y1 = xs[k], xs[-1 - k], ys[k], ys[-1 - k]
cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
rad = max(x1 - x0, y1 - y0) / 2
side = int(rad * 2) + 2
box = (int(cx - side / 2), int(cy - side / 2), int(cx - side / 2) + side, int(cy - side / 2) + side)
crop = im.crop(box)

# 圓形遮罩（往內縮一點，去掉邊緣的白色殘邊）；放大畫再縮小，邊緣才平滑
SS = 4
mask = Image.new('L', (side * SS, side * SS), 0)
inset = side * 0.012
ImageDraw.Draw(mask).ellipse([inset * SS, inset * SS, (side - inset) * SS, (side - inset) * SS], fill=255)
mask = mask.resize((side, side), Image.LANCZOS)
crop.putalpha(mask)

if src_path != os.path.join(media, 'LogoSource.png'):
    im.save(os.path.join(media, 'LogoSource.png'))  # 保留原圖，之後可以重新轉
crop.resize((256, 256), Image.LANCZOS).save(os.path.join(media, 'Logo256.png'))
crop.resize((64, 64), Image.LANCZOS).save(os.path.join(media, 'Logo.tga'), compression=None, orientation=-1)  # 左下角原點
print('circle center', (round(cx), round(cy)), 'radius', round(rad), '->', media)
