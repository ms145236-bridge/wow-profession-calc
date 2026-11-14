-- 阿聖系列共用外觀（照 ShengLeveling 的樣子）：深色面板＋細邊＋金色強調線、金框按鈕、底線分頁、勾選框、2 px 捲動條、標題列（齒輪＋關閉）。
-- ShengHealing 和 ShengProfession 各帶一份一模一樣的檔案（改了就複製到另一份）。這裡不放任何文字：標籤由呼叫的地方傳進來（已經過 L）。
local _, NS = ...
local UI = {}
NS.UI = UI

local FONT = STANDARD_TEXT_FONT or (GameFontNormal and GameFontNormal:GetFont()) or "Fonts\\FRIZQT__.TTF"
-- 色票（ShengLeveling UI.lua 同一組）
local C = {
  BG = { .055, .059, .071, .94 }, EDGE = { .165, .176, .204 }, EDGE2 = { .263, .282, .325 },
  TEXT = { .91, .894, .847 }, DIM = { .545, .561, .596 }, FAINT = { .333, .349, .384 },
  GOLD = { .851, .698, .373 }, AMBER = { .878, .569, .227 }, GREEN = { .435, .749, .451 },
  BRONZE = { .427, .353, .184 }, RED = { .851, .380, .310 },
}
UI.C, UI.FONT = C, FONT
function UI.hex(c) return string.format("|cff%02x%02x%02x", math.floor(c[1] * 255 + .5), math.floor(c[2] * 255 + .5), math.floor(c[3] * 255 + .5)) end
local function paint(fs, c) fs:SetTextColor(c[1], c[2], c[3]) end
UI.paint = paint

function UI.measure(fs)
  if fs.GetUnboundedStringWidth then
    local w = fs:GetUnboundedStringWidth()
    if type(w) == "number" and w > 0 then return w end
  end
  local w = fs.GetStringWidth and fs:GetStringWidth()
  return type(w) == "number" and w or 0
end

function UI.text(parent, size, color, justify)
  local s = parent:CreateFontString(nil, "OVERLAY")
  s:SetFont(FONT, size, "")
  paint(s, color)
  s:SetJustifyH(justify or "LEFT")
  s:SetWordWrap(false)
  return s
end

-- 底色＋四邊 1 px 細線；f.edges 留著換框色（UI.edge）
function UI.box(f, edge, bg)
  bg = bg or C.BG
  local t = f:CreateTexture(nil, "BACKGROUND")
  t:SetAllPoints()
  t:SetColorTexture(bg[1], bg[2], bg[3], bg[4] or 1)
  f.edges = {}
  local function line(p1, p2, w, h)
    local e = f:CreateTexture(nil, "BORDER")
    e:SetPoint(p1); e:SetPoint(p2)
    if w then e:SetWidth(w) else e:SetHeight(h) end
    f.edges[#f.edges + 1] = e
  end
  line("TOPLEFT", "TOPRIGHT", nil, 1); line("BOTTOMLEFT", "BOTTOMRIGHT", nil, 1)
  line("TOPLEFT", "BOTTOMLEFT", 1); line("TOPRIGHT", "BOTTOMRIGHT", 1)
  UI.edge(f, edge or C.EDGE)
  return t
end
function UI.edge(f, c) for _, e in ipairs(f.edges) do e:SetColorTexture(c[1], c[2], c[3], 1) end end

-- 金框按鈕：深底、銅金框、金字；換字用 b:SetText（各插件的 setLabel 會配合文字寬度）
function UI.Button(parent, label, onClick)
  local b = CreateFrame("Button", nil, parent)
  b:SetHeight(22)
  UI.box(b, C.BRONZE, { 0, 0, 0, .3 })
  local fs = UI.text(b, 13, C.GOLD, "CENTER")
  fs:SetPoint("CENTER", 0, 0)
  b:SetFontString(fs)
  b.label = fs
  local hl = b:CreateTexture(nil, "HIGHLIGHT")
  hl:SetPoint("TOPLEFT", 1, -1); hl:SetPoint("BOTTOMRIGHT", -1, 1)
  hl:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], .12)
  b:SetScript("OnEnable", function(self) self:SetAlpha(1) end)
  b:SetScript("OnDisable", function(self) self:SetAlpha(.4) end)
  if onClick then b:SetScript("OnClick", onClick) end
  b:SetText(label or "")
  b:SetWidth(math.ceil(UI.measure(fs)) + 24)
  return b
end
-- 按鈕狀態外觀：nil＝一般、"applied"＝已套用（金框白字）、"danger"＝危險（紅框紅字）
function UI.look(b, st)
  UI.edge(b, st == "applied" and C.GOLD or st == "danger" and C.RED or C.BRONZE)
  paint(b.label, st == "applied" and C.TEXT or st == "danger" and C.RED or C.GOLD)
end

-- 底線分頁：沒選灰字、滑過變白；選中白字＋金色底線。small＝子分頁（字小、線 1 px）
function UI.Tab(parent, label, onClick, small)
  local b = CreateFrame("Button", nil, parent)
  b:SetHeight(small and 22 or 26)
  local fs = UI.text(b, small and 12 or 14, C.DIM, "CENTER")
  fs:SetPoint("CENTER", 0, 1)
  b:SetFontString(fs)
  b.label = fs
  b.under = b:CreateTexture(nil, "ARTWORK")
  b.under:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], 1)
  b.under:SetPoint("BOTTOMLEFT", 6, 0); b.under:SetPoint("BOTTOMRIGHT", -6, 0); b.under:SetHeight(small and 1 or 2)
  b.under:Hide()
  b:SetScript("OnEnter", function(self) if not self.on then paint(fs, C.TEXT) end end)
  b:SetScript("OnLeave", function(self) if not self.on then paint(fs, C.DIM) end end)
  b:SetScript("OnClick", onClick)
  function b:SetOn(on)
    self.on = on and true or false
    paint(fs, on and C.TEXT or C.DIM); self.under:SetShown(self.on)
  end
  function b:Relabel(t) self:SetText(t); self:SetWidth(math.ceil(UI.measure(fs)) + 16) end
  b:Relabel(label or "")
  return b
end

-- 勾選框＋標籤（整列都能點）；寬度跟著標籤
function UI.Check(parent, label, onClick)
  local b = CreateFrame("Button", nil, parent)
  b:SetHeight(20)
  b.box = CreateFrame("Frame", nil, b)
  b.box:SetSize(16, 16); b.box:SetPoint("LEFT", 0, 0)
  UI.box(b.box, C.EDGE2, { .02, .022, .028, .9 })
  b.mark = b.box:CreateTexture(nil, "ARTWORK")
  b.mark:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
  b.mark:SetDesaturated(true)
  b.mark:SetVertexColor(C.GOLD[1], C.GOLD[2], C.GOLD[3])
  b.mark:SetPoint("CENTER", 1, 0); b.mark:SetSize(20, 20)
  b.mark:Hide()
  local hl = b:CreateTexture(nil, "HIGHLIGHT")
  hl:SetPoint("TOPLEFT", b.box, "TOPLEFT", 1, -1); hl:SetPoint("BOTTOMRIGHT", b.box, "BOTTOMRIGHT", -1, 1)
  hl:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], .15)
  b.label = UI.text(b, 13, C.TEXT)
  b.label:SetPoint("LEFT", b.box, "RIGHT", 6, 0)
  b:SetScript("OnClick", onClick)
  b:SetScript("OnEnable", function(self) self:SetAlpha(1) end)
  b:SetScript("OnDisable", function(self) self:SetAlpha(.4) end)
  function b:SetCheck(on) self.mark:SetShown(on and true or false) end
  function b:Relabel(t) self.label:SetText(t); self:SetWidth(16 + 6 + math.ceil(UI.measure(self.label)) + 2) end
  b:Relabel(label or "")
  return b
end

-- 右緣內側 2 px 的金色捲動條；列表的右上角＝(anchor 的 TOPRIGHT + x, y)、高 h。內容不滿一頁不畫
function UI.Scrollbar(parent)
  local t = parent:CreateTexture(nil, "OVERLAY")
  t:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], .5)
  t:SetWidth(2); t:Hide()
  return t
end
function UI.scroll(t, anchor, x, y, h, off, total, vis)
  if total <= vis or h <= 0 then t:Hide(); return end
  local th = math.max(10, h * vis / total)
  local dy = (h - th) * off / math.max(1, total - vis)
  t:ClearAllPoints(); t:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", x, y - dy); t:SetHeight(th); t:Show()
end

-- 設定用的齒輪圖示（沒有這張圖的客戶端退到其他圖）
local function gearIcon(tex, size)
  local ok, loaded = pcall(tex.SetTexture, tex, "Interface\\WorldMap\\Gear_64Grey")
  if ok and loaded then tex:SetTexCoord(.1, .9, .1, .9); tex:SetSize(size + 2, size + 2); return end
  if C_Texture and C_Texture.GetAtlasInfo and tex.SetAtlas and pcall(C_Texture.GetAtlasInfo, "GM-icon-settings") then
    tex:SetAtlas("GM-icon-settings"); tex:SetSize(size + 4, size + 4); return
  end
  tex:SetTexture("Interface\\Buttons\\UI-OptionsButton"); tex:SetSize(size, size)
end

-- 視窗外框：深色面板、標題列（金色強調線、圖示、標題、齒輪、關閉）。標題列高 24，內容從 -24 往下排
-- 層級 HIGH（不蓋住世界地圖、背包）＋點到就移到最上面。onGear 是齒輪的動作，gearTip 是它的滑鼠提示
function UI.Window(f, title, logo, onGear, gearTip)
  UI.box(f)
  f:SetFrameStrata("HIGH")
  f:SetToplevel(true)
  local accent = f:CreateTexture(nil, "ARTWORK")
  accent:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], 1)
  accent:SetPoint("TOPLEFT", 1, -1); accent:SetSize(3, 23)
  local sep = f:CreateTexture(nil, "ARTWORK")
  sep:SetColorTexture(C.EDGE2[1], C.EDGE2[2], C.EDGE2[3], 1)
  sep:SetPoint("TOPLEFT", 1, -24); sep:SetPoint("TOPRIGHT", -1, -24); sep:SetHeight(1)
  local icon = f:CreateTexture(nil, "ARTWORK")
  icon:SetTexture(logo); icon:SetSize(16, 16); icon:SetPoint("TOPLEFT", 10, -4)
  f.titleText = UI.text(f, 13, C.GOLD)
  f.titleText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
  f.titleText:SetText(title)
  local close = CreateFrame("Button", nil, f)
  close:SetSize(22, 22); close:SetPoint("TOPRIGHT", -2, -1)
  close.label = UI.text(close, 16, C.DIM, "CENTER"); close.label:SetPoint("CENTER", 0, 1); close.label:SetText("×")
  close:SetScript("OnEnter", function() paint(close.label, C.TEXT) end)
  close:SetScript("OnLeave", function() paint(close.label, C.DIM) end)
  close:SetScript("OnClick", function() f:Hide() end) -- 直接隱藏：戰鬥中也關得掉
  f.closeBtn = close
  if onGear then
    local g = CreateFrame("Button", nil, f)
    g:SetSize(22, 22); g:SetPoint("RIGHT", close, "LEFT", -2, 0)
    g.icon = g:CreateTexture(nil, "ARTWORK"); g.icon:SetPoint("CENTER"); gearIcon(g.icon, 14)
    g:SetAlpha(.6)
    g:SetScript("OnEnter", function(self)
      self:SetAlpha(1)
      if gearTip then GameTooltip:SetOwner(self, "ANCHOR_TOP"); GameTooltip:AddLine(gearTip); GameTooltip:Show() end
    end)
    g:SetScript("OnLeave", function(self) self:SetAlpha(.6); GameTooltip:Hide() end)
    g:SetScript("OnClick", onGear)
    f.gearBtn = g
  end
  return f
end

-- 齒輪打開的小設定面板：貼在標題列下面、靠右
function UI.Panel(f)
  local p = CreateFrame("Frame", nil, f)
  UI.box(p, C.EDGE2, { .04, .043, .05, .98 })
  p:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -26)
  p:SetFrameLevel(f:GetFrameLevel() + 20)
  p:EnableMouse(true)
  p:Hide()
  return p
end

-- 列表的滑過高亮（列是 Frame，自己顯示／隱藏）
-- 下拉選單：entries = { { 文字, 動作, 目前選的（金字） } }，開在 anchor 下方；再按 anchor 或點外面就關
function UI.Menu(anchor, entries)
  local m = UI.menu
  if not m then
    m = CreateFrame("Frame", nil, UIParent)
    UI.box(m, C.EDGE2); m:SetFrameStrata("FULLSCREEN_DIALOG"); m:EnableMouse(true); m.rows = {}; m:Hide()
    pcall(m.RegisterEvent, m, "GLOBAL_MOUSE_DOWN")
    m:SetScript("OnEvent", function()
      if m:IsShown() and not m:IsMouseOver() and not (m.anchor and m.anchor:IsMouseOver()) then m:Hide() end
    end)
    UI.menu = m
  end
  if m:IsShown() and m.anchor == anchor then m:Hide(); return end
  m.anchor = anchor
  m:SetScale(anchor:GetEffectiveScale() / UIParent:GetEffectiveScale())
  local w = anchor:GetWidth()
  for i, e in ipairs(entries) do
    local r = m.rows[i]
    if not r then
      r = CreateFrame("Button", nil, m); r:SetHeight(20)
      r:SetPoint("TOPLEFT", 1, -1 - (i - 1) * 20); r:SetPoint("RIGHT", -1, 0)
      r.label = UI.text(r, 13, C.TEXT); r.label:SetPoint("LEFT", 8, 0)
      local hl = r:CreateTexture(nil, "HIGHLIGHT"); hl:SetAllPoints(); hl:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], .12)
      m.rows[i] = r
    end
    r.label:SetText(e[1]); paint(r.label, e[3] and C.GOLD or C.TEXT)
    r:SetScript("OnClick", function() m:Hide(); e[2]() end)
    r:Show()
    w = math.max(w, UI.measure(r.label) + 16)
  end
  for i = #entries + 1, #m.rows do m.rows[i]:Hide() end
  m:SetSize(math.ceil(w) + 2, #entries * 20 + 2)
  m:ClearAllPoints(); m:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
  m:Show()
end

-- 改了要重新載入才生效：跳出確認框。「重新載入」是安全按鈕，執行 /reload（插件直接呼叫重新載入會被遊戲擋下）。
-- name 是框的全域名稱（Esc 關閉用，各插件不同）；戰鬥中建立不了安全按鈕，回傳 false 讓呼叫的地方改用聊天框提示
function UI.ReloadPrompt(name, msgText, okLabel, laterLabel)
  if InCombatLockdown() then return false end
  local p = UI.reloadPop
  if not p then
    p = CreateFrame("Frame", name, UIParent)
    p:SetFrameStrata("FULLSCREEN_DIALOG"); p:EnableMouse(true); p:SetPoint("CENTER", 0, 120)
    UI.box(p, C.EDGE2)
    p.text = UI.text(p, 13, C.TEXT, "CENTER"); p.text:SetWordWrap(true); p.text:SetWidth(280); p.text:SetPoint("TOP", 0, -16)
    local ok = CreateFrame("Button", nil, p, "SecureActionButtonTemplate")
    ok:SetAttribute("type", "macro"); ok:SetAttribute("macrotext", "/reload"); ok:RegisterForClicks("AnyUp", "AnyDown")
    ok:SetHeight(22); UI.box(ok, C.BRONZE, { 0, 0, 0, .3 })
    ok.label = UI.text(ok, 13, C.GOLD, "CENTER"); ok.label:SetPoint("CENTER", 0, 0)
    local hl = ok:CreateTexture(nil, "HIGHLIGHT")
    hl:SetPoint("TOPLEFT", 1, -1); hl:SetPoint("BOTTOMRIGHT", -1, 1); hl:SetColorTexture(C.GOLD[1], C.GOLD[2], C.GOLD[3], .12)
    ok:SetPoint("BOTTOMRIGHT", p, "BOTTOM", -4, 14)
    p.ok = ok
    p.later = UI.Button(p, "", function() p:Hide() end)
    p.later:SetPoint("BOTTOMLEFT", p, "BOTTOM", 4, 14)
    if name then table.insert(UISpecialFrames, name) end
    UI.reloadPop = p
  end
  p.text:SetText(msgText); p.ok.label:SetText(okLabel); p.later:SetText(laterLabel)
  local bw = math.ceil(math.max(UI.measure(p.ok.label), UI.measure(p.later.label))) + 28
  p.ok:SetWidth(bw); p.later:SetWidth(bw)
  p:SetSize(312, math.ceil(p.text:GetStringHeight()) + 16 + 16 + 22 + 14)
  p:Show()
  return true
end

function UI.hover(row)
  local t = row:CreateTexture(nil, "BORDER", nil, 1)
  t:SetAllPoints(); t:SetColorTexture(1, 1, 1, .06); t:Hide()
  return t
end
