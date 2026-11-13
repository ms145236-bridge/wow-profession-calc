-- 專業助手：介面語言
-- 程式裡的介面文字一律寫中文原文，用 L["中文"] 取顯示文字：中文介面直接回傳原文，其他語言查 Locales\<語言>.lua 的對照表（查不到也回傳原文）。
-- 新增語言：加一個 Locales\xxXX.lua（NS.locales.xxXX = { ["中文"] = "翻譯" }），列進 toc；資料表的翻譯用「欄位_xxXX」（例如 name_enUS）。
-- 語言在這裡決定一次：預設跟遊戲語言；/sprof lang en|zh|<語言代碼>|auto 存進 ProfLevelCharDB.lang，讀到存檔後（ADDON_LOADED）才套用，所以要 /reload。
-- 偵測專業、讀遊戲文字不看這個設定，永遠照遊戲語言（NS.client）。

local _, NS = ...
NS.locales = NS.locales or {}
local client = GetLocale and GetLocale() or "enUS"
NS.client = client
NS.clientZh = client == "zhTW" or client == "zhCN"

-- 客戶端字型只有自己的文字（中文、韓文、俄文字型以外都是拉丁字母），所以只能切成同一種文字的語言；英文到處都能顯示
local SCRIPT = { zhTW = "zh", zhCN = "zh", koKR = "ko", ruRU = "ru" }
function NS.canShow(code) return code == "enUS" or (SCRIPT[code] or "latin") == (SCRIPT[client] or "latin") end

-- setting：nil／"auto" 跟遊戲語言；"en"、"zh" 或語言代碼（例如 "deDE"）是測試用的強制語言；"stress" 是壓力測試（英文字串加長約 35%）。
-- 查不到的字：墨西哥西文 → 西班牙西文 → 英文；其他非中文語言 → 英文；簡中 → 繁中原文
function NS.applyLang(setting)
  local want = ((setting == "en" or setting == "stress") and "enUS") or (setting == "zh" and NS.clientZh and "zhTW")
    or (setting and NS.locales[setting] and NS.canShow(setting) and setting) or client
  if want == "esMX" and not NS.locales.esMX then want = "esES" end
  if want ~= "zhTW" and not NS.locales[want] then want = "enUS" end
  NS.lang, NS.zh, NS.stress = want, want == "zhTW", setting == "stress"
  NS.gameText = not NS.zh and want == client -- 遊戲 API 回傳的名稱就是介面語言（可以直接拿來顯示）
  NS.chain = (want == "zhTW" and {}) or ((want == "enUS" or want == "zhCN") and { want })
    or (want == "esMX" and { "esMX", "esES", "enUS" }) or { want, "enUS" }
end
NS.applyLang()

-- 壓力測試：每個字串前後加 [ ]、尾巴補 ~，總長多約 35%（色碼不算長度）；3 個字以內的單位、符號不動
local stretched = {}
local function stretch(s)
  if not NS.stress or type(s) ~= "string" then return s end
  if not stretched[s] then
    local n = #(s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("[\128-\191]", ""))
    stretched[s] = n < 4 and s or ("[" .. s .. string.rep("~", math.max(0, math.ceil(n * 0.35) - 2)) .. "]")
  end
  return stretched[s]
end

NS.L = setmetatable({}, { __index = function(_, k)
  for _, code in ipairs(NS.chain) do
    local v = NS.locales[code] and NS.locales[code][k]
    if v then return stretch(v) end
  end
  return stretch(k)
end })

-- 資料表的顯示文字：依查字順序找「欄位_語言」，都沒有用中文欄位
function NS.loc(t, field)
  for _, code in ipairs(NS.chain) do
    local v = t[field .. "_" .. code]
    if v then return stretch(v) end
  end
  return stretch(t[field])
end
