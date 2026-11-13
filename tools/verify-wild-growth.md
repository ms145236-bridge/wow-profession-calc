# 《魔獸世界：永恆》1.60.1 野性痊癒逐跳查證

**三階都確認每秒一跳、持續 7 秒、前高後低，週期治療係數欄位為 0.066。正式服第 1–7 跳的實際數字、衰減公式與有效加成分配均【需遊戲實測】。** 目前可用的固定輸入是間隔、持續時間、名目跳數與原始係數。每跳權重保持未驗證。 [暴雪德魯伊職業說明][blue-druid] · [70938 SpellEffect][effect] · [熱修快取比對][hotfix-cache]

## 1. 三階總量與七跳

每階基礎讀條 3 秒，冷卻 6 秒。表中 DB2 基準是週期治療效果的原始欄位，台服提示以 60 級瀏覽。實測總量應把同一次施放對同一人的七筆原始治療加總。 [70938 SpellEffect][effect] · [70938 SpellLevels][levels] · [70938 SpellDuration][duration] · [ForeverChanges 德魯伊][fc-druid]

| 階／法術 ID | 學習等級 | 週期效果記錄 ID | DB2 基準值／每級成長欄 | 台服 60 級提示總量／人 | 增益提示／秒 | 跳數／間隔／持續 | 實際 1–7 跳與總量 | 來源 |
|---|---:|---:|---:|---:|---:|---|---|---|
| 1／408120 | 40 | 1072065 | 40／1.0 | 336 | 48 | 7 跳／1 秒／7 秒 | 【需遊戲實測】 | [台服 1 階][r1] · [70938 SpellEffect][effect] |
| 2／1238214 | 50 | 1235327 | 60／1.3 | 493 | 70 | 7 跳／1 秒／7 秒 | 【需遊戲實測】 | [台服 2 階][r2] · [70938 SpellEffect][effect] |
| 3／1238215 | 60 | 1235329 | 97／1.6 | 769 | 110 | 7 跳／1 秒／7 秒 | 【需遊戲實測】 | [台服 3 階][r3] · [70938 SpellEffect][effect] |

- 客戶端描述以 `$o1` 顯示全程總量、`$w1` 顯示每秒參考值。336 ÷ 7 = 48、493 ÷ 7 約 70.43、769 ÷ 7 約 109.86，符合頁面顯示的每秒量級。這些欄位沒有提供第一跳、最後一跳或相鄰兩跳的差值。原始基準值乘七得到的 280／420／679 也只是欄位算術。 [70938 Spell][spell] · [台服 1 階][r1] · [台服 2 階][r2] · [台服 3 階][r3]
- 三階各有一筆週期治療（`EffectIndex=0`、`EffectAura=8`、`EffectAuraPeriod=1000`），以及一筆 `EffectIndex=1` 的 Dummy 光環，基準值 5、週期間隔 0、觸發法術 0。週期治療的 `EffectChainAmplitude=1`、`EffectChainTargets=0` 屬於跳躍欄位。這些值無法推得七跳的衰減。 [70938 SpellEffect][effect] · [Wowhead 效果說明][r3]
- 三個 ID 都沒有 `SpellAuraOptions` 或 `SpellAuraRestrictions` 的對應列。野性痊癒天賦 `TraitDefinition 134371` 對應 `TraitNodeEntry 129570`、最大 1 點，`TraitDefinitionEffectPoints` 沒有對應列，未找到可連到 `CurvePoint` 的衰減曲線。三階共用的 `SpellDescriptionVariables 823` 只有以玩家等級 `$PL` 為變數的 `damagepower` 和 `healpower`，沒有跳次變數或七點權重。 [SpellAuraOptions][aura] · [SpellAuraRestrictions][aura-restrictions] · [TraitDefinition][trait] · [TraitNodeEntry][node] · [TraitDefinitionEffectPoints][trait-points] · [CurvePoint][curve] · [SpellXDescriptionVariables][spell-vars-link] · [SpellDescriptionVariables][spell-vars]
- 暴雪只確認每秒遞減，沒有公布是等差、等比或逐跳查表。可找到的 TrinityCore／AzerothCore 3.3.5 公式屬其他版本的模擬實作，未套到永恆。WoWSims 永恆版熱修比對也註明其野性痊癒尚未實作，沒有可用來反查七跳的模擬輸出。 [暴雪德魯伊職業說明][blue-druid] · [3.3.5 實作對照][wrath] · [WoWSims 永恆熱修][hotfix-cache]

## 2. 治療效果加成

| 項目 | 查證結果 | 來源 |
|---|---|---|
| 熱修前 | 1.60.1.70790 與 70888 的原始週期效果列皆為 `0.03299999982`（0.033）。一些舊法術頁快照仍會顯示這個值。 | [70888 SpellEffect][effect-old] · [較早的 Wowhead 法術頁][r3-old] |
| 熱修後 | 70938 的三筆週期效果皆為 `0.06599999964`（**0.066**）。本機台服客戶端的 `Logs/Hotfix.log` 也記錄 push `113718` 驗證通過。唯讀核對 `Cache/ADB/zhTW/DBCache.bin`，相同 push 的三筆效果都寫 1000 ms 及 0.066。Wowhead 報導與 WoWSims 對快取的獨立比對一致。 | [70938 SpellEffect][effect] · [Wowhead 熱修][wowhead-hotfix] · [WoWSims 113718 比對][hotfix-cache] |
| 官方公告口徑 | 11/10 公告確認自然迅捷可使野性痊癒瞬發。係數翻倍可直接在熱修快取與 70938 表列重現。ForeverChanges 提醒某些客戶端與伺服器資料的快照不同，該摘要未給每跳實測值。 | [暴雪 11/10 熱修][official-hotfix] · [ForeverChanges 70938 公告][fc-patch] · [70938 SpellEffect][effect] |
| 七跳實際加成 | **6.6% 是週期效果欄位**。若伺服器對每跳都加上同樣的 `0.066 × 額外治療效果`，全程名目係數是 **46.2%／人**。是否每跳實收都相同、會不會連加成一起乘衰減、以及逐跳取整順序【需遊戲實測】。 | [70938 SpellEffect][effect] · [Wowhead 熱修][wowhead-hotfix] · [暴雪每跳遞減說明][blue-druid] |

## 3. 爆擊與選人

| 項目 | 查證結果 | 來源 |
|---|---|---|
| 能否爆擊 | 暴雪已修正為可爆擊。三階 `SpellMisc.Attributes_8=0x1200`，含 `0x200 PERIODIC_CAN_CRIT`，對應週期治療事件。 | [暴雪爆擊修正][blue-crit] · [70938 SpellMisc][misc] · [旗標定義][flag] |
| 獨立或共用爆擊 | 週期效果允許爆擊，但 DB2 沒寫伺服器的擲骰粒度。在同一次施放、同一目標有一跳爆擊和一跳未爆擊，可排除整段共用一次結果。正式服同施放逐跳事件【需遊戲實測】。 | [70938 SpellMisc][misc] · [暴雪爆擊修正][blue-crit] · [Warcraft Logs 事件檢視][event-doc] |
| 目標與小隊 | 可選任何小隊／團隊友方，再以該友方為中心覆蓋其小隊。40 人團隊可選另一隊，每次仍依所選小隊判定。官方明列可補該隊寵物，5 是滿小隊玩家席位。DB2 的 Dummy 基準 5 不能獨立證明含寵物的硬上限，`SpellTargetRestrictions` 也沒有三階對應列。寵物是否占名額及總單位上限【需遊戲實測】。 | [暴雪德魯伊職業說明][blue-druid] · [70938 SpellEffect][effect] · [SpellTargetRestrictions][target-restrictions] |
| 範圍 | 起手 **40 碼**。台服描述與週期治療效果的 `EffectRadiusIndex_1=524` 均指向距被選友方 **43.5 碼**。Dummy 效果半徑 ID 18 為 15 碼，部分 Wowhead 效果細節也顯示 15 碼。實際生效邊界、視線和移動出圈後的行為【需遊戲實測】。 | [台服 3 階][r3] · [70938 SpellEffect][effect] · [SpellRadius][radius] · [SpellRange][range] |
| 缺血優先 | 暴雪描述為覆蓋指定小隊的成員與寵物，未提到按血量高低挑選，沒有依據設定全團智慧治療。若候選單位多於實際硬上限，如何排序與是否略過滿血【需遊戲實測】。 | [暴雪德魯伊職業說明][blue-druid] · [ForeverChanges 德魯伊][fc-druid] |

## 4. 補成插件權重表所需的紀錄

本機台服安裝的 `Logs` 未找到 `WoWCombatLog*`。公開可查的資料能確認持續時間、週期與定性衰減，未找到同次施法、同一目標的七筆正式服事件，以及同階固定條件下兩組不同治療效果的紀錄。另查 Forever Sixty 當時列出的 4 份公開報告、共 228 個戰鬥摘要，沒有出現這三個技能 ID 或 Wild Growth 名稱。Warcraft Logs Forever 的事件頁仍可用來核對玩家提供的報告。 [Forever Sixty 公開報告][sixty] · [戰鬥報告範例][sixty-report] · [Warcraft Logs Forever][wcl] · [事件檢視][event-doc] · [Forever 本機記錄方式][logging]

1. 每階以固定施法者等級、目標、天賦和增益，開啟 `/combatlog`，單獨施放一次並讓光環完整結束。記錄 `SPELL_CAST_SUCCESS`、`SPELL_AURA_APPLIED` 與同一來源、同一目標、同一法術 ID 的七筆 `SPELL_PERIODIC_HEAL`。保留時間、原始治療、過量與爆擊欄。以持續缺血的目標收集每個跳次的未爆擊數值。
2. 每階用同一組條件重做兩次，只更換已知差值 `ΔH` 的額外治療效果。各跳實測係數 `c[i] = (高治療量組第 i 跳 − 低治療量組第 i 跳) ÷ ΔH`，可分辨平坦的 0.066 與隨跳次遞減的有效係數。三階盡量用同角色，分開記錄施法者等級與降階條件。
3. 若零額外治療效果的未爆擊七跳為 `b[1..7]`，全程基礎量是 `Σb[i]`，基礎權重是 `b[i] / Σb[i]`。逐跳治療效果另用 `c[i]`。只有實測顯示兩者按同一比例衰減時，才能共用同一組權重。選人另測同小隊滿血、缺血、寵物、別隊，以及 15／43.5 碼邊界。

[blue-druid]: https://news.blizzard.com/en-us/article/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid#restoration
[blue-crit]: https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Wild%20Growth%20can%20land%20critical%20hits
[official-hotfix]: https://news.blizzard.com/en-us/article/24315281/wow-forever-hotfixes-november-10-2026
[fc-druid]: https://foreverchanges.pro/class/druid
[fc-patch]: https://foreverchanges.pro/patch-notes
[hotfix-cache]: https://github.com/wowsims/forever/pull/954
[wowhead-hotfix]: https://www.wowhead.com/forever/news/restoration-druid-change-to-wild-growth-in-wow-forever-383851
[r1]: https://www.wowhead.com/forever/tw/spell=408120/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92
[r2]: https://www.wowhead.com/forever/tw/spell=1238214/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92
[r3]: https://www.wowhead.com/forever/tw/spell=1238215/%E9%87%8E%E6%80%A7%E7%97%8A%E7%99%92
[r3-old]: https://www.wowhead.com/forever/spell=1238215/wild-growth
[spell]: https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS
[effect]: https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS
[effect-old]: https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70888&locale=enUS
[misc]: https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS
[aura]: https://wago.tools/db2/SpellAuraOptions/csv?build=1.60.1.70938&locale=enUS
[aura-restrictions]: https://wago.tools/db2/SpellAuraRestrictions/csv?build=1.60.1.70938&locale=enUS
[duration]: https://wago.tools/db2/SpellDuration/csv?build=1.60.1.70938&locale=enUS
[levels]: https://wago.tools/db2/SpellLevels/csv?build=1.60.1.70938&locale=enUS
[radius]: https://wago.tools/db2/SpellRadius/csv?build=1.60.1.70938&locale=enUS
[range]: https://wago.tools/db2/SpellRange/csv?build=1.60.1.70938&locale=enUS
[target-restrictions]: https://wago.tools/db2/SpellTargetRestrictions/csv?build=1.60.1.70938&locale=enUS
[spell-vars-link]: https://wago.tools/db2/SpellXDescriptionVariables/csv?build=1.60.1.70938&locale=enUS
[spell-vars]: https://wago.tools/db2/SpellDescriptionVariables/csv?build=1.60.1.70938&locale=enUS
[trait]: https://wago.tools/db2/TraitDefinition/csv?build=1.60.1.70938&locale=enUS
[node]: https://wago.tools/db2/TraitNodeEntry/csv?build=1.60.1.70938&locale=enUS
[trait-points]: https://wago.tools/db2/TraitDefinitionEffectPoints/csv?build=1.60.1.70938&locale=enUS
[curve]: https://wago.tools/db2/CurvePoint/csv?build=1.60.1.70938&locale=enUS
[flag]: https://github.com/wowdev/WoWDBDefs/blob/master/meta/flags/SpellAttributes8.dbdf
[wrath]: https://335.trinitycore.net/d3/d6d/classspell__dru__wild__growth__aura
[sixty]: https://foreversixty.gg/logs
[sixty-report]: https://foreversixty.gg/reports/gxrgvz4yzsi2?fight=31
[wcl]: https://forever.warcraftlogs.com/
[event-doc]: https://www.archon.gg/wow-forever/articles/help/how-to-navigate-through-logs
[logging]: https://forever.wowcoach.gg/how-to-record-combat-log/
