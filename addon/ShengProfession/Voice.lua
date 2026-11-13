-- 專業助手：語音提示
-- 附近出現礦或草時，用遊戲內建的文字轉語音念出名稱。
-- 偵測方式跟 NodeSight 一樣：開了軟目標互動後，附近可互動的物件會有名牌（NAME_PLATE_UNIT_ADDED），
-- 從名牌單位的 GUID 讀出 GameObject ID，對照 VoiceNodes.lua。戰鬥中一律不念、也不排隊。

local _, NS = ...
local REPEAT, GAP = 120, 2 -- 同一個點 120 秒內不重念；兩句至少隔 2 秒，多的直接丟掉
local SAMPLE = "銅礦"
-- 需要的軟目標設定（目前值大於等於就算夠，不去改）
local WANT = { softTargetInteract = 3, SoftTargetIconGameObject = 1, SoftTargetInteractArc = 2, SoftTargetInteractRange = 30 }
local SKILL = { ore = "mining", herb = "herbalism" }
local VOICE_HINTS = { "hanhan", "chinese (taiwan)", "zh-tw", "中文" }

local byID, byName, nodes = {}, {}, { ore = {}, herb = {} }
for i, n in ipairs(NS.voiceNodes) do
  local node = { name = n[1], kind = n[2], skill = n[3], i = i }
  for _, id in ipairs(n[4]) do byID[id] = node end
  byName[n[1]] = node
  table.insert(nodes[n[2]], node)
end
for _, l in pairs(nodes) do table.sort(l, function(a, b) if a.skill ~= b.skill then return a.skill < b.skill end return a.i < b.i end) end

local function secret(x) return issecretvalue ~= nil and issecretvalue(x) end

-- 存檔：ProfLevelCharDB.voice；off 只記取消勾選的名稱，saved／applied 記我們改過的 CVar 原值與設定值
local function V()
  local db = NS.ensureDB()
  local v = type(db.voice) == "table" and db.voice or {}
  db.voice = v
  if v.on == nil then v.on = true end
  if v.canGather == nil then v.canGather = true end
  if v.learnedOnly == nil then v.learnedOnly = true end
  v.off, v.saved, v.applied = v.off or {}, v.saved or {}, v.applied or {}
  v.volume, v.rate = v.volume or 80, v.rate or 0
  return v
end

-- ── CVar ──────────────────────────────────────────────────────────────────
-- 只在戰鬥外改；值已經夠（例如 NodeSight 設好了）就不動。關掉語音時改回原值（除非玩家或別的插件改過）。
-- 有 NodeSight 時關語音不立刻還原（避免把它的光點關掉），留到登出再還原；登入後再設。
local pending
local function setup(logout)
  local v = V()
  if InCombatLockdown() then pending = true; return end
  pending = nil
  if v.on and not logout then
    for cvar, want in pairs(WANT) do
      local cur = C_CVar.GetCVar(cvar)
      if cur ~= nil and (tonumber(cur) or -1) < want then
        C_CVar.SetCVar(cvar, tostring(want))
        if tonumber(C_CVar.GetCVar(cvar)) == want then
          if v.saved[cvar] == nil then v.saved[cvar] = cur end
          v.applied[cvar] = want
        end
      end
    end
  elseif logout or not (C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("NodeSight")) then
    for cvar, old in pairs(v.saved) do
      if tonumber(C_CVar.GetCVar(cvar)) == tonumber(v.applied[cvar]) then C_CVar.SetCVar(cvar, old) end
    end
    wipe(v.saved); wipe(v.applied)
  end
end

-- ── 說話 ──────────────────────────────────────────────────────────────────
local function voices()
  local ok, l = pcall(C_VoiceChat.GetTtsVoices)
  return ok and type(l) == "table" and l or {}
end

-- 選好的語音；沒選或已不存在時，挑中文（台灣）語音，再沒有就第一個
local function pickVoice(v)
  local l = voices()
  for _, x in ipairs(l) do if x.voiceID == v.voice then return x end end
  for _, hint in ipairs(VOICE_HINTS) do
    for _, x in ipairs(l) do if tostring(x.name):lower():find(hint, 1, true) then return x end end
  end
  return l[1]
end

-- 短名稱：「Microsoft YunJhe Online (Natural) - Chinese (Taiwan)」→「YunJhe」
local function shortName(n)
  n = tostring(n)
  local t = n:gsub(" %- .*$", ""):gsub(" Online", ""):gsub(" Desktop", ""):gsub(" %(Natural%)", ""):gsub("^Microsoft ", "")
  return t ~= "" and t or n
end

local function speak(text)
  local v = V()
  local x = pickVoice(v)
  if x then C_VoiceChat.SpeakText(x.voiceID, text, v.rate, v.volume, false) end
end

-- 名牌上的互動圖示是採礦還是採草（跟 NodeSight 一樣看材質／圖集名稱）
local function iconKind(unit)
  local plate = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(unit)
  local icon = plate and plate.UnitFrame and plate.UnitFrame.SoftTargetFrame and plate.UnitFrame.SoftTargetFrame.Icon
  if not icon or not icon:IsShown() then return end
  for _, s in ipairs({ icon:GetTexture(), icon:GetAtlas() }) do
    if type(s) == "string" and not secret(s) then
      s = s:lower()
      if s:find("herb", 1, true) then return "herb" end
      if s:find("mine", 1, true) or s:find("mining", 1, true) then return "ore" end
    end
  end
end

-- 最近幾個物件為什麼沒念（/sprof voice why）
local why = {}
local function note(name, reason)
  table.insert(why, 1, tostring(name) .. "：" .. reason)
  if #why > 6 then why[7] = nil end
end

local heard, lastAt, inCombat = {}, 0, false
local function consider(unit)
  local v = V()
  if not v.on or inCombat or InCombatLockdown() then return end
  if UnitIsGameObject then
    local o = UnitIsGameObject(unit)
    if secret(o) or not o then return end
  end
  local guid = UnitGUID(unit)
  if secret(guid) or type(guid) ~= "string" then return end
  local id = tonumber(guid:match("^GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)")) or 0
  local name = UnitName(unit)
  if secret(name) or type(name) ~= "string" then name = nil end
  -- 先用物件 ID；永恆的 ID 可能跟資料不同，再用名稱、最後用名牌圖示判斷
  local node = byID[id] or (name and byName[name])
  if not node then
    local kind = iconKind(unit)
    if not kind then note(name or id, "不是礦或草（ID " .. id .. "）"); return end
    node = { name = name or (kind == "ore" and "礦" or "草"), kind = kind, skill = 0 }
  end
  if v.off[node.name] then note(node.name, "設定裡取消勾選"); return end
  local now = GetTime()
  if heard[guid] and now - heard[guid] < REPEAT then note(node.name, "兩分鐘內念過"); return end
  if now - lastAt < GAP then note(node.name, "跟上一句太近"); return end
  if v.learnedOnly or v.canGather then
    local L = NS.learnedProfs(true)[SKILL[node.kind]]
    if v.learnedOnly and not L then note(node.name, "沒學" .. (node.kind == "ore" and "採礦" or "草藥學")); return end
    if v.canGather and node.skill > (L and L.cur or 0) then note(node.name, "點數不夠（要 " .. node.skill .. "）"); return end
  end
  note(node.name, "已念")
  for g, t in pairs(heard) do if now - t >= REPEAT then heard[g] = nil end end
  heard[guid], lastAt = now, now
  speak(node.name)
end

-- ── 設定頁 ────────────────────────────────────────────────────────────────
local panel, category, ui

local function checkbox(parent, label, onClick)
  local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  cb:SetSize(24, 24)
  local fs = cb.Text or cb.text
  if not fs then fs = cb:CreateFontString(nil, "OVERLAY"); fs:SetPoint("LEFT", cb, "RIGHT", 2, 0) end
  fs:SetFontObject("GameFontHighlight"); fs:SetText(label)
  cb.label = fs
  cb:SetScript("OnClick", function(self) NS.quiet("語音設定", onClick, self:GetChecked() and true or false) end)
  return cb
end

local function slider(parent, label, key, low, high)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); fs:SetText(label)
  local s = CreateFrame("Frame", nil, parent, "MinimalSliderWithSteppersTemplate")
  s:SetWidth(170)
  local right = MinimalSliderWithSteppersMixin.Label.Right
  s:Init(V()[key], low, high, high - low, { [right] = CreateMinimalSliderFormatter(right) })
  s:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, function(_, value) V()[key] = math.floor(value + 0.5) end, s)
  s:SetPoint("LEFT", fs, "RIGHT", 10, 0)
  s.label = fs
  return s
end

local function refreshPanel()
  local v = V()
  ui.on:SetChecked(v.on); ui.canGather:SetChecked(v.canGather); ui.learnedOnly:SetChecked(v.learnedOnly)
  ui.volume:SetValue(v.volume); ui.rate:SetValue(v.rate)
  -- 下拉選單寬度配合目前的短名稱（量字寬，不猜）
  local x = pickVoice(v)
  local short = x and shortName(x.name) or "沒有可用的語音"
  ui.measure:SetText(short)
  local w = ui.measure.GetUnboundedStringWidth and ui.measure:GetUnboundedStringWidth() or ui.measure:GetStringWidth()
  w = math.ceil(math.max(40, w or 0))
  if ui.voice.modern then
    ui.voice:SetWidth(w + 44)
    if ui.voice.GenerateMenu then ui.voice:GenerateMenu() end
  else
    UIDropDownMenu_SetWidth(ui.voice, w + 30)
    UIDropDownMenu_SetText(ui.voice, short)
  end
  for _, cb in ipairs(ui.nodes) do cb:SetChecked(not v.off[cb.name]) end
end

local function toggle()
  local v = V()
  v.on = not v.on
  setup()
  if ProfLevelFrame and ProfLevelFrame:IsShown() then ProfLevel_Refresh() end
  if ui and panel:IsShown() then refreshPanel() end
end

local function setVoice(id) V().voice = id; refreshPanel() end

-- 語音下拉選單：新版選單 API（WowStyle1DropdownTemplate），沒有就用舊的 UIDropDownMenu
local function voiceDropdown()
  local ok, dd = pcall(CreateFrame, "DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
  if ok and dd and dd.SetupMenu then
    dd.modern = true
    if dd.SetDefaultText then dd:SetDefaultText("沒有可用的語音") end
    dd:SetupMenu(function(_, root)
      for _, x in ipairs(voices()) do
        local item = root:CreateRadio(shortName(x.name), function()
          local c = pickVoice(V()); return c ~= nil and c.voiceID == x.voiceID
        end, function() NS.quiet("語音設定", setVoice, x.voiceID) end)
        if item and item.SetTooltip then item:SetTooltip(function(tip) tip:SetText(tostring(x.name), 1, 1, 1, 1, true) end) end
      end
    end)
    return dd
  end
  dd = CreateFrame("Frame", "ProfLevelVoiceDropDown", panel, "UIDropDownMenuTemplate")
  UIDropDownMenu_Initialize(dd, function(_, level)
    local c = pickVoice(V())
    for _, x in ipairs(voices()) do
      local info = UIDropDownMenu_CreateInfo()
      info.text, info.checked = shortName(x.name), c ~= nil and c.voiceID == x.voiceID
      info.tooltipTitle, info.tooltipOnButton = tostring(x.name), true
      info.func = function() NS.quiet("語音設定", setVoice, x.voiceID) end
      UIDropDownMenu_AddButton(info, level)
    end
  end)
  return dd
end

local function buildPanel()
  ui = { nodes = {} }
  ui.on = checkbox(panel, "語音提示", function(on) if on ~= V().on then toggle() end end)
  ui.on:SetPoint("TOPLEFT", 16, -16)
  ui.canGather = checkbox(panel, "不能採的不念", function(on) V().canGather = on end)
  ui.canGather:SetPoint("LEFT", ui.on.label, "RIGHT", 24, 0)
  ui.learnedOnly = checkbox(panel, "只念學會的", function(on) V().learnedOnly = on end)
  ui.learnedOnly:SetPoint("LEFT", ui.canGather.label, "RIGHT", 24, 0)
  ui.volume = slider(panel, "音量", "volume", 0, 100)
  ui.volume.label:SetPoint("TOPLEFT", 20, -60)
  ui.rate = slider(panel, "語速", "rate", -5, 5)
  ui.rate.label:SetPoint("LEFT", ui.volume, "RIGHT", 50, 0)
  -- 語音：標籤、下拉選單（短名稱，滑鼠移上去看完整名稱）、試聽
  local vl = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); vl:SetText("語音")
  vl:SetPoint("TOPLEFT", 20, -100)
  ui.voice = voiceDropdown()
  ui.measure = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); ui.measure:SetPoint("TOPLEFT"); ui.measure:SetAlpha(0)
  local vt = ui.voice.Text or _G.ProfLevelVoiceDropDownText
  if vt and vt.GetFont and vt:GetFont() then ui.measure:SetFont(vt:GetFont()) end
  if ui.voice.modern then ui.voice:SetPoint("LEFT", vl, "RIGHT", 10, 0) else ui.voice:SetPoint("LEFT", vl, "RIGHT", -6, -2) end
  local hover = ui.voice.modern and ui.voice or (ui.voice.Button or _G.ProfLevelVoiceDropDownButton)
  if hover then
    hover:HookScript("OnEnter", function(self)
      local x = pickVoice(V())
      if not x then return end
      GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(tostring(x.name)); GameTooltip:Show()
    end)
    hover:HookScript("OnLeave", function() GameTooltip:Hide() end)
  end
  local test = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  test:SetHeight(24); test:SetText("試聽")
  local tf = test:GetFontString()
  test:SetWidth(math.max(60, math.ceil(tf and tf:GetStringWidth() or 0) + 24))
  test:SetPoint("LEFT", ui.voice, "RIGHT", ui.voice.modern and 8 or -6, ui.voice.modern and 0 or 2)
  test:SetScript("OnClick", function() NS.quiet("語音試聽", speak, SAMPLE) end)
  -- 礦、草兩欄，依技能點排序
  local sf = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
  sf:SetPoint("TOPLEFT", 16, -150); sf:SetPoint("BOTTOMRIGHT", -36, 12)
  local child = CreateFrame("Frame", nil, sf)
  sf:SetScrollChild(child)
  local rows = 0
  for col, kind in ipairs({ "ore", "herb" }) do
    local x = (col - 1) * 280
    local head = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    head:SetText(kind == "ore" and "礦" or "草"); head:SetPoint("BOTTOMLEFT", sf, "TOPLEFT", x + 4, 6)
    for i, node in ipairs(nodes[kind]) do
      local cb = checkbox(child, node.name .. " |cff8c8c8c" .. node.skill .. "|r", function(on) V().off[node.name] = (not on) or nil end)
      cb:SetPoint("TOPLEFT", x, -(i - 1) * 22)
      cb.name = node.name
      table.insert(ui.nodes, cb)
    end
    rows = math.max(rows, #nodes[kind])
  end
  child:SetSize(560, rows * 22)
end

local function register()
  panel = CreateFrame("Frame")
  panel:Hide()
  panel:SetScript("OnShow", function()
    if not ui then NS.quiet("語音設定", buildPanel) end
    if ui then NS.quiet("語音設定", refreshPanel) end
  end)
  if Settings and Settings.RegisterCanvasLayoutCategory then
    category = Settings.RegisterCanvasLayoutCategory(panel, "阿聖專業幫手")
    Settings.RegisterAddOnCategory(category)
  elseif InterfaceOptions_AddCategory then
    panel.name = "阿聖專業幫手"
    InterfaceOptions_AddCategory(panel)
  end
end

local function openSettings()
  if category and Settings.OpenToCategory then
    Settings.OpenToCategory(category:GetID())
  elseif InterfaceOptionsFrame_OpenToCategory then
    InterfaceOptionsFrame_OpenToCategory(panel); InterfaceOptionsFrame_OpenToCategory(panel) -- 舊介面第一次常開不到
  end
end

-- ── 給 Core.lua 用 ────────────────────────────────────────────────────────
function NS.voiceLabel() return V().on and "語音：開" or "語音：關" end
function NS.voiceToggle() NS.quiet("語音提示", toggle) end
function NS.voiceSlash(arg)
  if arg == "config" then NS.quiet("語音設定", openSettings)
  elseif arg == "test" then NS.quiet("語音試聽", speak, SAMPLE)
  elseif arg == "why" then
    if #why == 0 then NS.msg("語音提示：附近還沒偵測到任何物件（確認「互動鍵」相關設定有開）") end
    for i = #why, 1, -1 do NS.msg("語音提示：" .. why[i]) end
  else
    NS.quiet("語音提示", toggle)
    NS.msg("語音提示：" .. (V().on and "開" or "關"))
  end
end

-- ── 事件 ──────────────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, e, unit)
  if e == "NAME_PLATE_UNIT_ADDED" then NS.quiet("語音提示", consider, unit)
  elseif e == "PLAYER_SOFT_INTERACT_CHANGED" then NS.quiet("語音提示", consider, "softinteract")
  elseif e == "PLAYER_REGEN_DISABLED" then inCombat = true
  elseif e == "PLAYER_REGEN_ENABLED" then
    inCombat = false
    if pending then NS.quiet("語音提示", setup) end
  elseif e == "PLAYER_LOGIN" then NS.quiet("語音設定", register)
  elseif e == "PLAYER_ENTERING_WORLD" then NS.quiet("語音提示", setup)
  elseif e == "PLAYER_LOGOUT" then NS.quiet("語音提示", setup, true)
  end
end)
if NamePlateDriverFrame and NamePlateDriverFrame.OnSoftTargetUpdate then
  hooksecurefunc(NamePlateDriverFrame, "OnSoftTargetUpdate", function()
    if inCombat or not V().on then return end
    for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
      local u = plate.UnitFrame and plate.UnitFrame.unit
      if u then NS.quiet("語音提示", consider, u) end
    end
  end)
end
for _, e in ipairs({ "NAME_PLATE_UNIT_ADDED", "PLAYER_SOFT_INTERACT_CHANGED", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED",
  "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_LOGOUT" }) do pcall(ev.RegisterEvent, ev, e) end
