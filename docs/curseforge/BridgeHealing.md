**專案名稱：** 阿聖治療幫手 BridgeHealing
**授權（License）：** GPL-3.0
**系列：** 阿聖 Bridge（另有 阿聖練等幫手 BridgeLeveling、阿聖專業幫手 BridgeProfession）
**摘要（Summary，一行）：** 魔獸世界：永恆治療職 HPS／HPM 比較：直接讀遊戲技能說明與天賦，滑鼠提示與比較表告訴你哪一招最划算。
**分類：** Healer、Tooltip、Class（Paladin/Priest/Druid/Shaman）
**語言：** 繁體中文（zhTW）

---

## 阿聖治療幫手（魔獸世界：永恆）

比較治療職每個技能、每個等級的 **HPS**（每秒治療）和 **HPM**（每點法力治療），幫你決定什麼時候該用哪一招、哪一階。

### 特色

- **讀遊戲裡的真實數字**：技能治療量直接解析法術書的技能說明（已含你的治療效果和天賦），施法時間、法力、冷卻也從遊戲讀，換裝會即時更新。
- **滑鼠提示**：技能圖示上多一行 HPS／HPM，HPS 最高、HPM 最高的那招會特別標出。
- **比較表**（`/shps`）：所有技能所有等級一次列出，可依 HPS、HPM 排序；分「單補／群補／冷卻」三頁。
- **群補**：可用滑桿設定人數（2–10），恢復、回春術等持續治療會算能輪流鋪給幾個人；癒合這類直接＋持續治療也算進群補。
- **冷卻技能另列一頁**，照施放時的 HPS 比較。
- **滑鼠提示可調詳細度**：完整／標準／精簡／關。
- **降級衰減**：低階技能的治療效果打折會自動算進去。
- **聖光誓約**（神聖聖騎）：照實測公式計算對誓約目標的額外治療，包含「低階技能拿不到完整加成」的規則。實測過程與數據：[聖光誓約實測](https://github.com/ms145236-bridge/wow-profession-calc/blob/main/docs/聖光誓約實測.md)
- 牧師、德魯伊、薩滿的情境加成（例如 HoT、激流後的治療鍊）。
- 小地圖按鈕、可調整大小的視窗。非治療職業不會載入功能。

### 指令

- `/shps` 開關比較表
- `/shps tip` 開關滑鼠提示（詳細度在比較表的「設定」裡調）
- `/shps targets 2-10` 群補人數
- `/shps minimap` 隱藏／顯示小地圖按鈕
- `/shps debug` 列出插件讀到的資料（數值不對時請附上回報）

### 注意

- 不含爆擊、溢補；HoT 假設完整跑完。持續治療的 HPS 用持續時間算。
- 技能基礎數值已依永恆客戶端資料（1.60.1）逐階核對。
- 牧師、德魯伊、薩滿的部分天賦還沒有實測，數值如果怪怪的歡迎回報。

網頁版：https://ms145236-bridge.github.io/wow-profession-calc/healer.html
原始碼與問題回報：https://github.com/ms145236-bridge/wow-profession-calc

---

**English (BridgeHealing):** HPS / HPM comparison for healers in WoW Forever (zhTW client). Reads real numbers from in-game spell tooltips and talents, shows HPS/HPM in tooltips and a sortable comparison table (`/shps`, single-target / group / cooldown tabs, adjustable group size), including downranking penalties and the Oath of Light talent.
