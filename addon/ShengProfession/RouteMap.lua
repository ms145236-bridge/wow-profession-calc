-- 專業助手：採集路線
-- 採集分頁的「採集路線」區塊（礦／草／雙、路線清單、選中那列的「去」），以及在世界地圖畫整圈路線、小地圖畫虛線點。
-- 世界地圖：在地圖畫布上用線段畫；小地圖：用 HereBeDragons-Pins（Questie 帶的）放點，沒有就不畫。戰鬥中不重畫，脫戰再補。

local _, NS = ...
local L, loc = NS.L, NS.loc
local ROUTES = NS.ROUTES or {}
local BY_ID = {}
for _, r in ipairs(ROUTES) do BY_ID[r.id] = r end
local REF = "ShengProfessionRoute"
local DOT = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask" -- 白色圓點，染色用
local COLOR = { ore = { .93, .55, .22 }, herb = { .35, .86, .35 }, both = { 1, .82, 0 } }
local KINDS = { { "ore", "礦" }, { "herb", "草" }, { "both", "雙" } } -- 第二欄是中文原文，顯示時查 L
local STEP_YD, MAX_MINI = 25, 400 -- 小地圖每 25 碼一點，太長的路線放寬間距，最多 400 點

-- 舊版的「顯示：關」＝不畫：換成「沒選路線」（之後也不再自動選推薦路線）
local function DB()
  local db = NS.ensureDB()
  if db.routeShow ~= nil then
    if db.routeShow == false then db.route, db.routePicked = nil, true end
    db.routeShow = nil
  end
  return db
end
local function selected() return BY_ID[DB().route] end -- 選了就畫，取消選取就不畫

-- ── 世界地圖 ───────────────────────────────────────────────────────────────
local wf, wkey -- 畫布上的框、目前畫好的是哪條路線（加上畫布尺寸）
local pending = false -- 戰鬥中延後的重畫

local function canvas()
  if not WorldMapFrame then return end
  return (WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child) or (WorldMapFrame.GetCanvas and WorldMapFrame:GetCanvas())
end

local function drawWorld()
  local c, r = canvas(), selected()
  if not (r and c and WorldMapFrame:IsShown() and WorldMapFrame:GetMapID() == r.map) then
    if wf then wf:Hide() end
    return
  end
  local w, h = c:GetWidth(), c:GetHeight()
  local key = r.id .. ":" .. math.floor(w) .. "x" .. math.floor(h)
  if wkey ~= key and InCombatLockdown() then pending = true; if wf then wf:Hide() end; return end
  if not wf then
    wf = CreateFrame("Frame", nil, c); wf:SetAllPoints(c)
    wf.edges, wf.lines, wf.dots = {}, {}, {}
    wf.ring = wf:CreateTexture(nil, "OVERLAY", nil, 1); wf.ring:SetTexture(DOT); wf.ring:SetVertexColor(1, 1, 1)
    wf.start = wf:CreateTexture(nil, "OVERLAY", nil, 2); wf.start:SetTexture(DOT)
  end
  -- 疊在地圖圖塊與探索覆蓋上面，其他標點（任務、旅行點）下面
  local mgr = WorldMapFrame.GetPinFrameLevelsManager and WorldMapFrame:GetPinFrameLevelsManager()
  local lv = mgr and type(mgr.definitions) == "table" and mgr.definitions.PIN_FRAME_LEVEL_MAP_EXPLORATION and mgr:GetValidFrameLevel("PIN_FRAME_LEVEL_MAP_EXPLORATION")
  wf:SetFrameLevel((lv or c:GetFrameLevel() + 1) + 1)
  local col, n = COLOR[r.kind], #r.pts
  if wkey ~= key then
    for i = 1, n do
      local a, b = r.pts[i], r.pts[i % n + 1]
      local e, l, d = wf.edges[i], wf.lines[i], wf.dots[i]
      if not l then
        e = wf:CreateLine(nil, "BORDER"); e:SetColorTexture(0, 0, 0, .55); wf.edges[i] = e
        l = wf:CreateLine(nil, "ARTWORK"); wf.lines[i] = l
        d = wf:CreateTexture(nil, "OVERLAY"); d:SetTexture(DOT); wf.dots[i] = d
      end
      for _, t in ipairs({ e, l }) do
        t:SetStartPoint("TOPLEFT", wf, a[1] / 100 * w, -a[2] / 100 * h)
        t:SetEndPoint("TOPLEFT", wf, b[1] / 100 * w, -b[2] / 100 * h)
        t:Show()
      end
      l:SetColorTexture(col[1], col[2], col[3], .9)
      d:SetVertexColor(col[1], col[2], col[3]); d:ClearAllPoints(); d:SetPoint("CENTER", wf, "TOPLEFT", a[1] / 100 * w, -a[2] / 100 * h); d:Show()
    end
    for i = n + 1, #wf.lines do wf.edges[i]:Hide(); wf.lines[i]:Hide(); wf.dots[i]:Hide() end
    local p = r.pts[1]
    for _, t in ipairs({ wf.ring, wf.start }) do t:ClearAllPoints(); t:SetPoint("CENTER", wf, "TOPLEFT", p[1] / 100 * w, -p[2] / 100 * h) end
    wf.start:SetVertexColor(col[1], col[2], col[3])
    wkey = key
  end
  -- 粗細與點大小跟著縮放換算，放大縮小時螢幕上看起來一樣（約 3 像素線、6 像素點）
  local s = WorldMapFrame.GetCanvasScale and WorldMapFrame:GetCanvasScale() or 1
  if not s or s <= 0 then s = 1 end
  for i = 1, n do
    wf.edges[i]:SetThickness(5 / s); wf.lines[i]:SetThickness(3 / s); wf.dots[i]:SetSize(6 / s, 6 / s)
  end
  wf.ring:SetSize(14 / s, 14 / s); wf.start:SetSize(10 / s, 10 / s)
  wf:Show()
end

local queued = false
local function scheduleWorld()
  if queued then return end
  queued = true
  C_Timer.After(0, function() queued = false; NS.quiet("採集路線地圖", drawWorld) end)
end

local hooked = false
local function hookWorld()
  if hooked or not WorldMapFrame then return end
  hooked = true
  for _, m in ipairs({ "OnMapChanged", "OnCanvasScaleChanged" }) do
    if type(WorldMapFrame[m]) == "function" then hooksecurefunc(WorldMapFrame, m, scheduleWorld) end
  end
  WorldMapFrame:HookScript("OnShow", scheduleWorld)
  local c = canvas()
  if c then c:HookScript("OnSizeChanged", scheduleWorld) end
end

-- ── 小地圖 ─────────────────────────────────────────────────────────────────
local mpool, mused, mkey = {}, 0, nil

local function drawMini()
  local pins = LibStub and LibStub("HereBeDragons-Pins-2.0", true)
  if not pins then return end
  local r = selected()
  local key = r and r.id
  if key == mkey then return end
  if InCombatLockdown() then pending = true; return end
  pins:RemoveAllMinimapIcons(REF)
  for i = 1, mused do mpool[i]:Hide() end
  mused, mkey = 0, key
  if not r then return end
  -- 地圖百分比換成碼，每段依長度插點
  local core = LibStub("HereBeDragons-2.0", true)
  local zw, zh = 0, 0
  if core then zw, zh = core:GetZoneSize(r.map) end
  local n, segs, total = #r.pts, {}, 0
  for i = 1, n do
    local a, b = r.pts[i], r.pts[i % n + 1]
    local len = (zw > 0 and zh > 0) and math.sqrt(((b[1] - a[1]) / 100 * zw) ^ 2 + ((b[2] - a[2]) / 100 * zh) ^ 2) or 0
    segs[i] = len; total = total + len
  end
  local step = math.max(STEP_YD, total / MAX_MINI)
  local col = COLOR[r.kind]
  local function put(x, y, size, first)
    mused = mused + 1
    local f = mpool[mused]
    if not f then
      f = CreateFrame("Frame", nil, UIParent)
      f.ring = f:CreateTexture(nil, "ARTWORK", nil, 0); f.ring:SetTexture(DOT); f.ring:SetAllPoints(); f.ring:SetVertexColor(1, 1, 1)
      f.dot = f:CreateTexture(nil, "ARTWORK", nil, 1); f.dot:SetTexture(DOT); f.dot:SetPoint("CENTER")
      f:EnableMouse(false)
      mpool[mused] = f
    end
    f:SetSize(size, size); f.ring:SetShown(first)
    f.dot:SetSize(first and size - 3 or size, first and size - 3 or size)
    f.dot:SetVertexColor(col[1], col[2], col[3], first and 1 or .85)
    pins:AddMinimapIconMap(REF, f, r.map, x / 100, y / 100, false, false)
  end
  for i = 1, n do
    local a, b = r.pts[i], r.pts[i % n + 1]
    put(a[1], a[2], i == 1 and 9 or 5, i == 1)
    local k = math.floor(segs[i] / step)
    for j = 1, k - 1 do
      local t = j / k
      put(a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, 3, false)
    end
  end
end

-- 選的路線改變時呼叫：兩邊一起重畫
function NS.routeRedraw()
  hookWorld()
  wkey = nil
  NS.quiet("採集路線小地圖", drawMini)
  scheduleWorld()
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(_, e, a1)
  if e == "PLAYER_LOGIN" then
    NS.routeRedraw()
  elseif e == "ADDON_LOADED" and a1 == "Blizzard_WorldMap" then
    hookWorld()
  elseif e == "PLAYER_REGEN_ENABLED" and pending then
    pending = false
    NS.quiet("採集路線小地圖", drawMini)
    scheduleWorld()
  end
end)

-- ── 採集分頁的「採集路線」區塊 ─────────────────────────────────────────────
local function inRange(L, a, b) return L ~= nil and L.cur >= a and L.cur <= b end
local function fits(r, all)
  if r.kind == "both" then return inRange(all.mining, r.ore[1], r.ore[2]) and inRange(all.herbalism, r.herb[1], r.herb[2]) end
  return inRange(r.kind == "ore" and all.mining or all.herbalism, r.min, r.max)
end
local function rangeText(r)
  if r.kind == "both" then return string.format(L["礦 %d–%d　草 %d–%d"], r.ore[1], r.ore[2], r.herb[1], r.herb[2]) end
  return string.format("%d–%d", r.min, r.max)
end
-- 區域名：中文用資料表；遊戲語言跟介面相同時問遊戲（uiMapID），不然用資料表的翻譯
local function zoneName(r)
  if NS.gameText and C_Map and C_Map.GetMapInfo then
    local info = C_Map.GetMapInfo(r.map)
    if info and info.name then return info.name end
  end
  return loc(r, "zone")
end

local function rowTip(self)
  local r = self.r
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:AddLine(zoneName(r) .. L["　"] .. loc(r, "name"), 1, .82, 0)
  GameTooltip:AddDoubleLine(string.format(L["建議角色 %s 級"], r.level), L["技能 "] .. rangeText(r), 1, 1, 1, 1, 1, 1)
  GameTooltip:AddLine(loc(r, "yields"), .8, .8, .8, true)
  GameTooltip:AddLine(L["一圈約 "] .. loc(r, "lap"), .8, .8, .8, true)
  GameTooltip:AddLine(loc(r, "note"), 1, .62, .42, true)
  GameTooltip:Show()
end

local function build(g)
  local u = {}
  u.sep = g:CreateTexture(nil, "ARTWORK"); u.sep:SetColorTexture(1, 1, 1, .12); u.sep:SetHeight(1)
  u.title = g:CreateFontString(nil, "OVERLAY", "GameFontNormal"); u.title:SetText(L["採集路線"])
  u.kinds = {} -- 礦／草／雙：子分頁（沒學的種類不顯示）
  for i, k in ipairs(KINDS) do
    local b = NS.UI.Tab(g, L[k[2]], function() DB().routeKind = k[1]; ProfLevel_Refresh() end, true)
    b.kind = k[1]
    u.kinds[i] = b
  end
  -- 「去」：放在選中那列的右端（設航點到路線起點）
  u.go = NS.button(g, 20, L["去"], function()
    local r = BY_ID[DB().route]
    if r then NS.goTo({ map = r.map, x = r.pts[1][1], y = r.pts[1][2], name = zoneName(r) .. " " .. loc(r, "short") }) end
  end)
  u.go:SetHeight(20); u.go:Hide()
  u.go:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(L["去起點"]); GameTooltip:Show() end)
  u.go:SetScript("OnLeave", function() GameTooltip:Hide() end)
  u.rows = {}
  g.routeUI = u
  return u
end

-- 從 y（相對採集分頁頂端）往下排，回傳排完後的 y 和這個區塊需要的視窗寬（標題列、區域名＋至少 60 的路線名＋範圍＋去）
function NS.routeLayout(g, fw, y, all)
  local u = g.routeUI or build(g)
  local db = DB()
  -- 只列學了的種類（雙採要兩種都學）；一種都沒學就全部列出來看
  local avail, any = {}, false
  for _, k in ipairs(KINDS) do
    local ok = (k[1] == "ore" and all.mining) or (k[1] == "herb" and all.herbalism) or (k[1] == "both" and all.mining and all.herbalism)
    avail[k[1]] = ok and true or false
    any = any or avail[k[1]]
  end
  if not any then avail = { ore = true, herb = true, both = true } end
  local kind = db.routeKind
  if not avail[kind] then
    kind = not any and "ore" or (avail.both and "both") or (avail.herb and "herb") or "ore"
  end
  u.sep:ClearAllPoints(); u.sep:SetPoint("TOPLEFT", g, "TOPLEFT", 14, y); u.sep:SetWidth(fw - 28)
  y = y - 8
  u.title:ClearAllPoints(); u.title:SetPoint("TOPLEFT", g, "TOPLEFT", 14, y - 4)
  local prev, kindsW = nil, 0
  for _, b in ipairs(u.kinds) do
    b:SetShown(avail[b.kind]); b:SetOn(b.kind == kind)
    if avail[b.kind] then
      b:ClearAllPoints()
      if prev then b:SetPoint("LEFT", prev, "RIGHT", 2, 0) else b:SetPoint("LEFT", u.title, "RIGHT", 8, 0) end
      kindsW = kindsW + (prev and 2 or 8) + b:GetWidth()
      prev = b
    end
  end
  local need = 14 + NS.measure(u.title) + kindsW + 14
  y = y - 28
  -- 目前技能符合的排前面（第一條是推薦），其他照技能區間
  local fit, rest = {}, {}
  for _, r in ipairs(ROUTES) do
    if r.kind == kind then table.insert(fits(r, all) and fit or rest, r) end
  end
  local byMin = function(a, b) if a.min ~= b.min then return a.min < b.min end return a.id < b.id end
  table.sort(fit, byMin); table.sort(rest, byMin)
  local list = {}
  for _, r in ipairs(fit) do list[#list + 1] = r end
  for _, r in ipairs(rest) do list[#list + 1] = r end
  -- 第一次打開、還沒選過：自動選推薦那條，地圖直接有線
  if not db.route and not db.routePicked and fit[1] then
    db.route, db.routePicked = fit[1].id, true
    NS.routeRedraw()
  end
  local rowW, zoneW, rangeW = fw - 28, 0, 0
  for i, r in ipairs(list) do
    local row = u.rows[i]
    if not row then
      row = CreateFrame("Button", nil, g); row:SetHeight(20)
      row.sel = row:CreateTexture(nil, "BACKGROUND"); row.sel:SetAllPoints()
      local hl = row:CreateTexture(nil, "HIGHLIGHT"); hl:SetAllPoints(); hl:SetColorTexture(1, 1, 1, .08)
      row.zone = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.zone:SetPoint("LEFT", 6, 0); row.zone:SetWordWrap(false)
      row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.name:SetWordWrap(false); row.name:SetJustifyH("LEFT")
      row.range = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.range:SetWordWrap(false)
      row:SetScript("OnClick", function(self)
        local d = DB(); d.route = d.route ~= self.r.id and self.r.id or nil; d.routePicked = true -- 再點一次取消選取（不畫）
        NS.routeRedraw(); ProfLevel_Refresh()
      end)
      row:SetScript("OnEnter", rowTip)
      row:SetScript("OnLeave", function() GameTooltip:Hide() end)
      u.rows[i] = row
    end
    row.r = r
    row.zone:SetText(zoneName(r)); row.range:SetText(rangeText(r))
    zoneW = math.max(zoneW, NS.measure(row.zone)); rangeW = math.max(rangeW, NS.measure(row.range))
  end
  local goW = u.go:GetWidth() + 8
  need = math.ceil(math.max(need, 14 + 6 + zoneW + 12 + 60 + 12 + rangeW + goW + 6 + 14))
  u.go:Hide()
  for i, row in ipairs(u.rows) do
    local r = list[i]
    if r then
      local on = r.id == db.route
      row:ClearAllPoints(); row:SetPoint("TOPLEFT", g, "TOPLEFT", 14, y); row:SetWidth(rowW); row:Show()
      -- 選中那列：右端「去」，技能範圍往左讓
      row.range:ClearAllPoints(); row.range:SetPoint("RIGHT", row, "RIGHT", on and -(goW + 2) or -6, 0)
      if on then u.go:ClearAllPoints(); u.go:SetPoint("RIGHT", row, "RIGHT", -2, 0); u.go:SetFrameLevel(row:GetFrameLevel() + 2); u.go:Show() end
      row.name:ClearAllPoints(); row.name:SetPoint("LEFT", row, "LEFT", 6 + math.ceil(zoneW) + 12, 0)
      NS.fitText(row.name, rowW - 12 - math.ceil(zoneW) - 12 - math.ceil(rangeW) - 12 - goW, loc(r, "short"))
      local c = (i == 1 and #fit > 0) and { 1, .82, 0 } or (i <= #fit and { 1, 1, 1 }) or { .5, .5, .5 }
      for _, fs in ipairs({ row.zone, row.name, row.range }) do fs:SetTextColor(c[1], c[2], c[3]) end
      local col = COLOR[r.kind]
      if on then row.sel:SetColorTexture(col[1], col[2], col[3], .22) else row.sel:SetColorTexture(0, 0, 0, 0) end
      y = y - 20
    else
      row:Hide()
    end
  end
  return y, need
end

