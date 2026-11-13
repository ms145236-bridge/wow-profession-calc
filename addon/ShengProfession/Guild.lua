-- 專業助手：公會誰會做
-- 分隔符號用「~」：聊天系統把「|」當跳脫字元，避免被吃掉
-- 遊戲內建的公會專業被關掉了，改成插件之間互傳「學會哪些配方」。只看得到也有裝本插件的公會成員。
-- 協定（前綴 ShengProf，純文字，開頭是版本號）：
--   1~H~<雜湊>                       我的配方資料版本（登入、配方變動時對公會廣播；收到公會廣播時私訊回一次）
--   1~G                              跟對方要資料（私訊）
--   1~D~<雜湊>~<第幾則>/<共幾則>~<內容>  資料分段（私訊）；內容 = 專業:點數:配方ID(36進位),...

local _, NS = ...
local L = NS.L
local PREFIX, VER = "ShengProf", "1"
local LIMIT = 225 -- 每段內容的長度上限（整則訊息不能超過 255 位元組）
local KEEP = 30 * 86400

local function isSecret(...)
  if not issecretvalue then return false end
  for i = 1, select("#", ...) do if issecretvalue((select(i, ...))) then return true end end
  return false
end
local function inGuild() return IsInGuild and IsInGuild() and true or false end
local function sharing() return NS.ensureDB().guildShare ~= false end -- 預設分享；/sprof guild off 關掉（仍會收別人的）
local function store()
  local db = NS.ensureDB()
  db.guild = db.guild or {}
  return db.guild
end

local B36 = "0123456789abcdefghijklmnopqrstuvwxyz"
local function b36(n)
  n = math.floor(n)
  local s = ""
  repeat local r = n % 36; s = B36:sub(r + 1, r + 1) .. s; n = (n - r) / 36 until n == 0
  return s
end

-- 我的資料切成多段：每段只放一個專業（太長就同專業分好幾段）
local function snapshot()
  local db = NS.ensureDB()
  local learned = NS.learnedProfs()
  local keys = {}
  for k, book in pairs(db.recipes) do if next(book) then keys[#keys + 1] = k end end
  table.sort(keys)
  local chunks = {}
  for _, k in ipairs(keys) do
    local ids = {}
    for id in pairs(db.recipes[k]) do if type(id) == "number" then ids[#ids + 1] = id end end
    table.sort(ids)
    local head = k .. ":" .. (learned[k] and learned[k].cur or 0) .. ":"
    local cur = head
    for _, id in ipairs(ids) do
      local s = b36(id)
      if cur == head then cur = cur .. s
      elseif #cur + 1 + #s > LIMIT then chunks[#chunks + 1] = cur; cur = head .. s
      else cur = cur .. "," .. s end
    end
    chunks[#chunks + 1] = cur
  end
  local h = 5381
  local all = table.concat(chunks, ";")
  for i = 1, #all do h = (h * 33 + all:byte(i)) % 2147483647 end
  return chunks, #chunks > 0 and b36(h) or "0" -- "0"：沒有資料
end

-- ── 送訊息：排隊，每 0.25 秒送一則；戰鬥中先等 ─────────────────────────────
local outq, pumping, pump, whispered = {}, false, nil, {}
local function locked()
  if InCombatLockdown and InCombatLockdown() then return true end
  local C = C_ChatInfo
  if C and C.InChatMessagingLockdown then
    local ok, v = pcall(C.InChatMessagingLockdown)
    if ok and v == true then return true end
  end
  return false
end
local function step()
  if #outq == 0 then pumping = false; return end
  if locked() then C_Timer.After(2, pump); return end
  local m = table.remove(outq, 1)
  local ok, res = pcall(C_ChatInfo.SendAddonMessage, PREFIX, m.text, m.chan, m.to)
  if (not ok or res == false or (type(res) == "number" and res ~= 0)) and m.tries < 3 then -- 被節流就稍後重送
    m.tries = m.tries + 1; table.insert(outq, 1, m); C_Timer.After(1, pump); return
  end
  C_Timer.After(0.25, pump)
end
pump = function() NS.quiet("公會", step) end
local function send(text, chan, to)
  if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then return end
  outq[#outq + 1] = { text = text, chan = chan, to = to, tries = 0 }
  if to then
    whispered[to] = GetTime()
    local short = Ambiguate and Ambiguate(to, "none") or to
    if short ~= to then whispered[short] = to end
  end
  if not pumping then pumping = true; C_Timer.After(0.25, pump) end
end
local function dropTo(to)
  for i = #outq, 1, -1 do if outq[i].to == to then table.remove(outq, i) end end
end

-- ── 廣播自己的版本 ─────────────────────────────────────────────────────────
local loggedIn, helloPending, sentHash, lastHello = false, false, nil, -999
local function scheduleHello(delay)
  if helloPending then return end
  helloPending = true
  C_Timer.After(delay, function() NS.quiet("公會", function()
    helloPending = false
    if not inGuild() or not sharing() then return end
    local wait = 60 - (GetTime() - lastHello) -- 公會廣播最多一分鐘一次
    if wait > 0 then scheduleHello(wait); return end
    local _, h = snapshot()
    if h == sentHash then return end
    sentHash, lastHello = h, GetTime()
    send(VER .. "~H~" .. h, "GUILD")
  end) end)
end

local ver = 0 -- 資料有變就加一（物品對照表跟著重建）
function NS.guildRecipesChanged()
  ver = ver + 1
  if loggedIn then NS.quiet("公會", scheduleHello, 5) end
end

-- ── 收訊息 ─────────────────────────────────────────────────────────────────
local replied, asked, inbox = {}, {}, {}
local me, meFull
local function onAddon(prefix, text, chan, sender)
  if isSecret(prefix, text, chan, sender) or prefix ~= PREFIX then return end
  if (chan ~= "GUILD" and chan ~= "WHISPER") or not inGuild() or type(sender) ~= "string" then return end
  local name = Ambiguate and Ambiguate(sender, "none") or sender
  if name == me or sender == meFull then return end
  local v, kind, rest = text:match("^(%d+)~(%a)~?(.*)$")
  if v ~= VER then return end
  if kind == "H" then
    local h = rest:match("^(%w+)$")
    if not h then return end
    local e = store()[name]
    if h == "0" then store()[name] = nil
    elseif e and e.hash == h then e.t = time()
    elseif not asked[name] or GetTime() - asked[name] > 30 then
      asked[name] = GetTime(); send(VER .. "~G", "WHISPER", sender)
    end
    if chan == "GUILD" and not replied[name] and sharing() then -- 讓剛上線的人也知道我（私訊的 HELLO 不回，避免來回）
      replied[name] = true
      local _, mine = snapshot()
      send(VER .. "~H~" .. mine, "WHISPER", sender)
    end
  elseif kind == "G" and chan == "WHISPER" and sharing() then
    dropTo(sender)
    local chunks, h = snapshot()
    for i, c in ipairs(chunks) do send(string.format("%s~D~%s~%d/%d~%s", VER, h, i, #chunks, c), "WHISPER", sender) end
  elseif kind == "D" and chan == "WHISPER" and asked[name] then
    local h, seq, total, body = rest:match("^(%w+)~(%d+)/(%d+)~(.*)$")
    seq, total = tonumber(seq), tonumber(total)
    if not h or not seq or not total or total < 1 or total > 200 or seq < 1 or seq > total then return end
    local b = inbox[name]
    if not b or b.h ~= h or b.total ~= total or GetTime() - b.at > 120 then
      b = { h = h, total = total, got = {}, n = 0, at = GetTime() }; inbox[name] = b
    end
    if b.got[seq] then return end
    b.got[seq] = body; b.n = b.n + 1
    if b.n < total then return end
    local profs = {}
    for _, c in ipairs(b.got) do
      local key, skill, list = c:match("^([%w%-]+):(%d+):(.*)$")
      if key then
        local p = profs[key] or { skill = tonumber(skill), ids = {} }
        profs[key] = p
        for s in list:gmatch("[^,]+") do local id = tonumber(s, 36); if id then p.ids[id] = true end end
      end
    end
    store()[name] = { t = time(), hash = h, profs = profs }
    inbox[name], asked[name] = nil, nil
    ver = ver + 1
  end
end

-- ── 查誰會做 ───────────────────────────────────────────────────────────────
local idOut, outIdx, outVer = {}, nil, -1 -- 配方 → 產物（遊戲查一次就記住）
local function outIndex()
  if outIdx and outVer == ver then return outIdx end
  outIdx, outVer = {}, ver
  for _, book in pairs(NS.ensureDB().recipes) do
    for id, rec in pairs(book) do if rec.out then idOut[id] = rec.out end end
  end
  local T = C_TradeSkillUI
  for _, e in pairs(store()) do
    for _, p in pairs(e.profs) do
      for id in pairs(p.ids) do
        if idOut[id] == nil then
          local ok, sc = false, nil
          if T and T.GetRecipeSchematic then ok, sc = pcall(T.GetRecipeSchematic, id, false) end
          idOut[id] = ok and type(sc) == "table" and type(sc.outputItemID) == "number" and sc.outputItemID > 0 and sc.outputItemID or false
        end
        local o = idOut[id]
        if o then outIdx[o] = outIdx[o] or {}; outIdx[o][id] = true end
      end
    end
  end
  return outIdx
end

-- 會做這個配方（或做得出這個產物）的公會成員
local function knowers(id, out)
  if not inGuild() then return {} end
  local ids = out and outIndex()[out]
  local names = {}
  for name, e in pairs(store()) do
    local hit = false
    for _, p in pairs(e.profs) do
      if id and p.ids[id] then hit = true end
      if ids and not hit then for rid in pairs(ids) do if p.ids[rid] then hit = true; break end end end
      if hit then break end
    end
    if hit then names[#names + 1] = name end
  end
  table.sort(names)
  return names
end
local function nameList(names)
  if #names <= 5 then return table.concat(names, L["、"]) end
  return string.format(L["%s 等 %d 人"], table.concat(names, L["、"], 1, 5), #names)
end
function NS.guildLine(id, out)
  local names = NS.quiet("公會", knowers, id, out)
  if names and #names > 0 then return L["公會："] .. nameList(names) end
end

local function itemTip(tt, id)
  if (tt ~= GameTooltip and tt ~= ItemRefTooltip) or isSecret(id) or type(id) ~= "number" then return end
  local owner = tt.GetOwner and tt:GetOwner()
  if owner and owner.sprofRow then return end -- 插件視窗的列自己會加「公會：」
  if not NS.recipes()[id] then return end
  local names = knowers(nil, id)
  if #names > 0 then tt:AddLine(L["公會會做："] .. nameList(names), .55, .75, 1, true) end
end
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item then
  pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Item, function(tt, data)
    NS.quiet("公會", itemTip, tt, data and data.id)
  end)
else
  for _, tt in ipairs({ GameTooltip, ItemRefTooltip }) do
    if tt and tt.HasScript and tt:HasScript("OnTooltipSetItem") then
      tt:HookScript("OnTooltipSetItem", function(self)
        local _, link = self:GetItem()
        NS.quiet("公會", itemTip, self, type(link) == "string" and not isSecret(link) and tonumber(link:match("item:(%d+)")) or nil)
      end)
    end
  end
end

-- ── /sprof guild [名字] ────────────────────────────────────────────────────
local function ago(t)
  local s = math.max(0, time() - (t or 0))
  if s < 120 then return L["剛剛"] end
  if s < 7200 then return string.format(L["%d 分鐘前"], math.floor(s / 60)) end
  if s < 172800 then return string.format(L["%d 小時前"], math.floor(s / 3600)) end
  return string.format(L["%d 天前"], math.floor(s / 86400))
end
function NS.guildSlash(arg)
  local sw = arg and arg:lower()
  if sw == "on" or sw == "off" then
    NS.ensureDB().guildShare = sw == "on"
    if sw == "on" then sentHash = nil; if loggedIn then scheduleHello(1) end else wipe(outq) end
    NS.msg(L["分享我的配方給公會："] .. (sw == "on" and L["開"] or L["關（仍看得到別人的）"]))
    return
  end
  if not inGuild() then NS.msg(L["沒有公會"]); return end
  local g = store()
  if arg and arg ~= "" then
    local q, found = arg:lower(), nil
    for name in pairs(g) do
      local l = name:lower()
      if l == q then found = name; break end
      if not found and l:sub(1, #q) == q then found = name end
    end
    if not found then NS.msg(string.format(L["沒有 %s 的資料"], arg)); return end
    local e, t = g[found], {}
    for key, p in pairs(e.profs) do
      local n = 0
      for _ in pairs(p.ids) do n = n + 1 end
      t[#t + 1] = string.format(L["%s %d（%d 個配方）"], NS.profName(key), p.skill or 0, n)
    end
    table.sort(t)
    NS.msg(found .. L["："] .. (#t > 0 and table.concat(t, L["、"]) or L["沒有配方"]) .. L["　"] .. ago(e.t))
    return
  end
  local n, last = 0, nil
  for _, e in pairs(g) do n = n + 1; if not last or e.t > last then last = e.t end end
  if n == 0 then NS.msg(L["還沒有公會成員的資料（對方也要裝阿聖專業幫手）"] .. (sharing() and "" or L["　（我的不分享）"])); return end
  NS.msg(string.format(L["公會 %d 人的配方資料，最近更新：%s"], n, ago(last)) .. (sharing() and "" or L["　（我的不分享）"]))
end

-- 私訊的對象剛好下線時，遊戲會在聊天視窗說「找不到玩家」：是我們送的就藏起來，並丟掉要給他的訊息
if ChatFrame_AddMessageEventFilter and type(ERR_CHAT_PLAYER_NOT_FOUND_S) == "string" then
  local pat = "^" .. ERR_CHAT_PLAYER_NOT_FOUND_S:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0"):gsub("%%%%s", "(.+)") .. "$"
  ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, text)
    if isSecret(text) or type(text) ~= "string" then return false end
    local who = text:match(pat)
    local full = who and (type(whispered[who]) == "string" and whispered[who] or who)
    if full and type(whispered[full]) == "number" and GetTime() - whispered[full] < 60 then dropTo(full); return true end
    return false
  end)
end

-- ── 事件 ───────────────────────────────────────────────────────────────────
if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX) end
local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, e, ...)
  if e == "CHAT_MSG_ADDON" then
    if loggedIn then NS.quiet("公會", onAddon, ...) end
  elseif e == "PLAYER_LOGIN" then
    NS.quiet("公會", function()
      local n = UnitName("player")
      if not isSecret(n) then
        me = n
        local realm = GetNormalizedRealmName and GetNormalizedRealmName()
        if realm and not isSecret(realm) then meFull = n .. "-" .. realm end
      end
      local g, now = store(), time()
      for name, x in pairs(g) do
        if type(x) ~= "table" or type(x.t) ~= "number" or now - x.t > KEEP or type(x.profs) ~= "table" then g[name] = nil end
      end
      loggedIn = true
      scheduleHello(10)
    end)
  end
end)
for _, e in ipairs({ "PLAYER_LOGIN", "CHAT_MSG_ADDON" }) do pcall(ev.RegisterEvent, ev, e) end
