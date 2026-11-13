# 阿聖治療幫手的永恆 enUS 技能說明

- 查到 23 個遊戲技能家族、139 階，查無 0 家族、0 階。四職業均已覆蓋。插件的 24 個資料項包含兩筆共用 Regrowth 的直接治療與 HoT 顯示。
- 139 階均核對永恆 1.60.1.70938 的英文技能名、階級副標題與說明模板，並取得 Wowhead Forever 英文 tooltip JSON。未擷取遊戲內畫面，需實測的動態顯示列於文末。 [SpellName DB2](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=enUS) · [Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS)

表中 `A`、`B` 是最小／最大量，`N` 是總量或單次量，`T` 是持續秒數，`I` 是每跳間隔，`R` 是距離。英文欄保留辨識所需的原文片段，中間省略的字用 `…`。數字是 Wowhead 該階英文說明的顯示範例，可拿來驗證讀取位置。直接治療範圍會隨來源的角色等級或天賦條件變動，這些範例沒有用來覆蓋插件的基礎數值。每行的資料連結均指向該階英文 tooltip。 [Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS)

## 法力、施法、冷卻、階級

| 欄位 | 永恆 enUS 字串／模板 | 說明 |
| --- | --- | --- |
| 法力 | `N Mana` | `MANA_COST`、`MANA_COST_LARGE` 使用 `%s Mana`。核對的 139 階皆為固定法力成本。共用字串另有 `N Mana, plus M per sec` 和 `N Mana per sec`，供有持續消耗的技能使用。 |
| 讀條 | `N sec cast` | `SPELL_CAST_TIME_SEC` 使用 `%.2g sec cast`，可含小數，例如 `1.5 sec cast`。另有 `N min cast`。 |
| 瞬發 | `Instant` | `SPELL_CAST_TIME_INSTANT` 和 `SPELL_CAST_TIME_INSTANT_NO_MANA` 共用此顯示。 |
| 引導 | `Channeled` | `SPELL_CAST_CHANNELED` 的字串。Wowhead 寧靜頁顯示 `Channeled (10 sec cast)`，懺悟頁只有 `Channeled`，持續時間從說明內文讀取。 |
| 冷卻 | `N sec cooldown` 或 `N min cooldown` | 字串表另有 `hour`、`day`。有真正冷卻的技能才從這欄取值。沒有該欄的範例標 `—`，公共冷卻與同目標限制各有自己的資料。 |
| 階級 | `Rank N` | `Spell.NameSubtext_lang` 的 139 筆均為此格式。Wowhead tooltip 頁首的 `Level` 和 `Requires level` 是不同欄位。 |

[永恆 GlobalStrings DB2](https://wago.tools/db2/GlobalStrings/csv?build=1.60.1.70938&locale=enUS) · [永恆 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=0)

## 治療內文

### 德魯伊

| 技能 | 英文辨識片段 | 第一階顯示範例（法力／施法／冷卻）與欄位 | 來源 |
| --- | --- | --- | --- |
| 癒合 Regrowth | `for A to B and another N over T sec` | 70／2 秒／—。直接 89–103，另有 91／21 秒。9 階為 525 法力、2 秒、999–1111，另有 994／21 秒。 | [1 階 #8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=0) · [9 階 #9858](https://nether.wowhead.com/forever/tooltip/spell/9858?locale=0) |
| 治療之觸 Healing Touch | `Heals a friendly target for A to B` | 25／1.5 秒／—。40–54。 | [#5185](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=0) |
| 回春術 Rejuvenation | `Heals the target for N over T sec` | 25／瞬發／—。總量 32／12 秒。光環說明為每 3 秒 8。 | [#774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=0) |
| 寧靜 Tranquility | `within R yards for N every I sec for T sec` | 375／引導 10 秒／5 分鐘。20 碼內每 2 秒 91。 | [#740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) |
| 野性痊癒 Wild Growth | `their party for N over T sec` | 550／3 秒／6 秒。總量 336／7 秒，目標周圍 43.5 碼。1 階用 `yards`，2、3 階用 `yds`。文字另寫每跳量隨時間減少。 | [1 階 #408120](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=0) · [2 階 #1238214](https://nether.wowhead.com/forever/tooltip/spell/1238214?locale=0) · [3 階 #1238215](https://nether.wowhead.com/forever/tooltip/spell/1238215?locale=0) |

### 牧師

| 技能 | 英文辨識片段 | 第一階顯示範例（法力／施法／冷卻）與欄位 | 來源 |
| --- | --- | --- | --- |
| 次級治療術 Lesser Heal | `Heal your target for A to B` | 30／1.5 秒／—。47–57。開頭用 `Heal`。 | [#2050](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=0) |
| 治療術 Heal | `Heal your target for A to B` | 155／3 秒／—。260–300。 | [#2054](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=0) |
| 快速治療 Flash Heal | `Heals a friendly target for A to B` | 125／1.5 秒／—。184–223。 | [#2061](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=0) |
| 強效治療術 Greater Heal | `heals a single target for A to B` | 370／3 秒／—。819–920。此片段出現在句中。 | [#2060](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=0) |
| 恢復 Renew | `Heals the target of N damage over T sec` | 30／瞬發／—。總量 45／15 秒，光環說明為每 3 秒 9。此處 `damage` 描述被治好的傷害。 | [#139](https://nether.wowhead.com/forever/tooltip/spell/139?locale=0) |
| 真言術：盾 Power Word: Shield | `absorbing N damage`、`Lasts T sec`、`again for T sec` | 45／瞬發／4 秒。吸收 48，盾持續 30 秒，同目標虛弱靈魂 15 秒。第 1 階 DB2 模板另有天賦條件分支。 | [1 階 #17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=0) · [10 階 #10901](https://nether.wowhead.com/forever/tooltip/spell/10901?locale=0) · [虛弱靈魂 #6788](https://nether.wowhead.com/forever/tooltip/spell/6788?locale=0) |
| 治療禱言 Prayer of Healing | `heals the target and their party for A to B` | 410／3 秒／—。目標與其小隊每人 179–191，範圍從目標起算 40 碼。 | [#596](https://nether.wowhead.com/forever/tooltip/spell/596?locale=0) |
| 懺悟 Penance | `N healing to an ally`、`instantly and every I sec for T sec` | 150／引導／12 秒。友方每發 134，立即一發、其後每秒一發，說明持續 2 秒。敵方傷害 45 在前一分句。 | [#402174](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=0) · [治療子法術 #402289](https://nether.wowhead.com/forever/tooltip/spell/402289?locale=0) |
| 癒合禱言 Prayer of Mending | `heals them for …`、`Jumps up to N times` | 210／瞬發／10 秒。Wowhead 顯示公式，基礎 172 加 `Healing × 0.42899999` 再乘修正值，跳躍距離 20 碼，每次跳躍後 30 秒，文案稱最多跳躍 5 次。 | [#401859](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=0) |
| 神聖新星 Holy Nova | `healing all party members within R yards for A to B` | 185／瞬發／—。10 碼內治療 50–57，前一分句的敵方傷害為 26–30。2–6 階另有 Holy Fire 觸發免費施法的文字。 | [1 階 #15237](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=0) · [2 階 #15430](https://nether.wowhead.com/forever/tooltip/spell/15430?locale=0) |

### 薩滿

| 技能 | 英文辨識片段 | 第一階顯示範例（法力／施法／冷卻）與欄位 | 來源 |
| --- | --- | --- | --- |
| 治療波 Healing Wave | `Heals a friendly target for A to B` | 25／1.5 秒／—。37–47。 | [#331](https://nether.wowhead.com/forever/tooltip/spell/331?locale=0) |
| 次級治療波 Lesser Healing Wave | `Heals a friendly target for A to B` | 105／1.5 秒／—。151–172。 | [#8004](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=0) |
| 治療鍊 Chain Heal | `Heals the friendly target for A to B`、`Heals N total targets` | 260／2.5 秒／—。首跳 246–281，共 3 個目標。每跳為前一跳的 50%，DB2 另有符合光環 #415096 時顯示 65% 的分支。 | [#1064](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=0) · [Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS) |
| 激流 Riptide | `for N over T sec` | 150／瞬發／12 秒。總量 445／15 秒，光環說明為每 3 秒 89。後面的 25% 是直接對該目標施放治療鍊的增益。 | [#408521](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=0) |

### 聖騎士

| 技能 | 英文辨識片段 | 第一階顯示範例（法力／施法／冷卻）與欄位 | 來源 |
| --- | --- | --- | --- |
| 聖光術 Holy Light | `Heals a friendly target for A to B` | 35／2.5 秒／—。42–50。 | [#635](https://nether.wowhead.com/forever/tooltip/spell/635?locale=0) |
| 聖光閃現 Flash of Light | `Heals a friendly target for A to B` | 35／1.5 秒／—。48–54。 | [#19750](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=0) |
| 神聖震擊 Holy Shock | `A to B healing to an ally` | 160／瞬發／10 秒。治療 110–118，前一分句的傷害為 129–139。 | [#1311606](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=0) |
| 聖光戒備 Light's Vigil | `heals the target and their party for A to B` | 730／1.5 秒／6 秒。先給 30 秒戒備，下一次對該目標用神聖震擊觸發 326–344 的小隊治療。 | [#1310911](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=0) · [觸發治療 #1310912](https://nether.wowhead.com/forever/tooltip/spell/1310912?locale=0) |

## 英文讀取的待確認項目

- `ShengHealing/Core.lua` 會用遊戲 API 讀法力、施法毫秒與基礎冷卻。治療量的文字讀取另走 `C_Spell.GetSpellDescription`。目前範圍解析支援 `to`，排除傷害分句只找中文「造成」，因此英文 Holy Nova、Holy Shock 可能取到傷害範圍。HoT、吸收、額外癒合量與持續時間的幾個分支只比對中文字串，enUS 目前會依情形回退到資料表。表中的範例可作為辨識分句與數值的測例。 [Holy Nova](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=0) · [Holy Shock](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=0)
- `ShengHealing/Data.lua` 的名稱種子仍有 `48438`（Wild Growth）、`61295`（Riptide）、`33076`（Prayer of Mending）。三個 ID 均未出現在 70938 的 `SpellName` 表。永恆第一階 ID 依序為 `408120`、`408521`、`401859`。舊 ID 是否另有用戶端相容別名【需遊戲實測】。 [SpellName DB2](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=enUS)
- 癒合禱言在遊戲內回傳已求值的整數或公式字串，以及癒合與真言術：盾在穿脫治療裝、切換天賦後的顯示值【需遊戲實測】。可從 enUS 角色記錄原始 `C_Spell.GetSpellDescription` 和法術書提示，以確認顯示值如何受裝備與天賦影響。 [Prayer of Mending](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=0) · [Regrowth](https://nether.wowhead.com/forever/tooltip/spell/9858?locale=0) · [Power Word: Shield](https://nether.wowhead.com/forever/tooltip/spell/10901?locale=0)
- 寧靜與懺悟在 enUS 遊戲內的引導提示排列與 `C_Spell.GetSpellInfo().castTime` 實值【需遊戲實測】。目前可由描述取得 10 秒與 2 秒，冷卻另讀。寧靜的 2 分鐘天賦冷卻在 Wowhead 回傳中有獨立註記，表中採顯示的 5 分鐘基礎冷卻。 [Tranquility](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) · [Penance](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=0)

## 各階核對索引

依序是第 1 階起的 `SpellID`。每列均已逐階比對 `SpellName.Name_lang`、`Spell.NameSubtext_lang`、`Spell.Description_lang` 與相同 ID 的 Forever 英文 tooltip。 [SpellName DB2](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=enUS) · [Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS)

| 家族 | 階數 | SpellID |
| --- | ---: | --- |
| Regrowth | 9 | 8936、8938、8939、8940、8941、9750、9856、9857、9858 |
| Healing Touch | 11 | 5185、5186、5187、5188、5189、6778、8903、9758、9888、9889、25297 |
| Rejuvenation | 11 | 774、1058、1430、2090、2091、3627、8910、9839、9840、9841、25299 |
| Tranquility | 4 | 740、8918、9862、9863 |
| Wild Growth | 3 | 408120、1238214、1238215 |
| Power Word: Shield | 10 | 17、592、600、3747、6065、6066、10898、10899、10900、10901 |
| Penance | 4 | 402174、1240720、1240721、1316995 |
| Holy Nova | 6 | 15237、15430、15431、27799、27800、27801 |
| Prayer of Mending | 3 | 401859、1240826、1240827 |
| Lesser Heal | 3 | 2050、2052、2053 |
| Heal | 4 | 2054、2055、6063、6064 |
| Flash Heal | 7 | 2061、9472、9473、9474、10915、10916、10917 |
| Greater Heal | 5 | 2060、10963、10964、10965、25314 |
| Renew | 10 | 139、6074、6075、6076、6077、6078、10927、10928、10929、25315 |
| Prayer of Healing | 5 | 596、996、10960、10961、25316 |
| Light's Vigil | 3 | 1310911、1311590、1311595 |
| Holy Shock | 4 | 1311606、20473、20929、20930 |
| Holy Light | 9 | 635、639、647、1026、1042、3472、10328、10329、25292 |
| Flash of Light | 6 | 19750、19939、19940、19941、19942、19943 |
| Healing Wave | 10 | 331、332、547、913、939、959、8005、10395、10396、25357 |
| Lesser Healing Wave | 6 | 8004、8008、8010、10466、10467、10468 |
| Chain Heal | 3 | 1064、10622、10623 |
| Riptide | 3 | 408521、1239242、1239243 |
