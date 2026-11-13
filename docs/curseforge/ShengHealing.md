**專案名稱：** 阿聖治療幫手 ShengHealing
**授權（License）：** GPL-3.0
**系列：** 阿聖 Sheng（另有 阿聖練等幫手 ShengLeveling、阿聖專業幫手 ShengProfession）
**摘要（Summary，英文）：** Compare HPS and HPM of every healing spell and rank in WoW Forever, and simulate fights to find the most mana-efficient way to keep the tank alive.

---

## ShengHealing (WoW Forever)

Compares **HPS** (healing per second) and **HPM** (healing per mana) for every healing spell and every rank, and simulates fights so you know which spell — and which rank — keeps the tank alive with the least mana.

### Features

- **Real in-game numbers**: healing amounts are read from your spellbook tooltips (already including your healing power and talents); cast time, mana and cooldown are read from the game too.
- **Tooltips**: an extra HPS / HPM line on spell tooltips; the best HPS and best HPM spells are highlighted. Detail level: full / standard / compact / off.
- **Comparison table** (`/shps`): every spell and rank at once, sortable, with Single-target / Group / Cooldown tabs. Group size slider (2–10); HoTs count how many targets you can keep them rolling on.
- **Analysis tab**: simulates a whole fight second by second using your real mana, Spirit regen and the 5-second rule.
  - Single tank: trash, boss, solo and "save water" presets scaled to your level, or set tank HP, hit size, interval and fight length yourself.
  - Group: trash, raid-wide AoE, sustained AoE and random-target presets with each class's common group-healing rotations.
  - Compares single spells, efficient spell + emergency spell, HoT rotations and deliberate pauses for regen; shows whether the tank survives, mana left, lowest HP and how many pulls you can do before drinking.
  - Results: two "most mana-efficient" and two "most stable" picks, or the full ranked list.
- **Header line** shows your level, healing power, Spirit and mana regen (resting / while casting).
- **Downranking penalty** and **Oath of Light** (Holy Paladin, formula verified in game) are included.
- Minimap button and resizable window. Does nothing on non-healing classes.

### Commands

- `/shps` toggle the window (old command `/hps` still works)
- `/shps tip` toggle tooltips
- `/shps targets 2-10` group size
- `/shps minimap` hide / show the minimap button
- `/shps debug` show what the addon read

### Notes

- The interface is in Traditional Chinese (zhTW client).
- Crits and overhealing are not counted in the comparison table; the analysis tab includes crits (HoTs crit in Forever).
- Base spell values were checked rank by rank against the WoW Forever client data (1.60.1). Combat numbers for the analysis presets come from Forever data and logs and are estimates.

Web version: https://ms145236-bridge.github.io/wow-profession-calc/healer.html
Source and issues: https://github.com/ms145236-bridge/wow-profession-calc

---

## 阿聖治療幫手（魔獸世界：永恆）

比較治療職每個技能、每個等級的 **HPS**（每秒治療）和 **HPM**（每點法力治療），還能模擬整場戰鬥，找出最省藍又能撐住坦克的補法。

### 特色

- **讀遊戲裡的真實數字**：技能治療量直接解析法術書的技能說明（已含你的治療效果和天賦），施法時間、法力、冷卻也從遊戲讀。
- **滑鼠提示**：技能圖示上多一行 HPS／HPM，最高的那招會特別標出；詳細度可選完整／標準／精簡／關。
- **比較表**（`/shps`）：所有技能所有等級一次列出，分「單補／群補／冷卻」三頁。群補人數用滑桿調（2–10），持續治療會算能輪流鋪給幾個人。
- **分析分頁**：用你實際的法力、精神回藍和五秒規則，逐秒模擬整場戰鬥。
  - 單坦：小怪、王戰、單練、省水情境，數值依你的等級換算；也可以自己調坦克生命、每次傷害、間隔和戰鬥長度。
  - 團刷：群怪、全團技、範圍、點名情境，比較各職業常見的群補手法。
  - 比較單招、省藍招＋救命招、保持持續治療、刻意停手回藍等打法；列出坦克活不活、剩多少藍、最低血量、能連打幾波才要喝水。
  - 結論推薦「最省藍」「最穩定」各兩種，勾「詳細」看完整排名。
- **上方資訊列**顯示等級、治療效果、精神與回藍（停手／施法中）。
- **降級衰減**與**聖光誓約**（神聖聖騎，照實測公式）都會算進去。
- 小地圖按鈕、可調整大小的視窗。非治療職業不會載入功能。

### 指令

- `/shps` 開關視窗（舊指令 `/hps` 也能用）
- `/shps tip` 開關滑鼠提示
- `/shps targets 2-10` 群補人數
- `/shps minimap` 隱藏／顯示小地圖按鈕
- `/shps debug` 列出插件讀到的資料

### 注意

- 比較表不含爆擊、溢補；分析頁有算爆擊（永恆的持續治療會爆擊）。
- 技能基礎數值已依永恆客戶端資料（1.60.1）逐階核對；分析頁預設情境的傷害數字依永恆資料與戰鬥紀錄估計。

網頁版：https://ms145236-bridge.github.io/wow-profession-calc/healer.html
原始碼與問題回報：https://github.com/ms145236-bridge/wow-profession-calc
