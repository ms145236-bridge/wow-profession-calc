-- 專業助手（魔獸世界：永恆）
-- 依 Auctionator 的價格，從候選路線挑最省的一條，列出每段要做什麼、做幾次，以及要買的材料與花費。
-- 自動偵測已學專業與目前點數、扣掉背包與銀行已有的材料，可一鍵建立 Auctionator 購物清單。

local ADDON, NS = ... -- NS：跟 Guild.lua 共用
local D = ProfLevel_Data
local CALLER = "ProfLevel" -- 呼叫 Auctionator API 用的名稱
local ICON = "Interface\\AddOns\\ShengProfession\\Media\\Logo"
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
local DEFAULTS = { prof = nil, from = {}, to = {}, tab = "profit", minimapAngle = 200, minimapHide = false, scale = 1.25, decompose = true, useBag = true, useBank = true, recipes = {}, queue = {}, psort = "profit", pdesc = true, dock = false }
local db

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage("|cff4fc3f7阿聖|r|cffd9b25f專業幫手|r " .. s) end
local reported = {}
-- 錯誤存進存檔（登出後開發者讀得到），同一種錯誤只記一筆、算次數，最多 50 種
local function logError(where, err)
  if type(ProfLevelCharDB) == "table" then
    local log = ProfLevelCharDB.errors or {}
    ProfLevelCharDB.errors = log
    local key = where .. "：" .. err
    if log[key] then log[key].n = log[key].n + 1; log[key].t = date("%m/%d %H:%M")
    elseif #(log.keys or {}) < 50 then
      log.keys = log.keys or {}
      log.keys[#log.keys + 1] = key
      log[key] = { n = 1, t = date("%m/%d %H:%M") }
    end
  end
end
local function safe(where, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then
    err = tostring(err)
    logError(where, err)
    if not reported[err] then reported[err] = true; msg("|cffff7b7b" .. where .. "出錯：|r" .. err .. "　請把這行回報給開發者") end
  end
  return ok
end
local function ensureDB()
  if db then return db end
  ProfLevelCharDB = ProfLevelCharDB or {}
  for k, v in pairs(DEFAULTS) do if ProfLevelCharDB[k] == nil then ProfLevelCharDB[k] = type(v) == "table" and {} or v end end
  db = ProfLevelCharDB
  if (db.dockV or 0) < 2 then db.dock = false; db.dockV = 2 end -- 自動開改成預設關閉（點了才打開）
  if db.tabV ~= 1 then db.tab = "profit"; db.tabV = 1 end -- 主體改成利潤與佇列，衝級變成其中一個分頁
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
-- 只有升階提示用到的專業（沒有衝級路線）
local EXTRA = { { key = "herbalism", name = "草藥學", line = 182 }, { key = "skinning", name = "剝皮", line = 393 }, { key = "fishing", name = "釣魚", line = 356 } }
local EXTRA_BY_LINE, EXTRA_BY_NAME = {}, { ["草藥"] = EXTRA[1] }
for _, p in ipairs(EXTRA) do EXTRA_BY_LINE[p.line] = p; EXTRA_BY_NAME[p.name] = p end

-- 已學的專業與目前點數：{ [key] = { cur, max } }；all 為真時連草藥、剝皮、釣魚也算
local function learnedProfs(all)
  local out = {}
  if GetProfessions and GetProfessionInfo then
    local n = select("#", GetProfessions())
    local list = { GetProfessions() }
    for i = 1, n do
      local idx = list[i]
      if idx then
        local ok, name, _, cur, mx, _, _, line = pcall(GetProfessionInfo, idx)
        local p = ok and (PROF_BY_LINE[line] or PROF_BY_NAME[name] or (all and (EXTRA_BY_LINE[line] or EXTRA_BY_NAME[name])))
        if p then out[p.key] = { cur = cur or 1, max = mx or 300 } end
      end
    end
  end
  if not next(out) and GetNumSkillLines and GetSkillLineInfo then -- 經典版的讀法
    for i = 1, GetNumSkillLines() do
      local name, isHeader, _, rank, _, _, maxRank = GetSkillLineInfo(i)
      local p = not isHeader and (PROF_BY_NAME[name] or (all and EXTRA_BY_NAME[name]))
      if p then out[p.key] = { cur = rank or 1, max = maxRank or 300 } end
    end
  end
  return out
end

-- ── 升階提示 ───────────────────────────────────────────────────────────────
local TRAIN = ProfLevel_Trainers or {}
-- 下一階的資料：上限 150 要學專家、225 要學大師；其他上限回傳 nil
local function nextRank(key, L)
  local t = L and TRAIN[key]
  local rk = t and ((L.max == 150 and "expert") or (L.max == 225 and "master"))
  if rk and t[rk] then return t[rk], rk == "expert" and "專家" or "大師" end
end
-- 一行說明，例如「下一階 大師：斯通納德 羅格瓦爾（35 級、技能 200、5 金）」；第二個回傳值：角色等級還不夠
local function rankText(key, L)
  local R, label = nextRank(key, L)
  if not R then return end
  local a = R.at[1]
  local need = {}
  if R.level then need[#need + 1] = R.level .. " 級" end
  need[#need + 1] = "技能 " .. R.skill
  if R.cost >= 10000 then need[#need + 1] = (R.cost / 10000) .. " 金" elseif R.cost > 0 then need[#need + 1] = (R.cost / 100) .. " 銀" end
  local how = (R.book and ("　買《" .. R.book .. "》")) or (R.quest and ("　任務「" .. R.quest .. "」")) or ""
  return string.format("下一階 %s：%s %s%s（%s）", label, a.place, a.name, how, table.concat(need, "、")),
    (R.level or 0) > (UnitLevel("player") or 0), R
end
local function goTo(a)
  if not (a and a.map) then return end
  local api = WaypointUIAPI and WaypointUIAPI.Navigation
  if api and type(api.NewUserNavigation) == "function"
    and pcall(api.NewUserNavigation, { name = a.name, mapID = a.map, x = a.x, y = a.y, flags = "ShengProfession" }) then return end
  pcall(function()
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(a.map, a.x / 100, a.y / 100))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  end)
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

-- 拍賣場在架數量：Auctionator 每次掃描記下「當天看到的最多在架數量」（遊戲沒有成交量資料）
local function ahStats(id)
  local dbx = Auctionator and Auctionator.Database and Auctionator.Database.db
  local d = type(dbx) == "table" and dbx[tostring(id)]
  if type(d) ~= "table" or type(d.a) ~= "table" then return nil end
  local latest
  for k in pairs(d.a) do local n = tonumber(k); if n and (not latest or n > latest) then latest = n end end
  if not latest then return nil end
  local sum, days, last = 0, 0, 0
  for k, v in pairs(d.a) do
    local n = tonumber(k)
    if n and latest - n < 14 and type(v) == "number" then
      sum = sum + v; days = days + 1
      if n == latest then last = v end
    end
  end
  return { last = last, avg = days > 0 and sum / days or 0, days = days }
end

-- 已有的數量：可設定要不要扣掉背包、銀行裡的
local function have(id)
  local f = (C_Item and C_Item.GetItemCount) or GetItemCount
  if not f or not (db.useBag or db.useBank) then return 0 end
  local okA, all = pcall(f, id, true) -- 背包＋銀行
  local okB, bag = pcall(f, id, false) -- 只有背包
  all, bag = okA and all or 0, okB and bag or 0
  return (db.useBag and bag or 0) + (db.useBank and math.max(0, all - bag) or 0)
end
local function haveText() -- 「已扣掉背包和銀行」這類說明
  if db.useBag and db.useBank then return "已扣掉背包和銀行裡的數量" end
  if db.useBag then return "已扣掉背包裡的數量（不扣銀行）" end
  if db.useBank then return "已扣掉銀行裡的數量（不扣背包）" end
  return "沒有扣掉背包和銀行裡的數量"
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
-- 衝級做出來的成品賣掉能回收多少：產量扣掉後面步驟當材料用掉的，乘拍賣價（扣 5% 手續費）
local function payback(route, r)
  local made, used = {}, {}
  for i, s in ipairs(route.steps) do
    local n = r.stepCrafts[i] + r.extraCrafts[i]
    if n > 0 then
      if s.k == "i" then made[s.id] = (made[s.id] or 0) + n * (route.yields[s.id] or 1) end
      for _, m in ipairs(s.m) do used[m[1]] = (used[m[1]] or 0) + n * m[2] / s.c end
    end
  end
  local value, total = {}, 0
  for id, q in pairs(made) do
    local sellQty = math.max(0, q - (used[id] or 0))
    local pr = (not D.vendor[id]) and price(id)
    if pr and sellQty > 0 then value[id] = pr * sellQty * 0.95; total = total + value[id] end
  end
  local stepVal = {}
  for i, s in ipairs(route.steps) do
    local n = r.stepCrafts[i] + r.extraCrafts[i]
    if n > 0 and s.k == "i" and value[s.id] then stepVal[i] = value[s.id] * n * (route.yields[s.id] or 1) / made[s.id] end
  end
  return total, stepVal
end

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

local current -- 最近一次計算的結果
-- ── 已學配方（打開專業視窗時記下）、利潤、製作佇列 ───────────────────────
local function openProf()
  local T = C_TradeSkillUI
  if T and T.GetBaseProfessionInfo then
    local ok, b = pcall(T.GetBaseProfessionInfo)
    if ok and type(b) == "table" and b.professionID then
      return PROF_BY_LINE[b.professionID] or PROF_BY_NAME[b.professionName or ""]
    end
  end
  if GetTradeSkillLine then
    local name = GetTradeSkillLine()
    if name and name ~= "UNKNOWN" then return PROF_BY_NAME[name] end
  end
end

-- 讀專業視窗裡學會的配方，記在 db.recipes[專業]（關掉視窗後利潤表照樣能用）
local function scanRecipes()
  local p = openProf()
  if not p then return end
  local out, n = {}, 0
  local T = C_TradeSkillUI
  if T and T.GetAllRecipeIDs and T.GetRecipeInfo then
    local ok, ids = pcall(T.GetAllRecipeIDs)
    if not ok or type(ids) ~= "table" then return end
    for _, id in ipairs(ids) do
      local okI, ri = pcall(T.GetRecipeInfo, id)
      if okI and type(ri) == "table" and ri.learned ~= false and not ri.isDummyRecipe and not ri.isRecraft then
        local rec = { name = ri.name, mats = {}, qmin = 1, qmax = 1 }
        local okS, sc = false, nil
        if T.GetRecipeSchematic then okS, sc = pcall(T.GetRecipeSchematic, id, false) end
        if okS and type(sc) == "table" then
          rec.out = sc.outputItemID
          rec.qmin = sc.quantityMin or 1
          rec.qmax = sc.quantityMax or rec.qmin
          for _, slot in ipairs(sc.reagentSlotSchematics or {}) do
            local r1 = type(slot.reagents) == "table" and slot.reagents[1]
            if r1 and r1.itemID and slot.required ~= false then table.insert(rec.mats, { r1.itemID, slot.quantityRequired or 1 }) end
          end
        end
        if rec.out == 0 then rec.out = nil end
        out[id] = rec; n = n + 1
      end
    end
  elseif GetNumTradeSkills and GetTradeSkillInfo then -- 經典版的讀法
    for i = 1, GetNumTradeSkills() do
      local name, kind = GetTradeSkillInfo(i)
      if name and kind ~= "header" and kind ~= "subheader" then
        local link = GetTradeSkillRecipeLink and GetTradeSkillRecipeLink(i)
        local id = link and tonumber(link:match("enchant:(%d+)") or link:match("spell:(%d+)"))
        if id then
          local rec = { name = name, mats = {}, qmin = 1, qmax = 1, index = i }
          local il = GetTradeSkillItemLink and GetTradeSkillItemLink(i)
          rec.out = il and tonumber(il:match("item:(%d+)"))
          if GetTradeSkillNumMade then local lo, hi = GetTradeSkillNumMade(i); rec.qmin, rec.qmax = lo or 1, hi or lo or 1 end
          for j = 1, (GetTradeSkillNumReagents and GetTradeSkillNumReagents(i) or 0) do
            local rl = GetTradeSkillReagentItemLink and GetTradeSkillReagentItemLink(i, j)
            local rid = rl and tonumber(rl:match("item:(%d+)"))
            local _, _, q = GetTradeSkillReagentInfo(i, j)
            if rid then table.insert(rec.mats, { rid, q or 1 }) end
          end
          out[id] = rec; n = n + 1
        end
      end
    end
  end
  if n > 0 then db.recipes[p.key] = out; NS.guildRecipesChanged() end
end

local function bagCount(id) -- 製作只能用背包裡的
  local f = (C_Item and C_Item.GetItemCount) or GetItemCount
  if not f then return 0 end
  local ok, n = pcall(f, id, false)
  return ok and n or 0
end
local function canMakeNow(rec)
  if not rec or #rec.mats == 0 then return 0 end
  local n = math.huge
  for _, m in ipairs(rec.mats) do n = math.min(n, math.floor(bagCount(m[1]) / m[2])) end
  return n
end

-- 成本（材料取「買」和「自己做」較便宜的）、售價（Auctionator 價格扣 5% 手續費）、利潤
local function profitOf(rec, learned)
  local memo, cost = {}, 0
  for _, m in ipairs(rec.mats) do
    local c = bestCost(m[1], learned, 1, memo)
    if not c then cost = nil; break end
    cost = cost + c * m[2]
  end
  if #rec.mats == 0 then cost = nil end
  local sell
  if rec.out and not D.vendor[rec.out] then
    local p = price(rec.out)
    if p then sell = p * (rec.qmin + rec.qmax) / 2 * 0.95 end
  end
  return cost, sell, (cost and sell) and (sell - cost) or nil
end

local function recipeName(q, rec)
  if rec and rec.out then return (info("i", rec.out)) end
  if q and q.out then return (info("i", q.out)) end
  return (rec and rec.name) or (q and q.name) or "?"
end

-- 佇列：db.queue = { { prof, id（配方，可能還不知道）, out（產物）, name, count } }
local function queueAdd(prof, id, out, name, count)
  for i, q in ipairs(db.queue) do
    if q.prof == prof and ((id and q.id == id) or (out and q.out == out)) then
      q.count = q.count + count
      q.id = q.id or id
      if q.count <= 0 then table.remove(db.queue, i) end
      return
    end
  end
  if count > 0 then table.insert(db.queue, { prof = prof, id = id, out = out, name = name, count = count }) end
end

local function findRecipe(prof, out)
  local book = db.recipes[prof]
  if not book or not out then return nil end
  for id, rec in pairs(book) do if rec.out == out then return id end end
end

-- 把衝級路線（含「準備」）依序加入佇列
local function queueRoute()
  if not current then return end
  local r, route, added = current.r, current.route, 0
  local cs = r.crafts or {}
  for i = #cs, 1, -1 do
    local c = cs[i]
    if c.n > 0 then
      queueAdd(c.rec.prof, findRecipe(c.rec.prof, c.id), c.id, (info("i", c.id)), c.n); added = added + 1
    end
  end
  for i, s in ipairs(route.steps) do
    local n = r.stepCrafts[i] + r.extraCrafts[i]
    if n > 0 then
      local out = s.k == "i" and s.id or nil
      local id = (s.k == "s" and s.id) or findRecipe(current.prof.key, out)
      queueAdd(current.prof.key, id, out, (info(s.k, s.id)), n); added = added + 1
    end
  end
  msg(string.format("已把 %d 個步驟加入製作佇列", added))
end

-- 佇列要用的材料（扣掉佇列裡自己會做出來的中間材料）
local function queueNeeds(learned)
  local need, made, order, unknown = {}, {}, {}, 0
  for _, q in ipairs(db.queue) do
    local rec = q.id and db.recipes[q.prof] and db.recipes[q.prof][q.id]
    if rec then
      for _, m in ipairs(rec.mats) do
        if not need[m[1]] then need[m[1]] = 0; table.insert(order, m[1]) end
        need[m[1]] = need[m[1]] + m[2] * q.count
      end
      if rec.out then made[rec.out] = (made[rec.out] or 0) + q.count * (rec.qmin + rec.qmax) / 2 end
    else
      unknown = unknown + 1
    end
  end
  local list, total, missing = {}, 0, 0
  for _, id in ipairs(order) do
    local qty = math.ceil(need[id] - (made[id] or 0) - 1e-9)
    if qty > 0 then
      local it = { id = id, qty = qty, kind = "mat", unit = price(id), have = have(id) }
      it.buy = math.max(0, it.qty - it.have)
      if it.unit then total = total + it.unit * it.buy elseif it.buy > 0 then missing = missing + 1 end
      table.insert(list, it)
    end
  end
  local r = { list = list, total = total, missing = missing, stepCrafts = {}, extraCrafts = {} }
  if db.decompose then r = decompose(r, learned) end
  r.unknown = unknown
  return r
end

-- 製作下一個：佇列裡第一個「目前開著的專業」的項目，一次做完（材料夠多少做多少）
local function craftNext()
  local p = openProf()
  if not p then msg("請先打開專業視窗（例如鍛造），再按「製作下一個」"); return end
  local T = C_TradeSkillUI
  for _, q in ipairs(db.queue) do
    if q.count > 0 and q.prof == p.key then
      q.id = q.id or findRecipe(p.key, q.out)
      if not q.id then msg((q.name or "?") .. "：專業視窗裡找不到這個配方（還沒學？）"); return end
      local rec = db.recipes[p.key] and db.recipes[p.key][q.id]
      local n = math.min(q.count, rec and canMakeNow(rec) or q.count)
      if T and T.GetRecipeInfo then
        local ok, ri = pcall(T.GetRecipeInfo, q.id)
        if ok and type(ri) == "table" and type(ri.numAvailable) == "number" then n = math.min(q.count, ri.numAvailable) end
      end
      if n <= 0 then msg((q.name or "?") .. "：材料不夠（只算背包裡的），先把材料準備好"); return end
      if T and T.CraftRecipe then T.CraftRecipe(q.id, n)
      elseif DoTradeSkill and rec and rec.index then DoTradeSkill(rec.index, n)
      else msg("這個遊戲版本不支援從插件製作"); return end
      msg(string.format("開始製作 %s ×%d", q.name or "?", n))
      return
    end
  end
  msg("佇列裡沒有" .. p.name .. "要做的東西")
end

-- 做完一次就從佇列扣掉
local function onCrafted(spellID)
  for i, q in ipairs(db.queue) do
    if q.id == spellID then
      q.count = q.count - 1
      if q.count <= 0 then table.remove(db.queue, i) end
      return true
    end
  end
end

-- ── 視窗 ───────────────────────────────────────────────────────────────────
local W, ROW_H, MAXLINES, TOP, GAP = 600, 24, 20, 170, 16
local frame, offset = nil, 0
local TABS = {
  steps = { { "等級", 80, "RIGHT" }, { "製作", 220, "LEFT", true }, { "次數", 56, "RIGHT" }, { "來源", 140, "LEFT" }, { "回本", 80, "RIGHT" } },
  profit = { { "配方", 220, "LEFT", true }, { "成本", 80, "RIGHT", nil, "cost" }, { "售價", 80, "RIGHT", nil, "sell" }, { "利潤", 90, "RIGHT", nil, "profit" },
    { "利潤%", 60, "RIGHT", nil, "pct" }, { "在架", 50, "RIGHT", nil, "listed" }, { "可做", 44, "RIGHT", nil, "can" }, { "佇列", 44, "RIGHT", nil, "queued" } },
  queue = { { "製作", 220, "LEFT", true }, { "次數", 50, "RIGHT" }, { "專業", 60, "LEFT" }, { "材料", 110, "LEFT" }, { "可做", 50, "RIGHT" } },
  shop = { { "物品", 220, "LEFT", true }, { "需要", 52, "RIGHT" }, { "已有", 52, "RIGHT" }, { "要買", 52, "RIGHT" }, { "單價", 90, "RIGHT" }, { "小計", 100, "RIGHT" } },
}
local NCOL = 8

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
      local hb = frame.headBtns[c]
      hb:ClearAllPoints(); hb:SetPoint("LEFT", frame.head, "LEFT", x, 0); hb:SetSize(w, 22); hb:SetShown(col[5] ~= nil)
      for i = 1, MAXLINES do
        local l = frame.lines[i]
        l.c[c]:ClearAllPoints(); l.c[c]:SetPoint("LEFT", l, "LEFT", x + iconW, 0); l.c[c]:SetWidth(w - iconW); l.c[c]:SetJustifyH(col[3]); l.c[c]:Show()
        if col[4] then l.icon:ClearAllPoints(); l.icon:SetPoint("LEFT", l, "LEFT", x, 0) end
      end
      x = x + w + GAP
    else
      hf:Hide(); frame.headBtns[c]:Hide()
      for i = 1, MAXLINES do frame.lines[i].c[c]:Hide() end
    end
  end
  local total = math.max(x - GAP, W)
  frame.head:SetWidth(total)
  for i = 1, MAXLINES do frame.lines[i]:SetWidth(total) end
  frame:SetWidth(total + 28)
end

-- 右下角的調整把手：拖曳放大縮小整個視窗（左上角固定），大小記在設定裡
local function addResizeGrip(f)
  local g = CreateFrame("Button", nil, f)
  g:SetSize(18, 18); g:SetPoint("BOTTOMRIGHT", -4, 4); g:SetFrameLevel(f:GetFrameLevel() + 10)
  g:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  g:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  g:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  g:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:AddLine("拖曳調整視窗大小"); GameTooltip:Show()
  end)
  g:SetScript("OnLeave", function() GameTooltip:Hide() end)
  g:SetScript("OnMouseDown", function(self)
    local s0, eff0 = f:GetScale(), f:GetEffectiveScale()
    local leftPx, topPx, widthPx = f:GetLeft() * eff0, f:GetTop() * eff0, f:GetWidth() * eff0
    self:SetScript("OnUpdate", function()
      local cx = GetCursorPosition()
      local s = math.max(0.6, math.min(2.5, s0 * (cx - leftPx) / widthPx))
      f:SetScale(s); db.scale = s
      local eff = f:GetEffectiveScale()
      f:ClearAllPoints(); f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", leftPx / eff, topPx / eff)
    end)
  end)
  g:SetScript("OnMouseUp", function(self) self:SetScript("OnUpdate", nil) end)
  g:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
end

-- 按鈕寬度配合文字（字型較大時不會超出按鈕）
local function fitButton(b, minW)
  local fs = b:GetFontString()
  local w = fs and fs.GetStringWidth and fs:GetStringWidth()
  if type(w) == "number" and w > 0 then b:SetWidth(math.max(minW or 0, w + 24)) end
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
  frame.profBtn:SetText(p.name .. (L and string.format("（%d）", L.cur) or "（沒學）")); fitButton(frame.profBtn, 146)
  if not frame.fromBox:HasFocus() then frame.fromBox:SetText(tostring(S)) end
  if not frame.toBox:HasFocus() then frame.toBox:SetText(tostring(T)) end
  local route, r, nVar = pickRoute(p.key, S, T)
  if db.decompose then r = decompose(r, learned) end
  current = { prof = p, S = S, T = T, route = route, r = r }
  local pbTotal, stepVal = payback(route, r)
  local qr
  if db.tab == "queue" then qr = queueNeeds(learned); current.r = qr; current.queue = true end
  local api = auctionator()
  frame.status:SetText(api and string.format("價格：Auctionator　從 %d 條路線選出最省的", nVar)
    or "|cffff9d5c沒有偵測到 Auctionator，只有商人物品有價格（使用預設路線）|r")
  if db.tab == "queue" then
    local nq = 0
    for _, q in ipairs(db.queue) do nq = nq + q.count end
    frame.total:SetText(string.format("製作佇列 %d 項（共 %d 次）　材料花費 %s%s%s", #db.queue, nq, money(qr.total),
      qr.missing > 0 and string.format("　|cffff9d5c%d 項沒有價格|r", qr.missing) or "",
      qr.unknown > 0 and string.format("　|cffff9d5c%d 項還不知道材料（打開那個專業視窗一次）|r", qr.unknown) or ""))
  elseif db.tab == "profit" then
    local book, nr = db.recipes[p.key], 0
    if book then for _ in pairs(book) do nr = nr + 1 end end
    frame.total:SetText(nr > 0 and string.format("%s 已記下 %d 個配方　點一下加入佇列（Shift 加 5、右鍵減 1）", p.name, nr)
      or string.format("|cffff9d5c打開%s的專業視窗一次，插件就會記下你學會的配方|r", p.name))
  else
    frame.total:SetText(string.format("%s %d–%d　花費 %s%s", p.name, S, T, money(r.total),
      pbTotal > 0.5 and string.format("　|cff9fd18b回本 %s|r　淨花費 %s", money(pbTotal), money(math.max(0, r.total - pbTotal))) or ""))
    -- 次要資訊放在價格來源那行，避免花費這行太長被截斷
    frame.status:SetText((frame.status:GetText() or "") .. ((r.saved and r.saved > 0.5) and ("　|cff9fd18b自製中間材料省 " .. money(r.saved) .. "|r") or "")
      .. (r.missing > 0 and string.format("　|cffff9d5c%d 項沒有價格|r", r.missing) or ""))
  end
  frame.decBtn:SetText(db.decompose and "拆中間材料：開" or "拆中間材料：關"); fitButton(frame.decBtn, 120)
  frame.bagBtn:SetText(db.useBag and "扣背包：開" or "扣背包：關"); fitButton(frame.bagBtn, 90)
  frame.bankBtn:SetText(db.useBank and "扣銀行：開" or "扣銀行：關"); fitButton(frame.bankBtn, 90)
  frame.bagBtn:SetShown(db.tab == "queue"); frame.bankBtn:SetShown(db.tab == "queue")
  frame.voiceBtn:SetText(NS.voiceLabel()); fitButton(frame.voiceBtn, 60)
  local isLv = db.tab == "steps" or db.tab == "shop"
  for _, w in ipairs({ frame.fromLbl, frame.fromBox, frame.toLbl, frame.toBox, frame.nowBtn, frame.stepsBtn, frame.shopBtn }) do w:SetShown(isLv) end
  frame.decBtn:ClearAllPoints()
  frame.decBtn:SetPoint("LEFT", isLv and frame.shopBtn or frame.levelBtn, "RIGHT", isLv and 10 or 16, 0)
  for _, t in ipairs({ { frame.stepsBtn, "steps" }, { frame.shopBtn, "shop" }, { frame.profitBtn, "profit" }, { frame.queueBtn, "queue" }, { frame.levelBtn, "level" } }) do
    local on = db.tab == t[2] or (t[2] == "level" and isLv)
    t[1]:GetFontString():SetTextColor(on and 1 or .55, on and .82 or .52, on and 0 or .45)
  end
  frame.atrBtn:SetShown(api ~= nil and api.CreateShoppingList ~= nil)
  -- 內容
  local cols = TABS[db.tab]
  for c = 1, NCOL do
    local col = cols[c]
    local lbl = col and col[1] or ""
    if col and col[5] and col[5] == db.psort then lbl = (db.pdesc ~= false and "▼" or "▲") .. lbl end
    frame.headFs[c]:SetText(lbl)
    if col and col[5] and col[5] == db.psort then frame.headFs[c]:SetTextColor(1, .82, 0) else frame.headFs[c]:SetTextColor(.6, .57, .5) end
  end
  local rows = {}
  if db.tab == "steps" then
    local cs = r.crafts or {}
    for i = #cs, 1, -1 do -- 先做最底層的（例如先冶煉銅錠、錫錠，再做青銅錠）
      if cs[i].n > 0 then table.insert(rows, { prep = cs[i] }) end
    end
    for i, s in ipairs(route.steps) do
      local n = r.stepCrafts[i] + r.extraCrafts[i]
      if n > 0 then table.insert(rows, { step = s, n = n, extra = r.extraCrafts[i], val = stepVal[i] }) end
    end
  elseif db.tab == "profit" then
    local qc = {}
    for _, q in ipairs(db.queue) do if q.id then qc[q.id] = (qc[q.id] or 0) + q.count end end
    for id, rec in pairs(db.recipes[p.key] or {}) do
      local cost, sell, profit = profitOf(rec, learned)
      local pct = (profit and cost and cost > 0) and (profit / cost * 100) or nil
      local st = rec.out and ahStats(rec.out)
      table.insert(rows, { recipe = rec, id = id, prof = p.key, cost = cost, sell = sell, profit = profit, pct = pct, can = canMakeNow(rec), queued = qc[id] or 0,
        listed = st and st.last or nil, stats = st })
    end
    local k, desc = db.psort or "profit", db.pdesc ~= false
    table.sort(rows, function(a, b)
      local va, vb = a[k], b[k]
      if (va ~= nil) ~= (vb ~= nil) then return va ~= nil end -- 沒有數值的排最後
      if va ~= nil and va ~= vb then if desc then return va > vb else return va < vb end end
      return recipeName(nil, a.recipe) < recipeName(nil, b.recipe)
    end)
  elseif db.tab == "queue" then
    for _, q in ipairs(db.queue) do table.insert(rows, { queue = q }) end
  else
    for _, it in ipairs(current.r.list) do table.insert(rows, { item = it }) end
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
      if e.recipe then
        local rec = e.recipe
        local name, icon, col
        if rec.out then name, icon, col = info("i", rec.out) else name, icon, col = info("s", e.id); name = rec.name or name end
        l.icon:SetTexture(icon); l.icon:Show()
        local pf = e.profit and ((e.profit >= 0 and "|cff9fd18b" or "|cffff7b7b") .. (e.profit >= 0 and "" or "-") .. money(math.abs(e.profit)) .. "|r") or "—"
        local pc = e.pct and string.format("%s%d%%|r", e.pct >= 0 and "|cff9fd18b" or "|cffff7b7b", math.floor(e.pct + 0.5)) or "—"
        vals = { name, e.cost and money(e.cost) or "|cffff9d5c沒價格|r", e.sell and money(e.sell) or "—", pf, pc,
          e.listed and tostring(e.listed) or "—", e.can > 0 and e.can or "0", e.queued > 0 and ("|cffffd100" .. e.queued .. "|r") or "" }
        l.c[1]:SetTextColor(col[1], col[2], col[3])
      elseif e.queue then
        local q = e.queue
        local rec = q.id and db.recipes[q.prof] and db.recipes[q.prof][q.id]
        local name, icon, col
        if q.out then name, icon, col = info("i", q.out) else name, icon, col = info("s", q.id or 0); name = q.name or name end
        l.icon:SetTexture(icon); l.icon:Show()
        local pn = q.prof == "mining" and "採礦" or (PROF_BY_KEY[q.prof] and PROF_BY_KEY[q.prof].name or q.prof)
        local miss, matTxt = 0, "|cffff9d5c不知道材料|r"
        if rec then
          for _, m in ipairs(rec.mats) do if bagCount(m[1]) < m[2] * q.count then miss = miss + 1 end end
          matTxt = miss == 0 and "|cff9fd18b齊了|r" or string.format("|cffff9d5c缺 %d 種|r", miss)
        end
        vals = { name, "×" .. q.count, pn, matTxt, rec and canMakeNow(rec) or "—" }
        l.c[1]:SetTextColor(col[1], col[2], col[3])
      elseif e.prep then
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
        vals = { hi > lo and (lo .. "–" .. hi) or "—", name, "×" .. e.n, srcName(s.src), e.val and ("|cff9fd18b" .. money(e.val) .. "|r") or "—" }
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
  local emptyTxt = db.tab == "queue" and "佇列是空的：在「利潤」點產品加入，或在「步驟」按「全部加入佇列」"
    or (db.tab == "profit" and "還沒有記下配方" or "這個範圍不需要製作任何東西")
  frame.foot:SetText(#rows == 0 and emptyTxt or (#rows > MAXLINES and string.format("共 %d 列，用滾輪捲動", #rows) or ""))
  -- 底部動作按鈕（依分頁）
  local y = -(TOP + shown * ROW_H + 8)
  frame.atrBtn:ClearAllPoints(); frame.atrBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, y)
  frame.foot:ClearAllPoints()
  if frame.atrBtn:IsShown() then frame.foot:SetPoint("LEFT", frame.atrBtn, "RIGHT", 10, 0) else frame.foot:SetPoint("TOPLEFT", 14, y - 5) end
  frame.act1:Hide(); frame.act2:Hide()
  if db.tab == "steps" then
    frame.act1:SetText("全部加入製作佇列"); fitButton(frame.act1, 140); frame.act1.fn = queueRoute; frame.act1:Show()
  elseif db.tab == "queue" then
    frame.act1:SetText("製作下一個"); fitButton(frame.act1, 120); frame.act1.fn = craftNext; frame.act1:Show()
    frame.act2:SetText("清空佇列"); fitButton(frame.act2, 90); frame.act2.fn = function() wipe(db.queue) end; frame.act2:Show()
  end
  frame.act1:ClearAllPoints(); frame.act1:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, y)
  frame.act2:ClearAllPoints(); frame.act2:SetPoint("RIGHT", frame.act1, "LEFT", -6, 0)
  local hasAct = frame.act1:IsShown() or frame.atrBtn:IsShown()
  frame:SetHeight(TOP + shown * ROW_H + ((hasAct or frame.foot:GetText() ~= "") and 44 or 18))
  autoFit(cols)
  -- 升階提示（點數到上限前 10 點或已夠升階時才出現）
  local tr, low, R = rankText(p.key, L)
  if tr and L.cur < math.min(L.max - 10, R.skill) then tr = nil end
  frame.status:ClearAllPoints()
  if tr then
    frame.train:SetText(tr); frame.train:Show()
    if low then frame.train:SetTextColor(.5, .5, .5) else frame.train:SetTextColor(1, .82, 0) end
    frame.goBtn.R = R; frame.goBtn:SetShown(R.at[1].map ~= nil)
    local anchor = frame.goBtn:IsShown() and frame.goBtn or frame.train
    frame.status:SetPoint("LEFT", anchor, "RIGHT", 10, 0)
    frame.status:SetWidth(math.max(1, frame:GetWidth() - 38 - measure(frame.train) - (frame.goBtn:IsShown() and frame.goBtn:GetWidth() + 6 or 0)))
  else
    frame.train:Hide(); frame.goBtn:Hide(); frame.goBtn.R = nil
    frame.status:SetPoint("TOPLEFT", 14, -66); frame.status:SetWidth(0)
  end
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
  local listName = current.queue and "阿聖專業幫手 製作佇列" or string.format("阿聖專業幫手 %s %d-%d", current.prof.name, current.S, current.T)
  if safe("建立購物清單", api.CreateShoppingList, CALLER, listName, terms) then
    msg(string.format("已建立 Auctionator 購物清單「%s」，共 %d 項（%s，商人物品不列入）", listName, #terms, haveText()))
  end
end


local function button(parent, w, label, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(w + 16, 26); b:SetText(label); b:SetScript("OnClick", onClick)
  fitButton(b, w + 16)
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
  addResizeGrip(frame)
  -- 右上角的關閉鈕：範本預設走 HideUIPanel，戰鬥中可能被擋而關不掉；改成直接隱藏（一般視窗隨時都能關）
  local close = frame.CloseButton or _G[frame:GetName() .. "CloseButton"]
  if close then close:SetScript("OnClick", function() frame:Hide() end) end
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetFrameStrata("DIALOG")
  tinsert(UISpecialFrames, "ProfLevelFrame")
  if not frame.TitleText then
    frame.TitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.TitleText:SetPoint("TOP", 0, -5)
  end
  frame.TitleText:SetText("阿聖專業幫手")
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
  local fromLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fromLbl:SetText("從"); frame.fromLbl = fromLbl
  fromLbl:SetPoint("LEFT", frame.nextBtn, "RIGHT", 12, 0)
  frame.fromBox = numBox(frame, function(v) db.from[db.prof] = v end)
  frame.fromBox:SetPoint("LEFT", fromLbl, "RIGHT", 8, 0)
  local toLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); toLbl:SetText("到"); frame.toLbl = toLbl
  toLbl:SetPoint("LEFT", frame.fromBox, "RIGHT", 8, 0)
  frame.toBox = numBox(frame, function(v) db.to[db.prof] = v end)
  frame.toBox:SetPoint("LEFT", toLbl, "RIGHT", 8, 0)
  frame.nowBtn = button(frame, 52, "目前", function() db.from[db.prof] = nil; ProfLevel_Refresh() end)
  frame.nowBtn:SetPoint("LEFT", frame.toBox, "RIGHT", 6, 0)
  frame.nowBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine("起點改回目前的專業點數"); GameTooltip:Show()
  end)
  frame.nowBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第一列最右邊：語音提示開關（右鍵開設定，見 Voice.lua）
  frame.voiceBtn = button(frame, 60, "", function(_, btn) if btn == "RightButton" then NS.voiceSlash("config") else NS.voiceToggle() end end)
  frame.voiceBtn:SetHeight(22); frame.voiceBtn:SetPoint("TOPRIGHT", -14, -32)
  frame.voiceBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  frame.voiceBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine("附近的礦和草念出名稱"); GameTooltip:AddLine("右鍵：設定", .6, .6, .6); GameTooltip:Show()
  end)
  frame.voiceBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第二、三列：價格來源、總花費
  frame.status = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame.status:SetPoint("TOPLEFT", 14, -66); frame.status:SetJustifyH("LEFT"); frame.status:SetWordWrap(false)
  -- 升階提示：快到上限時佔掉價格來源那行的開頭，「去」設航點
  frame.train = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.train:SetPoint("TOPLEFT", 14, -66); frame.train:SetJustifyH("LEFT"); frame.train:SetWordWrap(false); frame.train:Hide()
  frame.goBtn = button(frame, 20, "去", function(self) goTo(self.R and self.R.at[1]) end)
  frame.goBtn:SetHeight(20); frame.goBtn:SetPoint("LEFT", frame.train, "RIGHT", 6, 0); frame.goBtn:Hide()
  frame.goBtn:SetScript("OnEnter", function(self)
    local R = self.R
    if not R then return end
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    for i, a in ipairs(R.at) do
      if i == 1 then GameTooltip:AddLine(a.place .. " " .. a.name)
      else GameTooltip:AddDoubleLine(a.place .. " " .. a.name, a.map and string.format("%.1f, %.1f", a.x, a.y) or "", 1, 1, 1, .6, .6, .6) end
    end
    if R.note then GameTooltip:AddLine(R.note, .8, .8, .8, true) end
    GameTooltip:Show()
  end)
  frame.goBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  frame.total = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.total:SetPoint("TOPLEFT", 14, -88); frame.total:SetJustifyH("LEFT"); frame.total:SetWordWrap(false)
  -- 分頁與購物清單按鈕
  frame.stepsBtn = button(frame, 50, "步驟", function() db.tab = "steps"; db.lvTab = "steps"; offset = 0; ProfLevel_Refresh() end)
  frame.shopBtn = button(frame, 50, "材料", function() db.tab = "shop"; db.lvTab = "shop"; offset = 0; ProfLevel_Refresh() end)
  frame.levelBtn = button(frame, 50, "衝級", function() db.tab = db.lvTab or "steps"; offset = 0; ProfLevel_Refresh() end)
  frame.profitBtn = button(frame, 50, "利潤", function() db.tab = "profit"; offset = 0; ProfLevel_Refresh() end)
  frame.queueBtn = button(frame, 50, "佇列", function() db.tab = "queue"; offset = 0; ProfLevel_Refresh() end)
  frame.act1 = button(frame, 120, "", function(self) if self.fn then safe("動作", self.fn) end; ProfLevel_Refresh() end)
  frame.act2 = button(frame, 90, "", function(self) if self.fn then safe("動作", self.fn) end; ProfLevel_Refresh() end)
  frame.act1:Hide(); frame.act2:Hide()
  frame.atrBtn = button(frame, 160, "建立 Auctionator 購物清單", function() safe("建立購物清單", createShoppingList) end)
  frame.atrBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("建立 Auctionator 購物清單")
    GameTooltip:AddLine("數量" .. haveText() .. "；商人販售的物品不列入。在拍賣行打開 Auctionator 的購物分頁就能用。", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.atrBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 表頭與內容
  local head = CreateFrame("Frame", nil, frame); head:SetSize(W, 22); head:SetPoint("TOPLEFT", 14, -(TOP - 26))
  local line = head:CreateTexture(nil, "ARTWORK"); line:SetColorTexture(1, 1, 1, .12); line:SetHeight(1)
  line:SetPoint("BOTTOMLEFT", head, "BOTTOMLEFT", 0, -1); line:SetPoint("BOTTOMRIGHT", head, "BOTTOMRIGHT", 0, -1)
  frame.head, frame.headFs = head, {}
  frame.headBtns = {}
  for c = 1, NCOL do
    local fs = head:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fs:SetWordWrap(false); fs:SetTextColor(.6, .57, .5)
    frame.headFs[c] = fs
    local hb = CreateFrame("Button", nil, head) -- 點欄名排序（利潤分頁）
    hb:SetScript("OnClick", function()
      local col = TABS[db.tab][c]
      if not (col and col[5]) then return end
      if db.psort == col[5] then db.pdesc = not (db.pdesc ~= false) else db.psort = col[5]; db.pdesc = true end
      offset = 0; ProfLevel_Refresh()
    end)
    frame.headBtns[c] = hb
  end
  -- 分頁按鈕自成一列（在花費那行下面、表頭上面），不會壓到文字
  frame.profitBtn:SetPoint("TOPLEFT", 12, -116)
  frame.decBtn = button(frame, 120, "", function() db.decompose = not db.decompose; ProfLevel_Refresh() end)
  -- 佇列：材料要不要扣掉背包、銀行已有的（衝級路線也照這個設定）
  frame.bagBtn = button(frame, 90, "", function() db.useBag = not db.useBag; ProfLevel_Refresh() end)
  frame.bagBtn:SetPoint("LEFT", frame.decBtn, "RIGHT", 6, 0)
  frame.bankBtn = button(frame, 90, "", function() db.useBank = not db.useBank; ProfLevel_Refresh() end)
  frame.bankBtn:SetPoint("LEFT", frame.bagBtn, "RIGHT", 2, 0)
  frame.queueBtn:SetPoint("LEFT", frame.profitBtn, "RIGHT", 2, 0)
  frame.levelBtn:SetPoint("LEFT", frame.queueBtn, "RIGHT", 2, 0)
  -- 衝級的子分頁：步驟／材料
  frame.stepsBtn:SetPoint("LEFT", frame.levelBtn, "RIGHT", 16, 0)
  frame.shopBtn:SetPoint("LEFT", frame.stepsBtn, "RIGHT", 2, 0)
  frame.decBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("拆中間材料")
    GameTooltip:AddLine("開：每個中間材料都比較「直接買」和「買原料自己做」，便宜的那個才列進清單。只拆你學過、點數也夠的配方（冶煉要有採礦）。", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.decBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
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
    l:EnableMouse(true); l.sprofRow = true
    l:SetScript("OnMouseUp", function(self, btn)
      local e = self.e; if not e then return end
      local d = (btn == "RightButton") and -1 or 1
      if IsShiftKeyDown and IsShiftKeyDown() then d = d * 5 end
      if e.recipe then queueAdd(e.prof, e.id, e.recipe.out, recipeName(nil, e.recipe), d); ProfLevel_Refresh()
      elseif e.queue then queueAdd(e.queue.prof, e.queue.id, e.queue.out, e.queue.name, d); ProfLevel_Refresh() end
    end)
    l:SetScript("OnEnter", function(self)
      local e = self.e; if not e then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      if e.recipe or e.queue then
        local rec = e.recipe or (e.queue.id and db.recipes[e.queue.prof] and db.recipes[e.queue.prof][e.queue.id])
        local out = (e.recipe and e.recipe.out) or (e.queue and e.queue.out)
        if out then pcall(GameTooltip.SetItemByID, GameTooltip, out) elseif e.id or (e.queue and e.queue.id) then pcall(GameTooltip.SetSpellByID, GameTooltip, e.id or e.queue.id) end
        GameTooltip:AddLine(" ")
        if rec then
          local times = e.queue and e.queue.count or 1
          for _, m in ipairs(rec.mats) do
            local nm = info("i", m[1])
            local need, got = m[2] * times, bagCount(m[1])
            local pr = price(m[1])
            GameTooltip:AddDoubleLine(string.format("%s ×%d", nm, need), string.format("%s背包 %d", pr and (money(pr * m[2]) .. "　") or "", got),
              1, 1, 1, got >= need and .6 or 1, got >= need and 1 or .6, .6)
          end
        end
        local gl = NS.guildLine(e.recipe and e.id or e.queue.id, out)
        if gl then GameTooltip:AddLine(gl, .55, .75, 1, true) end
        if e.recipe then
          if e.sell then GameTooltip:AddLine(string.format("售價 %s（已扣拍賣行 5%% 手續費）", money(e.sell)), .8, .8, .8) end
          local st = e.stats
          if st then
            GameTooltip:AddLine(string.format("拍賣場：最近一次在架 %d 個；最近 14 天有 %d 天看到，平均在架 %d 個", st.last, st.days, math.floor(st.avg + 0.5)), .55, .75, 1, true)
            GameTooltip:AddLine("（只代表有多少人在賣，不代表賣得掉：賣不掉的也會一直重新上架。遊戲沒有成交量資料）", .6, .6, .6, true)
          else
            GameTooltip:AddLine("拍賣場：Auctionator 沒有這個成品的掃描紀錄", .6, .6, .6, true)
          end
          GameTooltip:AddLine("左鍵加入佇列、Shift+左鍵加 5、右鍵減 1", .6, .6, .6)
        else
          GameTooltip:AddLine("左鍵 +1、右鍵 −1（Shift 一次 5）", .6, .6, .6)
        end
      elseif e.prep then
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
        if e.val then GameTooltip:AddLine("做出來的成品賣掉約可回本 " .. money(e.val) .. "（已扣 5% 手續費、扣掉後面步驟會用掉的）", .6, 1, .6, true) end
        local st = s.k == "i" and ahStats(s.id)
        if st then GameTooltip:AddLine(string.format("拍賣場：最近一次在架 %d 個；最近 14 天有 %d 天看到", st.last, st.days), .55, .75, 1, true) end
        if s.d and #s.d == 4 then
          local function dv(x) return (x == nil or x == "" or x == "–") and "—" or x end
          GameTooltip:AddLine(string.format("難度：|cffff8040%s|r |cffffff00%s|r |cff40bf40%s|r |cff808080%s|r", dv(s.d[1]), dv(s.d[2]), dv(s.d[3]), dv(s.d[4])), .8, .8, .8)
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

-- ── 專業視窗整合：配方細節區顯示利潤與「加入佇列」，插件視窗貼在專業視窗右邊 ──
local profUI, docked = nil, false
local function selectedRecipe()
  local sf = ProfessionsFrame and ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm
  local ok, ri = false, nil
  if sf and sf.GetRecipeInfo then ok, ri = pcall(sf.GetRecipeInfo, sf) end
  if ok and type(ri) == "table" and ri.recipeID then return ri.recipeID end
  if C_TradeSkillUI and C_TradeSkillUI.GetSelectedRecipeID then
    local ok2, id = pcall(C_TradeSkillUI.GetSelectedRecipeID)
    if ok2 and type(id) == "number" and id > 0 then return id end
  end
end
local function updateProfUI()
  if not profUI or not profUI:IsVisible() then return end
  local open = frame and frame:IsShown() and true or false
  profUI.text:SetShown(open); profUI.addBtn:SetShown(open)
  profUI.openBtn:SetText(open and "關閉幫手" or "專業幫手"); fitButton(profUI.openBtn, 110)
  if not open then return end
  local p, id = openProf(), selectedRecipe()
  profUI.id, profUI.prof, profUI.rec = id, p and p.key, nil
  if not p or not id then profUI.text:SetText(""); return end
  priceCache = {}
  local rec = db.recipes[p.key] and db.recipes[p.key][id]
  profUI.rec = rec
  local qn = 0
  for _, q in ipairs(db.queue) do if q.id == id then qn = qn + q.count end end
  local txt = ""
  if rec then
    local cost, sell, profit = profitOf(rec, learnedProfs())
    if profit then
      txt = string.format("利潤 %s%s|r（%d%%）", profit >= 0 and "|cff9fd18b" or "|cffff7b7b", (profit < 0 and "-" or "") .. money(math.abs(profit)),
        cost > 0 and math.floor(profit / cost * 100 + 0.5) or 0)
    elseif cost then txt = "成本 " .. money(cost) .. "（沒有售價）" end
  end
  profUI.text:SetText(txt .. (qn > 0 and string.format("　|cffffd100佇列 ×%d|r", qn) or ""))
end
local function dockOpen(force)
  if (not force and not db.dock) or not ProfessionsFrame then return end
  local p = openProf()
  if p then db.prof = p.key end
  if not frame then buildFrame() end
  frame:ClearAllPoints(); frame:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 6, 0)
  docked = true
  if not frame.profHooked then -- 助手開關時，專業視窗裡的面板跟著顯示或收起
    frame.profHooked = true
    frame:HookScript("OnShow", function() safe("專業視窗", updateProfUI) end)
    frame:HookScript("OnHide", function() safe("專業視窗", updateProfUI) end)
  end
  frame:Show(); ProfLevel_Refresh()
end
local function dockClose()
  if docked and frame then frame:Hide() end
  docked = false
end
local function setupProfUI()
  if profUI or not (ProfessionsFrame and ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm) then return end
  local sf = ProfessionsFrame.CraftingPage.SchematicForm
  profUI = CreateFrame("Frame", "ProfLevelProfessionsPanel", sf)
  profUI:SetSize(360, 56); profUI:SetFrameLevel(sf:GetFrameLevel() + 30)
  local anchor = _G.AuctionatorCraftingInfoProfessionsFrame
  if anchor then profUI:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -40) else profUI:SetPoint("BOTTOMLEFT", sf, "BOTTOMLEFT", 24, 70) end
  profUI.text = profUI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  profUI.text:SetPoint("TOPLEFT", 2, 0); profUI.text:SetJustifyH("LEFT")
  local b = CreateFrame("Button", nil, profUI, "UIPanelButtonTemplate")
  b:SetSize(110, 24); b:SetText("加入佇列"); profUI.addBtn = b
  b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  b:SetScript("OnClick", function(_, btn)
    if not profUI.id then return end
    local d = (btn == "RightButton") and -1 or 1
    if IsShiftKeyDown and IsShiftKeyDown() then d = d * 5 end
    local rec = profUI.rec
    queueAdd(profUI.prof, profUI.id, rec and rec.out, rec and recipeName(nil, rec) or nil, d)
    updateProfUI()
    if frame and frame:IsShown() then ProfLevel_Refresh() end
  end)
  b:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine("加入製作佇列")
    GameTooltip:AddLine("左鍵 +1、Shift+左鍵 +5、右鍵 −1", 1, 1, 1); GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  fitButton(b, 110)
  local o = CreateFrame("Button", nil, profUI, "UIPanelButtonTemplate")
  o:SetSize(110, 24); o:SetText("專業幫手"); o:SetPoint("TOPLEFT", 0, -22); profUI.openBtn = o
  b:SetPoint("LEFT", o, "RIGHT", 6, 0)
  -- 點了才打開（不會改「自動開啟」的設定）
  o:SetScript("OnClick", function() if frame and frame:IsShown() then frame:Hide(); docked = false else dockOpen(true) end end)
  fitButton(o, 110)
  if sf.Init then hooksecurefunc(sf, "Init", function() C_Timer.After(0, function() safe("專業視窗", updateProfUI) end) end) end
  profUI:SetScript("OnShow", function() safe("專業視窗", updateProfUI) end)
  ProfessionsFrame:HookScript("OnShow", function() safe("專業視窗", dockOpen) end)
  ProfessionsFrame:HookScript("OnHide", dockClose)
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
  local icon = b:CreateTexture(nil, "ARTWORK"); icon:SetTexture(ICON); icon:SetTexCoord(0.1, 0.9, 0.1, 0.9); icon:SetSize(20, 20); icon:SetPoint("TOPLEFT", 6, -5)
  b.icon, b.Icon = icon, icon -- 小地圖按鈕收納插件會找這個欄位當圖示
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
    GameTooltip:AddLine("阿聖專業幫手")
    GameTooltip:AddLine("左鍵：開關視窗", 1, 1, 1)
    GameTooltip:AddLine("拖曳：沿著小地圖移動", .6, .6, .6)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  placeMinimap()
  if db.minimapHide then b:Hide() end
end

-- ── 指令 ───────────────────────────────────────────────────────────────────
SLASH_PROFLEVEL1 = "/sprof"
SLASH_PROFLEVEL2 = "/prof" -- 舊指令保留
SLASH_PROFLEVEL3 = "/proflevel"
SlashCmdList.PROFLEVEL = function(input)
  ensureDB()
  local cmd = (input or ""):lower():match("^%s*(%S*)")
  if cmd == "" then toggleWindow()
  elseif cmd == "minimap" then
    db.minimapHide = not db.minimapHide
    if mmBtn then if db.minimapHide then mmBtn:Hide() else mmBtn:Show() end end
    msg("小地圖按鈕：" .. (db.minimapHide and "隱藏（再輸入 /sprof minimap 顯示）" or "顯示"))
  elseif cmd == "dock" then
    db.dock = not db.dock
    msg("打開專業視窗時自動顯示專業助手：" .. (db.dock and "開" or "關"))
  elseif cmd == "scale" then
    local v = tonumber((input or ""):match("scale%s+([%d%.]+)"))
    if v and v >= 0.5 and v <= 2 then db.scale = v; if frame then frame:SetScale(v) end; msg("視窗縮放：" .. v)
    else msg("用法：/sprof scale 1.2（0.5～2，目前 " .. (db.scale or 1) .. "）") end
  elseif cmd == "guild" then
    NS.guildSlash((input or ""):match("^%s*%S+%s+(.-)%s*$"))
  elseif cmd == "train" then
    local learned = learnedProfs(true)
    local n = 0
    for _, list in ipairs({ PROFS, { MINING }, EXTRA }) do
      for _, p in ipairs(list) do
        local L = learned[p.key]
        if L then
          n = n + 1
          local tr, low, R = rankText(p.key, L)
          local a = R and R.at[1]
          local where = (a and a.map) and string.format("　|cffffff00|Hworldmap:%d:%d:%d|h[%s %.1f, %.1f]|h|r", a.map, math.floor(a.x * 100 + 0.5), math.floor(a.y * 100 + 0.5), a.place, a.x, a.y) or ""
          local line = tr and ((low and "|cff808080" or "") .. tr .. (low and "|r" or "") .. where)
            or (L.max >= 300 and "已是大師") or (L.max <= 75 and "下一階：任一訓練師（10 級、技能 50）") or "沒有資料"
          msg(string.format("%s %d/%d　%s", p.name, L.cur, L.max, line))
        end
      end
    end
    if n == 0 then msg("沒偵測到專業") end
  elseif cmd == "track" then
    if ProfLevel_Track then ProfLevel_Track((input or ""):match("track%s+(%S+)")) end
  elseif cmd == "voice" then
    NS.voiceSlash((input or ""):lower():match("voice%s+(%S+)"))
  elseif cmd == "debug" then
    local learned = learnedProfs()
    local t = {}
    for _, p in ipairs(PROFS) do if learned[p.key] then table.insert(t, p.name .. " " .. learned[p.key].cur .. "/" .. learned[p.key].max) end end
    msg("版本 0.7.1　已學專業：" .. (#t > 0 and table.concat(t, "、") or "沒偵測到"))
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
    msg("/sprof 開關視窗　/sprof scale 1.2 調整視窗大小　/sprof dock 開關「跟專業視窗一起開」　/sprof minimap 隱藏小地圖按鈕　/sprof track 採集追蹤提醒　/sprof voice 語音提示（config 設定、test 試聽）/sprof train 下一階去哪學/sprof guild 公會誰會做（on/off 分享）　/sprof debug 列出偵測結果")
  end
end

NS.ensureDB, NS.msg, NS.learnedProfs, NS.recipes = ensureDB, msg, learnedProfs, recipes
function NS.quiet(where, fn, ...) -- 跟 safe 一樣記錯誤，但不在聊天視窗顯示（公會同步要完全安靜）
  local r = { pcall(fn, ...) }
  if not r[1] then logError(where, tostring(r[2])); return nil end
  return unpack(r, 2, table.maxn(r))
end
function NS.profName(k) return (PROF_BY_KEY[k] or (k == MINING.key and MINING) or { name = k }).name end

-- ── 事件 ───────────────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
local SCAN_EVENTS = { TRADE_SKILL_SHOW = true, TRADE_SKILL_LIST_UPDATE = true, TRADE_SKILL_DATA_SOURCE_CHANGED = true }
local scanPending = false
local function queueScan()
  if scanPending then return end
  scanPending = true
  C_Timer.After(0.5, function()
    scanPending = false; ensureDB(); safe("讀取配方", scanRecipes)
    if docked then local p = openProf(); if p then db.prof = p.key end end -- 專業視窗切換專業時跟著換
    safe("專業視窗", updateProfUI)
    if frame and frame:IsShown() then ProfLevel_Refresh() end
  end)
end
local REFRESH_EVENTS = { SKILL_LINES_CHANGED = true, BAG_UPDATE_DELAYED = true,
  GET_ITEM_INFO_RECEIVED = true, AUCTION_HOUSE_CLOSED = true, CHAT_MSG_SKILL = true, PLAYER_LEVEL_UP = true }
ev:SetScript("OnEvent", function(_, e, a1, ...)
  if e == "ADDON_LOADED" and a1 == ADDON then
    ensureDB()
  elseif e == "PLAYER_LOGIN" then
    ensureDB()
    if not db.scaleV then if db.scale == 1 then db.scale = 1.25 end; db.scaleV = 1 end -- 舊預設值改成新的預設大小（只遷移一次，之後尊重玩家設定）
    safe("小地圖按鈕", buildMinimapButton)
  elseif e == "ADDON_LOADED" and a1 == "Blizzard_Professions" then
    safe("專業視窗", setupProfUI)
  elseif SCAN_EVENTS[e] then
    if e == "TRADE_SKILL_SHOW" then
      local first = not profUI
      safe("專業視窗", setupProfUI)
      if first and ProfessionsFrame and ProfessionsFrame:IsShown() then safe("專業視窗", dockOpen) end
    end
    queueScan()
  elseif e == "UNIT_SPELLCAST_SUCCEEDED" then
    local spellID = select(2, ...) -- 參數：unit（a1）, castGUID, spellID；限制中（戰鬥、副本）是秘密值，不能比較，跳過
    if issecretvalue and (issecretvalue(a1) or issecretvalue(spellID)) then return end
    if a1 == "player" and spellID and onCrafted(spellID) and frame and frame:IsShown() then ProfLevel_Refresh() end
  elseif REFRESH_EVENTS[e] then
    if frame and frame:IsShown() then ProfLevel_Refresh() end
  end
end)
for _, e in ipairs({ "ADDON_LOADED", "PLAYER_LOGIN" }) do pcall(ev.RegisterEvent, ev, e) end
for e in pairs(REFRESH_EVENTS) do pcall(ev.RegisterEvent, ev, e) end
for e in pairs(SCAN_EVENTS) do pcall(ev.RegisterEvent, ev, e) end
if ev.RegisterUnitEvent then pcall(ev.RegisterUnitEvent, ev, "UNIT_SPELLCAST_SUCCEEDED", "player") else pcall(ev.RegisterEvent, ev, "UNIT_SPELLCAST_SUCCEEDED") end
