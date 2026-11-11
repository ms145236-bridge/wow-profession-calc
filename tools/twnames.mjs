// 從 Wowhead 繁中（zh-TW）抓官方物品/法術名稱，輸出 tw.json
import fs from 'fs';
const raw = JSON.parse(fs.readFileSync('raw.json', 'utf8'));
const want = new Map(); // key "i:123" -> cn name
for (const pool of Object.values(raw.pools)) for (const prof of Object.values(pool)) {
  for (const m of prof.mats) want.set(`${m.k}:${m.id}`, m.cn);
  for (const s of prof.steps) { want.set(`${s.k}:${s.id}`, s.cn); for (const [rid, n] of s.m) want.set(`i:${rid}`, n); }
}
const old = fs.existsSync('tw.json') ? JSON.parse(fs.readFileSync('tw.json', 'utf8')) : {};
const out = { ...old };
const sleep = ms => new Promise(r => setTimeout(r, ms));
const envs = ['https://nether.wowhead.com/classic/tw/tooltip', 'https://nether.wowhead.com/tw/tooltip'];
for (const [key, cn] of want) {
  if (out[key] && out[key].tw) continue;
  const [k, id] = key.split(':');
  let got = null;
  for (const base of envs) {
    try {
      const r = await fetch(`${base}/${k === 's' ? 'spell' : 'item'}/${id}`, { headers: { 'User-Agent': 'Mozilla/5.0' } });
      const j = await r.json();
      if (j && j.name) { got = { tw: j.name, src: base.includes('classic') ? 'classic' : 'retail', icon: j.icon || null }; break; }
    } catch (e) {}
    await sleep(150);
  }
  out[key] = got ? { cn, ...got } : { cn, tw: null };
  console.error(key, cn, '→', got ? got.tw + ' (' + got.src + ')' : '找不到');
  await sleep(200);
}
fs.writeFileSync('tw.json', JSON.stringify(out, null, 1));
