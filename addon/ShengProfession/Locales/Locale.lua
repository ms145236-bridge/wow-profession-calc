-- 專業助手：介面語言
-- 程式裡的介面文字一律寫中文原文，用 L["中文"] 取顯示文字：中文介面直接回傳原文，其他語言查 Locales\<語言>.lua 的對照表（查不到也回傳原文）。
-- 新增語言：加一個 Locales\xxXX.lua（NS.locales.xxXX = { ["中文"] = "翻譯" }），列進 toc；資料表的翻譯用「欄位_xxXX」（例如 name_enUS）。
-- 語言在這裡決定一次：預設跟遊戲語言；/sprof lang en|zh|auto 存進 ProfLevelCharDB.lang，讀到存檔後（ADDON_LOADED）才套用，所以要 /reload。
-- 偵測專業、讀遊戲文字不看這個設定，永遠照遊戲語言（NS.client）。

local _, NS = ...
NS.locales = NS.locales or {}
local client = GetLocale and GetLocale() or "enUS"
if client == "zhCN" then client = "zhTW" end -- 簡中客戶端目前沿用繁中原文（之後有 Locales\zhCN.lua 再拿掉這行）
NS.client = client
NS.clientZh = client == "zhTW"

-- setting：nil／"auto" 跟遊戲語言；"en"、"zh" 是測試用的強制語言。
-- 非中文客戶端的字型沒有中文字（會變成方塊），所以只有中文客戶端能切成中文。
function NS.applyLang(setting)
  local want = (setting == "en" and "enUS") or (setting == "zh" and NS.clientZh and "zhTW") or client
  if want ~= "zhTW" and not NS.locales[want] then want = "enUS" end
  NS.lang, NS.zh = want, want == "zhTW"
  NS.gameText = not NS.zh and want == client -- 遊戲 API 回傳的名稱就是介面語言（可以直接拿來顯示）
end
NS.applyLang()

NS.L = setmetatable({}, { __index = function(_, k)
  local t = NS.locales[NS.lang]
  return t and t[k] or k
end })

-- 資料表的顯示文字：有「欄位_語言」就用，沒有用中文欄位
function NS.loc(t, field)
  return t[field .. "_" .. NS.lang] or t[field]
end
