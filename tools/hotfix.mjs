// WoW Forever 熱修正：原站資料還沒更新的配方材料（每做 1 次需要的數量）
// 2026-11-11 熱修正：多個裁縫包包改為需要更多布卷（格數也增加）
export const HOTFIX = {
  tailoring: {
    4241: { 2997: 5 },  // 綠色毛紡包：毛布卷 4 → 5（10 格）
    5763: { 2997: 5 },  // 紅色毛紡包：毛布卷 4 → 5（10 格）
    5764: { 4305: 5 },  // 綠色絲綢背包：絲綢卷 4 → 5（12 格）
    5765: { 4305: 6 },  // 黑色絲綢背包：絲綢卷 5 → 6（12 格）
    10051: { 4339: 5 }, // 紅色魔紋包：魔紋布卷 4 → 5（14 格）
  },
};

// 套用到路線步驟：s.m 是整步的總量（每次數量 × 次數 s.c）
export function applyHotfix(prof, steps) {
  const fix = HOTFIX[prof];
  if (!fix) return 0;
  let n = 0;
  for (const s of steps) {
    const f = s.k === 'i' && fix[s.id];
    if (!f) continue;
    for (const m of s.m) if (f[m[0]] != null && m[1] !== f[m[0]] * s.c) { m[1] = f[m[0]] * s.c; n++; }
  }
  return n;
}
