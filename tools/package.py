# 打包插件成 CurseForge 用的 zip：dist/<資料夾>-<版本>.zip，zip 裡最上層就是插件資料夾
# 用法：python tools/package.py            （打包全部）
#       python tools/package.py HealHPS    （只打包一個）
import fnmatch, os, re, sys, zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAMES = sys.argv[1:] or ['HealHPS', 'ProfLevel']
EXCLUDE = ['LogoSource.png', '*.bak', '.DS_Store']  # 開發用檔案不放進發行檔

os.makedirs(os.path.join(ROOT, 'dist'), exist_ok=True)
for n in NAMES:
    src = os.path.join(ROOT, 'addon', n)
    toc = open(os.path.join(src, n + '.toc'), encoding='utf-8').read()
    ver = re.search(r'^## Version:\s*(\S+)', toc, re.M).group(1)
    out = os.path.join(ROOT, 'dist', f'{n}-{ver}.zip')
    with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
        for d, _, files in os.walk(src):
            for f in sorted(files):
                if any(fnmatch.fnmatch(f, p) for p in EXCLUDE):
                    continue
                full = os.path.join(d, f)
                z.write(full, n + '/' + os.path.relpath(full, src).replace(os.sep, '/'))
    print(out, f'{os.path.getsize(out) // 1024} KB')
