// 衝級和佇列會跟商人買的東西（材料、配方／圖樣）：從 QuestieDB（Forever）查哪些商人賣、在哪裡，產生 addon/ShengProfession/RecipeVendors.lua
// 用法：node tools/recipe-vendors.mjs（讀練等插件 repo 的 QuestieDB 讀取器與遊戲裡裝的 QuestieDB）
import fs from 'fs';
import { openQuestieDB } from 'file:///F:/Codex/wow-leveling-guide/tools/questiedb.mjs';

const lua = fs.readFileSync(new URL('../addon/ShengProfession/Data.lua', import.meta.url), 'utf8');
const vendorSold = [...lua.match(/^ {2}vendor = \{(.*)\},$/m)[1].matchAll(/\[(\d+)\]/g)].map(m => +m[1]);

const db = openQuestieDB();
const q = s => JSON.stringify(s);
const lines = [];
const missing = [];
for (const id of vendorSold.sort((a, b) => a - b)) {
  const at = (db.field('Item', id, 14) || []).flatMap(nid => {
    const n = db.npc(nid), side = db.field('Npc', nid, 13);
    if (!n || !n.spawns.length || !side) return [];
    const s = n.spawns[0];
    return [`{ ${q(side)}, ${q(n.zhTW || n.en)}, ${q(n.en)}, ${s.map}, ${s.x}, ${s.y} }`];
  });
  if (!at.length) { missing.push(`${id} ${db.field('Item', id, 1)}`); continue; }
  lines.push(`  [${id}] = { ${at.join(', ')} }, -- ${db.field('Item', id, 1)}`);
}
fs.writeFileSync(new URL('../addon/ShengProfession/RecipeVendors.lua', import.meta.url),
  `-- 由 tools/recipe-vendors.mjs 從 QuestieDB（WoW Forever）產生，請勿手改。\n` +
  `-- [物品] = { { 陣營（A/H/AH）, 名字, 英文名字, uiMapID, x, y（0–100）}, ... }：賣這個東西的商人\n` +
  `ShengProfession_RecipeVendors = {\n${lines.join('\n')}\n}\n`);
console.log(`${lines.length} 個物品有商人位置；沒有：${missing.join('、') || '無'}`);
