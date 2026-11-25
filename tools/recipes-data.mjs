// 從 wago.tools 抓 WoW Forever（wowf）遊戲檔的配方表，產生 addon/ShengProfession/Recipes.lua
// 用法：node tools/recipes-data.mjs [版本號]（不給就用 wowf 最新版）
import fs from 'fs';

const PROF = { 171: 'alchemy', 164: 'blacksmithing', 333: 'enchanting', 202: 'engineering', 165: 'leatherworking',
  197: 'tailoring', 185: 'cooking', 129: 'first-aid', 186: 'mining' };
const build = process.argv[2] || (await (await fetch('https://wago.tools/api/builds')).json()).wowf[0].version;

async function table(name) {
  const r = await fetch(`https://wago.tools/db2/${name}/csv?build=${build}`);
  if (!r.ok) throw new Error(`${name}: HTTP ${r.status}`);
  const [head, ...rows] = (await r.text()).trim().split(/\r?\n/);
  const keys = head.split(',');
  // 這三張表用到的欄位都是數字，沒有引號逗號
  return rows.map(line => Object.fromEntries(line.split(',').map((v, i) => [keys[i], v])));
}

const [abilities, reagents, effects] = await Promise.all(['SkillLineAbility', 'SpellReagents', 'SpellEffect'].map(table));
const mats = new Map(reagents.map(r => [r.SpellID, [0, 1, 2, 3, 4, 5, 6, 7]
  .filter(i => r[`Reagent_${i}`] !== '0').map(i => [+r[`Reagent_${i}`], +r[`ReagentCount_${i}`]])]));
const made = new Map();
for (const e of effects.filter(e => e.Effect === '24' && e.DifficultyID === '0').sort((a, b) => a.EffectIndex - b.EffectIndex))
  if (!made.has(e.SpellID)) made.set(e.SpellID, [+e.EffectItemType, Math.max(1, Math.round(+e.EffectBasePointsF))]);

const out = new Map();
for (const a of abilities) {
  const prof = PROF[a.SkillLine], m = mats.get(a.Spell);
  if (!prof || !m || m.length === 0 || out.has(+a.Spell)) continue;
  const [item, n] = made.get(a.Spell) || [0, 1];
  out.set(+a.Spell, [prof, item, n, m]);
}
const lines = [...out].sort((a, b) => a[0] - b[0])
  .map(([id, [prof, item, n, m]]) => `  [${id}] = { "${prof}", ${item}, ${n}, ${m.flat().join(', ')} },`);
fs.writeFileSync(new URL('../addon/ShengProfession/Recipes.lua', import.meta.url),
  `-- 由 tools/recipes-data.mjs 從 wago.tools 的 WoW Forever ${build} 遊戲檔產生，請勿手改。\n` +
  `-- [法術] = { 專業, 產物（0＝附魔這類沒有產物）, 一次做幾個, 材料, 數量, 材料, 數量 ... }\n` +
  `ShengProfession_RecipesBuild = "${build}"\nShengProfession_Recipes = {\n${lines.join('\n')}\n}\n`);
console.log(`wowf ${build}: ${out.size} 個配方`);
