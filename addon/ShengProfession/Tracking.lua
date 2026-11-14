-- 專業助手：採集追蹤提醒
-- 學了採礦／草藥學但小地圖沒開「尋找礦物／尋找草藥」時，畫面上出現提醒按鈕（點一下就開）；可以的話自動開啟。

local _, NS = ...
local L = NS.L
local KINDS = { -- label 是中文原文，顯示時查 L
  mine = { spell = 2580, label = "尋找礦物" },
  herb = { spell = 2383, label = "尋找草藥" },
}
local ORDER = { "mine", "herb" }
local GATHER = { [2580] = "mine", [2383] = "herb" }

local function msg(s) DEFAULT_CHAT_FRAME:AddMessage(L["|cff4fc3f7阿聖|r|cffd9b25f專業幫手|r "] .. s) end
local function DB()
  local db = ProfLevelCharDB
  if not db then ProfLevelCharDB = {}; db = ProfLevelCharDB end
  if db.trackRemind == nil then db.trackRemind = true end
  if db.trackAuto == nil then db.trackAuto = true end
  return db
end

local function spellName(id)
  if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
  if GetSpellInfo then return (GetSpellInfo(id)) end
end
local function spellIcon(id)
  if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
  if GetSpellTexture then return GetSpellTexture(id) end
end
local function known(k)
  local id = KINDS[k].spell
  if IsPlayerSpell and IsPlayerSpell(id) then return true end
  if IsSpellKnown and IsSpellKnown(id) then return true end
  return false
end

-- 讀小地圖追蹤清單：{ index, name, active, spellID }
local function trackingList()
  local list = {}
  local M = C_Minimap
  local num = (M and M.GetNumTrackingTypes and M.GetNumTrackingTypes()) or (GetNumTrackingTypes and GetNumTrackingTypes()) or 0
  for i = 1, num do
    local name, active, sid
    if M and M.GetTrackingInfo then
      local a, b, c, _, _, f = M.GetTrackingInfo(i)
      if type(a) == "table" then name, active, sid = a.name, a.active, a.spellID
      else name, active, sid = a, c, f end
    elseif GetTrackingInfo then
      local a, _, c, _, _, f = GetTrackingInfo(i)
      name, active, sid = a, c, f
    end
    if name then
      if not sid then for id in pairs(GATHER) do if spellName(id) == name then sid = id end end end
      table.insert(list, { index = i, name = name, active = active and true or false, spellID = sid })
    end
  end
  return list
end

-- 目前有沒有開採集追蹤；另外回傳「開著的其他法術追蹤」名稱
local function status()
  local list = trackingList()
  local gather, other = nil, nil
  for _, e in ipairs(list) do
    if e.active then
      if e.spellID and GATHER[e.spellID] then gather = GATHER[e.spellID]
      elseif e.spellID then other = e.name end
    end
  end
  -- 沒有追蹤清單 API：改看身上的追蹤效果（戰鬥中遊戲不讓讀增益，跳過）
  if not gather and #list == 0 and not InCombatLockdown() and C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
    for id, k in pairs(GATHER) do
      local ok, a = pcall(C_UnitAuras.GetPlayerAuraBySpellID, id)
      if ok and a then gather = k end
    end
  end
  return gather, other, list
end

local function wanted()
  local db = DB()
  if db.trackPref and KINDS[db.trackPref] and known(db.trackPref) then return db.trackPref end
  for _, k in ipairs(ORDER) do if known(k) then return k end end
end

-- ---------- 提醒按鈕（安全按鈕：點一下等於施放追蹤法術，不會被暴雪擋） ----------
-- 36 px 圖示鈕＋金框，預設在小地圖左下；出現時閃 3 次後常亮；怎麼用寫在滑鼠提示
local GOLD = NS.UI.C.GOLD
local btn = CreateFrame("Button", "ProfLevelTrackButton", UIParent, "SecureActionButtonTemplate")
btn:SetSize(36, 36)
btn:SetFrameStrata("HIGH")
btn:SetClampedToScreen(true)
btn:SetMovable(true)
btn:RegisterForClicks("AnyUp", "AnyDown")
btn:RegisterForDrag("LeftButton")
btn:Hide()
NS.UI.box(btn, GOLD, { .02, .022, .028, .95 })
local inner = btn:CreateTexture(nil, "BORDER") -- 金框加粗成 2 px
inner:SetPoint("TOPLEFT", 1, -1); inner:SetPoint("BOTTOMRIGHT", -1, 1); inner:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
btn.icon = btn:CreateTexture(nil, "ARTWORK")
btn.icon:SetPoint("TOPLEFT", 2, -2); btn.icon:SetPoint("BOTTOMRIGHT", -2, 2)
btn.icon:SetTexCoord(.07, .93, .07, .93)
local hl = btn:CreateTexture(nil, "HIGHLIGHT")
hl:SetPoint("TOPLEFT", 2, -2); hl:SetPoint("BOTTOMRIGHT", -2, 2); hl:SetColorTexture(1, 1, 1, .15)
-- 閃 3 次（暗→亮各一次算一下），之後停在全亮
local pulse = btn:CreateAnimationGroup()
pulse:SetLooping("REPEAT")
local a = pulse:CreateAnimation("Alpha")
a:SetFromAlpha(1); a:SetToAlpha(0.3); a:SetDuration(0.35)
local b2 = pulse:CreateAnimation("Alpha")
b2:SetFromAlpha(0.3); b2:SetToAlpha(1); b2:SetDuration(0.35); b2:SetStartDelay(0.35)
local loops = 0
pulse:SetScript("OnLoop", function(self) loops = loops + 1; if loops >= 3 then self:Stop() end end)
btn:SetScript("OnShow", function() loops = 0; pulse:Play() end)
btn:SetScript("OnHide", function() pulse:Stop() end)

btn:SetScript("OnDragStart", function(self) if IsShiftKeyDown() and not InCombatLockdown() then self:StartMoving() end end)
btn:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing()
  local p, _, rp, x, y = self:GetPoint()
  DB().trackPos = { p, rp, x, y }
end)
btn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_LEFT")
  GameTooltip:AddLine(self.title or "", 1, .82, 0)
  GameTooltip:AddLine(string.format(L["左鍵：%s"], self.spell or ""), 1, 1, 1)
  GameTooltip:AddLine(L["右鍵：10 分鐘內不提醒"], 1, 1, 1)
  GameTooltip:AddLine(L["Shift＋拖曳：移動"], .6, .6, .6)
  GameTooltip:Show()
end)
btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local snoozeUntil = 0
local update
btn:SetScript("PostClick", function(_, button)
  if button == "RightButton" then -- 10 分鐘不提醒（不印聊天；/sprof track off 可以完全關閉）
    snoozeUntil = GetTime() + 600
    if not InCombatLockdown() then btn:Hide() end
  end
  if C_Timer then C_Timer.After(0.5, function() update() end) end
end)

local function place()
  local p = DB().trackPos
  btn:ClearAllPoints()
  if p then btn:SetPoint(p[1], UIParent, p[2], p[3], p[4])
  elseif Minimap and Minimap.GetBottom and Minimap:GetLeft() and Minimap:GetBottom() then
    -- 小地圖左下；用螢幕座標掛在 UIParent（直接掛在小地圖上會讓小地圖變成受保護框架）
    local s = Minimap:GetEffectiveScale() / UIParent:GetEffectiveScale()
    btn:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", Minimap:GetLeft() * s + 2, Minimap:GetBottom() * s + 2)
  else btn:SetPoint("TOP", UIParent, "TOP", 0, -150) end
end

-- ---------- 自動開啟 ----------
local lastTry, autoFailed, autoMsg = -100, false, false
local function tryAuto(k, list)
  if autoFailed or not DB().trackAuto then return end
  local set = (C_Minimap and C_Minimap.SetTracking) or SetTracking
  if not set then autoFailed = true; return end
  if GetTime() - lastTry < 8 then return end
  lastTry = GetTime()
  local idx
  for _, e in ipairs(list) do if e.spellID == KINDS[k].spell then idx = e.index end end
  if not idx then return end
  pcall(set, idx, true)
  C_Timer.After(1.5, function()
    local g = status()
    if g then
      if not autoMsg then msg(string.format(L["已自動開啟%s（/sprof track auto 可以關掉自動開啟）"], L[KINDS[k].label])); autoMsg = true end
    else
      autoFailed = true -- 遊戲不允許插件直接開：之後只用提醒按鈕
      msg(string.format(L["沒辦法自動開啟%s，請點畫面上的提醒按鈕"], L[KINDS[k].label]))
    end
    update()
  end)
end

local pending = false
update = function()
  if InCombatLockdown() then pending = true; return end
  pending = false
  local db = DB()
  local k = wanted()
  local gather, other, list = status()
  local hide = (not db.trackRemind) or (not k) or gather or GetTime() < snoozeUntil
    or UnitIsDeadOrGhost("player") or (UnitOnTaxi and UnitOnTaxi("player")) or select(2, IsInInstance()) ~= "none"
  if hide then btn:Hide(); return end
  -- 有開其他法術追蹤（例如獵人追蹤野獸）時不搶，只提醒
  if not other then tryAuto(k, list) end
  local name = spellName(KINDS[k].spell) or L[KINDS[k].label]
  btn:SetAttribute("type1", "spell")
  btn:SetAttribute("spell1", name)
  btn:SetAttribute("type2", nil)
  btn.icon:SetTexture(spellIcon(KINDS[k].spell) or "Interface\\Icons\\INV_Misc_QuestionMark")
  btn.title = other and string.format(L["目前追蹤：%s"], other) or string.format(L["還沒開啟%s"], name) -- 滑鼠提示的第一行
  btn.spell = name
  btn:Show()
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, e, unit)
  if e == "PLAYER_LOGIN" then place() end
  if e == "UNIT_AURA" and ((issecretvalue and issecretvalue(unit)) or unit ~= "player") then return end
  if C_Timer then C_Timer.After(0.3, update) else update() end
end)
for _, e in ipairs({ "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "MINIMAP_UPDATE_TRACKING", "PLAYER_REGEN_ENABLED",
  "PLAYER_ALIVE", "PLAYER_UNGHOST", "SPELLS_CHANGED", "SKILL_LINES_CHANGED", "ZONE_CHANGED_NEW_AREA", "PLAYER_CONTROL_GAINED" }) do
  pcall(ev.RegisterEvent, ev, e)
end
-- 只聽自己的增益變化（全部單位的 UNIT_AURA 戰鬥中很密，參數還可能是秘密值）
if ev.RegisterUnitEvent then pcall(ev.RegisterUnitEvent, ev, "UNIT_AURA", "player") else pcall(ev.RegisterEvent, ev, "UNIT_AURA") end
-- 保險：每 10 秒檢查一次（有些客戶端關閉追蹤不會發事件）
if C_Timer and C_Timer.NewTicker then C_Timer.NewTicker(10, function() if btn:IsShown() or not pending then update() end end) end

-- /sprof track 子指令
function ProfLevel_Track(arg)
  local db = DB()
  arg = (arg or ""):lower()
  if arg == "off" then db.trackRemind = false; msg(L["採集追蹤提醒：關"])
  elseif arg == "on" then db.trackRemind = true; snoozeUntil = 0; msg(L["採集追蹤提醒：開"])
  elseif arg == "auto" then db.trackAuto = not db.trackAuto; autoFailed = false; msg(L["自動開啟採集追蹤："] .. (db.trackAuto and L["開"] or L["關"]))
  elseif arg == "mine" or arg == "herb" then db.trackPref = arg; msg(L["兩種都學時優先追蹤："] .. L[KINDS[arg].label])
  elseif arg == "reset" then db.trackPos = nil; if not InCombatLockdown() then place() end; msg(L["提醒按鈕位置已重設"])
  else
    local g = status()
    msg(string.format(L["採集追蹤　提醒：%s　自動開啟：%s%s　優先：%s　目前：%s"],
      db.trackRemind and L["開"] or L["關"], db.trackAuto and L["開"] or L["關"], autoFailed and L["（這次登入失敗過）"] or "",
      KINDS[db.trackPref or ""] and L[KINDS[db.trackPref].label] or L["自動"], g and L[KINDS[g].label] or L["沒有開"]))
    msg(L["/sprof track on|off 開關提醒　/sprof track auto 開關自動開啟　/sprof track mine|herb 兩種都學時優先哪個　/sprof track reset 重設按鈕位置"])
  end
  update()
end

-- 給主視窗「採集」分頁、設定面板用的開關（不在聊天視窗說話，勾選框就是狀態）
function NS.trackOn() return DB().trackRemind end
function NS.trackAutoOn() return DB().trackAuto end
function NS.trackAutoToggle()
  local db = DB()
  db.trackAuto = not db.trackAuto
  autoFailed = false
  update()
end
function NS.trackToggle()
  local db = DB()
  db.trackRemind = not db.trackRemind
  if db.trackRemind then snoozeUntil = 0 end
  update()
end
