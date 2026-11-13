**專案名稱：** 阿聖練等幫手 ShengLeveling
**授權（License）：** GPL-3.0（路線資料使用 Questie／QuestieDB 的資料，必須是 GPL-3.0）
**系列：** 阿聖 Sheng（另有 阿聖治療幫手 ShengHealing、阿聖專業幫手 ShengProfession）
**摘要（Summary，一行）：** 魔獸世界：永恆部落 1–60 練等路線：一次只顯示一步，任務一變就自動對齊，自動接交、選怪巨集、地圖標點與導航，照著走就能升級。
**分類：** Quests & Leveling、Map & Minimap
**語言：** 英文（enUS）、繁體中文（zhTW），依遊戲語言自動切換
**選用相依（Optional dependency）：** Questie（地圖標點）、WaypointUI（箭頭導航）

---

# ShengLeveling (WoW Forever)

Horde 1–60 leveling route. No guide to look up, no guessing where to go next: the step bar tells you what to do now and moves on when it is done.

## Features

**Step bar**
- Shows only the current step; accepting, killing and turning in move it forward.
- Quests close to where you are heading are listed underneath so you can do them together.
- Reads your quest log to work out where you are, so going out of order or to the wrong place realigns on its own. Missed quests are listed.
- Starting zone is your choice, not tied to race; class quests only for your class.

**Auto accept / turn in**
- Quests on the route are accepted and turned in automatically. With more than one reward to choose, you pick.

**Target macro and quest items**
- The **Quest Target** macro targets the mob your quest needs and marks nearby quest mobs with a raid icon. Bindable in Key Bindings.
- The current step's quest item gets a button on the step bar (bindable too) and an optional auto-updated macro.

**Map and navigation**
- Numbered pins for the remaining steps on the world map and the next few on the minimap, including quest objective areas (where to kill or loot). Shape and color show accept / do / turn in.
- Waypoint to the current step through **WaypointUI** if installed, otherwise the game's own map pin. Click the step bar to reset it to the current step.

**Hints**
- Detours: a nearby quest worth doing gets **Go**; the bar then shows the original step with **Back** to return to the route.
- Leaving a zone with quests that matter later, missing prerequisites, class training, repair, new flight masters and danger areas.
- When quest XP will not reach the next zone's level, worthwhile side quests are added back, then a grinding spot is suggested.
- Optional quests are marked; they stay off the route unless you enable them or need the XP.
- Bag item tooltips warn when a later quest needs the item.

**Dungeons**
- Prerequisite quests for 34 dungeons, picked up along the way when you pass by, with a reminder once you are in level range.
- Inside a dungeon, only that dungeon's quests are shown.

**Settings**
- Size, width, opacity, fade, font size, pin size and hint position all adjustable.

**Language**
- English and Traditional Chinese, following your client language. Quest, NPC and mob names and the target macro use the game's names.

## Commands

- `/slv` toggle the step bar (`/lv`, `/metro` also work)
- `/slv config` settings
- `/slv macro` create the Quest Target macro
- `/slv reset` realign with your quest log
- `/slv minimap` show the minimap button
- `/slv lang en|zh|auto` interface language, applies after `/reload`
- `/slv rec on|off|export|clear` in-game route recording (stored locally, used to fix the route)
- `/slv probe` diagnostic report (attach it to bug reports)

## Requirements

- Optional: **Questie** for world map and minimap pins (uses its HereBeDragons library). **WaypointUI** for the arrow.

## Notes

- Horde only for now.
- Route order follows the WoW Forever leveling videos by Bilibili creator 奇怪小鸭, refined with other public routes. Quest, NPC and coordinate data from Questie / QuestieDB (GPL-3.0).

Source: https://github.com/ms145236-bridge/wow-leveling-guide
Issues: https://github.com/ms145236-bridge/wow-leveling-guide/issues

---

# 阿聖練等幫手（魔獸世界：永恆）

部落 1–60 練等路線。不用自己查攻略、不用想下一步去哪：步驟列只告訴你現在做什麼，做完自動跳下一步。

## 功能

**步驟列**
- 只顯示目前該做的事，接、殺、交任務後自動往下走。
- 往目的地附近可以一起做的任務列在下面。
- 照任務日誌判斷你走到哪，跳著做、跑錯地方都會自己對齊；漏掉的任務會列出來。
- 新手村可以自選，不綁種族；職業任務只顯示你這個職業的。

**自動接交任務**
- 路線上的任務自動接、自動交；有多個獎勵可選時由你自己挑。

**選怪巨集與任務物品**
- **任務目標**巨集一鍵選取任務要打的怪，並幫附近的任務怪上團隊標記；可以在按鍵設定綁快捷鍵。
- 目前步驟要用的任務物品會出現在步驟列旁的按鈕（也能綁鍵），也可以自動建立任務物品巨集。

**地圖與導航**
- 世界地圖標出本區剩下的步驟、小地圖標出接下來幾步，包含任務目標地點（去哪裡打怪、撿東西）。形狀和顏色區分接、做、交。
- 有 **WaypointUI** 就用它導航到目前步驟，沒有就用遊戲內建的地圖標記。點一下步驟列，導航重設回目前步驟。

**提示**
- 順路任務：附近值得做的任務有**去**按鈕；去了之後提示列顯示原本的步驟，按**返回**回到路線順序。
- 離開前還有影響後續的任務、少了前置、該去學技能、修裝、還沒開的飛行點、危險區域。
- 任務經驗不夠到下一區時，自動補回值得做的支線，再不夠就建議練怪地點。
- 可跳過的任務會標出來；預設不排進路線，除非你在設定開啟或經驗不夠。
- 背包物品的滑鼠提示會提醒之後的任務要用，別賣。

**副本**
- 34 個副本的前置任務，經過時順路接，等級到了會提醒。
- 進副本後只顯示該副本的任務。

**設定**
- 大小、寬度、透明度、淡出、字體、標點大小、提示框位置都能調。

**語言**
- 英文、繁體中文介面，依遊戲語言自動切換；任務、NPC、怪物名稱與選怪巨集使用遊戲裡的名稱。

## 指令

- `/slv` 開關步驟列（`/lv`、`/metro` 也能用）
- `/slv config` 設定
- `/slv macro` 建立「任務目標」巨集
- `/slv reset` 依任務日誌重新對齊
- `/slv minimap` 顯示小地圖按鈕
- `/slv lang en|zh|auto` 介面語言，`/reload` 後生效
- `/slv rec on|off|export|clear` 遊戲內記錄（只存在本機，用來修正路線）
- `/slv probe` 檢查報告（回報問題時請附上）

## 需求

- 選用：**Questie**（世界地圖、小地圖標點，使用它附的 HereBeDragons）、**WaypointUI**（箭頭）。

## 注意

- 目前路線只有部落。
- 路線站序參考 Bilibili UP 主「奇怪小鸭」的《魔兽世界无限》練級路線影片，並參考其他公開練級路線優化；任務、NPC、座標資料取自 Questie／QuestieDB（GPL-3.0）。

原始碼：https://github.com/ms145236-bridge/wow-leveling-guide
問題回報：https://github.com/ms145236-bridge/wow-leveling-guide/issues
