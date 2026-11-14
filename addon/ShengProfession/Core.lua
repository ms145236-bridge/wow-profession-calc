-- 專業助手（魔獸世界：永恆）
-- 依 Auctionator 的價格，從候選路線挑最省的一條，列出每段要做什麼、做幾次，以及要買的材料與花費。
-- 自動偵測已學專業與目前點數、扣掉背包與銀行已有的材料，可一鍵建立 Auctionator 購物清單。

local ADDON, NS = ... -- NS：跟 Guild.lua 共用
local L, loc = NS.L, NS.loc -- 介面文字（Locale.lua）
local UI = NS.UI -- 系列共用外觀（ShengUI.lua）
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
local DEFAULTS = { prof = nil, from = {}, to = {}, tab = "profit", minimapAngle = 225, minimapHide = false, scale = 1.25, decompose = true, useBag = true, useBank = true, recipes = {}, queue = {}, psort = "profit", pdesc = true, dock = false }
local db

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage(L["|cff4fc3f7阿聖|r|cffd9b25f專業幫手|r "] .. s) end
-- 換版本時清掉舊版本留下的錯誤紀錄（修好的錯誤不用留著）
do
  local f = CreateFrame("Frame")
  f:RegisterEvent("ADDON_LOADED")
  f:SetScript("OnEvent", function(self, _, name)
    if name ~= "ShengProfession" then return end
    self:UnregisterEvent("ADDON_LOADED")
    local meta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local ver = meta and meta("ShengProfession", "Version")
    if type(ProfLevelCharDB) == "table" and ver and type(ProfLevelCharDB.errors) == "table" and ProfLevelCharDB.errors.ver ~= ver then
      ProfLevelCharDB.errors = { ver = ver }
    elseif type(ProfLevelCharDB) == "table" and ver and ProfLevelCharDB.errors == nil then
      ProfLevelCharDB.errors = { ver = ver }
    end
  end)
end
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
    if not reported[err] then reported[err] = true; msg("|cffff7b7b" .. string.format(L["%s出錯："], L[where]) .. "|r" .. err .. L["　請把這行回報給開發者"]) end
  end
  return ok
end
local function ensureDB()
  if db then return db end
  ProfLevelCharDB = ProfLevelCharDB or {}
  for k, v in pairs(DEFAULTS) do if ProfLevelCharDB[k] == nil then ProfLevelCharDB[k] = type(v) == "table" and {} or v end end
  db = ProfLevelCharDB
  ShengProfessionDB = ShengProfessionDB or {}
  ShengProfessionDB.shop = ShengProfessionDB.shop or {} -- 各角色衝級材料要買的（「全部角色」合併看）
  NS.applyLang(db.lang); NS.relabel() -- /sprof lang：存檔讀到後才套用
  if (db.dockV or 0) < 2 then db.dock = false; db.dockV = 2 end -- 自動開改成預設關閉（點了才打開）
  if db.tabV ~= 1 then db.tab = "profit"; db.tabV = 1 end -- 主體改成利潤與佇列，衝級變成其中一個分頁
  return db
end

-- 金錢：12金34銀56銅（100 金以上不顯示銅）
local function money(c)
  c = math.floor((c or 0) + 0.5)
  if c <= 0 then return "0" end
  local g, s, cu = math.floor(c / 10000), math.floor(c % 10000 / 100), c % 100
  local t = {}
  if g > 0 then t[#t + 1] = "|cffffd100" .. g .. L["金"] .. "|r" end
  if s > 0 then t[#t + 1] = "|cffc7c9cc" .. s .. L["銀"] .. "|r" end
  if cu > 0 and g < 100 then t[#t + 1] = "|cffc9814a" .. cu .. L["銅"] .. "|r" end
  return table.concat(t, " ") -- 金銀銅之間空一格比較好讀（欄寬會跟著量）
end

-- ── 遊戲資料 ───────────────────────────────────────────────────────────────
-- 只有升階提示用到的專業（沒有衝級路線）
local EXTRA = { { key = "herbalism", name = "草藥學", line = 182 }, { key = "skinning", name = "剝皮", line = 393 }, { key = "fishing", name = "釣魚", line = 356 } }
local EXTRA_BY_LINE, EXTRA_BY_NAME = {}, { ["草藥"] = EXTRA[1] }
for _, p in ipairs(EXTRA) do EXTRA_BY_LINE[p.line] = p; EXTRA_BY_NAME[p.name] = p end
-- 顯示名稱跟著介面語言（存檔讀到後才知道 /sprof lang）；偵測用的名稱表收所有語言的寫法（舊版 API 用遊戲語言的名稱）
local NAMED = { MINING, EXTRA[1], EXTRA[2], EXTRA[3] }
for _, p in ipairs(PROFS) do NAMED[#NAMED + 1] = p end
for _, p in ipairs(NAMED) do
  p.zhName = p.name
  local byName = PROF_BY_LINE[p.line] == p and PROF_BY_NAME or EXTRA_BY_NAME
  for _, t in pairs(NS.locales) do if t[p.name] then byName[t[p.name]] = p end end
end
function NS.relabel() for _, p in ipairs(NAMED) do p.name = L[p.zhName] end end

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
local function nextRank(key, sk)
  local t = sk and TRAIN[key]
  local rk = t and ((sk.max == 150 and "expert") or (sk.max == 225 and "master"))
  if rk and t[rk] then return t[rk], rk == "expert" and L["專家"] or L["大師"] end
end
-- 訓練師「地點 名字」（中文以外是「名字, 地點」）
local function whoAt(a)
  if NS.zh or NS.lang == "zhCN" then return loc(a, "place") .. " " .. loc(a, "name") end
  return loc(a, "name") .. ", " .. loc(a, "place")
end
-- 一行說明，例如「下一階 大師：斯通納德 羅格瓦爾（35 級、技能 200、5 金）」；第二個回傳值：角色等級還不夠；第四個：不含括號條件的短版
local function rankText(key, sk)
  local R, label = nextRank(key, sk)
  if not R then return end
  local need = {}
  if R.level then need[#need + 1] = string.format(L["%d 級"], R.level) end
  need[#need + 1] = string.format(L["技能 %d"], R.skill)
  if R.cost >= 10000 then need[#need + 1] = string.format(L["%s 金"], R.cost / 10000) elseif R.cost > 0 then need[#need + 1] = string.format(L["%s 銀"], R.cost / 100) end
  -- 非中文：遊戲語言跟介面相同時書名、任務名先問遊戲，查不到用資料表的翻譯
  local book = R.book and ((NS.gameText and R.bookID and C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(R.bookID)) or loc(R, "book"))
  local quest = R.quest and ((NS.gameText and R.questID and C_QuestLog and C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(R.questID)) or loc(R, "quest"))
  local how = (book and string.format(L["　買《%s》"], book)) or (quest and string.format(L["　任務「%s」"], quest)) or ""
  local short = string.format(L["下一階 %s：%s%s"], label, whoAt(R.at[1]), how)
  return string.format(L["%s（%s）"], short, table.concat(need, L["、"])), (R.level or 0) > (UnitLevel("player") or 0), R, short
end
-- 升階提示的滑鼠提示：完整文字＋每個訓練師的位置
local function rankTip(owner, full, R)
  if not full or full == "" then return end
  GameTooltip:SetOwner(owner, "ANCHOR_TOP")
  GameTooltip:AddLine(full, 1, .82, 0, true)
  for _, a in ipairs(R and R.at or {}) do
    GameTooltip:AddDoubleLine(whoAt(a), a.map and string.format("%.1f, %.1f", a.x, a.y) or "", 1, 1, 1, .6, .6, .6)
  end
  if R and R.note then GameTooltip:AddLine(loc(R, "note"), .8, .8, .8, true) end
  GameTooltip:Show()
end
local function goTo(a)
  if not (a and a.map) then return end
  local api = WaypointUIAPI and WaypointUIAPI.Navigation
  if api and type(api.NewUserNavigation) == "function"
    and pcall(api.NewUserNavigation, { name = loc(a, "name"), mapID = a.map, x = a.x, y = a.y, flags = "ShengProfession" }) then return end
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
  if db.useBag and db.useBank then return L["已扣掉背包和銀行裡的數量"] end
  if db.useBag then return L["已扣掉背包裡的數量（不扣銀行）"] end
  if db.useBank then return L["已扣掉銀行裡的數量（不扣背包）"] end
  return L["沒有扣掉背包和銀行裡的數量"]
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
  name = name or ((NS.zh or NS.clientZh) and d and d[1]) or ("#" .. id) -- 資料表的名稱是中文，其他語言等遊戲讀到再顯示
  icon = icon or (d and d[3] and ("Interface\\Icons\\" .. d[3])) or "Interface\\Icons\\INV_Misc_QuestionMark"
  local col = QUALITY[(d and d[2]) or "common"] or QUALITY.common
  return name, icon, col
end

local function srcName(s)
  if SRC[s] then return L[SRC[s]] end
  if s == nil or s == "" then return "" end
  local name -- 依查字順序找 npcs_<語言>（和英文同名的不列），都沒有用繁中
  for _, code in ipairs(NS.chain) do name = name or (D["npcs_" .. code] or {})[s] end
  return string.format(L["%s（商人）"], name or D.npcs[s] or s)
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
  local sk = learned[rec.prof]
  if not sk or sk.cur < rec.minSkill then return nil end
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

-- 視窗裡的短暫回饋（不印聊天）：失敗原因用琥珀色寫在總計那行，5 秒後清掉；成功時按鈕文字暫時換成結果，2 秒後換回
local flash = { label = {} }
local function flashNote(text)
  local token = {}
  flash.note, flash.token = text, token
  C_Timer.After(5, function() if flash.token == token then flash.note = nil; ProfLevel_Refresh() end end)
end
local function flashLabel(key, text)
  local token = {}
  flash.label[key] = { text = text, token = token }
  C_Timer.After(2, function()
    local f = flash.label[key]
    if f and f.token == token then flash.label[key] = nil; ProfLevel_Refresh() end
  end)
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
  if added > 0 then flashLabel("route", L["已加入"]) end
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
-- 失敗原因寫在視窗總計那行（琥珀色、5 秒）；成功不說話（佇列數字自己會變）
local function craftNext()
  local p = openProf()
  if not p then flashNote(L["先打開專業視窗"]); return end
  local T = C_TradeSkillUI
  for _, q in ipairs(db.queue) do
    if q.count > 0 and q.prof == p.key then
      q.id = q.id or findRecipe(p.key, q.out)
      if not q.id then flashNote(string.format(L["找不到配方：%s"], recipeName(q))); return end
      local rec = db.recipes[p.key] and db.recipes[p.key][q.id]
      local n = math.min(q.count, rec and canMakeNow(rec) or q.count)
      if T and T.GetRecipeInfo then
        local ok, ri = pcall(T.GetRecipeInfo, q.id)
        if ok and type(ri) == "table" and type(ri.numAvailable) == "number" then n = math.min(q.count, ri.numAvailable) end
      end
      if n <= 0 then
        -- 寫出第一個不夠的材料（只算背包裡的）；不知道材料就寫配方名
        local short
        for _, m in ipairs(rec and rec.mats or {}) do if not short and bagCount(m[1]) < m[2] then short = info("i", m[1]) end end
        flashNote(string.format(L["材料不夠：%s"], short or recipeName(q, rec)))
        return
      end
      if T and T.CraftRecipe then T.CraftRecipe(q.id, n)
      elseif DoTradeSkill and rec and rec.index then DoTradeSkill(rec.index, n)
      else flashNote(L["這個遊戲版本不支援從插件製作"]) end
      return
    end
  end
  flashNote(string.format(L["佇列裡沒有%s要做的東西"], p.name))
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
local W, ROW_H, MAXLINES, GAP = 600, 24, 20, 16
-- 排序箭頭用貼圖（所有語系一樣；英文等字型沒有 ▼▲）
local ARROW_DOWN = "|TInterface\\Buttons\\UI-SortArrow:8:9:0:0:16:16:0:9:0:16|t "
local ARROW_UP = "|TInterface\\Buttons\\UI-SortArrow:8:9:0:0:16:16:0:9:16:0|t "
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

-- ── 文字適配（所有語言共用的規則）──────────────────────────────────────────
-- 單行文字只有兩種：寬度算進視窗下限（會撐寬），或 fitTextTip（限寬＋滑鼠提示看全文）；不准引擎自己截斷、不准放不下就隱藏。

-- 放得下就用完整文字，不然換短版，再不行就截斷加「…」；回傳有沒有縮短（呼叫的地方要有提示框顯示完整文字）
-- 截斷：色碼、材質、連結當成零寬度整段保留（截完補 |r）；中日韓逐字，拉丁／西里爾文字退到空白；連「…」都放不下才隱藏
local function fitText(fs, maxW, full, short)
  fs:Show(); fs:SetText(full)
  if measure(fs) <= maxW then return false end
  local t = short or full
  fs:SetText(t)
  if measure(fs) <= maxW then return true end
  local tk, vis = {}, {} -- tk：每一段文字；vis：可見字在 tk 裡的位置
  local i = 1
  while i <= #t do
    local esc = t:match("^|c%x%x%x%x%x%x%x%x", i) or t:match("^|r", i) or t:match("^|T.-|t", i) or t:match("^|H.-|h", i) or t:match("^|h", i)
    local c = esc or t:match("^[%z\1-\127\194-\244][\128-\191]*", i) or t:sub(i, i)
    tk[#tk + 1] = c
    if not esc then vis[#vis + 1] = #tk end
    i = i + #c
  end
  local function cut(n) -- 前 n 個可見字（含中間的色碼）＋「…」
    local s = table.concat(tk, "", 1, n > 0 and vis[n] or 0)
    local open = false
    for code in s:gmatch("|[cr]") do open = code == "|c" end
    return s .. (open and "|r" or "") .. L["…"]
  end
  local lo, hi = 0, #vis
  while lo < hi do
    local mid = math.ceil((lo + hi) / 2)
    fs:SetText(cut(mid))
    if measure(fs) <= maxW then lo = mid else hi = mid - 1 end
  end
  -- 斷在字中間（前後都是字母）：退到前一個空白
  local function word(n) return n >= 1 and n <= #vis and tk[vis[n]]:find("^[%w'\195-\213]") ~= nil end
  if word(lo) and word(lo + 1) then
    for n = lo - 1, 1, -1 do if tk[vis[n]] == " " then lo = n - 1; break end end
  end
  fs:SetText(cut(lo))
  if lo == 0 and measure(fs) > maxW then fs:SetText(""); fs:Hide() end
  return true
end

-- 給文字掛一塊滑鼠範圍：fitTextTip 有縮短時才出現，移上去顯示完整文字
local function tipArea(fs, parent)
  local h = CreateFrame("Frame", nil, parent); h:SetAllPoints(fs); h:EnableMouse(true); h:Hide()
  h:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(self.full, 1, 1, 1, true); GameTooltip:Show()
  end)
  h:SetScript("OnLeave", function() GameTooltip:Hide() end)
  fs.tip = h
end
local function fitTextTip(fs, maxW, full, short)
  local cut = fitText(fs, maxW, full, short)
  fs.tip.full = full; fs.tip:SetShown(cut)
  return cut
end

-- 按鈕寬度配合文字（字型較大時不會超出按鈕）；換字一律走 setLabel
local function fitButton(b, minW)
  local fs = b:GetFontString()
  local w = fs and measure(fs) or 0
  if w > 0 then b:SetWidth(math.max(minW or 0, w + 24)) end
end
local function setLabel(b, text, minW) b:SetText(text); fitButton(b, minW) end

local function button(parent, w, label, onClick)
  local b = UI.Button(parent, "", onClick)
  setLabel(b, label, w + 16)
  return b
end

-- 一排從左到右串接的元件要多寬：{ 元件, 左邊間距, 寬度（文字傳 measure 的結果，按鈕省略）}；隱藏的不算
local function rowEnd(list)
  local x = 0
  for _, t in ipairs(list) do if t[1]:IsShown() then x = x + t[2] + (t[3] or t[1]:GetWidth()) end end
  return x
end

-- 視窗內容最多多寬、表格最多幾列：照螢幕大小（換算成視窗自己的縮放），不小於設計值
local function maxContentW()
  return math.max(W, math.floor(UIParent:GetWidth() / frame:GetScale()) - 68)
end
-- 視窗位置一律用左上角（存成 UIParent 的座標）：切分頁改大小時標題和分頁列不動，只有右緣、下緣變
local function saveTopLeft()
  local l, t, s = frame:GetLeft(), frame:GetTop(), frame:GetScale()
  if not (l and t) then return end
  frame:ClearAllPoints(); frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", l, t)
  db.pos = { l * s, t * s }
end
local function placeTopLeft()
  if not db.pos then return end
  local s = frame:GetScale()
  frame:ClearAllPoints(); frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.pos[1] / s, db.pos[2] / s)
end
-- 視窗寬只增不減（這次登入看過的最大值），切分頁時右緣不會跳；縮放改了才重算
local function setFrameWidth(w)
  w = math.max(w, frame.stableW or 0)
  frame.stableW = w; frame:SetWidth(w)
  return w
end
local function visibleRows(top)
  return math.max(5, math.min(MAXLINES, math.floor((UIParent:GetHeight() / frame:GetScale() - top - 44 - 40) / ROW_H)))
end

-- 採集分頁列出的技能：採礦、草藥、剝皮、釣魚（烹飪、急救不是採集，下一階提示在專業切換的狀態列）
local GATHER = { MINING, EXTRA[1], EXTRA[2], EXTRA[3] }

local function profList(learned)
  local list = {}
  for _, p in ipairs(PROFS) do if learned[p.key] then table.insert(list, p) end end
  for _, p in ipairs(PROFS) do if not learned[p.key] then table.insert(list, p) end end
  return list
end

-- 欄寬照表頭和每列的文字量；回傳表格要多寬。超過螢幕放得下的寬度時先縮名稱欄（截斷的名稱，列的滑鼠提示有完整物品）
local function autoFit(cols)
  local ws, nameC, total = {}, nil, -GAP
  for c = 1, NCOL do
    local col = cols[c]
    if col then
      local w = math.max(col[2], measure(frame.headFs[c]) + 4)
      for i = 1, MAXLINES do
        local l = frame.lines[i]
        if l.used then w = math.max(w, measure(l.c[c]) + 4 + (col[4] and 26 or 0)) end
      end
      ws[c] = math.ceil(w)
      total = total + ws[c] + GAP
      if col[4] then nameC = c end
    end
  end
  local cap = maxContentW()
  if nameC and total > cap then
    local w = math.max(cols[nameC][2], ws[nameC] - (total - cap))
    total = total - ws[nameC] + w
    ws[nameC] = w
    for i = 1, MAXLINES do
      local l = frame.lines[i]
      if l.used then fitText(l.c[nameC], w - 26 - 4, l.c[nameC]:GetText()) end
    end
  end
  local x = 0
  for c = 1, NCOL do
    local col = cols[c]
    local hf = frame.headFs[c]
    if col then
      local iconW = col[4] and 26 or 0
      local w = ws[c]
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
  return math.max(total, W)
end

-- 右下角的調整把手：拖曳放大縮小整個視窗（左上角固定），大小記在設定裡
local function addResizeGrip(f)
  local g = CreateFrame("Button", nil, f)
  g:SetSize(18, 18); g:SetPoint("BOTTOMRIGHT", -4, 4); g:SetFrameLevel(f:GetFrameLevel() + 10)
  g:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  g:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  g:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  g:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:AddLine(L["拖曳調整視窗大小"]); GameTooltip:Show()
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
  g:SetScript("OnMouseUp", function(self) -- 縮放變了，螢幕放得下的寬度和列數跟著變
    self:SetScript("OnUpdate", nil); saveTopLeft(); f.stableW = nil; ProfLevel_Refresh()
  end)
  g:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
end


-- 設定裡的介面語言：跟隨客戶端，或客戶端字型顯示得出來的語言（NS.canShow）
local LANG_NAMES = { { "auto" }, { "zh", "繁體中文", "zhTW" }, { "zhCN", "简体中文", "zhCN" }, { "en", "English", "enUS" }, { "deDE", "Deutsch", "deDE" },
  { "frFR", "Français", "frFR" }, { "esES", "Español (EU)", "esES" }, { "esMX", "Español (AL)", "esMX" }, { "ptBR", "Português (BR)", "ptBR" },
  { "ruRU", "Русский", "ruRU" }, { "koKR", "한국어", "koKR" } }
local function langOpts()
  local cur = db.lang == "en" and "enUS" or db.lang == "zh" and "zhTW" or NS.locales[db.lang] and db.lang or nil
  local out = {}
  for _, x in ipairs(LANG_NAMES) do
    local c = x[3]
    if not c or (c == "zhTW" and NS.clientZh) or (c ~= "zhTW" and NS.locales[c] and NS.canShow(c)) then
      out[#out + 1] = { code = x[1], name = x[2] or L["跟隨客戶端"], on = c == cur }
    end
  end
  if not cur then out[1].on = true end
  return out
end
-- 設定面板（標題列齒輪、小地圖按鈕右鍵）：勾選框照目前設定，由上往下排，面板寬照最寬的一列
local function layoutOpts()
  local o = frame.opts
  if not o:IsShown() then return end
  local y, w = -10, 0
  for _, c in ipairs(o.checks) do
    c:SetCheck(c.get()); c:ClearAllPoints(); c:SetPoint("TOPLEFT", o, "TOPLEFT", 12, y)
    y = y - 24; w = math.max(w, c:GetWidth())
  end
  for _, x in ipairs(langOpts()) do if x.on then o.langBtn:SetText(x.name); o.langBtn:SetWidth(math.ceil(UI.measure(o.langBtn.label)) + 24) end end
  o.langRow:SetWidth(math.ceil(UI.measure(o.langLabel)) + 8 + o.langBtn:GetWidth())
  o.langRow:ClearAllPoints(); o.langRow:SetPoint("TOPLEFT", o, "TOPLEFT", 12, y - 2)
  y = y - 30; w = math.max(w, o.langRow:GetWidth())
  o:SetSize(math.max(180, w) + 24, -y + 6)
end

-- 清掉其他角色存的材料清單（要按兩次）
local function clearOthers()
  if frame.altArm then
    frame.altArm = nil
    for _, c in ipairs(frame.others or {}) do ShengProfessionDB.shop[c.name .. "-" .. c.realm] = nil end
    db.shopAll = false
    return
  end
  local token = {}
  frame.altArm = token
  C_Timer.After(3, function() if frame.altArm == token then frame.altArm = nil; ProfLevel_Refresh() end end)
end
-- 清空佇列：兩段式。第一下按鈕變紅字「再按一次清空」，3 秒內再按才清
local function clearQueue()
  if frame.clearArm then frame.clearArm = nil; wipe(db.queue); return end
  local token = {}
  frame.clearArm = token
  C_Timer.After(3, function() if frame.clearArm == token then frame.clearArm = nil; ProfLevel_Refresh() end end)
end

local function refreshImpl()
  if not frame or not frame:IsShown() then return end
  priceCache = {}
  layoutOpts()
  local isLv = db.tab == "steps" or db.tab == "shop"
  for _, t in ipairs({ { frame.profitBtn, "profit" }, { frame.queueBtn, "queue" }, { frame.levelBtn, "level" }, { frame.gatherBtn, "gather" } }) do
    t[1]:SetOn(db.tab == t[2] or (t[2] == "level" and isLv))
  end
  frame.stepsBtn:SetOn(db.tab == "steps"); frame.shopBtn:SetOn(db.tab == "shop")
  -- 分頁列有多寬：視窗至少要這麼寬
  local tabs = { { frame.profitBtn, 10 }, { frame.queueBtn, 2 }, { frame.levelBtn, 2 }, { frame.gatherBtn, 2 } }
  frame.main:SetShown(db.tab ~= "gather"); frame.gather:SetShown(db.tab == "gather")
  frame.sb:Hide()
  if db.tab == "gather" then
    -- 採集分頁：每個採集／副專業一行（名稱、點數、下一階、去），下面是採集相關設定
    local g, all = frame.gather, learnedProfs(true)
    g.trackBtn:SetCheck(NS.trackOn())
    local shown, nameW = {}, 0
    for _, p in ipairs(GATHER) do
      local sk = all[p.key]
      if sk then
        local i = #shown + 1
        local r = g.rows[i]
        if not r then
          r = CreateFrame("Frame", nil, g); r:SetSize(1, 24)
          r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal"); r.name:SetPoint("LEFT"); r.name:SetWordWrap(false)
          r.hint = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); r.hint:SetWordWrap(false)
          r.hit = CreateFrame("Frame", nil, r); r.hit:SetAllPoints(r.hint); r.hit:EnableMouse(true)
          r.hit:SetScript("OnEnter", function(self) rankTip(self, r.full, r.R) end)
          r.hit:SetScript("OnLeave", function() GameTooltip:Hide() end)
          r.go = button(r, 20, L["去"], function() goTo(r.R and r.R.at[1]) end)
          r.go:SetHeight(20); r.go:SetPoint("LEFT", r.hint, "RIGHT", 6, 0)
          r.go:SetScript("OnEnter", function(self) rankTip(self, r.full, r.R) end)
          r.go:SetScript("OnLeave", function() GameTooltip:Hide() end)
          g.rows[i] = r
        end
        r.name:SetText(string.format("%s %d/%d", p.name, sk.cur, sk.max))
        nameW = math.max(nameW, measure(r.name))
        local tr, low, R, short = rankText(p.key, sk)
        r.full = tr or (sk.max >= 300 and L["已是大師"]) or (sk.max <= 75 and L["下一階：任一訓練師（10 級、技能 50）"]) or ""
        r.short, r.R = short, R
        r.ready = tr and not low and sk.cur >= R.skill
        shown[i] = r
      end
    end
    -- 寬度下限：分頁列、追蹤提醒、技能名稱＋至少 80 的下一階提示＋去、採集路線（上次排版量到的）；上限是螢幕
    local fw = math.min(maxContentW() + 28, math.max(W + 28, rowEnd(tabs) + 14, rowEnd({ { g.trackBtn, 14 } }) + 14,
      math.ceil(nameW) + 14 + 80 + 32 + 28, frame.routeNeed or 0))
    fw = setFrameWidth(fw)
    local y = -66
    for _, r in ipairs(shown) do
      r:ClearAllPoints(); r:SetPoint("TOPLEFT", 14, y); r:Show()
      r.hint:ClearAllPoints(); r.hint:SetPoint("LEFT", r, "LEFT", math.ceil(nameW) + 14, 0)
      r.go:SetShown(r.R ~= nil and r.R.at[1].map ~= nil)
      fitText(r.hint, fw - 28 - math.ceil(nameW) - 14 - (r.go:IsShown() and r.go:GetWidth() + 6 or 0), r.full, r.short)
      if r.ready then r.hint:SetTextColor(1, .82, 0) else r.hint:SetTextColor(.6, .6, .6) end
      y = y - 26
    end
    for i = #shown + 1, #g.rows do g.rows[i]:Hide() end
    g.empty:SetShown(#shown == 0)
    if #shown == 0 then g.empty:ClearAllPoints(); g.empty:SetPoint("TOPLEFT", 14, y - 4); y = y - 26 end
    g.sep:ClearAllPoints(); g.sep:SetPoint("TOPLEFT", 14, y - 6); g.sep:SetWidth(fw - 28)
    y = y - 14
    g.trackBtn:ClearAllPoints(); g.trackBtn:SetPoint("TOPLEFT", 14, y - 2)
    local ry, need = nil, nil
    if NS.routeLayout then ry, need = NS.quiet("採集路線", NS.routeLayout, g, fw, y - 30, all) end -- 採集路線（RouteMap.lua）
    -- 路線標題列、區域名＋範圍比現在的視窗寬：記下來，馬上用新寬度重排一次（第二次一定放得下，不會一直重排）
    local grow = need and need > fw and need ~= frame.routeNeed
    frame.routeNeed = need
    if grow then return refreshImpl() end
    frame:SetHeight(ry and (-ry + 14) or (-y + 26 + 16))
    return
  end
  local learned = learnedProfs()
  local list = profList(learned)
  if not db.prof or not PROF_BY_KEY[db.prof] then db.prof = list[1].key end
  local p = PROF_BY_KEY[db.prof]
  local sk = learned[p.key]
  local S = tonumber(db.from[p.key]) or (sk and sk.cur) or 1
  local T = tonumber(db.to[p.key]) or 300
  S = math.max(1, math.min(299, math.floor(S)))
  T = math.max(S + 1, math.min(300, math.floor(T)))
  -- 專業按鈕固定用最長的專業名稱量一次，切專業時後面的元件不會左右跳
  if not frame.profW then
    local w = 0
    for _, q in ipairs(PROFS) do
      for _, s in ipairs({ q.name .. L["（沒學）"], q.name .. string.format(L["（%d）"], 300) }) do
        frame.profBtn:SetText(s); w = math.max(w, measure(frame.profBtn:GetFontString()))
      end
    end
    frame.profW = math.max(146, math.ceil(w) + 24)
  end
  setLabel(frame.profBtn, p.name .. (sk and string.format(L["（%d）"], sk.cur) or L["（沒學）"]), frame.profW)
  if not frame.fromBox:HasFocus() then frame.fromBox:SetText(tostring(S)) end
  if not frame.toBox:HasFocus() then frame.toBox:SetText(tostring(T)) end
  local route, r, nVar = pickRoute(p.key, S, T)
  if db.decompose then r = decompose(r, learned) end
  current = { prof = p, S = S, T = T, route = route, r = r }
  local pbTotal, stepVal = payback(route, r)
  -- 跨角色：這隻角色衝級材料要買的存進帳號存檔；材料頁勾「全部角色」時合併同伺服器、同陣營其他角色的
  local shop, realm, faction = ShengProfessionDB.shop, GetRealmName() or "", UnitFactionGroup("player")
  local me = (UnitName("player") or "?") .. "-" .. realm
  if isLv then
    local items = {}
    for _, it in ipairs(r.list) do if it.buy > 0 and it.kind ~= "craft" then items[#items + 1] = { id = it.id, kind = it.kind, qty = it.qty, have = it.have, buy = it.buy } end end
    shop[me] = #items > 0 and { realm = realm, faction = faction, name = UnitName("player"), class = select(2, UnitClass("player")), prof = p.key, S = S, T = T, items = items } or nil
  end
  local others = {}
  for k, c in pairs(shop) do if k ~= me and c.realm == realm and c.faction == faction then others[#others + 1] = c end end
  table.sort(others, function(a, b) return a.name < b.name end)
  frame.others = others
  if db.tab == "shop" and db.shopAll and #others > 0 then
    local list, byKey, total, missing = {}, {}, 0, 0
    local function put(it, who)
      local k = it.kind .. it.id
      local m = byKey[k]
      if not m then m = { id = it.id, kind = it.kind, qty = 0, have = 0, buy = 0, unit = price(it.id), who = {} }; byKey[k] = m; list[#list + 1] = m end
      m.qty, m.have, m.buy = m.qty + it.qty, m.have + it.have, m.buy + it.buy
      if it.buy > 0 then m.who[#m.who + 1] = { who, it.buy } end
    end
    for _, it in ipairs(r.list) do if it.kind == "craft" then list[#list + 1] = it else put(it, UnitName("player")) end end
    for _, c in ipairs(others) do for _, it in ipairs(c.items) do put(it, c.name) end end
    for _, it in ipairs(list) do
      if it.kind ~= "craft" then if it.unit then total = total + it.unit * it.buy elseif it.buy > 0 then missing = missing + 1 end end
    end
    local order = { recipe = 1, tool = 2, craft = 3, mat = 3 }
    table.sort(list, function(a, b)
      if order[a.kind] ~= order[b.kind] then return order[a.kind] < order[b.kind] end
      return (a.unit or 0) * a.buy > (b.unit or 0) * b.buy
    end)
    r = { list = list, total = total, missing = missing, all = true }
    current.r = r
  end
  local qr
  if db.tab == "queue" then qr = queueNeeds(learned); current.r = qr; current.queue = true end
  -- 價格來源那行（status）：有 Auctionator 時不顯示（「從 N 條路線選出最省的」放進總計那行的滑鼠提示），沒有才出琥珀警告；
  -- 總計那行（total）只放數字結論，寬度算進視窗下限；利潤頁沒有總計那行
  -- 警告（沒有 Auctionator、沒有價格、不知道材料）不跟數字搶位置：放進總計後面的黃色標記，滑鼠移上去看
  local api = auctionator()
  local statusFull = not api and ("|cffff9d5c" .. L["沒有偵測到 Auctionator，只有商人物品有價格（使用預設路線）"] .. "|r") or nil
  local statusShort = not api and ("|cffff9d5c" .. L["沒有 Auctionator"] .. "|r") or nil
  local warns, totalTip = {}, {}
  if not api then warns[1] = L["沒有偵測到 Auctionator，只有商人物品有價格（使用預設路線）"] end
  local totalFull, totalShort, emptyTxt
  if db.tab == "queue" then
    local nq = 0
    for _, q in ipairs(db.queue) do nq = nq + q.count end
    totalFull = string.format(L["製作佇列 %d 項（共 %d 次）　材料花費 %s"], #db.queue, nq, money(qr.total))
    if qr.missing > 0 then warns[#warns + 1] = string.format(L["%d 項沒有價格"], qr.missing) end
    if qr.unknown > 0 then warns[#warns + 1] = string.format(L["%d 項還不知道材料（打開那個專業視窗一次）"], qr.unknown) end
    emptyTxt = L["佇列是空的：從「利潤」或「衝級」加入"]
  elseif db.tab == "profit" then
    emptyTxt = string.format(L["打開%s的專業視窗一次，插件就會記下你學會的配方"], p.name) -- 怎麼加入佇列：列滑過時佇列欄出現「+」
  else
    totalShort = string.format(L["%s %d–%d　花費 %s"], p.name, S, T, money(r.total))
    -- 回本超過花費時改顯示淨賺（原本會顯示淨花費 0）
    totalFull = totalShort .. (pbTotal > 0.5 and (pbTotal > r.total
      and string.format(L["　|cff9fd18b回本 %s|r　|cff9fd18b淨賺 %s|r"], money(pbTotal), money(pbTotal - r.total))
      or string.format(L["　|cff9fd18b回本 %s|r　淨花費 %s"], money(pbTotal), money(r.total - pbTotal))) or "")
    if api then totalTip[#totalTip + 1] = string.format(L["價格：Auctionator　從 %d 條路線選出最省的"], nVar) end
    if r.saved and r.saved > 0.5 then totalTip[#totalTip + 1] = "|cff9fd18b" .. string.format(L["自製中間材料省 %s"], money(r.saved)) .. "|r" end
    if r.missing > 0 then warns[#warns + 1] = string.format(L["%d 項沒有價格"], r.missing) end
    emptyTxt = L["這個範圍不需要製作任何東西"]
    if r.all then totalShort = string.format(L["全部角色　花費 %s"], money(r.total)); totalFull = totalShort end
  end
  frame.warn.lines = warns; frame.warn:SetShown(#warns > 0 and totalFull ~= nil)
  -- 第三列：左邊衝級的子分頁（步驟／材料），右邊開關（勾選框，靠右對齊）
  frame.decBtn:SetCheck(db.decompose); frame.bagBtn:SetCheck(db.useBag); frame.bankBtn:SetCheck(db.useBank)
  frame.bagBtn:SetShown(db.tab == "queue"); frame.bankBtn:SetShown(db.tab == "queue")
  frame.allBtn:SetCheck(db.shopAll); frame.allBtn:SetShown(db.tab == "shop" and #others > 0)
  for _, w in ipairs({ frame.fromLbl, frame.fromBox, frame.toLbl, frame.toBox, frame.nowBtn, frame.stepsBtn, frame.shopBtn }) do w:SetShown(isLv) end
  local prevR
  for _, c in ipairs({ frame.allBtn, frame.bankBtn, frame.bagBtn, frame.decBtn }) do
    if c:IsShown() then
      c:ClearAllPoints()
      if prevR then c:SetPoint("RIGHT", prevR, "LEFT", -14, 0) else c:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, -89) end
      prevR = c
    end
  end
  local row3 = { { frame.stepsBtn, 8 }, { frame.shopBtn, 2 }, { frame.decBtn, 24 }, { frame.bagBtn, 14 }, { frame.bankBtn, 14 }, { frame.allBtn, 14 } }
  frame.atrBtn:SetShown(api ~= nil and api.CreateShoppingList ~= nil)
  -- 由上往下：升階提示／價格警告那行（有才佔位）、總計那行（利潤頁沒有）、表頭、表格
  local tr, low, R, short = rankText(p.key, sk)
  if tr and sk.cur < math.min(sk.max - 10, R.skill) then tr = nil end
  local lineY, y = -116, -116
  if tr or statusFull then y = y - 22 end
  frame.total:SetShown(totalFull ~= nil)
  if totalFull then frame.total:ClearAllPoints(); frame.total:SetPoint("TOPLEFT", 14, y - 2); y = y - 28 end
  local top = -y + 26
  frame.head:ClearAllPoints(); frame.head:SetPoint("TOPLEFT", 14, y)
  -- 內容
  local cols = TABS[db.tab]
  for c = 1, NCOL do
    local col = cols[c]
    local lbl = col and L[col[1]] or ""
    if col and col[5] and col[5] == db.psort then lbl = (db.pdesc ~= false and ARROW_DOWN or ARROW_UP) .. lbl end
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
  -- 表格最多幾列照螢幕高度（20 列 × 1.25 倍在 768 高的介面會超出），多的用滾輪捲動
  local vis = visibleRows(top)
  local maxOff = math.max(0, #rows - vis)
  if offset > maxOff then offset = maxOff end
  local shown = 0
  for i = 1, MAXLINES do
    local l, e = frame.lines[i], i <= vis and rows[i + offset] or nil
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
        vals = { name, e.cost and money(e.cost) or ("|cffff9d5c" .. L["沒價格"] .. "|r"), e.sell and money(e.sell) or "—", pf, pc,
          e.listed and tostring(e.listed) or "—", e.can > 0 and e.can or "0", e.queued > 0 and ("|cffffd100" .. e.queued .. "|r") or "" }
        l.c[1]:SetTextColor(col[1], col[2], col[3])
      elseif e.queue then
        local q = e.queue
        local rec = q.id and db.recipes[q.prof] and db.recipes[q.prof][q.id]
        local name, icon, col
        if q.out then name, icon, col = info("i", q.out) else name, icon, col = info("s", q.id or 0); name = q.name or name end
        l.icon:SetTexture(icon); l.icon:Show()
        local pn = q.prof == "mining" and MINING.name or (PROF_BY_KEY[q.prof] and PROF_BY_KEY[q.prof].name or q.prof)
        local miss, matTxt = 0, "|cffff9d5c" .. L["不知道材料"] .. "|r"
        if rec then
          for _, m in ipairs(rec.mats) do if bagCount(m[1]) < m[2] * q.count then miss = miss + 1 end end
          matTxt = miss == 0 and ("|cff9fd18b" .. L["齊了"] .. "|r") or ("|cffff9d5c" .. string.format(L["缺 %d 種"], miss) .. "|r")
        end
        vals = { name, "×" .. q.count, pn, matTxt, rec and canMakeNow(rec) or "—" }
        l.c[1]:SetTextColor(col[1], col[2], col[3])
      elseif e.prep then
        local c = e.prep
        local name, icon, col = info("i", c.id)
        l.icon:SetTexture(icon); l.icon:Show()
        local pn = c.rec.prof == "mining" and MINING.name or (PROF_BY_KEY[c.rec.prof] and PROF_BY_KEY[c.rec.prof].name or "")
        vals = { L["準備"], name, "×" .. c.n, string.format(L["自己做（%s）"], pn) }
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
        local tag = it.kind == "recipe" and ("|cfff0cf7f" .. L["（配方）"] .. "|r") or (D.vendor[it.id] and ("|cff9fd18b" .. L["（商人）"] .. "|r") or "")
        if it.kind == "craft" then
          vals = { name .. "|cff8cc4ff" .. string.format(L["（自己做 ×%d）"], it.n) .. "|r", it.qty, it.have > 0 and ("|cff9fd18b" .. it.have .. "|r") or "0", "—",
            it.unit and string.format(L["自製 %s"], money(it.unit)) or "—", it.saved and ("|cff9fd18b" .. string.format(L["省 %s"], money(it.saved)) .. "|r") or "—" }
        else
          vals = { name .. tag, it.qty, it.have > 0 and ("|cff9fd18b" .. it.have .. "|r") or "0", it.buy,
            it.unit and money(it.unit) or ("|cffff9d5c" .. L["沒價格"] .. "|r"), it.unit and money(it.unit * it.buy) or "—" }
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
  -- 視窗寬：表格（佇列頁每列右端多一個「×」）、每一排橫向串接的元件（分頁列、第二、三列）、總計那行（數字不截，最多撐到螢幕寬）取最大
  local row2 = { { frame.prevBtn, 12 }, { frame.profBtn, 2 }, { frame.nextBtn, 2 }, { frame.fromLbl, 12, measure(frame.fromLbl) }, { frame.fromBox, 8 },
    { frame.toLbl, 8, measure(frame.toLbl) }, { frame.toBox, 8 }, { frame.nowBtn, 6 } }
  local warnW = frame.warn:IsShown() and frame.warn:GetWidth() + 6 or 0
  frame.total:SetText(totalFull or "")
  local cap = maxContentW()
  local fw = math.max(autoFit(cols) + (db.tab == "queue" and 22 or 0) + 28, rowEnd(tabs) + 14, rowEnd(row2) + 14, rowEnd(row3) + 14,
    totalFull and (math.min(math.ceil(measure(frame.total)) + warnW, cap) + 28) or 0)
  fw = setFrameWidth(fw)
  local avail = fw - 28
  frame.head:SetWidth(avail)
  for i = 1, MAXLINES do
    local l = frame.lines[i]
    l:SetWidth(avail); l:ClearAllPoints(); l:SetPoint("TOPLEFT", 14, -top - (i - 1) * ROW_H)
    l.del:SetShown(l.used and l.e.queue ~= nil)
  end
  local usedW = 0
  if totalFull then
    -- 總計那行的滑鼠提示：被截斷時的全文、價格來源（從幾條路線選出最省的）、自製中間材料省多少
    local cut = fitText(frame.total, avail - warnW, totalFull, totalShort)
    if cut then table.insert(totalTip, 1, totalFull) end
    frame.total:SetWidth(math.min(avail - warnW, math.ceil(measure(frame.total)) + 2)) -- 警告標記緊接在數字後面
    frame.total.tip.full = table.concat(totalTip, "\n"); frame.total.tip:SetShown(#totalTip > 0)
    usedW = frame.total:GetWidth() + warnW
  else
    frame.total.tip:Hide()
  end
  -- 空的時候：說明放在表格的位置（可換行，不會因為按鈕太寬就看不到）
  local emptyH = 0
  frame.empty:SetShown(#rows == 0)
  if #rows == 0 then
    frame.empty:ClearAllPoints(); frame.empty:SetPoint("TOPLEFT", 14, -(top + 6))
    frame.empty:SetWidth(avail); frame.empty:SetText(emptyTxt)
    local h = frame.empty:GetStringHeight()
    emptyH = math.ceil(type(h) == "number" and h > 0 and h or 14) + 12
  end
  UI.scroll(frame.sb, frame.head, 7, -26, shown * ROW_H, offset, #rows, vis) -- 多的列用滾輪捲動：右緣捲動條
  -- 底部動作按鈕（依分頁）；成功時文字暫時換成結果
  local by = -(top + shown * ROW_H + emptyH + 8)
  local fl = flash.label
  setLabel(frame.atrBtn, fl.list and fl.list.text or L["建立 Auctionator 購物清單"], 0)
  frame.atrBtn:ClearAllPoints(); frame.atrBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, by)
  frame.act1:Hide(); frame.act2:Hide()
  UI.look(frame.act2, nil)
  if db.tab == "steps" then
    setLabel(frame.act1, fl.route and fl.route.text or L["全部加入製作佇列"], 140); frame.act1.fn = queueRoute; frame.act1:Show()
  elseif db.tab == "shop" and current.r.all then
    setLabel(frame.act1, frame.altArm and L["再按一次清空"] or L["清除其他角色"], 110); frame.act1.fn = clearOthers; frame.act1:Show()
    if frame.altArm then UI.look(frame.act1, "danger") end
  elseif db.tab == "queue" then
    setLabel(frame.act1, L["製作下一個"], 120); frame.act1.fn = craftNext; frame.act1:Show()
    setLabel(frame.act2, frame.clearArm and L["再按一次清空"] or L["清空佇列"], 90); frame.act2.fn = clearQueue; frame.act2:Show()
    if frame.clearArm then UI.look(frame.act2, "danger") end
  end
  frame.act1:ClearAllPoints(); frame.act1:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, by)
  frame.act2:ClearAllPoints(); frame.act2:SetPoint("RIGHT", frame.act1, "LEFT", -6, 0)
  local hasAct = frame.act1:IsShown() or frame.atrBtn:IsShown()
  frame:SetHeight(top + shown * ROW_H + emptyH + (hasAct and 40 or 14))
  -- 失敗原因（琥珀色，5 秒）：寫在總計那行的數字後面；沒有總計那行（利潤頁）就寫在底部按鈕之間
  frame.note:ClearAllPoints()
  if flash.note then
    local noteW
    if totalFull then
      frame.note:SetPoint("LEFT", frame.warn:IsShown() and frame.warn or frame.total, "RIGHT", 10, 0)
      noteW = avail - usedW - 10
    else
      local left = frame.atrBtn:IsShown() and frame.atrBtn:GetWidth() + 10 or 0
      frame.note:SetPoint("LEFT", frame, "TOPLEFT", 14 + left, by - 11)
      noteW = avail - left - rowEnd({ { frame.act1, 0 }, { frame.act2, 6 } }) - 10
    end
    frame.note:SetWidth(math.max(1, noteW))
    fitTextTip(frame.note, math.max(1, noteW), flash.note)
  else
    frame.note:Hide(); frame.note.tip:Hide()
  end
  -- 升階提示（點數到上限前 10 點或已夠升階時才出現）：放不下先拿掉括號條件，再截斷（滑鼠移上去看全文和訓練師位置）；
  -- 沒有 Auctionator 的警告接在後面，至少留 60 寬，放不下用短版＋提示框
  frame.status:ClearAllPoints()
  if tr then
    frame.goBtn.R, frame.goBtn.full, frame.trainHit.full = R, tr, tr
    frame.goBtn:SetShown(R.at[1].map ~= nil)
    local goW = frame.goBtn:IsShown() and frame.goBtn:GetWidth() + 6 or 0
    frame.train:ClearAllPoints(); frame.train:SetPoint("TOPLEFT", 14, lineY)
    fitText(frame.train, avail - goW - (statusFull and 70 or 0), tr, short); frame.trainHit:Show()
    if low then frame.train:SetTextColor(.5, .5, .5) else frame.train:SetTextColor(1, .82, 0) end
    if statusFull then
      local rest = avail - math.ceil(measure(frame.train)) - goW - 10
      frame.status:SetPoint("LEFT", frame.goBtn:IsShown() and frame.goBtn or frame.train, "RIGHT", 10, 0)
      frame.status:SetWidth(rest)
      fitTextTip(frame.status, rest, statusFull, statusShort)
    else
      frame.status:Hide(); frame.status.tip:Hide()
    end
  else
    frame.train:Hide(); frame.trainHit:Hide(); frame.goBtn:Hide(); frame.goBtn.R = nil
    if statusFull then
      frame.status:SetPoint("TOPLEFT", 14, lineY); frame.status:SetWidth(avail)
      fitTextTip(frame.status, avail, statusFull, statusShort)
    else
      frame.status:Hide(); frame.status.tip:Hide()
    end
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
  if #terms == 0 then flashNote(L["沒有要在拍賣行買的東西"]); return end
  local listName = current.queue and L["阿聖專業幫手 製作佇列"] or current.r.all and L["阿聖專業幫手 全部角色"] or string.format(L["阿聖專業幫手 %s %d-%d"], current.prof.name, current.S, current.T)
  if safe("建立購物清單", api.CreateShoppingList, CALLER, listName, terms) then flashLabel("list", L["已建立"]) end -- 成功：按鈕短暫寫「已建立」
end



local function numBox(parent, onSet)
  local e = CreateFrame("EditBox", nil, parent)
  UI.box(e, UI.C.EDGE2, { .02, .022, .028, .9 })
  e:SetFontObject(GameFontHighlight); e:SetJustifyH("CENTER"); e:SetTextInsets(2, 2, 0, 0)
  e:SetSize(46, 22); e:SetAutoFocus(false); e:SetNumeric(true); e:SetMaxLetters(3)
  local function commit(self) onSet(tonumber(self:GetText())); self:ClearFocus(); ProfLevel_Refresh() end
  e:SetScript("OnEnterPressed", commit)
  e:SetScript("OnEditFocusLost", function(self) onSet(tonumber(self:GetText())); ProfLevel_Refresh() end)
  e:SetScript("OnEscapePressed", function(self) self:ClearFocus(); ProfLevel_Refresh() end)
  return e
end

local mmBtn -- 小地圖按鈕（建立在下面，設定面板要開關它）
local function buildFrame()
  frame = CreateFrame("Frame", "ProfLevelFrame", UIParent)
  frame:SetSize(W + 28, 300); frame:SetPoint("CENTER"); frame:SetScale(db.scale or 1); placeTopLeft()
  frame:SetClampedToScreen(true) -- 撐寬或貼在專業視窗右邊時不跑出螢幕
  -- 系列外框：標題列、齒輪（設定面板）、關閉（直接隱藏，戰鬥中也關得掉）；層級 HIGH、點到就移到最上面
  UI.Window(frame, L["阿聖專業幫手"], ICON, function() frame.opts:SetShown(not frame.opts:IsShown()); ProfLevel_Refresh() end, L["設定"])
  addResizeGrip(frame)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing(); saveTopLeft() end)
  tinsert(UISpecialFrames, "ProfLevelFrame")
  -- 設定面板：原本只有指令能改的開關
  frame.opts = UI.Panel(frame)
  frame.opts.checks = {}
  local function opt(label, get, set)
    local c = UI.Check(frame.opts, label, function() set(not get()); ProfLevel_Refresh() end)
    c.get = get
    frame.opts.checks[#frame.opts.checks + 1] = c
    return c
  end
  opt(L["打開專業視窗時自動顯示"], function() return db.dock end, function(v) db.dock = v end)
  opt(L["顯示小地圖按鈕"], function() return not db.minimapHide end, function(v) db.minimapHide = not v; if mmBtn then mmBtn:SetShown(v) end end)
  opt(L["分享我的配方給公會"], function() return NS.guildSharing() end, function(v) NS.guildShare(v) end)
  opt(L["採集追蹤提醒"], function() return NS.trackOn() end, function() NS.trackToggle() end)
  opt(L["自動開啟採集追蹤"], function() return NS.trackAutoOn() end, function() NS.trackAutoToggle() end)
  -- 介面語言：載入時決定，選好後要 /reload（插件不能自己重新載入，會被遊戲擋下）
  local o = frame.opts
  o.langRow = CreateFrame("Frame", nil, o); o.langRow:SetHeight(24)
  o.langLabel = o.langRow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  o.langLabel:SetPoint("LEFT", 0, 0); o.langLabel:SetText(L["介面語言"])
  o.langBtn = UI.Button(o.langRow, "", function(self)
    local es = {}
    for _, x in ipairs(langOpts()) do es[#es + 1] = { x.name, function() if not x.on then db.lang = x.code; msg(string.format(L["介面語言：%s（/reload 後生效）"], x.name)); ProfLevel_Refresh() end end, x.on } end
    UI.Menu(self, es)
  end)
  o.langBtn:SetPoint("LEFT", o.langLabel, "RIGHT", 8, 0)
  -- 分頁以外的內容分兩組：main（利潤／佇列／衝級）、gather（採集），切分頁時整組顯示或隱藏
  local main = CreateFrame("Frame", nil, frame); main:SetAllPoints(); frame.main = main
  local gather = CreateFrame("Frame", nil, frame); gather:SetAllPoints(); gather:Hide(); frame.gather = gather
  -- 第一列：底線分頁
  frame.profitBtn = UI.Tab(frame, L["利潤"], function() db.tab = "profit"; offset = 0; ProfLevel_Refresh() end)
  frame.queueBtn = UI.Tab(frame, L["佇列"], function() db.tab = "queue"; offset = 0; ProfLevel_Refresh() end)
  frame.levelBtn = UI.Tab(frame, L["衝級"], function() db.tab = db.lvTab or "steps"; offset = 0; ProfLevel_Refresh() end)
  frame.gatherBtn = UI.Tab(frame, L["採集"], function() db.tab = "gather"; offset = 0; ProfLevel_Refresh() end)
  frame.profitBtn:SetPoint("TOPLEFT", 10, -28)
  frame.queueBtn:SetPoint("LEFT", frame.profitBtn, "RIGHT", 2, 0)
  frame.levelBtn:SetPoint("LEFT", frame.queueBtn, "RIGHT", 2, 0)
  frame.gatherBtn:SetPoint("LEFT", frame.levelBtn, "RIGHT", 2, 0)
  local tabLine = frame:CreateTexture(nil, "ARTWORK")
  tabLine:SetColorTexture(UI.C.EDGE2[1], UI.C.EDGE2[2], UI.C.EDGE2[3], 1); tabLine:SetHeight(1)
  tabLine:SetPoint("TOPLEFT", 12, -54); tabLine:SetPoint("TOPRIGHT", -12, -54)
  frame.sb = UI.Scrollbar(main) -- 表格多的列用滾輪捲動：右緣捲動條
  -- 採集分頁：技能列在 refresh 時建立；下面是追蹤提醒（之後的「採集路線」接在這組下面）
  gather.rows = {}
  gather.empty = gather:CreateFontString(nil, "OVERLAY", "GameFontDisable"); gather.empty:SetText(L["沒有學採集或副專業"])
  gather.sep = gather:CreateTexture(nil, "ARTWORK"); gather.sep:SetColorTexture(1, 1, 1, .12); gather.sep:SetHeight(1)
  gather.trackBtn = UI.Check(gather, L["採集追蹤提醒"], function() NS.trackToggle(); ProfLevel_Refresh() end)
  gather.trackBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(L["採集追蹤提醒"])
    GameTooltip:AddLine(L["學了採礦／草藥學但小地圖沒開尋找礦物／草藥時，畫面上出現提醒按鈕"], 1, 1, 1, true)
    GameTooltip:AddLine(L["/sprof track 看其他設定"], .6, .6, .6); GameTooltip:Show()
  end)
  gather.trackBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第二列：專業切換、起點、目標
  frame.prevBtn = button(main, 8, "<", function() end)
  frame.prevBtn:SetPoint("TOPLEFT", 12, -60)
  frame.profBtn = button(main, 130, "", function() end)
  frame.profBtn:SetPoint("LEFT", frame.prevBtn, "RIGHT", 2, 0)
  frame.nextBtn = button(main, 8, ">", function() end)
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
  local fromLbl = main:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fromLbl:SetText(L["從"]); frame.fromLbl = fromLbl
  fromLbl:SetPoint("LEFT", frame.nextBtn, "RIGHT", 12, 0)
  frame.fromBox = numBox(main, function(v) db.from[db.prof] = v end)
  frame.fromBox:SetPoint("LEFT", fromLbl, "RIGHT", 8, 0)
  local toLbl = main:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); toLbl:SetText(L["到"]); frame.toLbl = toLbl
  toLbl:SetPoint("LEFT", frame.fromBox, "RIGHT", 8, 0)
  frame.toBox = numBox(main, function(v) db.to[db.prof] = v end)
  frame.toBox:SetPoint("LEFT", toLbl, "RIGHT", 8, 0)
  frame.nowBtn = button(main, 52, L["目前"], function() db.from[db.prof] = nil; ProfLevel_Refresh() end)
  frame.nowBtn:SetPoint("LEFT", frame.toBox, "RIGHT", 6, 0)
  frame.nowBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(L["起點改回目前的專業點數"]); GameTooltip:Show()
  end)
  frame.nowBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第三列：衝級的子分頁（步驟／材料）、右邊開關（勾選框）
  frame.stepsBtn = UI.Tab(main, L["步驟"], function() db.tab = "steps"; db.lvTab = "steps"; offset = 0; ProfLevel_Refresh() end, true)
  frame.shopBtn = UI.Tab(main, L["材料"], function() db.tab = "shop"; db.lvTab = "shop"; offset = 0; ProfLevel_Refresh() end, true)
  frame.stepsBtn:SetPoint("TOPLEFT", 8, -88)
  frame.shopBtn:SetPoint("LEFT", frame.stepsBtn, "RIGHT", 2, 0)
  frame.decBtn = UI.Check(main, L["拆中間材料"], function() db.decompose = not db.decompose; ProfLevel_Refresh() end)
  frame.decBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(L["拆中間材料"])
    GameTooltip:AddLine(L["開：每個中間材料都比較「直接買」和「買原料自己做」，便宜的那個才列進清單。只拆你學過、點數也夠的配方（冶煉要有採礦）。"], 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.decBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 佇列：材料要不要扣掉背包、銀行已有的（衝級路線也照這個設定）
  frame.bagBtn = UI.Check(main, L["扣背包"], function() db.useBag = not db.useBag; ProfLevel_Refresh() end)
  frame.bankBtn = UI.Check(main, L["扣銀行"], function() db.useBank = not db.useBank; ProfLevel_Refresh() end)
  -- 材料頁：合併同伺服器、同陣營其他角色要買的（有其他角色的清單才出現）
  frame.allBtn = UI.Check(main, L["全部角色"], function() db.shopAll = not db.shopAll; offset = 0; ProfLevel_Refresh() end)
  frame.allBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(L["全部角色"])
    for _, c in ipairs(frame.others or {}) do
      local pp = PROF_BY_KEY[c.prof]
      GameTooltip:AddDoubleLine(c.name, (pp and pp.name or "") .. " " .. c.S .. "–" .. c.T, 1, 1, 1, .8, .8, .8)
    end
    GameTooltip:Show()
  end)
  frame.allBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 第四列起（位置在重整時依內容往下排）：升階提示／價格警告、總計、表頭、表格
  frame.status = main:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame.status:SetPoint("TOPLEFT", 14, -116); frame.status:SetJustifyH("LEFT"); frame.status:SetWordWrap(false)
  tipArea(frame.status, main)
  -- 升階提示：快到上限時佔掉價格警告那行的開頭，「去」設航點；放不下時縮短，滑鼠移上去看完整文字
  frame.train = main:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.train:SetPoint("TOPLEFT", 14, -116); frame.train:SetJustifyH("LEFT"); frame.train:SetWordWrap(false); frame.train:Hide()
  frame.trainHit = CreateFrame("Frame", nil, main); frame.trainHit:SetAllPoints(frame.train); frame.trainHit:EnableMouse(true); frame.trainHit:Hide()
  frame.trainHit:SetScript("OnEnter", function(self) rankTip(self, self.full, frame.goBtn.R) end)
  frame.trainHit:SetScript("OnLeave", function() GameTooltip:Hide() end)
  frame.goBtn = button(main, 20, L["去"], function(self) goTo(self.R and self.R.at[1]) end)
  frame.goBtn:SetHeight(20); frame.goBtn:SetPoint("LEFT", frame.train, "RIGHT", 6, 0); frame.goBtn:Hide()
  frame.goBtn:SetScript("OnEnter", function(self) rankTip(self, self.full, self.R) end)
  frame.goBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  frame.total = main:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.total:SetPoint("TOPLEFT", 14, -140); frame.total:SetJustifyH("LEFT"); frame.total:SetWordWrap(false)
  tipArea(frame.total, main)
  -- 警告標記：接在總計後面，滑鼠移上去看沒有價格、不知道材料等提醒
  frame.warn = CreateFrame("Frame", nil, main); frame.warn:SetSize(18, 18); frame.warn:EnableMouse(true); frame.warn:Hide()
  frame.warn:SetPoint("LEFT", frame.total, "RIGHT", 6, 0)
  local warnIcon = frame.warn:CreateTexture(nil, "OVERLAY"); warnIcon:SetAllPoints(); warnIcon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
  frame.warn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    for _, w in ipairs(self.lines or {}) do GameTooltip:AddLine(w, 1, .62, .36, true) end
    GameTooltip:Show()
  end)
  frame.warn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 「製作下一個」、購物清單失敗的原因（琥珀色，5 秒後清掉）
  frame.note = UI.text(main, 13, UI.C.AMBER); frame.note:Hide()
  tipArea(frame.note, main)
  -- 表格是空的時候的說明（佔表格第一列的位置，可換行）
  frame.empty = main:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame.empty:SetJustifyH("LEFT"); frame.empty:SetWordWrap(true); frame.empty:Hide()
  -- 底部動作按鈕、購物清單按鈕
  frame.act1 = button(main, 120, "", function(self) if self.fn then safe("動作", self.fn) end; ProfLevel_Refresh() end)
  frame.act2 = button(main, 90, "", function(self) if self.fn then safe("動作", self.fn) end; ProfLevel_Refresh() end)
  frame.act1:Hide(); frame.act2:Hide()
  frame.atrBtn = button(main, 160, L["建立 Auctionator 購物清單"], function() safe("建立購物清單", createShoppingList); ProfLevel_Refresh() end)
  frame.atrBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(L["建立 Auctionator 購物清單"])
    GameTooltip:AddLine(string.format(L["數量%s；商人販售的物品不列入。在拍賣行打開 Auctionator 的購物分頁就能用。"], haveText()), 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.atrBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 表頭與內容
  local head = CreateFrame("Frame", nil, main); head:SetSize(W, 22); head:SetPoint("TOPLEFT", 14, -144) -- 位置在重整時依上面幾列決定
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
  frame.lines = {}
  for i = 1, MAXLINES do
    local l = CreateFrame("Frame", nil, main)
    l:SetSize(W, ROW_H) -- 位置在重整時依表頭決定
    if i % 2 == 0 then local bg = l:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(1, 1, 1, .035) end
    l.hov = UI.hover(l) -- 滑過高亮：看得出列可以點
    -- 佇列頁：每列右端「×」整項移除
    l.del = CreateFrame("Button", nil, l); l.del:SetSize(18, 18); l.del:SetPoint("RIGHT", -2, 0); l.del:Hide()
    l.del.label = UI.text(l.del, 15, UI.C.DIM, "CENTER"); l.del.label:SetPoint("CENTER", 0, 1); l.del.label:SetText("×")
    l.del:SetScript("OnEnter", function(self) UI.paint(self.label, UI.C.RED); l.hov:Show() end)
    l.del:SetScript("OnLeave", function(self) UI.paint(self.label, UI.C.DIM); l.hov:Hide() end)
    l.del:SetScript("OnClick", function()
      local q = l.e and l.e.queue
      for k, x in ipairs(db.queue) do if x == q then table.remove(db.queue, k); break end end
      ProfLevel_Refresh()
    end)
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
      self.hov:Show()
      if e.recipe and e.queued == 0 then self.c[8]:SetText("|cff8c8c8c+|r") end -- 佇列欄是 0：滑過出現淡色「+」（點一下加入）
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
            GameTooltip:AddDoubleLine(string.format("%s ×%d", nm, need), (pr and (money(pr * m[2]) .. L["　"]) or "") .. string.format(L["背包 %d"], got),
              1, 1, 1, got >= need and .6 or 1, got >= need and 1 or .6, .6)
          end
        end
        local gl = NS.guildLine(e.recipe and e.id or e.queue.id, out)
        if gl then GameTooltip:AddLine(gl, .55, .75, 1, true) end
        if e.recipe then
          if e.sell then GameTooltip:AddLine(string.format(L["售價 %s（已扣拍賣行 5%% 手續費）"], money(e.sell)), .8, .8, .8) end
          local st = e.stats
          if st then
            GameTooltip:AddLine(string.format(L["拍賣場：最近一次在架 %d 個；最近 14 天有 %d 天看到，平均在架 %d 個"], st.last, st.days, math.floor(st.avg + 0.5)), .55, .75, 1, true)
            GameTooltip:AddLine(L["（只代表有多少人在賣，不代表賣得掉：賣不掉的也會一直重新上架。遊戲沒有成交量資料）"], .6, .6, .6, true)
          else
            GameTooltip:AddLine(L["拍賣場：Auctionator 沒有這個成品的掃描紀錄"], .6, .6, .6, true)
          end
          GameTooltip:AddLine(L["左鍵加入佇列、Shift+左鍵加 5、右鍵減 1"], .6, .6, .6)
        else
          GameTooltip:AddLine(L["左鍵 +1、右鍵 −1（Shift 一次 5）"], .6, .6, .6)
        end
      elseif e.prep then
        local c = e.prep
        pcall(GameTooltip.SetItemByID, GameTooltip, c.id)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format(L["自己做 %d 次（共 %d 個，已有 %d）"], c.n, c.qty, c.have), 1, .82, 0, true)
        local mats = {}
        for _, m in ipairs(c.rec.mats) do table.insert(mats, string.format("%s ×%d", (info("i", m[1])), math.ceil(c.n * m[2] - 1e-9))) end
        GameTooltip:AddLine(L["材料："] .. table.concat(mats, L["、"]), 1, 1, 1, true)
        if c.buyUnit and c.unit then GameTooltip:AddLine(string.format(L["直接買每個 %s，自己做每個 %s"], money(c.buyUnit), money(c.unit)), .8, .8, .8, true) end
      elseif e.step then
        local s = e.step
        if s.k == "s" then pcall(GameTooltip.SetSpellByID, GameTooltip, s.id) else pcall(GameTooltip.SetItemByID, GameTooltip, s.id) end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format(L["做 %d 次"], e.n) .. (e.extra > 0 and string.format(L["（其中 %d 次是多做的，留給後面步驟當材料）"], e.extra) or ""), 1, .82, 0, true)
        local mats = {}
        for _, m in ipairs(s.m) do
          local nm = info("i", m[1])
          table.insert(mats, string.format("%s ×%d", nm, math.ceil(e.n * m[2] / s.c)))
        end
        if #mats > 0 then GameTooltip:AddLine(L["材料："] .. table.concat(mats, L["、"]), 1, 1, 1, true) end
        if e.val then GameTooltip:AddLine(string.format(L["做出來的成品賣掉約可回本 %s（已扣 5%% 手續費、扣掉後面步驟會用掉的）"], money(e.val)), .6, 1, .6, true) end
        local st = s.k == "i" and ahStats(s.id)
        if st then GameTooltip:AddLine(string.format(L["拍賣場：最近一次在架 %d 個；最近 14 天有 %d 天看到"], st.last, st.days), .55, .75, 1, true) end
        if s.d and #s.d == 4 then
          local function dv(x) return (x == nil or x == "" or x == "–") and "—" or x end
          GameTooltip:AddLine(string.format(L["難度："] .. "|cffff8040%s|r |cffffff00%s|r |cff40bf40%s|r |cff808080%s|r", dv(s.d[1]), dv(s.d[2]), dv(s.d[3]), dv(s.d[4])), .8, .8, .8)
        end
      else
        pcall(GameTooltip.SetItemByID, GameTooltip, e.item.id)
        local c = e.item
        if c.who and #c.who > 0 then
          GameTooltip:AddLine(" ")
          for _, w in ipairs(c.who) do GameTooltip:AddDoubleLine(w[1], "×" .. w[2], 1, 1, 1, 1, 1, 1) end
        end
        if c.kind == "craft" then
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine(string.format(L["比價：直接買每個 %s，自己做每個 %s → 自己做"], c.buyUnit and money(c.buyUnit) or L["沒價格"], money(c.unit or 0)), .55, .75, 1, true)
        end
      end
      GameTooltip:Show()
    end)
    l:SetScript("OnLeave", function(self)
      self.hov:Hide(); GameTooltip:Hide()
      if self.e and self.e.recipe and self.e.queued == 0 then self.c[8]:SetText("") end
    end)
    frame.lines[i] = l
  end
  frame:EnableMouseWheel(true)
  frame:SetScript("OnMouseWheel", function(_, delta) offset = math.max(0, offset - delta * 3); ProfLevel_Refresh() end)
  frame:SetScript("OnShow", function()
    -- 舊版存的是置中或其他錨點：第一次打開時照目前看到的位置換成左上角（貼在專業視窗旁邊時本來就是左上角，不動）
    if frame:GetPoint() ~= "TOPLEFT" then saveTopLeft() end
    safe("比較表", refreshImpl)
  end)
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
  profUI.text:SetShown(open); profUI.addBtn:SetShown(open); profUI.text.tip:Hide()
  setLabel(profUI.openBtn, open and L["關閉幫手"] or L["專業幫手"], 110)
  if not open then return end
  local p, id = openProf(), selectedRecipe()
  profUI.id, profUI.prof, profUI.rec = id, p and p.key, nil
  if not p or not id then profUI.text:SetText(""); profUI.text.tip:Hide(); return end
  priceCache = {}
  local rec = db.recipes[p.key] and db.recipes[p.key][id]
  profUI.rec = rec
  local qn = 0
  for _, q in ipairs(db.queue) do if q.id == id then qn = qn + q.count end end
  local txt = ""
  if rec then
    local cost, sell, profit = profitOf(rec, learnedProfs())
    if profit then
      txt = string.format(L["利潤 %s%s|r（%d%%）"], profit >= 0 and "|cff9fd18b" or "|cffff7b7b", (profit < 0 and "-" or "") .. money(math.abs(profit)),
        cost > 0 and math.floor(profit / cost * 100 + 0.5) or 0)
    elseif cost then txt = string.format(L["成本 %s（沒有售價）"], money(cost)) end
  end
  -- 面板 360 寬：放不下就截斷，滑鼠移上去看全文
  fitTextTip(profUI.text, 356, txt .. (qn > 0 and (L["　"] .. "|cffffd100" .. string.format(L["佇列 ×%d"], qn) .. "|r") or ""))
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
  profUI.text:SetPoint("TOPLEFT", 2, 0); profUI.text:SetJustifyH("LEFT"); profUI.text:SetWordWrap(false)
  tipArea(profUI.text, profUI)
  local b = CreateFrame("Button", nil, profUI, "UIPanelButtonTemplate")
  b:SetSize(110, 24); profUI.addBtn = b
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
    GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(L["加入製作佇列"])
    GameTooltip:AddLine(L["左鍵 +1、Shift+左鍵 +5、右鍵 −1"], 1, 1, 1); GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  setLabel(b, L["加入佇列"], 110)
  local o = CreateFrame("Button", nil, profUI, "UIPanelButtonTemplate")
  o:SetSize(110, 24); o:SetPoint("TOPLEFT", 0, -22); profUI.openBtn = o
  b:SetPoint("LEFT", o, "RIGHT", 6, 0)
  -- 點了才打開（不會改「自動開啟」的設定）
  o:SetScript("OnClick", function() if frame and frame:IsShown() then frame:Hide(); docked = false else dockOpen(true) end end)
  setLabel(o, L["專業幫手"], 110)
  if sf.Init then hooksecurefunc(sf, "Init", function() C_Timer.After(0, function() safe("專業視窗", updateProfUI) end) end) end
  profUI:SetScript("OnShow", function() safe("專業視窗", updateProfUI) end)
  ProfessionsFrame:HookScript("OnShow", function() safe("專業視窗", dockOpen) end)
  ProfessionsFrame:HookScript("OnHide", dockClose)
end

-- ── 小地圖按鈕 ─────────────────────────────────────────────────────────────
local function placeMinimap()
  local a = math.rad(db.minimapAngle or 225)
  local r = (Minimap:GetWidth() / 2) + 5
  mmBtn:ClearAllPoints()
  mmBtn:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
end
local function buildMinimapButton()
  if mmBtn or not Minimap then return end
  local b = CreateFrame("Button", "ProfLevelMinimapButton", Minimap)
  mmBtn = b
  b:SetSize(31, 31); b:SetFrameStrata("MEDIUM"); b:SetFrameLevel(8)
  b:RegisterForClicks("LeftButtonUp", "RightButtonUp"); b:RegisterForDrag("LeftButton")
  b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local bg = b:CreateTexture(nil, "BACKGROUND"); bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  bg:SetSize(20, 20); bg:SetPoint("TOPLEFT", 7, -5)
  local icon = b:CreateTexture(nil, "ARTWORK"); icon:SetTexture(ICON); icon:SetTexCoord(0.1, 0.9, 0.1, 0.9); icon:SetSize(20, 20); icon:SetPoint("TOPLEFT", 6, -5)
  b.icon, b.Icon = icon, icon -- 小地圖按鈕收納插件會找這個欄位當圖示
  local border = b:CreateTexture(nil, "OVERLAY"); border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(53, 53); border:SetPoint("TOPLEFT")
  b:SetScript("OnClick", function(_, btn)
    if btn == "RightButton" then -- 右鍵：設定
      if not frame then buildFrame() end
      frame:Show(); frame.opts:Show(); ProfLevel_Refresh()
    else toggleWindow() end
  end)
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
    GameTooltip:AddLine(L["阿聖專業幫手"])
    GameTooltip:AddLine(L["左鍵：開啟／關閉"], 1, 1, 1)
    GameTooltip:AddLine(L["右鍵：設定"], 1, 1, 1)
    GameTooltip:AddLine(L["拖曳：沿著小地圖移動"], .6, .6, .6)
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
    msg(L["小地圖按鈕："] .. (db.minimapHide and L["隱藏（再輸入 /sprof minimap 顯示）"] or L["顯示"]))
  elseif cmd == "dock" then
    db.dock = not db.dock
    msg(L["打開專業視窗時自動顯示專業助手："] .. (db.dock and L["開"] or L["關"]))
  elseif cmd == "scale" then
    local v = tonumber((input or ""):match("scale%s+([%d%.]+)"))
    if v and v >= 0.5 and v <= 2 then db.scale = v; if frame then frame:SetScale(v); if not docked then placeTopLeft() end; frame.stableW = nil end; msg(L["視窗縮放："] .. v)
    else msg(string.format(L["用法：/sprof scale 1.2（0.5～2，目前 %s）"], tostring(db.scale or 1))) end
  elseif cmd == "guild" then
    NS.guildSlash((input or ""):match("^%s*%S+%s+(.-)%s*$"))
  elseif cmd == "train" then
    local learned = learnedProfs(true)
    local n = 0
    for _, list in ipairs({ PROFS, { MINING }, EXTRA }) do
      for _, p in ipairs(list) do
        local sk = learned[p.key]
        if sk then
          n = n + 1
          local tr, low, R = rankText(p.key, sk)
          local a = R and R.at[1]
          local where = (a and a.map) and string.format(L["　"] .. "|cffffff00|Hworldmap:%d:%d:%d|h[%s %.1f, %.1f]|h|r", a.map, math.floor(a.x * 100 + 0.5), math.floor(a.y * 100 + 0.5), loc(a, "place"), a.x, a.y) or ""
          local line = tr and ((low and "|cff808080" or "") .. tr .. (low and "|r" or "") .. where)
            or (sk.max >= 300 and L["已是大師"]) or (sk.max <= 75 and L["下一階：任一訓練師（10 級、技能 50）"]) or L["沒有資料"]
          msg(string.format("%s %d/%d", p.name, sk.cur, sk.max) .. L["　"] .. line)
        end
      end
    end
    if n == 0 then msg(L["沒偵測到專業"]) end
  elseif cmd == "track" then
    if ProfLevel_Track then ProfLevel_Track((input or ""):match("track%s+(%S+)")) end
  elseif cmd == "lang" then -- 測試用：中文客戶端也能預覽其他語言的介面（偵測專業、讀遊戲文字仍照客戶端語言）
    local v = (input or ""):lower():match("lang%s+(%a+)")
    -- stress：英文字串加長約 35%，加新語言前先用它檢查每個分頁的版面；也可以指定有語言檔的代碼（例如 /sprof lang dede）
    local code
    for c in pairs(NS.locales) do if c:lower() == v and NS.canShow(c) then code = c end end -- 字型沒有該語言的文字就不給切
    if v == "en" or v == "stress" or (v == "zh" and NS.clientZh) or v == "auto" or code then -- 非中文客戶端的字型沒有中文字，不給切中文
      db.lang = code or (v ~= "auto" and v or nil)
      msg(string.format(L["介面語言：%s（/reload 後生效）"], code or v))
    else msg(string.format(L["用法：/sprof lang en/zh/stress/auto（目前 %s）"], db.lang or "auto")) end
  elseif cmd == "debug" then
    local learned = learnedProfs()
    local t = {}
    for _, p in ipairs(PROFS) do if learned[p.key] then table.insert(t, p.name .. " " .. learned[p.key].cur .. "/" .. learned[p.key].max) end end
    msg(L["版本 0.7.1　已學專業："] .. (#t > 0 and table.concat(t, L["、"]) or L["沒偵測到"]))
    msg(L["Auctionator："] .. (auctionator() and L["有"] or L["沒有"]))
    -- 專業視窗 API（下一版做製作佇列、利潤表會用到）：打開專業視窗再執行
    local T = C_TradeSkillUI
    if T and T.GetAllRecipeIDs then
      local ok, ids = pcall(T.GetAllRecipeIDs)
      local n = ok and type(ids) == "table" and #ids or 0
      local base = T.GetBaseProfessionInfo and select(2, pcall(T.GetBaseProfessionInfo))
      msg(string.format(L["專業視窗 API：新版　配方 %d 個　目前專業：%s　CraftRecipe：%s"], n,
        type(base) == "table" and tostring(base.professionName or base.professionID) or L["未開啟"],
        T.CraftRecipe and L["有"] or L["沒有"]))
      if n > 0 then
        local id = ids[1]
        local okI, ri = pcall(T.GetRecipeInfo, id)
        local okS, sc = pcall(T.GetRecipeSchematic, id, false)
        local reag = 0
        if okS and type(sc) == "table" and type(sc.reagentSlotSchematics) == "table" then reag = #sc.reagentSlotSchematics end
        msg(string.format(L["第一個配方 %d：%s　產物 %s　材料欄 %d　可做 %s"], id,
          okI and type(ri) == "table" and tostring(ri.name) or "?", okS and type(sc) == "table" and tostring(sc.outputItemID) or "?",
          reag, okI and type(ri) == "table" and tostring(ri.numAvailable) or "?"))
      end
    elseif GetNumTradeSkills then
      msg(string.format(L["專業視窗 API：舊版　配方列 %s 列"], tostring(GetNumTradeSkills())))
    else
      msg(L["專業視窗 API：沒有"])
    end
  else
    msg(L["/sprof 開關視窗　/sprof scale 1.2 調整視窗大小　/sprof dock 開關「跟專業視窗一起開」　/sprof minimap 隱藏小地圖按鈕　/sprof track 採集追蹤提醒　/sprof train 下一階去哪學　/sprof guild 公會誰會做（on/off 分享）　/sprof debug 列出偵測結果　/sprof lang en/zh/auto 介面語言（stress＝版面壓力測試，英文加長 35%）"])
  end
end

NS.ensureDB, NS.msg, NS.learnedProfs, NS.recipes = ensureDB, msg, learnedProfs, recipes
NS.goTo, NS.button, NS.fitButton, NS.setLabel, NS.fitText, NS.measure, NS.rowEnd = goTo, button, fitButton, setLabel, fitText, measure, rowEnd -- 採集路線、追蹤提醒共用
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
    -- 語音提示已移除：把它改過的互動鍵設定還原（玩家或別的插件改過的不動），只做一次
    if type(db.voice) == "table" then
      for cvar, old in pairs(db.voice.saved or {}) do
        if tonumber(C_CVar.GetCVar(cvar)) == tonumber((db.voice.applied or {})[cvar]) then C_CVar.SetCVar(cvar, old) end
      end
      db.voice = nil
    end
    if not db.scaleV then if db.scale == 1 then db.scale = 1.25 end; db.scaleV = 1 end -- 舊預設值改成新的預設大小（只遷移一次，之後尊重玩家設定）
    -- 小地圖按鈕舊預設 200° 和練等幫手疊在一起：沒拖過（剛好 200）的改成新預設 225°（只遷移一次）
    if not db.mmV then if db.minimapAngle == 200 then db.minimapAngle = 225 end; db.mmV = 1 end
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
