# 阿聖治療幫手｜永恆 frFR 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=frFR)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 à 103` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=2) |
| HoT 總量和持續時間 | `32 points de vie à la cible en 12 sec.` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=2) |
| 每跳間隔 | `toutes les 2 s pendant 10 sec.` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=2) |
| 吸收 | `absorbe 48 points de dégâts` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=2) |
| 額外 HoT | `91 points supplémentaires pendant 21 sec.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=2) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `Soigne une cible amie pour 89 à 103 puis pour 91 points supplémentaires pendant 21 sec.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=2) |
| Healing Touch | 5185 | `Rend 40 à 54 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=2) |
| Rejuvenation | 774 | `Rend 32 points de vie à la cible en 12 sec.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=2) |
| Tranquility | 740 | `Régénère de 91 les points de vie des membres du groupe à moins de 20 m toutes les 2 s pendant 10 sec.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=2) |
| Wild Growth | 408120 | `Rend 336 points de vie en 7 sec à la cible et aux membres`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=2) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `Soigne la cible de 47 à 57 points de vie.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=2) |
| Heal | 2054 | `Soigne la cible de 260 à 300 points de vie.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=2) |
| Flash Heal | 2061 | `Rend 184 à 223 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=2) |
| Greater Heal | 2060 | `Une longue incantation qui rend 819 à 920 points de vie à une cible unique.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=2) |
| Renew | 139 | `Rend 45 points de vie à la cible en 15 sec.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=2) |
| Power Word: Shield | 17 | `Puise dans l’âme du membre du groupe pour le protéger et absorbe 48 points de dégâts. Dure 30 sec.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=2) |
| Prayer of Healing | 596 | `Puissante prière qui restitue 179 à 191 points de vie à la cible et`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=2) |
| Penance | 402174 | …`à un personnage adverse ou rend 134 points de vie à un personnage allié instantanément et toutes les 1 s pendant 2 sec.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=2) |
| Prayer of Mending | 401859 | …`cible un sort qui lui rend [(172 + (Soins * 0.42899999)) * (1 * 1)] points de vie`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=2) |
| Holy Nova | 15237 | …`zone de 10 m et rend 50 à 57 points de vie aux membres du groupe`… | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=2) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `Rend 37 à 47 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=2) |
| Lesser Healing Wave | 8004 | `Rend 151 à 172 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=2) |
| Chain Heal | 1064 | `Rend 246 à 281 points de vie à la cible alliée, puis soigne d’autres personnages alliés proches.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=2) |
| Riptide | 408521 | `Rend 445 points de vie à une cible alliée en 15 sec, et augmente l’efficacité de votre sort`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=2) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `Rend 42 à 50 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=2) |
| Flash of Light | 19750 | `Rend 48 à 54 points de vie à une cible alliée.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=2) |
| Holy Shock | 1311606 | …`sacré à un adversaire, ou rend 110 à 118 points de vie à un personnage allié.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=2) |
| Light's Vigil | 1310911 | …`et son groupe à hauteur de 326 à 344 points de vie. Une seule occurrence de`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=2) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=2) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=2) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=2)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=2) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=2) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=2) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=2)
