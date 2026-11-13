-- English (also the fallback for clients without their own locale file)
-- ui: interface text, keyed by the original Chinese text in Core.lua / Data.lua
-- game: patterns for reading English spell descriptions, and English names of the spells and talents in Data.lua / Core.lua
HealHPS_Locales = HealHPS_Locales or {}
HealHPS_Locales.enUS = {
  game = {
    rangeSeps = { "to" },                                -- "Heals ... for 47 to 58."
    damageAfter = "^[%s%a]-damage",                      -- "29 to 34 Holy damage" is damage, not healing
    hot = "(%d+)[%a ]-%s+over%s+%d+%s*sec",               -- "for 45 over 15 sec." / "of 45 damage over 15 sec."
    absorb = "absorb%a*%s+(%d+)",                         -- "absorbing 44 damage"
    single = "[Hh]eal%a*[%a ]-%s+for%s+(%d+)",            -- "heals them for 172"
    tick = "(%d+)%s+every%s+(%d+)", tickAmountFirst = true, -- "for 98 every 2 seconds"
    tickDur = "every%s+%d+%s*%a+%s+for%s+(%d+)%s*sec",   -- "every 2 seconds for 10 sec."
    extra = "another%s+(%d+)",                            -- "and another 98 over 21 sec."
    dur = "over%s+(%d+)%s*sec",                           -- "over 21 sec"
    -- Spell and talent names (used only when the spell ID lookup returns nothing)
    spells = {
      ["聖光術"] = "Holy Light", ["聖光閃現"] = "Flash of Light", ["神聖震擊"] = "Holy Shock",
      ["聖光戒備"] = "Light's Vigil", ["聖光守望"] = "Light's Vigil",
      ["次級治療術"] = "Lesser Heal", ["治療術"] = "Heal", ["快速治療"] = "Flash Heal", ["強效治療術"] = "Greater Heal",
      ["恢復"] = "Renew", ["真言術：盾"] = "Power Word: Shield", ["治療禱言"] = "Prayer of Healing",
      ["懺悟"] = "Penance", ["苦修"] = "Penance", ["癒合禱言"] = "Prayer of Mending", ["愈合禱言"] = "Prayer of Mending",
      ["神聖新星"] = "Holy Nova",
      ["治療之觸"] = "Healing Touch", ["回春術"] = "Rejuvenation", ["癒合"] = "Regrowth", ["愈合"] = "Regrowth",
      ["寧靜"] = "Tranquility", ["野性痊癒"] = "Wild Growth", ["野性成長"] = "Wild Growth",
      ["治療波"] = "Healing Wave", ["次級治療波"] = "Lesser Healing Wave", ["治療鍊"] = "Chain Heal", ["治療鏈"] = "Chain Heal",
      ["激流"] = "Riptide",
      ["治療之光"] = "Healing Light", ["精神治療"] = "Spiritual Healing", ["強化真言術：盾"] = "Improved Power Word: Shield",
      ["自然賜福"] = "Gift of Nature", ["淨化"] = "Purification",
      ["聖光誓約"] = "Oath of Light", ["聖光誓言"] = "Oath of Light",
      ["聖光束縛"] = "Holy Binding", ["神聖束縛"] = "Holy Binding",
      ["綻放"] = "Bloom", ["盛放"] = "Bloom", ["花開"] = "Bloom",
    },
  },
  ui = {
    -- product, chat
    ["|cff4fc3f7阿聖|r|cffd9b25f治療幫手|r "] = "|cff4fc3f7Sheng|r|cffd9b25fHealing|r ",
    ["阿聖治療幫手"] = "Sheng Healing",
    ["|cffff7b7b%s出錯：|r%s　請把這行回報給開發者"] = "|cffff7b7b%s error:|r %s  Please report this line to the developer.",
    -- where an error happened
    ["滑鼠提示"] = "Tooltip", ["分析"] = "Analysis", ["比較表"] = "Table", ["除錯指令"] = "Debug command",
    ["掛上滑鼠提示"] = "Tooltip hook", ["小地圖按鈕"] = "Minimap button",
    -- spell rows (Data.lua labels)
    ["聖光術"] = "Holy Light", ["聖光閃現"] = "Flash of Light", ["神聖震擊"] = "Holy Shock",
    ["聖光戒備→震擊"] = "Light's Vigil > Shock",
    ["次級治療術"] = "Lesser Heal", ["治療術"] = "Heal", ["快速治療"] = "Flash Heal", ["強效治療術"] = "Greater Heal",
    ["恢復"] = "Renew", ["真言術：盾"] = "Power Word: Shield", ["治療禱言"] = "Prayer of Healing", ["懺悟"] = "Penance",
    ["癒合禱言"] = "Prayer of Mending", ["神聖新星（治療）"] = "Holy Nova (heal)",
    ["治療之觸"] = "Healing Touch", ["回春術"] = "Rejuvenation", ["癒合（不含HoT）"] = "Regrowth (direct)", ["癒合"] = "Regrowth",
    ["寧靜"] = "Tranquility", ["野性痊癒"] = "Wild Growth",
    ["治療波"] = "Healing Wave", ["次級治療波"] = "Lesser Healing Wave", ["治療鍊"] = "Chain Heal", ["激流"] = "Riptide",
    -- spell notes (Data.lua)
    ["CD 10s；永恆治療之光也乘震擊"] = "10 sec cooldown; Healing Light also boosts it in Forever",
    ["戒備 CD 6s；只計小隊治療"] = "Vigil 6 sec cooldown; party heal only",
    ["法術書可見 774–910；以降級計算器客戶端為準"] = "Spellbook shows 774–910; client downrank values used",
    ["HoT 總量／15秒"] = "HoT total over 15 sec",
    ["吸收；原生CD4；同目標虛弱靈魂15s（永恆待核）"] = "Absorb; 4 sec base cooldown; Weakened Soul 15 sec per target (unverified in Forever)",
    ["目標及其小隊每人此量"] = "Heals each member of the target's party for this amount",
    ["3×133／跳；CD 12；係數待核"] = "3 × 133 per bolt; 12 sec cooldown; coefficient unverified",
    ["每跳等量；最多5跳；CD 10"] = "Same amount per jump; up to 5 jumps; 10 sec cooldown",
    ["治療分量；係數待核"] = "Healing part only; coefficient unverified",
    ["Forever 確認總量／12秒"] = "Total over 12 sec, confirmed in Forever",
    ["僅直接；HoT 另列"] = "Direct heal only; HoT listed separately",
    ["HoT 91/21s（客戶端）；直接 0.286、HoT 0.497"] = "HoT 91 over 21 sec (client); coefficient 0.286 direct, 0.497 HoT",
    ["引導；每人總量；長CD"] = "Channeled; total per person; long cooldown",
    ["cast 3s＋CD 6（ForeverChanges）；舊 Wiki 瞬發已否"] = "3 sec cast + 6 sec cooldown (ForeverChanges); not instant",
    ["第1跳=基礎；總量1+0.5+0.25"] = "First jump = base; total 1 + 0.5 + 0.25",
    ["僅HoT；CD 12；無瞬發"] = "HoT only; 12 sec cooldown; no direct heal",
    -- situational bonuses
    ["聖光誓約"] = "Oath of Light", ["誓約目標"] = "Oath target",
    ["對誓約目標施放聖光術、聖光閃現、神聖震擊時的固定加成。計入：比較表改用誓約目標的數值。"] =
      "Flat bonus to Holy Light, Flash of Light and Holy Shock on your Oath target. Included: the table uses Oath target values.",
    ["聖光束縛"] = "Holy Binding", ["對他人施放（含自療）"] = "On others (with self-heal)",
    ["快速治療施放在別人身上時，自己也回復同等治療量的 50%。計入：比較表把自療算進快速治療。"] =
      "Flash Heal on someone else also heals you for 50% of the amount. Included: the table adds the self-heal to Flash Heal.",
    ["激流加成"] = "Riptide bonus", ["目標有激流"] = "Target has Riptide",
    ["目標身上有你的激流時，直接對他施放的治療鍊效果 +25%（只算第一跳）。計入：比較表改用這個數值。"] =
      "Chain Heal cast on a target with your Riptide heals 25% more (first jump only). Included: the table uses this value.",
    ["綻放"] = "Bloom", ["含綻放"] = "With Bloom",
    ["回春術、癒合的 HoT 自然結束時，目標再回復你精神 100% 的生命（被驅散只有 50%）。計入：比較表把它算進回春術和癒合（含HoT）。"] =
      "When your Rejuvenation or Regrowth HoT expires, the target heals for 100% of your Spirit (50% if dispelled). Included: the table adds it to Rejuvenation and Regrowth.",
    ["沒學"] = "Not learned", ["計入"] = "Included", ["不計入"] = "Excluded",
    -- talents
    ["讀不到"] = "not found", ["經典"] = "Classic",
    ["%s %d/%d（+%d%%）"] = "%s %d/%d (+%d%%)",
    ["天賦加成"] = "Talent Bonuses", ["沒有偵測到治療加成天賦"] = "No healing talents detected",
    ["治療加成 "] = "Healing bonus ", ["%（手動）"] = "% (manual)",
    ["聖光誓約：讀不到加成量（請執行 /shps debug 回報）"] = "Oath of Light: bonus not found (run /shps debug and report it)",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d"] = "Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d",
    ["綻放：每次 HoT 結束 +"] = "Bloom per HoT expiry: +",
    -- shared bits (symbols: Latin-1 and plain punctuation only, other glyphs turn into boxes)
    ["…"] = "...", ["▼"] = "v ", ["★"] = "*",
    ["："] = ": ", ["、"] = ", ", ["＋"] = " + ", ["（"] = " (", ["）"] = ")", [" ／ "] = " / ",
    [" 等級"] = " Rank ", [" 秒"] = " sec", ["開"] = "On", ["關"] = "Off",
    ["單補"] = "Single", ["群補"] = "Group", ["冷卻"] = "Cooldown", ["救命"] = "Emergency",
    -- analysis names
    ["保持"] = "Keep ", ["鋪"] = "Spread ", ["，救命 "] = ", emergency ",
    ["（停到 %d%%）"] = " (hold until %d%%)", ["（救命 %s）"] = " (emergency %s)",
    ["，坦克快倒時改放 %s"] = ", %s when the tank is low",
    ["戰鬥中不分析"] = "Not available in combat", ["讀不到回藍"] = "Can't read mana regen",
    -- breakdown lines
    ["%d 秒內補完；冷卻 %s 秒"] = "Heals over %d sec; %s sec cooldown",
    ["冷卻 %s 秒"] = "%s sec cooldown",
    ["直接 %s（每秒 %s）＋ %d 秒 %s，輪流 %d 人時每發只跑到 %d%%"] = "Direct %s (%s/s) + %d sec HoT %s; on %d targets each HoT runs %d%%",
    ["直接 %s（每秒 %s）＋ %d 秒 %s（每秒 %s）\n輪流補不同目標時每秒 %s"] = "Direct %s (%s/s) + %d sec HoT %s (%s/s)\nRotating targets: %s/s",
    ["%d 秒內補完；鋪 %d 人"] = "Heals over %d sec; spread on %d targets",
    ["%d 秒內補完；輪流掛不同目標時每秒 %s"] = "Heals over %d sec; rotating targets: %s/s",
    ["同一目標 15 秒一次；輪流上不同目標時每秒 %s"] = "Once per 15 sec per target; rotating targets: %s/s",
    -- spell tooltip
    ["（吸收）"] = " (absorb)", ["（%d人）"] = " (%d targets)", ["|cffd9b25fHPS ／ HPM|r"] = "|cffd9b25fHPS / HPM|r",
    ["降級"] = "Downrank", ["治療效果只算 %d%%"] = "%d%% of Bonus Healing",
    ["★ %s HPS最高"] = "* Best HPS (%s)", ["★ %s HPM最高"] = "* Best HPM (%s)",
    -- window
    ["拖曳調整視窗大小"] = "Drag to resize",
    ["設定"] = "Settings",
    ["技能"] = "Spell", ["等級"] = "Rank", ["有效量"] = "Heal", ["法力"] = "Mana", ["秒"] = "Sec",
    ["%d 級 · 治療效果 %d"] = "Level %d · Bonus Healing %d", [" · 精神 %d"] = " · Spirit %d",
    [" · 回藍 停手 %d／施法 %d（每 5 秒）"] = " · Mana regen: %d idle / %d casting (per 5 s)",
    ["技能提示："] = "Spell tooltip: ", ["精簡"] = "Brief", ["標準"] = "Standard", ["完整"] = "Full",
    ["群補人數 "] = "Group targets ",
    ["HPS＝治療量÷施法時間\n|cff9a9282瞬發算 1.5 秒\n持續治療用持續時間算；群補時算能輪流鋪給幾人\n冷卻技能另列一頁，照施放時算|r"] =
      "HPS = heal ÷ cast time\n|cff9a9282Instant casts count as 1.5 sec\nHoTs use their duration; Group counts how many targets you can keep them on\nCooldown spells have their own tab, per cast|r",
    ["（吸收）|r"] = " (absorb)|r",
    ["這一頁沒有你學會的技能。"] = "No learned spells on this tab.",
    ["|cffffd100★ HPS最高|r %s 等級%d"] = "|cffffd100* Best HPS|r %s Rank %d", ["|cff66ff66★ HPM最高|r %s 等級%d"] = "|cff66ff66* Best HPM|r %s Rank %d",
    ["目前沒有可比較的治療技能（吸收盾不參加比較）"] = "No healing spells to compare (absorbs are excluded)",
    ["（滾輪看更多）"] = "(scroll for more)",
    ["吸收量不是治療量，不參加 HPS／HPM 最高的比較"] = "Absorbs aren't healing and are excluded from best HPS / HPM",
    ["學習等級"] = "Learned at", ["（%d%%）"] = " (%d%%)",
    ["部分數值來自資料表（遊戲讀不到）"] = "Some values come from the data table (not readable in game)",
    -- analysis tab
    ["單坦"] = "Tank", ["團刷"] = "Group",
    ["小怪"] = "Trash", ["王戰"] = "Boss", ["單練"] = "Solo", ["省水"] = "Easy",
    ["群怪"] = "Trash", ["全團技"] = "Raid AoE", ["範圍"] = "AoE", ["點名"] = "Targeted",
    ["詳細"] = "Details",
    ["坦克生命 %d"] = "Tank HP %d", ["每次傷害 %d"] = "Damage per hit %d", ["受傷間隔 %.1f 秒"] = "Hit interval %.1f sec",
    ["戰鬥長度 %d 秒"] = "Fight length %d sec", ["人數 %d"] = "Group size %d", ["成員生命 %d"] = "Member HP %d",
    ["坦克每次傷害 %d"] = "Tank hit %d", ["坦克每次傷害 無"] = "Tank hit: none", ["坦克間隔 %.1f 秒"] = "Tank interval %.1f sec",
    ["範圍每次傷害 %d"] = "AoE hit %d", ["範圍每次傷害 無"] = "AoE hit: none", ["範圍間隔 %.1f 秒"] = "AoE interval %.1f sec",
    ["範圍命中 隨機 %d 人"] = "AoE hits %d random", ["範圍命中 全員"] = "AoE hits everyone",
    ["最省藍"] = "Most efficient", ["最穩定"] = "Most stable", ["撐最久"] = "Lasts longest",
    ["沒有可以補的技能"] = "No healing spells to use", ["沒有可以單補的技能"] = "No single-target heals to use",
    ["|cffffd100最省藍：|r%s"] = "|cffffd100Most efficient:|r %s", ["|cffffd100最穩定：|r%s"] = "|cffffd100Most stable:|r %s",
    ["|cffff6b6b都撐不住：|r最好 %s（%s）"] = "|cffff6b6bNone survive:|r best %s (%s)",
    ["%d 秒滅團"] = "wipe at %d sec", ["倒 %d 人"] = "%d dead",
    ["|cffff6b6b都撐不住：|r最久 %s（撐 %d 秒）"] = "|cffff6b6bNone survive:|r longest %s (%d sec)",
    ["活"] = "Alive", ["倒下 %d 秒"] = "Dead at %d sec", ["滅團 %d 秒"] = "Wipe at %d sec", ["倒 %d 人 %d 秒"] = "%d dead, first at %d sec",
    ["沒藍 %d 秒"] = "OOM at %d sec", ["補滿差 "] = "Short by ", ["剩藍 "] = "Mana left ", ["最低 %d%%"] = "Low %d%%",
    ["每 "] = "Every ", [" 秒一發"] = " sec", ["沒出手"] = "No casts",
    ["不用喝水"] = "No drinking", ["打完要喝水"] = "Drink after", ["可連打 %d 波"] = "%d pulls in a row",
    ["補到"] = "Healed", ["溢補"] = "Overheal", ["施法"] = "Casts", [" 次"] = "", ["、救命 "] = ", emergency ",
    ["倒下"] = "Deaths", ["%d 人，第一人 %d 秒"] = "%d, first at %d sec", ["，坦克或自己倒下"] = ", tank or you died",
    ["低於 30%"] = "Below 30%", ["%d 人秒"] = "%d player-sec", ["戰鬥結束"] = "Fight end",
    ["不喝水連打"] = "Pulls in a row", [" 波"] = "", ["救命 "] = "emergency ",
    ["坦克 %d%%、剩藍 %s"] = "Tank %d%%, mana left %s",
    -- minimap
    ["技能提示的 HPS："] = "Spell tooltip HPS: ",
    ["左鍵：開關比較表"] = "Left-click: toggle the table",
    ["右鍵：開關技能提示的 HPS（目前"] = "Right-click: toggle tooltip HPS (now ",
    ["拖曳：沿著小地圖移動"] = "Drag: move around the minimap",
    -- debug
    ["版本 %s　API：%s　法術書共 %d 個技能"] = "Version %s  API: %s  Spellbook: %d spells",
    ["新版 C_SpellBook"] = "new C_SpellBook", ["舊版"] = "legacy",
    ["職業 %s　等級 %d　治療效果 %d　說明數字：%s　天賦：%s"] = "Class %s  Level %d  Bonus Healing %d  Description values: %s  Talents: %s",
    ["已含治療效果"] = "include Bonus Healing", ["基礎量"] = "base only", ["沒找到"] = "none",
    ["聖光誓約：讀不到加成量。天賦說明："] = "Oath of Light: bonus not found. Talent text: ",
    ["聖光誓約：聖光術 +%d、聖光閃現 +%d、神聖震擊 +%d（%s）"] = "Oath of Light: Holy Light +%d, Flash of Light +%d, Holy Shock +%d (%s)",
    ["比較表已計入"] = "included in the table", ["比較表未計入"] = "not included in the table",
    ["已點天賦："] = "Talents: ", ["有"] = "Yes",
    ["（比較表已計入）"] = " (included in the table)", ["（比較表未計入）"] = " (not included in the table)",
    ["沒偵測到"] = "Not detected",
    ["一個治療技能都沒對上。法術書前幾個技能："] = "No healing spells matched. First spellbook entries: ",
    ["%s：法術書沒找到"] = "%s: not in spellbook",
    ["%s：遊戲名「%s」到等級 %d（%d 個等級有法術ID）　說明解析：%s"] = "%s: game name \"%s\" up to rank %d (%d ranks with spell IDs)  Parsed: %s",
    ["不解析"] = "not parsed", ["失敗："] = "failed: ", ["說明未載入"] = "description not loaded",
    -- slash commands
    ["這個職業沒有治療技能，插件不會運作。"] = "This class has no healing spells; the addon is inactive.",
    ["小地圖按鈕："] = "Minimap button: ", ["隱藏（再輸入 /shps minimap 顯示）"] = "hidden (type /shps minimap to show it)", ["顯示"] = "shown",
    ["治療加成 %："] = "Healing bonus %: ", ["（手動）"] = " (manual)", ["依天賦自動"] = "auto from talents",
    ["吸收加成 %："] = "Absorb bonus %: ", ["群補目標數："] = "Group targets: ",
    ["滑鼠提示："] = "Tooltip: ", ["降級衰減："] = "Downrank penalty: ", ["視窗縮放："] = "Window scale: ",
    ["用法：/shps scale 1.2（0.5～2，目前 "] = "Usage: /shps scale 1.2 (0.5–2, now ",
    ["技能說明數字："] = "Spell description values: ",
    ["已含治療效果（手動）"] = "include Bonus Healing (manual)", ["只有基礎量（手動）"] = "base only (manual)", ["自動判斷"] = "auto",
    ["　目前："] = "  Now: ", ["直接採用說明數字"] = "using description values", ["基礎＋治療效果×係數"] = "base + Bonus Healing × coefficient",
    ["介面語言：%s（/reload 後生效）"] = "UI language: %s (applies after /reload)",
    ["設定已重設"] = "Settings reset",
    ["/shps 開關視窗　/shps pct 數字|auto　/shps absorb 數字|auto　/shps targets 2-10　/shps tip　/shps scale 1.2　/shps minimap　/shps downrank　/shps desc incl|base|auto　/shps lang en|zh|stress|auto（stress＝版面壓力測試，英文加長 35%）　/shps debug　/shps reset"] =
      "/shps toggle window  /shps pct <n>|auto  /shps absorb <n>|auto  /shps targets 2-10  /shps tip  /shps scale 1.2  /shps minimap  /shps downrank  /shps desc incl|base|auto  /shps lang en|zh|stress|auto (stress = layout stress test, English padded 35%)  /shps debug  /shps reset",
  },
}
