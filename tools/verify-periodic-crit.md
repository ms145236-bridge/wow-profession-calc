# 《魔獸世界：永恆》1.60.1 的 HoT／DoT 爆擊查證

核對台服名稱及正式服客戶端 1.60.1.70790、70888、70938，表內旗標以 70938 為準。證據包括暴雪藍帖、客戶端法術效果和玩家公開的實測。標【需遊戲實測】的項目仍缺正式服事件或數值。 [Wago SpellName（zhTW）][zh] · [Wago SpellMisc][misc] · [Wago SpellEffect][effect] · [ForeverChanges 版本紀錄][fc] · [暴雪開發公告][blue]

## 1. 一般規則

| 項目 | 永恆 1.60.1 | 來源 |
|---|---|---|
| 週期性治療與傷害 | 許多玩家法術的週期效果可爆擊。角色面板用「多數週期效果」描述，DB2 也顯示按法術啟用。恢復、回春術、癒合 HoT、野性痊癒、激流、寧靜和治療之泉的治療效果都帶相應旗標。吸血鬼的擁抱回補有明確禁爆規則，點燃與重傷也有個別處理。 | [永恆角色面板截圖與轉錄][critui] · [藍帖的職業修正][blue] · [Wago 旗標][misc] |
| DB2 欄位 | 永恆的屬性陣列在 `SpellMisc`。`Attributes_8 & 0x00000200` 是 `SPELL_ATTR8_PERIODIC_CAN_CRIT`（Wowhead 顯示 Periodic Can Crit）。`Attributes_2 & 0x20000000` 是 `SPELL_ATTR2_CANT_CRIT`。兩者應讀實際產生傷害／治療的 ID。 `SpellEffect` 的 `EffectAura=8` 是週期治療、`3` 是週期傷害、`23` 是週期觸發子法術，`Effect=10` 是直接治療。 | [Wago SpellMisc][misc] · [Wago SpellEffect][effect] · [WoWDBDefs Attr8][attr8] · [WoWDBDefs Attr2][attr2] · [Wowhead 癒合旗標][regrowth] |
| 爆擊倍率 | 一般法術治療與法術傷害基準為 **1.50 倍**。Beta 裸裝、未點天賦的玩家測到回春術／癒合 HoT 42→63。可爆的物理流血可用物理爆擊基準 **2.00 倍**，正式服紀錄有血襲 31→62，天賦可再提高。技能自帶的爆擊傷害加成需另算。藍帖已移除早期 Beta 的通用 PvP 爆擊折減。 | [角色面板截圖與轉錄][critui] · [回春術／癒合測值][healtest] · [正式服流血原始紀錄][bleed] · [暴雪 PvP 修正][pvp] |
| 經典 Era 對照 | 以同 ID 對照 1.15.9.69722，恢復、回春術、癒合 HoT、寧靜、治療之泉、腐蝕術、暗言術：痛與撕扯在 Era 均沒有這個週期爆擊位元。癒合的直接治療屬於另一段效果。 | [Era SpellMisc][eramisc] · [永恆 SpellMisc][misc] · [Era 癒合][eraregrowth] |
| 快照 | 暴雪開發者確認永恆改用動態 DoT，並因此移除心靈專注對週期效果的爆擊加成。各 HoT 遇到臨時爆擊增益時的讀值時點、圖騰如何繼承爆擊率，【需遊戲實測】。 | [開發者對動態 DoT 的說明][dynamic] · [藍帖心靈專注][blue] |

### DoT 範例與例外

| 法術 | 結果 | 來源 |
|---|---|---|
| 腐蝕術 172、暗言術：痛 589、月火術 8921、烈焰震擊 8050 | 各例有週期傷害與 `0x200`。暗言術：痛與烈焰震擊另有 Beta 玩家紀錄。烈焰震擊的週期爆擊能造成額外傷害，開發者同時確認它不觸發元素浩劫。 | [Wago SpellMisc][misc] · [Wago SpellEffect][effect] · [暗言術：痛實測][dynamic] · [烈焰震擊實測與開發者回覆][flametest] |
| 噬靈瘟疫 2944、地獄烈焰 1949→5857 | 暴雪明確修正為可爆擊。噬靈瘟疫的傷害屬週期吸取，回補隨傷害，不另算一次 HoT 爆擊。地獄烈焰可確認對敵人的每次傷害，施法者自傷的爆擊行為【需遊戲實測】。 | [暴雪開發公告][blue] · [Wowhead 噬靈瘟疫][plague] · [Wowhead 地獄烈焰效果][hellfire] |
| 掃擊、撕扯、割裂、血襲 | 有正式服週期傷害爆擊紀錄。以血襲 9007 為例，DB2 有 `0x200`，同目標先 31 普通、再 62 爆擊。生存本能點滿在 11/9 修正後的同法術例為 36→80，約 2.2 倍。 | [正式服 11/8 原始戰鬥紀錄與 11/10 回測][bleed] · [Wago 旗標][misc] |
| 法師點燃（Ignite，412538→412545）、戰士重傷（Deep Wound，412609） | 是由爆擊衍生的週期傷害。兩個光環均無 `0x200`，點燃的傷害子法術 412545 還有 `CANT_CRIT`。重傷 412609 以週期 dummy aura 表示，依目前資料不給第二次爆擊。若伺服器另用不同傷害 ID，該 ID【需遊戲實測】。 | [Wago SpellMisc][misc] · [Wago SpellEffect][effect] · [Wowhead 點燃][ignite] · [Wowhead 重傷][deep] |

## 2. 治療法術逐項核對

下表的 `Attr8` 為完整欄位值。列出的玩家技能階數逐一核對，隱藏的同名 NPC、套裝或其他版本 ID 可能有不同旗標。 [Wago SpellName（zhTW）][zh] · [Wago SpellMisc][misc] · [Wago SpellEffect][effect]

| 職業與技能 | 核對的法術／效果 | 爆擊判定 | 來源 |
|---|---|---|---|
| 牧師・恢復（Renew） | 1–10 階 139、6074、6075、6076、6077、6078、10927、10928、10929、25315。Aura 8，每 3 秒，`Attr8=0x01000200`。 | **HoT 可爆擊**。藍帖和玩家影片均有支持。恢復爆擊不觸發神禦之盾。 | [Wowhead 1 階][renew] · [藍帖][blue] · [玩家影片與開發者回覆][renewtest] |
| 德魯伊・回春術（Rejuvenation） | 1–11 階 774、1058、1430、2090、2091、3627、8910、9839、9840、9841、25299。Aura 8，每 3 秒。7 階 `0x00000200`，其餘 `0x01000200`。 | **HoT 可爆擊**。玩家實測 42→63。 | [Wowhead 1 階][rejuv] · [暴雪開發公告][blue] · [玩家數值][healtest] |
| 德魯伊・癒合（Regrowth） | 1–9 階 8936、8938、8939、8940、8941、9750、9856、9857、9858。`EffectIndex 0` 是直接治療，`1` 是 Aura 8、每 3 秒、共 21 秒。各階 `Attr8=0x01000200`。 | **直接治療和 HoT 都可爆擊**。Beta 玩家在未點天賦時已觀察到 HoT 爆擊。 | [Wowhead 癒合][regrowth] · [永恆恢復德魯伊技能頁][druidguide] · [玩家實測][healtest] |
| 德魯伊・野性痊癒（Wild Growth） | 1–3 階 408120、1238214、1238215。Aura 8，每 1 秒，`Attr8=0x00001200`。 | **HoT 可爆擊**。技能本身各跳基礎量遞減，計算倍率時應比較相同跳次。 | [Wowhead 法術][growth] · [藍帖][blue] · [ForeverChanges 德魯伊][fcdruid] |
| 薩滿・激流（Riptide） | 1–3 階 408521、1239242、1239243。Aura 8，每 3 秒，`Attr8=0x00001200`。 | **HoT 可爆擊**。正式服的初始治療已移除，1.60.1.70938 效果表也只有週期治療。 | [Wowhead 法術][riptide] · [藍帖爆擊及初始治療改動][blue] · [ForeverChanges 薩滿][fcshaman] |
| 德魯伊・寧靜（Tranquility） | 1–4 階 740、8918、9862、9863。引導中的範圍 Aura 8，每 2 秒、技能卡與 DB2 皆列 10 秒，`Attr8=0x00001200`。 | **引導的週期治療可爆擊**。同一人同一次引導是否能混出普通與爆擊、同跳跨目標是否各判，見第 3 節。 | [Wowhead 法術][tranq] · [藍帖][blue] · [永恆恢復德魯伊技能頁][druidguide] |
| 牧師・懺悟（Penance） | 1–4 階施放 ID 402174、1240720、1240721、1316995。治療引導 Aura 23 的 ID 是 402277、1240732、1240733、1316992。實際治療子法術是 402289、1240723、1240724、1316991，均為 `Effect=10`，未禁爆。 | **治療彈可爆擊**。0、1、2 秒三發，每發為獨立治療事件。每發的擲骰實證見第 3 節。傷害彈另用 `Effect=2` 子法術。 | [Wowhead 最高階施放][penance] · [Wowhead 實際治療][penanceheal] · [藍帖 2 秒引導][penanceblue] · [ForeverChanges 牧師][fcpriest] |
| 聖騎士・聖光戒備（Light’s Vigil） | 施放 1310911、1311590、1311595。聖光戒備標記由神聖震擊觸發，範圍治療 ID 1310912、1311591、1311596，均為 `Effect=10`，未禁爆。 | **觸發時的一次直接治療可爆擊**。等待觸發的標記沒有 HoT 跳數。啟發的觸發清單明列聖光戒備的治療爆擊。 | [Wowhead 施放][vigil] · [Wowhead 治療子法術][vigilheal] · [暴雪聖騎士開發說明][pallyblue] · [ForeverChanges 聖騎士][fcpaladin] |
| 薩滿・治療之泉圖騰（Healing Stream Totem） | 召喚 5394、6375、6377、10462、10463。圖騰真正放出的治療之泉（Healing Stream）5672、6371、6372、10460、10461 為範圍 Aura 8、每 2 秒，`Attr8=0x01001200`。 | **治療光環具備爆擊資格**。10/5 Beta 同角同裝測試在元素／增強看到爆擊，恢復未觀察到。正式服各專精、圖騰繼承率、是否受潮汐專精影響【需遊戲實測】。 | [Wowhead 治療光環][stream] · [Beta 玩家測試][streamtest] · [Wago SpellMisc][misc] |
| 牧師・光束泉／恢復光束泉（Lightwell／Lightwell Renew） | 召喚 724、27870、27871，實際 HoT 7001、27873、27874 是 Aura 8、每 2 秒，`Attr8=0x00000200`。 | **HoT 有爆擊旗標**。正式服實測與爆擊率取自牧師、點泉者或召喚物【需遊戲實測】。 | [Wowhead 光束泉][well] · [Wowhead 恢復光束泉][wellheal] · [Wago SpellMisc][misc] |
| 牧師・吸血鬼的擁抱（Vampiric Embrace） | 15286 是標記。15290、1237618 為事件觸發的直接回補，帶 `CANT_CRIT`。 | **回補不能另外爆擊**。11/2 藍帖明確關閉。 | [藍帖禁爆][blue] · [Wago SpellMisc][misc] · [Wago SpellEffect][effect] |
| 牧師・祝福復元（Blessed Recovery） | 天賦 27811，週期光環 27813 為 Aura 226、每 2 秒，`Attr8=0`。另有同名直接治療 1240755，帶 `CANT_CRIT`。 | **資料未啟用週期爆擊，直接回補記錄亦禁爆**。 | [Wowhead 天賦][blessed] · [Wago SpellMisc][misc] · [Wago SpellEffect][effect] |
| 裝備・癒腐（Rotmending） | 癒腐者法衣 5 件 1321587→1321586，Aura 8、每 3 秒，`Attr8=0x00000200`。 | **套裝自帶的額外 HoT 有爆擊旗標**。正式服實際觸發爆擊與繼承率【需遊戲實測】。 | [套裝客戶端資料][rotset] · [Wago ItemSetSpell][sets] · [Wago SpellMisc][misc] |

## 3. 引導治療的每跳判定

| 法術 | 可以確定的事 | 同一次引導是否各自擲骰 | 來源 |
|---|---|---|---|
| 懺悟 | 一次引導依序產生三個直接治療事件。判定時使用治療子法術，不用引導外殼的週期爆擊位元。Beta 討論有玩家依實戰影片報告約 346–347 的治療爆擊，與一般約 230 的數值吻合。 | **資料結構支持按發判定**。同一個正式服引導、同一目標中同時出現普通與爆擊的原始事件【需遊戲實測】。暴雪對嶄新希望的回覆只說虛弱靈魂縮時按施法計，不能用來判爆擊擲骰。 | [ForeverChanges 0／1／2 秒][fcpriest] · [Wago SpellEffect][effect] · [Beta 實戰討論][penancetest] · [開發者回覆嶄新希望][penancerh] |
| 寧靜 | 藍帖與 DB2 均確認週期治療可爆擊。每名受治者有週期治療事件。 | **資料支持每跳都有爆擊資格**。同一受治者能否在同一引導內混出普通與爆擊、同一跳不同人是否共用結果，【需遊戲實測】。 | [藍帖][blue] · [Wowhead 法術][tranq] · [Wago SpellEffect][effect] |

## 4. 天賦、套裝及爆擊觸發條件

在本次核對的 70938 治療職天賦與永恆套裝效果裡，未發現把原先禁爆的 HoT 整體改成可爆的天賦或套裝。常見 HoT 已在原法術上啟用。下表列的是提高機率、調整倍率、加入另一個效果或限制爆擊觸發的項目。 [Wago TraitDefinition][trait] · [Wago SpellEffect][effect] · [Wago ItemSetSpell][sets]

| 項目 | 永恆效果與判定 | 來源 |
|---|---|---|
| 德魯伊・強化癒合（Improved Regrowth，17074）／自然威嚴（Nature’s Majesty，1223082） | 強化癒合增加癒合爆擊率 10／20／30／40／50 個百分點，法術遮罩對到癒合的共同 ID，說明未拆直接與週期。HoT 本來就會爆，強化癒合是否在伺服器端同幅套用到兩段【需遊戲實測】。自然威嚴提高法術及近戰爆擊率 2／4 個百分點。 | [Wowhead 強化癒合][imprg] · [Wowhead 自然威嚴][majesty] · [ForeverChanges 德魯伊][fcdruid] |
| 德魯伊・生生不息（Genesis，1223081）、自然光采（Nature’s Splendor，1223083）、綻放（Bloom，1328621→1328622） | 生生不息加週期治療／傷害量，自然光采延長指定效果。綻放在自己的回春術／癒合自然結束時給 100% 精神的一次治療，被驅散則 50%。1328622 是直接治療且未禁爆，伺服器是否允許這次額外治療爆擊【需遊戲實測】。自然之賜（16880）只吃非週期爆擊。 | [ForeverChanges 德魯伊][fcdruid] · [暴雪綻放改動][blue] · [Wago SpellEffect][effect] |
| 牧師・心靈專注（14751）、神禦之盾（431622）、靈感（14892）、嶄新希望（425280） | 心靈專注的 +25 個百分點排除週期效果。神禦之盾與靈感只由非週期治療爆擊觸發。嶄新希望給指定直接治療（含懺悟）對虛弱靈魂目標 +2／4／6／8／10 個百分點，名單沒有恢復。 | [藍帖][blue] · [ForeverChanges 牧師][fcpriest] · [恢復觸發實測與回覆][renewtest] |
| 薩滿・潮汐專精（Tidal Mastery，16194）、先祖治療（16176）、水之盾（408510） | 潮汐專精提高合資格治療法術爆擊率 1–5 個百分點，DB2 的法術遮罩涵蓋激流各階，未涵蓋治療之泉的治療光環。圖騰有無其他爆擊繼承機制【需遊戲實測】。先祖治療文字泛稱治療爆擊，公開資料對照指出觸發遮罩未涵蓋週期治療，激流爆擊是否給護甲【需遊戲實測】。水之盾的暴雪說明擴到自身法術爆擊，激流 HoT 與圖騰爆擊是否消耗水球也需實測。恢復圖騰（16187）提高治療之泉的治療量。 | [ForeverChanges 薩滿][fcshaman] · [Wago SpellClassOptions][classoptions] · [Wago SpellAuraOptions][auraopts] · [先祖治療觸發遮罩對照][ancestral] · [水之盾藍帖][blue] |
| 聖騎士・神聖強化（Holy Power，5923）／啟發（20210） | 神聖強化提升神聖法術的爆擊**治療加成** 10／20／30／40／50%，按 50% 基礎加成推算滿點 1.75 倍。聖光戒備各階與取整【需遊戲實測】。啟發在合資格治療爆擊後返藍，不授予爆擊資格。 | [ForeverChanges 聖騎士][fcpaladin] · [藍帖神聖強化][blue] · [暴雪啟發開發說明][pallyblue] |
| 永恆套裝 | 癒腐者法衣 5 件增加獨立的可爆擊 HoT（旗標）。招魂師 5 件（1301713）縮短激流冷卻，信念法衣 5 件（1301703）縮短懺悟與癒合禱言冷卻，林地看守者衣飾 5 件（1301250）縮短迅癒冷卻。這些永恆套裝記錄沒有改寫既有 HoT 的爆擊資格。資料中還有探索賽季 `S03` 套裝同名記錄，這裡以永恆套裝 ID 與正式服項目為準。 | [Wago ItemSet（zhTW）][itemset] · [Wago ItemSetSpell][sets] · [Wago SpellEffect][effect] |

## 5. 待補的正式服紀錄

- 開啟進階戰鬥紀錄並用 `/combatlog`。寧靜抓同一次施放、同一目標連續的 `SPELL_PERIODIC_HEAL`。懺悟抓同一次施放下的三筆 `SPELL_HEAL`，用 402289 等治療子法術對齊。各收一組同一目標的普通與爆擊事件，可排除整次引導共用同一次爆擊結果。測試時讓目標維持足夠缺血，保留事件原始金額及 critical 欄。 [Forever 戰鬥紀錄方式][logging] · [Wago SpellEffect][effect]
- 同裝備切換元素／增強／恢復，在穩定缺血條件記錄治療之泉的每跳。把潮汐專精、有無先祖治療及水之盾分開切換，對照激流和圖騰的傷害／治療爆擊與增益、充能事件。強化癒合則用 0／5 點分開計直接與 HoT 的爆擊比例。 [治療之泉玩家測試][streamtest] · [先祖治療資料對照][ancestral] · [強化癒合天賦][imprg]
- 若需要計算平均原始治療量，單一可爆擊效果的估值可用 `非爆擊治療量 × [1 + 爆擊率 × (爆擊倍率 − 1)]`，逐段加總。寧靜或懺悟跳與跳是否共用擲骰，會影響連爆機率和變異，平均值可在各跳邊際爆擊率相同時直接相加。治療之泉實際爆擊率未確認前可獨立列為待核。 [角色面板爆擊規則][critui] · [Wago 實際治療子法術][effect]

[zh]: https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhTW
[misc]: https://wago.tools/db2/SpellMisc/csv?build=1.60.1.70938&locale=enUS
[effect]: https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938&locale=enUS
[eramisc]: https://wago.tools/db2/SpellMisc/csv?build=1.15.9.69722&locale=enUS
[attr8]: https://github.com/wowdev/WoWDBDefs/blob/master/meta/flags/SpellAttributes8.dbdf
[attr2]: https://github.com/wowdev/WoWDBDefs/blob/master/meta/flags/SpellAttributes2.dbdf
[trait]: https://wago.tools/db2/TraitDefinition/csv?build=1.60.1.70938&locale=enUS
[sets]: https://wago.tools/db2/ItemSetSpell/csv?build=1.60.1.70938&locale=enUS
[itemset]: https://wago.tools/db2/ItemSet/csv?build=1.60.1.70938&locale=zhTW
[classoptions]: https://wago.tools/db2/SpellClassOptions/csv?build=1.60.1.70938&locale=enUS
[auraopts]: https://wago.tools/db2/SpellAuraOptions/csv?build=1.60.1.70938&locale=enUS
[fc]: https://foreverchanges.pro/patch-notes
[fcpriest]: https://foreverchanges.pro/class/priest
[fcdruid]: https://foreverchanges.pro/class/druid
[fcshaman]: https://foreverchanges.pro/class/shaman
[fcpaladin]: https://foreverchanges.pro/class/paladin
[blue]: https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696
[pvp]: https://www.bluetracker.gg/wow/topic/us-en/2360696-wow-forever-beta-development-notes-updated-november-2/#:~:text=Critical%20strikes%20in%20PvP%20no%20longer
[penanceblue]: https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696/5
[pallyblue]: https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin#holy-talents
[critui]: https://wowforever.be/news/the-character-panel-now-explains-every-stat/
[healtest]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/396
[bleed]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/468
[dynamic]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/137
[flametest]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/257
[renewtest]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/295
[penancerh]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/288
[penancetest]: https://us.forums.blizzard.com/en/wow/t/the-penance-problem/2374640?page=6
[streamtest]: https://us.forums.blizzard.com/en/wow/t/beta-resto-shaman-recap/2372793
[ancestral]: https://github.com/ClassicWoWCommunity/forever-bugs/issues/444
[renew]: https://www.wowhead.com/forever/tw/spell=139
[rejuv]: https://www.wowhead.com/forever/tw/spell=774
[regrowth]: https://www.wowhead.com/forever/spell=8939/regrowth
[eraregrowth]: https://www.wowhead.com/classic/tw/spell=9858
[growth]: https://www.wowhead.com/forever/tw/spell=408120
[riptide]: https://www.wowhead.com/forever/spell=408521/riptide
[tranq]: https://www.wowhead.com/forever/spell=9863/tranquility
[penance]: https://www.wowhead.com/forever/tw/spell=1316995
[penanceheal]: https://www.wowhead.com/forever/tw/spell=1316991
[vigil]: https://www.wowhead.com/forever/tw/spell=1311595
[vigilheal]: https://www.wowhead.com/forever/tw/spell=1311596
[stream]: https://www.wowhead.com/forever/spell=6371/healing-stream
[well]: https://www.wowhead.com/forever/tw/spell=724
[wellheal]: https://www.wowhead.com/forever/tw/spell=7001
[blessed]: https://www.wowhead.com/forever/tw/spell=27811
[plague]: https://www.wowhead.com/forever/tw/spell=2944
[hellfire]: https://www.wowhead.com/forever/tw/spell=5857
[ignite]: https://www.wowhead.com/forever/tw/spell=412545
[deep]: https://www.wowhead.com/forever/tw/spell=412609
[imprg]: https://www.wowhead.com/forever/changes/talents/druid/improved-regrowth
[majesty]: https://www.wowhead.com/forever/changes/talents/druid/natures-majesty
[druidguide]: https://www.wowhead.com/forever/guide/classes/druid/restoration/healer-abilities
[rotset]: https://bindonforever.com/set/2133
[logging]: https://forever.wowcoach.gg/how-to-record-combat-log/
