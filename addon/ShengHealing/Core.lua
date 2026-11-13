-- 阿聖治療幫手 ShengHealing（魔獸世界：永恆）
-- 盡量從遊戲讀取：技能與階級（法術書）、法力、施法時間、冷卻、學習等級、基礎治療量（技能說明）、治療效果、天賦。
-- 遊戲讀不到的欄位才用 Data.lua（由網頁資料產生）。治療係數遊戲不會顯示，一律用資料表。

local ADDON = ...
local D = HealHPS_Data
local DEFAULTS = { mode = "single", tipLevel = 3, fight = 180, anaHp = 3000, anaHit = 300, anaGap = 2, rate = "cast", sort = "hps", targets = 5, downrank = true, tip = true,
  includeCd = false, pct = nil, absorb = nil, minimapAngle = 225, minimapHide = false, oath = false, scale = 1.25, anaDetail = false }
local LOGO = "Interface\\AddOns\\ShengHealing\\Media\\Logo"
local db
-- 設定：每個角色一份。任何地方用到前都先確保已經建立（不依賴事件順序）
-- 技能說明的數字是否已經含治療效果：永恆（新版引擎）實測會含；經典版不含。/shps desc 可手動指定
local function descIncludesBonus()
  local m = HealHPSCharDB and HealHPSCharDB.desc or "auto"
  if m == "incl" then return true elseif m == "base" then return false end
  return (C_Spell and C_Spell.GetSpellDescription) and true or false
end

-- 有治療技能的職業；其他職業不掛滑鼠提示、不建小地圖按鈕
local HEALER_CLASSES = { PALADIN = true, PRIEST = true, DRUID = true, SHAMAN = true }
local function isHealerClass() return HEALER_CLASSES[select(2, UnitClass("player"))] == true end

local function ensureDB()
  if db then return db end
  HealHPSCharDB = HealHPSCharDB or {}
  for k, v in pairs(DEFAULTS) do if HealHPSCharDB[k] == nil then HealHPSCharDB[k] = v end end
  db = HealHPSCharDB
  if type(db.targets) ~= "number" or db.targets < 2 then db.targets = 2 elseif db.targets > 10 then db.targets = 10 end -- 群補至少 2 人
  if type(db.expanded) ~= "table" then db.expanded = {} end -- 展開了哪些技能
  return db
end

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage("|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r " .. s) end

-- ── 遊戲 API 相容層：永恆用新版引擎（C_Spell／C_SpellBook），經典版用舊的全域函式 ─────
local API = {}
function API.SpellInfo(x) -- 回傳 名稱, 施法毫秒, 法術ID
  if x == nil then return nil end
  if C_Spell and C_Spell.GetSpellInfo then
    local i = C_Spell.GetSpellInfo(x)
    if i then return i.name, i.castTime, i.spellID end
    return nil
  end
  if GetSpellInfo then local n, _, _, ct, _, _, id = GetSpellInfo(x); return n, ct, id end
end
function API.Desc(id)
  local f = (C_Spell and C_Spell.GetSpellDescription) or GetSpellDescription
  return f and id and f(id)
end
function API.PowerCost(id)
  local f = (C_Spell and C_Spell.GetSpellPowerCost) or GetSpellPowerCost
  return f and id and f(id)
end
function API.Subtext(id)
  local f = (C_Spell and C_Spell.GetSpellSubtext) or GetSpellSubtext
  return f and id and f(id)
end
function API.LevelLearned(id)
  local f = (C_Spell and C_Spell.GetSpellLevelLearned) or GetSpellLevelLearned
  if not f or not id then return nil end
  local ok, v = pcall(f, id)
  return ok and v or nil
end
function API.BaseCooldown(id)
  local f = GetSpellBaseCooldown or (C_Spell and C_Spell.GetSpellBaseCooldown)
  if not f or not id then return nil end
  local ok, v = pcall(f, id)
  return ok and v or nil
end
function API.Spellbook() -- 回傳 { {name, sub, id}, ... }，永恆的法術書會列出所有階級
  local out = {}
  if C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines then
    local bank = Enum.SpellBookSpellBank.Player
    local spellType = Enum.SpellBookItemType and Enum.SpellBookItemType.Spell
    for line = 1, (C_SpellBook.GetNumSpellBookSkillLines() or 0) do
      local li = C_SpellBook.GetSpellBookSkillLineInfo(line)
      if li then
        local off = li.itemIndexOffset or 0
        for slot = off + 1, off + (li.numSpellBookItems or 0) do
          local info = C_SpellBook.GetSpellBookItemInfo(slot, bank)
          if info and info.spellID and info.name and (not spellType or info.itemType == spellType) and not info.isPassive then
            table.insert(out, { name = info.name, sub = info.subName, id = info.spellID })
          end
        end
      end
    end
    return out
  end
  local BOOK = BOOKTYPE_SPELL or "spell"
  for tab = 1, GetNumSpellTabs() do
    local _, _, offset, num = GetSpellTabInfo(tab)
    for slot = offset + 1, offset + num do
      local name, sub = GetSpellBookItemName(slot, BOOK)
      local typ, id = GetSpellBookItemInfo(slot, BOOK)
      if name and typ == "SPELL" and id then table.insert(out, { name = name, sub = sub, id = id }) end
    end
  end
  return out
end

-- 出錯時印在聊天視窗（同一個錯誤只印一次），不要默默失敗
local reported = {}
local function safe(where, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then
    err = tostring(err)
  -- 錯誤存進存檔（登出後開發者讀得到），同一種錯誤只記一筆、算次數，最多 50 種
  if type(HealHPSCharDB) == "table" then
    local log = HealHPSCharDB.errors or {}
    HealHPSCharDB.errors = log
    local key = where .. "：" .. err
    if log[key] then log[key].n = log[key].n + 1; log[key].t = date("%m/%d %H:%M")
    elseif #(log.keys or {}) < 50 then
      log.keys = log.keys or {}
      log.keys[#log.keys + 1] = key
      log[key] = { n = 1, t = date("%m/%d %H:%M") }
    end
  end
    if not reported[err] then reported[err] = true; msg("|cffff7b7b" .. where .. "出錯：|r" .. err .. "　請把這行回報給開發者") end
  end
  return ok
end
local function fmt1(n) return n and string.format("%.1f", n) or "—" end
local function fmt2(n) return n and string.format("%.2f", n) or "—" end
local function fint(n) n = math.floor((n or 0) + 0.5); return BreakUpLargeNumbers and BreakUpLargeNumbers(n) or tostring(n) end

-- ── 天賦：名稱用法術 ID 向遊戲查（不受語言影響），查不到用繁中名稱 ─────────────
local TALENTS = {
  PALADIN = { { ids = { 20237 }, names = { "治療之光" }, per = 4, what = "heal" } },
  PRIEST  = { { ids = { 14898 }, names = { "精神治療" }, per = 2, what = "heal" },
              { ids = { 14748 }, names = { "強化真言術：盾" }, per = 5, what = "absorb" } },
  DRUID   = { { ids = { 17104 }, names = { "自然賜福" }, per = 2, what = "heal" } },
  SHAMAN  = { { ids = { 16178 }, names = { "淨化" }, per = 2, what = "heal" } },
}

local function nameSet(ids, names)
  local set = {}
  for _, id in ipairs(ids) do local n = API.SpellInfo(id); if n then set[n] = true end end
  for _, n in ipairs(names) do set[n] = true end
  return set
end

-- 永恆（新版引擎）沒有 GetTalentInfo，天賦改用 C_ClassTalents／C_Traits 讀；回傳 { [名稱] = {rank, max} } 或 nil
local function traitRanks()
  if not (C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_Traits and C_Traits.GetConfigInfo
    and C_Traits.GetTreeNodes and C_Traits.GetNodeInfo) then return nil end
  local ok, cfg = pcall(C_ClassTalents.GetActiveConfigID)
  if not ok or not cfg then return nil end
  local ok1, info = pcall(C_Traits.GetConfigInfo, cfg)
  if not ok1 or type(info) ~= "table" or type(info.treeIDs) ~= "table" then return nil end
  local out, seen = {}, 0
  for _, tree in ipairs(info.treeIDs) do
    local okN, nodes = pcall(C_Traits.GetTreeNodes, tree)
    for _, nid in ipairs((okN and type(nodes) == "table") and nodes or {}) do
      local ok2, ni = pcall(C_Traits.GetNodeInfo, cfg, nid)
      local maxR = ok2 and type(ni) == "table" and tonumber(ni.maxRanks) or 0
      if maxR > 0 then
        seen = seen + 1
        local rank = tonumber(ni.activeRank) or 0
        if rank == 0 then rank = tonumber(ni.ranksPurchased) or 0 end
        local eid = (type(ni.activeEntry) == "table" and ni.activeEntry.entryID) or (type(ni.entryIDs) == "table" and ni.entryIDs[1]) or nil
        local sid
        if eid and C_Traits.GetEntryInfo and C_Traits.GetDefinitionInfo then
          local ok3, ei = pcall(C_Traits.GetEntryInfo, cfg, eid)
          if ok3 and type(ei) == "table" and ei.definitionID then
            local ok4, di = pcall(C_Traits.GetDefinitionInfo, ei.definitionID)
            sid = ok4 and type(di) == "table" and tonumber(di.spellID) or nil
          end
        end
        local name = sid and API.SpellInfo(sid)
        -- 客戶端有重複的孤兒節點：同名取點數多的
        if name and (not out[name] or rank > out[name].rank) then out[name] = { rank = rank, max = maxR, sid = sid } end
      end
    end
  end
  if seen == 0 then return nil end
  return out
end

-- 聖光誓約：對誓約目標的聖光術／聖光閃現／神聖震擊固定加量，隨等級成長；從天賦說明讀目前的數值
-- 情境加成：技能說明不會顯示、只在特定情況才生效的加成（設定裡的開關控制比較表是否計入）
local SIT = {
  PALADIN = { label = "聖光誓約", tip = "誓約目標",
    help = "對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。" },
  PRIEST = { label = "聖光束縛", tip = "對他人施放（含自療）", names = { "聖光束縛", "神聖束縛" },
    help = "快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。" },
  SHAMAN = { label = "激流加成", tip = "目標有激流",
    help = "目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。" },
  DRUID = { label = "綻放", tip = "含綻放", names = { "綻放", "盛放", "花開" },
    help = "回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。" },
}
local OATH = { ids = { 1328548 }, names = { "聖光誓約", "聖光誓言" } }
local OATH_SPELLS = { { "hl", 635, "聖光術" }, { "fol", 19750, "聖光閃現" }, { "hs", 20473, "神聖震擊" } }
local function parseOath(desc)
  if not desc or desc == "" then return nil end
  desc = desc:gsub("(%d),(%d)", "%1%2")
  local out, found = {}, 0
  for _, v in ipairs(OATH_SPELLS) do
    local name = API.SpellInfo(v[2]) or v[3]
    local p = desc:find(name, 1, true)
    local n = p and tonumber(desc:match("(%d+)", p + #name))
    out[v[1]] = n or 0
    if n then found = found + 1 end
  end
  -- 三個名稱都在數字前面（例如「聖光術、聖光閃現和神聖震擊分別提高 400、115、230」）會讀成同一個數字，
  -- 這時改取說明裡最後三個數字（照聖光術、聖光閃現、神聖震擊的順序）
  if found < 3 or (out.hl == out.fol and out.fol == out.hs) then
    local nums = {}
    for d in desc:gmatch("%d+") do nums[#nums + 1] = tonumber(d) end
    if #nums >= 3 then out.hl, out.fol, out.hs = nums[#nums - 2], nums[#nums - 1], nums[#nums]; found = 3 end
  end
  return found > 0 and out or nil
end

local function scanTalents(class)
  local res = { heal = 0, absorb = 0, found = {}, source = "讀不到" }
  local defs = TALENTS[class] or {}
  for _, def in ipairs(defs) do def.set = def.set or nameSet(def.ids, def.names) end
  OATH.set = OATH.set or nameSet(OATH.ids, OATH.names)
  local oathRank, oathSid = 0, nil
  local sit = SIT[class]
  if sit and sit.names and not sit.set then sit.set = {}; for _, n in ipairs(sit.names) do sit.set[n] = true end end
  res.learned = {}
  local function seen(name, rank)
    if name and (rank or 0) > 0 then
      table.insert(res.learned, name .. " " .. rank)
      if sit and sit.set and sit.set[name] then res.sitLearned = true end
    end
  end
  local function add(def, name, rank, maxRank)
    if rank and rank > 0 then
      res[def.what] = res[def.what] + rank * def.per
      table.insert(res.found, string.format("%s %d/%d（+%d%%）", name, rank, maxRank or 0, rank * def.per))
    end
  end
  local tr = traitRanks()
  if tr then
    res.source = "C_Traits"
    for name, v in pairs(tr) do
      for _, def in ipairs(defs) do if def.set[name] then add(def, name, v.rank, v.max) end end
      if OATH.set[name] and v.rank > oathRank then oathRank, oathSid = v.rank, v.sid end
      seen(name, v.rank)
    end
  elseif GetTalentInfo and GetNumTalents then
    res.source = "經典"
    local tabs = GetNumTalentTabs and GetNumTalentTabs() or 3
    for t = 1, tabs do
      local okN, nTal = pcall(GetNumTalents, t)
      for i = 1, (okN and nTal or 0) do
        local name, _, _, _, rank, maxRank = GetTalentInfo(t, i)
        for _, def in ipairs(defs) do
          if name and def.set[name] then add(def, name, rank, maxRank) end
        end
        if name and OATH.set[name] and (rank or 0) > oathRank then oathRank = rank end
        seen(name, rank)
      end
    end
  end
  if class == "PALADIN" and oathRank > 0 then
    local desc = API.Desc(oathSid) or API.Desc(OATH.ids[1])
    res.oathDesc = desc
    res.oath = parseOath(desc) or { unknown = true }
  end
  return res
end

-- ── 讀技能說明 ───────────────────────────────────────────────────────────────
local function getDesc(id)
  if not id then return nil end
  local d = API.Desc(id)
  if not d or d == "" then return nil end
  return (d:gsub("(%d),(%d)", "%1%2"))
end

local RANGE_SEPS = { "至", "到", "to" }
local function parseRange(d)
  local best
  for _, sep in ipairs(RANGE_SEPS) do
    for pos, a, b in d:gmatch("()(%d+)%s*" .. sep .. "%s*(%d+)") do
      local pre = d:sub(math.max(1, pos - 18), pos - 1)
      -- 「造成 A 至 B 點傷害」是傷害，不是治療（神聖新星、神聖震擊）
      if not pre:find("造成", 1, true) and (not best or pos < best[1]) then best = { pos, tonumber(a), tonumber(b) } end
    end
  end
  if best then return best[2], best[3] end
end

-- 回傳 min, max, hotTotal（有讀到才回傳）
local function parseDesc(mode, d)
  if not d or not mode then return nil end
  if mode == "range" then return parseRange(d)
  elseif mode == "hot" then local n = tonumber(d:match("總計%s*(%d+)")); return n, n
  elseif mode == "absorb" then local n = tonumber(d:match("吸收%s*(%d+)")); return n, n
  elseif mode == "single" then local n = tonumber(d:match("治療%s*(%d+)%s*點")); return n, n
  elseif mode == "tick" then
    local iv, amt = d:match("每%s*(%d+)%s*秒恢復%s*(%d+)")
    local dur = d:match("持續%s*(%d+)%s*秒")
    if iv and amt and dur then local n = tonumber(amt) * tonumber(dur) / tonumber(iv); return n, n end
  elseif mode == "regrowth" then
    local a, b = parseRange(d)
    local hot = tonumber(d:match("額外的?%s*(%d+)%s*點"))
    return a, b, hot
  end
end

-- ── 掃描法術書 ───────────────────────────────────────────────────────────────
local scan = { dirty = true, rows = {}, byId = {}, families = {}, unmatchedRetry = 0 }

local function rankOf(sub, id)
  local r = tonumber((sub or ""):match("(%d+)"))
  if not r and id then r = tonumber((API.Subtext(id) or ""):match("(%d+)")) end
  return r or 1
end

local function rescan()
  local _, class = UnitClass("player")
  local fams = {}
  local byName = {}
  for _, f in ipairs(D.families) do
    if f.class == class then
      local st = { f = f, known = {}, maxRank = 0, gameName = nil }
      fams[f.key] = st
      for n in pairs(nameSet(f.ids, f.names)) do byName[n] = byName[n] or {}; table.insert(byName[n], st) end
    end
  end
  -- 1) 法術書裡看得到的
  local subTemplate
  for _, e in ipairs(API.Spellbook()) do
    local list = byName[e.name]
    if list then
      local r = rankOf(e.sub, e.id)
      if e.sub and e.sub:find("%d") then subTemplate = subTemplate or e.sub end
      for _, st in ipairs(list) do
        st.known[r] = e.id; st.gameName = e.name
        if r > st.maxRank then st.maxRank = r end
      end
    end
  end
  -- 2) 法術書只顯示最高階時，用「名稱(等級 N)」向遊戲查低階的法術 ID
  if subTemplate then
    for _, st in pairs(fams) do
      if st.gameName then
        for r = 1, st.maxRank - 1 do
          if not st.known[r] then
            local query = st.gameName .. "(" .. subTemplate:gsub("%d+", tostring(r)) .. ")"
            local id = select(3, API.SpellInfo(query))
            if id then st.known[r] = id end
          end
        end
      end
    end
  end
  -- 3) 比最高階低的階級一定學過（階級依序學）；查不到 ID 的用資料表
  for _, st in pairs(fams) do
    for r = 1, st.maxRank do if st.known[r] == nil then st.known[r] = false end end
  end
  scan.families = fams
  scan.dirty = false
  scan.missingDesc = false
end

-- ── 組出每一列（遊戲值優先） ───────────────────────────────────────────────
local function foreverDownrank(level, learn)
  local after = level - learn
  if after <= 17 then return 1 end
  return math.max(0, 1 - 0.05 * (after - 17))
end
local function chainFactor(t) local s, f = 0, 1; for _ = 1, t do s = s + f; f = f * 0.5 end; return s end

local function readRank(st, r, id, ctx)
  local f = st.f
  local d = f.ranks[r] or (f.fallback and scan.families[f.fallback] and scan.families[f.fallback].f.ranks[r])
  local src = { }
  local row = { key = f.key, label = f.label, rank = r, id = id or nil, f = f, src = src }
  -- 學習等級
  local learn = API.LevelLearned(id)
  if learn and learn > 0 then row.learn = learn; src.learn = "遊戲" elseif d then row.learn = d.learn; src.learn = "資料" else return nil end
  -- 法力
  local mana
  if id then
    local costs = API.PowerCost(id)
    if costs then for _, c in ipairs(costs) do if c.cost and c.cost > 0 then mana = c.cost; break end end end
  end
  if mana then row.mana = mana; src.mana = "遊戲" elseif d then row.mana = d.mana; src.mana = "資料" else return nil end
  -- 施法時間（遊戲值已含天賦與急速；引導技能遊戲回傳 0，用資料）
  local castMs = id and select(2, API.SpellInfo(id))
  if f.kind ~= "channel" and castMs then row.cast = castMs / 1000; src.cast = "遊戲" else row.cast = d and d.cast or 0; src.cast = "資料" end
  row.dur = d and d.dur
  if f.kind == "channel" then row.dur = row.dur or row.cast end
  -- 冷卻（真言術：盾的冷卻欄代表同目標虛弱靈魂，用資料）
  local cdMs = API.BaseCooldown(id)
  if f.kind ~= "absorb" and cdMs and (cdMs > 0 or not d) then row.cd = cdMs / 1000; src.cd = "遊戲" else row.cd = d and d.cd or 0; src.cd = "資料" end
  -- 係數（只能用資料；沒有這階的資料就用同技能最高階的係數）
  if d then row.coeff = d.coeff; row.rel = d.rel
  else
    local best
    for rr, dd in pairs(f.ranks) do if not best or rr > best then best = rr end end
    row.coeff = f.ranks[best].coeff; row.rel = "係數未確認"
  end
  local down = db.downrank and foreverDownrank(ctx.level, row.learn) or 1
  row.down = down
  -- 基礎量
  local desc = getDesc(id)
  if id and not desc then scan.missingDesc = true end
  local gmin, gmax, ghot = parseDesc(f.parse, desc)
  local gdur = desc and tonumber(desc:match("(%d+)%s*秒內"))
  if gmin and gmax then
    -- 若說明已經把治療效果加進去，扣回來
    if d and ctx.bonus > 0 and not ctx.descIncl then
      local dataAvg, gAvg = (d.min + d.max) / 2, (gmin + gmax) / 2
      local add = ctx.bonus * row.coeff * down
      local exp = dataAvg + add
      if math.abs(gAvg - exp) < math.abs(gAvg - dataAvg) and math.abs(gAvg - exp) / exp < 0.03 then
        gmin, gmax = gmin - add, gmax - add; src.baseNote = "說明含治療效果，已扣除"
      end
    end
    row.min, row.max = gmin, gmax; src.base = "遊戲"
  elseif d then row.min, row.max = d.min, d.max; src.base = "資料"
  else return nil end
  if f.parse == "regrowth" then
    if ghot then row.hotBase = ghot; src.hot = "遊戲" elseif d and d.hotBase then row.hotBase = d.hotBase; src.hot = "資料" else return nil end
    row.hotCoeff = d and d.hotCoeff or 0
    row.dur = gdur or row.dur or 21
  end
  if f.parse == "hot" and gdur then row.dur = gdur end -- 回春術、恢復的持續時間也從說明讀（天賦會改）
  local nGame = 0
  for _, k in ipairs({ "mana", "cast", "base" }) do if src[k] == "遊戲" then nGame = nGame + 1 end end
  row.srcText = nGame == 3 and "遊戲" or nGame == 0 and "資料" or "部分"
  return row
end

local function compute()
  ensureDB()
  if scan.dirty then rescan() end
  local _, class = UnitClass("player")
  local ctx = { level = UnitLevel("player"), bonus = (GetSpellBonusHealing and GetSpellBonusHealing()) or 0 }
  ctx.descIncl = descIncludesBonus()
  ctx.class = class
  ctx.spirit = (UnitStat and select(2, UnitStat("player", 5))) or 0
  -- 每秒回藍：遊戲已把精神、MP5、施法中保留回藍的天賦都算好；idle＝停手滿 5 秒後，active＝施法中（5 秒內）
  local okR, idle, active = pcall(GetManaRegen)
  ctx.regenIdle, ctx.regenActive = okR and idle or 0, okR and active or 0
  ctx.maxMana = UnitPowerMax and UnitPowerMax("player", 0) or 0
  ctx.ripKnown = scan.families.ript and scan.families.ript.maxRank > 0 or false
  local tal = scanTalents(class)
  ctx.healPct = (db.pct or tal.heal) / 100
  ctx.absorbPct = (db.absorb or tal.absorb) / 100
  ctx.talents = tal
  local targets = math.max(2, math.min(10, db.targets or 5))
  local rows, byId = {}, {}
  local hsMana
  do -- 聖光戒備要接一發最高階神聖震擊
    local st = scan.families.hs
    if st and st.maxRank > 0 then
      local id = st.known[st.maxRank]
      local costs = API.PowerCost(id)
      hsMana = costs and costs[1] and costs[1].cost or (st.f.ranks[st.maxRank] and st.f.ranks[st.maxRank].mana)
    end
  end
  for _, st in pairs(scan.families) do
    for r = 1, st.maxRank do
      local id = st.known[r] or nil
      local row = readRank(st, r, id, ctx)
      if row then
        local f = row.f
        local avg = (row.min + row.max) / 2
        local mult = 1
        if f.kind == "absorb" then mult = f.absorbPct and (1 + ctx.absorbPct) or 1
        elseif f.healPct then mult = 1 + ctx.healPct end
        local per
        row.bonusPart = ctx.bonus * row.coeff * row.down * mult -- 估計值，只用來顯示
        if ctx.descIncl and row.src.base == "遊戲" then
          -- 說明的數字已含治療效果與加成：直接當有效量，不再重複加
          per = avg
          if f.parse == "regrowth" then row.directPart, row.hotPart = avg, row.hotBase; per = per + row.hotBase end
          row.inclDesc = true
        else
          per = (avg + ctx.bonus * row.coeff * row.down) * mult
          if f.parse == "regrowth" then -- HoT 段的治療效果係數另計（永恆 DB2：直接 0.286、HoT 0.497）
            local hot = (row.hotBase + ctx.bonus * row.hotCoeff * row.down) * mult
            row.directPart, row.hotPart = per, hot; per = per + hot
          end
        end
        -- 情境加成（不在技能說明裡）
        local sitAdd = 0
        row.oathRatio = nil
        if ctx.class == "PALADIN" then
          -- 聖光誓約，遊戲內實測（33、34 級）：固定量也乘治療之光等加成（聖光術 507–568＋220×1.12，實測 766／808／815）；
          -- 比例＝1 −（角色等級 − 學會等級 − 12）× 5%，0～100%：比技能高 12 級內拿全部，之後每級少 5%
          -- （34 級：聖光術 2 階實測平均 213.1，預測 214.1；3 階實測 457.1，預測 456.9）
          local oath = ctx.talents.oath
          row.oathRatio = math.max(0, math.min(1, 1 - (ctx.level - row.learn - 12) * 0.05))
          sitAdd = ((oath and not oath.unknown and oath[f.key]) or 0) * mult * row.oathRatio
        elseif ctx.class == "PRIEST" and ctx.talents.sitLearned and f.key == "fh" then
          sitAdd = per * 0.5 -- 聖光束縛：快速治療施放在別人身上時自己回復 50%
        elseif ctx.class == "SHAMAN" and ctx.ripKnown and f.key == "ch" then
          sitAdd = per * 0.25 -- 激流：對有激流的目標直接施放治療鍊 +25%（只算第一跳）
        elseif ctx.class == "DRUID" and ctx.talents.sitLearned and (f.key == "rejuv" or f.key == "rgh") then
          sitAdd = ctx.spirit -- 綻放：HoT 自然結束時回復精神的 100%
        end
        row.oathAdd = sitAdd
        row.withOath = db.oath and sitAdd > 0 or nil
        row.perHeal = per
        local occupy = f.kind == "channel" and math.max(row.cast, row.dur or 0, f.gcd) or math.max(row.cast, f.gcd)
        -- 單體 HoT（含癒合這種直接＋HoT）在群補模式：持續時間內能輪流施放給幾個人（每次占用施法時間／公共冷卻，有冷卻就受冷卻限制），
        -- 最多到群補人數；鋪不到 2 人的（例如激流：冷卻 12 秒、持續 15 秒）不算群補
        -- 冷卻技能（有冷卻、不是吸收盾）另列一頁，照施放時的 HPS 算
        local isCd = row.cd > 0 and f.kind ~= "absorb"
        row.isCd = isCd or nil
        local reach = not isCd and f.kind == "hot" and not f.group and (row.dur or 0) > 0 and math.floor(row.dur / math.max(occupy, row.cd)) or 0
        row.spread = reach >= 2 or nil
        local spreading = row.spread and db.mode == "group"
        local total, used = per, 1
        if f.key == "bh" then total, used = per * 2, 2
        elseif f.group then
          used = math.min(targets, f.maxTargets)
          total = f.groupModel == "chain50" and per * chainFactor(used) or per * used
        elseif spreading then used = math.min(targets, reach) end
        -- 癒合輪流施放：同一人每「人數 × 占用」秒重放一次，HoT 沒跑完就被蓋掉，每發只算跑到的比例
        local hotFrac = 1
        if row.hotPart then
          if spreading then hotFrac = math.min(1, used * occupy / row.dur) end
          total = row.directPart + row.hotPart * hotFrac
        elseif spreading then total = per * used end
        row.totalHeal, row.targets = total, used
        -- 情境加成；綻放在 HoT 自然結束才回：鋪幾人回幾次，癒合被蓋掉就沒有
        local sitTimes = row.hotPart and (hotFrac >= 1 and 1 or 0) or (spreading and used or 1)
        if row.withOath then per = per + sitAdd; total = total + sitAdd * sitTimes; row.perHeal, row.totalHeal = per, total end
        local manaEff = row.mana
        if spreading and not row.hotPart then manaEff = manaEff * used end -- 鋪幾個人就施放幾次（癒合已經是每發的量）
        if f.key == "vigil" and hsMana then manaEff = manaEff + hsMana; occupy = occupy + 1.5 end
        local t = occupy
        -- 純 HoT 用效果期間：總量 ÷ 持續時間（冷卻比持續時間長就用冷卻）；群補 HoT 的總量已乘上目標數
        if f.kind == "hot" and not row.hotPart and (row.dur or 0) > 0 then t = math.max(row.dur, occupy)
        elseif f.kind == "absorb" then t = math.max(row.cd, occupy, 15) end -- 同一目標受虛弱靈魂限制 15 秒一次
        row.manaEff, row.time = manaEff, t
        local shown = (f.key == "bh" or ((db.mode == "group" or isCd) and (f.group or row.spread))) and total or per
        row.shown = shown
        row.hps = t > 0 and shown / t or 0
        row.hpm = manaEff > 0 and shown / manaEff or 0
        row.hpsT = t > 0 and total / t or 0
        row.hpmT = manaEff > 0 and total / manaEff or 0
        if row.hotPart then
          -- 直接 ÷ 施法時間 ＋ HoT ÷ 持續時間（群補輪流時 HoT 乘人數）；HPM 用每發的有效量
          local bloom = row.withOath and sitAdd * sitTimes or 0
          row.shown = total
          row.hps = row.directPart / t + ((spreading and used or 1) * row.hotPart + bloom) / row.dur
          row.hpsT = row.hps
          row.hpm = manaEff > 0 and total / manaEff or 0
          row.hpmT = row.hpm
        end
        table.insert(rows, row)
        if row.id then byId[row.id] = byId[row.id] or {}; table.insert(byId[row.id], row) end
      end
    end
  end
  local hasRgh = {}
  for _, r in ipairs(rows) do if r.key == "rgh" then hasRgh[r.rank] = true end end
  if next(hasRgh) then
    local kept = {}
    for _, r in ipairs(rows) do if not (r.key == "rg" and hasRgh[r.rank]) then table.insert(kept, r) end end
    rows = kept
    byId = {}
    for _, r in ipairs(rows) do if r.id then byId[r.id] = byId[r.id] or {}; table.insert(byId[r.id], r) end end
  end
  scan.rows, scan.byId, scan.ctx = rows, byId, ctx
  if scan.missingDesc and scan.unmatchedRetry < 3 then
    -- 技能說明還沒載入：稍後再讀一次
    scan.unmatchedRetry = scan.unmatchedRetry + 1
    C_Timer.After(2, function() if HealHPSFrame and HealHPSFrame:IsShown() then HealHPS_Refresh() end end)
  end
  return rows, ctx
end

local SORT_LABEL = { hps = "HPS", hpm = "HPM", heal = "有效量" }

local function filterRows(rows, mode)
  local list = {}
  for _, r in ipairs(rows) do
    local f = r.f
    local ok
    if mode == "cd" then ok = r.isCd
    elseif r.isCd then ok = false
    elseif mode == "group" then ok = f.group or r.spread
    else ok = not f.group end
    if ok then table.insert(list, r) end
  end
  local k = db.sort == "heal" and "shown" or db.sort
  table.sort(list, function(a, b) return a[k] > b[k] end)
  return list
end
-- 最佳 HPS、最佳 HPM（在同一類：單補跟單補比、群補跟群補比）
local function bests(list)
  local h, m
  for _, r in ipairs(list) do
    if r.f.kind == "absorb" then -- 吸收量不等於治療量，不參加 HPS／HPM 最高的比較
    elseif not h or r.hps > h.hps then h = r end
    if r.f.kind == "absorb" then
    elseif not m or r.hpm > m.hpm then m = r end
  end
  return h, m
end
local function sameRow(a, b) return a and b and a.key == b.key and a.rank == b.rank end
local function filtered()
  local rows, ctx = compute()
  return filterRows(rows, db.mode), ctx
end

-- ── 分析：模擬一場戰鬥，看哪種補法讓坦克活著又最省藍 ─────────────────────
-- 每 0.1 秒一步（全部用整數步數算，避免小數誤差）。回藍照五秒規則：最後一次花藍滿 5 秒後用 i、否則用 a，連續回復。
-- 補量用期望值（爆擊 150%）；永恆的 HoT 也會爆擊，每跳都乘爆擊期望值。HoT 每 3 秒跳一次（掛上後 3 秒第一跳）。
local function analyze()
  if InCombatLockdown and InCombatLockdown() then return { err = "戰鬥中不分析" } end
  local rows = compute()
  local secret = issecretvalue or function() return false end
  local okR, regenI, regenA = pcall(GetManaRegen)
  local okM, maxMana = pcall(UnitPowerMax, "player", 0)
  if not okR or not okM or secret(regenI) or secret(regenA) or secret(maxMana)
    or type(regenI) ~= "number" or type(regenA) ~= "number" or type(maxMana) ~= "number" or maxMana <= 0 then
    return { err = "讀不到回藍" }
  end
  local okC, crit = pcall(GetSpellCritChance, 2) -- 2＝神聖系；回傳百分比
  crit = (okC and not secret(crit) and type(crit) == "number") and crit / 100 or 0
  local critMul = 1 + crit * 0.5
  local DT = 0.1
  local TICK = math.floor(3 / DT + 0.5)
  local steps = math.floor(db.fight / DT + 0.5)
  local gap = math.max(1, math.floor(db.anaGap / DT + 0.5))
  local hp0, hit = db.anaHp, db.anaHit
  -- 某段時間內（現在之後到 s 步為止）會挨幾下：第 k 下落在 k×gap 步
  local function hitsBy(now, s) return math.floor(s / gap) - math.floor(now / gap) end

  local function mk(r)
    local pureHot = r.f.kind == "hot" and not r.hotPart and (r.dur or 0) > 0
    local cast = math.floor(math.max(r.f.kind == "channel" and math.max(r.cast, r.dur or 0) or r.cast, 0) / DT + 0.5)
    local direct = pureHot and 0 or (r.hotPart and r.directPart or r.perHeal)
    local hot = pureHot and r.perHeal or (r.hotPart or 0)
    local dur = math.max(1, math.floor((r.dur or 0) / DT + 0.5))
    local n = hot > 0 and math.max(1, math.floor(dur / TICK)) or 0
    return { r = r, key = r.f.key, mana = r.mana, cast = cast, busy = math.max(cast, math.floor(r.f.gcd / DT + 0.5)),
      cd = math.floor((r.cd or 0) / DT + 0.5), direct = direct, hot = hot, n = n, every = math.min(TICK, dur), pureHot = pureHot,
      -- 平常／預先放：直接治療看施法期間，爆擊也不溢補；純 HoT 看整段持續時間的期望總量
      need = pureHot and hot * critMul or direct * 1.5, win = pureHot and cast + dur or cast,
      -- 保持 HoT：缺的血＋持續時間內會挨的打 ≥ 這發的期望總量才補上
      full = (direct + hot) * critMul, fullWin = cast + dur }
  end

  -- 能拿來單補坦克的技能：每個學會的等級都算（降級在這裡很重要），群補、冷卻、吸收盾不算
  local spells = {}
  for _, r in ipairs(rows) do
    if not r.f.group and not r.isCd and r.f.kind ~= "absorb" and r.perHeal > 0 then table.insert(spells, mk(r)) end
  end

  -- main：平常用；emerg：救命用；keep：要一直掛著的 HoT（過期才補，激流照冷卻）
  -- pause：刻意停手，坦克掉到這個比例以下才開始補，補到再補會溢補就停（停超過 5 秒就吃到完整回藍）
  local function run(main, emerg, keep, pause)
    keep = keep or {}
    local isKeep, applied = {}, {}
    for _, k in ipairs(keep) do isKeep[k] = true end
    local resting = pause ~= nil
    local hp, mana, last = hp0, maxMana, -1e9
    local minHp, healed, over, casts, eCasts, hCasts = hp0, 0, 0, 0, 0, 0
    local oom, dead, casting, castEnd, busyUntil = nil, nil, nil, 0, 0
    local hots, ready = {}, {} -- 同一技能（不分等級）只會有一個 HoT，重放會蓋掉
    local function heal(amount)
      local eff = math.min(amount, hp0 - hp)
      hp, healed, over = hp + eff, healed + eff, over + amount - eff
    end
    -- 已經掛著的 HoT 在 e 步（含）以前還會跳的量
    local function pendingBy(e)
      local sum = 0
      for _, h in pairs(hots) do
        if e >= h.next then sum = sum + h.per * math.min(h.left, math.floor((e - h.next) / h.every) + 1) end
      end
      return sum
    end
    for s = 1, steps do
      if s % gap == 0 then
        hp = hp - hit
        if hp < minHp then minHp = hp end
        if hp <= 0 then dead = s; break end
      end
      mana = math.min(maxMana, mana + (s - last >= 5 / DT and regenI or regenA) * DT)
      if not casting and s >= busyUntil then
        local missing = hp0 - hp
        -- 救命：施法期間挨完打後，再一下就倒 → 立刻放，溢補也放（救命技能藍不夠時，主力夠就先放主力）
        local wantE = not (emerg.pureHot and hots[emerg.key]) and hp - hitsBy(s, s + emerg.cast) * hit <= hit
        local pick, want = nil, wantE
        if wantE then pick = (mana >= emerg.mana and emerg) or (mana >= main.mana and main) or nil
        else
          -- 保持 HoT：過期、冷卻好了、補得到不溢補，而且放完再接救命也來得及
          for _, k in ipairs(keep) do
            if not pick and not hots[k.key] and s >= (ready[k.key] or 0)
              and missing - pendingBy(s + k.fullWin) + hitsBy(s, s + k.fullWin) * hit >= k.full
              and hp - hitsBy(s, s + k.busy + emerg.cast) * hit > hit then
              want = true
              if mana >= k.mana then pick = k end
            end
          end
          -- 平常／預先放：缺的血－補到前會跳的 HoT＋施法期間會挨的打 ≥ 門檻
          if not pick and not (main.pureHot and hots[main.key]) then
            if resting and hp <= hp0 * pause then resting = false end
            if missing - pendingBy(s + main.win) + hitsBy(s, s + main.win) * hit >= main.need then
              if not resting then
                want = true
                if mana >= main.mana then pick = main end
              end
            elseif pause then resting = true end
          end
        end
        if pick then
          casting, castEnd, busyUntil, casts = pick, s + pick.cast, s + pick.busy, casts + 1
          if pick.cd > 0 then ready[pick.key] = s + pick.cd end
          if isKeep[pick] then hCasts = hCasts + 1; applied[pick.key] = true
          elseif pick ~= main then eCasts = eCasts + 1 end
        elseif want and not oom then oom = s end
      end
      -- 施法完成才扣藍（瞬發同一步就完成）
      if casting and s >= castEnd then
        mana, last = mana - casting.mana, s
        heal(casting.direct * critMul)
        if casting.n > 0 then
          hots[casting.key] = { sp = casting, per = casting.hot / casting.n * critMul, left = casting.n, every = casting.every, next = s + casting.every }
        end
        casting = nil
      end
      for key, h in pairs(hots) do
        if s >= h.next then
          heal(h.per); h.left, h.next = h.left - 1, h.next + h.every
          if h.left <= 0 then hots[key] = nil end
        end
      end
    end
    -- 戰鬥結束時還沒跳的 HoT 按比例退藍，免得最後才掛上的 HoT 吃虧
    if not dead then for _, h in pairs(hots) do mana = mana + h.sp.mana * h.left / h.sp.n end; mana = math.min(mana, maxMana) end
    local function nm(sp, sep) return sp.r.label .. sep .. sp.r.rank end
    local lasted = (dead or steps) * DT
    local name, long
    if #keep > 0 then
      local a, b = {}, {}
      for i, k in ipairs(keep) do a[i], b[i] = nm(k, " "), nm(k, " 等級") end
      name = "保持" .. table.concat(a, "、") .. "＋" .. nm(main, " ")
      long = "保持" .. table.concat(b, "、") .. "＋" .. nm(main, " 等級") .. (emerg ~= main and ("，救命 " .. nm(emerg, " 等級")) or "")
    else
      local tag = pause and string.format("（停到 %d%%）", math.floor(pause * 100 + 0.5)) or ""
      name = nm(main, " ") .. (emerg ~= main and ("＋" .. nm(emerg, " ")) or "") .. tag
      long = nm(main, " 等級") .. (emerg ~= main and ("＋" .. nm(emerg, " 等級")) or "") .. tag
    end
    local allApplied = true
    for _, k in ipairs(keep) do if not applied[k.key] then allApplied = false end end
    -- 剩藍＝戰後用主力把坦克補滿之後還剩的藍（停手會把坦克留在低血量，要算進去；可以是負的），排名和顯示都用這個
    local topped = dead and mana or mana - (hp0 - hp) * main.mana / main.full
    -- 同樣的戰鬥能連打幾波不用喝水：淨用藍不到 1 點就算不用喝水
    local net = maxMana - topped
    return { name = name, long = long, pulls = not dead and (net < 1 and math.huge or math.floor(maxMana / net)) or nil,
      dead = dead and dead * DT, minPct = math.max(0, minHp) / hp0 * 100, healed = healed, over = over,
      mana = topped, rawMana = mana, endPct = math.max(0, hp) / hp0 * 100, oom = oom and oom * DT, casts = casts, eCasts = eCasts, hCasts = hCasts, allApplied = allApplied,
      every = casts > 0 and lasted / casts or nil, combo = emerg ~= main }
  end

  local list = {}
  -- 每個等級單用，再加「停到 60%」「停到 40%」兩種刻意停手；結果跟前一種一樣的不列
  for _, sp in ipairs(spells) do
    local prev = run(sp, sp)
    table.insert(list, prev)
    for _, p in ipairs({ 0.6, 0.4 }) do
      local res = run(sp, sp, nil, p)
      if res.casts ~= prev.casts or res.mana ~= prev.mana or res.minPct ~= prev.minPct or res.dead ~= prev.dead then
        table.insert(list, res); prev = res
      end
    end
  end
  -- 組合：主力＝HPM 前 4 名，救命＝HPS 前 4 名裡比主力 HPS 高的
  local byHpm, byHps = {}, {}
  for i, sp in ipairs(spells) do byHpm[i], byHps[i] = sp, sp end
  table.sort(byHpm, function(a, b) return a.r.hpm > b.r.hpm end)
  table.sort(byHps, function(a, b) return a.r.hps > b.r.hps end)
  for i = 1, math.min(4, #byHpm) do
    for j = 1, math.min(4, #byHps) do
      local m, e = byHpm[i], byHps[j]
      if m ~= e and e.r.hps > m.r.hps then
        local res = run(m, e)
        if res.eCasts > 0 then table.insert(list, res) end -- 救命技能沒用到就跟單用主力一樣，不重複列
      end
    end
  end
  -- 保持 HoT＋主力：第一個 HoT 和主力各試最高階、最省藍（HPM 最高）兩階，第二個 HoT（癒合）只用最高階；救命＝HPS 最高的單補
  local fam = {}
  for _, r in ipairs(rows) do
    if not r.f.group and r.f.kind ~= "absorb" and r.perHeal > 0 then fam[r.key] = fam[r.key] or {}; table.insert(fam[r.key], r) end
  end
  local function two(keys)
    local hi, best
    for _, k in ipairs(keys) do
      for _, r in ipairs(fam[k] or {}) do
        if not hi or r.perHeal > hi.perHeal then hi = r end
        if not best or r.hpm > best.hpm then best = r end
      end
    end
    return not hi and {} or hi == best and { hi } or { hi, best }
  end
  local ROT = { { { "rejuv" }, { "ht" } }, { { "rejuv", "rgh" }, { "ht" } }, { { "renew" }, { "heal", "gh" } },
    { { "renew" }, { "fh" } }, { { "ript" }, { "hw" } }, { { "ript" }, { "lhw" } } }
  local top = byHps[1]
  for _, rot in ipairs(ROT) do
    local firsts, second = two({ rot[1][1] }), rot[1][2] and two({ rot[1][2] })[1]
    if not (rot[1][2] and not second) then
      for _, h in ipairs(firsts) do
        for _, fr in ipairs(two(rot[2])) do
          local keep = { mk(h) }
          if second then keep[2] = mk(second) end
          local main = mk(fr)
          local res = run(main, (not top or top.r == fr) and main or top, keep)
          if res.allApplied then table.insert(list, res) end -- HoT 一次都沒掛上就跟單用主力一樣，不重複列
        end
      end
    end
  end
  -- 活下來的排前面：剩藍多、最低血量高的優先；都倒下就比誰撐得久
  table.sort(list, function(a, b)
    if (a.dead == nil) ~= (b.dead == nil) then return a.dead == nil end
    if a.dead then return a.dead > b.dead end
    if a.mana ~= b.mana then return a.mana > b.mana end
    return a.minPct > b.minPct
  end)
  return { list = list }
end

-- ── 滑鼠提示 ───────────────────────────────────────────────────────────────
-- 把提示框第 from 行之後（我們加的行）統一成同一種字型，避免大小不一
local function unifyFont(tt, from)
  local name = tt.GetName and tt:GetName()
  if not name or not GameTooltipText then return end
  for i = from, tt:NumLines() do
    for _, side in ipairs({ "TextLeft", "TextRight" }) do
      local fs = _G[name .. side .. i]
      if fs and fs.SetFontObject then fs:SetFontObject(GameTooltipText) end
    end
  end
end

-- 拆解行（提示「標準」以上）：直接＋HoT 分開、HoT 輪流掛、盾輪流上、冷卻技能的冷卻時間
local function breakdown(r)
  local busy = math.max(r.cast, r.f.gcd)
  local spread = r.spread and r.targets > 1 -- 群補模式輪流鋪：主數字已經是輪流的算法，不再列輪流那行
  if r.isCd then
    return (r.f.kind == "hot" and (r.dur or 0) > 0) and string.format("%d 秒內補完；冷卻 %s 秒", r.dur, fmt1(r.cd))
      or string.format("冷卻 %s 秒", fmt1(r.cd))
  elseif r.hotPart and spread then
    return string.format("直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%", fint(r.directPart), fmt1(r.directPart / busy),
      r.dur, fint(r.hotPart), r.targets, math.floor(math.min(1, r.targets * busy / r.dur) * 100 + .5))
  elseif r.hotPart then
    return string.format("直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s", fint(r.directPart), fmt1(r.directPart / busy),
      r.dur, fint(r.hotPart), fmt1(r.hotPart / r.dur), fmt1((r.directPart + r.hotPart) / busy))
  elseif r.f.kind == "hot" and spread then
    return string.format("%d 秒內補完；鋪 %d 人", r.dur, r.targets)
  elseif r.f.kind == "hot" and (r.dur or 0) > 0 then
    return string.format("%d 秒內補完；輪流掛不同目標時每秒 %s", r.dur, fmt1(r.perHeal / busy))
  elseif r.f.kind == "absorb" then
    return string.format("同一目標 15 秒一次；輪流上不同目標時每秒 %s", fmt1(r.perHeal / busy))
  end
end

local function addTooltip(tt, id)
  ensureDB()
  if not db.tip or not id then return end
  if scan.dirty or not scan.ctx then compute() end
  if not scan.byId[id] then return end
  compute() -- 治療效果、增益可能改變，重新算
  local rows = scan.byId[id]
  if not rows then return end
  local cat = rows[1].isCd and "cd" or (rows[1].f.group or (rows[1].spread and db.mode == "group")) and "group" or "single"
  local bh, bm
  for _, r in ipairs(filterRows(scan.rows, cat)) do
    if r.f.kind ~= "absorb" then
      if not bh or r.hpsT > bh.hpsT then bh = r end
      if not bm or r.hpmT > bm.hpmT then bm = r end
    end
  end
  local catName = ({ single = "單補", group = "群補", cd = "冷卻" })[cat]
  local firstLine = (tt.NumLines and tt:NumLines() or 0) + 1
  for _, r in ipairs(rows) do
    local tag = r.f.kind == "absorb" and "（吸收）" or ((r.f.group or r.f.key == "bh" or r.targets > 1) and string.format("（%d人）", r.targets) or "")
    local sit = SIT[select(2, UnitClass("player"))]
    if r.withOath and sit then tag = "（" .. sit.tip .. "）" end
    -- 左欄標籤、右欄數字，兩排數字靠右對齊
    tt:AddDoubleLine("|cffd9b25fHPS ／ HPM|r" .. tag, fmt1(r.hpsT) .. " ／ " .. fmt2(r.hpmT), 1, 1, 1, 1, 1, 1)
    local detail = breakdown(r)
    if detail and db.tipLevel >= 2 then tt:AddLine(detail, .8, .8, .8) end
    if r.oathAdd > 0 and not r.withOath and sit and db.tipLevel >= 2 then
      local h = r.totalHeal + r.oathAdd
      tt:AddDoubleLine("|cffd9b25f" .. sit.tip .. "|r", fmt1(r.time > 0 and h / r.time or 0) .. " ／ " .. fmt2(r.manaEff > 0 and h / r.manaEff or 0), 1, 1, 1, 1, 1, 1)
    end
    if db.tipLevel >= 3 then
      if r.down < 0.9995 then tt:AddDoubleLine("降級", string.format("治療效果只算 %d%%", math.floor(r.down * 100 + .5)), .8, .8, .8, 1, .6, .3) end
    end
    if sameRow(r, bh) then tt:AddLine("★ " .. catName .. " HPS最高", 1, .82, 0) end
    if sameRow(r, bm) then tt:AddLine("★ " .. catName .. " HPM最高", .4, 1, .4) end
  end
  unifyFont(tt, firstLine)
  tt:Show()
end

local function hookTooltips()
  if TooltipDataProcessor and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Spell then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tt, data)
      if tt == GameTooltip and data then safe("滑鼠提示", addTooltip, tt, data.id) end
    end)
  else
    GameTooltip:HookScript("OnTooltipSetSpell", function(tt)
      local _, b, c = tt:GetSpell()
      local id = (type(c) == "number" and c) or (type(b) == "number" and b) or nil -- 舊版第二個回傳值可能是等級文字
      safe("滑鼠提示", addTooltip, tt, id)
    end)
  end
end

-- ── 比較表視窗 ─────────────────────────────────────────────────────────────
-- 比較表：一列一個技能等級；★ 與等級各自一欄，數字一律靠右對齊
local W = 520        -- 內容寬度
local ROW_H = 24
local MAXLINES = 18  -- 最多顯示幾列（多的用滾輪捲動）
local TOP = 120      -- 第一列的位置
local ANA_TOP = 92   -- 分析頁從這裡開始（資訊列下面）
-- { 標題, x, 寬, 對齊, 排序鍵 }
local COLS = {
  { "",     0,   24, "CENTER" },
  { "技能", 16,  160, "LEFT" },
  { "等級", 150, 44,  "RIGHT" },
  { "有效量", 184, 72, "RIGHT", "heal" },
  { "法力", 240, 56,  "RIGHT" },
  { "秒",   284, 44,  "RIGHT" },
  { "HPS",  318, 72,  "RIGHT", "hps" },
  { "HPM",  366, 60,  "RIGHT", "hpm" },
}
local frame, offset = nil, 0
local GOLD, GREEN, DIM = { 1, .82, 0 }, { .4, 1, .4 }, { .6, .57, .5 }

local function cell(parent, col)
  local f = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  f:SetPoint("LEFT", parent, "LEFT", col[2], 0); f:SetWidth(col[3]); f:SetJustifyH(col[4]); f:SetWordWrap(false)
  return f
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

local function button(parent, w, label, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(w + 16, 26); b:SetText(label); b:SetScript("OnClick", onClick)
  fitButton(b, w + 16)
  return b
end

local GAP = 16
local function measure(fsObj)
  if fsObj.GetUnboundedStringWidth then
    local w = fsObj:GetUnboundedStringWidth()
    if type(w) == "number" and w > 0 then return w end
  end
  local w = fsObj.GetStringWidth and fsObj:GetStringWidth()
  return type(w) == "number" and w or 0
end
local autoFit -- 定義在下面
local function refreshImpl()
  if not frame or not frame:IsShown() then return end
  local list, ctx = filtered()
  local tal = ctx.talents
  frame.talTxt = db.pct and ("治療加成 " .. db.pct .. "%（手動）") or (#tal.found > 0 and table.concat(tal.found, "、") or "")
  local o = tal.oath
  if o then
    frame.talTxt = frame.talTxt .. (frame.talTxt ~= "" and "\n" or "") .. (o.unknown and "聖光誓約：讀不到加成量（請執行 /shps debug 回報）"
      or string.format("聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d", o.hl, o.fol, o.hs))
  end
  local cls = select(2, UnitClass("player"))
  local sit = SIT[cls]
  local has = (cls == "PALADIN" and o ~= nil) or ((cls == "PRIEST" or cls == "DRUID") and tal.sitLearned) or (cls == "SHAMAN" and ctx.ripKnown)
  if cls == "DRUID" and has then frame.talTxt = frame.talTxt .. (frame.talTxt ~= "" and "\n" or "") .. "綻放：每次 HoT 結束 +" .. fint(ctx.spirit) end
  if sit then frame.oathBtn:SetText(sit.label .. "：" .. (not has and "沒學" or (db.oath and "計入" or "不計入"))) end
  local isPal = sit ~= nil -- 有情境加成的職業才顯示這個按鈕（四個治療職業都有）
  frame.oathBtn:SetShown(isPal)
  frame.sitHelp = sit and sit.help or ""
  local th = frame.how.GetStringHeight and frame.how:GetStringHeight()
  th = (type(th) == "number" and th > 0) and th or 40
  frame.tgtBtn:ClearAllPoints(); frame.tgtBtn:SetPoint("TOP", frame.opts, "TOP", 0, -(10 + th + 12))
  frame.opts:SetHeight(10 + th + 12 + (isPal and 3 or 2) * 30 + 8)
  frame.info:SetText(string.format("%d 級 · 治療效果 %d", ctx.level, ctx.bonus))
  for _, m in ipairs({ { frame.singleBtn, "single" }, { frame.groupBtn, "group" }, { frame.cdModeBtn, "cd" }, { frame.anaBtn, "analysis" } }) do
    local on = db.mode == m[2]
    m[1]:GetFontString():SetTextColor(on and 1 or .55, on and .82 or .52, on and 0 or .45)
  end
  frame.tipBtn:SetText("技能提示：" .. (not db.tip and "關" or ({ "精簡", "標準", "完整" })[db.tipLevel]))
  frame.tgtLabel:SetText("群補人數 " .. (db.targets or 5))
  if frame.tgtSlider:GetValue() ~= (db.targets or 5) then frame.tgtSlider:SetValue(db.targets or 5) end
  local ana = db.mode == "analysis"
  frame.ana:SetShown(ana); frame.head:SetShown(not ana); frame.foot:SetShown(not ana)
  if ana then
    for i = 1, MAXLINES do frame.lines[i]:Hide(); frame.lines[i].row = nil end
    for _, inp in ipairs(frame.anaInputs) do
      local d = inp.def
      inp.fs:SetText(string.format(d[2], db[d[1]]))
      if inp.sl:GetValue() ~= db[d[1]] then inp.sl:SetValue(db[d[1]]) end
    end
    local inCombat = InCombatLockdown and InCombatLockdown()
    if inCombat then frame.anaKey = nil -- 脫戰後再開會重算
    else
      -- 輸入改了才重算；拖滑桿時等 0.2 秒沒再動才算
      local key = table.concat({ db.anaHp, db.anaHit, db.anaGap, db.fight }, ",")
      if frame.anaKey ~= key then
        frame.anaKey = key
        local token = {}
        frame.anaToken = token
        local function go()
          if frame.anaToken ~= token or db.mode ~= "analysis" or not frame:IsShown() then return end
          safe("分析", function() frame.anaRes = analyze() end)
          HealHPS_Refresh()
        end
        if C_Timer and C_Timer.After then C_Timer.After(0.2, go) else go() end
      end
    end
    frame.anaDetailBtn:GetFontString():SetTextColor(db.anaDetail and 1 or .55, db.anaDetail and .82 or .52, db.anaDetail and 0 or .45)
    local res = frame.anaRes
    local list = res and res.list or {}
    -- 結論：活下來的分「最省藍」「最穩定」各前 2 名（都倒下就列「撐最久」前 2 名）；詳細：全部照排名，滾輪捲動
    local alive = {}
    for _, r in ipairs(list) do if not r.dead then table.insert(alive, r) end end
    local byMana, byMin = {}, {}
    for i, r in ipairs(alive) do byMana[i], byMin[i] = r, r end
    table.sort(byMana, function(a, b) if a.mana ~= b.mana then return a.mana > b.mana end return a.minPct > b.minPct end)
    table.sort(byMin, function(a, b) if a.minPct ~= b.minPct then return a.minPct > b.minPct end return a.mana > b.mana end)
    local entries = {}
    if db.anaDetail then
      local off = math.max(0, math.min(frame.anaOff or 0, #list - #frame.anaLines))
      frame.anaOff = off
      for i = off + 1, math.min(#list, off + #frame.anaLines) do table.insert(entries, { r = list[i], no = i }) end
    else
      local groups = #alive > 0 and { { "最省藍", byMana }, { "最穩定", byMin } } or #list > 0 and { { "撐最久", list } } or {}
      for _, g in ipairs(groups) do
        table.insert(entries, { head = g[1] })
        for i = 1, math.min(2, #g[2]) do table.insert(entries, { r = g[2][i], no = i }) end
      end
    end
    local best = list[1]
    local conc = inCombat and "戰鬥中不分析" or (res and res.err) or (res and not best and "沒有可以單補的技能")
      or (byMana[1] and string.format("|cffffd100最省藍：|r%s；|cffffd100最穩定：|r%s", byMana[1].name, byMin[1].name))
      or (best and string.format("|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）", best.long, math.floor(best.dead + 0.5))) or ""
    frame.anaConc:SetText(conc)
    local cols, n = #frame.anaLines[1].c, 0
    for i, l in ipairs(frame.anaLines) do
      local e = not inCombat and entries[i]
      local r = e and e.r
      if e and e.head then
        n = i
        for c = 1, cols do l.c[c]:SetText(c == 2 and e.head or "") end
        l.c[2]:SetTextColor(unpack(GOLD)); l.hl:Hide()
        l.res = nil; l:Show()
      elseif r then
        n = i
        local vals = { e.no .. ".", r.name, r.dead and string.format("倒下 %d 秒", math.floor(r.dead + 0.5)) or "活",
          r.oom and string.format("沒藍 %d 秒", math.floor(r.oom + 0.5)) or ("剩藍 " .. fint(r.mana)),
          string.format("最低 %d%%", math.floor(r.minPct + 0.5)),
          r.every and ("每 " .. fmt1(r.every) .. " 秒一發") or "沒出手",
          r.pulls and (r.pulls == math.huge and "不用喝水" or r.pulls < 1 and "打完要喝水" or string.format("可連打 %d 波", r.pulls)) or "" }
        for c = 1, cols do l.c[c]:SetText(vals[c]); l.c[c]:SetTextColor(1, 1, 1) end
        l.c[3]:SetTextColor(unpack(r.dead and { 1, .42, .42 } or GREEN))
        if r.dead then l.hl:SetColorTexture(1, .2, .2, .12); l.hl:Show()
        elseif e.no == 1 then l.hl:SetColorTexture(1, .82, 0, .14); l.hl:Show(); l.c[2]:SetTextColor(unpack(GOLD))
        else l.hl:Hide() end
        l.res = r; l:Show()
      else l.res = nil; l:Hide() end
    end
    -- 欄寬照實際文字量（遊戲字型比預期大，不寫死寬度）
    local x = 0
    for c = 1, cols do
      local w = 0
      for i = 1, n do w = math.max(w, measure(frame.anaLines[i].c[c]) + 4) end
      w = math.ceil(w)
      for _, l in ipairs(frame.anaLines) do
        l.c[c]:ClearAllPoints(); l.c[c]:SetPoint("LEFT", l, "LEFT", x, 0); l.c[c]:SetWidth(w)
      end
      x = x + w + GAP
    end
    local inputW = 0
    for _, inp in ipairs(frame.anaInputs) do inputW = math.max(inputW, inp.holder:GetWidth()) end
    local total = math.ceil(math.max(x - GAP, inputW, frame.anaPresetW, measure(frame.anaConc) + 4, 360))
    for _, l in ipairs(frame.anaLines) do l:SetWidth(total) end
    frame.anaConc:SetWidth(total); frame.info:SetWidth(total); frame.ana:SetWidth(total)
    local top = frame.anaListTop
    frame.ana:SetHeight(top + n * ROW_H)
    frame:SetWidth(total + 28)
    frame:SetHeight(ANA_TOP + top + n * ROW_H + 16)
    return
  end
  for _, h in ipairs(frame.heads) do
    local on = h.key == db.sort
    h.fs:SetText((on and "▼" or "") .. h.label) -- 箭頭放左邊，右邊緣才會跟數字對齊
    h.fs:SetTextColor(unpack(on and GOLD or DIM))
  end
  local bh, bm = bests(list)
  local maxOff = math.max(0, #list - MAXLINES)
  if offset > maxOff then offset = maxOff end
  local n = 0
  for i = 1, MAXLINES do
    local l, r = frame.lines[i], list[i + offset]
    if r then
      n = i
      local isH, isM = sameRow(r, bh), sameRow(r, bm)
      local amt
      if db.mode == "group" or (db.mode == "cd" and r.f.group) then amt = fint(r.totalHeal)
      elseif r.f.key == "bh" then amt = fint(r.perHeal) .. "×2"
      elseif r.hotPart then amt = fint(r.directPart) .. "+" .. fint(r.hotPart)
      else amt = fint(r.perHeal) end
      local star = (isH and "|cffffd100★|r" or "") .. (isM and "|cff66ff66★|r" or "")
      local name = (r.f.kind == "absorb" and ("|cff8cc4ff" .. r.label .. "（吸收）|r") or r.label)
        .. (r.down < 0.9995 and string.format(" |cffff9d5c%d%%|r", math.floor(r.down * 100 + .5)) or "")
      local vals = { star, name, r.rank, amt, fint(r.manaEff), fmt1(r.time), fmt1(r.hps), fmt2(r.hpm) }
      for c = 1, #COLS do l.c[c]:SetText(vals[c]) end
      l.c[7]:SetTextColor(unpack(isH and GOLD or { 1, 1, 1 }))
      l.c[8]:SetTextColor(unpack(isM and GREEN or { 1, 1, 1 }))
      if isH then l.hl:SetColorTexture(1, .82, 0, .14); l.hl:Show()
      elseif isM then l.hl:SetColorTexture(.3, 1, .3, .11); l.hl:Show()
      else l.hl:Hide() end
      l.row = r
      l:Show()
    else l:Hide(); l.row = nil end
  end
  local foot
  if #list == 0 then foot = "這一頁沒有你學會的技能。"
  else
    foot = (bh and bm) and string.format("|cffffd100★ HPS最高|r %s 等級%d　　|cff66ff66★ HPM最高|r %s 等級%d", bh.label, bh.rank, bm.label, bm.rank)
      or "目前沒有可比較的治療技能（吸收盾不參加比較）"
    if #list > MAXLINES then foot = foot .. "　|cff9a9282（滾輪看更多）|r" end
  end
  frame.foot:SetText(foot)
  frame.foot:ClearAllPoints()
  frame.foot:SetPoint("TOPLEFT", 14, -(TOP + n * ROW_H + 10))
  local fh = frame.foot.GetStringHeight and frame.foot:GetStringHeight()
  frame:SetHeight(TOP + n * ROW_H + 24 + ((type(fh) == "number" and fh > 0) and fh or 16))
  autoFit()
end

autoFit = function()
  local x = 0
  for c, col in ipairs(COLS) do
    local w = col[3] -- 最小寬度
    w = math.max(w, measure(frame.headFs[c]) + 4)
    for i = 1, MAXLINES do
      local l = frame.lines[i]
      if l.row then w = math.max(w, measure(l.c[c]) + 4) end
    end
    w = math.ceil(w)
    local function place(obj, parent)
      obj:ClearAllPoints(); obj:SetPoint("LEFT", parent, "LEFT", x, 0); obj:SetWidth(w)
    end
    place(frame.headFs[c], frame.head)
    if frame.headBtns[c] then place(frame.headBtns[c], frame.head) end
    for i = 1, MAXLINES do place(frame.lines[i].c[c], frame.lines[i]) end
    x = x + w + GAP
  end
  local total = math.max(x - GAP, 360)
  frame.head:SetWidth(total)
  for i = 1, MAXLINES do frame.lines[i]:SetWidth(total) end
  frame.info:SetWidth(total)
  local footW = measure(frame.foot)
  frame.foot:SetWidth(math.max(total, footW + 4))
  frame:SetWidth(math.max(total, footW + 4) + 28)
end

function HealHPS_Refresh() safe("比較表", refreshImpl) end

-- 設定裡的滑桿：label 右邊接一條滑桿；沒有 OptionsSliderTemplate 就自己畫軌道
local function slider(holder, label, min, max, step, value, set)
  local ok, sl = pcall(CreateFrame, "Slider", nil, holder, "OptionsSliderTemplate")
  if ok and sl then
    for _, k in ipairs({ "Low", "High", "Text" }) do if type(sl[k]) == "table" and sl[k].SetText then sl[k]:SetText("") end end
  else
    sl = CreateFrame("Slider", nil, holder)
    sl:SetOrientation("HORIZONTAL")
    local track = sl:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(.35, .29, .15, 1); track:SetPoint("LEFT"); track:SetPoint("RIGHT"); track:SetHeight(4)
    sl:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  end
  sl:SetPoint("LEFT", label, "RIGHT", 12, 0); sl:SetPoint("RIGHT", holder, "RIGHT", -6, 0); sl:SetHeight(16)
  sl:SetMinMaxValues(min, max); sl:SetValueStep(step)
  if sl.SetObeyStepsOnDrag then sl:SetObeyStepsOnDrag(true) end
  sl:SetValue(value)
  local last = value
  sl:SetScript("OnValueChanged", function(_, v)
    v = math.floor(v / step + 0.5) * step
    if v ~= last then last = v; set(v); HealHPS_Refresh() end
  end)
  return sl
end

local function buildFrame()
  frame = CreateFrame("Frame", "HealHPSFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(W + 28, 300); frame:SetPoint("CENTER"); frame:SetScale(db.scale or 1)
  addResizeGrip(frame)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetFrameStrata("DIALOG")
  tinsert(UISpecialFrames, "HealHPSFrame") -- 按 Esc 關閉
  if not frame.TitleText then
    frame.TitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.TitleText:SetPoint("TOP", 0, -5)
  end
  frame.TitleText:SetText("阿聖治療幫手")
  local logo = frame:CreateTexture(nil, "OVERLAY"); logo:SetTexture(LOGO); logo:SetSize(18, 18); logo:SetPoint("TOPLEFT", 6, -3)
  -- 第一列：單補／群補、設定
  frame.singleBtn = button(frame, 52, "單補", function() db.mode = "single"; offset = 0; HealHPS_Refresh() end)
  frame.singleBtn:SetPoint("TOPLEFT", 12, -30)
  frame.groupBtn = button(frame, 52, "群補", function() db.mode = "group"; offset = 0; HealHPS_Refresh() end)
  frame.groupBtn:SetPoint("LEFT", frame.singleBtn, "RIGHT", 2, 0)
  frame.cdModeBtn = button(frame, 52, "冷卻", function() db.mode = "cd"; offset = 0; HealHPS_Refresh() end)
  frame.cdModeBtn:SetPoint("LEFT", frame.groupBtn, "RIGHT", 2, 0)
  frame.anaBtn = button(frame, 52, "分析", function() db.mode = "analysis"; frame.anaKey = nil; HealHPS_Refresh() end)
  frame.anaBtn:SetPoint("LEFT", frame.cdModeBtn, "RIGHT", 2, 0)
  frame.gearBtn = button(frame, 52, "設定", function() if frame.opts:IsShown() then frame.opts:Hide() else frame.opts:Show() end end)
  frame.gearBtn:SetPoint("TOPRIGHT", -12, -30)
  -- 資訊列：等級與治療效果；天賦加成滑鼠移上去才顯示
  frame.info = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  frame.info:SetPoint("TOPLEFT", 14, -66); frame.info:SetWidth(W); frame.info:SetJustifyH("LEFT"); frame.info:SetWordWrap(false)
  local infoHit = CreateFrame("Frame", nil, frame); infoHit:SetAllPoints(frame.info); infoHit:EnableMouse(true)
  infoHit:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("天賦加成")
    GameTooltip:AddLine(frame.talTxt ~= "" and frame.talTxt or "沒有偵測到治療加成天賦", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  infoHit:SetScript("OnLeave", function() GameTooltip:Hide() end)
  -- 設定：平常收起來
  frame.opts = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  frame.opts:SetSize(290, 150); frame.opts:SetPoint("TOPRIGHT", frame.gearBtn, "BOTTOMRIGHT", 0, -2)
  frame.opts:SetFrameLevel(frame:GetFrameLevel() + 20)
  if frame.opts.SetBackdrop then
    frame.opts:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    frame.opts:SetBackdropColor(.08, .07, .05, .97); frame.opts:SetBackdropBorderColor(.35, .29, .15, 1)
  end
  local how = frame.opts:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  how:SetPoint("TOPLEFT", 12, -10); how:SetWidth(266); how:SetJustifyH("LEFT"); how:SetSpacing(3)
  how:SetText("HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r")
  frame.how = how
  -- 群補人數：滑桿 2–10（群補技能還受技能本身的人數上限；持續治療受持續時間與公共冷卻限制）
  frame.tgtBtn = CreateFrame("Frame", nil, frame.opts)
  frame.tgtBtn:SetSize(250, 26)
  frame.tgtLabel = frame.tgtBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.tgtLabel:SetPoint("LEFT", 4, 0)
  frame.tgtSlider = slider(frame.tgtBtn, frame.tgtLabel, 2, 10, 1, db.targets or 5, function(v) db.targets = v end)
  frame.tipBtn = button(frame.opts, 250, "", function()
    -- 完整 → 標準 → 精簡 → 關 → 完整
    if not db.tip then db.tip, db.tipLevel = true, 3 elseif db.tipLevel <= 1 then db.tip = false else db.tipLevel = db.tipLevel - 1 end
    HealHPS_Refresh()
  end)
  frame.tipBtn:SetHeight(26); frame.tipBtn:SetPoint("TOP", frame.tgtBtn, "BOTTOM", 0, -4)
  frame.oathBtn = button(frame.opts, 250, "", function() db.oath = not db.oath; HealHPS_Refresh() end)
  frame.oathBtn:SetHeight(26); frame.oathBtn:SetPoint("TOP", frame.tipBtn, "BOTTOM", 0, -4)
  frame.oathBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    local sit = SIT[select(2, UnitClass("player"))]
    GameTooltip:AddLine(sit and sit.label or "")
    GameTooltip:AddLine(frame.sitHelp or "", 1, 1, 1, true)
    GameTooltip:Show()
  end)
  frame.oathBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  frame.opts:Hide()
  -- 表頭（點 有效量／HPS／HPM 排序）
  local head = CreateFrame("Frame", nil, frame); head:SetSize(W, 22); head:SetPoint("TOPLEFT", 14, -(TOP - 26))
  frame.head, frame.headFs, frame.headBtns = head, {}, {}
  local line = head:CreateTexture(nil, "ARTWORK"); line:SetColorTexture(1, 1, 1, .12); line:SetHeight(1)
  line:SetPoint("BOTTOMLEFT", head, "BOTTOMLEFT", 0, -1); line:SetPoint("BOTTOMRIGHT", head, "BOTTOMRIGHT", 0, -1)
  frame.heads = {}
  for _, col in ipairs(COLS) do
    local fs = cell(head, col); fs:SetText(col[1]); fs:SetTextColor(unpack(DIM))
    frame.headFs[#frame.headFs + 1] = fs
    if col[5] then
      local b = CreateFrame("Button", nil, head)
      b:SetPoint("LEFT", head, "LEFT", col[2], 0); b:SetSize(col[3], 18)
      frame.headBtns[#frame.headFs] = b
      b:SetScript("OnClick", function() db.sort = col[5]; offset = 0; HealHPS_Refresh() end)
      table.insert(frame.heads, { fs = fs, key = col[5], label = col[1] })
    end
  end
  -- 內容列
  frame.lines = {}
  for i = 1, MAXLINES do
    local l = CreateFrame("Frame", nil, frame)
    l:SetSize(W, ROW_H); l:SetPoint("TOPLEFT", 14, -TOP - (i - 1) * ROW_H)
    l.hl = l:CreateTexture(nil, "BORDER"); l.hl:SetAllPoints(); l.hl:Hide()
    if i % 2 == 0 then local bg = l:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(1, 1, 1, .035) end
    l.c = {}
    for c, col in ipairs(COLS) do l.c[c] = cell(l, col) end
    l:EnableMouse(true)
    l:SetScript("OnEnter", function(self)
      local r = self.row; if not r then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine(r.label .. " 等級" .. r.rank)
      local detail = breakdown(r)
      if detail and db.tipLevel >= 2 then GameTooltip:AddLine(detail, .8, .8, .8, true) end
      if r.f.kind == "absorb" and db.tipLevel >= 2 then GameTooltip:AddLine("吸收量不是治療量，不參加 HPS／HPM 最高的比較", .55, .75, 1, true) end
      if db.tipLevel < 3 then GameTooltip:Show(); return end
      GameTooltip:AddDoubleLine("學習等級", tostring(r.learn), .8, .8, .8, 1, 1, 1)
      if r.down < 0.9995 then GameTooltip:AddDoubleLine("降級", string.format("治療效果只算 %d%%", math.floor(r.down * 100 + .5)), .8, .8, .8, 1, .6, .3) end
      if r.cd > 0 then GameTooltip:AddDoubleLine("冷卻", fmt1(r.cd) .. " 秒", .8, .8, .8, 1, 1, 1) end
      if r.oathAdd and r.oathAdd > 0 then
        local sit = SIT[select(2, UnitClass("player"))]
        GameTooltip:AddDoubleLine(sit and sit.label or "", "+" .. fint(r.oathAdd) .. (r.oathRatio and string.format("（%d%%）", math.floor(r.oathRatio * 100 + .5)) or ""), .8, .8, .8, 1, 1, 1)
      end
      if r.srcText ~= "遊戲" then GameTooltip:AddLine("部分數值來自資料表（遊戲讀不到）", 1, .6, .3) end
      if r.f.note ~= "" then GameTooltip:AddLine(r.f.note, .6, .6, .6, true) end
      GameTooltip:Show()
    end)
    l:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.lines[i] = l
  end
  frame:EnableMouseWheel(true)
  frame:SetScript("OnMouseWheel", function(_, delta)
    if db.mode == "analysis" then frame.anaOff = math.max(0, (frame.anaOff or 0) - delta * 3)
    else offset = math.max(0, offset - delta * 3) end
    HealHPS_Refresh()
  end)
  frame.foot = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.foot:SetWidth(W); frame.foot:SetJustifyH("LEFT"); frame.foot:SetWordWrap(false)
  -- 分析頁：預設組合、四條滑桿、結論、排名（只在「分析」顯示）
  frame.ana = CreateFrame("Frame", nil, frame)
  frame.ana:SetPoint("TOPLEFT", 14, -ANA_TOP); frame.ana:SetSize(W, 200)
  local PRESETS = { { "小怪", 3000, 250, 1.5, 45 }, { "王戰", 5000, 450, 2, 180 }, { "單練", nil, 120, 2, 60 }, { "省水", 3000, 120, 2, 60 } }
  local prev
  frame.anaPresetW = 0
  for _, p in ipairs(PRESETS) do
    local b = button(frame.ana, 40, p[1], function()
      local hpMax = p[2]
      if not hpMax then -- 單練：坦克就是自己
        local ok, v = pcall(UnitHealthMax, "player")
        hpMax = (ok and not (issecretvalue and issecretvalue(v)) and type(v) == "number") and v or db.anaHp
        hpMax = math.max(500, math.min(20000, math.floor(hpMax / 100 + 0.5) * 100))
      end
      db.anaHp, db.anaHit, db.anaGap, db.fight = hpMax, p[3], p[4], p[5]
      HealHPS_Refresh()
    end)
    if prev then b:SetPoint("LEFT", prev, "RIGHT", 2, 0) else b:SetPoint("TOPLEFT", frame.ana, "TOPLEFT", 0, 0) end
    frame.anaPresetW = frame.anaPresetW + b:GetWidth() + 2
    prev = b
  end
  frame.anaDetailBtn = button(frame.ana, 40, "詳細", function() db.anaDetail = not db.anaDetail; frame.anaOff = 0; HealHPS_Refresh() end)
  frame.anaDetailBtn:SetPoint("LEFT", prev, "RIGHT", 12, 0)
  frame.anaPresetW = frame.anaPresetW + frame.anaDetailBtn:GetWidth() + 12
  -- { 設定鍵, 文字, 最小, 最大, 間隔, 最長的值（量寬度用） }
  local INPUTS = { { "anaHp", "坦克生命 %d", 500, 20000, 100, 20000 }, { "anaHit", "每次傷害 %d", 50, 5000, 10, 5000 },
    { "anaGap", "受傷間隔 %.1f 秒", 0.5, 5, 0.5, 5 }, { "fight", "戰鬥長度 %d 秒", 30, 600, 10, 600 } }
  frame.anaInputs = {}
  local labelW = 0
  for i, v in ipairs(INPUTS) do
    local holder = CreateFrame("Frame", nil, frame.ana)
    holder:SetSize(340, 26); holder:SetPoint("TOPLEFT", 0, -(30 + (i - 1) * 28))
    local fs = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("LEFT", 4, 0); fs:SetJustifyH("LEFT"); fs:SetWordWrap(false)
    fs:SetText(string.format(v[2], v[6]))
    labelW = math.max(labelW, measure(fs))
    local sl = slider(holder, fs, v[3], v[4], v[5], db[v[1]], function(x) db[v[1]] = x end)
    frame.anaInputs[i] = { def = v, fs = fs, sl = sl, holder = holder }
  end
  -- 四個標籤同寬（用最長的值量），數字變長時滑桿不會跟著跳
  for _, inp in ipairs(frame.anaInputs) do inp.fs:SetWidth(math.ceil(labelW) + 4); inp.holder:SetWidth(math.ceil(labelW) + 200) end
  local concTop = 30 + #INPUTS * 28 + 6
  frame.anaConc = frame.ana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.anaConc:SetPoint("TOPLEFT", 0, -concTop); frame.anaConc:SetJustifyH("LEFT"); frame.anaConc:SetWordWrap(false)
  frame.anaListTop = concTop + 26
  frame.anaLines = {}
  for i = 1, 8 do
    local l = CreateFrame("Frame", nil, frame.ana)
    l:SetSize(W, ROW_H); l:SetPoint("TOPLEFT", 0, -(frame.anaListTop + (i - 1) * ROW_H))
    l.hl = l:CreateTexture(nil, "BORDER"); l.hl:SetAllPoints(); l.hl:Hide()
    if i % 2 == 0 then local bg = l:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(1, 1, 1, .035) end
    l.c = {}
    for c = 1, 7 do
      local fs = l:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      fs:SetJustifyH((c == 2 or c == 3 or c == 7) and "LEFT" or "RIGHT"); fs:SetWordWrap(false)
      l.c[c] = fs
    end
    l:EnableMouse(true)
    l:SetScript("OnEnter", function(self)
      local r = self.res; if not r then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine(r.name)
      local total = r.healed + r.over
      GameTooltip:AddDoubleLine("補到", fint(r.healed), .8, .8, .8, 1, 1, 1)
      GameTooltip:AddDoubleLine("溢補", string.format("%d%%", total > 0 and math.floor(r.over / total * 100 + 0.5) or 0), .8, .8, .8, 1, 1, 1)
      GameTooltip:AddDoubleLine("施法", r.casts .. " 次" .. ((r.hCasts > 0 or r.combo) and ("（" .. (r.hCasts > 0 and ("HoT " .. r.hCasts) or "") .. (r.hCasts > 0 and r.combo and "、" or "") .. (r.combo and ("救命 " .. r.eCasts) or "") .. "）") or ""), .8, .8, .8, 1, 1, 1)
      if not r.dead then
        GameTooltip:AddDoubleLine("戰鬥結束", string.format("坦克 %d%%、剩藍 %s", math.floor(r.endPct + 0.5), fint(r.rawMana)), .8, .8, .8, 1, 1, 1)
      end
      if r.pulls then
        GameTooltip:AddDoubleLine("不喝水連打", r.pulls == math.huge and "不用喝水" or r.pulls < 1 and "打完要喝水" or (r.pulls .. " 波"), .8, .8, .8, 1, 1, 1)
      end
      GameTooltip:Show()
    end)
    l:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.anaLines[i] = l
  end
  frame.ana:Hide()
  frame:SetScript("OnShow", function() frame.anaKey = nil; HealHPS_Refresh() end)
  frame:Hide()
end

local function toggleWindow()
  if not frame then buildFrame() end
  if frame:IsShown() then frame:Hide() else frame:Show() end
end

-- ── 小地圖按鈕 ─────────────────────────────────────────────────────────────
local mmBtn
local function placeMinimap()
  local a = math.rad(db.minimapAngle or 225)
  local r = (Minimap:GetWidth() / 2) + 5
  mmBtn:ClearAllPoints()
  mmBtn:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
end
local function buildMinimapButton()
  if mmBtn or not Minimap then return end
  local b = CreateFrame("Button", "HealHPSMinimapButton", Minimap)
  mmBtn = b
  b:SetSize(31, 31); b:SetFrameStrata("MEDIUM"); b:SetFrameLevel(8)
  b:RegisterForClicks("LeftButtonUp", "RightButtonUp"); b:RegisterForDrag("LeftButton")
  b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local bg = b:CreateTexture(nil, "BACKGROUND"); bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  bg:SetSize(20, 20); bg:SetPoint("TOPLEFT", 7, -5)
  local icon = b:CreateTexture(nil, "ARTWORK"); icon:SetTexture(LOGO); icon:SetTexCoord(0.1, 0.9, 0.1, 0.9); icon:SetSize(21, 21); icon:SetPoint("TOPLEFT", 6, -5)
  local border = b:CreateTexture(nil, "OVERLAY"); border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(53, 53); border:SetPoint("TOPLEFT")
  b:SetScript("OnClick", function(_, btn)
    if btn == "RightButton" then
      db.tip = not db.tip; msg("技能提示的 HPS：" .. (db.tip and "開" or "關"))
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
    GameTooltip:AddLine("阿聖治療幫手")
    GameTooltip:AddLine("左鍵：開關比較表", 1, 1, 1)
    GameTooltip:AddLine("右鍵：開關技能提示的 HPS（目前" .. (db.tip and "開" or "關") .. "）", 1, 1, 1)
    GameTooltip:AddLine("拖曳：沿著小地圖移動", .6, .6, .6)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  placeMinimap()
  if db.minimapHide then b:Hide() end
end

-- ── 指令 ───────────────────────────────────────────────────────────────────
local function debugDump()
  local _, class = UnitClass("player")
  local book = API.Spellbook()
  msg(string.format("版本 0.8.7　API：%s　法術書共 %d 個技能", (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines) and "新版 C_SpellBook" or "舊版", #book))
  rescan()
  local _, ctx = compute()
  msg(string.format("職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s", class, ctx.level, ctx.bonus, ctx.descIncl and "已含治療效果" or "基礎量",
    (#ctx.talents.found > 0 and table.concat(ctx.talents.found, "、") or "沒找到") .. "（" .. ctx.talents.source .. "）"))
  local o = ctx.talents.oath
  if o then
    msg(o.unknown and ("聖光誓約：讀不到加成量。天賦說明：" .. tostring(ctx.talents.oathDesc))
      or string.format("聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）", o.hl, o.fol, o.hs, db.oath and "比較表已計入" or "比較表未計入"))
  end
  if #ctx.talents.learned > 0 then msg("已點天賦：" .. table.concat(ctx.talents.learned, "、")) end
  local sit = SIT[class]
  if sit and class ~= "PALADIN" then
    local has = ctx.talents.sitLearned or (class == "SHAMAN" and ctx.ripKnown)
    msg(sit.label .. "：" .. (has and ("有" .. (db.oath and "（比較表已計入）" or "（比較表未計入）")) or "沒偵測到"))
  end
  local keys, anyFound = {}, false
  for k, st in pairs(scan.families) do table.insert(keys, k); if st.maxRank > 0 then anyFound = true end end
  table.sort(keys)
  if not anyFound then
    local names = {}
    for i = 1, math.min(15, #book) do names[i] = book[i].name .. (book[i].sub and book[i].sub ~= "" and ("(" .. book[i].sub .. ")") or "") end
    msg("一個治療技能都沒對上。法術書前幾個技能：" .. table.concat(names, "、"))
  end
  for _, k in ipairs(keys) do
    local st = scan.families[k]
    if st.maxRank == 0 then msg(string.format("%s：法術書沒找到", st.f.label))
    else
      local nId = 0
      for r = 1, st.maxRank do if st.known[r] then nId = nId + 1 end end
      local top = st.known[st.maxRank]
      local d = getDesc(top)
      local a, b, h = parseDesc(st.f.parse, d)
      msg(string.format("%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s", st.f.label, st.gameName or "?", st.maxRank, nId,
        not st.f.parse and "不解析" or a and (a .. "–" .. b .. (h and (" HoT " .. h) or "")) or ("失敗：" .. (d and d:sub(1, 80) or "說明未載入"))))
    end
  end
end

SLASH_HEALHPS1 = "/shps"
SLASH_HEALHPS2 = "/hps" -- 舊指令保留
SlashCmdList.HEALHPS = function(input)
  ensureDB()
  local cmd, arg = (input or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
  if not isHealerClass() and cmd ~= "debug" then
    msg("這個職業沒有治療技能，插件不會運作。")
    return
  end
  if cmd == "" then
    toggleWindow()
  elseif cmd == "minimap" then
    db.minimapHide = not db.minimapHide
    if mmBtn then if db.minimapHide then mmBtn:Hide() else mmBtn:Show() end end
    msg("小地圖按鈕：" .. (db.minimapHide and "隱藏（再輸入 /shps minimap 顯示）" or "顯示"))
  elseif cmd == "pct" then
    db.pct = arg ~= "auto" and tonumber(arg) or nil
    msg("治療加成 %：" .. (db.pct and db.pct .. "（手動）" or "依天賦自動"))
  elseif cmd == "absorb" then
    db.absorb = arg ~= "auto" and tonumber(arg) or nil
    msg("吸收加成 %：" .. (db.absorb and db.absorb .. "（手動）" or "依天賦自動"))
  elseif cmd == "targets" then
    db.targets = math.max(2, math.min(10, tonumber(arg) or 5)); msg("群補目標數：" .. db.targets)
  elseif cmd == "tip" then
    db.tip = not db.tip; msg("滑鼠提示：" .. (db.tip and "開" or "關"))
  elseif cmd == "downrank" then
    db.downrank = not db.downrank; msg("降級衰減：" .. (db.downrank and "開" or "關"))
  elseif cmd == "scale" then
    local v = tonumber((input or ""):match("scale%s+([%d%.]+)"))
    if v and v >= 0.5 and v <= 2 then db.scale = v; if frame then frame:SetScale(v) end; msg("視窗縮放：" .. v)
    else msg("用法：/shps scale 1.2（0.5～2，目前 " .. (db.scale or 1) .. "）") end
  elseif cmd == "desc" then
    db.desc = (arg == "incl" or arg == "base") and arg or "auto"
    msg("技能說明數字：" .. (db.desc == "incl" and "已含治療效果（手動）" or db.desc == "base" and "只有基礎量（手動）" or "自動判斷")
      .. "　目前：" .. (descIncludesBonus() and "直接採用說明數字" or "基礎＋治療效果×係數"))
  elseif cmd == "debug" then
    safe("除錯指令", debugDump)
  elseif cmd == "reset" then
    HealHPSCharDB = CopyTable(DEFAULTS); db = HealHPSCharDB; msg("設定已重設")
  else
    msg("/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps debug　/shps reset")
  end
  if frame then HealHPS_Refresh() end
end

-- ── 事件 ───────────────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
local RESCAN_EVENTS = { SPELLS_CHANGED = true, LEARNED_SPELL_IN_TAB = true, LEARNED_SPELL_IN_SKILL_LINE = true,
  PLAYER_LEVEL_UP = true, CHARACTER_POINTS_CHANGED = true, PLAYER_TALENT_UPDATE = true }
ev:SetScript("OnEvent", function(_, e, a1)
  if e == "ADDON_LOADED" and a1 == ADDON then
    ensureDB()
  elseif e == "PLAYER_LOGIN" then
    ensureDB()
    if not db.scaleV then if db.scale == 1 then db.scale = 1.25 end; db.scaleV = 1 end -- 舊預設值改成新的預設大小（只遷移一次，之後尊重玩家設定）
    if isHealerClass() then
      safe("掛上滑鼠提示", hookTooltips)
      safe("小地圖按鈕", buildMinimapButton)
    end
  elseif RESCAN_EVENTS[e] then
    scan.dirty = true; scan.unmatchedRetry = 0
    if frame and frame:IsShown() then HealHPS_Refresh() end
  elseif e == "PLAYER_EQUIPMENT_CHANGED" then
    if frame and frame:IsShown() then HealHPS_Refresh() end
  end
end)
-- 不同版本的遊戲事件名稱不一樣；註冊不存在的事件會出錯，所以逐一試、失敗就跳過
for _, e in ipairs({ "ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_EQUIPMENT_CHANGED" }) do pcall(ev.RegisterEvent, ev, e) end
for e in pairs(RESCAN_EVENTS) do pcall(ev.RegisterEvent, ev, e) end
