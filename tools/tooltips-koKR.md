# 阿聖治療幫手｜永恆 koKR 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=koKR)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 에서 103만큼` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=1) |
| HoT 總量和持續時間 | `12초에 걸쳐 32의 생명력` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=1) |
| 每跳間隔 | `10초 동안 2초마다` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=1) |
| 吸收 | `48의 피해를 흡수합니다` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=1) |
| 額外 HoT | `추가로 21초에 걸쳐 총 91` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=1) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `대상의 생명력을 89 에서 103만큼 회복시키고 추가로 21초에 걸쳐 총 91의 생명력을 회복시킵니다.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=1) |
| Healing Touch | 5185 | `대상의 생명력을 40 에서 54만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=1) |
| Rejuvenation | 774 | `12초에 걸쳐 32의 생명력을 회복시킵니다.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=1) |
| Tranquility | 740 | `10초 동안 2초마다 20미터 내 주위 모든 파티원의 생명력을 91만큼 회복시킵니다.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=1) |
| Wild Growth | 408120 | `대상과 대상의 파티를 7초에 걸쳐 336만큼 치유합니다.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=1) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `대상의 생명력을 47 에서 57만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=1) |
| Heal | 2054 | `대상의 생명력을 260 에서 300만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=1) |
| Flash Heal | 2061 | `대상의 생명력을 184 에서 223만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=1) |
| Greater Heal | 2060 | `대상의 생명력을 819 에서 920만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=1) |
| Renew | 139 | `15초에 걸쳐 대상의 생명력을 총 45만큼 회복시킵니다.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=1) |
| Power Word: Shield | 17 | `파티원의 영적인 힘을 이용하여 즉시 보호막을 생성하여 48의 피해를 흡수합니다. 30초 동안 지속됩니다.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=1) |
| Prayer of Healing | 596 | `강력한 기원으로 대상과 대상의 파티를 179 에서 191만큼 치유합니다.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=1) |
| Penance | 402174 | …`적에게는 즉시, 그리고 2초 동안 1초마다 45의 신성 피해를 입히며, 아군에게는 같은 주기로 134만큼 생명력을 회복시킵니다.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=1) |
| Prayer of Mending | 401859 | `대상에 주문을 걸어두어, 다음 피해를 받거나 비주기적인 치유를 받을 때 [(172 + (치유 * 0.42899999)) * (1 * 1)]의 생명력을 회복하게 합니다.`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=1) |
| Holy Nova | 15237 | …`입히고 10미터 반경 내의 파티원의 생명력을 50 에서 57만큼 치유합니다. 이 주문은 위협 수준을 생성하지 않습니다.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=1) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `대상의 생명력을 37 에서 47만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=1) |
| Lesser Healing Wave | 8004 | `대상의 생명력을 151 에서 172만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=1) |
| Chain Heal | 1064 | `대상의 생명력을 246 에서 281만큼 회복시키고 그 주위의 아군을 연쇄적으로 회복시킵니다.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=1) |
| Riptide | 408521 | `아군 대상을 만큼 15초에 걸쳐 445만큼 회복시킵니다.`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=1) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `대상의 생명력을 42 에서 50만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=1) |
| Flash of Light | 19750 | `대상의 생명력을 48 에서 54만큼 회복시킵니다.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=1) |
| Holy Shock | 1311606 | `대상을 성스러운 기운으로 강타하여 129 에서 139의 신성 피해를 입히거나, 아군의 생명력을 110 에서 118만큼 회복시킵니다.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=1) |
| Light's Vigil | 1310911 | …`시전자가 대상에게 사용하는 다음 신성 충격이 재사용 대기시간을 발생시키지 않고, 대상과 대상의 파티를 326 에서 344만큼 치유합니다.`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=1) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=1) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=1) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=1)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=1) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=1) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=1) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=1)
