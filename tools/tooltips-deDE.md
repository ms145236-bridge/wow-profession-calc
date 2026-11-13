# 阿聖治療幫手｜永恆 deDE 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=deDE)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 bis 103` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=3) |
| HoT 總量和持續時間 | `12 Sek. lang 32 Punkt(e) Schaden` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=3) |
| 每跳間隔 | `10 Sek. lang alle 2 Sek. 91 Gesundheit` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=3) |
| 吸收 | `absorbiert dabei 48 Punkt(e) Schaden` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=3) |
| 額外 HoT | `über 21 Sek. um weitere 91` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=3) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `Heilt ein befreundetes Ziel um 89 bis 103 und über 21 Sek. um weitere 91.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=3) |
| Healing Touch | 5185 | `Heilt ein befreundetes Ziel um 40 bis 54 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=3) |
| Rejuvenation | 774 | `Heilt beim Ziel 12 Sek. lang 32 Punkt(e) Schaden.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=3) |
| Tranquility | 740 | `Regeneriert 10 Sek. lang alle 2 Sek. 91 Gesundheit aller Gruppenmitglieder innerhalb von 20 Metern.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=3) |
| Wild Growth | 408120 | `Heilt das Ziel und seine Gruppenmitglieder innerhalb von 43.5 Metern um ihn herum im Verlauf von 7 Sek. um 336 Gesundheit.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=3) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `Euer Ziel um 47 bis 57 Punkt(e) heilen.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=3) |
| Heal | 2054 | `Euer Ziel um 260 bis 300 Punkt(e) heilen.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=3) |
| Flash Heal | 2061 | `Heilt ein befreundetes Ziel um 184 bis 223 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=3) |
| Greater Heal | 2060 | `Ein langsam zu wirkender Zauber, der ein einzelnes Ziel um 819 bis 920 Punkt(e) heilt.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=3) |
| Renew | 139 | `Heilt das Ziel 15 Sek. lang um 45 Schadenspunkt(e).` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=3) |
| Power Word: Shield | 17 | `Nutzt die Seelenkraft des Gruppenmitglieds zum Abschirmen und absorbiert dabei 48 Punkt(e) Schaden. Hält 30 Sek. lang an.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=3) |
| Prayer of Healing | 596 | `Ein mächtiges Gebet, das das Ziel und seine Gruppenmitglieder um 179 bis 191 Gesundheit heilt.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=3) |
| Penance | 402174 | …`oder ein verbündetes Ziel sofort sowie 2 Sek. lang alle 1 Sek. um 134 Gesundheit heilt.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=3) |
| Prayer of Mending | 401859 | …`mit einem Zauber, der es um [(172 + (Heilung * 0.42899999)) * (1 * 1)] Gesundheit heilt, wenn`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=3) |
| Holy Nova | 15237 | …`Zusätzlich werden alle Gruppenmitglieder innerhalb von 10 Metern um 50 bis 57 Gesundheit geheilt.`… | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=3) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `Heilt ein befreundetes Ziel um 37 bis 47 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=3) |
| Lesser Healing Wave | 8004 | `Heilt ein befreundetes Ziel um 151 bis 172 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=3) |
| Chain Heal | 1064 | `Heilt das verbündete Ziel um 246 bis 281 Gesundheit und springt dann weiter, um weitere Ziele in der Nähe zu heilen.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=3) |
| Riptide | 408521 | `Heilt ein befreundetes Ziel im Verlauf von 15 Sek. um 445 Gesundheit.`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=3) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `Heilt ein befreundetes Ziel um 42 bis 50 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=3) |
| Flash of Light | 19750 | `Heilt ein befreundetes Ziel um 48 bis 54 Punkt(e).` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=3) |
| Holy Shock | 1311606 | `Überzieht das Ziel mit heiliger Energie, die Gegnern 129 bis 139 Heiligschaden zufügt oder Verbündete um 110 bis 118 Gesundheit heilt.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=3) |
| Light's Vigil | 1310911 | …`das Ziel sowie dessen Gruppe um 326 bis 344 geheilt. Pro Paladin und Gruppe kann nur`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=3) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=3) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=3) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=3)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=3) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=3) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=3) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=3)
