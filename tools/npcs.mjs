// 商人 NPC 名稱：kovarel 搜尋取得 NPC ID → Wowhead 繁中名稱，輸出 npc.json
import fs from 'fs';
const raw = JSON.parse(fs.readFileSync('raw.json', 'utf8'));
const names = new Set();
for (const pool of Object.values(raw.pools)) for (const prof of Object.values(pool)) for (const s of prof.steps) if (!['训练师', '商人', '拍卖行'].includes(s.src)) names.add(s.src);
const out = fs.existsSync('npc.json') ? JSON.parse(fs.readFileSync('npc.json', 'utf8')) : {};
for (const n of names) {
  if (out[n]) continue;
  const h = await fetch('https://kovarel.com/cn/wow-forever/npcs?q=' + encodeURIComponent(n), { headers: { 'User-Agent': 'Mozilla/5.0 Chrome/130' } }).then(r => r.text());
  const ids = [...h.matchAll(/npcs\/(\d+)-([^"\\]+)/g)].map(m => [m[1], decodeURIComponent(m[2])]);
  const want = n.replace(/·/g, '-').replace(/\s+/g, '-');
  const hit = ids.find(([, slug]) => slug === want) || ids[0];
  let tw = null;
  if (hit) { const j = await fetch('https://nether.wowhead.com/classic/tw/tooltip/npc/' + hit[0]).then(r => r.json()).catch(() => ({})); tw = j.name || null; }
  out[n] = tw;
  console.error(n, hit && hit[0], '→', tw);
}
fs.writeFileSync('npc.json', JSON.stringify(out, null, 1));
