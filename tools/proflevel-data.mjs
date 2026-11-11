// 把網頁（index.html）內建的衝級路線資料轉成插件用的 addon/ProfLevel/Data.lua
// 用法（在 repo 根目錄）：node tools/proflevel-data.mjs
// 更新路線的流程：tools/build.mjs 重建 index.html 之後，再執行這支
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const html = fs.readFileSync(path.join(root, 'index.html'), 'utf8');
const m = html.match(/const DATA = (\{.*?\});\n/s);
if (!m) throw new Error('index.html 裡找不到 DATA');
const D = JSON.parse(m[1]);

const q = v => JSON.stringify(v); // JSON 字串在 Lua 5.1 也合法
const out = [];
out.push('-- 由 tools/proflevel-data.mjs 從 index.html 產生，請勿手改。');
out.push(`-- 路線來源：Kovarel 衝級路線（抓取時間 ${D.fetched}）；物品名稱：Wowhead 繁中（遊戲裡讀得到時用遊戲名稱）`);
out.push('ProfLevel_Data = {');
// 物品：[key] = { 名稱, 品質, 圖示, 是否自訂物品 }
out.push('  items = {');
for (const [k, v] of Object.entries(D.items)) {
  out.push(`    [${q(k)}] = { ${q(v[0])}, ${v[1] == null ? 'nil' : q(v[1])}, ${v[2] == null ? 'nil' : q(v[2])}, ${v[3] ? 'true' : 'false'} },`);
}
out.push('  },');
// 商人固定售價（銅）
out.push('  vendor = { ' + Object.entries(D.vendor).map(([id, p]) => `[${id}] = ${p}`).join(', ') + ' },');
out.push('  npcs = { ' + Object.entries(D.npcs || {}).filter(([, v]) => v).map(([k, v]) => `[${q(k)}] = ${q(v)}`).join(', ') + ' },');
// 每個專業的候選路線
out.push('  variants = {');
for (const [prof, vs] of Object.entries(D.variants)) {
  out.push(`    [${q(prof)}] = {`);
  for (const v of vs) {
    out.push('      {');
    out.push('        steps = {');
    for (const s of v.steps) {
      const mats = s.m.map(([r, n]) => `{ ${r}, ${n} }`).join(', ');
      const diff = (s.d || []).map(x => q(String(x))).join(', ');
      out.push(`          { f = ${s.f}, t = ${s.t}, k = ${q(s.k)}, id = ${s.id}, src = ${q(s.src || '')}, c = ${s.c}, extra = ${s.extra || 0}, m = { ${mats} }, d = { ${diff} } },`);
    }
    out.push('        },');
    // 配方 → 用到它的步驟（網頁是 0 起算，Lua 改 1 起算）
    out.push('        recipes = { ' + Object.entries(v.recipes).map(([r, idx]) => `[${r}] = { ${idx.map(i => i + 1).join(', ')} }`).join(', ') + ' },');
    out.push('        tools = { ' + v.tools.join(', ') + ' },');
    out.push('        yields = { ' + Object.entries(v.yields || {}).map(([id, n]) => `[${id}] = ${n}`).join(', ') + ' },');
    out.push('      },');
  }
  out.push('    },');
}
out.push('  },');
out.push('  defaultVariant = { ' + Object.entries(D.defaultVariant).map(([p, i]) => `[${q(p)}] = ${i + 1}`).join(', ') + ' },');
out.push('}');
const dest = path.join(root, 'addon', 'ProfLevel', 'Data.lua');
fs.mkdirSync(path.dirname(dest), { recursive: true });
fs.writeFileSync(dest, out.join('\n') + '\n');
console.log('寫入', path.relative(root, dest), (fs.statSync(dest).size / 1024).toFixed(0) + ' KB',
  Object.keys(D.variants).length, '個專業', Object.keys(D.items).length, '個物品');
