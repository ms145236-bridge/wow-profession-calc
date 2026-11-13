**專案名稱：** 阿聖專業幫手 BridgeProfession
**授權（License）：** GPL-3.0
**系列：** 阿聖 Bridge（另有 阿聖練等幫手 BridgeLeveling、阿聖治療幫手 BridgeHealing）
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

**專業視窗整合**
- 打開專業視窗時，旁邊可以展開專業幫手，直接把配方加進佇列。

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

**English (BridgeProfession):** Profession helper for WoW Forever (zhTW client): profit table for all your recipes, a crafting queue with one-click crafting, cheapest leveling route based on Auctionator prices, Auctionator shopping lists, and a gathering-tracking reminder. Requires Auctionator for prices.
