// 阿聖治療幫手：英文技能說明解析測試
// 讀 addon/ShengHealing/Locales/enUS.lua 的 Lua 樣式，轉成等效的 JS 正規式（只支援插件用到的子集：%d %s %a、[]、- * + ?、^、擷取），
// 照 Core.lua 的 parseRange／parseDesc 邏輯跑 tools/english-tooltips.md 的範例句，比對讀到的數字。
// 用法：node tools/test-healing-enus.mjs
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const lua = fs.readFileSync(path.join(root, 'addon/ShengHealing/Locales/enUS.lua'), 'utf8');
const game = lua.slice(lua.indexOf('game = {'), lua.indexOf('spells = {'));
const pat = (k) => {
  const m = game.match(new RegExp('\\b' + k + ' = "((?:[^"\\\\]|\\\\.)*)"'));
  if (!m) throw new Error('missing pattern ' + k);
  return m[1];
};
const P = Object.fromEntries(['damageAfter', 'hot', 'absorb', 'single', 'tick', 'tickDur', 'extra', 'dur'].map((k) => [k, pat(k)]));
const tickAmountFirst = /tickAmountFirst = true/.test(game);
const seps = [...game.match(/rangeSeps = \{([^}]*)\}/)[1].matchAll(/"([^"]*)"/g)].map((m) => m[1]);

// Lua 樣式 → JS 正規式
function toRe(p) {
  const cls = { d: '\\d', s: '\\s', a: 'A-Za-z' };
  let out = '', inSet = false;
  for (let i = 0; i < p.length; i++) {
    const c = p[i];
    if (c === '%') {
      const n = p[++i];
      if (cls[n]) out += inSet || n !== 'a' ? cls[n] : '[A-Za-z]';
      else out += '\\' + n;
    } else if (c === '[') { inSet = true; out += c; }
    else if (c === ']') { inSet = false; out += c; }
    else if (c === '-' && !inSet) out += '*?';
    else if (c === '.' && !inSet) out += '.';
    else out += c;
  }
  return new RegExp(out);
}
const match = (s, p) => { const m = s.match(toRe(p)); return m ? m.slice(1) : null; };

// Core.lua parseRange：最前面的「A to B」，後面 17 字內有 damage 的不算
function parseRange(d) {
  let best;
  for (const sep of seps) {
    const re = new RegExp('(\\d+)\\s*' + sep + '\\s*(\\d+)', 'g');
    for (const m of d.matchAll(re)) {
      const e = m.index + m[0].length; // Lua 的 () 是 1 起算的下一個位置；d:sub(e, e+16) ＝ JS 的 slice(e, e+17)
      const hurt = toRe(P.damageAfter).test(d.slice(e, e + 17));
      if (!hurt && (!best || m.index < best[0])) best = [m.index, +m[1], +m[2]];
    }
  }
  return best ? [best[1], best[2]] : [];
}
function parseDesc(mode, d) {
  d = d.replace(/(\d),(\d)/g, '$1$2');
  const dur = match(d, P.dur);
  if (mode === 'range') return { amount: parseRange(d).join('–') };
  if (mode === 'hot') return { amount: match(d, P.hot)?.[0], dur: dur?.[0] };
  if (mode === 'absorb') return { amount: match(d, P.absorb)?.[0] };
  if (mode === 'single') return { amount: match(d, P.single)?.[0] };
  if (mode === 'tick') {
    let [a, b] = match(d, P.tick) || [];
    const [iv, amt] = tickAmountFirst ? [b, a] : [a, b];
    const td = match(d, P.tickDur)?.[0];
    return { amount: amt && td ? String(amt * td / iv) : undefined, tick: amt, every: iv, dur: td };
  }
  if (mode === 'regrowth') return { amount: parseRange(d).join('–'), hot: match(d, P.extra)?.[0], dur: dur?.[0] };
}

// 範例句：依 tools/english-tooltips.md 的英文片段與第一階數字組成（Wowhead Forever enUS tooltip）。
// parse＝Data.lua 該家族的解析方式；nil 的家族插件不讀說明（用資料表），這裡只確認樣式不會誤讀。
const CASES = [
  ['Holy Light', 'range', 'Heals a friendly target for 42 to 50.', { amount: '42–50' }],
  ['Flash of Light', 'range', 'Heals a friendly target for 48 to 54.', { amount: '48–54' }],
  ['Holy Shock', 'range', 'Blasts the target with Holy energy, causing 129 to 139 Holy damage to an enemy, or 110 to 118 healing to an ally.', { amount: '110–118' }],
  ['Light\'s Vigil (not parsed)', 'range', 'The next Holy Shock you cast on the target heals the target and their party for 326 to 344.', { amount: '326–344' }],
  ['Lesser Heal', 'range', 'Heal your target for 47 to 57.', { amount: '47–57' }],
  ['Heal', 'range', 'Heal your target for 260 to 300.', { amount: '260–300' }],
  ['Flash Heal', 'range', 'Heals a friendly target for 184 to 223.', { amount: '184–223' }],
  ['Greater Heal', 'range', 'A slow casting spell that heals a single target for 819 to 920.', { amount: '819–920' }],
  ['Renew', 'hot', 'Heals the target of 45 damage over 15 sec.', { amount: '45', dur: '15' }],
  ['Power Word: Shield', 'absorb', 'Draws on the soul of the friendly target to shield them, absorbing 48 damage. Lasts 30 sec. Once shielded, the target cannot be shielded again for 15 sec.', { amount: '48' }],
  ['Prayer of Healing', 'range', 'A powerful prayer that heals the target and their party for 179 to 191. Party members must be within 40 yards of the target.', { amount: '179–191' }],
  ['Prayer of Mending', 'single', 'Places a spell on the target that heals them for 172 the next time they take damage or receive any healing. When the heal occurs, Prayer of Mending jumps to a party or raid member within 20 yards. Jumps up to 5 times and lasts 30 sec after each jump.', { amount: '172' }],
  ['Holy Nova', 'range', 'Causes an explosion of holy light around the caster, causing 26 to 30 Holy damage to all enemy targets within 10 yards and healing all party members within 10 yards for 50 to 57.', { amount: '50–57' }],
  ['Healing Touch', 'range', 'Heals a friendly target for 40 to 54.', { amount: '40–54' }],
  ['Rejuvenation', 'hot', 'Heals the target for 32 over 12 sec.', { amount: '32', dur: '12' }],
  ['Regrowth r1', 'regrowth', 'Heals a friendly target for 89 to 103 and another 91 over 21 sec.', { amount: '89–103', hot: '91', dur: '21' }],
  ['Regrowth r9', 'regrowth', 'Heals a friendly target for 999 to 1,111 and another 994 over 21 sec.', { amount: '999–1111', hot: '994', dur: '21' }],
  ['Tranquility', 'tick', 'Heals all nearby group members within 20 yards for 91 every 2 sec for 10 sec. The Druid must channel to maintain the spell.', { amount: '455', tick: '91', every: '2', dur: '10' }],
  ['Wild Growth (not parsed)', 'hot', 'Heals up to 5 friendly party or raid members within 43.5 yards of the target and their party for 336 over 7 sec. The amount healed is applied quickly at first, and slows down as the Wild Growth reaches its normal duration.', { amount: '336', dur: '7' }],
  ['Healing Wave', 'range', 'Heals a friendly target for 37 to 47.', { amount: '37–47' }],
  ['Lesser Healing Wave', 'range', 'Heals a friendly target for 151 to 172.', { amount: '151–172' }],
  ['Chain Heal', 'range', 'Heals the friendly target for 246 to 281, then jumps to heal additional nearby targets. Each jump reduces the effectiveness of the heal by 50%. Heals 3 total targets.', { amount: '246–281' }],
  ['Riptide (not parsed)', 'hot', 'Heals a friendly target for 445 over 15 sec. Your next Chain Heal cast on that primary target within 15 sec will increase the amount of the Chain Heal by 25%.', { amount: '445', dur: '15' }],
];

let fail = 0;
const rows = CASES.map(([name, mode, text, want]) => {
  const got = parseDesc(mode, text);
  const ok = Object.entries(want).every(([k, v]) => String(got[k]) === v);
  if (!ok) fail++;
  const fmt = (o) => Object.entries(want).map(([k]) => `${k}=${o[k]}`).join(' ');
  return { spell: name, mode, expected: fmt(want), parsed: fmt(got), ok: ok ? 'ok' : 'FAIL' };
});
console.table(rows);
console.log(fail ? `${fail} FAIL` : `all ${rows.length} ok`);
process.exit(fail ? 1 : 0);
