# 阿聖治療幫手｜永恆 zhCN 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=zhCN)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89至103点生命值` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=4) |
| HoT 總量和持續時間 | `在12秒内恢复总计32点生命值` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=4) |
| 每跳間隔 | `每2秒恢复91点生命值，持续10秒` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=4) |
| 吸收 | `吸收48点伤害。持续30秒` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=4) |
| 額外 HoT | `额外的91点生命值` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=4) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `治疗友方目标，恢复89至103点生命值，并在21秒内恢复额外的91点生命值。` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=4) |
| Healing Touch | 5185 | `治疗友方目标，恢复40至54点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=4) |
| Rejuvenation | 774 | `治疗目标，在12秒内恢复总计32点生命值。` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=4) |
| Tranquility | 740 | `使20码内附近的所有队伍成员每2秒恢复91点生命值，持续10秒。`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=4) |
| Wild Growth | 408120 | `在7秒内为目标及其43.5码内的小队成员恢复336点生命值。`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=4) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `治疗目标，恢复47至57点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=4) |
| Heal | 2054 | `治疗目标，恢复260至300点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=4) |
| Flash Heal | 2061 | `治疗友方目标，恢复184至223点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=4) |
| Greater Heal | 2060 | `施法缓慢的法术，可以为单一目标治疗819至920点伤害。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=4) |
| Renew | 139 | `治疗目标，在15秒内恢复总计45点生命值。` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=4) |
| Power Word: Shield | 17 | `汲取一名队伍成员的灵魂力量，为其施加护盾，吸收48点伤害。持续30秒。`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=4) |
| Prayer of Healing | 596 | `强大的祷言，治疗目标及其小队，回复179至191点生命值。`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=4) |
| Penance | 402174 | `向目标释放圣光能量，立即对一名敌人造成45点神圣伤害，或为一名盟友恢复134点生命值，并在接下来的2秒内每1秒重复一次效果。` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=4) |
| Prayer of Mending | 401859 | `向目标施加一个法术，在该目标下一次受到伤害或获得非周期性治疗时为其恢复[(172 + (治疗中 * 0.42899999)) * (1 * 1)]点生命值。`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=4) |
| Holy Nova | 15237 | `在施法者周围引发神圣光芒爆炸，对10码内所有敌方目标造成26至30点神圣伤害，并为10码内所有小队成员恢复50至57点生命值。`… | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=4) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `治疗友方目标，恢复37至47点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=4) |
| Lesser Healing Wave | 8004 | `治疗友方目标，恢复151至172点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=4) |
| Chain Heal | 1064 | `为友方目标回复246至281点生命值，然后转而治疗附近的目标。`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=4) |
| Riptide | 408521 | `在15秒内为一个友方目标恢复445点生命值，并使你对该目标直接施放的治疗链效果提高25%。` | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=4) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `治疗友方目标，恢复42至50点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=4) |
| Flash of Light | 19750 | `治疗友方目标，恢复48至54点生命值。` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=4) |
| Holy Shock | 1311606 | `以神圣能量冲击目标，对一个敌人造成129至139点神圣伤害，或者为一个友方目标恢复110至118点生命值。` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=4) |
| Light's Vigil | 1310911 | …`你对其施放的下一个神圣震击不触发冷却，并为目标及其小队恢复326至344点生命值。`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=4) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=4) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=4) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=4)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=4) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=4) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=4) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=4)
