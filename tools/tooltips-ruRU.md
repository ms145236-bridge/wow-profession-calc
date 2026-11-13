# 阿聖治療幫手｜永恆 ruRU 技能說明

- 家族原文查到 **23／23**，查無 **0**。
- 各階 DB2 說明查到 **139／139**，查無 **0**。逐階核對 `Spell.Description_lang`。下表每家族取第一階的公開顯示範例。 [永恆 1.60.1.70938 Spell DB2](https://wago.tools/db2/Spell/csv?build=1.60.1.70938&locale=ruRU)

例句照錄 Wowhead Forever 的對應語系資料，移除 HTML 標記，保留原有大小寫、拼法及分隔字。行首或行尾的省略號表示截取。數值是提示在該查詢條件下的顯示值。

## 治療描述辨識片段

| 類型 | 實際片段 | 來源 |
|---|---|---|
| 直接治療範圍 | `89 в 103 ед.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=7) |
| HoT 總量和持續時間 | `32 ед. в течение 12 сек.` | [774](https://nether.wowhead.com/forever/tooltip/spell/774?locale=7) |
| 每跳間隔 | `91 ед. здоровья раз в 2 сек. в течение 10 сек.` | [740](https://nether.wowhead.com/forever/tooltip/spell/740?locale=7) |
| 吸收 | `поглощающий 48 ед. урона` | [17](https://nether.wowhead.com/forever/tooltip/spell/17?locale=7) |
| 額外 HoT | `еще 91 ед. в течение 21 сек.` | [8936](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=7) |

## 德魯伊

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Regrowth | 8936 | `Исцеление дружественной цели на 89 в 103 ед. и еще 91 ед. в течение 21 сек.` | 直接治療範圍、額外 HoT 總量、HoT 時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8936?locale=7) |
| Healing Touch | 5185 | `Исцеление дружественной цели на 40 в 54 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/5185?locale=7) |
| Rejuvenation | 774 | `Излечение цели на 32 ед. в течение 12 сек.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/774?locale=7) |
| Tranquility | 740 | `Восполняет участникам группы в радиусе 20 м 91 ед. здоровья раз в 2 сек. в течение 10 сек.`… | 範圍、每跳量、每跳間隔、引導時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/740?locale=7) |
| Wild Growth | 408120 | `Восполняет цели и участникам ее группы в радиусе 43.5 м 336 ед. здоровья за 7 сек.`… | 群體 HoT 總量、持續時間。距離是獨立欄位 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408120?locale=7) |

## 牧師

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Lesser Heal | 2050 | `Исцеление цели на 47 в 57 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2050?locale=7) |
| Heal | 2054 | `Исцеление цели на 260 в 300 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2054?locale=7) |
| Flash Heal | 2061 | `Исцеление дружественной цели на 184 в 223 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2061?locale=7) |
| Greater Heal | 2060 | `Медленно накладываемое заклинание, которое излечивает одну цель на 819 в 920 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/2060?locale=7) |
| Renew | 139 | `Излечение цели на 45 ед. в течение 15 сек.` | HoT 總量、持續時間 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/139?locale=7) |
| Power Word: Shield | 17 | `Вытягивает частичку души участника группы и создает из нее щит, поглощающий 48 ед. урона. Время действия – 30 сек.`… | 吸收量、護盾時間。再次套盾限制有獨立秒數 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/17?locale=7) |
| Prayer of Healing | 596 | `Действенная молитва восстанавливает цели и участникам ее группы 179 в 191 ед. здоровья.`… | 每個目標的直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/596?locale=7) |
| Penance | 402174 | …`от светлой магии или восполняющие союзнику 134 ед. здоровья сразу и затем еще раз в 1 сек. в течение 2 сек.` | 每發友方治療、每跳間隔與引導時間。敵方數字是傷害 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=7) |
| Prayer of Mending | 401859 | `Применяет к цели заклинание, восполняющее ей [(172 + (Исцеление * 0.42899999)) * (1 * 1)] ед. здоровья при`… | 每次觸發治療，公開提示可能含公式 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=7) |
| Holy Nova | 15237 | …`участникам группы в радиусе 10 м 50 в 57 ед. здоровья. Не повышает уровень угрозы.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=7) |

## 薩滿

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Healing Wave | 331 | `Исцеление дружественной цели на 37 в 47 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/331?locale=7) |
| Lesser Healing Wave | 8004 | `Исцеление дружественной цели на 151 в 172 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/8004?locale=7) |
| Chain Heal | 1064 | `Восполняет союзнику 246 в 281 ед. здоровья, а затем переходит на соседние цели.`… | 首跳治療範圍。每跳衰減及目標數各有自己的數字 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1064?locale=7) |
| Riptide | 408521 | `Восстанавливает союзнику 445 ед. здоровья за 15 сек.`… | HoT 總量、持續時間。25% 是治療鍊加成 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/408521?locale=7) |

## 聖騎士

| 家族 | SpellID | 原文範例 | 辨識欄位 | 來源 |
|---|---:|---|---|---|
| Holy Light | 635 | `Исцеляет дружественную цель на 42 в 50 ед. здоровья.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/635?locale=7) |
| Flash of Light | 19750 | `Исцеление дружественной цели на 48 в 54 ед.` | 直接治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/19750?locale=7) |
| Holy Shock | 1311606 | `Переполняет цель мощью светлой магии, нанося 129 в 139 ед. урона противнику или восстанавливая 110 в 118 ед. здоровья союзнику.` | 取友方治療範圍 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=7) |
| Light's Vigil | 1310911 | …`Следующий "Шок небес", который вы примените к цели, не активирует время восстановления и восстановит 326 в 344 ед. здоровья цели и остальным участникам группы.`… | 觸發後的群體治療範圍。30 秒是戒備本身 | [Forever tooltip](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=7) |

## 待遊戲實測

- 癒合禱言的公開提示可能保留運算式，確認遊戲內 `C_Spell.GetSpellDescription` 是否已代入角色屬性。寧靜、懺悟可用「每跳間隔」和「持續時間」兩欄互相驗證。 [癒合禱言](https://nether.wowhead.com/forever/tooltip/spell/401859?locale=7) · [寧靜](https://nether.wowhead.com/forever/tooltip/spell/740?locale=7) · [懺悟](https://nether.wowhead.com/forever/tooltip/spell/402174?locale=7)

- 神聖新星、神聖震擊先分辨傷害和治療句段，再取數值。真言術：盾、聖光戒備要分辨護盾／戒備持續時間和其他秒數。法力、施法時間、冷卻仍可由遊戲 API 讀取。 [神聖新星](https://nether.wowhead.com/forever/tooltip/spell/15237?locale=7) · [神聖震擊](https://nether.wowhead.com/forever/tooltip/spell/1311606?locale=7) · [真言術：盾](https://nether.wowhead.com/forever/tooltip/spell/17?locale=7) · [聖光戒備](https://nether.wowhead.com/forever/tooltip/spell/1310911?locale=7)
