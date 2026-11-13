**專案名稱：** 阿聖專業幫手 ShengProfession
**授權（License）：** GPL-3.0
**系列：** 阿聖 Sheng（另有 阿聖練等幫手 ShengLeveling、阿聖治療幫手 ShengHealing）
**摘要（Summary，一行）：** 魔獸世界：永恆專業幫手：利潤表、製作佇列、最省衝級路線與 Auctionator 購物清單、採集分頁與推薦採集路線、公會誰會做。
**分類：** Professions、Auction & Economy
**語言：** 英文（enUS）、繁體中文（zhTW），依遊戲語言自動切換
**選用相依（Optional dependency）：** Auctionator（價格）、WaypointUI（導航）、Questie 或其他附 HereBeDragons 的插件（小地圖路線）

---

# ShengProfession (WoW Forever)

Answers the usual profession questions: what is worth crafting, what leveling will cost, and how to work through a pile of crafts without clicking each one.

## Features

**Profit**
- Every recipe you know with material cost, auction price (after the 5% cut), profit and profit %. Click a column header to sort.
- When a material can be crafted from cheaper parts, buy vs. craft is compared automatically.
- Shows how many are listed on the auction house (from Auctionator scans).

**Crafting queue**
- Add recipes from the Profit or Leveling tab, then press **Craft next** to work through the list.
- **Use bags / Use bank** toggles decide whether materials you already own are subtracted.
- One click builds an **Auctionator shopping list** for what is still missing.

**Leveling**
- Picks the cheapest leveling route from current Auctionator prices and lists each step and how many to craft.
- Shows the total cost and what the crafted items sell back for; intermediate materials can be broken down into raw materials.
- Materials tab with the full shopping list.

**Gathering tab**
- Mining, Herbalism, Skinning and Fishing skill levels.
- Where to learn the next rank: Expert and Artisan trainer, level and skill requirement, cost; the book or quest for Cooking, First Aid and Fishing. **Go** sets a waypoint.
- Tracking reminder: turns on Find Minerals / Find Herbs when you forget, or shows a button to click.

**Recommended gathering routes**
- Horde Mining, Herbalism and dual-gathering loops (41 routes), matched to your current skill.
- Pick one to draw the full loop on the world map and a trail on the minimap; **Go to start** sets a waypoint.
- Tooltips show suggested character level, skill range, yields, lap time and danger spots.

**Guild crafters**
- Guild members who also use ShengProfession share their known recipes automatically.
- Profit and queue rows and item tooltips show who in your guild can craft it.

**Profession window**
- The helper can open next to the profession window so you can queue recipes straight from it.

**Language**
- English and Traditional Chinese, following your client language. Item, recipe and zone names follow the game language.

## Commands

- `/sprof` toggle the window (`/prof`, `/proflevel` also work)
- `/sprof scale 1.2` window size, 0.5–2 (or drag the corner)
- `/sprof dock` open together with the profession window on/off
- `/sprof minimap` hide / show the minimap button
- `/sprof train` next rank location for all your professions
- `/sprof track` tracking reminder settings (`on`, `off`, `auto`, `mine`, `herb`, `reset`)
- `/sprof guild` guild data summary; `/sprof guild <name>` one member; `/sprof guild on|off` share your recipes (on by default)
- `/sprof lang en|zh|auto` interface language, applies after `/reload` (Chinese needs a Chinese client)
- `/sprof debug` show what the addon detected

## Requirements

- **Auctionator** for prices. Scan the auction house once first; without it only vendor items have prices.
- Optional: **WaypointUI** for waypoints (falls back to the game's map pin). Minimap route trails need an addon that ships HereBeDragons, such as **Questie**.

## Notes

- Listed count means how many people are selling, not how many sell (the game has no sales data).
- Leveling route data is based on the kovarel.com WoW Forever profession tool.

---

# 阿聖專業幫手（魔獸世界：永恆）

做專業最常遇到的問題：做什麼賺錢、衝級要花多少、一堆東西要做不想一個一個點。這個插件一次處理。

## 功能

**利潤**
- 列出你學會的所有配方：材料成本、拍賣售價（已扣 5% 手續費）、利潤、利潤 %，點欄名排序。
- 材料可以用更便宜的東西做出來時，自動比較買還是自己做。
- 顯示拍賣場在架數量（Auctionator 掃描紀錄）。

**製作佇列**
- 從「利潤」或「衝級」把配方加進佇列，按**製作下一個**依序做完。
- **扣背包／扣銀行**開關決定已有的材料要不要扣掉。
- 一鍵把還缺的材料建立成 **Auctionator 購物清單**。

**衝級**
- 依目前 Auctionator 價格挑最省的衝級路線，列出每一段做什麼、做幾次。
- 算出總花費和成品賣掉能回收多少；中間材料可以拆成原材料比價。
- 「材料」頁列出完整購物清單。

**採集分頁**
- 採礦、草藥學、剝皮、釣魚的點數。
- 下一階去哪學：專家、大師訓練師、等級與技能門檻、費用；烹飪、急救、釣魚列出技能書或任務。按**去**設導航點。
- 採集追蹤提醒：忘了開尋找礦物／尋找草藥時自動開啟，或出現按鈕讓你點。

**推薦採集路線**
- 部落採礦、採草、雙採路線共 41 條，依你目前的點數推薦。
- 選一條就在世界地圖畫出整圈、小地圖畫出路徑；**去起點**設導航點。
- 滑鼠提示列出建議等級、技能範圍、產出、一圈時間與危險地點。

**公會誰會做**
- 公會成員也裝本插件時，會自動互傳學會的配方。
- 利潤、佇列和物品滑鼠提示會顯示公會裡誰會做。

**專業視窗**
- 可以跟專業視窗一起打開，直接把配方加進佇列。

**語言**
- 英文、繁體中文介面，依遊戲語言自動切換；物品、配方、地區名稱跟著遊戲語言。

## 指令

- `/sprof` 開關視窗（`/prof`、`/proflevel` 也能用）
- `/sprof scale 1.2` 視窗大小，0.5～2（也可以拖右下角）
- `/sprof dock` 開關「跟專業視窗一起開」
- `/sprof minimap` 隱藏／顯示小地圖按鈕
- `/sprof train` 列出所有專業的下一階去哪學
- `/sprof track` 採集追蹤提醒設定（`on`、`off`、`auto`、`mine`、`herb`、`reset`）
- `/sprof guild` 公會資料摘要；`/sprof guild 名字` 看單人；`/sprof guild on|off` 分享我的配方（預設開）
- `/sprof lang en|zh|auto` 介面語言，`/reload` 後生效（中文需要中文客戶端）
- `/sprof debug` 列出偵測結果

## 需求

- 價格需要 **Auctionator**，請先在拍賣場掃描一次；沒有時只有商人物品有價格。
- 選用：**WaypointUI** 導航（沒有就用遊戲內建的地圖標記）。小地圖路線需要附 HereBeDragons 的插件，例如 **Questie**。

## 注意

- 在架數量只代表有多少人在賣，不代表賣得掉（遊戲沒有成交量資料）。
- 衝級路線資料整理自 kovarel.com 的 WoW Forever 專業工具。

