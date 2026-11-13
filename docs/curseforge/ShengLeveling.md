**專案名稱：** 阿聖練等幫手 ShengLeveling
**授權（License）：** GPL-3.0（路線資料使用 Questie／QuestieDB 的資料，必須是 GPL-3.0）
**系列：** 阿聖 Sheng（另有 阿聖治療幫手 ShengHealing、阿聖專業幫手 ShengProfession）
**摘要（Summary，一行）：** 魔獸世界：永恆部落 1–60 練等路線：一次只顯示一步，任務一變就自動對齊，地圖標點＋箭頭，照著走就能升級。
**分類：** Quests & Leveling、Map & Minimap
**語言：** 繁體中文（zhTW）
**選用相依（Optional dependency）：** Questie（世界地圖標點）、WaypointUI（箭頭）

---

## 阿聖練等幫手（魔獸世界：永恆）

部落 1–60 的練等路線指引。不用自己查攻略、不用想下一步去哪：步驟列只告訴你「現在做什麼」，做完自動跳下一步。

### 特色

- **一次一步**：步驟列只顯示目前該做的事，接、殺、交任務後自動往下走；附近可以順手一起做的任務會列在下面。
- **自動對位**：照遊戲的任務狀態判斷你走到哪，跑錯地方、跳著做都會自己對齊，漏掉的任務會列出來。
- **依種族、職業分支**：新手村可以自選，不綁種族；職業任務只顯示你這個職業的。
- **地圖標點與箭頭**：世界地圖、小地圖都有編號標點；裝了 WaypointUI 會有箭頭指路。
- **「任務目標」巨集**：按一下就選取任務要打的怪，並幫附近的任務怪上標記；也可以綁快捷鍵。任務要用的物品會出現在步驟列旁邊，點了就用。
- **經驗不夠時自動補任務**：把打怪經驗也算進去，等級落後時自動加入值得做的支線，再不夠就建議去哪裡打怪。
- **提醒**：順路任務、離開前還有會影響後續的任務、少了前置、該去學技能、補給和危險區域。
- **副本分頁**：34 個副本的前置任務怎麼接、等級到了就提醒；進副本後只顯示該副本的任務，附打王動線與位置說明。
- **任務日誌**：滑過任務會顯示在不在路線上、值不值得做。
- **大量設定**：大小、寬度、透明度、提示框位置都能用滑桿調。

### 指令

- `/slv` 開關（舊指令 `/metro` 也能用）
- `/slv config` 設定
- `/slv macro` 建立「任務目標」巨集
- `/slv probe` 檢查報告（有問題時請附上回報）

### 注意

- 目前路線以部落為主。
- 路線站序參考 Bilibili UP 主「奇怪小鸭」的《魔兽世界无限》練級路線影片，並參考其他公開練級路線優化；任務、NPC、座標資料取自 Questie／QuestieDB（GPL-3.0）。
- 插件會在你的電腦上記錄接交任務的位置等資料（設定可關），只存在本機存檔，用來修正路線。

原始碼與問題回報：https://github.com/ms145236-bridge/wow-leveling-guide

---

**English (ShengLeveling):** Horde 1–60 leveling route guide for WoW Forever (zhTW client). Shows one step at a time and auto-syncs with your quest log, with world map / minimap pins and WaypointUI arrows, race/class branches, a one-click "target quest mob" macro, XP-shortfall suggestions, dungeon prerequisites and in-dungeon quest lists. Optional: Questie, WaypointUI.
