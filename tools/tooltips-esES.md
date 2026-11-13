# 阿聖治療幫手｜永恆 esES 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=esES)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 西班牙文區域差異

兩個語系 139 階的 DB2 說明字串逐筆有差異。兩者的範圍可見 `al`，持續時間用 `durante N s`，每跳用 `cada N s`。各自的治療動詞、詞序及額外治療措辭需保留。癒合 esES 用 `y otro en 91 p.`，esMX 用 `y otros 91 p.`。癒合禱言 esES 用 `lo sanará`，esMX 用 `le restaura`。 [esES DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=esES) · [esMX DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=esMX) · [esES 癒合](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=6) · [esMX 癒合](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=11) · [esES 癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=6) · [esMX 癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=11)

另一語系的逐家族範例見同目錄 `tooltips-esMX.md`。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 al 103 p.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=6) |
| HoT 總量和持續時間 | `32 p. durante 12 s.` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=6) |
| 每跳間隔 | `cada 2 s durante 10 s.` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=6) |
| 吸收 | `absorbe 48 p. de daño` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=6) |
| 額外 HoT | `y otro en 91 p. durante 21 s.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=6) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `Cura un objetivo amigo en 89 al 103 p. y otro en 91 p. durante 21 s.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=6) |
| Healing Touch | 5185 | `Cura un objetivo amigo en 40 al 54 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=6) |
| Rejuvenation | 774 | `Cura el objetivo en 32 p. durante 12 s.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=6) |
| Tranquility | 740 | `Regenera 91 p. a todos los miembros del grupo en un radio de 20 m cada 2 s durante 10 s.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=6) |
| Wild Growth | 408120 | `Sana 336 p. al objetivo y a su grupo durante 7 s.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=6) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `Cura tu objetivo en 47 al 57 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=6) |
| Heal | 2054 | `Cura tu objetivo en 260 al 300 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=6) |
| Flash Heal | 2061 | `Cura un objetivo amigo en 184 al 223 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=6) |
| Greater Heal | 2060 | `Un hechizo de consecución lenta que cura a un único objetivo en 819 al 920 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=6) |
| Renew | 139 | `Cura el objetivo en 45 p. de daño durante 15 s.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=6) |
| Power Word: Shield | 17 | `Atrae el alma de un miembro del grupo para protegerlo y absorbe 48 p. de daño. Dura 30 s.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=6) |
| Prayer of Healing | 596 | `Un poderoso rezo que sana 179 al 191 p. al objetivo y a su grupo.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=6) |
| Penance | 402174 | …`Sagrado a un enemigo o aplica 134 p. de sanación a un aliado de forma instantánea y cada 1 s durante 2 s.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=6) |
| Prayer of Mending | 401859 | …`sobre el objetivo que lo sanará [(172 + (Sanacíon * 0.42899999)) * (1 * 1)] p. la próxima`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=6) |
| Holy Nova | 15237 | …`radio de 10 m y sana 50 al 57 p. a todos los miembros del grupo`… | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=6) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `Cura un objetivo amigo en 37 al 47 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=6) |
| Lesser Healing Wave | 8004 | `Cura un objetivo amigo en 151 al 172 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=6) |
| Chain Heal | 1064 | `Sana primero a un objetivo amistoso 246 al 281 p. y después a otros objetivos cercanos.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=6) |
| Riptide | 408521 | `Sana a un objetivo amistoso 445 p. durante 15 s.`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=6) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `Cura un objetivo amigo en 42 al 50 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=6) |
| Flash of Light | 19750 | `Cura un objetivo amigo en 48 al 54 p.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=6) |
| Holy Shock | 1311606 | …`Sagrado a un enemigo o sana 110 al 118 p. a un aliado.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=6) |
| Light's Vigil | 1310911 | …`el tiempo de reutilización y sana 326 al 344 p. al objetivo y su grupo. Solo`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=6) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=6) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=6) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=6)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=6) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=6) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=6) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=6)
