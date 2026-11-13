-- 阿聖治療幫手 ShengHealing（魔獸世界：永恆）
-- 盡量從遊戲讀取：技能與階級（法術書）、法力、施法時間、冷卻、學習等級、基礎治療量（技能說明）、治療效果、天賦。
-- 遊戲讀不到的欄位才用 Data.lua（由網頁資料產生）。治療係數遊戲不會顯示，一律用資料表。

local ADDON = ...
local D = HealHPS_Data
local DEFAULTS = { mode = "single", tipLevel = 3, fight = 180, anaHp = 3000, anaHit = 300, anaGap = 2, rate = "cast", sort = "hps", targets = 5, downrank = true, tip = true,
  includeCd = false, pct = nil, absorb = nil, minimapAngle = 225, minimapHide = false, oath = false, scale = 1.25, anaDetail = false,
  -- 團刷分析：人數、成員／坦克生命、坦克每次傷害與間隔、範圍每次傷害與間隔、範圍命中（0＝全員）、戰鬥長度
  anaGroup = false, gN = 5, gHp = 3200, gTankHp = 5500, gTankHit = 400, gTankGap = 2, gAoe = 150, gAoeGap = 3, gAoeK = 0, gFight = 45 }
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
-- 玩家職業：限制啟動時 UnitClass 可能回傳秘密值（不能當表格鍵、不能比較），讀到一次正常值就記住（職業不會變）
local myClass
local function playerClass()
  if not myClass then
    local _, c = UnitClass("player")
    if not (issecretvalue and issecretvalue(c)) and type(c) == "string" then myClass = c end
  end
  return myClass
end
local function isHealerClass() return HEALER_CLASSES[playerClass()] == true end

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
  local class = playerClass()
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
  -- 戰鬥中治療效果、精神、回藍等是秘密值，拿來比較會報錯（還會讓介面功能被擋）：直接沿用戰鬥前算好的結果
  if InCombatLockdown and InCombatLockdown() and scan.rows and scan.ctx then return scan.rows, scan.ctx end
  if scan.dirty then rescan() end
  -- 讀到秘密值（或讀不到）就用上一次的數字
  local old = scan.ctx or {}
  local function num(v, prev)
    if type(v) ~= "number" or (issecretvalue and issecretvalue(v)) then return prev or 0 end
    return v
  end
  local class = playerClass() or old.class
  local ctx = { level = num(UnitLevel("player"), old.level), bonus = num(GetSpellBonusHealing and GetSpellBonusHealing(), old.bonus) }
  ctx.descIncl = descIncludesBonus()
  ctx.class = class
  ctx.spirit = num(UnitStat and select(2, UnitStat("player", 5)), old.spirit)
  -- 每秒回藍：遊戲已把精神、MP5、施法中保留回藍的天賦都算好；idle＝停手滿 5 秒後，active＝施法中（5 秒內）
  local okR, idle, active = pcall(GetManaRegen)
  ctx.regenIdle, ctx.regenActive = num(okR and idle, old.regenIdle), num(okR and active, old.regenActive)
  ctx.maxMana = num(UnitPowerMax and UnitPowerMax("player", 0), old.maxMana)
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
local DT = 0.1
-- 單坦、團刷共用：戰鬥中或讀不到回藍（屬性被鎖住）時回傳錯誤文字
local function anaEnv()
  if InCombatLockdown and InCombatLockdown() then return nil, "戰鬥中不分析" end
  local secret = issecretvalue or function() return false end
  local okR, regenI, regenA = pcall(GetManaRegen)
  local okM, maxMana = pcall(UnitPowerMax, "player", 0)
  if not okR or not okM or secret(regenI) or secret(regenA) or secret(maxMana)
    or type(regenI) ~= "number" or type(regenA) ~= "number" or type(maxMana) ~= "number" or maxMana <= 0 then
    return nil, "讀不到回藍"
  end
  local okC, crit = pcall(GetSpellCritChance, 2) -- 2＝神聖系；回傳百分比
  crit = (okC and not secret(crit) and type(crit) == "number") and crit / 100 or 0
  return { regenI = regenI, regenA = regenA, maxMana = maxMana, critMul = 1 + crit * 0.5 }
end

local function analyze()
  local env, err = anaEnv()
  if not env then return { err = err } end
  local rows = compute()
  local regenI, regenA, maxMana, critMul = env.regenI, env.regenA, env.maxMana, env.critMul
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
      -- 主力＋救命：「聖光閃現 1（救命 3）」；救命是別招就寫全名
      local save = emerg ~= main and ("（救命 " .. (emerg.r.label == main.r.label and tostring(emerg.r.rank) or nm(emerg, " ")) .. "）") or ""
      name = nm(main, " ") .. save .. tag
      long = nm(main, " 等級") .. (emerg ~= main and ("，坦克快倒時改放 " .. nm(emerg, " 等級")) or "") .. tag
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

-- ── 團刷分析：一隊人一起挨打，比較各職業的群補輪替 ─────────────────────────
-- 跟單坦共用：0.1 秒一步、五秒規則連續回藍、爆擊期望值（HoT 每跳也算）、HoT 每 3 秒一跳、戰鬥結束沒跳完的 HoT 按比例退藍。
-- 成員 1＝坦克、2＝自己（補師，也會挨範圍傷害），每 5 人一個小隊，坦克和自己在第 1 隊。坦克或自己倒下就算滅團、提前結束。
-- 遊戲還沒實測的假設集中在這裡，實測後改這裡：
local GA = {
  -- 野性痊癒每秒一跳共 7 跳的權重（總和 1）。暴雪只確認逐跳遞減，序列未公布：
  -- 先借用 3.3.5 的線性遞減（第 1 跳 +42%、每跳少 14%，平均不變），遊戲內實測後再換
  WG_W = { 1.42 / 7, 1.28 / 7, 1.14 / 7, 1 / 7, 0.86 / 7, 0.72 / 7, 0.58 / 7 },
  WG_EVERY = 10,         -- 野性痊癒每 1 秒一跳（步數）
  WG_MIN = 3,            -- 野性痊癒：同一小隊至少 3 人缺到整段的量才放
  POM_N = 5,             -- 癒合禱言最多 5 次治療：持有者挨打（或受直接治療）時補他一次，再跳給缺血最多的其他人（假設距離都夠；30 秒期限不計；持有者倒下就消失）
  CH = { 1, 0.5, 0.25 }, -- 治療鍊三個目標 100%／50%／25%，跳給缺血最多的其他人（可跨小隊、不跳滿血）
  RIPT_CH = 1.25,        -- 第一目標身上有自己的激流：治療鍊第一跳 +25%（只加第一跳、不消耗激流）
  TQ_N = 5, TQ_EVERY = 20, -- 寧靜：引導 10 秒鎖住施法，每 2 秒一跳共 5 跳，只補自己小隊
  TQ_LOW = 0.4,          -- 寧靜只救命用：自己小隊 ≥3 人低於 40% 才放（單補來不及補 3 個人）
  VIGIL_MIN = 3,         -- 聖光戒備：同一小隊至少 3 人缺到門檻才標記
  LOW = 0.3,             -- 「低血」：血量低於 30% 的人秒
  -- 以下不是遊戲數值，是模擬的規則
  SINGLE_CAP = 0.5,      -- 單補門檻（缺血 ≥ 爆擊量）最多到該成員最大生命的 50%，不然血少的人永遠等不到門檻、只能靠救命
  SEED = 12345.0,        -- 隨機點名用固定種子，每種補法挨的打完全一樣（寫成小數：整數運算的 Lua 會溢位）
}

local function analyzeGroup()
  local env, err = anaEnv()
  if not env then return { err = err, group = true } end
  local rows, ctx = compute()
  local critMul, maxMana, regenI, regenA = env.critMul, env.maxMana, env.regenI, env.regenA
  local function st(x) return math.floor(x / DT + 0.5) end
  local TICK, steps, N = st(3), st(db.gFight), db.gN
  local maxHp, party = {}, {}
  for i = 1, N do maxHp[i] = i == 1 and db.gTankHp or db.gHp; party[i] = math.floor((i - 1) / 5) + 1 end
  local nParty = math.floor((N + 4) / 5)
  local tHit, aHit, K = db.gTankHit, db.gAoe, math.min(db.gAoeK, N)
  local tg = tHit > 0 and math.max(1, st(db.gTankGap)) or 0
  local ag = aHit > 0 and math.max(1, st(db.gAoeGap)) or 0
  -- 傷害時間表先排好，所有補法共用（點名：每次從全隊隨機挑 K 個不同的人）
  local evS, evM, evA, nEv = {}, {}, {}, 0
  do
    local seed, idx = GA.SEED, {}
    for i = 1, N do idx[i] = i end
    local function push(s, m, a) nEv = nEv + 1; evS[nEv], evM[nEv], evA[nEv] = s, m, a end
    for s = 1, steps do
      if tg > 0 and s % tg == 0 then push(s, 1, tHit) end
      if ag > 0 and s % ag == 0 then
        if K == 0 then for i = 1, N do push(s, i, aHit) end
        else
          for j = 1, K do
            seed = (seed * 16807) % 2147483647
            local r = j + seed % (N - j + 1)
            idx[j], idx[r] = idx[r], idx[j]
            push(s, idx[j], aHit)
          end
        end
      end
    end
  end
  -- 到第 s 步為止的累計傷害（先算好查表）：P＝看得到的（坦克的固定傷害、全員範圍），E＝救命用（隨機點名當作每個人都可能被點）
  -- s 步之後到 e 步為止會挨的打＝表[e]－表[s]；表多算 60 秒，HoT 的預估視窗超過戰鬥結束也查得到
  local PT, PM, ET, EM = {}, {}, {}, {}
  for s = 0, steps + st(60) do
    local t = tg > 0 and math.floor(s / tg) * tHit or 0
    local a = ag > 0 and math.floor(s / ag) * aHit or 0
    PM[s] = K == 0 and a or 0
    PT[s], ET[s], EM[s] = t + PM[s], t + a, a
  end
  local pArr, eArr = {}, {}
  for i = 1, N do pArr[i], eArr[i] = i == 1 and PT or PM, i == 1 and ET or EM end
  local function predictE(i, s, e) local E = eArr[i]; return E[e] - E[s] end

  local function mk(r, kind)
    local cast = st(r.f.kind == "channel" and math.max(r.cast, r.dur or 0) or r.cast)
    local sp = { r = r, kind = kind, key = r.key, mana = r.mana, cast = cast, busy = math.max(cast, st(r.f.gcd)), cd = st(r.cd or 0),
      H = r.perHeal - (r.withOath and r.oathAdd or 0) } -- H＝每人一般治療量（不含爆擊；情境加成不計）
    if kind == "hot" then
      local d = math.max(1, st(r.dur or 0))
      sp.n, sp.every = math.max(1, math.floor(d / TICK)), math.min(TICK, d)
      sp.full, sp.win = sp.H * critMul, cast + d
    elseif kind == "wg" then sp.win = cast + #GA.WG_W * GA.WG_EVERY end
    return sp
  end
  -- 單補：主力＝HPM 最高、救命＝HPS 最高（直接治療，不含 HoT、群補、冷卻、吸收盾）
  local singles, fam = {}, {}
  for _, r in ipairs(rows) do
    local f = r.f
    if not f.group and not r.isCd and f.kind ~= "absorb" and f.kind ~= "hot" and r.perHeal > 0 then singles[#singles + 1] = r end
    fam[r.key] = fam[r.key] or {}; table.insert(fam[r.key], r)
  end
  if #singles == 0 then return { list = {}, group = true } end
  local mR, eR = singles[1], singles[1]
  for _, r in ipairs(singles) do
    if r.hpm > mR.hpm then mR = r end
    if r.hps > eR.hps then eR = r end
  end
  local M = mk(mR, "single")
  local E = eR == mR and M or mk(eR, "single")
  local function hiOf(k)
    local h
    for _, r in ipairs(fam[k] or {}) do if not h or r.perHeal > h.perHeal then h = r end end
    return h
  end
  -- 群補技能試最高階和 HPM 最高的那階
  local function two(k)
    local h, b
    for _, r in ipairs(fam[k] or {}) do
      if not h or r.perHeal > h.perHeal then h = r end
      if not b or r.hpmT > b.hpmT then b = r end
    end
    return not h and {} or h == b and { h } or { h, b }
  end
  local HS -- 聖光戒備標記後接的神聖震擊（最高階；不觸發震擊冷卻）
  do
    local h = hiOf("hs")
    if h then HS = { kind = "shock", mana = h.mana, cast = 0, busy = st(h.f.gcd), cd = 0, H = h.perHeal - (h.withOath and h.oathAdd or 0) } end
  end

  local function run(rot)
    local M = rot.main or M -- 只單補的對照組可以換填充招
    local G, HT, PM, WG, TQ = rot.group, rot.hot, rot.pom, rot.wg, rot.tranq
    local hp, alive, hN, hNext, hPer, wK, wNext, wTot, wShare, dang = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
    for i = 1, N do
      hp[i], alive[i], hN[i], hNext[i], hPer[i] = maxHp[i], true, 0, 0, 0
      wK[i], wNext[i], wTot[i], wShare[i], dang[i] = 0, 0, 0, 0, 0
    end
    local mana, last, casting, castEnd, busyUntil, tgt, p, s = maxMana, -1e9, nil, 0, 0, 0, 1, 0
    local pomHolder, pomLeft, pomTrig, mark, tqLeft, tqNext = 0, 0, false, 0, 0, 0
    local deaths, first, wiped, minPct, lowSteps, healed, over, casts, oom = 0, 0, 0, 1, 0, 0, 0, 0, 0
    local cnt = { group = 0, single = 0, emerg = 0, hot = 0, pom = 0, wg = 0, tranq = 0 }
    local ready = {}
    local function heal(i, a)
      if not alive[i] then return end
      local e = math.min(a, maxHp[i] - hp[i])
      hp[i], healed, over = hp[i] + e, healed + e, over + a - e
    end
    local function healD(i, a) -- 直接治療：補到癒合禱言的持有者會觸發
      heal(i, a)
      if i == pomHolder and alive[i] then pomTrig = true end
    end
    -- i 身上的 HoT 在 e 步（含）以前還會跳的量
    local function pend(i, e)
      local sum = 0
      if hN[i] > 0 and e >= hNext[i] then sum = sum + hPer[i] * math.min(hN[i], math.floor((e - hNext[i]) / HT.every) + 1) end
      if wK[i] > 0 and e >= wNext[i] then
        for k = wK[i], math.min(#GA.WG_W, wK[i] + math.floor((e - wNext[i]) / GA.WG_EVERY)) do sum = sum + wTot[i] * GA.WG_W[k] end
      end
      return sum
    end
    -- 有效缺血＝缺的血－補到前會跳的 HoT＋施法期間看得到的傷害
    local function eff(i, c) local P = pArr[i]; return maxHp[i] - hp[i] - pend(i, s + c) + (P[s + c] - P[s]) end
    -- 缺血最多的活人（排除 a、b）；full＝滿血的也可以
    local function most(a, b, full)
      local best, bv = 0, -1
      for i = 1, N do
        if alive[i] and i ~= a and i ~= b then
          local v = maxHp[i] - hp[i]
          if v > bv and (full or v > 0) then best, bv = i, v end
        end
      end
      return best
    end
    local function pomFire()
      pomTrig = false
      if pomLeft <= 0 then return end
      if not alive[pomHolder] then pomLeft, pomHolder = 0, 0; return end
      heal(pomHolder, PM.H * critMul); pomLeft = pomLeft - 1
      pomHolder = pomLeft > 0 and most(pomHolder, 0, true) or 0
      if pomHolder == 0 then pomLeft = 0 end
    end
    local function start(sp, t, tag)
      casting, tgt, castEnd, busyUntil, casts = sp, t, s + sp.cast, s + sp.busy, casts + 1
      cnt[tag] = cnt[tag] + 1
      if sp.cd > 0 then ready[sp] = s + sp.cd end
      if sp == TQ then mana, last, tqLeft, tqNext = mana - sp.mana, s, GA.TQ_N, s + GA.TQ_EVERY end -- 引導：開始就扣藍
    end
    local function rdy(sp) return s >= (ready[sp] or 0) end
    -- 小隊群補：合格（有效缺血 ≥ H）人數最多的小隊；need＝固定人數，否則該隊活人的 60%（無條件進位，至少 2 人）
    local function bestParty(c, H, need)
      local bp, bc = 0, 0
      for q = 1, nParty do
        local m, n = 0, 0
        for i = (q - 1) * 5 + 1, math.min(N, q * 5) do
          if alive[i] then m = m + 1; if eff(i, c) >= H then n = n + 1 end end
        end
        if n >= (need or math.max(2, math.floor((3 * m + 4) / 5))) and n > bc then bp, bc = q, n end
      end
      return bp
    end
    local function mostIn(q, c)
      local b, bv = 0, -1e18
      for i = (q - 1) * 5 + 1, math.min(N, q * 5) do
        if alive[i] then local v = eff(i, c); if v > bv then b, bv = i, v end end
      end
      return b
    end
    -- 治療鍊第一目標：缺 ≥ H（有激流的目標缺 ≥ 1.25H 優先），還要另一人缺 ≥ 0.5H
    local function chFirst()
      local H, t1, bv = G.H, 0, -1e18
      if HT and HT.key == "ript" then
        for i = 1, N do
          if alive[i] and hN[i] > 0 then local v = eff(i, G.cast); if v >= H * GA.RIPT_CH and v > bv then t1, bv = i, v end end
        end
      end
      if t1 == 0 then
        for i = 1, N do
          if alive[i] then local v = eff(i, G.cast); if v >= H and v > bv then t1, bv = i, v end end
        end
      end
      if t1 == 0 then return 0 end
      for i = 1, N do if alive[i] and i ~= t1 and eff(i, G.cast) >= H * GA.CH[2] then return t1 end end
      return 0
    end
    -- 能出手時決定放什麼：救命 → 保持的 HoT／冷卻技能 → 群補門檻 → 單補 → 等
    local function decide()
      local want = false
      if mark > 0 then -- 聖光戒備標記好了：接神聖震擊
        if not alive[mark] then mark = 0
        elseif mana >= HS.mana then start(HS, mark, "group"); return
        else want = true end
      end
      -- (a) 救命：照「現在放主力、接著放救命」的時間，期間挨的打（點名當作誰都可能被點）≥ 目前血量＋這段時間 HoT 會跳的量
      local W = M.busy + E.cast
      local nD, worst, wv = 0, 0, 1e18
      for i = 1, N do
        dang[i] = 0
        if alive[i] then
          local v = hp[i] + pend(i, s + W) - predictE(i, s, s + W)
          if v <= 0 then dang[i] = 1; nD = nD + 1; if v < wv then worst, wv = i, v end end
        end
      end
      if TQ and rdy(TQ) then
        local c = 0
        for i = 1, math.min(N, 5) do if alive[i] and hp[i] < maxHp[i] * GA.TQ_LOW then c = c + 1 end end
        if c >= 3 then
          if mana >= TQ.mana then start(TQ, 1, "tranq"); return end
          want = true
        end
      end
      if nD > 0 then
        -- 2 人以上危險，而且群補落地前他們都還活著、蓋得到 ≥2 人 → 放群補
        if nD >= 2 and G and not (G.kind == "mark" and mark > 0) then
          local t = 0
          if G.kind == "ch" then
            local c, b, bv = 0, 0, 1e18
            for i = 1, N do
              if dang[i] == 1 then
                local v = hp[i] + pend(i, s + G.cast) - predictE(i, s, s + G.cast)
                if v > 0 then c = c + 1; if v < bv then b, bv = i, v end end
              end
            end
            if c >= 2 then t = b end
          else
            local bc = 0
            for q = 1, nParty do
              local c, b, bv = 0, 0, 1e18
              for i = (q - 1) * 5 + 1, math.min(N, q * 5) do
                if dang[i] == 1 then
                  local v = hp[i] + pend(i, s + G.cast) - predictE(i, s, s + G.cast)
                  if v > 0 then c = c + 1; if v < bv then b, bv = i, v end end
                end
              end
              if c >= 2 and c > bc then bc, t = c, G.kind == "mark" and b or q end
            end
          end
          if t > 0 then
            if mana >= G.mana + (G.kind == "mark" and HS.mana or 0) then start(G, t, "group"); return end
            want = true
          end
        end
        -- 單補救最危險的人；救命技能藍不夠就用主力
        if mana >= E.mana then start(E, worst, E == M and "single" or "emerg")
        elseif mana >= M.mana then start(M, worst, "single")
        elseif oom == 0 then oom = s end
        return
      end
      -- (b) 保持的 HoT、冷卻技能
      if PM and pomLeft == 0 and rdy(PM) then -- 癒合禱言：冷卻好就放，有坦克傷害就給坦克
        local t = (alive[1] and tg > 0) and 1 or most(0, 0, true)
        if t > 0 then
          if mana >= PM.mana then start(PM, t, "pom"); return end
          want = true
        end
      end
      if HT and rdy(HT) then -- 單體 HoT：沒有這個 HoT、缺的血＋持續時間內看得到的傷害 ≥ 整段期望量（激流只給坦克）
        local b, bv = 0, -1e18
        for i = 1, rot.hotTank and 1 or N do
          if alive[i] and hN[i] == 0 then local v = eff(i, HT.win); if v >= HT.full and v > bv then b, bv = i, v end end
        end
        if b > 0 then
          if mana >= HT.mana then start(HT, b, "hot"); return end
          want = true
        end
      end
      if WG and rdy(WG) then
        local q = bestParty(WG.win, WG.H, GA.WG_MIN)
        if q > 0 then
          if mana >= WG.mana then start(WG, q, "wg"); return end
          want = true
        end
      end
      -- (c) 群補門檻（一般治療量，不算爆擊）
      if G and not (G.kind == "mark" and mark > 0) and rdy(G) then
        local t
        if G.kind == "ch" then t = chFirst()
        else
          local q = bestParty(G.cast, G.H, G.kind == "mark" and GA.VIGIL_MIN or nil)
          t = (q > 0 and G.kind == "mark") and mostIn(q, G.cast) or q
        end
        if t > 0 then
          if mana >= G.mana + (G.kind == "mark" and HS.mana or 0) then start(G, t, "group"); return end
          want = true
        end
      end
      -- (d) 單補有效缺血最多的人：缺 ≥ 主力的爆擊量（最多到他最大生命的 50%）
      local b, bv = 0, -1e18
      for i = 1, N do
        if alive[i] then
          local v = eff(i, M.cast)
          if v >= math.min(M.H * 1.5, maxHp[i] * GA.SINGLE_CAP) and v > bv then b, bv = i, v end
        end
      end
      if b > 0 then
        if mana >= M.mana then start(M, b, "single"); return end
        want = true
      end
      if want and oom == 0 then oom = s end
    end
    -- 施法完成：扣藍（引導開始時已扣）、落地
    local function complete()
      local sp = casting
      casting = nil
      if sp ~= TQ then mana, last = mana - sp.mana, s end
      local k = sp.kind
      if k == "single" then healD(tgt, sp.H * critMul)
      elseif k == "poh" then
        for i = (tgt - 1) * 5 + 1, math.min(N, tgt * 5) do if alive[i] then healD(i, sp.H * critMul) end end
      elseif k == "ch" then
        local t1 = alive[tgt] and tgt or most(0, 0, false)
        if t1 > 0 then
          healD(t1, sp.H * ((HT and HT.key == "ript" and hN[t1] > 0) and GA.RIPT_CH or 1) * critMul)
          local t2 = most(t1, 0, false)
          if t2 > 0 then
            healD(t2, sp.H * GA.CH[2] * critMul)
            local t3 = most(t1, t2, false)
            if t3 > 0 then healD(t3, sp.H * GA.CH[3] * critMul) end
          end
        end
      elseif k == "mark" then mark = alive[tgt] and tgt or 0
      elseif k == "shock" then -- 震擊補被標記的人，再觸發他整個小隊的戒備治療
        local q = party[mark]
        healD(mark, sp.H * critMul)
        for i = (q - 1) * 5 + 1, math.min(N, q * 5) do if alive[i] then healD(i, G.H * critMul) end end
        mark = 0
      elseif k == "hot" then
        if alive[tgt] then hN[tgt], hNext[tgt], hPer[tgt] = sp.n, s + sp.every, sp.H / sp.n * critMul end
      elseif k == "wg" then
        local c = 0
        for i = (tgt - 1) * 5 + 1, math.min(N, tgt * 5) do if alive[i] then c = c + 1 end end
        for i = (tgt - 1) * 5 + 1, math.min(N, tgt * 5) do
          if alive[i] then wK[i], wNext[i], wTot[i], wShare[i] = 1, s + GA.WG_EVERY, sp.H * critMul, sp.mana / c end
        end
      elseif k == "pom" then pomHolder, pomLeft = tgt, GA.POM_N end
      if pomTrig then pomFire() end
    end

    while s < steps do
      s = s + 1
      while p <= nEv and evS[p] == s do
        local i, a = evM[p], evA[p]
        p = p + 1
        if alive[i] then
          hp[i] = hp[i] - a
          if i == pomHolder then pomTrig = true end
          if hp[i] / maxHp[i] < minPct then minPct = math.max(0, hp[i] / maxHp[i]) end
          if hp[i] <= 0 then
            alive[i], deaths, hN[i], wK[i] = false, deaths + 1, 0, 0
            if first == 0 then first = s end
            if i <= 2 then wiped = s end
          end
        end
      end
      if wiped > 0 then break end
      if pomTrig then pomFire() end
      mana = math.min(maxMana, mana + (s - last >= 5 / DT and regenI or regenA) * DT)
      if not casting and s >= busyUntil then decide() end
      if casting and s >= castEnd then complete() end
      for i = 1, N do
        if hN[i] > 0 and s >= hNext[i] then heal(i, hPer[i]); hN[i], hNext[i] = hN[i] - 1, hNext[i] + HT.every end
        if wK[i] > 0 and s >= wNext[i] then
          heal(i, wTot[i] * GA.WG_W[wK[i]])
          wK[i] = wK[i] + 1
          if wK[i] > #GA.WG_W then wK[i] = 0 else wNext[i] = wNext[i] + GA.WG_EVERY end
        end
      end
      if tqLeft > 0 and s >= tqNext then
        for i = 1, math.min(N, 5) do if alive[i] then heal(i, TQ.H / GA.TQ_N * critMul) end end
        tqLeft, tqNext = tqLeft - 1, tqNext + GA.TQ_EVERY
      end
      for i = 1, N do if alive[i] and hp[i] < maxHp[i] * GA.LOW then lowSteps = lowSteps + 1 end end
    end
    -- 剩藍：沒跳完的 HoT 按比例退藍，再虛擬補滿所有人：≥3 人各缺 ≥ 群補量就算一發群補，其餘照主力單補的藍／補量算
    local topped = mana
    if wiped == 0 then
      local refund = tqLeft > 0 and TQ.mana * tqLeft / GA.TQ_N or 0
      for i = 1, N do
        if alive[i] then
          if hN[i] > 0 then refund = refund + HT.mana * hN[i] / HT.n end
          if wK[i] > 0 then for k = wK[i], #GA.WG_W do refund = refund + wShare[i] * GA.WG_W[k] end end
          dang[i] = maxHp[i] - hp[i]
        else dang[i] = 0 end
      end
      local cost, TU = 0, G or WG
      if TU then
        local H, c = TU.H * critMul, 0
        for i = 1, N do if dang[i] >= H then c = c + 1 end end
        if c >= 3 then
          cost = TU.mana + (TU.kind == "mark" and HS.mana or 0)
          local j, lim = 0, TU.kind == "ch" and 3 or 5
          for i = 1, N do
            if dang[i] >= H and j < lim then
              j = j + 1
              dang[i] = math.max(0, dang[i] - H * (TU.kind == "ch" and GA.CH[j] or 1))
            end
          end
        end
      end
      local rest = 0
      for i = 1, N do rest = rest + dang[i] end
      topped = math.min(maxMana, mana + refund) - cost - rest * M.mana / (M.H * critMul)
    end
    local net = maxMana - topped
    return { group = true, name = rot.name, deaths = deaths, dead = deaths > 0 and first * DT or nil, wiped = wiped > 0 and wiped * DT or nil,
      effDeaths = wiped > 0 and N or deaths, minPct = minPct * 100, lowSec = lowSteps * DT, healed = healed, over = over,
      mana = topped, rawMana = mana, casts = casts, cnt = cnt, oom = oom > 0 and oom * DT or nil, M = M, E = E,
      every = casts > 0 and (wiped > 0 and wiped or steps) * DT / casts or nil,
      pulls = deaths == 0 and (net < 1 and math.huge or math.floor(maxMana / net)) or nil }
  end

  -- 各職業的輪替（沒學會的技能就跳過）；need＝這個輪替特有的技能，一次都沒放就跟別的一樣、不列
  local function nm(r) return r.label .. " " .. r.rank end
  local rots = {}
  local function add(name, rot, need) rot.name, rot.need = name, need; rots[#rots + 1] = rot end
  local cls = ctx.class
  if cls == "PRIEST" then
    local rn, pm = hiOf("renew"), hiOf("pom")
    for _, g in ipairs(two("poh")) do
      local G = mk(g, "poh")
      add(nm(g), { group = G })
      if rn then add("鋪" .. nm(rn) .. "＋" .. nm(g), { group = G, hot = mk(rn, "hot") }, "hot") end
      if pm then add(nm(pm) .. "＋" .. nm(g), { group = G, pom = mk(pm, "pom") }, "pom") end
    end
  elseif cls == "DRUID" then
    for _, h in ipairs(two("rejuv")) do add("鋪" .. nm(h), { hot = mk(h, "hot") }, "hot") end
    local rj, tq = hiOf("rejuv"), hiOf("tranq")
    if rj then
      for _, w in ipairs(two("wg")) do
        add(nm(w) .. "＋" .. nm(rj), { wg = mk(w, "wg"), hot = mk(rj, "hot") }, "wg")
        if tq then add(nm(w) .. "＋" .. nm(rj) .. "＋" .. nm(tq), { wg = mk(w, "wg"), hot = mk(rj, "hot"), tranq = mk(tq, "tranq") }, "tranq") end
      end
    end
  elseif cls == "SHAMAN" then
    local rp = hiOf("ript")
    for _, c in ipairs(two("ch")) do
      local G = mk(c, "ch")
      add(nm(c), { group = G })
      if rp then add("保持" .. nm(rp) .. "＋" .. nm(c), { group = G, hot = mk(rp, "hot"), hotTank = true }, "hot") end
    end
  elseif cls == "PALADIN" and HS then
    for _, v in ipairs(two("vigil")) do add(nm(v), { group = mk(v, "mark") }) end
  end
  if cls == "SHAMAN" or cls == "PALADIN" or #rots == 0 then -- 只單補（對照組）：填充招試最省藍和最快的那招
    add(nm(M.r) .. (E ~= M and ("（救命 " .. (E.r.label == M.r.label and tostring(E.r.rank) or nm(E.r)) .. "）") or ""), {})
    if E ~= M then add(nm(E.r), { main = E }) end
  end

  local list = {}
  for _, rot in ipairs(rots) do
    local res = run(rot)
    local keep = not rot.need or res.cnt[rot.need] > 0
    for _, x in ipairs(list) do
      if keep and x.casts == res.casts and x.mana == res.mana and x.minPct == res.minPct and x.deaths == res.deaths then keep = false end
    end
    if keep then table.insert(list, res) end
  end
  -- 沒人倒下的排前面：剩藍多 → 最低血量高 → 低血人秒少；有人倒下：倒得少（滅團算全倒）→ 第一個人倒得晚
  table.sort(list, function(a, b)
    if (a.deaths == 0) ~= (b.deaths == 0) then return a.deaths == 0 end
    if a.deaths == 0 then
      if a.mana ~= b.mana then return a.mana > b.mana end
      if a.minPct ~= b.minPct then return a.minPct > b.minPct end
      return a.lowSec < b.lowSec
    end
    if a.effDeaths ~= b.effDeaths then return a.effDeaths < b.effDeaths end
    if a.dead ~= b.dead then return a.dead > b.dead end
    if (a.wiped or 1e9) ~= (b.wiped or 1e9) then return (a.wiped or 1e9) > (b.wiped or 1e9) end
    return a.lowSec < b.lowSec
  end)
  return { list = list, group = true }
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
    local sit = SIT[playerClass()]
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
      if tt == GameTooltip and data and not (issecretvalue and issecretvalue(data.id)) then safe("滑鼠提示", addTooltip, tt, data.id) end
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
  local cls = playerClass()
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
  -- 精神與回藍（每 5 秒，跟角色面板一樣）：停手 5 秒後／施法中；讀不到（秘密值）就不顯示
  local secret = issecretvalue or function() return false end
  local info = string.format("%d 級 · 治療效果 %d", ctx.level, ctx.bonus)
  if type(ctx.spirit) == "number" and not secret(ctx.spirit) then info = info .. string.format(" · 精神 %d", ctx.spirit) end
  local okR, idle, active = pcall(GetManaRegen)
  if okR and type(idle) == "number" and type(active) == "number" and not secret(idle) and not secret(active) then
    info = info .. string.format(" · 回藍 停手 %d／施法 %d（每 5 秒）", math.floor(idle * 5 + .5), math.floor(active * 5 + .5))
  end
  frame.info:SetText(info)
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
    local g = db.anaGroup and true or false
    for _, m in ipairs(frame.anaModeBtns) do
      local on = m.on == g
      m.b:GetFontString():SetTextColor(on and 1 or .55, on and .82 or .52, on and 0 or .45)
    end
    local set = g and frame.anaSets.group or frame.anaSets.single
    for _, row in pairs(frame.anaSets) do for _, b in ipairs(row) do b:SetShown(row == set) end end
    frame.anaDetailBtn:ClearAllPoints(); frame.anaDetailBtn:SetPoint("LEFT", set[#set], "RIGHT", 12, 0)
    frame.anaOathBtn:SetShown(cls == "PALADIN" and not g)
    local presetW = frame.anaModeW + set.w + 12 + frame.anaDetailBtn:GetWidth() + (frame.anaOathBtn:IsShown() and frame.anaOathBtn:GetWidth() + 2 or 0)
    local inputs = g and frame.anaGInputs or frame.anaInputs
    for _, s2 in ipairs({ frame.anaInputs, frame.anaGInputs }) do for _, inp in ipairs(s2) do inp.holder:SetShown(s2 == inputs) end end
    for _, inp in ipairs(inputs) do
      local d, v = inp.def, db[inp.def[1]]
      inp.fs:SetText(v == 0 and d[7] or string.format(d[2], v))
      if inp.sl:GetValue() ~= v then inp.sl:SetValue(v) end
    end
    local concTop = 30 + inputs.rows * 28 + 6
    frame.anaConc:ClearAllPoints(); frame.anaConc:SetPoint("TOPLEFT", 0, -concTop)
    frame.anaListTop = concTop + 26
    for i, l in ipairs(frame.anaLines) do l:ClearAllPoints(); l:SetPoint("TOPLEFT", 0, -(frame.anaListTop + (i - 1) * ROW_H)) end
    local inCombat = InCombatLockdown and InCombatLockdown()
    if inCombat then frame.anaKey = nil -- 脫戰後再開會重算
    else
      -- 輸入改了才重算；拖滑桿時等 0.2 秒沒再動才算
      local key = g and table.concat({ "g", db.gN, db.gHp, db.gTankHp, db.gTankHit, db.gTankGap, db.gAoe, db.gAoeGap, db.gAoeK, db.gFight }, ",")
        or table.concat({ db.anaHp, db.anaHit, db.anaGap, db.fight, tostring(db.oath) }, ",")
      if frame.anaKey ~= key then
        frame.anaKey = key
        local token = {}
        frame.anaToken = token
        local function go()
          if frame.anaToken ~= token or db.mode ~= "analysis" or not frame:IsShown() then return end
          safe("分析", function() frame.anaRes = db.anaGroup and analyzeGroup() or analyze() end)
          HealHPS_Refresh()
        end
        if C_Timer and C_Timer.After then C_Timer.After(0.2, go) else go() end
      end
    end
    frame.anaDetailBtn:GetFontString():SetTextColor(db.anaDetail and 1 or .55, db.anaDetail and .82 or .52, db.anaDetail and 0 or .45)
    frame.anaOathBtn:GetFontString():SetTextColor(db.oath and 1 or .55, db.oath and .82 or .52, db.oath and 0 or .45)
    local res = frame.anaRes
    if res and (res.group or false) ~= g then res = nil end -- 剛切換模式、還沒算完：不顯示另一個模式的結果
    local list = res and res.list or {}
    -- 結論：活下來的分「最省藍」「最穩定」各前 2 名（都倒下就列「撐最久」前 2 名）；詳細：全部照排名，滾輪捲動
    local alive = {}
    for _, r in ipairs(list) do if not r.dead then table.insert(alive, r) end end
    local byMana, byMin = {}, {}
    for i, r in ipairs(alive) do byMana[i], byMin[i] = r, r end
    table.sort(byMana, function(a, b) if a.mana ~= b.mana then return a.mana > b.mana end return a.minPct > b.minPct end)
    table.sort(byMin, function(a, b)
      if a.minPct ~= b.minPct then return a.minPct > b.minPct end
      if (a.lowSec or 0) ~= (b.lowSec or 0) then return (a.lowSec or 0) < (b.lowSec or 0) end -- 團刷：再比低血人秒
      return a.mana > b.mana
    end)
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
    local conc = inCombat and "戰鬥中不分析" or (res and res.err) or (res and not best and (g and "沒有可以補的技能" or "沒有可以單補的技能"))
      or (byMana[1] and string.format("|cffffd100最省藍：|r%s；|cffffd100最穩定：|r%s", byMana[1].name, byMin[1].name))
      or (best and best.group and string.format("|cffff6b6b都撐不住：|r最好 %s（%s）", best.name,
        best.wiped and string.format("%d 秒滅團", math.floor(best.wiped + 0.5)) or string.format("倒 %d 人", best.deaths)))
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
        local fate = not r.dead and "活" or not r.group and string.format("倒下 %d 秒", math.floor(r.dead + 0.5))
          or r.wiped and string.format("滅團 %d 秒", math.floor(r.wiped + 0.5)) or string.format("倒 %d 人 %d 秒", r.deaths, math.floor(r.dead + 0.5))
        local vals = { e.no .. ".", r.name, fate,
          -- 倒下且沒藍：寫幾秒沒藍；活下來但補滿坦克還不夠：寫差多少；其餘寫剩多少
          (r.dead and r.oom) and string.format("沒藍 %d 秒", math.floor(r.oom + 0.5))
            or r.mana < 0 and ("補滿差 " .. fint(-r.mana)) or ("剩藍 " .. fint(r.mana)),
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
    local total = math.ceil(math.max(x - GAP, inputs.w, presetW, measure(frame.anaConc) + 4, measure(frame.info) + 4, 360))
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
  local total = math.max(x - GAP, measure(frame.info) + 4, 360) -- 資訊列（精神、回藍）也要放得下
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
    local sit = SIT[playerClass()]
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
        local sit = SIT[playerClass()]
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
  -- 單坦／團刷切換，接著是該模式的預設組合、詳細（聖騎在單坦多一個聖光誓約）
  frame.anaModeBtns, frame.anaModeW = {}, 0
  local prev
  for i, m in ipairs({ { "單坦", false }, { "團刷", true } }) do
    local b = button(frame.ana, 40, m[1], function() db.anaGroup = m[2]; frame.anaOff = 0; HealHPS_Refresh() end)
    if prev then b:SetPoint("LEFT", prev, "RIGHT", 2, 0) else b:SetPoint("TOPLEFT", frame.ana, "TOPLEFT", 0, 0) end
    frame.anaModeBtns[i] = { b = b, on = m[2] }
    frame.anaModeW = frame.anaModeW + b:GetWidth() + 2
    prev = b
  end
  local modeLast = prev
  local function presetRow(list, apply)
    local row, last = { w = 0 }, modeLast
    for _, p in ipairs(list) do
      local b = button(frame.ana, 40, p[1], function() apply(p); HealHPS_Refresh() end)
      b:SetPoint("LEFT", last, "RIGHT", last == modeLast and 12 or 2, 0)
      row.w = row.w + b:GetWidth() + (last == modeLast and 12 or 2)
      row[#row + 1], last = b, b
    end
    return row
  end
  frame.anaSets = {
    -- 預設情境依角色等級 L 換算（估計值：同等級副本坦克與菁英怪的大概數字；60 級時接近一般五人本）
    --   坦克生命 ≈ 1.2L²＋35L、隊員生命 ≈ 0.7L²＋25L、菁英怪每下 ≈ 4.5L、首領每下 ≈ 7L、野外普通怪每下 ≈ 2.2L
    -- p[2] 是情境代號，數值在套用時才算，所以升級後再點一次就會跟著變
    single = presetRow({ { "小怪", "trash" }, { "王戰", "boss" }, { "單練", "solo" }, { "省水", "easy" } }, function(p)
      local L = UnitLevel("player") or 60
      local tank = math.floor((1.2 * L * L + 35 * L) / 100 + 0.5) * 100
      local hp, hit, gap, fight
      if p[2] == "trash" then hp, hit, gap, fight = tank, 4.5 * L, 1, 30 -- 兩隻菁英怪同時打坦克
      elseif p[2] == "boss" then hp, hit, gap, fight = tank, 7 * L, 2, 90
      elseif p[2] == "easy" then hp, hit, gap, fight = tank, 4.5 * L, 2, 30 -- 一隻菁英怪
      else -- 單練：坦克就是自己，野外普通怪
        local ok, v = pcall(UnitHealthMax, "player")
        hp = (ok and not (issecretvalue and issecretvalue(v)) and type(v) == "number") and v or tank
        hit, gap, fight = 2.2 * L, 2, 30
      end
      db.anaHp = math.max(500, math.min(20000, math.floor(hp / 100 + 0.5) * 100))
      db.anaHit = math.max(50, math.floor(hit / 10 + 0.5) * 10)
      db.anaGap, db.fight = gap, fight
    end),
    group = presetRow({ { "群怪", "trash" }, { "全團技", "boss" }, { "範圍", "aoe" }, { "點名", "pick" } }, function(p)
      local L = UnitLevel("player") or 60
      local r10 = function(v) return math.max(10, math.floor(v / 10 + 0.5) * 10) end
      local tank = math.floor((1.2 * L * L + 35 * L) / 100 + 0.5) * 100
      local member = math.floor((0.7 * L * L + 25 * L) / 100 + 0.5) * 100
      -- { 範圍每次傷害, 範圍間隔, 範圍命中（0＝全員）, 坦克每次傷害, 坦克間隔, 戰鬥長度 }
      local v = ({ trash = { 2.5 * L, 3, 0, 4.5 * L, 1.5, 45 }, boss = { 9 * L, 20, 0, 5 * L, 2, 90 },
        aoe = { 1.8 * L, 2, 0, 0, 2, 60 }, pick = { 10 * L, 5, 1, 5 * L, 2, 60 } })[p[2]]
      db.gN, db.gHp, db.gTankHp = 5, math.max(500, member), math.max(500, tank)
      db.gAoe, db.gAoeGap, db.gAoeK = r10(v[1]), v[2], v[3]
      db.gTankHit, db.gTankGap, db.gFight = v[4] > 0 and r10(v[4]) or 0, v[5], v[6]
    end),
  }
  frame.anaDetailBtn = button(frame.ana, 40, "詳細", function() db.anaDetail = not db.anaDetail; frame.anaOff = 0; HealHPS_Refresh() end)
  -- 聖騎：坦克就是誓約目標時，分析要不要算聖光誓約的加成（和設定裡的同一個開關）
  frame.anaOathBtn = button(frame.ana, 70, "聖光誓約", function() db.oath = not db.oath; HealHPS_Refresh() end)
  frame.anaOathBtn:SetPoint("LEFT", frame.anaDetailBtn, "RIGHT", 2, 0)
  -- 滑桿組：cols 欄，同一欄的標籤同寬（用最長的值量），數字變長時滑桿不會跟著跳
  -- { 設定鍵, 文字, 最小, 最大, 間隔, 最長的值（量寬度用）, 值為 0 時的文字 }
  local function inputSet(defs, cols, sliderW)
    local set, colW = {}, {}
    for i, v in ipairs(defs) do
      local holder = CreateFrame("Frame", nil, frame.ana)
      holder:SetSize(340, 26)
      local fs = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      fs:SetPoint("LEFT", 4, 0); fs:SetJustifyH("LEFT"); fs:SetWordWrap(false)
      local c = (i - 1) % cols + 1
      fs:SetText(string.format(v[2], v[6]))
      local w = measure(fs)
      if v[7] then fs:SetText(v[7]); w = math.max(w, measure(fs)) end
      colW[c] = math.max(colW[c] or 0, w)
      local sl = slider(holder, fs, v[3], v[4], v[5], db[v[1]], function(x) db[v[1]] = x end)
      set[i] = { def = v, fs = fs, sl = sl, holder = holder, col = c, row = math.floor((i - 1) / cols) }
    end
    local x, xs = 0, {}
    for c = 1, cols do xs[c] = x; x = x + math.ceil(colW[c]) + 4 + sliderW + GAP end
    for _, inp in ipairs(set) do
      local lw = math.ceil(colW[inp.col]) + 4
      inp.fs:SetWidth(lw); inp.holder:SetWidth(lw + sliderW)
      inp.holder:SetPoint("TOPLEFT", xs[inp.col], -(30 + inp.row * 28))
    end
    set.w, set.rows = x - GAP, math.ceil(#defs / cols)
    return set
  end
  frame.anaInputs = inputSet({ { "anaHp", "坦克生命 %d", 500, 20000, 100, 20000 }, { "anaHit", "每次傷害 %d", 50, 5000, 10, 5000 },
    { "anaGap", "受傷間隔 %.1f 秒", 0.5, 5, 0.5, 5 }, { "fight", "戰鬥長度 %d 秒", 30, 600, 10, 600 } }, 1, 196)
  frame.anaGInputs = inputSet({ { "gN", "人數 %d", 2, 10, 1, 10 }, { "gFight", "戰鬥長度 %d 秒", 30, 600, 10, 600 },
    { "gHp", "成員生命 %d", 500, 20000, 100, 20000 }, { "gTankHp", "坦克生命 %d", 500, 30000, 100, 30000 },
    { "gTankHit", "坦克每次傷害 %d", 0, 5000, 10, 5000, "坦克每次傷害 無" }, { "gTankGap", "坦克間隔 %.1f 秒", 0.5, 5, 0.5, 5 },
    { "gAoe", "範圍每次傷害 %d", 0, 5000, 10, 5000, "範圍每次傷害 無" }, { "gAoeGap", "範圍間隔 %.1f 秒", 1, 30, 0.5, 30 },
    { "gAoeK", "範圍命中 隨機 %d 人", 0, 5, 1, 5, "範圍命中 全員" } }, 2, 150)
  frame.anaConc = frame.ana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.anaConc:SetJustifyH("LEFT"); frame.anaConc:SetWordWrap(false)
  frame.anaLines = {}
  for i = 1, 8 do
    local l = CreateFrame("Frame", nil, frame.ana)
    l:SetSize(W, ROW_H) -- 位置在重整時依輸入列數決定
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
      if r.group then
        local parts = {}
        for _, c in ipairs({ { "group", "群補" }, { "pom", "癒合禱言" }, { "hot", "HoT" }, { "wg", "野性痊癒" }, { "tranq", "寧靜" }, { "single", "單補" }, { "emerg", "救命" } }) do
          if r.cnt[c[1]] > 0 then parts[#parts + 1] = c[2] .. " " .. r.cnt[c[1]] end
        end
        GameTooltip:AddDoubleLine("施法", r.casts .. " 次" .. (#parts > 0 and ("（" .. table.concat(parts, "、") .. "）") or ""), .8, .8, .8, 1, 1, 1)
        GameTooltip:AddDoubleLine("單補", r.M.r.label .. " 等級" .. r.M.r.rank .. (r.E ~= r.M and ("、救命 " .. r.E.r.label .. " 等級" .. r.E.r.rank) or ""), .8, .8, .8, 1, 1, 1)
        if r.dead then
          GameTooltip:AddDoubleLine("倒下", string.format("%d 人，第一人 %d 秒", r.deaths, math.floor(r.dead + 0.5)) .. (r.wiped and "，坦克或自己倒下" or ""), .8, .8, .8, 1, .42, .42)
        end
        GameTooltip:AddDoubleLine("低於 30%", string.format("%d 人秒", math.floor(r.lowSec + 0.5)), .8, .8, .8, 1, 1, 1)
        if not r.wiped then GameTooltip:AddDoubleLine("戰鬥結束", "剩藍 " .. fint(r.rawMana), .8, .8, .8, 1, 1, 1) end
        if r.pulls then
          GameTooltip:AddDoubleLine("不喝水連打", r.pulls == math.huge and "不用喝水" or r.pulls < 1 and "打完要喝水" or (r.pulls .. " 波"), .8, .8, .8, 1, 1, 1)
        end
        GameTooltip:Show()
        return
      end
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
  b.icon, b.Icon = icon, icon -- 小地圖按鈕收納插件會找這個欄位當圖示
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
  local class = playerClass()
  local book = API.Spellbook()
  msg(string.format("版本 0.8.7　API：%s　法術書共 %d 個技能", (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines) and "新版 C_SpellBook" or "舊版", #book))
  rescan()
  local _, ctx = compute()
  msg(string.format("職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s", tostring(class), ctx.level, ctx.bonus, ctx.descIncl and "已含治療效果" or "基礎量",
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
