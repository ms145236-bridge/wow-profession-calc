-- 治療 HPS 計算器（魔獸世界：永恆）
-- 盡量從遊戲讀取：技能與階級（法術書）、法力、施法時間、冷卻、學習等級、基礎治療量（技能說明）、治療效果、天賦。
-- 遊戲讀不到的欄位才用 Data.lua（由網頁資料產生）。治療係數遊戲不會顯示，一律用資料表。

local ADDON = ...
local D = HealHPS_Data
local DEFAULTS = { mode = "single", rate = "cast", sort = "hps", targets = 5, downrank = true, tip = true,
  includeCd = false, pct = nil, absorb = nil }
local db
-- 設定：每個角色一份。任何地方用到前都先確保已經建立（不依賴事件順序）
-- 技能說明的數字是否已經含治療效果：永恆（新版引擎）實測會含；經典版不含。/hps desc 可手動指定
local function descIncludesBonus()
  local m = HealHPSCharDB and HealHPSCharDB.desc or "auto"
  if m == "incl" then return true elseif m == "base" then return false end
  return (C_Spell and C_Spell.GetSpellDescription) and true or false
end

local function ensureDB()
  if db then return db end
  HealHPSCharDB = HealHPSCharDB or {}
  for k, v in pairs(DEFAULTS) do if HealHPSCharDB[k] == nil then HealHPSCharDB[k] = v end end
  db = HealHPSCharDB
  return db
end

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage("|cffd9b25f治療HPS|r " .. s) end

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
        if name and (not out[name] or rank > out[name].rank) then out[name] = { rank = rank, max = maxR } end
      end
    end
  end
  if seen == 0 then return nil end
  return out
end

local function scanTalents(class)
  local res = { heal = 0, absorb = 0, found = {}, source = "讀不到" }
  local defs = TALENTS[class]
  if not defs then return res end
  for _, def in ipairs(defs) do def.set = def.set or nameSet(def.ids, def.names) end
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
    end
    return res
  end
  if not GetTalentInfo or not GetNumTalents then return res end
  res.source = "經典"
  local tabs = GetNumTalentTabs and GetNumTalentTabs() or 3
  for t = 1, tabs do
    local okN, nTal = pcall(GetNumTalents, t)
    for i = 1, (okN and nTal or 0) do
      local name, _, _, _, rank, maxRank = GetTalentInfo(t, i)
      for _, def in ipairs(defs) do
        if name and def.set[name] then add(def, name, rank, maxRank) end
      end
    end
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
  end
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
  local tal = scanTalents(class)
  ctx.healPct = (db.pct or tal.heal) / 100
  ctx.absorbPct = (db.absorb or tal.absorb) / 100
  ctx.talents = tal
  local targets = math.max(1, math.min(5, db.targets or 5))
  local rows, byId = {}, {}
  local hsMana
  do -- 聖光守望要接一發最高階神聖震擊
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
          if f.parse == "regrowth" then per = per + row.hotBase end
          row.inclDesc = true
        else
          per = (avg + ctx.bonus * row.coeff * row.down) * mult
          if f.parse == "regrowth" then per = per + row.hotBase * mult end -- HoT 係數未公開，不加治療效果
        end
        row.perHeal = per
        local total, used = per, 1
        if f.key == "bh" then total, used = per * 2, 2
        elseif f.group then
          used = math.min(targets, f.maxTargets)
          total = f.groupModel == "chain50" and per * chainFactor(used) or per * used
        end
        row.totalHeal, row.targets = total, used
        local occupy = f.kind == "channel" and math.max(row.cast, row.dur or 0, f.gcd) or math.max(row.cast, f.gcd)
        local manaEff = row.mana
        if f.key == "vigil" and hsMana then manaEff = manaEff + hsMana; occupy = occupy + 1.5 end
        local t = occupy
        if db.rate == "effect" and (f.kind == "hot" or f.kind == "channel") then t = math.max(row.dur or occupy, occupy)
        elseif db.rate == "cooldown" then t = math.max(row.cd > 0 and row.cd or occupy, occupy) end
        row.manaEff, row.time = manaEff, t
        local shown = (f.key == "bh" or (db.mode == "group" and f.group)) and total or per
        row.shown = shown
        row.hps = t > 0 and shown / t or 0
        row.hpm = manaEff > 0 and shown / manaEff or 0
        table.insert(rows, row)
        if row.id then byId[row.id] = byId[row.id] or {}; table.insert(byId[row.id], row) end
      end
    end
  end
  scan.rows, scan.byId, scan.ctx = rows, byId, ctx
  if scan.missingDesc and scan.unmatchedRetry < 3 then
    -- 技能說明還沒載入：稍後再讀一次
    scan.unmatchedRetry = scan.unmatchedRetry + 1
    C_Timer.After(2, function() if HealHPSFrame and HealHPSFrame:IsShown() then HealHPS_Refresh() end end)
  end
  return rows, ctx
end

local RATE_LABEL = { cast = "施法占用", effect = "效果期間", cooldown = "冷卻上限" }
local SORT_LABEL = { hps = "HPS", hpm = "HPM", heal = "有效量" }

local function filterRows(rows, mode)
  local list = {}
  for _, r in ipairs(rows) do
    local f = r.f
    local okMode = (mode == "group") == (f.group and true or false)
    local okCd = db.includeCd or mode == "group" or db.rate == "cooldown" or r.cd <= 0 or f.key == "hs" or f.kind == "absorb"
    if okMode and okCd then table.insert(list, r) end
  end
  local k = db.sort == "heal" and "shown" or db.sort
  table.sort(list, function(a, b) return a[k] > b[k] end)
  return list
end
-- 最佳 HPS、最佳 HPM（在同一類：單補跟單補比、群補跟群補比）
local function bests(list)
  local h, m
  for _, r in ipairs(list) do
    if not h or r.hps > h.hps then h = r end
    if not m or r.hpm > m.hpm then m = r end
  end
  return h, m
end
local function sameRow(a, b) return a and b and a.key == b.key and a.rank == b.rank end
local function filtered()
  local rows, ctx = compute()
  return filterRows(rows, db.mode), ctx
end

-- ── 滑鼠提示 ───────────────────────────────────────────────────────────────
local function addTooltip(tt, id)
  ensureDB()
  if not db.tip or not id then return end
  if scan.dirty or not scan.ctx then compute() end
  local rows = scan.byId[id]
  if not rows then return end
  compute() -- 數值（治療效果、增益）可能改變，重新算
  rows = scan.byId[id]
  if not rows then return end
  tt:AddLine(" ")
  for _, r in ipairs(rows) do
    local f = r.f
    local head = r.f.parse == "regrowth" and "含完整HoT" or (f.kind == "absorb" and "吸收" or "有效治療")
    tt:AddDoubleLine("|cffd9b25f治療HPS|r " .. head, fint(r.perHeal) .. (r.inclDesc and "（技能說明值，已含治療效果）" or (r.bonusPart > 0.5 and string.format("（治療效果 +%s）", fint(r.bonusPart)) or "")), 1, 1, 1, 1, 1, 1)
    if f.group or f.key == "bh" then tt:AddDoubleLine("  總量", string.format("%s（%d 人）", fint(r.totalHeal), r.targets), .8, .8, .8, 1, 1, 1) end
    tt:AddDoubleLine(string.format("  HPS（%s）", RATE_LABEL[db.rate]), string.format("%s　HPM %s", fmt1(r.hps), fmt2(r.hpm)), .8, .8, .8, 1, 1, 1)
    if r.down < 0.9995 then tt:AddLine(string.format("  降級：治療效果只算 %d%%", math.floor(r.down * 100 + 0.5)), 1, .6, .3) end
  end
  local cat = rows[1].f.group and "group" or "single"
  local bh, bm = bests(filterRows(scan.rows, cat))
  local catName = cat == "group" and "群補" or "單補"
  local isH, isM = false, false
  for _, r in ipairs(rows) do
    if sameRow(r, bh) then isH = true end
    if sameRow(r, bm) then isM = true end
  end
  if isH then tt:AddLine("  ★ 目前" .. catName .. "最佳 HPS", 1, .82, 0)
  elseif bh then tt:AddDoubleLine("  " .. catName .. "最佳 HPS", string.format("%s %d（%s）", bh.label, bh.rank, fmt1(bh.hps)), 1, .82, 0, 1, .82, 0) end
  if isM then tt:AddLine("  ★ 目前" .. catName .. "最佳 HPM", .4, 1, .4)
  elseif bm then tt:AddDoubleLine("  " .. catName .. "最佳 HPM", string.format("%s %d（%s）", bm.label, bm.rank, fmt2(bm.hpm)), .4, 1, .4, .4, 1, .4) end
  tt:Show()
end

local function hookTooltips()
  if TooltipDataProcessor and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Spell then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tt, data)
      if tt == GameTooltip and data then safe("滑鼠提示", addTooltip, tt, data.id) end
    end)
  else
    GameTooltip:HookScript("OnTooltipSetSpell", function(tt)
      local _, id = tt:GetSpell()
      safe("滑鼠提示", addTooltip, tt, id)
    end)
  end
end

-- ── 比較表視窗 ─────────────────────────────────────────────────────────────
local ROWS = 18
local COLS = { { "技能", 0, 168, "LEFT" }, { "學習", 168, 34, "RIGHT" }, { "有效量", 206, 82, "RIGHT", "heal" }, { "法力", 292, 50, "RIGHT" },
  { "秒", 346, 38, "RIGHT" }, { "HPS", 388, 62, "RIGHT", "hps" }, { "HPM", 454, 46, "RIGHT", "hpm" }, { "來源", 510, 40, "RIGHT" } }
local frame, offset = nil, 0

local function cell(parent, x, w, just)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetPoint("LEFT", parent, "LEFT", x, 0); fs:SetWidth(w); fs:SetJustifyH(just); fs:SetWordWrap(false)
  return fs
end

local function button(parent, w, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(w, 22); b:SetScript("OnClick", onClick)
  return b
end

local function refreshImpl()
  if not frame or not frame:IsShown() then return end
  local list, ctx = filtered()
  local tal = ctx.talents
  local pctTxt = db.pct and (db.pct .. "%（手動）") or (tal.heal .. "%（天賦自動）")
  frame.info:SetText(string.format("等級 %d　治療效果 %d　治療加成 %s　%s　%s", ctx.level, ctx.bonus, pctTxt,
    ctx.descIncl and "|cff9fd18b有效量＝技能說明值|r" or "有效量＝基礎＋治療效果×係數",
    #tal.found > 0 and ("|cff9a9282" .. table.concat(tal.found, "、") .. "|r") or ""))
  frame.modeBtn:SetText(db.mode == "group" and "群補" or "單補")
  frame.rateBtn:SetText(RATE_LABEL[db.rate])
  frame.sortBtn:SetText("排序：" .. SORT_LABEL[db.sort])
  frame.cdBtn:SetText(db.includeCd and "含冷卻技能" or "排除冷卻技能")
  local bh, bm = bests(list)
  frame.best:SetText(#list == 0 and "" or string.format("|cffffd100★ 最佳 HPS：%s %d（%s）|r　　|cff66ff66★ 最佳 HPM：%s %d（%s）|r",
    bh.label, bh.rank, fmt1(bh.hps), bm.label, bm.rank, fmt2(bm.hpm)))
  for _, h in ipairs(frame.heads) do
    h.fs:SetText(h.label .. (h.key == db.sort and " ▼" or ""))
    if h.key == db.sort then h.fs:SetTextColor(1, .82, 0) else h.fs:SetTextColor(.6, .57, .5) end
  end
  local maxOff = math.max(0, #list - ROWS)
  if offset > maxOff then offset = maxOff end
  for i = 1, ROWS do
    local line, r = frame.lines[i], list[i + offset]
    if r then
      local f = r.f
      local amt
      if db.mode == "group" then amt = fint(r.totalHeal) .. "（" .. r.targets .. "）"
      elseif f.key == "bh" then amt = fint(r.perHeal) .. "×2"
      else amt = fint(r.perHeal) end
      local isH, isM = sameRow(r, bh), sameRow(r, bm)
      local name = (isH and "|cffffd100★|r" or "") .. (isM and "|cff66ff66★|r" or "") .. r.label .. " " .. r.rank
        .. (r.down < 0.9995 and string.format(" |cffff9d5c%d%%|r", math.floor(r.down * 100 + .5)) or "")
      if isH then line.hl:SetColorTexture(1, .82, 0, .18); line.hl:Show()
      elseif isM then line.hl:SetColorTexture(.3, 1, .3, .14); line.hl:Show()
      else line.hl:Hide() end
      local vals = { name, r.learn, amt, fint(r.manaEff), fmt1(r.time), fmt1(r.hps), fmt2(r.hpm), r.srcText }
      for c = 1, #COLS do line.c[c]:SetText(vals[c]) end
      line.row = r
      line:Show()
    else line:Hide() end
  end
  frame.foot:SetText(#list == 0 and "這個條件下沒有技能。可以切換單補／群補，或按「含冷卻技能」。"
    or string.format("共 %d 筆　滾輪捲動　數值會隨裝備與增益即時更新", #list))
end

function HealHPS_Refresh() safe("比較表", refreshImpl) end

local function buildFrame()
  frame = CreateFrame("Frame", "HealHPSFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(580, 545); frame:SetPoint("CENTER")
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetFrameStrata("DIALOG")
  tinsert(UISpecialFrames, "HealHPSFrame") -- 按 Esc 關閉
  if not frame.TitleText then
    frame.TitleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.TitleText:SetPoint("TOP", 0, -5)
  end
  frame.TitleText:SetText("治療 HPS 計算器")
  frame.info = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.info:SetPoint("TOPLEFT", 14, -32); frame.info:SetWidth(552); frame.info:SetJustifyH("LEFT")
  frame.modeBtn = button(frame, 70, function() db.mode = db.mode == "group" and "single" or "group"; offset = 0; HealHPS_Refresh() end)
  frame.modeBtn:SetPoint("TOPLEFT", 12, -52)
  local rates = { cast = "effect", effect = "cooldown", cooldown = "cast" }
  frame.rateBtn = button(frame, 90, function() db.rate = rates[db.rate]; HealHPS_Refresh() end)
  frame.rateBtn:SetPoint("LEFT", frame.modeBtn, "RIGHT", 6, 0)
  local sorts = { hps = "hpm", hpm = "heal", heal = "hps" }
  frame.sortBtn = button(frame, 110, function() db.sort = sorts[db.sort]; HealHPS_Refresh() end)
  frame.sortBtn:SetPoint("LEFT", frame.rateBtn, "RIGHT", 6, 0)
  frame.cdBtn = button(frame, 110, function() db.includeCd = not db.includeCd; HealHPS_Refresh() end)
  frame.cdBtn:SetPoint("LEFT", frame.sortBtn, "RIGHT", 6, 0)
  frame.best = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.best:SetPoint("TOPLEFT", 14, -82); frame.best:SetWidth(552); frame.best:SetJustifyH("LEFT")
  local head = CreateFrame("Frame", nil, frame); head:SetSize(552, 18); head:SetPoint("TOPLEFT", 14, -102)
  frame.heads = {}
  for _, c in ipairs(COLS) do
    local fs = cell(head, c[2], c[3], c[4]); fs:SetText(c[1]); fs:SetTextColor(.6, .57, .5)
    if c[5] then -- 點表頭依這欄排序
      local b = CreateFrame("Button", nil, head)
      b:SetPoint("LEFT", head, "LEFT", c[2], 0); b:SetSize(c[3], 18)
      b:SetScript("OnClick", function() db.sort = c[5]; offset = 0; HealHPS_Refresh() end)
      b:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine("點一下依" .. c[1] .. "排序"); GameTooltip:Show() end)
      b:SetScript("OnLeave", function() GameTooltip:Hide() end)
      table.insert(frame.heads, { fs = fs, key = c[5], label = c[1] })
    end
  end
  frame.lines = {}
  for i = 1, ROWS do
    local line = CreateFrame("Frame", nil, frame)
    line:SetSize(552, 21); line:SetPoint("TOPLEFT", 14, -120 - (i - 1) * 21)
    line.hl = line:CreateTexture(nil, "BORDER"); line.hl:SetAllPoints(); line.hl:Hide()
    line.c = {}
    for c, col in ipairs(COLS) do line.c[c] = cell(line, col[2], col[3], col[4]) end
    line:EnableMouse(true)
    line:SetScript("OnEnter", function(self)
      local r = self.row; if not r then return end
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine(r.label .. " " .. r.rank)
      for _, k in ipairs({ { "base", "基礎量" }, { "mana", "法力" }, { "cast", "施法時間" }, { "cd", "冷卻" }, { "learn", "學習等級" }, { "hot", "HoT" } }) do
        if r.src[k[1]] then GameTooltip:AddDoubleLine(k[2], r.src[k[1]], .8, .8, .8, 1, 1, 1) end
      end
      GameTooltip:AddDoubleLine("係數", string.format("%.3f（資料）", r.coeff), .8, .8, .8, 1, 1, 1)
      GameTooltip:AddDoubleLine("可靠", r.rel or "—", .8, .8, .8, 1, 1, 1)
      if r.src.baseNote then GameTooltip:AddLine(r.src.baseNote, 1, .6, .3) end
      if r.f.note ~= "" then GameTooltip:AddLine(r.f.note, .6, .6, .6, true) end
      GameTooltip:Show()
    end)
    line:SetScript("OnLeave", function() GameTooltip:Hide() end)
    if i % 2 == 0 then local bg = line:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(1, 1, 1, .04) end
    frame.lines[i] = line
  end
  frame:EnableMouseWheel(true)
  frame:SetScript("OnMouseWheel", function(_, delta) offset = math.max(0, offset - delta * 3); HealHPS_Refresh() end)
  frame.foot = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.foot:SetPoint("BOTTOMLEFT", 14, 12)
  frame:SetScript("OnShow", HealHPS_Refresh)
  frame:Hide()
end

-- ── 指令 ───────────────────────────────────────────────────────────────────
local function debugDump()
  local _, class = UnitClass("player")
  local book = API.Spellbook()
  msg(string.format("版本 0.2.2　API：%s　法術書共 %d 個技能", (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines) and "新版 C_SpellBook" or "舊版", #book))
  rescan()
  local _, ctx = compute()
  msg(string.format("職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s", class, ctx.level, ctx.bonus, ctx.descIncl and "已含治療效果" or "基礎量",
    (#ctx.talents.found > 0 and table.concat(ctx.talents.found, "、") or "沒找到") .. "（" .. ctx.talents.source .. "）"))
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
      msg(string.format("%s：遊戲名「%s」到 %d 階（%d 階有法術ID）　說明解析：%s", st.f.label, st.gameName or "?", st.maxRank, nId,
        not st.f.parse and "不解析" or a and (a .. "–" .. b .. (h and (" HoT " .. h) or "")) or ("失敗：" .. (d and d:sub(1, 80) or "說明未載入"))))
    end
  end
end

SLASH_HEALHPS1 = "/hps"
SlashCmdList.HEALHPS = function(input)
  ensureDB()
  local cmd, arg = (input or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
  if cmd == "" then
    if not frame then buildFrame() end
    if frame:IsShown() then frame:Hide() else frame:Show() end
  elseif cmd == "pct" then
    db.pct = arg ~= "auto" and tonumber(arg) or nil
    msg("治療加成 %：" .. (db.pct and db.pct .. "（手動）" or "依天賦自動"))
  elseif cmd == "absorb" then
    db.absorb = arg ~= "auto" and tonumber(arg) or nil
    msg("吸收加成 %：" .. (db.absorb and db.absorb .. "（手動）" or "依天賦自動"))
  elseif cmd == "targets" then
    db.targets = math.max(1, math.min(5, tonumber(arg) or 5)); msg("群補目標數：" .. db.targets)
  elseif cmd == "tip" then
    db.tip = not db.tip; msg("滑鼠提示：" .. (db.tip and "開" or "關"))
  elseif cmd == "downrank" then
    db.downrank = not db.downrank; msg("降級衰減：" .. (db.downrank and "開" or "關"))
  elseif cmd == "desc" then
    db.desc = (arg == "incl" or arg == "base") and arg or "auto"
    msg("技能說明數字：" .. (db.desc == "incl" and "已含治療效果（手動）" or db.desc == "base" and "只有基礎量（手動）" or "自動判斷")
      .. "　目前：" .. (descIncludesBonus() and "直接採用說明數字" or "基礎＋治療效果×係數"))
  elseif cmd == "debug" then
    safe("除錯指令", debugDump)
  elseif cmd == "reset" then
    HealHPSCharDB = CopyTable(DEFAULTS); db = HealHPSCharDB; msg("設定已重設")
  else
    msg("/hps 開關視窗　/hps pct 數字|auto　/hps absorb 數字|auto　/hps targets 1-5　/hps tip　/hps downrank　/hps desc incl|base|auto　/hps debug　/hps reset")
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
    safe("掛上滑鼠提示", hookTooltips)
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
