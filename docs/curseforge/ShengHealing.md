**專案名稱：** 阿聖治療幫手 ShengHealing
**授權（License）：** GPL-3.0
**系列：** 阿聖 Sheng（另有 阿聖練等幫手 ShengLeveling、阿聖專業幫手 ShengProfession）
**摘要（Summary，英文）：** Compare HPS and HPM of every healing spell and rank in WoW Forever, and simulate fights to find the most mana-efficient way to keep the tank alive.
**語言：** 英文（enUS）、繁體中文（zhTW），依遊戲語言自動切換

---

# ShengHealing (WoW Forever)

Compares **HPS** (healing per second) and **HPM** (healing per mana) for every healing spell and every rank, and simulates fights so you know which spell and rank keeps the tank alive with the least mana. For Priests, Paladins, Druids and Shamans.

## Features

**Real in-game numbers**
- Healing amounts are read from your spellbook tooltips, so your healing power and talents are already included. Cast time, mana and cooldown come from the game too.
- Downranking penalty is applied.

**Tooltips**
- Spell tooltips get an HPS / HPM line; the best HPS and best HPM rank are marked.
- Detail level: full / standard / compact / off.

**Comparison table**
- Every spell and rank at once, sortable by amount, HPS or HPM.
- **Single**, **Group** and **Cooldown** tabs. Group size 2–10; HoTs count how many targets you can keep them rolling on.
- Class bonuses the tooltip does not show can be counted: **Oath of Light** (Paladin), Holy Binding (Priest), Riptide bonus (Shaman), Bloom (Druid).

**Analysis tab**
- Simulates a whole fight second by second with your real mana, Spirit regen and the five-second rule.
- Single tank: trash, boss, solo and "save water" presets scaled to your level, or set tank HP, hit size, interval and fight length yourself.
- Group: trash, raid-wide, sustained AoE and random-target presets with common group-healing rotations for each class.
- Compares single spells, efficient spell + emergency spell, HoT upkeep and deliberate pauses for regen. Shows whether the tank survives, mana left, lowest HP and how many pulls before you drink.
- Results: two "most mana-efficient" and two "most stable" picks, or the full ranked list.
- Paladins can toggle **Oath of Light** for the tank.

**Header**
- Level, healing power, **Spirit** and mana regen (resting / while casting).

**Language**
- English, Traditional and Simplified Chinese, German, French, Spanish (Spain / Mexico), Russian, Korean and Portuguese, following your client language.

Minimap button (left click: open/close, right click: settings) and a resizable window. Other classes are left alone.

## Commands

- `/shps` toggle the window (`/hps` also works)
- `/shps tip` tooltips on/off
- `/shps targets 2-10` group size
- `/shps scale 1.2` window size, 0.5–2
- `/shps minimap` hide / show the minimap button
- `/shps downrank` downranking penalty on/off
- `/shps pct <number>|auto` healing bonus % (auto reads talents)
- `/shps absorb <number>|auto` absorb bonus % (auto reads talents)
- `/shps desc incl|base|auto` whether tooltip numbers already include healing power
- `/shps lang en|zh|zhCN|deDE|frFR|esES|esMX|ruRU|koKR|ptBR|auto` interface language, applies after `/reload`
- `/shps debug` show what the addon read
- `/shps reset` reset settings

## Notes

- The comparison table ignores crits and overhealing; the analysis tab includes crits (HoTs can crit in Forever).
- Base spell values were checked rank by rank against WoW Forever client data (1.60.1). Analysis preset damage numbers come from Forever data and combat logs and are estimates.

---

# 阿聖治療幫手（魔獸世界：永恆）

比較治療職每個技能、每個等級的 **HPS**（每秒治療）和 **HPM**（每點法力治療），還能模擬整場戰鬥，找出最省藍又能撐住坦克的補法。適用牧師、聖騎士、德魯伊、薩滿。

## 功能

**讀遊戲裡的真實數字**
- 治療量直接解析法術書的技能說明，已含你的治療效果和天賦；施法時間、法力、冷卻也從遊戲讀。
- 降級衰減會算進去。

**滑鼠提示**
- 技能提示多一行 HPS／HPM，最高 HPS、最高 HPM 的等級會標出來。
- 詳細度可選完整／標準／精簡／關。

**比較表**
- 所有技能所有等級一次列出，可依有效量、HPS、HPM 排序。
- 分**單補**、**群補**、**冷卻**三頁。群補人數 2–10；持續治療會算能輪流鋪給幾個人。
- 技能說明沒寫的職業加成可以選擇計入：**聖光誓約**（聖騎）、聖光束縛（牧師）、激流加成（薩滿）、綻放（德魯伊）。

**分析分頁**
- 用你實際的法力、精神回藍和五秒規則，逐秒模擬整場戰鬥。
- 單坦：小怪、王戰、單練、省水情境，依你的等級換算；也可以自己調坦克生命、每次傷害、間隔和戰鬥長度。
- 團刷：群怪、全團技、持續範圍、點名情境，比較各職業常見的群補手法。
- 比較單招、省藍招＋救命招、保持持續治療、刻意停手回藍；列出坦克活不活、剩多少藍、最低血量、能連打幾波才要喝水。
- 結論推薦「最省藍」「最穩定」各兩種，或看完整排名。
- 聖騎可以切換坦克是否為**聖光誓約**目標。

**上方資訊列**
- 等級、治療效果、**精神**與回藍（停手／施法中）。

**語言**
- 英文、繁體中文、簡體中文、德文、法文、西班牙文（西班牙／墨西哥）、俄文、韓文、葡萄牙文介面，依遊戲語言自動切換。

小地圖按鈕（左鍵開關視窗、右鍵打開設定）、可調整大小的視窗。非治療職業不會啟用。

## 指令

- `/shps` 開關視窗（`/hps` 也能用）
- `/shps tip` 開關滑鼠提示
- `/shps targets 2-10` 群補人數
- `/shps scale 1.2` 視窗大小，0.5～2
- `/shps minimap` 隱藏／顯示小地圖按鈕
- `/shps downrank` 開關降級衰減
- `/shps pct 數字|auto` 治療加成 %（auto 依天賦）
- `/shps absorb 數字|auto` 吸收加成 %（auto 依天賦）
- `/shps desc incl|base|auto` 技能說明數字是否已含治療效果
- `/shps lang en|zh|zhCN|deDE|frFR|esES|esMX|ruRU|koKR|ptBR|auto` 介面語言，`/reload` 後生效
- `/shps debug` 列出插件讀到的資料
- `/shps reset` 重設設定

## 注意

- 比較表不含爆擊、溢補；分析頁有算爆擊（永恆的持續治療會爆擊）。
- 技能基礎數值已依永恆客戶端資料（1.60.1）逐階核對；分析頁預設情境的傷害數字依永恆資料與戰鬥紀錄估計。

