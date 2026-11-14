**專案名稱：** 阿聖練等幫手 ShengLeveling
**授權（License）：** GPL-3.0（路線資料使用 Questie／QuestieDB 的資料，必須是 GPL-3.0）
**系列：** 阿聖 Sheng（另有 阿聖治療幫手 ShengHealing、阿聖專業幫手 ShengProfession）
**摘要（Summary，一行）：** 魔獸世界：永恆部落與聯盟 1–60 練等路線：一次只顯示一步，任務一變就自動對齊，自動接交、選怪巨集、地圖標點與導航，照著走就能升級。
**分類：** Quests & Leveling、Map & Minimap
**語言：** 英文（enUS）、繁體中文（zhTW），依遊戲語言自動切換
**選用相依（Optional dependency）：** Questie（地圖標點）、WaypointUI（箭頭導航）

---

# ShengLeveling (WoW Forever)

Horde and Alliance 1–60 leveling route. No guide to look up, no guessing where to go next: the step bar tells you what to do now and moves on when it is done.

## Features

**Step bar**
- Shows only the current step; accepting, killing and turning in move it forward.
- Quests close to where you are heading are listed underneath so you can do them together.
- Reads your quest log to work out where you are, so going out of order or to the wrong place realigns on its own. Missed quests are listed.
- Starting zone is your choice, not tied to race; class quests only for your class.
- When a quest needs an item from a vendor, a **Buy** step shows who sells it and how many you have.

**Auto accept / turn in**
- Quests on the route are accepted and turned in automatically. With more than one reward to choose, you pick.
- Gray (too low level) quests are not auto-accepted.

**Target macro and quest items**
- The **Quest Target** macro targets the mob your quest needs and marks nearby quest mobs with a raid icon. Bindable in Key Bindings.
- The current step's quest item gets a button on the step bar (bindable too) and an optional auto-updated macro.

**Map and navigation**
- Numbered pins for the remaining steps on the world map and the next few on the minimap, including quest objective areas (where to kill or loot). Shape and color show accept / do / turn in.
- Waypoint to the current step through **WaypointUI** if installed, otherwise the game's own map pin. Click the step bar to reset it to the current step.

**Hints**
- Detours: a nearby quest worth doing gets **Go**; the bar then shows the original step with **Back** to return to the route.
- Leaving a zone with quests that matter later, missing prerequisites, class training, repair, new flight masters and danger areas. Opening the flight map records every flight point you already know.
- When quest XP will not reach the next zone's level, worthwhile side quests are added back, then a grinding spot is suggested.
- Optional quests are marked, including long detours with nothing else nearby; they stay off the route unless you enable them or need the XP.
- Bag item tooltips warn when a later quest needs the item.

**Dungeons**
- Prerequisite quests for 34 dungeons, picked up along the way when you pass by, with a reminder once you are in level range.
- Inside a dungeon, only that dungeon's quests are shown, each with a line saying where it is and how to get there; the tooltip shows the kill order.
- Quests turned in inside the dungeon show who to hand them to; after you leave, ready dungeon turn-ins nearby are suggested as detours.
- Dungeons with all quests turned in are marked Done.

**Settings**
- Size, width, font size and fade on the main page; opacity, pin details and positions under Advanced. Hover a setting to see what it does.

**Language**
- Switch the interface language under Settings › Other (default: client language).
- English, Traditional and Simplified Chinese, German, French, Spanish (Spain / Mexico), Russian, Korean and Portuguese, following your client language. Quest, NPC and mob names and the target macro use the game's names.

## Commands

- `/slv` toggle the step bar (`/lv`, `/metro` also work)
- `/slv config` settings
- `/slv macro` create the Quest Target macro
- `/slv reset` realign with your quest log
- `/slv minimap` show the minimap button (left-click: step bar, right-click: settings)
- `/slv lang en|zh|zhCN|deDE|frFR|esES|esMX|ruRU|koKR|ptBR|auto` interface language, applies after `/reload`
- `/slv rec on|off|export|clear` in-game route recording (stored locally, used to fix the route)
- `/slv probe` diagnostic report (attach it to bug reports)

## Requirements

- Optional: **Questie** for world map and minimap pins (uses its HereBeDragons library). **WaypointUI** for the arrow.

## Notes

- The addon loads only your own faction's route. Skyborne characters count as Horde until they pick a faction; /reload after choosing.
- The Alliance route is built on the quest order of the TUGs Guidelime guide and has not been played through in game yet; reports are welcome.
- Route order follows the WoW Forever leveling videos by Bilibili creator 奇怪小鸭, refined with other public routes. Quest, NPC and coordinate data from Questie / QuestieDB (GPL-3.0).

---

# 阿聖練等幫手（魔獸世界：永恆）

部落與聯盟 1–60 練等路線。不用自己查攻略、不用想下一步去哪：步驟列只告訴你現在做什麼，做完自動跳下一步。

## 功能

**步驟列**
- 只顯示目前該做的事，接、殺、交任務後自動往下走。
- 往目的地附近可以一起做的任務列在下面。
- 照任務日誌判斷你走到哪，跳著做、跑錯地方都會自己對齊；漏掉的任務會列出來。
- 新手村可以自選，不綁種族；職業任務只顯示你這個職業的。
- 任務要用的東西需要向商人買時，會有一步**買**，寫跟誰買、背包裡有幾個。

**自動接交任務**
- 路線上的任務自動接、自動交；有多個獎勵可選時由你自己挑。
- 灰名（差太多等）的任務不會自動接。

**選怪巨集與任務物品**
- **任務目標**巨集一鍵選取任務要打的怪，並幫附近的任務怪上團隊標記；可以在按鍵設定綁快捷鍵。
- 目前步驟要用的任務物品會出現在步驟列旁的按鈕（也能綁鍵），也可以自動建立任務物品巨集。

**地圖與導航**
- 世界地圖標出本區剩下的步驟、小地圖標出接下來幾步，包含任務目標地點（去哪裡打怪、撿東西）。形狀和顏色區分接、做、交。
- 有 **WaypointUI** 就用它導航到目前步驟，沒有就用遊戲內建的地圖標記。點一下步驟列，導航重設回目前步驟。

**提示**
- 順路任務：附近值得做的任務有**去**按鈕；去了之後提示列顯示原本的步驟，按**返回**回到路線順序。
- 離開前還有影響後續的任務、少了前置、該去學技能、修裝、還沒開的飛行點、危險區域。打開飛行地圖時會記下所有已開的鳥點。
- 任務經驗不夠到下一區時，自動補回值得做的支線，再不夠就建議練怪地點。
- 可跳過的任務會標出來，包括要特地繞路、附近又沒別的任務的；預設不排進路線，除非你在設定開啟或經驗不夠。
- 背包物品的滑鼠提示會提醒之後的任務要用，別賣。

**副本**
- 34 個副本的前置任務，經過時順路接，等級到了會提醒。
- 進副本後只顯示該副本的任務，每一步寫在副本哪裡、怎麼走；滑鼠提示寫打的順序。
- 副本內回報的任務寫交給誰；出本後附近可交的副本任務會順路提示。
- 任務都交完的副本標示「已完成」。

**設定**
- 主頁面調大小、寬度、字體和淡出；透明度、標點細項和位置收在「進階」。滑鼠移到設定上會顯示說明。

**語言**
- 設定「其他」可以切換介面語言（預設跟隨客戶端）。
- 英文、繁體中文、簡體中文、德文、法文、西班牙文（西班牙／墨西哥）、俄文、韓文、葡萄牙文介面，依遊戲語言自動切換；任務、NPC、怪物名稱與選怪巨集使用遊戲裡的名稱。

## 指令

- `/slv` 開關步驟列（`/lv`、`/metro` 也能用）
- `/slv config` 設定
- `/slv macro` 建立「任務目標」巨集
- `/slv reset` 依任務日誌重新對齊
- `/slv minimap` 顯示小地圖按鈕（左鍵開關步驟列、右鍵打開設定）
- `/slv lang en|zh|zhCN|deDE|frFR|esES|esMX|ruRU|koKR|ptBR|auto` 介面語言，`/reload` 後生效
- `/slv rec on|off|export|clear` 遊戲內記錄（只存在本機，用來修正路線）
- `/slv probe` 檢查報告（回報問題時請附上）

## 需求

- 選用：**Questie**（世界地圖、小地圖標點，使用它附的 HereBeDragons）、**WaypointUI**（箭頭）。

## 注意

- 插件只載入自己陣營的路線。天裔精靈選陣營前算部落，選好後 /reload。
- 聯盟路線以 TUGs Guidelime 攻略的任務順序為骨架，還沒有在遊戲裡完整走過，歡迎回報問題。
- 路線站序參考 Bilibili UP 主「奇怪小鸭」的《魔兽世界无限》練級路線影片，並參考其他公開練級路線優化；任務、NPC、座標資料取自 Questie／QuestieDB（GPL-3.0）。

