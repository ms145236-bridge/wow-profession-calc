// 直接把 hotfix.mjs 套到現有的 index.html（沒有 raw.json 時用）
import fs from 'fs';
import { applyHotfix } from './hotfix.mjs';
const file = process.argv[2] || '../index.html';
const s = fs.readFileSync(file, 'utf8');
const m = s.match(/const DATA = (\{.*?\});\n/s);
const D = JSON.parse(m[1]);
let n = 0;
for (const [prof, vs] of Object.entries(D.variants)) vs.forEach(v => { n += applyHotfix(prof, v.steps); });
fs.writeFileSync(file, s.replace(m[1], () => JSON.stringify(D)));
console.error('修正材料', n, '處');
