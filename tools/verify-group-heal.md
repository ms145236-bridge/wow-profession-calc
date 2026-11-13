# 《魔獸世界：永恆》1.60.1 群體治療查證

以永恆客戶端 **1.60.1.70938**、近期伺服器修正和台服法術頁為準。等級欄是可學習／解鎖等級。數值未計裝備、天賦、爆擊、溢補與降階懲罰，另列有等級縮放的提示值。係數用「每名目標、每次實際治療」為單位，週期與跳躍技能另外標明整段或各跳的口徑。服務端腳本的排序、選人或跳數遇到來源衝突時，標【需遊戲實測】。 [Wago 台服 SpellName](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhTW) · [SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [SpellMisc](https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS) · [SpellTargetRestrictions](https://wago.tools/db2/SpellTargetRestrictions/csv?build=1.60.1.70938&locale=enUS) · [ForeverChanges 版本紀錄](https://foreverchanges.pro/patch-notes) · [暴雪 11 月伺服器修正](https://news.blizzard.com/en-us/article/24315281/wow-forever-hotfixes-november-11-2026)

## 各職業主力與人數

| 職業 | 主力群補 | 一次施放的上限與群組 | 來源 |
|---|---|---|---|
| 牧師 | 治療禱言 | 所選目標的小隊，最多 5 名玩家，寵物也可受益。癒合禱言另有最多 5 次治療，可跨小隊。 | [暴雪牧師說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) |
| 德魯伊 | 野性痊癒、寧靜 | 野性痊癒最多涵蓋所選目標小隊的 5 名玩家，寵物也可受益。寧靜涵蓋施法者自己小隊的 5 名玩家。 | [暴雪德魯伊說明](https://news.blizzard.com/en-us/article/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid) · [永恆寧靜](https://www.wowhead.com/forever/spell=9863/tranquility) |
| 薩滿 | 治療鍊 | 3 個目標，首跳加 2 次跳躍。跨隊跳躍條件待正式服核對。 | [Wowhead 永恆治療鍊](https://www.wowhead.com/forever/changes/spellbook/shaman/chain-heal) · [Beta 跨小隊觀察](https://us.forums.blizzard.com/en/wow/t/resto-shaman-feedback/2380322) |
| 聖騎士 | 聖光戒備 → 神聖震擊 | 每次觸發最多涵蓋標記所在小隊的 5 名玩家，技能文字包含被標記者。可在不同小隊各預掛一個標記。 | [暴雪跨隊預掛說明](https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin#holy-talents) · [台服聖光戒備](https://www.wowhead.com/forever/tw/spell=1311595) |

## 1. 牧師

### 治療禱言（Prayer of Healing）

施法距離 40 碼，選擇一位友方團員，治療其所屬小隊中距該目標 40 碼內的隊員。能選其他小隊作為整次施法的受益小隊，每次至多 5 名玩家。藍帖也列小隊寵物，Beta 測試回報其他小隊寵物有漏補情況，且直接選寵物起手會失敗。寵物計入後的硬上限及正式服跨組寵物行為【需遊戲實測】。按小隊與範圍選擇，沒有最低血量排序的證據，無跳躍、無衰減。直接治療可爆擊。神聖延伸提高半徑 10%／20%，名目 44／48 碼，未更動 40 碼起手距離。開發者也確認角色起手／讀條完成有距離寬限，兩位隊員距離在邊界時仍可能只有被選中的人吃到。遮蔽物對其他受益者的影響【需遊戲實測】。 [暴雪職業說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) · [Beta 距離與寵物實測及開發者回覆](https://github.com/ClassicWoWCommunity/forever-bugs/issues/266) · [神聖延伸](https://www.wowhead.com/forever/changes/talents/priest/holy-reach) · [ForeverChanges 牧師](https://foreverchanges.pro/spellbook/priest)

| 階／法術 ID | 學習等級 | 法力 | 施法／冷卻 | 每人 DB2 基礎範圍 | Wowhead 台服提示 | 每人治療係數 | 來源 |
|---|---:|---:|---|---:|---:|---:|---|
| 1／596 | 30 | 410 | 3 秒／0 | 172–184 | 179–191 | 28.6% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=596) |
| 2／996 | 40 | 560 | 3 秒／0 | 257–273 | 266–282 | 28.6% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=996) |
| 3／10960 | 50 | 770 | 3 秒／0 | 390–412 | 401–424 | 28.6% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=10960) |
| 4／10961 | 60 | 1,030 | 3 秒／0 | 567–599 | 581–612 | 28.6% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=10961) |
| 5／25316 | 60 | 1,070 | 3 秒／0 | 631–667 | 646–681 | 28.6% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=25316) · [5 階典籍](https://www.wowhead.com/forever/tw/item=21287) |

### 神聖新星（Holy Nova，治療部分）

施法者為中心，治療 10 碼內自己的小隊，至多 5 名玩家。治療子法術的目標類型為施法者的小隊區域，沒有低血量排序的證據，也沒有跳躍或衰減。可爆擊。神聖延伸名目半徑為 11／12 碼。寵物及可被計入的其他召喚單位【需遊戲實測】。治療與傷害都不產生仇恨。第 1 階由神聖天賦解鎖。表內天賦等級按一般點數列。傳承 Talented 可提前取得天賦點，與個別技能等級門檻是否一起提前【需遊戲實測】。 [暴雪傳承說明](https://news.blizzard.com/en-us/article/24307383/get-to-know-the-world-of-warcraft-forever-legacy-system) · [Wowhead 永恆牧師](https://www.wowhead.com/forever/guide/classes/priest/holy/healer-abilities) · [神聖延伸](https://www.wowhead.com/forever/spell=27790/holy-reach) · [ForeverChanges 牧師](https://foreverchanges.pro/spellbook/priest)

| 階／施放→治療 ID | 學習等級 | 法力 | 施法／冷卻 | 每人 DB2 基礎範圍 | Wowhead 台服提示 | 每人治療係數 | 來源 |
|---|---:|---:|---|---:|---:|---:|---|
| 1／15237→23455 | 20 | 185 | 瞬發／0 | 47–55 | 50–57 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=15237) · [治療](https://www.wowhead.com/forever/tw/spell=23455) |
| 2／15430→23458 | 28 | 290 | 瞬發／0 | 77–87 | 80–90 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=15430) · [治療](https://www.wowhead.com/forever/tw/spell=23458) |
| 3／15431→23459 | 36 | 400 | 瞬發／0 | 108–124 | 112–128 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=15431) · [治療](https://www.wowhead.com/forever/tw/spell=23459) |
| 4／27799→27803 | 44 | 520 | 瞬發／0 | 147–171 | 151–175 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=27799) · [治療](https://www.wowhead.com/forever/tw/spell=27803) |
| 5／27800→27804 | 52 | 635 | 瞬發／0 | 221–255 | 226–260 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=27800) · [治療](https://www.wowhead.com/forever/tw/spell=27804) |
| 6／27801→27805 | 60 | 750 | 瞬發／0 | 288–334 | 294–339 | 10.7% | [施放](https://www.wowhead.com/forever/tw/spell=27801) · [治療](https://www.wowhead.com/forever/tw/spell=27805) |

### 癒合禱言（Prayer of Mending）

40 碼指定第一個持有者。持有者受到傷害或非週期治療時，治療一次並消耗一層，轉給該持有者 20 碼內的另一名小隊或團隊成員，可跨小隊。每位持有者的光環期限 30 秒。同一牧師只可維持一條，暴雪亦寫明每個目標只可有一個癒合禱言。暴雪明定每次施放最多 **5 次治療事件**，所以起始目標治療後，最多再轉給他人 4 次並產生治療。提示把 5 寫成跳躍次數，DB2 三階的初始層數亦為 5，計算上限以 5 次為準。無已知逐跳衰減。每次只補當前持有者，是否依缺血量、能否折返或跳寵物、同時多候選的排序【需遊戲實測】。治療子法術 401863／1313379／1313381 為直接治療且無禁爆旗標，推定可爆擊，正式服事件、實際倍率和爆擊率來源【需遊戲實測】。 [暴雪 5 次總量及觸發說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior#holy) · [ForeverChanges 牧師](https://foreverchanges.pro/class/priest) · [Wago SpellAuraOptions](https://wago.tools/db2/SpellAuraOptions/csv?build=1.60.1.70938&locale=enUS) · [治療子法術](https://www.wowhead.com/forever/spell=401863/prayer-of-mending) · [Wago 跳躍半徑表](https://wago.tools/db2/SpellRadius/csv?build=1.60.1.70938&locale=enUS)

| 階／施放 ID | 學習等級 | 法力 | 施法／冷卻 | 每次固定基礎量 | 5 次非爆基礎量 | 每次／完整係數 | 來源 |
|---|---:|---:|---|---:|---:|---:|---|
| 1／401859 | 40（神聖 31 點） | 210 | 瞬發／10 秒 | 172 | 860 | 42.9%／214.5% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=401859) |
| 2／1240826 | 50 | 305 | 瞬發／10 秒 | 298 | 1,490 | 42.9%／214.5% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=1240826) |
| 3／1240827 | 60 | 390 | 瞬發／10 秒 | 413 | 2,065 | 42.9%／214.5% | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=1240827) |

### 光束泉（Lightwell）

改成可向訓練師學習。泉放在自己腳邊，場上可用 3 分鐘或總共 5 次點擊，隊伍／團隊玩家自行點擊，包含其他小隊，一次給點擊者一個 HoT，每 2 秒一跳。無自動選缺血、無跳躍或衰減。受擊可能中止該玩家 HoT。召喚效果半徑欄是 2 碼，HoT 子法術的互動 RangeIndex 12 是 5 碼，正式服可點擊距離【需遊戲實測】。三階 HoT 均有週期爆擊旗標，實際爆擊率由牧師或點擊者提供【需遊戲實測】。實際 HoT 效果的 DB2 治療係數為 0，應看 HoT 而非召喚物件效果，伺服器是否另加治療強度【需遊戲實測】。 [ForeverChanges 職業法術](https://foreverchanges.pro/spellbook/priest) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago SpellMisc](https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS) · [Wago SpellRange](https://wago.tools/db2/SpellRange/csv?build=1.60.1.70938&locale=enUS)

| 階／召喚→HoT ID | 學習等級 | 法力 | 施法／冷卻 | 每跳／10 秒總量 | 來源 |
|---|---:|---:|---|---:|---|
| 1／724→7001 | 40 | 225 | 1.5 秒／600 秒 | 160／800 | [召喚](https://www.wowhead.com/forever/tw/spell=724) · [HoT](https://www.wowhead.com/forever/tw/spell=7001) |
| 2／27870→27873 | 50 | 295 | 1.5 秒／600 秒 | 233／1,165 | [召喚](https://www.wowhead.com/forever/tw/spell=27870) · [HoT](https://www.wowhead.com/forever/tw/spell=27873) |
| 3／27871→27874 | 60 | 365 | 1.5 秒／600 秒 | 320／1,600 | [召喚](https://www.wowhead.com/forever/tw/spell=27871) · [HoT](https://www.wowhead.com/forever/tw/spell=27874) |

### 治療之環與其他雙／多目標治療

- **治療之環（Circle of Healing）**：70938 有 401946 法術及 402842 授予法術，但 402842 指向 399967 手部符文技能，符合探索賽季來源。永恆 70938 職業法術與天賦清單未見可取得版本，不納入團刷。 [Wowhead 永恆紀錄](https://www.wowhead.com/forever/tw/spell=401946) · [Wago 法術效果](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [ForeverChanges 牧師](https://foreverchanges.pro/class/priest)
- **神聖束縛（Holy Binding，1328569→1328570）**：神聖第 4 列單點被動，最早 25 級。11/2 改動移除舊主動 Binding Heal。對另一位盟友施放快速治療時額外回補自己 50%，最多兩名玩家。沒有另外法力、施法、冷卻、範圍或獨立係數，沿用快速治療的 40 碼起手與單一指定目標。快速治療本身可爆，回補自己的 1328570 有禁止爆擊旗標。按有效量還是含過量的原始量取 50%【需遊戲實測】。 [暴雪 11/2 更新](https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696/9) · [Wowhead 天賦](https://www.wowhead.com/forever/tw/spell=1328569) · [Wowhead 回補](https://www.wowhead.com/forever/spell=1328570/holy-binding)
- **吸血鬼的擁抱（Vampiric Embrace，15286）**：暗影 16 點天賦，正常點數約 25 級可點，DB2 法術級別欄列 30，提早點天賦能否立刻施放【需遊戲實測】。40 法力、瞬發、30 秒冷卻、30 碼指定敵人、持續 30 秒。將自身對該敵人的暗影法術傷害按 20% 回補自己小隊，名目至多 5 玩家，無跳躍或缺血排序。沒有獨立治療係數，治療回補禁止爆擊，傷害爆擊仍可提高轉化前的傷害量。友方接收半徑及寵物【需遊戲實測】。 [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=15286) · [ForeverChanges 牧師](https://foreverchanges.pro/class/priest) · [暴雪禁爆修正](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Vampiric%20Embrace%20Healing%20can%20no%20longer)

## 2. 德魯伊

### 野性痊癒（Wild Growth）

3 秒施法，冷卻 6 秒，施放距離 40 碼。自然主義 1–5 點依序減 0.1–0.5 秒，11/10 熱修後自然迅捷可使其瞬發。選任一小隊或團隊成員，再以被選者為中心治療該玩家的小隊，5 個玩家席位（含選中者），官方另明列寵物。技能提示及治療效果的第二半徑欄 `SpellRadius ID 524` 均為 43.5 碼，Wowhead 的效果細節同頁另顯示 15 碼，DB2 的第二個 dummy 效果確實有 15 碼半徑（ID 18）。實際距離邊界、寵物是否另占名額及總單位硬上限【需遊戲實測】。目前資料支持指定小隊的範圍覆蓋，沒有依缺血量排序的說明，實際候選篩選【需遊戲實測】。 [暴雪職業深度介紹](https://news.blizzard.com/en-us/article/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid#restoration) · [ForeverChanges 德魯伊](https://foreverchanges.pro/class/druid) · [Wago 70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago 70938 SpellRadius](https://wago.tools/db2/SpellRadius/csv?build=1.60.1.70938&locale=enUS) · [11/10 熱修](https://worldofwarcraft.blizzard.com/en-us/news/24315281/wow-forever-hotfixes-november-11-2026)

| 階／法術 ID | 學習等級 | 法力 | DB2 每跳基準 | 台服提示總量／人 | 衰減後實際治療 | 來源 |
|---|---:|---:|---:|---:|---|---|
| 1／408120 | 40（恢復 31 點天賦，一般點數進度） | 550 | 40 | 336／7 秒 | 7 跳各值與實收總量【需遊戲實測】 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=408120/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92) |
| 2／1238214 | 50 | 755 | 60 | 493／7 秒 | 7 跳各值與實收總量【需遊戲實測】 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=1238214/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92) |
| 3／1238215 | 60 | 1,050 | 97 | 769／7 秒 | 7 跳各值與實收總量【需遊戲實測】 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=1238215/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92) |

每秒一跳，共七跳，各跳可爆擊，沒有跨目標跳躍。暴雪確認同一目標的治療量逐跳遞減。客戶端只列週期基準、每級成長 1.0／1.3／1.6、每跳係數和伺服器腳本標示。台服提示總量屬於頁面顯示值，未取得逐跳序列。70938 三階每跳的治療加成係數欄由 0.033 提高到 **0.066**，等量七跳的帳面係數為 0.462。衰減是否也乘到加成部分、逐跳取整、實際全程係數和跨施法者的同目標疊加【需遊戲實測】。請用固定裝備與天賦，對持續缺血的同一目標收集七筆未爆擊的 `SPELL_PERIODIC_HEAL`，再更換已知治療加成的裝備重測。 [暴雪職業說明](https://news.blizzard.com/en-us/article/24301515) · [暴雪爆擊修正](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Wild%20Growth%20can%20land%20critical%20hits) · [Wago 70888 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70888&locale=enUS) · [Wago 70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wowhead 係數熱修](https://www.wowhead.com/forever/news/restoration-druid-change-to-wild-growth-in-wow-forever-383851) · [熱修快取對照](https://github.com/wowsims/forever/pull/954)

### 寧靜（Tranquility）

施法者為中心，半徑 **20 碼**，覆蓋自己的小隊，最多 **5 名玩家**，含施法者。不跨團隊小隊，沒有跳躍、衰減或缺血排序。寵物是否可一併補、額外單位上限【需遊戲實測】。DB2 及逐階技能卡均為 **10 秒引導，每 2 秒一跳**，未中斷按 5 跳估算。冷卻 300 秒，強化寧靜 1／2 點降為 210／120 秒。每跳治療加成 **0.067**，5 跳每人 **0.335**。各跳可爆擊，是否獨立擲骰【需遊戲實測】。 [暴雪寧靜天賦](https://news.blizzard.com/en-us/article/24301515) · [暴雪寧靜爆擊修正](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Tranquility%20can%20land%20critical%20hits) · [Wago SpellDuration](https://wago.tools/db2/SpellDuration/csv?build=1.60.1.70938&locale=enUS) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS)

| 階／法術 ID | 等級 | 法力 | DB2 每跳／每人全程 | 台服提示每跳／每人全程 | 來源 |
|---|---:|---:|---:|---:|---|
| 1／740 | 30 | 375 | 87／435 | 91／455 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=740/%E5%AF%A7%E9%9D%9C) |
| 2／8918 | 40 | 505 | 129／645 | 133／665 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8918/%E5%AF%A7%E9%9D%9C) |
| 3／9862 | 50 | 695 | 196／980 | 201／1,005 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9862/%E5%AF%A7%E9%9D%9C) |
| 4／9863 | 60 | 925 | 285／1,425 | 291／1,455 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9863/%E5%AF%A7%E9%9D%9C) |

### 回春術（Rejuvenation）／癒合（Regrowth）

兩招每次均由玩家選 **1 名友方**，40 碼，可逐個手動覆蓋各小隊。回春術瞬發、癒合 2 秒，皆無獨立冷卻，基本公共冷卻 1.5 秒，沒有自動分配、跳躍或衰減。回春術每 3 秒一跳，12 秒共四跳，係數每跳 0.20／全程 0.80。癒合先給直接治療（係數 0.286），每 3 秒一跳，21 秒共七跳（每跳 0.071／全程 0.497）。兩招的 HoT 與癒合直接段都可爆擊。自然光采延長回春術 3 秒、癒合 6 秒。迅癒只用自己施加的回春術或癒合，且不消耗該 HoT。10/15 藍帖已修正高階回春術妨礙另一位德魯伊同時施放的問題。癒合跨施法者的同階、異階疊加與刷新邊界【需遊戲實測】。 [Wowhead 回春術](https://www.wowhead.com/forever/tw/spell=25299) · [Wowhead 癒合](https://www.wowhead.com/forever/tw/spell=9858) · [ForeverChanges 德魯伊](https://foreverchanges.pro/class/druid) · [暴雪回春術疊加修正](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=preventing%20other%20Druids) · [回春與癒合 HoT 玩家實測](https://github.com/ClassicWoWCommunity/forever-bugs/issues/396)

| 技能階／ID | 等級 | 法力 | 直接治療 DB2（台服提示） | 每跳／完整 HoT 基礎量 | 來源 |
|---|---:|---:|---:|---:|---|
| 癒合 1／8936 | 12 | 70 | 80–94（89–103） | 13／91 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8936) |
| 癒合 2／8938 | 18 | 125 | 153–175（165–188） | 22／154 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8938) |
| 癒合 3／8939 | 24 | 170 | 219–251（235–266） | 32／224 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8939) |
| 癒合 4／8940 | 30 | 210 | 292–330（310–348） | 42／294 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8940) |
| 癒合 5／8941 | 36 | 250 | 370–418（391–438） | 52／364 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8941) |
| 癒合 6／9750 | 42 | 305 | 474–534（498–557） | 68／476 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9750) |
| 癒合 7／9856 | 48 | 370 | 608–682（635–708） | 88／616 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9856) |
| 癒合 8／9857 | 54 | 445 | 771–863（801–893） | 113／791 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9857) |
| 癒合 9／9858 | 60 | 525 | 965–1077（999–1111） | 142／994 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9858) |
| 回春術 1／774 | 4 | 25 | — | 8／32 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=774) |
| 回春術 2／1058 | 10 | 40 | — | 12／48 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=1058) |
| 回春術 3／1430 | 16 | 75 | — | 23／92 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=1430) |
| 回春術 4／2090 | 22 | 105 | — | 32／128 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=2090) |
| 回春術 5／2091 | 28 | 135 | — | 42／168 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=2091) |
| 回春術 6／3627 | 34 | 160 | — | 51／204 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=3627) |
| 回春術 7／8910 | 40 | 195 | — | 71／284 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=8910) |
| 回春術 8／9839 | 46 | 235 | — | 94／376 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9839) |
| 回春術 9／9840 | 52 | 280 | — | 124／496 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9840) |
| 回春術 10／9841 | 58 | 335 | — | 161／644 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=9841) |
| 回春術 11／25299 | 60 | 360 | — | 194／776 | [Wowhead 永恆台服](https://www.wowhead.com/forever/tw/spell=25299) |

## 3. 薩滿

### 治療鍊（Chain Heal）

各階 2.5 秒施法，無獨立冷卻，第一目標施法距離 40 碼。每次最多 **3 個目標**，手選第一目標再跳 2 次。DB2 的 `EffectChainAmplitude=0.5`，後續按 100% → 50% → 25% 衰減。未計溢補、爆擊及目標專屬增益時，打滿三人合計約 175% 的首跳。每階首跳治療加成係數 **71.4%**，依衰減折算後兩跳 **35.7%／17.85%**，三跳合計 124.95%。各目標的直接治療可爆擊。逐跳取整、前一跳爆擊是否影響下一跳的原始值【需遊戲實測】。 [Wago 70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago 70938 SpellMisc](https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS) · [Wowhead 永恆階級比較](https://www.wowhead.com/forever/changes/spellbook/shaman/chain-heal) · [ForeverChanges 薩滿](https://foreverchanges.pro/class/shaman)

| 階／法術 ID | 學習等級 | 法力 | 70938 DB2 首跳原始範圍 | Wowhead 台服 60 級首跳提示 | 來源 |
|---|---:|---:|---:|---:|---|
| 1／1064 | 40 | 260 | 233–269 | 246–281 | [Wowhead 台服 1064](https://www.wowhead.com/forever/tw/spell=1064) · [台服提示資料](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=10) |
| 2／10622 | 46 | 315 | 312–358 | 326–372 | [Wowhead 台服 10622](https://www.wowhead.com/forever/tw/spell=10622) |
| 3／10623 | 54 | 405 | 458–522 | 474–539 | [Wowhead 台服 10623](https://www.wowhead.com/forever/tw/spell=10623) · [台服提示資料](https://nether.wowhead.com/forever/tooltip/spell/10623?locale=10) |

- **小隊與選人。** 永恆台服技能文字保留「對隊伍成員施放則跳其他隊伍成員」。永恆 Beta 薩滿玩家回報在團隊中實際可以跨小隊。團隊中從自己小隊起跳與從其他小隊起跳時的精確候選池、能否跳滿血、依絕對缺血量或缺血比例排序、寵物與視線規則【需遊戲實測】。經典 1.12 曾明載按絕對缺血量並優先合法團隊目標，僅作對照。 [Wowhead 台服技能說明](https://www.wowhead.com/forever/tw/spell=10622) · [永恆 Beta 玩家回報](https://us.forums.blizzard.com/en/wow/t/resto-shaman-feedback/2380322) · [經典 1.12 更新紀錄](https://warcraft.wiki.gg/wiki/Patch_1.12#Shaman)
- **跳躍距離。** 40 碼是施法者到第一目標的射程，70938 的治療效果未填跳距欄位。永恆的實際逐跳距離【需遊戲實測】，可用 10／12.5 碼作測試分界。12.5 碼見於巫妖王 3.2.0 更新記錄，勿套成永恆值。 [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [各版本跳距沿革](https://warcraft.wiki.gg/wiki/Chain_Heal#Patch_changes)
- **額外跳躍。** 資料仍有協和同調（Coherence，415096）提供不同跳數／衰減的說明。該 ID 在探索賽季已存在，70938 的薩滿天賦沒有此節點，無永恆玩家已取得的證據。團刷基準維持 3 人、50% 衰減。 [經典探索賽季 415096](https://www.wowhead.com/classic/spell=415096/coherence) · [Wago TraitDefinition](https://wago.tools/db2/TraitDefinition/csv?build=1.60.1.70938&locale=enUS) · [ForeverChanges 薩滿天賦](https://foreverchanges.pro/talents/shaman)

### 激流（Riptide）與治療鍊

恢復系 31 點天賦解鎖第 1 階，需治療之路。瞬發，40 碼，單一手選友方目標，可直接施於其他小隊成員。每 3 秒一跳，共 15 秒／5 跳，冷卻 12 秒。已移除初始治療，HoT 可爆擊，治療加成係數每跳 **10%**、五跳合計 **50%**。招魂師 5 件（1301713）另縮短 1 秒冷卻。 [暴雪 11/2 開發公告](https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696/9) · [ForeverChanges 薩滿](https://foreverchanges.pro/class/shaman) · [Wago 70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wowhead 套裝效果](https://www.wowhead.com/forever/tw/spell=1301713)

| 階／法術 ID | 學習等級 | 法力 | DB2 每跳／5 跳原始總量 | 台服提示總量 | 來源 |
|---|---:|---:|---:|---:|---|
| 1／408521 | 40 | 150 | 89／445 | 445 | [Wowhead 台服 408521](https://www.wowhead.com/forever/tw/spell=408521) |
| 2／1239242 | 50 | 180 | 115／575 | 575 | [Wowhead 台服 1239242](https://www.wowhead.com/forever/tw/spell=1239242) |
| 3／1239243 | 60 | 230 | 161／805 | 953（此階 DB2 有每級數值欄） | [Wowhead 台服 1239243](https://www.wowhead.com/forever/tw/spell=1239243) · [台服提示資料](https://nether.wowhead.com/forever/tooltip/spell/1239243?locale=10) |

你的激流仍在 **治療鍊的直接施放目標** 上時，技能文字給該施法 **+25%**。只在第二／三目標碰到激流的情況，技能文字不授予加成。第一目標觸發後，+25% 是否只提高其收到的治療，還是會傳給後兩跳的計算，以及 HoT 是否被消耗，【需遊戲實測】。台服文字沒有提及消耗，70938 把加成記為伺服器處理的 Dummy 光環，不能由該欄解出跳躍行為。以普通首跳未爆治療 H 為例，現有資料至少支持首跳 1.25H，後兩跳仍有 0.50H／0.25H 或 0.625H／0.3125H 兩種待驗情形。可比較同樣三人且維持缺血的普通治療鍊、首目標有激流、第二目標有激流、首目標有其他薩滿的激流。 [Wowhead 台服技能文字](https://www.wowhead.com/forever/tw/spell=408521) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [暴雪薩滿職業公告](https://news.blizzard.com/en-gb/article/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman)

### 治療之泉圖騰（Healing Stream Totem）

瞬發，無獨立冷卻，需水之圖騰。以圖騰為圓心，30 碼內自己的小隊成員，玩家最多 **5 人（含薩滿）**。每 2 秒一次，圖騰可存續 5 分鐘。範圍內小隊成員同時吃治療，沒有跳躍、衰減或按缺血排序的名額競爭。寵物是否另算及首末跳確切時間【需遊戲實測】。各階治療加成係數 **2.2%／每人每跳**。恢復圖騰（16187）各點提高總治療 10%／20%／30%／40%／50%，開發者確認已修正為連治療加成部分也乘上。實際治療光環帶週期爆擊旗標，Beta 玩家在元素／增強看到爆擊，恢復未觀察到，正式服各專精及圖騰的爆擊率繼承【需遊戲實測】。 [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wowhead 治療光環](https://www.wowhead.com/forever/spell=6371/healing-stream) · [ForeverChanges 薩滿](https://foreverchanges.pro/class/shaman) · [恢復圖騰實測與修正](https://github.com/ClassicWoWCommunity/forever-bugs/issues/291) · [Beta 逐專精觀察](https://us.forums.blizzard.com/en/wow/t/beta-resto-shaman-recap/2372793)

| 階／召喚 ID → 治療 ID | 學習等級 | 法力 | 每人每 2 秒固定治療 | 來源 |
|---|---:|---:|---:|---|
| 1／5394 → 5672 | 20 | 40 | 5 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=5394) |
| 2／6375 → 6371 | 30 | 50 | 6 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=6375) |
| 3／6377 → 6372 | 40 | 60 | 7 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=6377) |
| 4／10462 → 10460 | 50 | 70 | 9 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=10462) |
| 5／10463 → 10461 | 60 | 80 | 11 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=10463) |

### 法力之潮圖騰（Mana Tide Totem）

瞬發，冷卻 5 分鐘，需水之圖騰。以圖騰為圓心 30 碼內自己的小隊，玩家最多 **5 人（含薩滿）**，回藍實際受益者須使用法力。不跨團隊小隊。每 3 秒同時回藍，技能文字 12 秒，DB2 圖騰存續欄為 13 秒且技能文字明確減 1 秒。表中總量按 4 跳計，首末脈衝和滿階正式服實收總量【需遊戲實測】。這是固定法力回復，無治療量、治療加成係數、爆擊、跳躍、衰減或按缺藍排序。第一階由恢復第 16 點天賦解鎖，藍帖列 25 級，技能頁的 1 級是原始門檻。早期 Beta 曾未正確記錄回藍，開發者確認當時回藍有生效並修復紀錄和特效。 [暴雪四階學習等級](https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696#:~:text=Added%20an%20additional%20Rank%20of%20Mana%20Tide%20Totem) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago SpellDuration](https://wago.tools/db2/SpellDuration/csv?build=1.60.1.70938&locale=enUS) · [玩家紀錄與開發者回覆](https://github.com/ClassicWoWCommunity/forever-bugs/issues/231)

| 階／召喚 ID → 回藍 ID | 學習等級 | 施放耗藍 | 每人每 3 秒／4 跳總回藍 | 來源 |
|---|---:|---:|---:|---|
| 1／16190 → 16191 | 25（天賦） | 10 | 88／352 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=16190) |
| 2／17354 → 17355 | 38 | 20 | 133／532 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=17354) |
| 3／17359 → 17360 | 48 | 30 | 197／788 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=17359) |
| 4／1325256 → 1325257 | 58 | 60 | 290／1,160 | [Wowhead 台服](https://www.wowhead.com/forever/tw/spell=1325256) |

## 4. 聖騎士

### 聖光戒備（Light’s Vigil）

神聖系 31 點天賦，前置神聖震擊。**標記施法 1.5 秒、冷卻 6 秒、施放距離 40 碼、標記 30 秒**。自己下一次對該友方施放的神聖震擊引發一次額外群補，該次震擊不開始冷卻。施放標記本身沒有治療，也沒有重置既有神聖震擊冷卻的說明。神聖震擊本身瞬發、基礎冷卻 10 秒，實際花費依所用階數為 160／225／275／325。11/2 藍帖移除敵方分支與其返藍。 [暴雪職業說明](https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin#holy-talents) · [11/2 藍帖](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Light%E2%80%99s%20Vigil%20is%20now%20only%20usable) · [ForeverChanges 聖騎士](https://foreverchanges.pro/class/paladin) · [Wago SpellPower](https://wago.tools/db2/SpellPower/csv?build=1.60.1.70938&locale=enUS)

| 階／學習等級 | 標記 ID → 治療 ID | 標記法力 | 70938 每人治療，基準等級 | 台服 Wowhead 60 級提示，每人 | 係數／人 | 來源 |
|---|---|---:|---:|---:|---:|---|
| 1／40（天賦） | 1310911 → 1310912 | 730 | 315–333 | 326–344 | 14.3% | [台服 1 階](https://www.wowhead.com/forever/tw/spell=1310911) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) |
| 2／50 | 1311590 → 1311591 | 1,000 | 473–501 | 487–514 | 14.3% | [台服 2 階](https://www.wowhead.com/forever/tw/spell=1311590) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) |
| 3／60 | 1311595 → 1311596 | 1,340 | 684–724 | 700–740 | 14.3% | [台服 3 階](https://www.wowhead.com/forever/tw/spell=1311595) · [實際治療法術](https://www.wowhead.com/forever/spell=1311596/lights-vigil) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) |

- 70938 三個子法術的基礎中心值 324／487／704，依 Variance 約 0.056213 換算基準區間。每級縮放欄另有 1.2／1.5／1.8，所以台服頁的 60 級顯示與基準區間分列。計算時應分開計標記群補及觸發用的單體神聖震擊，耗魔合計兩次。 [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [台服 3 階](https://www.wowhead.com/forever/tw/spell=1311595)
- 群補以**被標記者**為中心，半徑 **40 碼**，治療被標記者及其小隊成員。一次覆蓋 1 個小隊，滿隊最多 **5 名玩家**，同一聖騎每小隊可預掛 1 個，可選其他小隊來準備。技能沒有跳躍或衰減，也沒有低血量排序的描述。寵物是否涵蓋、個別目標的視線與滿血事件、標記者是否同時收到兩筆治療在正式服【需遊戲實測】。官方文字包含標記者，早期玩家曾質疑其是否只收到震擊，該討論沒有逐目標紀錄。 [台服技能](https://www.wowhead.com/forever/tw/spell=1311595) · [治療子法術半徑](https://www.wowhead.com/forever/spell=1311596/lights-vigil) · [Wago SpellRadius（23）](https://wago.tools/db2/SpellRadius/csv?build=1.60.1.70938&locale=enUS) · [早期玩家觀察](https://eu.forums.blizzard.com/en/wow/t/need-to-talk-about-healer-design-in-forever-hpal-in-particular/633212)
- 群補可爆擊。三個子法術為直接治療且未禁爆，暴雪也將其治療爆擊列入啟發。神聖強化滿點對神聖治療的爆擊加成提高 50%，按基本 1.5 倍推算為 1.75 倍。群補各成員是否獨立擲骰、啟發是否每名爆擊各返一次，以及聖光誓言／無垠之光對觸發群補的連帶影響【需遊戲實測】。 [暴雪啟發說明](https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin#holy-talents) · [ForeverChanges 聖騎士](https://foreverchanges.pro/class/paladin) · [Wago SpellMisc](https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS)
- 核對正式服神聖天賦與法術書，沒有查到另一個永恆新增的聖騎士直接群補。聖光誓言（Oath of Light，1328548）每位聖騎只選 1 個對象，強化對其施放的聖光術、聖光閃現與神聖震擊。聖光審判則讓攻擊被審判敵人的個別攻擊者機率回血，應依攻擊事件估算。 [11/2 藍帖](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=New%20Talent%20Oath%20of%20Light) · [Wowhead 台服神聖技能](https://www.wowhead.com/forever/tw/guide/classes/paladin/holy/healer-abilities) · [聖光審判效果](https://www.wowhead.com/forever/spell=20346/judgement-of-light)

## 5. 小隊、團隊與缺血排序

40 人團隊可分成 8 個小隊，每隊最多 5 名玩家。以下的 5 是玩家席位。暴雪對治療禱言、野性痊癒另明列寵物可受益，兩者的正式服總單位硬上限仍【需遊戲實測】。40 人團隊和小隊各自用於哪些判定，要看法術的選人方式。 [暴雪永恆 5 人副本與團隊公告](https://news.blizzard.com/en-gb/article/24315820/world-of-warcraft-forever-now-live) · [暴雪團隊人數](https://news.blizzard.com/en-gb/article/24303009/world-of-warcraft-forever-raid-overviewlocations-raid-sizes-and-attunement) · [永恆 1.60.1 團隊介面](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_RaidFrame/Mainline/RaidFrame.lua)

| 選人方式 | 技能 | 40 人團隊如何運作 | 缺血優先 | 來源 |
|---|---|---|---|---|
| 由所選友方決定小隊 | 治療禱言、野性痊癒、聖光戒備 | 可藉由選另一隊成員換到該隊。每次覆蓋一隊內的合資格對象。距離由所選友方量起。 | 依小隊與半徑取候選。沒有全團低血排序的證據。 | [暴雪牧師說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) · [暴雪德魯伊說明](https://news.blizzard.com/en-us/article/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid) · [暴雪聖騎士說明](https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin) |
| 自己小隊的範圍 | 神聖新星、寧靜、治療之泉、法力之潮 | 中心是施法者或圖騰。站近別隊的玩家無法藉此把技能改成指定別隊。法力之潮只回法力。 | 依小隊與範圍，沒有低血或低藍目標排序的說明。 | [神聖新星治療效果](https://www.wowhead.com/forever/tw/spell=23455) · [寧靜](https://www.wowhead.com/forever/spell=9863/tranquility) · [治療之泉](https://www.wowhead.com/forever/spell=6371/healing-stream) · [法力之潮](https://www.wowhead.com/forever/tw/spell=1325256) |
| 自動轉移／跳躍 | 癒合禱言、治療鍊 | 禱言明列可跳團隊成員，從當前持有者量 20 碼。治療鍊的跨小隊條件與跳躍距離【需遊戲實測】。 | 目前無法從永恆客戶端核對兩招究竟按缺血絕對值、血量百分比、距離或其他規則排序。【需遊戲實測】 | [暴雪癒合禱言說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) · [永恆治療鍊技能文字](https://www.wowhead.com/forever/changes/spellbook/shaman/chain-heal) · [Beta 治療鍊跨隊觀察](https://us.forums.blizzard.com/en/wow/t/resto-shaman-feedback/2380322) |
| 玩家自行取得或指定 | 光束泉、回春術、癒合 | 光束泉供小隊或團隊成員點擊。後兩招每次由施法者選一名友方，可在團隊中逐人施放。 | 由玩家選。 | [暴雪光束泉說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) · [台服回春術](https://www.wowhead.com/forever/tw/spell=774) · [台服癒合](https://www.wowhead.com/forever/tw/spell=8936) |

固定範圍型估算以實際在場、在範圍且合資格的成員為準。跳躍型用每次治療事件計算，癒合禱言可回到之前治過的角色與否【需遊戲實測】，因此 5 次是事件上限。用 `/combatlog` 測試時安排兩隊各有一名受傷者，分開控制距離、缺血量與血量百分比，對照技能 ID、跳躍順序、過量治療、爆擊和寵物記錄。 [暴雪癒合禱言事件說明](https://news.blizzard.com/en-gb/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior) · [Forever 戰鬥紀錄操作](https://forever.wowcoach.gg/how-to-record-combat-log/)
