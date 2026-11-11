-- 專業衝級計算器（魔獸世界：永恆）
-- 依 Auctionator 的價格，從候選路線挑最省的一條，列出每段要做什麼、做幾次，以及要買的材料與花費。
-- 自動偵測已學專業與目前點數、扣掉背包與銀行已有的材料，可一鍵建立 Auctionator 購物清單。

local ADDON = ...
local D = ProfLevel_Data
local CALLER = "ProfLevel" -- 呼叫 Auctionator API 用的名稱
local ICON = "Interface\\Icons\\Trade_BlackSmithing"
local PROFS = {
  { key = "alchemy",        name = "鍊金術", line = 171 },
  { key = "blacksmithing",  name = "鍛造",   line = 164 },
  { key = "enchanting",     name = "附魔",   line = 333 },
  { key = "engineering",    name = "工程學", line = 202 },
  { key = "leatherworking", name = "製皮",   line = 165 },
  { key = "tailoring",      name = "裁縫",   line = 197 },
  { key = "cooking",        name = "烹飪",   line = 185 },
  { key = "first-aid",      name = "急救",   line = 129 },
}
local PROF_BY_KEY, PROF_BY_LINE, PROF_BY_NAME = {}, {}, {}
for i, p in ipairs(PROFS) do p.index = i; PROF_BY_KEY[p.key] = p; PROF_BY_LINE[p.line] = p; PROF_BY_NAME[p.name] = p end
PROF_BY_NAME["煉金術"] = PROF_BY_KEY.alchemy
PROF_BY_NAME["工程"] = PROF_BY_KEY.engineering
PROF_BY_NAME["製皮匠"] = PROF_BY_KEY.leatherworking
-- 採礦沒有衝級路線，只用來判斷能不能自己冶煉金屬錠
local MINING = { key = "mining", name = "採礦", line = 186 }
PROF_BY_LINE[186] = MINING; PROF_BY_NAME["採礦"] = MINING
local SRC = { ["训练师"] = "訓練師", ["商人"] = "商人", ["拍卖行"] = "拍賣行" }
local QUALITY = { poor = { .62, .62, .62 }, common = { 1, 1, 1 }, uncommon = { .12, 1, 0 }, rare = { 0, .44, .87 }, epic = { .64, .21, .93 } }
local DEFAULTS = { prof = nil, from = {}, to = {}, tab = "steps", minimapAngle = 200, minimapHide = false, scale = 1, decompose = true }
local db

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage("|cffd9b25f專業衝級|r " .. s) end
local reported = {}
local function safe(where, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then
    err = tostring(err)
    if not reported[err] then reported[err] = true; msg("|cffff7b7b" .. where .. "出錯：|r" .. err .. "　請把這行回報給開發者") end
  end
  return ok
end
local function ensureDB()
  if db then return db end
  ProfLevelCharDB = ProfLevelCharDB or {}
  for k, v in pairs(DEFAULTS) do if ProfLevelCharDB[k] == nil then ProfLevelCharDB[k] = type(v) == "table" and {} or v end end
  db = ProfLevelCharDB
  return db
end

-- 金錢：12金34銀56銅（100 金以上不顯示銅）
local function money(c)
  c = math.floor((c or 0) + 0.5)
  if c <= 0 then return "0" end
  local g, s, cu = math.floor(c / 10000), math.floor(c % 10000 / 100), c % 100
  local t = ""
  if g > 0 then t = t .. "|cffffd100" .. g .. "金|r" end
  if s > 0 then t = t .. "|cffc7c9cc" .. s .. "銀|r" end
  if cu > 0 and g < 100 then t = t .. "|cffc9814a" .. cu .. "銅|r" end
  return t
end

-- ── 遊戲資料 ───────────────────────────────────────────────────────────────
-- 已學的專業與目前點數：{ [key] = { cur, max } }
local function learnedProfs()
  local out = {}
  if GetProfessions and GetProfessionInfo then
    local n = select("#", GetProfessions())
    local list = { GetProfessions() }
    for i = 1, n do
      local idx = list[i]
      if idx then
        local ok, name, _, cur, mx, _, _, line = pcall(GetProfessionInfo, idx)
        local p = ok and (PROF_BY_LINE[line] or PROF_BY_NAME[name])
        if p then out[p.key] = { cur = cur or 1, max = mx or 300 } end
      end
    end
  end
  if not next(out) and GetNumSkillLines and GetSkillLineInfo then -- 經典版的讀法
    for i = 1, GetNumSkillLines() do
      local name, isHeader, _, rank, _, _, maxRank = GetSkillLineInfo(i)
      local p = not isHeader and PROF_BY_NAME[name]
      if p then out[p.key] = { cur = rank or 1, max = maxRank or 300 } end
    end
  end
  return out
end

local function auctionator()
  return Auctionator and Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.GetAuctionPriceByItemID and Auctionator.API.v1 or nil
end

-- 價格：商人物品用固定售價，其他問 Auctionator；查不到回傳 nil
local priceCache = {}
local function price(id)
  if D.vendor[id] then return D.vendor[id] end
  local v = priceCache[id]
  if v == nil then
    v = false
    local api = auctionator()
    if api then
      local ok, p = pcall(api.GetAuctionPriceByItemID, CALLER, id)
      if ok and type(p) == "number" and p > 0 then v = p end
    end
    priceCache[id] = v
  end
  return v or nil
end

local function have(id)
  local f = (C_Item and C_Item.GetItemCount) or GetItemCount
  if not f then return 0 end
  local ok, n = pcall(f, id, true) -- true：含銀行
  return ok and n or 0
end

-- 名稱、圖示、品質：遊戲讀得到就用遊戲的，讀不到用資料表
local function info(k, id)
  local d = D.items[k .. ":" .. id]
  local name, icon
  if k == "s" then
    name = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id)) or (GetSpellInfo and (GetSpellInfo(id)))
    icon = (C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(id)) or (GetSpellTexture and GetSpellTexture(id))
  else
    name = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)) or (GetItemInfo and (GetItemInfo(id)))
    icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id))
    if not name and C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
  end
  name = name or (d and d[1]) or ("#" .. id)
  icon = icon or (d and d[3] and ("Interface\\Icons\\" .. d[3])) or "Interface\\Icons\\INV_Misc_QuestionMark"
  local col = QUALITY[(d and d[2]) or "common"] or QUALITY.common
  return name, icon, col
end

local function srcName(s)
  if SRC[s] then return SRC[s] end
  if s == nil or s == "" then return "" end
  return (D.npcs[s] or s) .. "（商人）"
end

-- ── 路線計算（移植自網頁 tools/calc.js） ───────────────────────────────────
local function calcRoute(route, S, T)
  local steps = route.steps
  local producers = {}
  for i, s in ipairs(steps) do
    if s.k == "i" then producers[s.id] = producers[s.id] or {}; table.insert(producers[s.id], i) end
  end
  local demand, supply, early = {}, {}, {}
  local stepCrafts, extraCrafts, capLeft = {}, {}, {}
  local function add(o, k, v) o[k] = (o[k] or 0) + v end
  for i, s in ipairs(steps) do
    stepCrafts[i], extraCrafts[i], capLeft[i] = 0, 0, s.extra or 0
    local lo, hi = math.max(s.f, S), math.min(s.t, T)
    if hi > lo then stepCrafts[i] = math.ceil((s.c - (s.extra or 0)) * (hi - lo) / (s.t - s.f) - 1e-9) end
  end
  -- 步驟整段都在範圍內、且成品後面有用到 → 照原路線把「多做」的做掉
  for i, s in ipairs(steps) do
    if (s.extra or 0) > 0 and stepCrafts[i] > 0 and s.f >= S and s.t <= T then
      local usedLater = false
      for j, o in ipairs(steps) do
        if stepCrafts[j] > 0 then for _, m in ipairs(o.m) do if m[1] == s.id then usedLater = true end end end
      end
      if usedLater then extraCrafts[i] = s.extra; capLeft[i] = 0 end
    end
  end
  local function minP(id) local v = math.huge; for _, j in ipairs(producers[id]) do if j < v then v = j end end; return v end
  local function maxP(id) local v = -1; for _, j in ipairs(producers[id]) do if j > v then v = j end end; return v end
  for i, s in ipairs(steps) do
    local n = stepCrafts[i] + extraCrafts[i]
    if n > 0 then
      for _, m in ipairs(s.m) do
        local rid, q = m[1], m[2]
        -- 這個材料要到後面的步驟才學得到 → 這時只能買
        if producers[rid] and minP(rid) > i and price(rid) ~= nil then add(early, rid, n * q / s.c)
        else add(demand, rid, n * q / s.c) end
      end
      if s.k == "i" then add(supply, s.id, n * (route.yields[s.id] or 1)) end
    end
  end
  -- 中間產物：從後往前處理
  local prodIds = {}
  for id in pairs(producers) do table.insert(prodIds, id) end
  table.sort(prodIds, function(a, b) return maxP(a) > maxP(b) end)
  local buyInter = {}
  for _, id in ipairs(prodIds) do
    local need = (demand[id] or 0) - (supply[id] or 0)
    if need > 1e-9 then
      local list = producers[id]
      local si = list[#list]
      local s = steps[si]
      local y = route.yields[id] or 1
      local n = math.ceil(need / y - 1e-9)
      local cap = 0
      for _, j in ipairs(list) do cap = cap + capLeft[j] end
      -- 自己多做的數量有上限，超過的部分從拍賣行買（拍賣行沒有才全部自己做）
      if price(id) ~= nil and n > cap then buyInter[id] = math.ceil(need - cap * y - 1e-9); n = cap end
      if n > 0 then
        extraCrafts[si] = extraCrafts[si] + n
        add(supply, id, n * y)
        for _, m in ipairs(s.m) do add(demand, m[1], n * m[2] / s.c) end
      end
    end
  end
  for rid, q in pairs(early) do
    buyInter[rid] = (buyInter[rid] or 0) + math.ceil(q - 1e-6)
    if demand[rid] == nil then demand[rid] = 0 end
  end
  -- 購物清單
  local list, used, anyUsed = {}, {}, false
  for i = 1, #steps do if stepCrafts[i] + extraCrafts[i] > 0 then used[i] = true; anyUsed = true end end
  for rid, idxs in pairs(route.recipes) do
    local u = false
    for _, i in ipairs(idxs) do if used[i] then u = true end end
    if u then table.insert(list, { id = rid, qty = 1, kind = "recipe" }) end
  end
  if anyUsed then for _, id in ipairs(route.tools) do table.insert(list, { id = id, qty = 1, kind = "tool" }) end end
  for rid, q in pairs(demand) do
    if producers[rid] then
      if buyInter[rid] and buyInter[rid] > 0 then table.insert(list, { id = rid, qty = buyInter[rid], kind = "mat" }) end
    else
      local qty = math.ceil(q - 1e-6)
      if qty > 0 then table.insert(list, { id = rid, qty = qty, kind = "mat" }) end
    end
  end
  local total, missing = 0, 0
  for _, it in ipairs(list) do
    it.unit = price(it.id)
    it.have = have(it.id)
    it.buy = math.max(0, it.qty - it.have)
    if it.unit then total = total + it.unit * it.buy elseif it.buy > 0 then missing = missing + 1 end
  end
  local order = { recipe = 1, tool = 2, mat = 3 }
  table.sort(list, function(a, b)
    if order[a.kind] ~= order[b.kind] then return order[a.kind] < order[b.kind] end
    return (a.unit or 0) * a.buy > (b.unit or 0) * b.buy
  end)
  return { list = list, total = total, missing = missing, stepCrafts = stepCrafts, extraCrafts = extraCrafts }
end

-- 從候選路線挑最省的（沒價格的項目越少越優先）
local function pickRoute(prof, S, T)
  local vs = D.variants[prof]
  if not auctionator() then return vs[D.defaultVariant[prof]], calcRoute(vs[D.defaultVariant[prof]], S, T), #vs end
  local best, bestR
  for _, v in ipairs(vs) do
    local r = calcRoute(v, S, T)
    if not bestR or r.missing < bestR.missing or (r.missing == bestR.missing and r.total < bestR.total) then best, bestR = v, r end
  end
  return best, bestR, #vs
end

-- ── 中間材料：自己做比較便宜就拆成原料 ───────────────────────────────────
-- 配方來源：8 個專業衝級路線裡的步驟（永恆實際資料）＋經典版冶煉表（採礦）
local SMELT = { -- { 產物, 一次做幾個, 最低點數, { 材料, 數量 }... }
  { 2840, 1, 1,   { 2770, 1 } },             -- 銅錠 ← 銅礦石
  { 3576, 1, 65,  { 2771, 1 } },             -- 錫錠 ← 錫礦石
  { 2841, 2, 65,  { 2840, 1 }, { 3576, 1 } }, -- 青銅錠 ×2 ← 銅錠＋錫錠
  { 2842, 1, 75,  { 2775, 1 } },             -- 銀錠 ← 銀礦石
  { 3575, 1, 125, { 2772, 1 } },             -- 鐵錠 ← 鐵礦石
  { 3577, 1, 155, { 2776, 1 } },             -- 金錠 ← 金礦石
  { 3859, 1, 165, { 3575, 1 }, { 3857, 1 } }, -- 鋼錠 ← 鐵錠＋煤炭
  { 3860, 1, 175, { 3858, 1 } },             -- 秘銀錠 ← 秘銀礦石
  { 6037, 1, 230, { 7911, 1 } },             -- 真銀錠 ← 真銀礦石
  { 11371, 1, 230, { 11370, 8 } },           -- 黑鐵錠 ← 黑鐵礦石 ×8
  { 12359, 1, 250, { 10620, 1 } },           -- 瑟銀錠 ← 瑟銀礦石
}
local RECIPES -- [產物] = { prof, minSkill, yield, mats = { {id, 每次數量} } }
local function recipes()
  if RECIPES then return RECIPES end
  RECIPES = {}
  for _, r in ipairs(SMELT) do
    local mats = {}
    for i = 4, #r do table.insert(mats, { r[i][1], r[i][2] }) end
    RECIPES[r[1]] = { prof = "mining", minSkill = r[3], yield = r[2], mats = mats }
  end
  for prof, vs in pairs(D.variants) do
    for _, v in ipairs(vs) do
      for _, st in ipairs(v.steps) do
        if st.k == "i" and #st.m > 0 then
          local cur = RECIPES[st.id]
          if not cur then
            local mats = {}
            for _, m in ipairs(st.m) do table.insert(mats, { m[1], m[2] / st.c }) end
            RECIPES[st.id] = { prof = prof, minSkill = st.f, yield = v.yields[st.id] or 1, mats = mats }
          elseif cur.prof == prof and st.f < cur.minSkill then
            cur.minSkill = st.f
          end
        end
      end
    end
  end
  return RECIPES
end

-- 只拆你做得出來的：要學了那個專業，點數也要夠
local function canCraft(id, learned)
  local rec = recipes()[id]
  if not rec then return nil end
  local L = learned[rec.prof]
  if not L or L.cur < rec.minSkill then return nil end
  return rec
end

-- 每個的成本：直接買和自己做取便宜的；回傳 成本, 是否自己做
local function bestCost(id, learned, depth, memo)
  if memo[id] ~= nil then return memo[id][1], memo[id][2] end
  local buy = price(id)
  local craft
  local rec = depth < 4 and canCraft(id, learned)
  if rec then
    local sum = 0
    for _, m in ipairs(rec.mats) do
      local c = bestCost(m[1], learned, depth + 1, memo)
      if not c then sum = nil; break end
      sum = sum + c * m[2]
    end
    if sum then craft = sum / rec.yield end
  end
  local useCraft = craft ~= nil and (buy == nil or craft < buy)
  local v = useCraft and craft or buy
  memo[id] = { v, useCraft }
  return v, useCraft
end

-- 把購物清單裡的中間材料拆開；回傳新的清單、要自己做的中間材料
local function decompose(r, learned)
  local memo, final, order, crafts, craftIdx = {}, {}, {}, {}, {}
  local function addMat(id, q)
    if not final[id] then final[id] = 0; table.insert(order, id) end
    final[id] = final[id] + q
  end
  local function expand(id, q, depth)
    local _, useCraft = bestCost(id, learned, depth, memo)
    if not useCraft then addMat(id, q); return end
    local rec = canCraft(id, learned)
    local c = craftIdx[id]
    if not c then
      c = { id = id, qty = 0, have = have(id), rec = rec, buyUnit = price(id), unit = bestCost(id, learned, depth, memo) }
      craftIdx[id] = c; table.insert(crafts, c)
    end
    local before = math.max(0, c.qty - c.have)
    c.qty = c.qty + q
    local need = math.max(0, c.qty - c.have) - before -- 已有的中間材料先用掉
    if need <= 0 then return end
    local nBefore = math.ceil(before / rec.yield - 1e-9)
    local nAfter = math.ceil((before + need) / rec.yield - 1e-9)
    local n = nAfter - nBefore
    if n <= 0 then return end
    for _, m in ipairs(rec.mats) do expand(m[1], math.ceil(n * m[2] - 1e-9), depth + 1) end
  end
  local out = {}
  for _, it in ipairs(r.list) do
    if it.kind == "mat" then expand(it.id, it.qty, 0) else table.insert(out, it) end
  end
  if #crafts == 0 then return r end
  for _, c in ipairs(crafts) do
    c.kind = "craft"
    c.n = math.ceil(math.max(0, c.qty - c.have) / c.rec.yield - 1e-9)
    c.buy = 0
    if c.buyUnit and c.unit then c.saved = (c.buyUnit - c.unit) * math.max(0, c.qty - c.have) end
    table.insert(out, c)
  end
  local total, missing = 0, 0
  for _, it in ipairs(out) do
    if it.kind ~= "craft" and it.unit then total = total + it.unit * it.buy elseif it.kind ~= "craft" and it.buy > 0 then missing = missing + 1 end
  end
  for _, id in ipairs(order) do
    local it = { id = id, qty = final[id], kind = "mat", unit = price(id), have = have(id) }
    it.buy = math.max(0, it.qty - it.have)
    if it.unit then total = total + it.unit * it.buy elseif it.buy > 0 then missing = missing + 1 end
    table.insert(out, it)
  end
  local rank = { recipe = 1, tool = 2, craft = 3, mat = 4 }
  table.sort(out, function(a, b)
    if rank[a.kind] ~= rank[b.kind] then return rank[a.kind] < rank[b.kind] end
    return (a.unit or 0) * (a.buy or 0) > (b.unit or 0) * (b.buy or 0)
  end)
  local saved = 0
  for _, c in ipairs(crafts) do saved = saved + (c.saved or 0) end
  return { list = out, total = total, missing = missing, stepCrafts = r.stepCrafts, extraCrafts = r.extraCrafts,
    crafts = crafts, saved = saved, totalBefore = r.total }
end

-- ── 視窗 ───────────────────────────────────────────────────────────────────
local W, ROW_H, MAXLINES, TOP, GAP = 600, 24, 20, 170, 16
local frame, offset = nil, 0
local TABS = {
  steps = { { "等級", 80, "RIGHT" }, { "製作", 220, "LEFT", true }, { "次數", 56, "RIGHT" }, { "來源", 140, "LEFT" } },
  shop = { { "物品", 220, "LEFT", true }, { "需要", 52, "RIGHT" }, { "已有", 52, "RIGHT" }, { "要買", 52, "RIGHT" }, { "單價", 90, "RIGHT" }, { "小計", 100, "RIGHT" } },
}
local NCOL = 6
local current -- 最近一次計算的結果

local function measure(fs)
  if fs.GetUnboundedStringWidth then
    local w = fs:GetUnboundedStringWidth()
    if type(w) == "number" and w > 0 then return w end
  end
  local w = fs.GetStringWidth and fs:GetStringWidth()
  return type(w) == "number" and w or 0
end

local function profList(learned)
  local list = {}
  for _, p in ipairs(PROFS) do if learned[p.key] then table.insert(list, p) end end
  for _, p in ipairs(PROFS) do if not learned[p.key] then table.insert(list, p) end end
  return list
end

local function autoFit(cols)
  local x = 0
  for c = 1, NCOL do
    local col = cols[c]
    local hf = frame.headFs[c]
    if col then
      local iconW = col[4] and 26 or 0
      local w = math.max(col[2], measure(hf) + 4)
      for i = 1, MAXLINES do
        local l = frame.lines[i]
        if l.used then w = math.max(w, measure(l.c[c]) + 4 + iconW) end
      end
      w = math.ceil(w)
      hf:ClearAllPoints(); hf:SetPoint("LEFT", frame.head, "LEFT", x, 0); hf:SetWidth(w); hf:SetJustifyH(col[3]); hf:Show()
      for i = 1, MAXLINES do
        local l = frame.lines[i]
        l.c[c]:ClearAllPoints(); l.c[c]:SetPoint("LEFT", l, "LEFT", x + iconW, 0); l.c[c]:SetWidth(w - iconW); l.c[c]:SetJustifyH(col[3]); l.c[c]:Show()
        if col[4] then l.icon:ClearAllPoints(); l.icon:SetPoint("LEFT", l, "LEFT", x, 0) end
      end
      x = x + w + GAP
    else
      hf:Hide()
      for i = 1, MAXLINES do frame.lines[i].c[c]:Hide() end
    end
  end
  local total = math.max(x - GAP, W)
  frame.head:SetWidth(total)
  for i = 1, MAXLINES do frame.lines[i]:SetWidth(total) end
  frame:SetWidth(total + 28)
end

local function refreshImpl()
  if not frame or not frame:IsShown() then return end
  priceCache = {}
  local learned = learnedProfs()
  local list = profList(learned)
  if not db.prof or not PROF_BY_KEY[db.prof] then db.prof = list[1].key end
  local p = PROF_BY_KEY[db.prof]
  local L = learned[p.key]
  local S = tonumber(db.from[p.key]) or (L and L.cur) or 1
  local T = tonumber(db.to[p.key]) or 300
  S = math.max(1, math.min(299, math.floor(S)))
  T = math.max(S + 1, math.min(300, math.floor(T)))
  frame.profBtn:SetText(p.name .. (L and string.format("（%d）", L.cur) or "（沒學）"))
  if not frame.fromBox:HasFocus() then frame.fromBox:SetText(tostring(S)) end
  if not frame.toBox:HasFocus() then frame.toBox:SetText(tostring(T)) end
  local route, r, nVar = pickRoute(p.key, S, T)
  if db.decompose then r = decompose(r, learned) end
  current = { prof = p, S = S, T = T, route = route, r = r }
  local api = auctionator()
  frame.status:SetText(api and string.format("價格：Auctionator　從 %d 條路線選出最省的", nVar)
    or "|cffff9d5c沒有偵測到 Auctionator，只有商人物品有價格（使用預設路線）|r")
  frame.total:SetText(string.format("%s %d–%d　預計花費 %s%s%s", p.name, S, T, money(r.total),
    (r.saved and r.saved > 0.5) and ("　|cff9fd18b自己做中間材料省 " .. money(r.saved) .. "|r") or "",
    r.missing > 0 and string.format("　|cffff9d5c%d 項沒有價格|r", r.missing) or ""))
  frame.decBtn:SetText(db.decompose and "拆中間材料：開" or "拆中間材料：關")
  for _, t in ipairs({ { frame.stepsBtn, "steps" }, { frame.shopBtn, "shop" } }) do
    local on = db.tab == t[2]
    t[1]:GetFontString():SetTextColor(on and 1 or .55, on and .82 or .52, on and 0 or .45)
  end
  frame.atrBtn:SetShown(api ~= nil and api.CreateShoppingList ~= nil)
  -- 內容
  local cols = TABS[db.tab]
  for c = 1, NCOL do frame.headFs[c]:SetText(cols[c] and cols[c][1] or "") end
  local rows = {}
  if db.tab == "steps" then
    local cs = r.crafts or {}
    for i = #cs, 1, -1 do -- 先做最底層的（例如先冶煉銅錠、錫錠，再做青銅錠）
      if cs[i].n > 0 then table.insert(rows, { prep = cs[i] }) end
    end
    for i, s in ipairs(route.steps) do
      local n = r.stepCrafts[i] + r.extraCrafts[i]
      if n > 0 then table.insert(rows, { step = s, n = n, extra = r.extraCrafts[i] }) end
    end
  else
    for _, it in ipairs(r.list) do table.insert(rows, { item = it }) end
  end
  local maxOff = math.max(0, #rows - MAXLINES)
  if offset > maxOff then offset = maxOff end
  local shown = 0
  for i = 1, MAXLINES do
    local l, e = frame.lines[i], rows[i + offset]
    l.e = e
    l.used = e ~= nil
    if e then
      shown = i
      local vals
      if e.prep then
        local c = e.prep
        local name, icon, col = info("i", c.id)
        l.icon:SetTexture(icon); l.icon:Show()
        local pn = c.rec.prof == "mining" and "採礦" or (PROF_BY_KEY[c.rec.prof] and PROF_BY_KEY[c.rec.prof].name or "")
        vals = { "準備", name, "×" .. c.n, "自己做（" .. pn .. "）" }
        l.c[2]:SetTextColor(col[1], col[2], col[3])
      elseif e.step then
        local s = e.step
        local lo, hi = math.max(s.f, S), math.min(s.t, T)
        local name, icon, col = info(s.k, s.id)
        l.icon:SetTexture(icon); l.icon:Show()
        vals = { hi > lo and (lo .. "–" .. hi) or "—", name, "×" .. e.n, srcName(s.src) }
        l.c[2]:SetTextColor(col[1], col[2], col[3])
      else
        local it = e.item
        local name, icon, col = info("i", it.id)
        l.icon:SetTexture(icon); l.icon:Show()
        local tag = it.kind == "recipe" and "|cfff0cf7f（配方）|r" or (D.vendor[it.id] and "|cff9fd18b（商人）|r" or "")
        if it.kind == "craft" then
          vals = { name .. string.format("|cff8cc4ff（自己做 ×%d）|r", it.n), it.qty, it.have > 0 and ("|cff9fd18b" .. it.have .. "|r") or "0", "—",
            it.unit and ("自製 " .. money(it.unit)) or "—", it.saved and ("|cff9fd18b省 " .. money(it.saved) .. "|r") or "—" }
        else
          vals = { name .. tag, it.qty, it.have > 0 and ("|cff9fd18b" .. it.have .. "|r") or "0", it.buy,
            it.unit and money(it.unit) or "|cffff9d5c沒價格|r", it.unit and money(it.unit * it.buy) or "—" }
        end
        l.c[1]:SetTextColor(col[1], col[2], col[3])
      end
      for c = 1, NCOL do l.c[c]:SetText(vals[c] or "") end
      if e.step then l.c[1]:SetTextColor(.94, .81, .5) end
      l:Show()
    else
      l:Hide()
    end
  end
  frame.foot:SetText(#rows == 0 and "這個範圍不需要製作任何東西"
    or (#rows > MAXLINES and string.format("共 %d 列，用滾輪捲動", #rows) or ""))
  frame.foot:ClearAllPoints(); frame.foot:SetPoint("TOPLEFT", 14, -(TOP + shown * ROW_H + 6))
  frame:SetHeight(TOP + shown * ROW_H + (frame.foot:GetText() ~= "" and 36 or 18))
  autoFit(cols)
end

local refreshPending = false
function ProfLevel_Refresh()
  if refreshPending then return end
  refreshPending = true
  C_Timer.After(0.1, function() refreshPending = false; safe("比較表", refreshImpl) end)
end

local function createShoppingList()
  local api = auctionator()
  if not api or not api.CreateShoppingList or not current then return end
  local terms = {}
  for _, it in ipairs(current.r.list) do
    if it.buy > 0 and not D.vendor[it.id] then
      local name = info("i", it.id)
      local ok, s = pcall(api.ConvertToSearchString, CALLER, { searchString = name, isExact = true, quantity = it.buy })
      table.insert(terms, ok and s or ('"' .. name .. '"'))
    end
  end
  if #terms == 0 then msg("沒有要在拍賣行買的東西"); return end
  local listName = string.format("專業衝級 %s %d-%d", current.prof.name, current.S, current.T)
  if safe("建立購物清單", api.CreateShoppingList, CALLER, listName, terms) then
    msg(string.format("已建立 Auctionator 購物清單「%s」，共 %d 項（已扣掉背包和銀行裡的數量，商人物品不列入）", listName, #terms))
  end
end

local function button(parent, w, label, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(w + 16, 26); b:SetText(label); b:SetScript("OnClick", onClick)
  return b
end

local function numBox(parent, onSet)
  local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  e:SetSize(46, 24); e:SetAutoFocus(false); e:SetNumeric(true); e:SetMaxLetters(3)
  local function commit(self) onSet(tonumber(self:GetText())); self:ClearFocus(); ProfLevel_Refresh() end
  e:SetScript("OnEnterPressed", commit)
  e:SetScript("OnEditFocusLost", function(self) onSet(tonumber(self:GetText())); ProfLevel_Refresh() end)
  e:SetScript("OnEscapePressed", function(self) self:ClearFocus(); ProfLevel_Refresh() end)
  return e
end

local function buildFrame()
  frame = CreateFrame("Frame", "ProfLevelFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(W + 28, 300); frame:SetPoint("CENTER"); frame:SetScale(db.scale or 1)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetFrameStrata("DIALOG")
  tinsert(UISpecialFrames, "ProfLevelFrame")
  if not frame.TitleText then
    frame.TitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.TitleText:SetPoint("TOP", 0, -5)
  end
  frame.TitleText:SetText("專業衝級")
  local logo = frame:CreateTexture(nil, "OVERLAY"); logo:SetTexture(ICON); logo:SetSize(18, 18); logo:SetPoint("TOPLEFT", 6, -3)
  -- 第一列：專業切換、起點、目標
  frame.prevBtn = button(frame, 24, "<", function() end)
  frame.prevBtn:SetPoint("TOPLEFT", 12, -30)
  frame.profBtn = button(frame, 130, "", function() end)
  frame.profBtn:SetPoint("LEFT", frame.prevBtn, "RIGHT", 2, 0)
  frame.nextBtn = button(frame, 24, ">", function() end)
  frame.nextBtn:SetPoint("LEFT", frame.profBtn, "RIGHT", 2, 0)
  local function cycle(d)
    local list = profList(learnedProfs())
    local idx = 1
    for i, p in ipairs(list) do if p.key == db.prof then idx = i end end
    db.prof = list[(idx - 1 + d) % #list + 1].key; offset = 0; ProfLevel_Refresh()
  end
  frame.prevBtn:SetScript("OnClick", function() cycle(-1) end)
  frame.nextBtn:SetScript("OnClick", function() cycle(1) end)
  frame.profBtn:SetScript("OnClick", function() cycle(1) end)
  local fromLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fromLbl:SetText("從")
  fromLbl:SetPoint("LEFT", frame.nextBtn, "RIGHT", 12, 0)
  frame.fromBox = numBox(frame, function(v) db.from[db.prof] = v end)
  frame.fromBox:SetPoint("LEFT", fromLbl, "RIGHT", 8, 0)
  local toLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); toLbl:SetText("到")
  toLbl:SetPoint("LEFT", frame.fromBox, "RIGHT", 8, 0)
  frame.toBox = numBox(frame, function(v) db.to[db.prof] = v end)
  frame.toBox:SetPoint("LEFT", toLbl, "RIGHT", 8, 0)
  frame.nowBtn = button(frame, 52, "目前", function() db.from[db.prof] = nil; ProfLevel_Refresh() end)
  frame.nowBtn:SetPoint("LEFT", frame.toBox, "RIGHT", 6, 0)
  frame.nowBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine("起點改回目前的專業點數"); GameTooltip:Show()
  end)
  frame.nowBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第二、三列：價格來源、總花費
  frame.status = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame.status:SetPoint("TOPLEFT", 14, -66); frame.status:SetJustifyH("LEFT"); frame.status:SetWordWrap(false)
  frame.total = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.total:SetPoint("TOPLEFT", 14, -88); frame.total:SetJustifyH("LEFT"); frame.total:SetWordWrap(false)
  -- 分頁與購物清單按鈕
  frame.stepsBtn = button(frame, 60, "步驟", function() db.tab = "steps"; offset = 0; ProfLevel_Refresh() end)
  frame.shopBtn = button(frame, 76, "購物清單", function() db.tab = "shop"; offset = 0; ProfLevel_Refresh() end)
  frame.atrBtn = button(frame, 160, "建立 Auctionator 購物清單", function() safe("建立購物清單", createShoppingList) end)
  frame.atrBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("建立 Auctionator 購物清單")
    GameTooltip:AddLine("數量已扣掉背包和銀行裡的；商人販售的物品不列入。在拍賣行打開 Auctionator 的購物分頁就能用。", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.atrBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 表頭與內容
  local head = CreateFrame("Frame", nil, frame); head:SetSize(W, 22); head:SetPoint("TOPLEFT", 14, -(TOP - 26))
  local line = head:CreateTexture(nil, "ARTWORK"); line:SetColorTexture(1, 1, 1, .12); line:SetHeight(1)
  line:SetPoint("BOTTOMLEFT", head, "BOTTOMLEFT", 0, -1); line:SetPoint("BOTTOMRIGHT", head, "BOTTOMRIGHT", 0, -1)
  frame.head, frame.headFs = head, {}
  for c = 1, NCOL do
    local fs = head:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fs:SetWordWrap(false); fs:SetTextColor(.6, .57, .5)
    frame.headFs[c] = fs
  end
  -- 分頁按鈕自成一列（在花費那行下面、表頭上面），不會壓到文字
  frame.stepsBtn:SetPoint("TOPLEFT", 12, -116)
  frame.shopBtn:SetPoint("LEFT", frame.stepsBtn, "RIGHT", 2, 0)
  frame.decBtn = button(frame, 120, "", function() db.decompose = not db.decompose; ProfLevel_Refresh() end)
  frame.decBtn:SetPoint("LEFT", frame.shopBtn, "RIGHT", 10, 0)
  frame.decBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("拆中間材料")
    GameTooltip:AddLine("開：每個中間材料都比較「直接買」和「買原料自己做」，便宜的那個才列進清單。只拆你學過、點數也夠的配方（冶煉要有採礦）。", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.decBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  frame.atrBtn:SetPoint("TOPRIGHT", -12, -116)
  frame.lines = {}
  for i = 1, MAXLINES do
    local l = CreateFrame("Frame", nil, frame)
    l:SetSize(W, ROW_H); l:SetPoint("TOPLEFT", 14, -TOP - (i - 1) * ROW_H)
    if i % 2 == 0 then local bg = l:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(1, 1, 1, .035) end
    l.icon = l:CreateTexture(nil, "ARTWORK"); l.icon:SetSize(20, 20)
    l.c = {}
    for c = 1, NCOL do
      local fs = l:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fs:SetWordWrap(false)
      l.c[c] = fs
    end
    l:EnableMouse(true)
    l:SetScript("OnEnter", function(self)
      local e = self.e; if not e then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      if e.prep then
        local c = e.prep
        pcall(GameTooltip.SetItemByID, GameTooltip, c.id)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format("自己做 %d 次（共 %d 個，已有 %d）", c.n, c.qty, c.have), 1, .82, 0, true)
        local mats = {}
        for _, m in ipairs(c.rec.mats) do table.insert(mats, string.format("%s ×%d", (info("i", m[1])), math.ceil(c.n * m[2] - 1e-9))) end
        GameTooltip:AddLine("材料：" .. table.concat(mats, "、"), 1, 1, 1, true)
        if c.buyUnit and c.unit then GameTooltip:AddLine(string.format("直接買每個 %s，自己做每個 %s", money(c.buyUnit), money(c.unit)), .8, .8, .8, true) end
      elseif e.step then
        local s = e.step
        if s.k == "s" then pcall(GameTooltip.SetSpellByID, GameTooltip, s.id) else pcall(GameTooltip.SetItemByID, GameTooltip, s.id) end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format("做 %d 次%s", e.n, e.extra > 0 and string.format("（其中 %d 次是多做的，留給後面步驟當材料）", e.extra) or ""), 1, .82, 0, true)
        local mats = {}
        for _, m in ipairs(s.m) do
          local nm = info("i", m[1])
          table.insert(mats, string.format("%s ×%d", nm, math.ceil(e.n * m[2] / s.c)))
        end
        if #mats > 0 then GameTooltip:AddLine("材料：" .. table.concat(mats, "、"), 1, 1, 1, true) end
        if s.d and #s.d == 4 then
          GameTooltip:AddLine(string.format("難度：|cffff8040%s|r |cffffff00%s|r |cff40bf40%s|r |cff808080%s|r", s.d[1], s.d[2], s.d[3], s.d[4]), .8, .8, .8)
        end
      else
        pcall(GameTooltip.SetItemByID, GameTooltip, e.item.id)
        local c = e.item
        if c.kind == "craft" then
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine(string.format("比價：直接買每個 %s，自己做每個 %s → 自己做", c.buyUnit and money(c.buyUnit) or "沒價格", money(c.unit or 0)), .55, .75, 1, true)
        end
      end
      GameTooltip:Show()
    end)
    l:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.lines[i] = l
  end
  frame:EnableMouseWheel(true)
  frame:SetScript("OnMouseWheel", function(_, delta) offset = math.max(0, offset - delta * 3); ProfLevel_Refresh() end)
  frame.foot = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame:SetScript("OnShow", function() safe("比較表", refreshImpl) end)
  frame:Hide()
end

local function toggleWindow()
  if not frame then buildFrame() end
  if frame:IsShown() then frame:Hide() else frame:Show() end
end

-- ── 小地圖按鈕 ─────────────────────────────────────────────────────────────
local mmBtn
local function placeMinimap()
  local a = math.rad(db.minimapAngle or 200)
  local r = (Minimap:GetWidth() / 2) + 5
  mmBtn:ClearAllPoints()
  mmBtn:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
end
local function buildMinimapButton()
  if mmBtn or not Minimap then return end
  local b = CreateFrame("Button", "ProfLevelMinimapButton", Minimap)
  mmBtn = b
  b:SetSize(31, 31); b:SetFrameStrata("MEDIUM"); b:SetFrameLevel(8)
  b:RegisterForClicks("LeftButtonUp"); b:RegisterForDrag("LeftButton")
  b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local bg = b:CreateTexture(nil, "BACKGROUND"); bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  bg:SetSize(20, 20); bg:SetPoint("TOPLEFT", 7, -5)
  local icon = b:CreateTexture(nil, "ARTWORK"); icon:SetTexture(ICON); icon:SetSize(20, 20); icon:SetPoint("TOPLEFT", 6, -5)
  if icon.SetMask then pcall(icon.SetMask, icon, "Interface\\CharacterFrame\\TempPortraitAlphaMask") end
  local border = b:CreateTexture(nil, "OVERLAY"); border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(53, 53); border:SetPoint("TOPLEFT")
  b:SetScript("OnClick", toggleWindow)
  b:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
      local mx, my = Minimap:GetCenter()
      local cx, cy = GetCursorPosition()
      local sc = Minimap:GetEffectiveScale()
      db.minimapAngle = math.deg(math.atan2(cy / sc - my, cx / sc - mx))
      placeMinimap()
    end)
  end)
  b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
  b:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("專業衝級計算器")
    GameTooltip:AddLine("左鍵：開關視窗", 1, 1, 1)
    GameTooltip:AddLine("拖曳：沿著小地圖移動", .6, .6, .6)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  placeMinimap()
  if db.minimapHide then b:Hide() end
end

-- ── 指令 ───────────────────────────────────────────────────────────────────
SLASH_PROFLEVEL1 = "/prof"
SLASH_PROFLEVEL2 = "/proflevel"
SlashCmdList.PROFLEVEL = function(input)
  ensureDB()
  local cmd = (input or ""):lower():match("^%s*(%S*)")
  if cmd == "" then toggleWindow()
  elseif cmd == "minimap" then
    db.minimapHide = not db.minimapHide
    if mmBtn then if db.minimapHide then mmBtn:Hide() else mmBtn:Show() end end
    msg("小地圖按鈕：" .. (db.minimapHide and "隱藏（再輸入 /prof minimap 顯示）" or "顯示"))
  elseif cmd == "scale" then
    local v = tonumber((input or ""):match("scale%s+([%d%.]+)"))
    if v and v >= 0.5 and v <= 2 then db.scale = v; if frame then frame:SetScale(v) end; msg("視窗縮放：" .. v)
    else msg("用法：/prof scale 1.2（0.5～2，目前 " .. (db.scale or 1) .. "）") end
  elseif cmd == "debug" then
    local learned = learnedProfs()
    local t = {}
    for _, p in ipairs(PROFS) do if learned[p.key] then table.insert(t, p.name .. " " .. learned[p.key].cur .. "/" .. learned[p.key].max) end end
    msg("版本 0.2.0　已學專業：" .. (#t > 0 and table.concat(t, "、") or "沒偵測到"))
    msg("Auctionator：" .. (auctionator() and "有" or "沒有"))
    -- 專業視窗 API（下一版做製作佇列、利潤表會用到）：打開專業視窗再執行
    local T = C_TradeSkillUI
    if T and T.GetAllRecipeIDs then
      local ok, ids = pcall(T.GetAllRecipeIDs)
      local n = ok and type(ids) == "table" and #ids or 0
      local base = T.GetBaseProfessionInfo and select(2, pcall(T.GetBaseProfessionInfo))
      msg(string.format("專業視窗 API：新版　配方 %d 個　目前專業：%s　CraftRecipe：%s", n,
        type(base) == "table" and tostring(base.professionName or base.professionID) or "未開啟",
        T.CraftRecipe and "有" or "沒有"))
      if n > 0 then
        local id = ids[1]
        local okI, ri = pcall(T.GetRecipeInfo, id)
        local okS, sc = pcall(T.GetRecipeSchematic, id, false)
        local reag = 0
        if okS and type(sc) == "table" and type(sc.reagentSlotSchematics) == "table" then reag = #sc.reagentSlotSchematics end
        msg(string.format("第一個配方 %d：%s　產物 %s　材料欄 %d　可做 %s", id,
          okI and type(ri) == "table" and tostring(ri.name) or "?", okS and type(sc) == "table" and tostring(sc.outputItemID) or "?",
          reag, okI and type(ri) == "table" and tostring(ri.numAvailable) or "?"))
      end
    elseif GetNumTradeSkills then
      msg("專業視窗 API：舊版　配方列 " .. tostring(GetNumTradeSkills()) .. " 列")
    else
      msg("專業視窗 API：沒有")
    end
  else
    msg("/prof 開關視窗　/prof scale 1.2 調整視窗大小　/prof minimap 隱藏小地圖按鈕　/prof debug 列出偵測結果")
  end
end

-- ── 事件 ───────────────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
local REFRESH_EVENTS = { SKILL_LINES_CHANGED = true, TRADE_SKILL_LIST_UPDATE = true, BAG_UPDATE_DELAYED = true,
  GET_ITEM_INFO_RECEIVED = true, AUCTION_HOUSE_CLOSED = true, CHAT_MSG_SKILL = true }
ev:SetScript("OnEvent", function(_, e, a1)
  if e == "ADDON_LOADED" and a1 == ADDON then
    ensureDB()
  elseif e == "PLAYER_LOGIN" then
    ensureDB()
    safe("小地圖按鈕", buildMinimapButton)
  elseif REFRESH_EVENTS[e] then
    if frame and frame:IsShown() then ProfLevel_Refresh() end
  end
end)
for _, e in ipairs({ "ADDON_LOADED", "PLAYER_LOGIN" }) do pcall(ev.RegisterEvent, ev, e) end
for e in pairs(REFRESH_EVENTS) do pcall(ev.RegisterEvent, ev, e) end
