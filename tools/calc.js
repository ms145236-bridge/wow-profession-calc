// 成本計算核心（網頁與 Node 測試共用）
// route: { steps:[{f,t,k,id,src,c,extra,m:[[rid,qty]],d}], mats:{id:{p,v,qty}}, recipes:{recipeId: stepIndex[]}, tools:[id], yields:{id:n} }
function calcRoute(route, S, T, opts) {
  opts = opts || {};
  const price = opts.price || (id => (route.mats[id] ? route.mats[id].p : null));
  const owned = opts.owned || (() => false);
  const steps = route.steps;
  const producers = {}; // itemId -> step indices
  steps.forEach((s, i) => { if (s.k === 'i') (producers[s.id] = producers[s.id] || []).push(i); });
  const demand = {}, supply = {}, early = {}, stepCrafts = steps.map(() => 0), extraCrafts = steps.map(() => 0);
  const add = (o, k, v) => { o[k] = (o[k] || 0) + v; };
  steps.forEach((s, i) => {
    const lo = Math.max(s.f, S), hi = Math.min(s.t, T);
    if (hi <= lo) return;
    const skill = s.c - (s.extra || 0);
    const n = Math.ceil(skill * (hi - lo) / (s.t - s.f) - 1e-9);
    stepCrafts[i] = n;
  });
  // 步驟整段都在範圍內、且它的成品後面有用到 → 照原站一起把「多做」的做掉
  const capLeft = steps.map(s => s.extra || 0);
  steps.forEach((s, i) => {
    if (!s.extra || !stepCrafts[i] || s.f < S || s.t > T) return;
    const usedLater = steps.some((o, j) => stepCrafts[j] && o.m.some(([r]) => r === s.id));
    if (!usedLater) return;
    extraCrafts[i] = s.extra; capLeft[i] = 0;
  });
  steps.forEach((s, i) => {
    const n = stepCrafts[i] + extraCrafts[i]; if (!n) return;
    for (const [rid, q] of s.m) {
      // 這個材料要到後面的步驟才學得到 → 這時只能從拍賣行買
      if (producers[rid] && Math.min(...producers[rid]) > i && price(rid) != null) add(early, rid, n * q / s.c);
      else add(demand, rid, n * q / s.c);
    }
    if (s.k === 'i') add(supply, s.id, n * (route.yields[s.id] || 1));
  });
  // 中間產物：從後往前處理（後面的成品先算，再回推它用到的中間產物）
  const prodIds = Object.keys(producers).map(Number).sort((a, b) => Math.max(...producers[b]) - Math.max(...producers[a]));
  
  const craftCost = (id, depth) => {
    if (depth > 6) return Infinity;
    const si = producers[id][producers[id].length - 1], s = steps[si];
    let c = 0;
    for (const [rid, q] of s.m) {
      const per = q / s.c;
      const p = producers[rid] ? Math.min(price(rid) ?? Infinity, craftCost(rid, depth + 1)) : (price(rid) ?? 0);
      c += per * p;
    }
    return c / (route.yields[id] || 1);
  };
  const buyInter = {};
  for (const id of prodIds) {
    const need = (demand[id] || 0) - (supply[id] || 0);
    if (need <= 1e-9) continue;
    const ap = price(id);
    const si = producers[id][producers[id].length - 1], s = steps[si];
    const y = route.yields[id] || 1;
    let n = Math.ceil(need / y - 1e-9);
    // 依原站路線：自己多做的數量有上限，超過的部分從拍賣行買（拍賣行沒有才全部自己做）
    const cap = producers[id].reduce((a, i) => a + capLeft[i], 0);
    if (ap != null && n > cap) { buyInter[id] = Math.ceil(need - cap * y - 1e-9); n = cap; }
    if (n <= 0) continue;
    extraCrafts[si] += n;
    add(supply, id, n * y);
    for (const [rid, q] of s.m) add(demand, rid, n * q / s.c);
  }
  for (const [rid, q] of Object.entries(early)) { buyInter[rid] = (buyInter[rid] || 0) + Math.ceil(q - 1e-6); if (!(rid in demand)) demand[rid] = 0; }
  // 購物清單
  const list = [];
  const used = new Set();
  steps.forEach((s, i) => { if (stepCrafts[i] || extraCrafts[i]) used.add(i); });
  for (const [rid, idxs] of Object.entries(route.recipes)) {
    if (idxs.some(i => used.has(i))) list.push({ id: +rid, qty: 1, kind: 'recipe' });
  }
  for (const id of route.tools) if (used.size) list.push({ id, qty: 1, kind: 'tool' });
  for (const [rid, q] of Object.entries(demand)) {
    const id = +rid;
    if (producers[id]) { if (buyInter[id]) list.push({ id, qty: buyInter[id], kind: 'mat' }); continue; }
    list.push({ id, qty: Math.ceil(q - 1e-6), kind: 'mat' });
  }
  let total = 0;
  for (const it of list) {
    it.unit = price(it.id) ?? 0;
    it.owned = owned(it.id);
    it.sub = it.owned ? 0 : it.unit * it.qty;
    total += it.sub;
  }
  // 每步花費（依原料單價分攤）
  const stepCost = steps.map((s, i) => {
    const n = stepCrafts[i] + extraCrafts[i]; if (!n) return 0;
    let c = 0;
    for (const [rid, q] of s.m) if (!producers[rid] || buyInter[rid]) c += (owned(rid) ? 0 : (price(rid) ?? 0)) * n * q / s.c;
    return c;
  });
  return { list, total, stepCrafts, extraCrafts, stepCost };
}
if (typeof module !== 'undefined') module.exports = { calcRoute };
