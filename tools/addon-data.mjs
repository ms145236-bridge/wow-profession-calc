// 把網頁的 healer-data.js 轉成插件用的 addon/BridgeHealing/Data.lua
// 用法（在 repo 根目錄）：node tools/addon-data.mjs
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const src = fs.readFileSync(path.join(root, 'healer-data.js'), 'utf8');
const { SPELLS } = new Function(src + ';return { SPELLS };')();

// 遊戲內對應：ids＝用來向遊戲查「本地化名稱」的法術 ID（查不到就用 names），
// names＝繁中客戶端名稱（含常見別名），parse＝怎麼從技能說明讀基礎量。
//   range：「恢復 A 至 B 點」；hot：「總計 N 點」；absorb：「吸收 N 點」；tick：「每 X 秒恢復 N 點，持續 Y 秒」；
//   single：「治療 N 點」；regrowth：直接 A 至 B ＋「額外的 N 點」；null：不讀，用資料表。
const GAME = {
  hl:    { ids: [635],   names: ['聖光術'],               parse: 'range' },
  fol:   { ids: [19750], names: ['聖光閃現'],             parse: 'range' },
  hs:    { ids: [1311606, 20473], names: ['神聖震擊'],             parse: 'range' },
  vigil: { ids: [1310911], names: ['聖光戒備', '聖光守望'],             parse: null },
  lh:    { ids: [2050],  names: ['次級治療術'],           parse: 'range' },
  heal:  { ids: [2054],  names: ['治療術'],               parse: 'range' },
  fh:    { ids: [2061],  names: ['快速治療'],             parse: 'range' },
  gh:    { ids: [2060],  names: ['強效治療術'],           parse: 'range' },
  renew: { ids: [139],   names: ['恢復'],                 parse: 'hot' },
  pws:   { ids: [17],    names: ['真言術：盾'],           parse: 'absorb' },
  poh:   { ids: [596],   names: ['治療禱言'],             parse: 'range' },
  bh:    { ids: [32546], names: ['束縛治療'],             parse: 'range' },
  pen:   { ids: [402174, 47540], names: ['懺悟', '苦修'],         parse: null },
  pom:   { ids: [33076], names: ['癒合禱言', '愈合禱言'], parse: 'single' },
  hn:    { ids: [15237], names: ['神聖新星'],             parse: 'range' },
  ht:    { ids: [5185],  names: ['治療之觸'],             parse: 'range' },
  rejuv: { ids: [774],   names: ['回春術'],               parse: 'hot' },
  rg:    { ids: [8936],  names: ['癒合', '愈合'],         parse: 'range' },
  rgh:   { ids: [8936],  names: ['癒合', '愈合'],         parse: 'regrowth', fallback: 'rg' },
  tranq: { ids: [740],   names: ['寧靜'],                 parse: 'tick' },
  wg:    { ids: [48438], names: ['野性痊癒', '野性成長'], parse: null },
  hw:    { ids: [331],   names: ['治療波'],               parse: 'range' },
  lhw:   { ids: [8004],  names: ['次級治療波'],           parse: 'range' },
  ch:    { ids: [1064],  names: ['治療鍊', '治療鏈'],     parse: 'range' },
  ript:  { ids: [61295], names: ['激流'],                 parse: null },
};
const CLASS = { paladin_holy: 'PALADIN', priest_holy: 'PRIEST', priest_disc: 'PRIEST', druid_resto: 'DRUID', shaman_resto: 'SHAMAN' };
const LABEL = { rg: '癒合（不含HoT）', rgh: '癒合', vigil: '聖光戒備→震擊', hn: '神聖新星（治療）', pen: '懺悟', pom: '癒合禱言', wg: '野性痊癒', ch: '治療鍊' };

const fam = new Map();
for (const s of SPELLS) {
  if (!GAME[s.id]) throw new Error('缺少遊戲對應設定：' + s.id);
  if (!fam.has(s.id)) fam.set(s.id, { key: s.id, label: LABEL[s.id] || s.name, cls: CLASS[s.specs[0]], kind: s.kind, group: s.group,
    groupModel: s.groupModel, maxTargets: s.maxTargets, talent: s.talent, healPct: s.healPctApplies, absorbPct: s.absorbPctApplies,
    gcd: s.gcd, note: '', ranks: {} });
  const f = fam.get(s.id);
  if (!f.note && s.note) f.note = s.note;
  f.ranks[s.rank] = { learn: s.learnLevel, mana: s.mana, cast: s.cast, cd: s.cd, min: s.healMin, max: s.healMax, coeff: s.coeff,
    dur: s.duration, hotBase: s.hotBase, hotCoeff: s.hotCoeff, rel: s.reliability };
}

const q = v => JSON.stringify(v); // JSON 字串在 Lua 5.1 也合法（只有 \" \\ 跳脫，中文原樣輸出）
const val = v => v === undefined || v === null ? 'nil' : typeof v === 'string' ? q(v) : typeof v === 'boolean' ? String(v) : String(v);
let out = `-- 由 tools/addon-data.mjs 從 healer-data.js 產生，請勿手改。\n-- 資料主源：ForeverChanges 1.60.1.70790（核對 2026-11-06），永恆 DB2 1.60.1.70938 全面複核 2026-11-13\nHealHPS_Data = { families = {\n`;
for (const f of fam.values()) {
  const g = GAME[f.key];
  out += `  { key = ${q(f.key)}, label = ${q(f.label)}, class = ${q(f.cls)}, kind = ${q(f.kind)}, group = ${f.group}, groupModel = ${q(f.groupModel)}, maxTargets = ${f.maxTargets},\n`;
  out += `    talent = ${f.talent}, healPct = ${f.healPct}, absorbPct = ${f.absorbPct}, gcd = ${f.gcd}, parse = ${val(g.parse)}, fallback = ${val(g.fallback)}, note = ${q(f.note)},\n`;
  out += `    ids = { ${g.ids.join(', ')} }, names = { ${g.names.map(q).join(', ')} },\n    ranks = {\n`;
  for (const [r, d] of Object.entries(f.ranks)) {
    out += `      [${r}] = { learn = ${d.learn}, mana = ${d.mana}, cast = ${d.cast}, cd = ${d.cd}, min = ${d.min}, max = ${d.max}, coeff = ${d.coeff}, dur = ${val(d.dur)}, hotBase = ${val(d.hotBase)}, hotCoeff = ${val(d.hotCoeff)}, rel = ${q(d.rel)} },\n`;
  }
  out += `    } },\n`;
}
out += `} }\n`;
const dest = path.join(root, 'addon', 'BridgeHealing', 'Data.lua');
fs.mkdirSync(path.dirname(dest), { recursive: true });
fs.writeFileSync(dest, out);
console.log('寫入', path.relative(root, dest), fam.size, '個技能');
