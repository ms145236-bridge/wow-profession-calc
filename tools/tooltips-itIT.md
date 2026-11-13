# 阿聖治療幫手｜永恆 itIT 技能說明

- 家族原文查到 **0／23**，查無 **23**。
- 各階 DB2 說明查到 **0／139**，查無 **139**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=itIT)

Blizzard 的 1.60.1.70938 安裝設定 `supported_locales` 不含 itIT，客服也確認永恆沒有原生義大利語。 [Blizzard 版本對照](https://us.version.battle.net/v2/products/wowf/versions) · [Blizzard 安裝設定](https://us.cdn.blizzard.com/tpr/configs/data/0d/21/0d21f2f209a32c57f8c9b838cb35fd0a) · [Blizzard 客服說明](https://eu.forums.blizzard.com/it/wow/t/sar%C3%A0-localizzato-in-italiano/10302/4)

已比對永恆 1.60.1.70938。Wago 的 itIT `Spell` 和 `GlobalStrings` 匯出與 enUS 逐位元組相同。Wowhead locale=9 把部分範圍連接詞顯示成 `a`，Regrowth 內文其餘仍是英文。這裡把 23 家族列為 itIT 查無，另附英語範例供回退時比對。遊戲內若設定義大利語後的 `C_Spell.GetSpellDescription` 行為【需遊戲實測】。 [itIT Spell](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=itIT) · [enUS Spell](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=enUS) · [itIT GlobalStrings](https://wago.tools/db2/GlobalStrings/csv?build=1.60.1.70938&locale=itIT) · [enUS GlobalStrings](https://wago.tools/db2/GlobalStrings/csv?build=1.60.1.70938&locale=enUS) · [Wowhead Regrowth locale=9](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=9)

- Spell CSV 的 SHA-256 為 `d81a61397d9ecbc467a77767c4a3c231e9041ed08005c1716cdba6d3fe320ab5`。
- GlobalStrings CSV 的 SHA-256 為 `ed9bc18780af1f74a9d61912d15abb2faa56309cdbfbef48f2e018c3a7822c9e`。

## 治療描述辨識片段（enUS 回退參照）

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 to 103` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=0) |
| HoT 總量和持續時間 | `32 over 12 sec.` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=0) |
| 每跳間隔 | `91 every 2 sec for 10 sec.` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) |
| 吸收 | `absorbing 48 damage` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=0) |
| 額外 HoT | `and another 91 over 21 sec.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=0) |

## 德魯伊

| 家族 | SpellID | itIT | 英文回退範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|---|
| Regrowth | 8936 | 查無 | `Heals a friendly target for 89 to 103 and another 91 over 21 sec.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=9) |
| Healing Touch | 5185 | 查無 | `Heals a friendly target for 40 to 54.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=9) |
| Rejuvenation | 774 | 查無 | `Heals the target for 32 over 12 sec.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/774?locale=9) |
| Tranquility | 740 | 查無 | `Regenerates all nearby party members within 20 yards for 91 every 2 sec for 10 sec.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/740?locale=9) |
| Wild Growth | 408120 | 查無 | `Heals the target and their party for 336 over 7 sec.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=9) |

## 牧師

| 家族 | SpellID | itIT | 英文回退範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|---|
| Lesser Heal | 2050 | 查無 | `Heal your target for 47 to 57.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=9) |
| Heal | 2054 | 查無 | `Heal your target for 260 to 300.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=9) |
| Flash Heal | 2061 | 查無 | `Heals a friendly target for 184 to 223.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=9) |
| Greater Heal | 2060 | 查無 | `A slow casting spell that heals a single target for 819 to 920.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=9) |
| Renew | 139 | 查無 | `Heals the target of 45 damage over 15 sec.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/139?locale=9) |
| Power Word: Shield | 17 | 查無 | `Draws on the soul of the party member to shield them, absorbing 48 damage.  Lasts 30 sec.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/17?locale=9) |
| Prayer of Healing | 596 | 查無 | `A powerful prayer that heals the target and their party for 179 to 191.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/596?locale=9) |
| Penance | 402174 | 查無 | …`Holy damage to an enemy, or 134 healing to an ally, instantly and every 1 sec for 2 sec.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=9) |
| Prayer of Mending | 401859 | 查無 | …`the target that heals them for [(172 + (Healing * 0.42899999)) * (1 * 1)] the next time`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=9) |
| Holy Nova | 15237 | 查無 | …`party members within 10 yards for 50 to 57. These effects cause no threat.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=9) |

## 薩滿

| 家族 | SpellID | itIT | 英文回退範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|---|
| Healing Wave | 331 | 查無 | `Heals a friendly target for 37 to 47.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/331?locale=9) |
| Lesser Healing Wave | 8004 | 查無 | `Heals a friendly target for 151 to 172.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=9) |
| Chain Heal | 1064 | 查無 | `Heals the friendly target for 246 to 281, then jumps to heal additional nearby targets.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=9) |
| Riptide | 408521 | 查無 | `Heals a friendly target for 445 over 15 sec, and increases the effectiveness of your Chain Heal casts directly on that target by 25%.` | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=9) |

## 聖騎士

| 家族 | SpellID | itIT | 英文回退範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|---|
| Holy Light | 635 | 查無 | `Heals a friendly target for 42 to 50.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/635?locale=9) |
| Flash of Light | 19750 | 查無 | `Heals a friendly target for 48 to 54.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=9) |
| Holy Shock | 1311606 | 查無 | `Blasts the target with Holy energy, causing 129 to 139 Holy damage to an enemy, or 110 to 118 healing to an ally.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=9) |
| Light's Vigil | 1310911 | 查無 | …`The caster's next Holy Shock on the target incurs no cooldown and heals the target and their party for 326 to 344.`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=0) · [itIT 回退](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=9) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=0) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=0) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=0)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=0) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=0) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=0) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=0)
