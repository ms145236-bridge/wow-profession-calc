// 阿聖治療幫手：各語言技能說明解析測試（zhCN deDE frFR esES esMX ruRU koKR ptBR；enUS 見 test-healing-enus.mjs）
// 讀 addon/ShengHealing/Locales/<語言>.lua 的 game 樣式，轉成等效的 JS 正規式，照 Core.lua 的 getDesc／parseRange／parseDesc 跑下面的範例句。
// Lua 樣式是逐位元組比對（%a 只認 ASCII 字母），所以字串先轉成 UTF-8 位元組（latin1 字串）再比，和遊戲內結果一致。
// 範例句：Wowhead Forever 各語系第一階的技能說明（tools/tooltips-<語言>.md 的來源，1.60.1.70938），癒合禱言的公式換成遊戲顯示的數字；
// 最後一句是高階癒合加上千分位（各語系的千分位寫法未經遊戲實測）。
// 用法：node tools/test-healing-locales.mjs
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const bytes = (s) => Buffer.from(s, 'utf8').toString('latin1');
// Lua 字串常值 → 位元組字串（支援 \ddd、\\、\"）
const luaStr = (s) => s.replace(/\\(\d{1,3}|.)/g, (_, c) => (/\d/.test(c) ? String.fromCharCode(+c) : c));

function loadGame(loc) {
  const lua = bytes(fs.readFileSync(path.join(root, 'addon/ShengHealing/Locales', loc + '.lua'), 'utf8'));
  const game = lua.slice(lua.indexOf('game = {'), lua.indexOf('spells = {'));
  const get = (k) => { const m = game.match(new RegExp('\\b' + k + ' = "((?:[^"\\\\]|\\\\.)*)"')); return m ? luaStr(m[1]) : undefined; };
  const list = (k) => { const m = game.match(new RegExp('\\b' + k + ' = \\{([^}]*)\\}')); return m ? [...m[1].matchAll(/"((?:[^"\\]|\\.)*)"/g)].map((x) => luaStr(x[1])) : []; };
  const G = Object.fromEntries(['damageBefore', 'damageAfter', 'hot', 'absorb', 'single', 'tick', 'tickDur', 'extra', 'dur'].map((k) => [k, get(k)]));
  for (const k of ['hot', 'absorb', 'single', 'tick', 'tickDur', 'extra', 'dur']) if (!G[k]) throw new Error(loc + ': missing pattern ' + k);
  G.rangeSeps = list('rangeSeps');
  G.thousands = list('thousands');
  G.tickAmountFirst = /tickAmountFirst = true/.test(game);
  return G;
}

// Lua 樣式 → JS 正規式（插件用到的子集：%d %D %s %S %a %. 等跳脫、[] 集合、- * + ? 量詞、^ 錨點、. 任意位元組、擷取）
function toRe(p, flags = '') {
  const cls = { d: '0-9', s: ' \\t\\n\\v\\f\\r', a: 'A-Za-z' };
  const neg = { D: '0-9', S: ' \\t\\n\\v\\f\\r', A: 'A-Za-z' };
  const lit = (c) => (c.charCodeAt(0) > 127 ? '\\x' + c.charCodeAt(0).toString(16).padStart(2, '0') : /[\\^$.|?*+()[\]{}\/-]/.test(c) ? '\\' + c : c);
  let out = '', inSet = false;
  for (let i = 0; i < p.length; i++) {
    const c = p[i];
    if (c === '%') {
      const n = p[++i];
      if (cls[n]) out += inSet ? cls[n] : '[' + cls[n] + ']';
      else if (neg[n]) out += '[^' + neg[n] + ']';
      else out += lit(n);
    } else if (c === '[' && !inSet) { inSet = true; out += c; if (p[i + 1] === '^') { out += '^'; i++; } }
    else if (c === ']' && inSet) { inSet = false; out += c; }
    else if (inSet) out += lit(c);
    else if (c === '-' && i > 0) out += '*?';
    else if (c === '.') out += '[\\s\\S]';
    else if (c === '^' && i === 0) out += '^';
    else if ('*+?()'.includes(c)) out += c;
    else out += lit(c);
  }
  return new RegExp(out, flags);
}
const match = (s, p) => { const m = s.match(toRe(p)); return m ? m.slice(1) : null; };

// Core.lua getDesc：不換行空白當一般空白，拿掉千分位
function getDesc(G, d) {
  d = d.replace(/\xc2\xa0|\xe2\x80\xaf/g, ' ').replace(/(\d),(\d)/g, '$1$2');
  for (const sep of G.thousands) d = d.replace(toRe('(%d)' + sep + '(%d%d%d)', 'g'), '$1$2');
  return d;
}
// Core.lua parseRange：最前面的「A 分隔字 B」，前 18 位元組有 damageBefore、後 17 位元組符合 damageAfter 的是傷害
function parseRange(G, d) {
  let best;
  for (const sep of G.rangeSeps) {
    for (const m of d.matchAll(toRe('(%d+)%s*' + sep + '%s*(%d+)', 'g'))) {
      const e = m.index + m[0].length;
      const hurt = (G.damageBefore && d.slice(Math.max(0, m.index - 18), m.index).includes(G.damageBefore))
        || (G.damageAfter && toRe(G.damageAfter).test(d.slice(e, e + 17)));
      if (!hurt && (!best || m.index < best[0])) best = [m.index, +m[1], +m[2]];
    }
  }
  return best ? [best[1], best[2]] : [];
}
function parseDesc(G, mode, d) {
  d = getDesc(G, bytes(d));
  const dur = match(d, G.dur);
  if (mode === 'range') return { amount: parseRange(G, d).join('–') };
  if (mode === 'hot') return { amount: match(d, G.hot)?.[0], dur: dur?.[0] };
  if (mode === 'absorb') return { amount: match(d, G.absorb)?.[0] };
  if (mode === 'single') return { amount: match(d, G.single)?.[0] };
  if (mode === 'tick') {
    let [a, b] = match(d, G.tick) || [];
    const [iv, amt] = G.tickAmountFirst ? [b, a] : [a, b];
    const td = match(d, G.tickDur)?.[0];
    return { amount: amt && td ? String(amt * td / iv) : undefined, tick: amt, every: iv, dur: td };
  }
  if (mode === 'regrowth') return { amount: parseRange(G, d).join('–'), hot: match(d, G.extra)?.[0], dur: dur?.[0] };
}

// 家族：Data.lua 的解析方式與 tools/tooltips-<語言>.md 第一階的數字（not parsed＝插件不讀說明，這裡只確認樣式讀得到）
const FAMILIES = [
  ['hl', 'Holy Light', 'range', { amount: '42–50' }],
  ['fol', 'Flash of Light', 'range', { amount: '48–54' }],
  ['hs', 'Holy Shock', 'range', { amount: '110–118' }],
  ['vigil', "Light's Vigil (not parsed)", 'range', { amount: '326–344' }],
  ['lh', 'Lesser Heal', 'range', { amount: '47–57' }],
  ['heal', 'Heal', 'range', { amount: '260–300' }],
  ['fh', 'Flash Heal', 'range', { amount: '184–223' }],
  ['gh', 'Greater Heal', 'range', { amount: '819–920' }],
  ['renew', 'Renew', 'hot', { amount: '45', dur: '15' }],
  ['pws', 'Power Word: Shield', 'absorb', { amount: '48' }],
  ['poh', 'Prayer of Healing', 'range', { amount: '179–191' }],
  ['pom', 'Prayer of Mending', 'single', { amount: '172' }],
  ['hn', 'Holy Nova', 'range', { amount: '50–57' }],
  ['ht', 'Healing Touch', 'range', { amount: '40–54' }],
  ['rejuv', 'Rejuvenation', 'hot', { amount: '32', dur: '12' }],
  ['rg', 'Regrowth', 'regrowth', { amount: '89–103', hot: '91', dur: '21' }],
  ['tranq', 'Tranquility', 'tick', { amount: '455', tick: '91', every: '2', dur: '10' }],
  ['wg', 'Wild Growth (not parsed)', 'hot', { amount: '336', dur: '7' }],
  ['hw', 'Healing Wave', 'range', { amount: '37–47' }],
  ['lhw', 'Lesser Healing Wave', 'range', { amount: '151–172' }],
  ['ch', 'Chain Heal', 'range', { amount: '246–281' }],
  ['ript', 'Riptide (not parsed)', 'hot', { amount: '445', dur: '15' }],
];
const TEXTS = {
 "zhCN": {
  "hl": "治疗友方目标，恢复42至50点生命值。",
  "fol": "治疗友方目标，恢复48至54点生命值。",
  "hs": "以神圣能量冲击目标，对一个敌人造成129至139点神圣伤害，或者为一个友方目标恢复110至118点生命值。",
  "vigil": "对友方目标施加圣光守望，持续30秒。你对其施放的下一个神圣震击不触发冷却，并为目标及其小队恢复326至344点生命值。你在每个小队中最多可同时维持一个圣光守望。",
  "lh": "治疗目标，恢复47至57点生命值。",
  "heal": "治疗目标，恢复260至300点生命值。",
  "fh": "治疗友方目标，恢复184至223点生命值。",
  "gh": "施法缓慢的法术，可以为单一目标治疗819至920点伤害。",
  "renew": "治疗目标，在15秒内恢复总计45点生命值。",
  "pws": "汲取一名队伍成员的灵魂力量，为其施加护盾，吸收48点伤害。持续30秒。护盾存在期间，其施法不会因受到伤害而被打断。受到护盾保护后，该目标在15秒内无法再次受到护盾保护。",
  "poh": "强大的祷言，治疗目标及其小队，回复179至191点生命值。小队成员必须位于目标40码范围内。",
  "pom": "向目标施加一个法术，在该目标下一次受到伤害或获得非周期性治疗时为其恢复172点生命值。这个治疗效果发生之后，愈合祷言会转移到20码范围内的小队或团队成员身上。最多可以转移5次，每次转移之后持续30秒。每个施法者在同一时间内只能在一名目标身上施放该法术。",
  "hn": "在施法者周围引发神圣光芒爆炸，对10码内所有敌方目标造成26至30点神圣伤害，并为10码内所有小队成员恢复50至57点生命值。这些效果不产生威胁值。",
  "ht": "治疗友方目标，恢复40至54点生命值。",
  "rejuv": "治疗目标，在12秒内恢复总计32点生命值。",
  "rg": "治疗友方目标，恢复89至103点生命值，并在21秒内恢复额外的91点生命值。",
  "tranq": "使20码内附近的所有队伍成员每2秒恢复91点生命值，持续10秒。德鲁伊必须持续引导才能维持该法术。",
  "wg": "在7秒内为目标及其43.5码内的小队成员恢复336点生命值。治疗效果起初较快，随着野性成长接近结束而变慢。",
  "hw": "治疗友方目标，恢复37至47点生命值。",
  "lhw": "治疗友方目标，恢复151至172点生命值。",
  "ch": "为友方目标回复246至281点生命值，然后转而治疗附近的目标。如果对小队成员施法，则治疗链只会继续治疗其队友。治疗链每次跳跃后的治疗效果是上一个目标的50%。总共可治疗3个目标。",
  "ript": "在15秒内为一个友方目标恢复445点生命值，并使你对该目标直接施放的治疗链效果提高25%。"
 },
 "deDE": {
  "hl": "Heilt ein befreundetes Ziel um 42 bis 50 Punkt(e).",
  "fol": "Heilt ein befreundetes Ziel um 48 bis 54 Punkt(e).",
  "hs": "Überzieht das Ziel mit heiliger Energie, die Gegnern 129 bis 139 Heiligschaden zufügt oder Verbündete um 110 bis 118 Gesundheit heilt.",
  "vigil": "Belegt ein befreundetes Ziel 30 Sek. lang mit 'Lichtwacht'. Wenn Ihr das nächste Mal 'Heiliger Schock' auf das Ziel wirkt, wird keine Abklingzeit ausgelöst und das Ziel sowie dessen Gruppe um 326 bis 344 geheilt. Pro Paladin und Gruppe kann nur ein Effekt von 'Lichtwacht' aktiv sein.",
  "lh": "Euer Ziel um 47 bis 57 Punkt(e) heilen.",
  "heal": "Euer Ziel um 260 bis 300 Punkt(e) heilen.",
  "fh": "Heilt ein befreundetes Ziel um 184 bis 223 Punkt(e).",
  "gh": "Ein langsam zu wirkender Zauber, der ein einzelnes Ziel um 819 bis 920 Punkt(e) heilt.",
  "renew": "Heilt das Ziel 15 Sek. lang um 45 Schadenspunkt(e).",
  "pws": "Nutzt die Seelenkraft des Gruppenmitglieds zum Abschirmen und absorbiert dabei 48 Punkt(e) Schaden. Hält 30 Sek. lang an. Solange der Schild hält, wird das Zauberwirken durch erlittenen Schaden nicht unterbrochen. Nachdem das Ziel einmal abgeschirmt wurde, kann es 15 Sek. lang nicht wieder abgeschirmt werden.",
  "poh": "Ein mächtiges Gebet, das das Ziel und seine Gruppenmitglieder um 179 bis 191 Gesundheit heilt. Gruppenmitglieder müssen sich innerhalb von 40 Metern um das Ziel befinden.",
  "pom": "Belegt das Ziel mit einem Zauber, der es um 172 Gesundheit heilt, wenn es das nächste Mal Schaden erleidet oder nicht regelmäßige Heilung erhält. Wird die Heilung ausgelöst, springt 'Gebet der Besserung' zu einem Gruppen- oder Schlachtzugsmitglied innerhalb von 20 Metern über. Springt bis zu 5-mal und hält nach jedem Sprung 30 Sek. lang an. Dieser Zauber kann pro Zauberndem nur auf einem Ziel gleichzeitig platziert werden.",
  "hn": "Verursacht eine Explosion heiligen Lichts um den Zaubernden herum und fügt allen gegnerischen Zielen innerhalb von 10 Metern 26 bis 30 Heiligschaden zu. Zusätzlich werden alle Gruppenmitglieder innerhalb von 10 Metern um 50 bis 57 Gesundheit geheilt. Dieser Effekt erzeugt keine Bedrohung.",
  "ht": "Heilt ein befreundetes Ziel um 40 bis 54 Punkt(e).",
  "rejuv": "Heilt beim Ziel 12 Sek. lang 32 Punkt(e) Schaden.",
  "rg": "Heilt ein befreundetes Ziel um 89 bis 103 und über 21 Sek. um weitere 91.",
  "tranq": "Regeneriert 10 Sek. lang alle 2 Sek. 91 Gesundheit aller Gruppenmitglieder innerhalb von 20 Metern. Der Druide muss diesen Zauber kanalisieren, um ihn aufrechtzuerhalten.",
  "wg": "Heilt das Ziel und seine Gruppenmitglieder innerhalb von 43.5 Metern um ihn herum im Verlauf von 7 Sek. um 336 Gesundheit. Die Heilung wird zunächst schnell und mit zunehmender Dauer von 'Wildwuchs' langsamer angewendet.",
  "hw": "Heilt ein befreundetes Ziel um 37 bis 47 Punkt(e).",
  "lhw": "Heilt ein befreundetes Ziel um 151 bis 172 Punkt(e).",
  "ch": "Heilt das verbündete Ziel um 246 bis 281 Gesundheit und springt dann weiter, um weitere Ziele in der Nähe zu heilen. Wenn der Zauber auf ein Gruppenmitglied gewirkt wird, springt die Heilung nur auf andere Gruppenmitglieder über. Nach jedem Sprung beträgt die Heilung 50% des vorhergehenden Wertes. Heilt insgesamt 3 Ziele.",
  "ript": "Heilt ein befreundetes Ziel im Verlauf von 15 Sek. um 445 Gesundheit. Erhöht die Effektivität Eurer Einsätze von 'Kettenheilung', die direkt auf das Ziel gewirkt werden, um 25%."
 },
 "frFR": {
  "hl": "Rend 42 à 50 points de vie à une cible alliée.",
  "fol": "Rend 48 à 54 points de vie à une cible alliée.",
  "hs": "L’énergie sacrée frappe la cible et inflige 129 à 139 points de dégâts du sacré à un adversaire, ou rend 110 à 118 points de vie à un personnage allié.",
  "vigil": "Applique Vigile de Lumière à une cible alliée pendant 30 sec. Le prochain Horion sacré du lanceur ou de la lanceuse sur la cible ne déclenche pas de temps de recharge et soigne la cible et son groupe à hauteur de 326 à 344 points de vie. Une seule occurrence de Vigile de Lumière peut être active par paladin ou paladine et par groupe.",
  "lh": "Soigne la cible de 47 à 57 points de vie.",
  "heal": "Soigne la cible de 260 à 300 points de vie.",
  "fh": "Rend 184 à 223 points de vie à une cible alliée.",
  "gh": "Une longue incantation qui rend 819 à 920 points de vie à une cible unique.",
  "renew": "Rend 45 points de vie à la cible en 15 sec.",
  "pws": "Puise dans l’âme du membre du groupe pour le protéger et absorbe 48 points de dégâts. Dure 30 sec. Tant que le bouclier est actif, les sorts ne sont pas interrompus par les dégâts subis. Après usage, la cible ne peut plus profiter de cette protection pendant 15 sec.",
  "poh": "Puissante prière qui restitue 179 à 191 points de vie à la cible et aux membres de son groupe situés à moins de 40 m d’elle.",
  "pom": "Place sur la cible un sort qui lui rend 172 points de vie la prochaine fois qu’elle subit des dégâts ou reçoit des soins non périodiques. Chaque fois que les soins sont déclenchés, Prière de guérison passe à un autre membre du groupe ou raid à moins de 20 m. Change de cible 5 fois au maximum et dure 30 sec après chaque changement. Ce sort ne peut être placé que sur une cible à la fois.",
  "hn": "Provoque une explosion de lumière sacrée autour du lanceur ou de la lanceuse. Elle inflige 26 à 30 points de dégâts du sacré à toutes les cibles ennemies dans une zone de 10 m et rend 50 à 57 points de vie aux membres du groupe dans une zone de 10 m. Ces effets ne modifient pas le niveau de menace.",
  "ht": "Rend 40 à 54 points de vie à une cible alliée.",
  "rejuv": "Rend 32 points de vie à la cible en 12 sec.",
  "rg": "Soigne une cible amie pour 89 à 103 puis pour 91 points supplémentaires pendant 21 sec.",
  "tranq": "Régénère de 91 les points de vie des membres du groupe à moins de 20 m toutes les 2 s pendant 10 sec. Le personnage druide doit canaliser le sort pendant toute sa durée, sinon celui-ci s’interrompt.",
  "wg": "Rend 336 points de vie en 7 sec à la cible et aux membres de son groupe se trouvant à moins de 43.5 m d’elle. La quantité de soins prodiguée est importante au début, puis diminue à mesure que Croissance sauvage atteint sa durée maximale.",
  "hw": "Rend 37 à 47 points de vie à une cible alliée.",
  "lhw": "Rend 151 à 172 points de vie à une cible alliée.",
  "ch": "Rend 246 à 281 points de vie à la cible alliée, puis soigne d’autres personnages alliés proches. Si le sort est jeté sur un membre du groupe, il ne soignera que des membres du groupe. Chaque nouveau soin a pour effet 50 % du soin précédent. Soigne 3 cibles au total.",
  "ript": "Rend 445 points de vie à une cible alliée en 15 sec, et augmente l’efficacité de votre sort Salve de guérison de 25 % lorsqu’il est lancé directement sur cette cible."
 },
 "esES": {
  "hl": "Cura un objetivo amigo en 42 al 50 p.",
  "fol": "Cura un objetivo amigo en 48 al 54 p.",
  "hs": "Golpea al objetivo con energía Sagrada que inflige 129 al 139 p. de daño Sagrado a un enemigo o sana 110 al 118 p. a un aliado.",
  "vigil": "Aplica Vigilia de la Luz a un objetivo amistoso durante 30 s. El siguiente Choque Sagrado que lances sobre el objetivo no activa el tiempo de reutilización y sana 326 al 344 p. al objetivo y su grupo. Solo se puede tener una Vigilia activa por paladín y grupo.",
  "lh": "Cura tu objetivo en 47 al 57 p.",
  "heal": "Cura tu objetivo en 260 al 300 p.",
  "fh": "Cura un objetivo amigo en 184 al 223 p.",
  "gh": "Un hechizo de consecución lenta que cura a un único objetivo en 819 al 920 p.",
  "renew": "Cura el objetivo en 45 p. de daño durante 15 s.",
  "pws": "Atrae el alma de un miembro del grupo para protegerlo y absorbe 48 p. de daño. Dura 30 s. Mientras el escudo esté activo, los lanzamientos de hechizos no se interrumpirán al recibir daño. Una vez que haya sido protegido, el objetivo no puede recibir protección de nuevo durante 15 s.",
  "poh": "Un poderoso rezo que sana 179 al 191 p. al objetivo y a su grupo. Los miembros del grupo deben estar en un radio de 40 m del objetivo.",
  "pom": "Lanza un hechizo sobre el objetivo que lo sanará 172 p. la próxima vez que reciba daño o sanación no periódica. Una vez curado, Rezo de alivio saltará a otro miembro del grupo o banda que se encuentre en un radio de 20 m. Salta hasta 5 veces y dura 30 s tras cada salto. Este hechizo solo puede estar activo en un único objetivo a la vez por taumaturgo.",
  "hn": "Provoca una explosión de Luz Sagrada alrededor del taumaturgo que inflige 26 al 30 p. de daño Sagrado a todos los objetivos enemigos en un radio de 10 m y sana 50 al 57 p. a todos los miembros del grupo en un radio de 10 m. Estos efectos no generan amenaza.",
  "ht": "Cura un objetivo amigo en 40 al 54 p.",
  "rejuv": "Cura el objetivo en 32 p. durante 12 s.",
  "rg": "Cura un objetivo amigo en 89 al 103 p. y otro en 91 p. durante 21 s.",
  "tranq": "Regenera 91 p. a todos los miembros del grupo en un radio de 20 m cada 2 s durante 10 s. El druida debe canalizar su magia para mantener el hechizo.",
  "wg": "Sana 336 p. al objetivo y a su grupo durante 7 s. Los miembros del grupo deben estar en un radio de 43.5 m del objetivo. La cantidad sanada se aplica con rapidez al principio y va disminuyendo a medida que surte efecto Crecimiento salvaje.",
  "hw": "Cura un objetivo amigo en 37 al 47 p.",
  "lhw": "Cura un objetivo amigo en 151 al 172 p.",
  "ch": "Sana primero a un objetivo amistoso 246 al 281 p. y después a otros objetivos cercanos. Si se lanza sobre un miembro de un grupo, la sanación continuará aplicándose solo a los otros miembros del grupo. Por cada objetivo sucesivo, la efectividad del efecto se reduce a un 50% con respecto al objetivo anterior. Sana a un máximo de 3 objetivos.",
  "ript": "Sana a un objetivo amistoso 445 p. durante 15 s. Aumenta un 25% la efectividad de tu Sanación en cadena al lanzarla directamente sobre ese objetivo."
 },
 "esMX": {
  "hl": "Sana a un objetivo amistoso 42 al 50 p.",
  "fol": "Sana 48 al 54 p. a un objetivo aliado.",
  "hs": "Golpea al objetivo con energía Sagrada, inflige 129 al 139 p. de daño Sagrado a un enemigo o sana 110 al 118 p. a un aliado.",
  "vigil": "Aplica Vigilia de la Luz a un objetivo aliado durante 30 s. El siguiente Choque sagrado del taumaturgo sobre este objetivo no tiene tiempo de reutilización y restablece 326 al 344 p. de salud al objetivo y su grupo. Solo puede haber una Vigilia activa por paladín en cada grupo.",
  "lh": "Sana a tu objetivo 47 al 57 p.",
  "heal": "Sana tu objetivo en 260 al 300 p.",
  "fh": "Sana a un objetivo amistoso 184 al 223 p.",
  "gh": "Un hechizo de lanzamiento lento que sana a un único objetivo 819 al 920 p.",
  "renew": "Sana 45 p. de daño al objetivo durante 15 s.",
  "pws": "Refuerza con un escudo el alma de un miembro del grupo y absorbe 48 p. de daño. Dura 30 s. Mientras dura el escudo, el lanzamiento de hechizos no se ve interrumpido por el daño. Una vez protegido, el objetivo no puede volver a recibir protección durante 15 s.",
  "poh": "Un potente rezo que sana 179 al 191 p. al objetivo y su grupo. Los miembros del grupo deben estar en un radio de 40 m del objetivo.",
  "pom": "Lanza un hechizo sobre el objetivo que le restaura 172 p. de salud la próxima vez que reciba daño o sanación no periódica. Una vez sanado, Rezo de alivio pasa a otro miembro del grupo o banda en un radio de 20 m. Salta hasta 5 veces y dura 30 s después de cada salto. Este hechizo solo puede estar activo en un único objetivo a la vez por taumaturgo.",
  "hn": "Provoca una explosión de luz sagrada alrededor del taumaturgo que inflige 26 al 30 p. de daño sagrado a todos los objetivos enemigos en un radio de 10 m y sana 50 al 57 p. a todos los miembros del grupo en un radio de 10 m. Estos efectos no generan amenaza.",
  "ht": "Sana 40 al 54 p. a un objetivo aliado.",
  "rejuv": "Sana 32 p. al objetivo durante 12 s.",
  "rg": "Sana 89 al 103 p. a un objetivo aliado y otros 91 p. durante 21 s.",
  "tranq": "Regenera 91 p. de salud a todos los miembros del grupo en un radio de 20 m cada 2 s durante 10 s. El druida debe canalizar su magia para mantener el hechizo.",
  "wg": "Restablece 336 p. de salud al jugador objetivo y a todos los miembros de su grupo durante 7 s. Los miembros del grupo deben estar dentro de un radio de 43.5 m del jugador objetivo. La sanación se aplica rápidamente al principio y luego más lentamente a medida que el Crecimiento salvaje alcanza su duración máxima.",
  "hw": "Sana 37 al 47 p. a un objetivo aliado.",
  "lhw": "Sana a un objetivo amistoso 151 al 172 p.",
  "ch": "Restablece 246 al 281 p. de salud al objetivo aliado y salta para sanar objetivos adicionales cercanos. Si se lanza sobre un miembro del grupo, la sanación solo saltará hacia otros miembros del grupo. Cada sanación conserva un 50% de la efectividad con cada salto. Sana a un total de 3 objetivos.",
  "ript": "Sana 445 p. a un objetivo aliado durante 15 s y aumenta un 25% la efectividad de tu hechizo Sanación en cadena directo sobre ese objetivo."
 },
 "ruRU": {
  "hl": "Исцеляет дружественную цель на 42 в 50 ед. здоровья.",
  "fol": "Исцеление дружественной цели на 48 в 54 ед.",
  "hs": "Переполняет цель мощью светлой магии, нанося 129 в 139 ед. урона противнику или восстанавливая 110 в 118 ед. здоровья союзнику.",
  "vigil": "Применяет к союзнику \"Дозор Света\" на 30 сек. Следующий \"Шок небес\", который вы примените к цели, не активирует время восстановления и восстановит 326 в 344 ед. здоровья цели и остальным участникам группы. Каждый паладин может наложить только один \"Дозор Света\".",
  "lh": "Исцеление цели на 47 в 57 ед.",
  "heal": "Исцеление цели на 260 в 300 ед.",
  "fh": "Исцеление дружественной цели на 184 в 223 ед.",
  "gh": "Медленно накладываемое заклинание, которое излечивает одну цель на 819 в 920 ед.",
  "renew": "Излечение цели на 45 ед. в течение 15 сек.",
  "pws": "Вытягивает частичку души участника группы и создает из нее щит, поглощающий 48 ед. урона. Время действия – 30 сек. Пока персонаж защищен, применение заклинаний не может быть прервано получением урона. Повторно применить щит можно только через 15 сек.",
  "poh": "Действенная молитва восстанавливает цели и участникам ее группы 179 в 191 ед. здоровья. Участники группы должны находиться в радиусе 40 м от цели.",
  "pom": "Применяет к цели заклинание, восполняющее ей 172 ед. здоровья при следующем получении урона или исцеления прямого действия. После срабатывания \"Молитва восстановления\" переходит к другому участнику группы или рейда в радиусе 20 м. Максимум переходов – 5. Действует 30 сек. после каждого перехода. Можно применить только к одной цели одновременно.",
  "hn": "Вспыхивает священным светом, нанося противникам в радиусе 10 м 26 в 30 ед. урона от светлой магии и восстанавливая участникам группы в радиусе 10 м 50 в 57 ед. здоровья. Не повышает уровень угрозы.",
  "ht": "Исцеление дружественной цели на 40 в 54 ед.",
  "rejuv": "Излечение цели на 32 ед. в течение 12 сек.",
  "rg": "Исцеление дружественной цели на 89 в 103 ед. и еще 91 ед. в течение 21 сек.",
  "tranq": "Восполняет участникам группы в радиусе 20 м 91 ед. здоровья раз в 2 сек. в течение 10 сек. Требуется поддержание заклинания.",
  "wg": "Восполняет цели и участникам ее группы в радиусе 43.5 м 336 ед. здоровья за 7 сек. Объем исцеления постепенно уменьшается на протяжении действия \"Буйного роста\".",
  "hw": "Исцеление дружественной цели на 37 в 47 ед.",
  "lhw": "Исцеление дружественной цели на 151 в 172 ед.",
  "ch": "Восполняет союзнику 246 в 281 ед. здоровья, а затем переходит на соседние цели. Если применить к участнику группы, переходит только на других участников группы. Каждый переход снижает эффективность исцеления до 50% предыдущего исцеления. Максимум целей – 3.",
  "ript": "Восстанавливает союзнику 445 ед. здоровья за 15 сек. Повышает эффективность \"Цепного исцеления\", применяемого напрямую к этой цели, на 25%."
 },
 "koKR": {
  "hl": "대상의 생명력을 42 에서 50만큼 회복시킵니다.",
  "fol": "대상의 생명력을 48 에서 54만큼 회복시킵니다.",
  "hs": "대상을 성스러운 기운으로 강타하여 129 에서 139의 신성 피해를 입히거나, 아군의 생명력을 110 에서 118만큼 회복시킵니다.",
  "vigil": "아군 대상에게 30초 동안 빛의 경계를 적용합니다. 시전자가 대상에게 사용하는 다음 신성 충격이 재사용 대기시간을 발생시키지 않고, 대상과 대상의 파티를 326 에서 344만큼 치유합니다. 경계는 파티당 성기사별로 1개만 활성화할 수 있습니다.",
  "lh": "대상의 생명력을 47 에서 57만큼 회복시킵니다.",
  "heal": "대상의 생명력을 260 에서 300만큼 회복시킵니다.",
  "fh": "대상의 생명력을 184 에서 223만큼 회복시킵니다.",
  "gh": "대상의 생명력을 819 에서 920만큼 회복시킵니다.",
  "renew": "15초에 걸쳐 대상의 생명력을 총 45만큼 회복시킵니다.",
  "pws": "파티원의 영적인 힘을 이용하여 즉시 보호막을 생성하여 48의 피해를 흡수합니다. 30초 동안 지속됩니다. 보호막이 지속되는 동안은 피해에 의해 주문 시전이 방해받지 않습니다. 한 번 보호막을 사용한 대상에겐 15초 동안 다시 보호막을 사용할 수 없습니다.",
  "poh": "강력한 기원으로 대상과 대상의 파티를 179 에서 191만큼 치유합니다. 파티원이 대상의 40미터 내에 있어야 합니다.",
  "pom": "대상에 주문을 걸어두어, 다음 피해를 받거나 비주기적인 치유를 받을 때 172의 생명력을 회복하게 합니다. 생명력이 회복되면 20미터 반경 내의 파티원 혹은 공격대원에게 회복의 기원이 전달됩니다. 최대 5번까지 이동하며, 매 이동 시 효과가 30초 동안 지속됩니다. 이 주문은 시전자당 한 번에 하나의 대상에게만 걸어둘 수 있습니다.",
  "hn": "시전자의 주위를 감싸고 있는 신성한 빛을 폭발시켜 10미터 반경의 모든 적에게 26 에서 30의 신성 피해를 입히고 10미터 반경 내의 파티원의 생명력을 50 에서 57만큼 치유합니다. 이 주문은 위협 수준을 생성하지 않습니다.",
  "ht": "대상의 생명력을 40 에서 54만큼 회복시킵니다.",
  "rejuv": "12초에 걸쳐 32의 생명력을 회복시킵니다.",
  "rg": "대상의 생명력을 89 에서 103만큼 회복시키고 추가로 21초에 걸쳐 총 91의 생명력을 회복시킵니다.",
  "tranq": "10초 동안 2초마다 20미터 내 주위 모든 파티원의 생명력을 91만큼 회복시킵니다. 주문을 유지하려면 계속 정신을 집중해야 합니다.",
  "wg": "대상과 대상의 파티를 7초에 걸쳐 336만큼 치유합니다. 파티원이 대상의 43.5미터 내에 있어야 합니다. 처음에는 회복 속도가 빠르지만 시간이 지날수록 점차 느려집니다.",
  "hw": "대상의 생명력을 37 에서 47만큼 회복시킵니다.",
  "lhw": "대상의 생명력을 151 에서 172만큼 회복시킵니다.",
  "ch": "대상의 생명력을 246 에서 281만큼 회복시키고 그 주위의 아군을 연쇄적으로 회복시킵니다. 파티원에게 사용하면 같은 파티원에게만 효과가 전달됩니다. 대상이 바뀔 때마다 이전 대상 대비 50%의 효율을 발휘합니다. 최대 3명의 대상에게 효력을 미칩니다.",
  "ript": "아군 대상을 만큼 15초에 걸쳐 445만큼 회복시킵니다. 또한 대상에게 직접 시전하는 연쇄 치유의 효과가 25%만큼 증가합니다."
 },
 "ptBR": {
  "hl": "Cura 42 para 50 pontos de vida de um alvo aliado.",
  "fol": "Cura 48 para 54 pontos de vida de um alvo aliado.",
  "hs": "Atinge um inimigo com energia Sagrada, causando 129 para 139 de dano Sagrado a um inimigo ou curando 110 para 118 pontos de vida de um aliado.",
  "vigil": "Aplica Luz Zelosa a um alvo aliado por 30 s. O próximo Choque Sagrado lançado pelo lançador nesse alvo não ativa a recarga e cura o alvo e os integrantes do grupo dele em 326 para 344 pontos de vida. Apenas uma Luz Zelosa por paladino pode ficar ativa em cada grupo.",
  "lh": "Cura 47 para 57 pontos de vida do alvo.",
  "heal": "Cura 260 para 300 pontos de vida do seu alvo.",
  "fh": "Cura 184 para 223 pontos de vida de um alvo aliado.",
  "gh": "Feitiço de lançamento lento que cura 819 para 920 pontos de vida de um único alvo.",
  "renew": "Cura 45 pontos de vida do alvo ao longo de 15 s.",
  "pws": "Recorre à alma do integrante do grupo para protegê-lo, absorvendo 48 de dano. Dura 30 s. Enquanto o escudo estiver ativo, receber dano não interrompe o lançamento de feitiços. Ao ser protegido, o alvo não pode ser protegido novamente por 15 s.",
  "poh": "Uma prece poderosa que concede 179 para 191 de cura ao alvo e ao grupo dele. Integrantes do grupo devem estar a até 40 m do alvo.",
  "pom": "Lança um feitiço que concede ao alvo uma cura de 172 na próxima vez que ele receber dano ou cura não periódicos. Quando ocorre a cura, Prece da Recomposição propaga-se para um integrante do grupo ou raide em um raio de 20 m. Propaga-se até 5 vezes e dura 30 s após cada propagação. Este feitiço só pode ser colocado em um único alvo por vez por lançador.",
  "hn": "Provoca uma explosão de luz sagrada ao redor do lançador, causando 26 para 30 de dano Sagrado a todos os inimigos em um raio de 10 m. Cura 50 para 57 pontos de vida de todos os integrantes do grupo em um raio de 10 m. Estes efeitos não geram ameaça.",
  "ht": "Cura 40 para 54 pontos de vida de um alvo aliado.",
  "rejuv": "Cura 32 pontos de vida do alvo ao longo de 12 s.",
  "rg": "Cura 89 para 103 pontos de vida de um alvo aliado e mais 91 ao longo de 21 s.",
  "tranq": "Regenera 91 pontos de vida de todos os integrantes próximos do grupo em um raio de 20 m a cada 2 s por 10 s. O Druida precisa canalizar para manter o feitiço.",
  "wg": "Cura 336 pontos de vida do alvo e do grupo dele ao longo de 7 s. Os integrantes do grupo devem estar em um raio de 43.5 m do alvo. O valor da cura é aplicado rapidamente no começo, e desacelera à medida que Crescimento Silvestre chega à duração completa.",
  "hw": "Cura 37 para 47 pontos de vida de um alvo aliado.",
  "lhw": "Cura 151 para 172 pontos de vida de um alvo aliado.",
  "ch": "Cura 246 para 281 pontos de vida de um alvo aliado e se propaga para curar outros alvos próximos. Se o feitiço for lançado em um integrante do grupo, a cura só será propagada para outros integrantes do grupo. A cada propagação, o efeito equivale a 50% do efeito no alvo anterior. Cura no máximo 3 alvos.",
  "ript": "Concede 445 de cura a um alvo aliado ao longo de 15 s e aumenta em 25% a eficácia dos seus lançamentos de Cura Encadeada diretamente nesse alvo."
 }
};
// 高階癒合（999–1111＋994）用各語系的千分位寫法
const THOUSANDS = { zhCN: '1,111', deDE: '1.111', frFR: '1 111', esES: '1.111', esMX: '1.111', ruRU: '1 111', koKR: '1,111', ptBR: '1.111' };

let fail = 0, total = 0;
for (const [loc, texts] of Object.entries(TEXTS)) {
  const G = loadGame(loc);
  const cases = FAMILIES.map(([k, name, mode, want]) => [name, mode, texts[k], want]);
  const rg = texts.rg.replace(/\b89\b/, '999').replace(/\b103\b/, THOUSANDS[loc]).replace(/\b91\b/, '994');
  cases.push(['Regrowth r9 (thousands)', 'regrowth', rg, { amount: '999–1111', hot: '994', dur: '21' }]);
  const rows = cases.map(([name, mode, text, want]) => {
    const got = parseDesc(G, mode, text);
    const ok = Object.entries(want).every(([k, v]) => String(got[k]) === v);
    total++;
    if (!ok) fail++;
    const fmt = (o) => Object.keys(want).map((k) => `${k}=${o[k]}`).join(' ');
    return { spell: name, mode, expected: fmt(want), parsed: fmt(got), ok: ok ? 'ok' : 'FAIL' };
  });
  const bad = rows.filter((r) => r.ok !== 'ok');
  console.log(`${loc}: ${rows.length - bad.length}/${rows.length} ok`);
  if (bad.length || process.argv.includes('-v')) console.table(bad.length ? bad : rows);
}
console.log(fail ? `${fail} FAIL` : `all ${total} ok`);
process.exit(fail ? 1 : 0);
