**專案名稱：** 阿聖專業幫手 ShengProfession
**授權（License）：** GPL-3.0
**系列：** 阿聖 Sheng（另有 阿聖練等幫手 ShengLeveling、阿聖治療幫手 ShengHealing）
**摘要（Summary，一行）：** 魔獸世界：永恆專業幫手：利潤表、製作佇列一鍵製作、最省衝級路線、Auctionator 購物清單、採集追蹤提醒。
**分類：** Professions、Auction & Economy
**語言：** 繁體中文（zhTW）
**選用相依（Optional dependency）：** Auctionator

---

## 阿聖專業幫手（魔獸世界：永恆）

做專業最常遇到的問題：「做什麼賺錢？」「衝級要買多少材料、花多少錢？」「一堆東西要做，要一個一個點？」這個插件一次處理。

### 功能

**利潤表**
- 列出你學會的所有配方：材料成本、拍賣售價（已扣 5% 手續費）、利潤、利潤 %，可以點欄名排序。
- 材料可以自己做中間材料時，自動比較「買」還是「自己做」便宜。
- 顯示拍賣場在架數量（Auctionator 掃描紀錄），看競爭多不多。

**製作佇列**
- 想做的東西加進佇列，**一鍵依序製作**，做完自動換下一個。
- 依佇列需要的材料（扣掉背包和銀行已有的）一鍵建立 **Auctionator 購物清單**。

**衝級路線**
- 依目前拍賣價格，從多條路線中挑最省的，列出每一段做什麼、做幾次。
- 算出總花費，以及做出來的成品賣掉可以回收多少。
- 中間材料可以拆成原材料比價。

**採集追蹤提醒**
- 學了採礦或草藥學卻沒開「尋找礦物／尋找草藥」時，自動開啟；遊戲不允許時，畫面上出現提醒按鈕，點一下就開。

**採集路線**
- 「採集」分頁依目前採礦／草藥點數推薦部落採集路線（礦、草、雙採共 41 條），選一條就在世界地圖畫出整圈、小地圖沿路顯示虛線點（需要 Questie 等附 HereBeDragons 的插件），「去起點」設航點；滑鼠提示列出建議等級、產出與危險地點。

**語音提示**
- 附近出現礦或草時念出名稱（例如「錫礦」），預設只念你學會、點數也夠採的；戰鬥中不念。主視窗右上角「語音：開／關」，右鍵或 `/sprof voice config` 進設定：音量、語速、語音、每種礦草個別開關；`/sprof voice` 開關、`/sprof voice test` 試聽。

**公會誰會做**
- 有裝本插件的公會成員會自動互傳學會的配方：利潤表、佇列和物品滑鼠提示會顯示「公會：誰會做」；`/sprof guild` 看收到幾人的資料，`/sprof guild 名字` 看單人的專業與點數，`/sprof guild off` 不分享自己的（預設分享）。

**專業視窗整合**
- 打開專業視窗時，旁邊可以展開專業幫手，直接把配方加進佇列。

**下一階去哪學**
- 點數快到上限時，視窗顯示下一階（專家／大師）的部落訓練師、等級與技能門檻、費用，烹飪、急救、釣魚則列出技能書或任務；按「去」設航點（有 WaypointUI 就用它）。`/sprof train` 列出所有專業的下一階地點。

### 指令

- `/sprof` 開關視窗
- `/sprof track` 採集追蹤提醒設定
- `/sprof scale 1.2` 調整視窗大小（也可以拖右下角）
- `/sprof minimap` 隱藏／顯示小地圖按鈕
- `/sprof debug` 列出偵測結果

### 注意

- 價格需要 **Auctionator**，請先在拍賣場掃描一次。沒有 Auctionator 時只有商人物品有價格。
- 「在架數量」只代表有多少人在賣，不代表賣得掉（遊戲沒有成交量資料）。
- 衝級路線資料整理自 kovarel.com 的 WoW Forever 專業工具，物品名稱來自 Wowhead。

網頁版：https://ms145236-bridge.github.io/wow-profession-calc/
原始碼與問題回報：https://github.com/ms145236-bridge/wow-profession-calc

---

**English (ShengProfession):** Profession helper for WoW Forever (zhTW client): profit table for all your recipes, a crafting queue with one-click crafting, cheapest leveling route based on Auctionator prices, Auctionator shopping lists, and a gathering-tracking reminder. Requires Auctionator for prices.

- **Guild crafters:** guild members who also run ShengProfession share their known recipes automatically; recipe rows and item tooltips show who in your guild can craft it (`/sprof guild`, `/sprof guild <name>`; `/sprof guild off` stops sharing yours, on by default).
- **Next rank trainer:** when a profession nears its cap, the window shows where to learn Expert/Artisan (Horde trainer, level and skill requirements, cost; the book or quest for Cooking, First Aid and Fishing) with a button that sets a waypoint (uses WaypointUI if installed). `/sprof train` lists the next rank location for all your professions.
- **Gathering routes:** the Gathering tab recommends Horde mining, herbalism and dual-gathering loops (41 routes) for your current skill; pick one to draw the full loop on the world map and a dotted trail on the minimap (needs an addon that ships HereBeDragons, such as Questie), and 「去起點」 sets a waypoint to the start. Tooltips show the suggested level, yields and danger spots.
- **Voice alerts:** speaks the name of herbs and ore that come into range (text-to-speech), by default only ones you have the profession and skill to gather, never in combat. Toggle with the 「語音：開／關」 button or `/sprof voice`; volume, speed, voice and per-node switches in the game's AddOn settings (`/sprof voice config`, `/sprof voice test` plays a sample).
