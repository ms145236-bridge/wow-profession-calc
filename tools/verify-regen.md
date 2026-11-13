# 《魔獸世界：永恆》治療職回藍查證

查證範圍為永恆 1.60.1，DB2 固定用 1.60.1.70938。天賦以生效的節點和每點曲線為準，法術以台服 SpellName、Wowhead 永恆版技能說明和法術效果交叉比對。伺服器的跳點、條件觸發與疊加方式若只有客戶端記錄，另標【需遊戲實測】。 [Wago SpellName（zhTW）](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhTW) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [ForeverChanges 版本與法術資料](https://foreverchanges.pro/) · [暴雪開發公告存檔](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/)

## 結論

永恆保留五秒規則。最後一次實際花費法力約五秒後，精神回藍恢復到完整速率，即使還在戰鬥中。裝備的固定 MP5 在這五秒內照常生效。施法期間的精神回藍比例已有改動，崇敬滿點 30%，冥想、反射、正念滿點 50%。目前沒有足夠實測資料確認四職業在正式服各等級的精神公式與伺服器跳點。 [Wowhead 永恆牧師回藍說明](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer) · [Full Mana Forever Beta 實測紀錄摘要](https://github.com/KesaObscura/FullManaForever/blob/main/Regen.lua#L1-L9) · [Wago 天賦階數曲線](https://wago.tools/db2/CurvePoint/csv?build=1.60.1.70938&locale=enUS)

## 1. 自然回藍與五秒規則

| 項目 | 永恆查證 | 來源 |
|---|---|---|
| 五秒規則起點 | 從最後一次實際扣藍算起，之後一般法術再次扣藍會重新計時。聖療術的技能文字列有例外，見第 3 節。五秒內按施法中速率回復，五秒後按完整速率回復。取消而未扣藍的施法、未花費法力的動作可維持這段空窗。個別免費法術或引導技若有特殊扣款時點，【需遊戲實測】。 | [永恆 Wowhead 牧師](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer) · [永恆 Beta 實測摘要](https://github.com/KesaObscura/FullManaForever/blob/main/Regen.lua#L1-L9) |
| 跳點 | 永恆 Beta 的插件作者報告，其遊戲記錄呈現連續回復。Wowhead 的永恆牧師指南同頁寫了連續回復與每 2 秒一跳，且舊範例仍用經典的 15% 冥想。資料可支援以每秒速率估算，正式服伺服器的實際更新間隔及五秒後第一個可見增量的時點【需遊戲實測】。經典每 2 秒的記載僅供對照。 | [Full Mana Forever 實測摘要](https://github.com/KesaObscura/FullManaForever/blob/main/Regen.lua#L1-L9) · [Wowhead 永恆](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer) · [Wowhead 經典牧師](https://www.wowhead.com/classic/guide/classes/priest/healer-stat-priority-attributes-pve) |
| 固定裝備 MP5 | 五秒內外均生效，平均每秒為 MP5 ÷ 5。這是速率單位。智慧祝福和圖騰另外有技能自己的週期，API 是否已計入這些光環另見第 4 節。 | [Wowhead 永恆 MP5](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer#secondary-stats-and-what-they-do-in-wow-forever) · [永恆客戶端角色面板](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_UIPanels_Game/Camelot/PaperDollFrame.lua#L1245-L1255) |
| 智力、等級 | 智力會提高法力上限，也會透過法術爆擊影響部分返藍觸發。等級會改變基礎屬性、技能階級，以及依基礎或最大法力計算的金額。固定精神後，智力或等級是否直接改變永恆精神回藍的斜率／常數，四職業皆【需遊戲實測】。下表的經典公式可當量測對照。 | [Wowhead 永恆智力／精神](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer#main-attributes-and-what-they-do-in-wow-forever) · [永恆 API 的精神回藍欄位](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590) |

以下 S 為角色當前總精神。每 2 秒等值只用來換算公式。

| 職業 | 永恆完整精神回藍 | 經典 Era 對照 | 來源 |
|---|---|---|---|
| 牧師 | 永恆 Wowhead 的參考值為每 2 秒等值 12.5 + S/4，換算每秒 6.25 + S/8。指南根據 Beta，60 級與跨等級公式【需遊戲實測】。 | 每 2 秒 12.5 + S/4。另一份經典指南將常數列為 13。 | [Wowhead 永恆牧師](https://www.wowhead.com/forever/guide/classes/priest/holy/stat-priority-pve-healer) · [Wowhead 經典牧師](https://www.wowhead.com/classic/guide/classes/priest/healer-stat-priority-attributes-pve) · [Wowhead 經典跨職業表](https://www.wowhead.com/classic/guide/classes/shaman/healer-stat-priority-attributes-pve) |
| 聖騎士 | 精神係數、常數與等級縮放【需遊戲實測】。崇敬已確認保留 15%／30%。 | 每 2 秒 15 + S/5，換算每秒 7.5 + S/10。 | [Wowhead 永恆崇敬](https://www.wowhead.com/forever/changes/talents/paladin/reverence) · [Wowhead 經典跨職業表](https://www.wowhead.com/classic/guide/classes/shaman/healer-stat-priority-attributes-pve) |
| 德魯伊 | 精神係數、常數與等級縮放【需遊戲實測】。反射已確認保留 17%／33%／50%。 | 每 2 秒 15 + S/5，換算每秒 7.5 + S/10。 | [Wowhead 永恆反射](https://www.wowhead.com/forever/changes/talents/druid/reflection) · [Wowhead 經典跨職業表](https://www.wowhead.com/classic/guide/classes/shaman/healer-stat-priority-attributes-pve) |
| 薩滿 | 精神係數、常數與等級縮放【需遊戲實測】。正念已確認保留 17%／33%／50%。 | 每 2 秒 15 + S/5，換算每秒 7.5 + S/10。 | [Wowhead 永恆正念](https://www.wowhead.com/forever/changes/talents/shaman/mindfulness) · [Wowhead 經典跨職業表](https://www.wowhead.com/classic/guide/classes/shaman/healer-stat-priority-attributes-pve) |

## 2. 施法中保留精神回藍的天賦

同一列的永恆法術 ID 適用於所有天賦階數。下列百分比是五秒窗口內保留的比例。DB2 以 [TraitNodeEntry](https://wago.tools/db2/TraitNodeEntry/csv?build=1.60.1.70938&locale=enUS) 核對最大點數，再以 [TraitDefinition](https://wago.tools/db2/TraitDefinition/csv?build=1.60.1.70938&locale=enUS)、[TraitDefinitionEffectPoints](https://wago.tools/db2/TraitDefinitionEffectPoints/csv?build=1.60.1.70938&locale=enUS)、[CurvePoint](https://wago.tools/db2/CurvePoint/csv?build=1.60.1.70938&locale=enUS) 核對每點效果。台服名稱來自 [SpellName](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhTW)。

| 職業／系別 | 台服名（英文） | 法術 ID／曲線 | 永恆各點 | 與經典 Era 的差異 | 來源 |
|---|---|---|---|---|---|
| 聖騎士／神聖 | 崇敬（Reverence） | 1310899／110321 | 15%／30% | 永恆新增。早期 Beta 為三點，正式版兩點且滿點仍是 30%。 | [Wowhead 永恆](https://www.wowhead.com/forever/changes/talents/paladin/reverence) · [ForeverChanges 聖騎士](https://foreverchanges.pro/talents/paladin) · [暴雪開發公告](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Reverence%20moved%20to%20Row%202) |
| 牧師／戒律 | 冥想（Meditation） | 14521／83138 | 17%／33%／50% | 經典 Era 為 5%／10%／15%。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/priest/meditation) · [Wowhead 經典滿點](https://www.wowhead.com/classic/tw/spell=14777) · [ForeverChanges 牧師](https://foreverchanges.pro/talents/priest) |
| 德魯伊／恢復 | 反射（Reflection） | 17106／85365 | 17%／33%／50% | 經典 Era 為 5%／10%／15%。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/druid/reflection) · [Wowhead 經典滿點](https://www.wowhead.com/classic/tw/spell=17108) · [ForeverChanges 德魯伊](https://foreverchanges.pro/talents/druid) |
| 薩滿／恢復 | 正念（Mindfulness） | 1223033／85316 | 17%／33%／50% | 永恆新增。部分單一法術頁顯示 DB2 原始 5%，實際天賦階數由曲線覆蓋。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/shaman/mindfulness) · [ForeverChanges 薩滿](https://foreverchanges.pro/talents/shaman) · [Wago 曲線](https://wago.tools/db2/CurvePoint/csv?build=1.60.1.70938&locale=enUS) |
| 薩滿／增強 | 強化風暴打擊（Improved Stormstrike） | 1223031／增益 1238931 | 1／2 點：風暴打擊有 50%／100% 機率觸發。兩點的增益都保留 50%，持續 15 秒。 | 永恆加入這套觸發回藍。與正念同時生效的算法與上限【需遊戲實測】。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/shaman/improved-stormstrike) · [增益資料](https://www.wowhead.com/forever/tw/spell=1238931) |

## 3. 其他回藍、返還與減耗

### 聖騎士

| 技能（ID） | 永恆數值與條件 | 來源 |
|---|---|---|
| 啟發（Illumination，20210） | 聖光閃現、聖光術、聖光戒備與神聖震擊的治療爆擊，各點有 20%／40%／60%／80%／100% 機率返藍。永恆階數提示各點均寫返還該法術基礎耗魔的 50%，經典為 100%。DB2 同時有另一條 10%／20%／30%／40%／50% 的效果曲線，以及返還法術 20272 的「保留 50% 回藍、15 秒」增益記錄。滿點返還值有一致資料。低階實際返還比例、20272 是否真的掛增益及與崇敬的疊加【需遊戲實測】。 | [暴雪返還數值公告](https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin#holy-talents) · [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/paladin/illumination) · [觸發法術 20272](https://www.wowhead.com/forever/tw/spell=20272) · [Wowhead 經典](https://www.wowhead.com/classic/tw/spell=20215) · [Wago 效果曲線](https://wago.tools/db2/TraitDefinitionEffectPoints/csv?build=1.60.1.70938&locale=enUS) |
| 智慧祝福（Blessing of Wisdom，19742／19850／19852／19853／19854／25290） | 14／24／34／44／54／60 級。各階每 5 秒 12／18／24／30／36／40 點，持續 1 小時。經典滿階 33 點，持續 5 分鐘。 | [永恆 1 階](https://www.wowhead.com/forever/tw/spell=19742) · [永恆 2 階](https://www.wowhead.com/forever/tw/spell=19850) · [永恆 3 階](https://www.wowhead.com/forever/tw/spell=19852) · [永恆 4 階](https://www.wowhead.com/forever/tw/spell=19853) · [永恆 5 階](https://www.wowhead.com/forever/tw/spell=19854) · [永恆 6 階](https://www.wowhead.com/forever/tw/spell=25290) · [經典 6 階](https://www.wowhead.com/classic/tw/spell=25290) |
| 強效智慧祝福（Greater Blessing of Wisdom，25894／25918） | 54／60 級，每 5 秒 36／40 點，1 小時。作用於隊伍或團隊中與目標同職業的成員。經典滿階 33 點，持續 15 分鐘。 | [永恆 1 階](https://www.wowhead.com/forever/tw/spell=25894) · [永恆 2 階](https://www.wowhead.com/forever/tw/spell=25918) · [經典 2 階](https://www.wowhead.com/classic/tw/spell=25918) |
| 智慧聖印／智慧審判（Seal／Judgement of Wisdom） | 聖印 20166／20356／20357 由近戰攻擊機率觸發，每次 50／71／90。審判 20186／20354／20355 由對該目標的攻擊或法術機率觸發，每次 33／46／59。兩者按事件計，實際觸發率與內置冷卻【需遊戲實測】。 | [聖印](https://www.wowhead.com/forever/tw/spell=20357) · [審判](https://www.wowhead.com/forever/tw/spell=20355) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) |
| 聖療術（Lay on Hands，633／2800／10310） | 10／30／50 級。依技能說明，三階均消耗聖騎士剩餘法力且不打斷回藍，冷卻 20 分鐘。1 階只有治療，2／3 階另給目標 250／550 法力。 | [永恆 1 階](https://www.wowhead.com/forever/tw/spell=633) · [永恆 2 階](https://www.wowhead.com/forever/tw/spell=2800) · [永恆 3 階](https://www.wowhead.com/forever/tw/spell=10310) |
| 祈福（Benediction，20101） | 所有瞬發法術與技能耗魔減少 2%／4%／6%／8%／10%。節省發生在施法成本。 | [Wowhead 永恆祈福](https://www.wowhead.com/forever/changes/talents/paladin/benediction) |
| 聖光戒備（Light’s Vigil，1311595） | 可觸發啟發。目前只可對友方施放。Beta 版進攻用途的返藍條件已隨進攻效果移除。 | [Wowhead 技能](https://www.wowhead.com/forever/tw/spell=1311595) · [暴雪開發公告](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Light%E2%80%99s%20Vigil%20is%20now%20only%20usable) |

### 牧師

| 技能（ID） | 永恆數值與條件 | 來源 |
|---|---|---|
| 心靈之火（Inner Fire，588 起，最高階 10952） | 護甲增益，最高階 1,395 護甲，20 次、10 分鐘，施放耗 315 法力。與回藍相關的同名易混技能是下一列的心靈專注。 | [Wowhead 永恆最高階](https://www.wowhead.com/forever/tw/spell=10952) |
| 心靈專注（Inner Focus，14751） | 冷卻 3 分鐘。下一個合資格法術耗魔減少 100%，符合條件的非週期性效果爆擊率增加 25 個百分點。 | [Wowhead 永恆](https://www.wowhead.com/forever/tw/spell=14751) |
| 精神分流（Spirit Tap，15270，增益 15271） | 擊殺符合資格的敵人，或受自身吸血鬼的擁抱影響的目標死亡時，各點有 20%／40%／60%／80%／100% 機率觸發。觸發後精神加倍，五秒內保留 50%，持續 15 秒。與冥想同時生效的算法【需遊戲實測】。 | [Wowhead 天賦](https://www.wowhead.com/forever/changes/talents/priest/spirit-tap) · [增益](https://www.wowhead.com/forever/tw/spell=15271) |
| 神聖之靈（Divine Spirit，14752／14818／14819／27841） | 30／40／50／60 級，增加 17／23／33／40 精神，1 小時。由技能訓練取得。加在精神屬性，回藍隨角色的精神係數及保留比例變動。 | [永恆 1 階](https://www.wowhead.com/forever/tw/spell=14752) · [永恆 4 階](https://www.wowhead.com/forever/tw/spell=27841) · [暴雪開發公告](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/) |
| 精神敏銳（Mental Agility，14520） | 瞬發法術耗魔減少 3%／7%／10%。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/priest/mental-agility) |
| 聖光連禱（Litany of Light，1317006，效果 1317007） | 永恆新增。上一個治療是不同技能時，返還這次治療技能基礎耗魔的 5%／10%，DB2 曲線 83161。單一技能頁的未套曲線文字可能顯示 20%。同一技能換階級、免費施放或週期治療是否算在交替條件內【需遊戲實測】。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/priest/litany-of-light) · [Wago 曲線](https://wago.tools/db2/CurvePoint/csv?build=1.60.1.70938&locale=enUS) |
| 黑暗獻祭（Dark Sacrifice，1277328 為 60 級 5 階） | 永恆不死族牧師技能。15 秒消耗 1,640 生命，取得 1,640＋精神的法力，冷卻 10 分鐘。 | [Wowhead 永恆 5 階](https://www.wowhead.com/forever/tw/spell=1277328) |

### 德魯伊

| 技能（ID） | 永恆數值與條件 | 來源 |
|---|---|---|
| 啟動（Innervate，29166） | 40 級，20 秒，冷卻 6 分鐘。提高目標法力回復速率 400%，並允許施法期間保留 100%。按文字換算為受此增益的回復部分變成 5 倍，裝備 MP5、反射與其他光環如何納入倍率【需遊戲實測】。 | [Wowhead 永恆](https://www.wowhead.com/forever/tw/spell=29166) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) |
| 活化精神（Living Spirit，1309631） | 精神增加 5%／10%／15%。先改變角色總精神，再由精神回藍公式換算。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/druid/living-spirit) |
| 清晰預兆（Omen of Clarity，16864，增益 16870） | 20 級可學。觸發後下一個符合條件的技能可免費使用，DB2 有 10 秒內置冷卻。各種治療是否都能觸發或消耗、實際觸發率【需遊戲實測】。 | [Wowhead 永恆](https://www.wowhead.com/forever/tw/spell=16864) · [清晰施法增益](https://www.wowhead.com/forever/tw/spell=16870) · [Wago SpellAuraOptions](https://wago.tools/db2/SpellAuraOptions/csv?build=1.60.1.70938&locale=enUS) |

### 薩滿

| 技能（ID） | 永恆數值與條件 | 來源 |
|---|---|---|
| 水之盾（Water Shield，408510，回藍 408511） | 恢復天賦。3 顆水球，持續 10 分鐘。受近戰、遠程或法術命中，或自身法術爆擊時消耗一顆並返還最大法力的 2%。每顆觸發間隔 3.5 秒。 | [Wowhead 永恆](https://www.wowhead.com/forever/tw/spell=408510) · [回藍法術](https://www.wowhead.com/forever/tw/spell=408511) · [暴雪開發公告](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Can%20now%20trigger%20from%20any%20critical%20spell) |
| 法力之泉圖騰（Mana Spring Totem，5675／10495／10496／10497） | 26／36／46／56 級。每 2 秒回復 4／6／8／10，持續 5 分鐘，作用於 30 碼內小隊成員。恢復圖騰（Restorative Totems，16187）提高效果 5%／10%／15%／20%／25%，取整方式【需遊戲實測】。 | [永恆 1 階](https://www.wowhead.com/forever/tw/spell=5675) · [永恆 4 階](https://www.wowhead.com/forever/tw/spell=10497) · [Wowhead 永恆天賦](https://www.wowhead.com/forever/changes/talents/shaman/restorative-totems) |
| 法力之潮圖騰（Mana Tide Totem，16190／17354／17359／1325256） | 各階 25／38／48／58 級，第一階由天賦解鎖。每 3 秒 88／133／197／290，持續 12 秒，冷卻 5 分鐘，作用於 30 碼內小隊成員。四次脈衝的名目滿階總量是 1,160，首尾脈衝時點與實收總量【需遊戲實測】。 | [暴雪階級公告](https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Added%20an%20additional%20Rank%20of%20Mana%20Tide%20Totem) · [永恆 1 階](https://www.wowhead.com/forever/tw/spell=16190) · [永恆 2 階](https://www.wowhead.com/forever/tw/spell=17354) · [永恆 3 階](https://www.wowhead.com/forever/tw/spell=17359) · [永恆 4 階](https://www.wowhead.com/forever/tw/spell=1325256) |
| 潮汐集中（Tidal Focus，16179） | 治療法術耗魔減少 1%／2%／3%／4%／5%。 | [Wowhead 永恆階數](https://www.wowhead.com/forever/changes/talents/shaman/tidal-focus) |
| 召回圖騰（Totemic Recall，36936） | 20 級可學。收回圖騰，每根返還其召喚法力成本的 25%。 | [Wowhead 永恆](https://www.wowhead.com/forever/tw/spell=36936) · [暴雪薩滿職業公告](https://news.blizzard.com/en-gb/article/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman) |

### 永恆裝備、套裝

| 裝備 | 永恆數值與條件 | 來源 |
|---|---|---|
| 癒腐者法衣（Rotmender’s Raiment，套裝 2133） | 4 件「墓穴虹吸」1321560→1321558。法力低於 15% 時，每秒回 20、10 秒共 200，5 分鐘內置冷卻。在鬧鬼與荒地類區域效果加倍。按 70938 的法術效果與說明，早期 Beta 的不同數值僅供歷史比對。 | [Wowhead 永恆套裝](https://bindonforever.com/set/2133) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago ItemSetSpell](https://wago.tools/db2/ItemSetSpell/csv?build=1.60.1.70938&locale=enUS) |
| 紫羅蘭巫師法衣（Violet Sorcerer’s Vestments，套裝 2134） | 3 件 +10 精神（1324312）。4 件「紫羅蘭冥想」1324318→1324315，傷害法術機率觸發，15 秒內保留 15% 精神回藍。在要塞、城市類區域為 30%。實際觸發率、內置冷卻及與職業天賦疊加【需遊戲實測】。 | [Wowhead 永恆套裝](https://bindonforever.com/set/2134) · [Wago SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS) · [Wago ItemSetSpell](https://wago.tools/db2/ItemSetSpell/csv?build=1.60.1.70938&locale=enUS) |
| 永恆治療團本套裝 | 信念法衣（牧師，2104／1300954）、正義護甲（聖騎，2107／1300948）、招魂師（薩滿，2109／1300960）、林地看守者衣飾（德魯伊，2112／1300943），各為 2 件 +10 精神。這是 70938 的客戶端記錄，取得時間依官方團本開放進度。 | [Wago 繁中 ItemSet](https://wago.tools/db2/ItemSet/csv?build=1.60.1.70938&locale=zhTW) · [Wago ItemSetSpell](https://wago.tools/db2/ItemSetSpell/csv?build=1.60.1.70938&locale=enUS) · [暴雪永恆時程](https://news.blizzard.com/en-us/article/24303009/world-of-warcraft-forever-raid-overviewlocations-raid-sizes-and-attunement) |

## 4. 1.60.1 遊戲 API

| 問題 | 查證結果 | 來源 |
|---|---|---|
| GetManaRegen() 是否存在、回傳什麼？ | 存在。依序回傳 baseManaRegen 與 castingManaRegen，單位是每秒法力。第一項是五秒窗口外完整速率，第二項是窗口內速率。兩個數值是角色在兩種狀態的速率。Blizzard 角色面板將兩項各乘 5 再向下取整顯示 MP5。 | [1.60.1 API 原始碼](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590) · [Blizzard 角色面板換算](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_UIPanels_Game/Camelot/PaperDollFrame.lua#L1245-L1255) |
| 是否已含精神、MP5 與天賦？ | 對一般精神、固定裝備 MP5 與當前常駐保留天賦，這兩項是面板採用的總速率，無須把這三項再加一次。另有 GetManaRegenFromSpirit() 可對照精神部分，依序回傳 powerRegen 與 combatPowerRegen。 | [API 原始碼](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590) · [Blizzard 面板精神與法力欄位](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_UIPanels_Game/Camelot/PaperDollFrameStats.lua#L288-L307) |
| 智慧祝福、圖騰、短效增益和返藍是否也納入？ | 固定面板值與額外的週期／觸發事件應分開核對。智慧祝福、法力之泉在 Beta 有影響插件回藍顯示的記錄，來源使用的是相關的 GetPowerRegen()。這兩個光環各會讓 GetManaRegen() 的哪一項增加多少，以及移除時如何更新【需遊戲實測】。水之盾、啟發等一次性返還可按事件獨立計算。啟動、精神分流等短效光環生效時的 API 差值與疊加也需逐一確認。 | [Full Mana Forever 的增益觀察](https://github.com/KesaObscura/FullManaForever/blob/main/Regen.lua#L10-L19) · [智慧祝福](https://www.wowhead.com/forever/tw/spell=25290) · [法力之泉](https://www.wowhead.com/forever/tw/spell=10497) |
| 永恆插件隨時都能讀取嗎？ | GetManaRegen 在 1.60.1 標記 SecretWhenUnitStatsRestricted，受限時回傳秘密值。成功呼叫仍可能拿到秘密值，計算前需確認兩個值都可讀。GetManaRegenFromSpirit 的文件未列同一旗標，正式服何時可讀仍【需遊戲實測】。 | [1.60.1 API 限制旗標](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590) |

## 遊戲實測項目

1. 四職業各在至少兩個等級，以無外部光環、無 MP5 裝備、無保留天賦的角色，先單獨改變精神、再單獨改變智力。每個條件記錄角色等級、總精神、總智力與兩項精神回藍回傳值。以兩組精神差算斜率，對照常數與跨等級結果。 [精神回藍 API](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590)
2. 單次耗藍並留出至少 12 秒不再次扣藍，記下實際扣藍時點、前五秒的法力增量及五秒後第一次增量。換不同時點重複多次，再做一次免費施法及取消施法對照。區分角色面板顯示、客戶端資源更新與可觀察到的回復節奏。 [永恆 Beta 回藍觀察](https://github.com/KesaObscura/FullManaForever/blob/main/Regen.lua#L1-L9) · [暴雪論壇上的跳點與 API 問題](https://us.forums.blizzard.com/en/wow/t/mana-regen-ticks-five-second-rule-and-add-on-api-clarification/2362365)
3. 脫戰先逐項切換一件固定 MP5 裝備、每一點保留天賦、智慧祝福與法力之泉，記 GetManaRegen() 和 GetManaRegenFromSpirit() 的兩項差值。用分別開啟與同時開啟測試啟動、精神分流＋冥想、正念＋強化風暴打擊、啟發＋崇敬。另記一般戰鬥與副本戰鬥中的可讀性，以及啟發 1–4 點、法力之潮、水之盾、聖光連禱與套裝的實際觸發事件。 [角色面板與 API](https://github.com/Gethe/wow-ui-source/blob/bebcb6bf309cf41b41bd74f8ca651e6a105b2676/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua#L570-L590) · [永恆法術效果](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS)
