# 阿聖治療幫手｜永恆 ptBR 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=ptBR)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 para 103 pontos de vida` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=8) |
| HoT 總量和持續時間 | `32 pontos de vida do alvo ao longo de 12 s.` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=8) |
| 每跳間隔 | `a cada 2 s por 10 s.` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=8) |
| 吸收 | `absorvendo 48 de dano` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=8) |
| 額外 HoT | `e mais 91 ao longo de 21 s.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=8) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `Cura 89 para 103 pontos de vida de um alvo aliado e mais 91 ao longo de 21 s.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=8) |
| Healing Touch | 5185 | `Cura 40 para 54 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=8) |
| Rejuvenation | 774 | `Cura 32 pontos de vida do alvo ao longo de 12 s.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=8) |
| Tranquility | 740 | `Regenera 91 pontos de vida de todos os integrantes próximos do grupo em um raio de 20 m a cada 2 s por 10`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=8) |
| Wild Growth | 408120 | `Cura 336 pontos de vida do alvo e do grupo dele ao longo de 7 s.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=8) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `Cura 47 para 57 pontos de vida do alvo.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=8) |
| Heal | 2054 | `Cura 260 para 300 pontos de vida do seu alvo.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=8) |
| Flash Heal | 2061 | `Cura 184 para 223 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=8) |
| Greater Heal | 2060 | `Feitiço de lançamento lento que cura 819 para 920 pontos de vida de um único alvo.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=8) |
| Renew | 139 | `Cura 45 pontos de vida do alvo ao longo de 15 s.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=8) |
| Power Word: Shield | 17 | `Recorre à alma do integrante do grupo para protegê-lo, absorvendo 48 de dano. Dura 30 s.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=8) |
| Prayer of Healing | 596 | `Uma prece poderosa que concede 179 para 191 de cura ao alvo e ao grupo dele.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=8) |
| Penance | 402174 | …`Sagrado a um inimigo ou curando 134 pontos de vida de um aliado instantaneamente e a cada 1 s por 2 s.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=8) |
| Prayer of Mending | 401859 | …`concede ao alvo uma cura de [(172 + (Cura * 0.42899999)) * (1 * 1)] na próxima vez`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=8) |
| Holy Nova | 15237 | …`Cura 50 para 57 pontos de vida de todos os integrantes do grupo em um raio de 10 m.`… | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=8) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `Cura 37 para 47 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=8) |
| Lesser Healing Wave | 8004 | `Cura 151 para 172 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=8) |
| Chain Heal | 1064 | `Cura 246 para 281 pontos de vida de um alvo aliado e se propaga para curar outros alvos próximos.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=8) |
| Riptide | 408521 | `Concede 445 de cura a um alvo aliado ao longo de 15 s e aumenta em 25% a eficácia`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=8) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `Cura 42 para 50 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=8) |
| Flash of Light | 19750 | `Cura 48 para 54 pontos de vida de um alvo aliado.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=8) |
| Holy Shock | 1311606 | …`Sagrado a um inimigo ou curando 110 para 118 pontos de vida de um aliado.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=8) |
| Light's Vigil | 1310911 | …`os integrantes do grupo dele em 326 para 344 pontos de vida. Apenas uma Luz Zelosa`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=8) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=8) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=8) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=8)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=8) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=8) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=8) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=8)
