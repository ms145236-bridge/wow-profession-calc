-- 繁體中文（也用於沒有專屬語言檔的簡中客戶端）
-- 介面文字就是 Core.lua 裡的鍵（中文原文），所以沒有 ui 表；這裡只放解析技能說明的樣式
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.zhTW = {
  game = {
    rangeSeps = { "至", "到", "to" },   -- 「A 至 B」
    damageBefore = "造成",              -- 範圍前面 18 字內有這個字就是傷害，不是治療
    hot = "總計%s*(%d+)",               -- HoT 總量
    absorb = "吸收%s*(%d+)",
    single = "治療%s*(%d+)%s*點",        -- 單一數字的治療（癒合禱言）
    tick = "每%s*(%d+)%s*秒恢復%s*(%d+)", -- 間隔、每跳量（寧靜）
    tickDur = "持續%s*(%d+)%s*秒",
    extra = "額外的?%s*(%d+)%s*點",      -- 癒合的 HoT 段
    dur = "(%d+)%s*秒內",               -- HoT 持續時間
  },
}
