// 抓 kovarel 拍賣行工具資料（簡中頁，用 ID 對應），輸出 raw.json
import * as cheerio from 'cheerio';
import fs from 'fs';
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130 Safari/537.36';
const PROFS = ['alchemy','blacksmithing','enchanting','engineering','leatherworking','tailoring','cooking','first-aid'];
const onlyPools = process.argv[2] ? process.argv[2].split(',') : null;
const sleep = ms => new Promise(r => setTimeout(r, ms));
async function get(url) {
  for (let i = 0; i < 3; i++) {
    const r = await fetch(url, { headers: { 'User-Agent': UA, 'Accept-Language': 'zh-CN' } });
    if (r.ok) return r.text();
    console.error('HTTP', r.status, url); await sleep(3000);
  }
  throw new Error('fail ' + url);
}
const money = s => { let c = 0; const g = s.match(/([\d,]+)\s*金/), si = s.match(/(\d+)\s*银/), cu = s.match(/(\d+)\s*铜/);
  if (g) c += parseInt(g[1].replace(/,/g, '')) * 10000; if (si) c += +si[1] * 100; if (cu) c += +cu[1]; return c; };
const ent = ($a) => { const h = $a.attr('href') || ''; const m = h.match(/\/(items|spells)\/(\d+)/); return m ? [m[1] === 'spells' ? 's' : 'i', +m[2]] : ['i', 0]; };
const icon = ($a) => (($a.find('img').attr('src') || '').match(/\/36\/(.+)\.jpg/) || [])[1] || null;

function parse(html) {
  const $ = cheerio.load(html);
  const tables = $('article table').toArray();
  const meta = ($('article').text().match(/(\d+) 份玩家扫描的中位价 · 最近一份 ([^上]+?)(?=上传|$)/) || []);
  const mats = $(tables[0]).find('tbody tr').toArray().map(tr => {
    const td = $(tr).find('td'); const a = td.eq(0).find('a').first(); const t = td.eq(0).text();
    const [k, id] = ent(a);
    return { id, k, cn: a.find('img').attr('alt'), q: a.attr('data-quality') || null, ic: icon(a), v: /商人/.test(t) ? 1 : 0,
      p: money((t.match(/单价(.*)/) || ['', ''])[1]), qty: parseInt(td.eq(1).text().replace(/,/g, '')) };
  });
  const steps = [];
  tables.slice(1).forEach(tb => $(tb).find('tbody tr').each((_, tr) => {
    const td = $(tr).find('td'); const a = td.eq(1).find('a').first(); const [k, id] = ent(a);
    const r = td.eq(0).text().split('–').map(Number);
    const noteM = td.eq(2).text().match(/多做\s*(\d+)/);
    const reag = td.eq(3).find('a[aria-label]').toArray().map(e => { const $e = $(e); const m = $e.attr('aria-label').match(/^(.*) x(\d+)$/); const [, rid] = ent($e); return [rid, m[1], +m[2]]; });
    const diff = td.eq(4).find('span,div').toArray().filter(e => $(e).children().length === 0).map(e => $(e).text().trim());
    steps.push({ f: r[0], t: r[1], id, k, cn: a.find('img').attr('alt') || a.text().trim(), q: a.attr('data-quality') || null, ic: icon(a),
      src: a.find('[data-role=metadata]').text().trim(), c: parseInt(td.eq(2).text().replace(/[×,]/g, '')), extra: noteM ? +noteM[1] : 0, m: reag, d: diff });
  }));
  return { scans: meta[1] ? +meta[1] : null, ago: meta[2] ? meta[2].trim() : null, mats, steps };
}

const first = await get('https://kovarel.com/cn/wow-forever/tools/auction-house?pool=cn.pvp.horde&profession=alchemy');
const $ = cheerio.load(first);
let pools = [...new Set($('a[href*="pool="], option').toArray().map(e => { const h = $(e).attr('href') || $(e).attr('value') || ''; const m = h.match(/pool=([a-z.\-]+)/) || h.match(/^([a-z]+.[a-z\-]+\.(alliance|horde))$/); return m && m[1]; }).filter(Boolean))];
const poolNames = {};
$('a[href*="pool="], option').each((_, e) => { const h = $(e).attr('href') || $(e).attr('value') || ''; const m = h.match(/pool=([a-z.\-]+)/) || h.match(/^([a-z]+.[a-z\-]+\.(alliance|horde))$/); if (m) poolNames[m[1]] = $(e).text().trim(); });
console.error('pools', pools.length, pools.slice(0, 5));
if (onlyPools) pools = onlyPools;
const out = { fetched: new Date().toISOString(), poolNames, pools: {} };
for (const pool of pools) {
  out.pools[pool] = {};
  for (const p of PROFS) {
    const html = await get(`https://kovarel.com/cn/wow-forever/tools/auction-house?pool=${pool}&profession=${p}`);
    out.pools[pool][p] = parse(html);
    process.stderr.write('.');
    await sleep(700);
  }
  console.error(' ' + pool);
}
fs.writeFileSync('raw.json', JSON.stringify(out));
console.error('done');
