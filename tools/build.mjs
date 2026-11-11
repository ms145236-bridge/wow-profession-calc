// 組合資料 → data.json，並用 1–300 全程驗證計算結果與原站材料清單一致
import fs from 'fs';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const { calcRoute } = require('./calc.js');
const raw = JSON.parse(fs.readFileSync('raw.json', 'utf8'));
const tw = JSON.parse(fs.readFileSync('tw.json', 'utf8'));
const npc = fs.existsSync('npc.json') ? JSON.parse(fs.readFileSync('npc.json', 'utf8')) : {};
// Wowhead 沒有的 WoW Forever 自訂物品：手動繁中
const manual = { 'i:247786': '魔法微粒', 'i:249431': '翠綠染料', 'i:255716': '簡易藥膏', 'i:255718': '優質藥膏', 'i:255727': '手冊：優質藥膏', 'i:247755': '初級威力藥劑', 'i:254122': '圖樣：土紋外衣', 'i:254121': '土紋外衣', 'i:254020': '圖樣：土靈絲質護腕', 'i:254019': '土靈絲質護腕', 'i:264224': '結構圖：安全型號靈巧炸藥', 'i:260813': '安全型號管子', 'i:260814': '安全型號靈巧炸藥', 'i:255724': '手冊：巧妙藥膏', 'i:255717': '巧妙藥膏', 'i:252890': '圖樣：藍色山羊皮帽', 'i:252482': '藍色山羊皮帽' };
const items = {}; // key -> [twName, quality, icon, custom?]
const reg = (k, id, cn, q, ic) => {
  const key = `${k}:${id}`; if (items[key]) { if (!items[key][2] && ic) items[key][2] = ic; return; }
  const t = tw[key];
  const name = (t && t.tw) || manual[key];
  if (!name) console.error('缺繁中名', key, cn);
  items[key] = [name || cn, q, ic || (t && t.icon) || null, (t && t.tw) ? 0 : 1];
};
const recipeLinks = fs.existsSync('recipelinks.json') ? JSON.parse(fs.readFileSync('recipelinks.json', 'utf8')) : {};
const isRecipe = n => /^(配方|设计图|公式|结构图|图样|食谱|手册)：/.test(n);
const out = { items, vendor: {}, variants: {}, defaultVariant: {} };
const seen = {}; // prof -> key -> variant index
const votes = {}; // prof -> idx -> count
let bad = 0;
for (const [pool, profs] of Object.entries(raw.pools)) {
  for (const [prof, d] of Object.entries(profs)) {
    d.mats.forEach(m => reg(m.k, m.id, m.cn, m.q, m.ic));
    d.steps.forEach(s => { reg(s.k, s.id, s.cn, s.q, s.ic); s.m.forEach(([rid, n]) => reg('i', rid, n, null, null)); });
    const mats = {}; d.mats.forEach(m => mats[m.id] = { p: m.p, v: m.v, qty: m.qty });
    const steps = d.steps.map(s => ({ f: s.f, t: s.t, k: s.k, id: s.id, src: s.src, c: s.c, extra: s.extra, m: s.m.map(([rid, , q]) => [rid, q]), d: s.d }));
    // 配方 → 對應步驟
    const recipes = {}, tools = [];
    const consumed = new Set(); steps.forEach(s => s.m.forEach(([r]) => consumed.add(r)));
    for (const m of d.mats) {
      if (isRecipe(m.cn)) {
        const links = recipeLinks[m.id] || [];
        const twn = (items['i:' + m.id][0] || '').replace(/^[^：]+：/, '');
        const cnn = m.cn.replace(/^[^：]+：/, '');
        const idx = steps.map((s, i) => i).filter(i => links.includes(`${steps[i].k}:${steps[i].id}`) || items[`${steps[i].k}:${steps[i].id}`][0] === twn || d.steps[i].cn === cnn);
        if (!idx.length) { // 名稱不一致時：在非訓練師步驟中找字元最相近的
          const score = n => [...new Set(cnn)].filter(ch => n.includes(ch)).length / Math.max(cnn.length, n.length);
          let best = null, bs = 0.5;
          d.steps.forEach((s, i) => { if (s.src !== '训练师') { const sc = score(s.cn); if (sc > bs) { bs = sc; best = s.id; } } });
          if (best != null) steps.forEach((s, i) => { if (s.id === best) idx.push(i); });
          console.error('配方用相似名稱對應', pool, prof, m.cn, '→', best && d.steps.find(s => s.id === best).cn);
        }
        if (!idx.length) console.error('配方對不到步驟', pool, prof, m.cn);
        recipes[m.id] = idx;
      } else if (!consumed.has(m.id)) tools.push(m.id);
    }
    // 推算產量
    const yields = {};
    const prodSteps = {}; steps.forEach(s => { if (s.k === 'i') (prodSteps[s.id] = prodSteps[s.id] || []).push(s); });
    for (const [id, ss] of Object.entries(prodSteps)) {
      let cons = 0; steps.forEach(s => s.m.forEach(([r, q]) => { if (r == id) cons += q; }));
      if (!cons) continue;
      const bought = mats[id] ? mats[id].qty : 0;
      const crafts = ss.reduce((a, s) => a + s.c, 0);
      const y = Math.round((cons - bought) / crafts);
      if (y > 1) yields[id] = y;
    }
    d.mats.forEach(m => { if (m.v && m.p > 0) out.vendor[m.id] = Math.max(out.vendor[m.id] || 0, m.p); });
    const route = { steps, mats: Object.fromEntries(Object.entries(mats).map(([k, v]) => [k, { p: v.p, v: v.v }])), recipes, tools, yields };
    // 驗證
    const r = calcRoute({ ...route, mats }, 1, 300);
    const got = Object.fromEntries(r.list.map(x => [x.id, x.qty]));
    const diffs = d.mats.filter(m => got[m.id] !== m.qty).map(m => `${m.cn} 原站${m.qty} 算${got[m.id]}`);
    const extra = r.list.filter(x => !mats[x.id]).map(x => `${x.id}多出${x.qty}`);
    if (diffs.length || extra.length) { bad++; if (pool === 'cn.pvp.horde' || bad < 6) console.error('✗', pool, prof, diffs.join('；'), extra.join(' ')); }
    // 去重：同一套步驟只留一份（不保留原站的拍賣行價格）
    const key = JSON.stringify(steps.map(s => [s.f, s.t, s.id, s.c, s.extra, s.m]));
    seen[prof] = seen[prof] || {}; votes[prof] = votes[prof] || {};
    if (!(key in seen[prof])) { (out.variants[prof] = out.variants[prof] || []).push({ steps, recipes, tools, yields }); seen[prof][key] = out.variants[prof].length - 1; }
    const vi = seen[prof][key]; votes[prof][vi] = (votes[prof][vi] || 0) + 1;
  }
}
out.npcs = npc;
for (const [prof, v] of Object.entries(votes)) { out.defaultVariant[prof] = +Object.entries(v).sort((a, b) => b[1] - a[1])[0][0]; console.error(prof, '候選路線', out.variants[prof].length); }
out.fetched = new Date(raw.fetched).toLocaleString('zh-TW',{timeZone:'Asia/Taipei',hour12:false});
console.error('驗證不一致的路線數：', bad);
fs.writeFileSync('data.json', JSON.stringify(out));
console.error('data.json', (fs.statSync('data.json').size / 1024).toFixed(0), 'KB');

const tpl = fs.readFileSync('template.html','utf8');
const html = tpl.replace('/*DATA*/null', () => JSON.stringify(out)).replace('/*CALC*/', () => fs.readFileSync('calc.js','utf8').replace(/if \(typeof module.*/, ''));
fs.writeFileSync(process.argv[2] || 'index.html', html);
console.error('html', (html.length/1024).toFixed(0), 'KB');
