# 《魔獸世界：永恆》採集物件查核

適用版本 **1.60.1.70938**。物件 ID 用 GameObject ID。採集技能欄是開始採集的最低點數。地區列主要刷新區，並標出任務、團本與臨時生成的例外。台服名稱優先取永恆版 zhTW 物件滑鼠提示。若只有 QuestieDB 譯名、測試服快取或材料譯名，逐項註明；找不到正式服名稱的物件保留英文並標【需遊戲實測】。本機正式服 zhTW 物件快取只有檔頭，沒有可供比對的物件紀錄。[Wowhead 永恆礦物索引](https://www.wowhead.com/forever/objects/mineral-veins) · [Wowhead 永恆草藥索引](https://www.wowhead.com/forever/objects/herbs) · [QuestieDB 原始資料](https://github.com/Questie/QuestieDB) · [暴雪永恆版公告](https://worldofwarcraft.blizzard.com/en-us/news/24315820/world-of-warcraft-forever-now-live)

70938 的 `GameObjects` 公開匯出沒有一般礦草用的 Type 3 或魚群用的 Type 25，因此不能單靠該表枚舉所有 ID。`GameObjectDisplayInfo` 提供模型，數個物件可共用同一模型。以玩家互動後的永恆物件快取補齊物件型別、模型與 Lock ID，再用 70938 `Lock`／`LockType` 的採礦、草藥欄核對門檻。本機 QuestieDB 依 `QuestieDB_Forever.toc` 讀取物件資料和 `src/corrections/Forever/foreverObjectFixes.lua`；地區另與 Wowhead 物件頁比對。經典、探索賽季及較早永恆快取只用於交叉核對，分別標示。[70938 GameObjects](https://wago.tools/db2/GameObjects/csv?build=1.60.1.70938&locale=zhTW) · [70938 GameObjectDisplayInfo](https://wago.tools/db2/GameObjectDisplayInfo/csv?build=1.60.1.70938) · [70938 Lock](https://wago.tools/db2/Lock/csv?build=1.60.1.70938) · [70938 LockType](https://wago.tools/db2/LockType/csv?build=1.60.1.70938) · [永恆 70888 玩家物件紀錄](https://github.com/JIVESCORP/eg-link-output-wowf/blob/main/data/wowf/1.60.1.70888/object_details.enUS.json) · [永恆 70790 玩家物件紀錄](https://github.com/JIVESCORP/eg-link-output-wowf/blob/main/data/wowf/1.60.1.70790/object_details.enUS.json)

例如銅礦 **1731** 與貧瘠的銅礦 **562111** 同用 Display 310、Lock 38，採礦門檻都是 1。寧神花 **1618／3724** 與銀葉草 **1617／3725** 共用 Lock 29，草藥門檻都是 1。軟泥覆蓋的銀、金、秘銀共用 Display 767，對應三個不同 Lock，門檻分別是 75、155、175。這些礦脈依採礦分類播報。[永恆玩家物件紀錄](https://github.com/JIVESCORP/eg-link-output-wowf/blob/main/data/wowf/1.60.1.70888/object_details.enUS.json) · [70938 Lock](https://wago.tools/db2/Lock/csv?build=1.60.1.70938) · [永恆野外採集紀錄](https://pd.zroot.it/forever/nodes)

## 插件用精簡表

一般礦草資料含 39 個礦物、44 個草藥物件 ID。「—」代表此表不套採礦或草藥門檻。類型「其他」供選配分類，包含寶箱、魚群、任務物件與栽培複製物。預設礦草語音可排除任務礦 **1610、1667、2653、19903**。同名物件依 ID 分類，尤其是 **657xxx** 栽培複製物。祖爾格拉布、安其拉、暫未核到正式服刷新的舊別名與臨時召喚物件留在後面的查核章節；`School of Whimsyfin` 是測試版候選，啟用前需實測。

| 名稱 | 類型 | 技能點 | GameObject ID 清單 |
|---|---|---:|---|
| 貧瘠的銅礦 | 礦 | 1 | 562111 |
| 銅礦 | 礦 | 1 | 1731, 2055, 3763, 103713 |
| 一塊琥珀 | 礦 | 1 | 656332 |
| 大塊琥珀 | 礦 | 1 | 656333 |
| 錫礦 | 礦 | 65 | 1732, 2054, 3764, 103711 |
| 火岩礦脈 | 礦 | 65 | 1610, 1667 |
| 銀礦 | 礦 | 75 | 1733, 105569 |
| 軟泥覆蓋的銀礦脈 | 礦 | 75 | 73940 |
| 次級血石礦脈 | 礦 | 75 | 2653 |
| 鐵礦床 | 礦 | 125 | 1735 |
| 精鐵礦脈 | 礦 | 150 | 19903 |
| 金礦脈 | 礦 | 155 | 1734, 150080 |
| 金礦石 | 礦 | 155 | 181109 |
| 軟泥覆蓋的金礦脈 | 礦 | 155 | 73941 |
| 秘銀礦床 | 礦 | 175 | 2040 |
| 祕銀礦脈 | 礦 | 175 | 150079, 176645 |
| 軟泥覆蓋的祕銀礦脈 | 礦 | 175 | 123310 |
| 真銀礦床 | 礦 | 230 | 2047, 150081 |
| 真銀礦石 | 礦 | 230 | 181108 |
| 軟泥覆蓋的真銀礦脈 | 礦 | 230 | 123309 |
| 黑鐵礦床 | 礦 | 230 | 165658 |
| 瑟銀礦脈 | 礦 | 245 | 324, 150082, 176643 |
| 軟泥覆蓋的瑟銀礦脈 | 礦 | 245 | 123848 |
| 富瑟銀礦 | 礦 | 275 | 175404 |
| 軟泥覆蓋的富瑟銀礦脈 | 礦 | 275 | 177388 |
| Heavy Thorium Vein | 礦 | 300 | 566779 |
| 寧神花 | 草 | 1 | 1618, 3724 |
| 銀葉草 | 草 | 1 | 1617, 3725 |
| 凋謝的寧神花 | 草 | 1 | 656160 |
| 貧弱的銀葉草 | 草 | 1 | 656161 |
| 地根草 | 草 | 15 | 1619, 3726 |
| 魔皇草 | 草 | 50 | 1620, 3727 |
| 石南草 | 草 | 70 | 1621, 3729 |
| 荊棘藻 | 草 | 85 | 2045 |
| 跌打草 | 草 | 100 | 1622, 3730 |
| 野鋼花 | 草 | 115 | 1623 |
| 墓地苔 | 草 | 120 | 1628 |
| 皇血草 | 草 | 125 | 1624 |
| 活根草 | 草 | 150 | 2041 |
| 枯葉草 | 草 | 160 | 2042 |
| 金棘草 | 草 | 170 | 2046 |
| 卡德加的鬍鬚 | 草 | 185 | 2043 |
| 冬刺草 | 草 | 195 | 2044 |
| 火焰花 | 草 | 205 | 2866 |
| 紫蓮花 | 草 | 210 | 142140 |
| 阿薩斯之淚 | 草 | 220 | 142141, 176642 |
| 太陽草 | 草 | 230 | 142142, 176636 |
| 盲目草 | 草 | 235 | 142143 |
| 幽靈菇 | 草 | 245 | 142144 |
| 格羅姆高之血 | 草 | 250 | 142145, 176637 |
| 黃金蔘 | 草 | 260 | 176583, 176638 |
| 夢葉草 | 草 | 270 | 176584, 176639 |
| 山鼠草 | 草 | 280 | 176586, 176640 |
| 瘟疫花 | 草 | 285 | 176587, 176641 |
| 冰蓋草 | 草 | 290 | 176588 |
| 黑蓮花 | 草 | 300 | 176589 |
| Demonsage | 草 | 300 | 566786 |
| 破損的箱子 | 其他 | — | 2843, 2849, 106318, 106319 |
| 堅固的箱子 | 其他 | — | 2850, 2852, 2855, 2857, 4149, 153451, 153453, 153454 |
| 破碎的大箱子 | 其他 | — | 75293 |
| 堅固的大箱子 | 其他 | — | 75298, 75299, 75300, 153463, 153464 |
| 大型鐵箍儲物箱 | 其他 | — | 75295, 75296, 75297 |
| 大型祕銀儲物箱 | 其他 | — | 131978, 153468, 153469 |
| 凹陷的箱子 | 其他 | — | 626718, 626752 |
| 本尼迪克的箱子 | 其他 | — | 3239 |
| 沉沒的箱子 | 其他 | — | 32 |
| 七賢之箱 | 其他 | — | 169243 |
| 競技場財寶箱 | 其他 | — | 179697 |
| 血瓣花苗 | 其他 | — | 164958 |
| 藍色能量水晶 | 其他 | — | 164658 |
| 綠色能量水晶 | 其他 | — | 164659 |
| 紅色能量水晶 | 其他 | — | 164660 |
| 黃色能量水晶 | 其他 | — | 164661 |
| 貝殼陷阱 | 其他 | — | 176582, 176635 |
| 巨型蚌殼 | 其他 | — | 2744, 19017, 19018 |
| Fresh Wreckage | 其他 | — | 630533 |
| 浮標 | 其他 | — | 35591 |
| 魚群 | 其他 | — | 180184 |
| 可口魚魚群 | 其他 | — | 180248 |
| 變異魚魚群 | 其他 | — | 180658 |
| 黑口魚魚群 | 其他 | — | 180582, 180664, 180682, 180750, 180900 |
| 火鰭鯛魚群 | 其他 | — | 180657, 180683, 180752, 180902 |
| 鼠尾魚魚群 | 其他 | — | 180656, 180663 |
| 大型鼠尾魚魚群 | 其他 | — | 180684 |
| 石鱗鰻魚群 | 其他 | — | 180712 |
| 漂浮的碎片 | 其他 | — | 180655 |
| 漂浮的殘骸 | 其他 | — | 180662 |
| 漂浮殘骸 | 其他 | — | 180685, 180751, 180901 |
| 元素之水 | 其他 | — | 180753 |
| 混濁的水 | 其他 | — | 180369 |
| 墓穴草 | 其他 | — | 694732 |
| School of Whimsyfin | 其他 | — | 572928 |
| 油井 | 其他 | — | 180661 |
| 礫石 | 其他 | — | 414658 |
| 巨型軟殼蚌 | 其他 | — | 177784 |
| Hyjal Silphium | 其他 | — | 654624 |
| Wildflower | 其他 | — | 648994 |
| 毒蛇花 | 其他 | — | 13891 |
| 紫色水生菇 | 其他 | — | 141853 |
| 陰暗草 | 其他 | — | 175566 |
| 火焰龍舌蘭 | 其他 | — | 175928 |
| 末日草 | 其他 | — | 176753 |
| 擱淺的海洋生物 | 其他 | — | 175207 |
| 海龜骨頭 | 其他 | — | 176189 |
| 銀葉草 | 其他 | — | 657380 |
| 寧神花 | 其他 | — | 657382, 657456 |
| 地根草 | 其他 | — | 657383, 657458 |
| 石南草 | 其他 | — | 657385, 657460 |
| 跌打草 | 其他 | — | 657386 |
| 野鋼花 | 其他 | — | 657387 |
| 皇血草 | 其他 | — | 657388 |
| 活根草 | 其他 | — | 657390 |
| 荊棘藻 | 其他 | — | 657394 |
| 凋謝的寧神花 | 其他 | — | 657454 |
| 貧弱的銀葉草 | 其他 | — | 657455 |
| 魔皇草 | 其他 | — | 657459 |

## 礦脈

常用名稱取 Wowhead 永恆台服物件提示。同一英文名稱的不同 ID 可能顯示不同台服名稱，例如 2040「秘銀礦床」與 150079、176645「祕銀礦脈」，因此分列。括號內譯名若僅來自 QuestieDB，已標明來源。地區列目前能核對的主要地圖，使用物件頁、Wowhead 礦點匯入的地圖或本機 QuestieDB 的刷新點。資料庫顯示某地區有資料時，野外刷新、任務階段、團隊開放和當前可採性仍可能因伺服器進度而不同。[Wowhead 永恆礦點列表](https://www.wowhead.com/forever/objects/mineral-veins) · [Wowhead 永恆採礦總覽](https://www.wowhead.com/forever/tw/guide/professions/mining/overview-leveling) · [GatherLite 地圖匯入資料](https://github.com/Wuild/GatherLite/blob/master/tools/wowhead/forever.json)

| 名稱（英文） | 採礦技能 | GameObject ID | 主要地區及補充 |
|---|---:|---|---|
| 貧瘠的銅礦（Poor Copper Vein） | 1 | 562111 | 永恆新點，莫高雷、杜洛塔、艾爾文森林、提里斯法林地、丹莫洛、微風島。[562111](https://nether.wowhead.com/forever/tooltip/object/562111?locale=10) · [地區](https://www.wowhead.com/forever/tw/object=562111/poor-copper-vein) |
| 銅礦（Copper Vein） | 1 | 1731, 2055, 3763, 103713 | 微風島、莫高雷、杜洛塔、提里斯法林地、貧瘠之地、丹莫洛、艾爾文森林、赤脊山等。2055 在赤脊山，3763／103713 在貧瘠之地。[1731](https://nether.wowhead.com/forever/tooltip/object/1731?locale=10) · [2055](https://nether.wowhead.com/forever/tooltip/object/2055?locale=10) · [3763](https://nether.wowhead.com/forever/tooltip/object/3763?locale=10) · [103713](https://nether.wowhead.com/forever/tooltip/object/103713?locale=10) |
| 一塊琥珀（Chunk of Amber） | 1 | 656332 | 永恆新點，泰達希爾，採得銅礦石等。[656332](https://nether.wowhead.com/forever/tooltip/object/656332?locale=10) |
| 大塊琥珀（Large Chunk of Amber） | 1 | 656333 | 永恆新點，泰達希爾，採得銅礦石等。[656333](https://nether.wowhead.com/forever/tooltip/object/656333?locale=10) |
| 錫礦（Tin Vein） | 65 | 1732, 2054, 3764, 103711 | 赤脊山、貧瘠之地、希爾斯布萊德丘陵、梣谷、洛克莫丹、濕地、銀松森林、千針石林、大河林地。2054 在赤脊山，3764 在貧瘠之地，103711 在貧瘠之地／希爾斯布萊德丘陵。[1732](https://nether.wowhead.com/forever/tooltip/object/1732?locale=10) · [2054](https://nether.wowhead.com/forever/tooltip/object/2054?locale=10) · [3764](https://nether.wowhead.com/forever/tooltip/object/3764?locale=10) · [103711](https://nether.wowhead.com/forever/tooltip/object/103711?locale=10) |
| 火岩礦脈（Incendicite Mineral Vein） | 65 | 1610, 1667 | 濕地瑟根石洞，任務礦。台服名稱取本機 QuestieDB，Wowhead 台服提示回退英文，遊戲滑鼠提示【需遊戲實測】。[1610](https://nether.wowhead.com/forever/tooltip/object/1610?locale=10) · [1667](https://nether.wowhead.com/forever/tooltip/object/1667?locale=10) |
| 銀礦（Silver Vein） | 75 | 1733, 105569 | 阿拉希高地、千針石林、貧瘠之地、希爾斯布萊德丘陵、荊棘谷、石爪山脈、荒蕪之地、大河林地。105569 在貧瘠之地／希爾斯布萊德丘陵。[1733](https://nether.wowhead.com/forever/tooltip/object/1733?locale=10) · [105569](https://nether.wowhead.com/forever/tooltip/object/105569?locale=10) |
| 軟泥覆蓋的銀礦脈（Ooze Covered Silver Vein） | 75 | 73940 | 千針石林。台服名稱取本機 QuestieDB。[73940](https://nether.wowhead.com/forever/tooltip/object/73940?locale=10) |
| 次級血石礦脈（Lesser Bloodstone Deposit） | 75 | 2653 | 阿拉希高地枯鬚峽谷的洞穴，任務礦。此處採用永恆台服物件提示，Questie 舊名為「次級血石礦床」。[2653](https://nether.wowhead.com/forever/tooltip/object/2653?locale=10) |
| 鐵礦床（Iron Deposit） | 125 | 1735 | 阿拉希高地、淒涼之地、千針石林、荊棘谷、奧特蘭克山脈、大河林地、荒蕪之地、梣谷、申德拉斯。[1735](https://nether.wowhead.com/forever/tooltip/object/1735?locale=10) |
| 精鐵礦脈（Indurium Mineral Vein） | 150 | 19903 | 奧達曼，任務礦。物件頁列副本，公開頁無可用的本內座標。[19903](https://nether.wowhead.com/forever/tooltip/object/19903?locale=10) |
| 金礦脈（Gold Vein） | 155 | 1734, 150080 | 阿拉希高地、荒蕪之地、荊棘谷、塔納利斯、千針石林、辛特蘭、大河林地。150080 在詛咒之地且 zhTW 名取本機 QuestieDB。[1734](https://nether.wowhead.com/forever/tooltip/object/1734?locale=10) · [150080](https://nether.wowhead.com/forever/tooltip/object/150080?locale=10) |
| 金礦石（Gold Vein） | 155 | 181109 | 費伍德森林。此 ID 的提示就是「金礦石」。[181109](https://nether.wowhead.com/forever/tooltip/object/181109?locale=10) |
| 軟泥覆蓋的金礦脈（Ooze Covered Gold Vein） | 155 | 73941 | 菲拉斯、千針石林。台服名稱取本機 QuestieDB。[73941](https://nether.wowhead.com/forever/tooltip/object/73941?locale=10) |
| 秘銀礦床（Mithril Deposit） | 175 | 2040 | 辛特蘭、塔納利斯、艾薩拉、淒涼之地、荒蕪之地、菲拉斯、灼熱峽谷、大河林地、申德拉斯。2040 的「秘」為台服提示原字。[2040](https://nether.wowhead.com/forever/tooltip/object/2040?locale=10) |
| 祕銀礦脈（Mithril Deposit） | 175 | 150079, 176645 | 150079 在詛咒之地，176645 在費伍德森林。[150079](https://nether.wowhead.com/forever/tooltip/object/150079?locale=10) · [176645](https://nether.wowhead.com/forever/tooltip/object/176645?locale=10) |
| 軟泥覆蓋的祕銀礦脈（Ooze Covered Mithril Deposit） | 175 | 123310 | 菲拉斯、千針石林。[123310](https://nether.wowhead.com/forever/tooltip/object/123310?locale=10) |
| 真銀礦床（Truesilver Deposit） | 230 | 2047, 150081 | 希利蘇斯、冬泉谷、辛特蘭、安戈洛環形山、燃燒平原、東瘟疫之地、艾薩拉、大河林地。150081 在詛咒之地且 zhTW 名取本機 QuestieDB。[2047](https://nether.wowhead.com/forever/tooltip/object/2047?locale=10) · [150081](https://nether.wowhead.com/forever/tooltip/object/150081?locale=10) |
| 真銀礦石（Truesilver Deposit） | 230 | 181108 | 費伍德森林。此 ID 的提示就是「真銀礦石」。[181108](https://nether.wowhead.com/forever/tooltip/object/181108?locale=10) |
| 軟泥覆蓋的真銀礦脈（Ooze Covered Truesilver Deposit） | 230 | 123309 | 希利蘇斯、安戈洛環形山、菲拉斯。[123309](https://nether.wowhead.com/forever/tooltip/object/123309?locale=10) |
| 黑鐵礦床（Dark Iron Deposit） | 230 | 165658 | 燃燒平原、灼熱峽谷、黑石深淵。物件資料也收錄經典熔火之心，該團本開放狀態依永恆時程。[165658](https://nether.wowhead.com/forever/tooltip/object/165658?locale=10) · [官方團本時程](https://worldofwarcraft.blizzard.com/en-gb/news/24303009) |
| 瑟銀礦脈（Small Thorium Vein） | 245 | 324, 150082, 176643 | 安戈洛環形山、希利蘇斯、燃燒平原、詛咒之地、冬泉谷、費伍德森林、東／西瘟疫之地。150082 在詛咒之地，176643 在費伍德森林。[324](https://nether.wowhead.com/forever/tooltip/object/324?locale=10) · [150082](https://nether.wowhead.com/forever/tooltip/object/150082?locale=10) · [176643](https://nether.wowhead.com/forever/tooltip/object/176643?locale=10) |
| 軟泥覆蓋的瑟銀礦脈（Ooze Covered Thorium Vein） | 245 | 123848 | 安戈洛環形山、菲拉斯。[123848](https://nether.wowhead.com/forever/tooltip/object/123848?locale=10) |
| 富瑟銀礦（Rich Thorium Vein） | 275 | 175404 | 希利蘇斯、冬泉谷、東／西瘟疫之地、艾薩拉、海加爾山、燃燒平原、安戈洛環形山。[175404](https://nether.wowhead.com/forever/tooltip/object/175404?locale=10) |
| 軟泥覆蓋的富瑟銀礦脈（Ooze Covered Rich Thorium Vein） | 275 | 177388 | 希利蘇斯蟲巢。[177388](https://nether.wowhead.com/forever/tooltip/object/177388?locale=10) |
| Heavy Thorium Vein【需遊戲實測】 | 300 | 566779 | 永恆新點，海加爾山，Wowhead 台服礦點提示仍為英文，「沉重瑟銀礦石」為掉落物名稱。[566779](https://nether.wowhead.com/forever/tooltip/object/566779?locale=10) · [地區與採集記載](https://www.wow-professions.com/forever/mining-changes) |

### 礦脈候選與階段物件

| 名稱（英文） | 採礦技能 | GameObject ID | 核對狀態 |
|---|---:|---|---|
| 冷鐵礦床（Cold Iron Deposit） | 125 | 439558 | 暮色森林的探索賽季夢魘入侵採集。Wowhead 永恆提示及 QuestieDB 皆有記錄，未找到永恆正式服刷新【需遊戲實測】。[439558](https://nether.wowhead.com/forever/tooltip/object/439558?locale=10) |
| 愚人的黃金礦脈（Fool's Gold Vein） | 175 | 439628 | 梣谷的探索賽季夢魘入侵採集，永恆正式服刷新【需遊戲實測】。[439628](https://nether.wowhead.com/forever/tooltip/object/439628?locale=10) |
| 星銀礦脈（Starsilver Vein） | 245 | 439778 | 辛特蘭的探索賽季夢魘入侵採集，永恆正式服刷新【需遊戲實測】。[439778](https://nether.wowhead.com/forever/tooltip/object/439778?locale=10) |
| 強效月亮石陣（Greater Moonstone Formation） | 245 | 439815 | 菲拉斯的探索賽季夢魘入侵採集，永恆正式服刷新【需遊戲實測】。[439815](https://nether.wowhead.com/forever/tooltip/object/439815?locale=10) |
| 哈卡萊瑟銀礦脈（Hakkari Thorium Vein） | 275 | 180215 | 祖爾格拉布。永恆物件提示門檻為 275。官方首批團本不含祖爾格拉布，永恆可採階段【需遊戲實測】。[180215](https://nether.wowhead.com/forever/tooltip/object/180215?locale=10) |
| 小黑曜石塊（Small Obsidian Chunk） | 305 | 181068 | 物件資料列希利蘇斯、安其拉神廟、安其拉廢墟。經典有藉採礦加成超過 300 的門檻做法，永恆可採性及開放階段【需遊戲實測】。[181068](https://nether.wowhead.com/forever/tooltip/object/181068?locale=10) · [地區](https://www.wowhead.com/forever/object=181068/small-obsidian-chunk) |
| 大黑曜石塊（Large Obsidian Chunk） | 305 | 181069 | 物件資料列希利蘇斯、安其拉神廟、安其拉廢墟，永恆可採性及開放階段【需遊戲實測】。[181069](https://nether.wowhead.com/forever/tooltip/object/181069?locale=10) · [地區](https://www.wowhead.com/forever/object=181069/large-obsidian-chunk) |
| 軟泥覆蓋的鐵礦床（Ooze Covered Iron Deposit） | 125（經典） | 73939 | QuestieDB 有名稱、無刷新點，經典物件有類型和門檻。永恆可採性【需遊戲實測】。[經典 73939](https://nether.wowhead.com/classic/tooltip/object/73939?locale=10) |
| 銅礦（Copper Vein） | 1（經典） | 103714 | GatherLite 列舊別名、經典有物件提示；永恆物件提示與本機刷新未找到【需遊戲實測】。[經典 103714](https://nether.wowhead.com/classic/tooltip/object/103714?locale=10) |
| 錫礦（Tin Vein） | ？ | 103709 | 經典提示為 1，與常規錫礦 65 不同；永恆物件提示與刷新【需遊戲實測】。[經典 103709](https://nether.wowhead.com/classic/tooltip/object/103709?locale=10) |
| 鐵礦床（Iron Deposit） | 125（經典） | 103710, 103712 | GatherLite 列舊別名、經典有物件提示；永恆物件提示與刷新【需遊戲實測】。[經典 103710](https://nether.wowhead.com/classic/tooltip/object/103710?locale=10) · [經典 103712](https://nether.wowhead.com/classic/tooltip/object/103712?locale=10) |
| 富瑟銀礦（Rich Thorium Vein） | 275（經典） | 176644 | GatherLite 列舊別名、經典有物件提示；永恆物件提示與刷新【需遊戲實測】。[經典 176644](https://nether.wowhead.com/classic/tooltip/object/176644?locale=10) |
| 銅礦脈／錫礦脈（Copper Vein／Tin Vein） | 1／65（燃燒的遠征） | 181248, 181249 | 本機 QuestieDB 有名稱、無刷新點，燃燒的遠征地圖為鬼魂之地。永恆物件提示與刷新【需遊戲實測】。[燃燒的遠征 181248](https://nether.wowhead.com/tbc/tooltip/object/181248?locale=10) · [燃燒的遠征 181249](https://nether.wowhead.com/tbc/tooltip/object/181249?locale=10) |

探索賽季物件與未開放團本物件可保存 ID 供日後比對。正式服野外語音預設只納入前表。[探索賽季礦點](https://warcraft.wiki.gg/wiki/Deposits#Season_of_Discovery) · [暴雪夢魘入侵區域](https://worldofwarcraft.blizzard.com/en-us/news/24078318) · [暴雪首批團本公告](https://worldofwarcraft.blizzard.com/en-gb/news/24303009) · [GatherLite 礦點別名表](https://github.com/Wuild/GatherLite/blob/master/scripts/nodes.lua)

黃鐵、鋁土礦、方鈾礦、銅鈾雲母和惡魔水晶是礦點的額外掉落，公開資料未給獨立礦點 ID。奇石園是營地設施，三個生成法術引用一般銅、錫、鐵礦點，詳見法術引用章節。Rockslicer 可採銅、錫、銀、鐵，工具例外不改上表採礦門檻。[Wowhead 永恆採礦總覽](https://www.wowhead.com/forever/tw/guide/professions/mining/overview-leveling) · [營地與新材料](https://www.wow-professions.com/forever/mining-changes) · [Rockslicer](https://www.wowhead.com/forever/item=872/rockslicer)

## 草藥學採集點

最低點數採永恆 Wowhead 台服物件提示，地區綜合永恆 Wowhead 採集分布與本機 QuestieDB Forever。貧瘠之地 3724／3725／3726／3727／3729／3730 為同名採集點，永恆 70888 玩家快取亦記到正常草藥鎖和可伴生的任務物品 5056。祖爾格拉布五個物件有永恆草藥提示、地區和 QuestieDB 副本記錄，尚缺本版實際採集紀錄【需遊戲實測】。[永恆草藥物件](https://www.wowhead.com/forever/objects/herbs) · [永恆草藥地區](https://www.wowhead.com/forever/tw/guide/professions/herbalism/overview-leveling) · [GatherLite 永恆地區資料](https://github.com/Wuild/GatherLite/blob/master/tools/wowhead/forever.json) · [QuestieDB](https://github.com/Questie/QuestieDB)

| 遊戲物件名 | 英文 | 草藥學 | GameObject ID／永恆台服物件提示 | 主要區域 |
|---|---|---:|---|---|
| 寧神花 | Peacebloom | 1 | [1618](https://nether.wowhead.com/forever/tooltip/object/1618?locale=10)、[3724](https://nether.wowhead.com/forever/tooltip/object/3724?locale=10) | 微風島、莫高雷、杜洛塔、提里斯法林地、泰達希爾、艾爾文森林、丹莫洛。3724 在貧瘠之地 |
| 銀葉草 | Silverleaf | 1 | [1617](https://nether.wowhead.com/forever/tooltip/object/1617?locale=10)、[3725](https://nether.wowhead.com/forever/tooltip/object/3725?locale=10) | 莫高雷、微風島、提里斯法林地、杜洛塔、艾爾文森林、泰達希爾、丹莫洛、銀松森林。3725 在貧瘠之地 |
| 凋謝的寧神花 | Wilted Peacebloom | 1 | [656160](https://nether.wowhead.com/forever/tooltip/object/656160?locale=10) | 永恆新增出生區點。莫高雷、杜洛塔、提里斯法林地、艾爾文森林、丹莫洛、泰達希爾 |
| 貧弱的銀葉草 | Stunted Silverleaf | 1 | [656161](https://nether.wowhead.com/forever/tooltip/object/656161?locale=10) | 永恆新增出生區點。莫高雷、杜洛塔、提里斯法林地、艾爾文森林、丹莫洛、泰達希爾 |
| 地根草 | Earthroot | 15 | [1619](https://nether.wowhead.com/forever/tooltip/object/1619?locale=10)、[3726](https://nether.wowhead.com/forever/tooltip/object/3726?locale=10) | 微風島、莫高雷、杜洛塔、提里斯法林地、赤脊山。3726 在貧瘠之地 |
| 魔皇草 | Mageroyal | 50 | [1620](https://nether.wowhead.com/forever/tooltip/object/1620?locale=10)、[3727](https://nether.wowhead.com/forever/tooltip/object/3727?locale=10) | 貧瘠之地、銀松森林、赤脊山、洛克莫丹、西部荒野、黑海岸、微風島。3727 在貧瘠之地 |
| 石南草 | Briarthorn | 70 | [1621](https://nether.wowhead.com/forever/tooltip/object/1621?locale=10)、[3729](https://nether.wowhead.com/forever/tooltip/object/3729?locale=10) | 貧瘠之地、銀松森林、赤脊山、暮色森林、西部荒野、希爾斯布萊德丘陵。3729 在貧瘠之地 |
| 荊棘藻 | Stranglekelp | 85 | [2045](https://nether.wowhead.com/forever/tooltip/object/2045?locale=10) | 濕地、荊棘谷、梣谷、淒涼之地、大河林地、貧瘠之地、銀松森林的水域 |
| 跌打草 | Bruiseweed | 100 | [1622](https://nether.wowhead.com/forever/tooltip/object/1622?locale=10)、[3730](https://nether.wowhead.com/forever/tooltip/object/3730?locale=10) | 石爪山脈、貧瘠之地、梣谷、赤脊山、暮色森林、希爾斯布萊德丘陵。3730 在貧瘠之地 |
| 野鋼花 | Wild Steelbloom | 115 | [1623](https://nether.wowhead.com/forever/tooltip/object/1623?locale=10) | 荊棘谷、石爪山脈、阿拉希高地、濕地、希爾斯布萊德丘陵、大河林地、千針石林 |
| 墓地苔 | Grave Moss | 120 | [1628](https://nether.wowhead.com/forever/tooltip/object/1628?locale=10) | 暮色森林、淒涼之地、濕地、阿拉希高地、貧瘠之地、剃刀高地與血色修道院墓地 |
| 皇血草 | Kingsblood | 125 | [1624](https://nether.wowhead.com/forever/tooltip/object/1624?locale=10) | 荊棘谷、濕地、希爾斯布萊德丘陵、梣谷、石爪山脈、阿拉希高地、大河林地 |
| 活根草 | Liferoot | 150 | [2041](https://nether.wowhead.com/forever/tooltip/object/2041?locale=10) | 塵泥沼澤、荊棘谷、悲傷沼澤、濕地、奧特蘭克山脈、大河林地、菲拉斯，多在水邊 |
| 枯葉草 | Fadeleaf | 160 | [2042](https://nether.wowhead.com/forever/tooltip/object/2042?locale=10) | 塵泥沼澤、奧特蘭克山脈、阿拉希高地、荊棘谷、悲傷沼澤、荒蕪之地、辛特蘭 |
| 金棘草 | Goldthorn | 170 | [2046](https://nether.wowhead.com/forever/tooltip/object/2046?locale=10) | 荊棘谷、菲拉斯、阿拉希高地、塵泥沼澤、悲傷沼澤、大河林地、辛特蘭 |
| 卡德加的鬍鬚 | Khadgar's Whisker | 185 | [2043](https://nether.wowhead.com/forever/tooltip/object/2043?locale=10) | 荊棘谷、菲拉斯、阿拉希高地、塵泥沼澤、悲傷沼澤、奧特蘭克山脈、大河林地 |
| 冬刺草 | Wintersbite | 195 | [2044](https://nether.wowhead.com/forever/tooltip/object/2044?locale=10) | 奧特蘭克山脈雪地 |
| 火焰花 | Firebloom | 205 | [2866](https://nether.wowhead.com/forever/tooltip/object/2866?locale=10) | 灼熱峽谷、塔納利斯、荒蕪之地、詛咒之地 |
| 紫蓮花 | Purple Lotus | 210 | [142140](https://nether.wowhead.com/forever/tooltip/object/142140?locale=10)、[180165](https://nether.wowhead.com/forever/tooltip/object/180165?locale=10) | 艾薩拉、辛特蘭、菲拉斯、塔納利斯、荊棘谷遺跡。180165 為祖爾格拉布資料列 |
| 阿薩斯之淚 | Arthas' Tears | 220 | [142141](https://nether.wowhead.com/forever/tooltip/object/142141?locale=10)、[176642](https://nether.wowhead.com/forever/tooltip/object/176642?locale=10) | 東瘟疫之地、西瘟疫之地、費伍德森林、剃刀高地。176642 在費伍德森林 |
| 太陽草 | Sungrass | 230 | [142142](https://nether.wowhead.com/forever/tooltip/object/142142?locale=10)、[176636](https://nether.wowhead.com/forever/tooltip/object/176636?locale=10)、[180164](https://nether.wowhead.com/forever/tooltip/object/180164?locale=10) | 菲拉斯、辛特蘭、艾薩拉、安戈洛環形山、東西瘟疫之地。176636 在費伍德森林，180164 為祖爾格拉布資料列 |
| 盲目草 | Blindweed | 235 | [142143](https://nether.wowhead.com/forever/tooltip/object/142143?locale=10) | 悲傷沼澤、安戈洛環形山、瑪拉頓 |
| 幽靈菇 | Ghost Mushroom | 245 | [142144](https://nether.wowhead.com/forever/tooltip/object/142144?locale=10) | 辛特蘭洞穴、淒涼之地、瑪拉頓、厄運之槌 |
| 格羅姆高之血 | Gromsblood | 250 | [142145](https://nether.wowhead.com/forever/tooltip/object/142145?locale=10)、[176637](https://nether.wowhead.com/forever/tooltip/object/176637?locale=10) | 費伍德森林、詛咒之地、淒涼之地、梣谷。176637 在費伍德森林 |
| 黃金蔘 | Golden Sansam | 260 | [176583](https://nether.wowhead.com/forever/tooltip/object/176583?locale=10)、[176638](https://nether.wowhead.com/forever/tooltip/object/176638?locale=10)、[180167](https://nether.wowhead.com/forever/tooltip/object/180167?locale=10) | 艾薩拉、安戈洛環形山、東瘟疫之地、費伍德森林、燃燒平原。176638 在費伍德森林，180167 為祖爾格拉布資料列 |
| 夢葉草 | Dreamfoil | 270 | [176584](https://nether.wowhead.com/forever/tooltip/object/176584?locale=10)、[176639](https://nether.wowhead.com/forever/tooltip/object/176639?locale=10)、[180168](https://nether.wowhead.com/forever/tooltip/object/180168?locale=10) | 艾薩拉、東西瘟疫之地、安戈洛環形山、費伍德森林、燃燒平原、希利蘇斯、海加爾山。176639 在費伍德森林，180168 為祖爾格拉布資料列 |
| 山鼠草 | Mountain Silversage | 280 | [176586](https://nether.wowhead.com/forever/tooltip/object/176586?locale=10)、[176640](https://nether.wowhead.com/forever/tooltip/object/176640?locale=10)、[180166](https://nether.wowhead.com/forever/tooltip/object/180166?locale=10) | 冬泉谷、東瘟疫之地、艾薩拉、安戈洛環形山、燃燒平原、海加爾山。176640 在費伍德森林，180166 為祖爾格拉布資料列 |
| 瘟疫花 | Plaguebloom | 285 | [176587](https://nether.wowhead.com/forever/tooltip/object/176587?locale=10)、[176641](https://nether.wowhead.com/forever/tooltip/object/176641?locale=10) | 東瘟疫之地、西瘟疫之地、費伍德森林。176641 在費伍德森林 |
| 冰蓋草 | Icecap | 290 | [176588](https://nether.wowhead.com/forever/tooltip/object/176588?locale=10) | 冬泉谷 |
| 黑蓮花 | Black Lotus | 300 | [176589](https://nether.wowhead.com/forever/tooltip/object/176589?locale=10) | 燃燒平原、希利蘇斯、冬泉谷、東瘟疫之地 |
| Demonsage | Demonsage | 300 | [566786](https://nether.wowhead.com/forever/tooltip/object/566786?locale=10) | 永恆新增，海加爾山。台服物件提示目前為英文，材料名「魔鼠草」，遊戲內物件名【需遊戲實測】 |

### 草藥名稱近似的其他物件與待實測

- 荊棘藻另有永恆物件 **618987**，台服資料站顯示英文 Stranglekelp 且列草藥學 85，無公開刷新地點。先保留待測 ID【需遊戲實測】。盲目草 **183046** 僅本機 QuestieDB 有記錄且無刷新點，永恆物件提示 404【需遊戲實測】。[荊棘藻物件](https://www.wowhead.com/forever/tw/object=618987/stranglekelp) · [技能提示](https://nether.wowhead.com/forever/tooltip/object/618987?locale=10)
- **墓穴草 694732**（提里斯法林地）、**Hyjal Silphium 654624**（海加爾山，任務物品譯名海加爾羅盤草）是任務目標。Wowhead 通用草藥提示寫 1。墓穴草實際客戶端快取鎖是 259／草藥類 0，並指向任務物品 286204。海加爾物件的實際鎖及台服滑鼠名【需遊戲實測】。同類含 **毒蛇花 13891**、**紫色水生菇 141853**、**陰暗草 175566**、**火焰龍舌蘭 175928**、**末日草 176753**，均應用任務分類。黑海岸的擱淺的海洋生物 **175207**、海龜骨頭 **176189** 同樣在 Wowhead 草藥索引，實際為任務物件。大河林地 **648994 Wildflower** 是聯盟任務 95975 的容器，玩家物件快取記 Lock 4395／法術 1309310 與任務物品 271823「野花」，台服物件名【需遊戲實測】。[墓穴草任務](https://www.wowhead.com/forever/tw/quest=99142/tomb-weed) · [海加爾任務](https://www.wowhead.com/forever/quest=96616/herbs-for-the-bruised-and-weary) · [海加爾物件](https://nether.wowhead.com/forever/tooltip/object/654624?locale=10) · [野花物件](https://nether.wowhead.com/forever/tooltip/object/648994?locale=10) · [野花任務](https://www.wowhead.com/forever/quest=95975/her-world)
- 探索賽季夢魘入侵資料也會出現在永恆 Wowhead。夢魘苔 **439557**（125，暮色森林）、**439627**（Dreamroot，205，梣谷，無確認台服名）、星蓮花 **439762**（250，辛特蘭）、月之根 **439810**（250，菲拉斯）的公開物件和技能提示存在。任務與配套物品屬探索賽季，永恆正式服一般地圖是否有該批點【需遊戲實測】，預設草點排除。[探索賽季夢魘入侵](https://www.wowhead.com/classic/guide/season-of-discovery/nightmare-incursions-overview) · [夢魘苔物品的版本提示](https://nether.wowhead.com/forever/tooltip/item/219399?locale=10)
- 永恆有同名的牛頭人「栽培」複製物件。玩家物件快取中確認使用 Lock 4522，指向 70938 法術 1312650「栽培」，沒有草藥技能門檻。已核 ID 為銀葉草 **657380**、寧神花 **657382、657456**、地根草 **657383、657458**、石南草 **657385、657460**、跌打草 **657386**、野鋼花 **657387**、皇血草 **657388**、活根草 **657390**、荊棘藻 **657394**、凋謝的寧神花 **657454**、貧弱的銀葉草 **657455**、魔皇草 **657459**。同屬容器提示的候選為墓地苔 **657389**、枯葉草 **657391**、卡德加的鬍鬚 **657392**、金棘草 **657397**、銀葉草 **657457**、跌打草 **657461**，個別鎖【需遊戲實測】。QuestieDB 的材料來源另引用 **657395、657399**，物件提示查不到【需遊戲實測】。[栽培法術](https://www.wowhead.com/forever/tw/spell=1312650) · [70938 Lock](https://wago.tools/db2/Lock/csv?build=1.60.1.70938) · [寧神花容器](https://nether.wowhead.com/forever/tooltip/object/657382?locale=10) · [金棘草容器](https://nether.wowhead.com/forever/tooltip/object/657397?locale=10)
- 草藥副產物用來源母點報音。雨燕草 **Item 2452** 隨魔皇草／石南草，野葡萄藤 **Item 8153** 隨紫蓮花。血藤 **Item 19726** 的經典對照是帶血鐮刀 **Item 19727** 從祖爾格拉布母點取得，永恆副本可用性【需遊戲實測】。褶邊地衣 **Item 249399**、玫瑰冠草 **Item 249424**、窒息藤蔓 **Item 249274** 屬稀少副產物。惡夢葉草 **Item 248823** 對應法術 1272737 的臨時召喚物件 **619109**，野外獨立點、物件名稱及門檻【需遊戲實測】。死亡蓮花 **Item 248822** 尚無可核對的獨立採集物件 ID／技能點【需遊戲實測】。附魔「蓮花利爪」已確認可在海加爾採草時低機率取得死亡蓮花。種子同為物品。以上 Item ID 不作 GameObject 比對。[草藥學採集表](https://www.wowhead.com/forever/guide/professions/herbalism/overview-leveling) · [經典祖爾格拉布血藤](https://www.wowhead.com/classic/guide/wow-classic-zulgurub-overview) · [永恆草藥材料表](https://www.wowhead.com/forever/items/trade-goods/herbs) · [惡夢葉草](https://nether.wowhead.com/forever/tooltip/item/248823?locale=10) · [惡夢葉草臨時物件法術](https://www.wowhead.com/forever/pt/spell=1272737/marefoil) · [蓮花利爪](https://nether.wowhead.com/forever/tooltip/item/274424?locale=10)
- 費伍德森林受腐化與淨化的輕歌花、鞭根草、夜龍草、迎風花是任務／互動物件。種植於營地的溫室則採種子及成品流程。均應與常態野外技能草點分開。[費伍德淨化物件示例](https://nether.wowhead.com/forever/tooltip/object/164882?locale=10) · [營地溫室與種子](https://www.method.gg/wow-forever/how-herb-seeds-work-in-wow-forever-herbalism-greenhouse-and-seed-hybridizer)

## NodeSight 的寶箱、任務物件與其他採集物

本機 NodeSight 為 **3.0.0**（介面版本 16001）。作者在 11 月 13 日版本公告確認小地圖掃描、遠距閃光、箭頭和小地圖音效已移除。近距離物件閃光、尋找草藥／礦物切換、滑鼠提示門檻和近距離閃光提示音仍有程式支援。這版要求互動偵測範圍 30 碼（預設 10），由遊戲提供的物件名牌和當前軟互動目標辨識。30 碼是設定值，地形、面向與遊戲是否提供可讀名牌／物件名稱都會影響觸發。物件 ID 表可用來辨識客戶端已提供的物件。【需遊戲實測】實際距離及戰鬥中可讀性。[NodeSight 3.0.0 公告](https://github.com/Krelock/NodeSight/releases/tag/v3.0.0) · [同版 Sparkles.lua](https://github.com/Krelock/NodeSight/blob/v3.0.0/Sparkles.lua) · [同版 Settings.lua](https://github.com/Krelock/NodeSight/blob/v3.0.0/Settings.lua)

NodeSight 有寶箱、任務物件、其他物件、浮標、剝皮等獨立選項，閃光預設關閉。寶箱依英文類型詞尾或繁中名稱對照辨識。任務物件可以由目前任務、互動圖示、物件 ID 或曾拾取的任務物品判定，因此同一寶箱可能先歸到任務物件。其他物件以遊戲互動圖示與名牌分類，個別物件是否閃光需到場確認。郵箱、椅子、門、公會銀行等一般互動圖示通常不觸發。近距離音效為遊戲提示聲，啟用後同名物件間隔 30 秒、任兩聲間隔至少 2 秒。魚群本身沒有專用判定，程式內的 35591 指玩家施釣產生的浮標，GUID 不可讀時可用釣魚引導作為備援。魚群是否會被當成「其他物件」出現在互動名牌【需遊戲實測】。[閃光分類與音效](https://github.com/Krelock/NodeSight/blob/v3.0.0/Sparkles.lua) · [寶箱名稱判定](https://github.com/Krelock/NodeSight/blob/v3.0.0/Names.lua) · [台服名稱對照](https://github.com/Krelock/NodeSight/blob/v3.0.0/Locales/zhTW.lua) · [任務物件 ID](https://github.com/Krelock/NodeSight/blob/v3.0.0/QuestObjects.lua)

下列 ID 是物件 ID，箱子與水池名稱以 Wowhead 永恆 zhTW 物件提示優先。若只驗到物件 ID 或名字但未實測該物件的閃光，就保留為可選類別；魚群、任務物件不預設進礦／草語音提示。

| 名稱 | GameObject ID | NodeSight 判定與來源 |
|---|---|---|
| 破損的箱子 | 2843, 2849, 106318, 106319 | 寶箱名稱已在 v3.0.0 繁中表。QuestieDB 另有無座標的 2844，永恆 Wowhead 無對應，【需遊戲實測】。[2849](https://nether.wowhead.com/forever/tooltip/object/2849?locale=10) · [106318](https://nether.wowhead.com/forever/tooltip/object/106318?locale=10) |
| 堅固的箱子 | 2850, 2852, 2855, 2857, 4149, 153451, 153453, 153454 | 寶箱名稱已在繁中表。[2850](https://nether.wowhead.com/forever/tooltip/object/2850?locale=10) · [153451](https://nether.wowhead.com/forever/tooltip/object/153451?locale=10) |
| 破碎的大箱子 | 75293 | 寶箱名稱已在繁中表。[75293](https://nether.wowhead.com/forever/tooltip/object/75293?locale=10) |
| 堅固的大箱子 | 75298, 75299, 75300, 153463, 153464 | 寶箱名稱已在繁中表。QuestieDB 的 74448 有副本記錄，永恆提示回傳英文，台服名【需遊戲實測】。無座標的 153462 也待實測。[75298](https://nether.wowhead.com/forever/tooltip/object/75298?locale=10) · [74448](https://nether.wowhead.com/forever/tooltip/object/74448?locale=10) |
| 大型鐵箍儲物箱 | 75295, 75296, 75297 | 寶箱名稱已在繁中表。QuestieDB 的 74447 有副本記錄，永恆提示回傳英文，台服名【需遊戲實測】。[75295](https://nether.wowhead.com/forever/tooltip/object/75295?locale=10) · [74447](https://nether.wowhead.com/forever/tooltip/object/74447?locale=10) |
| 大型祕銀儲物箱 | 131978, 153468, 153469 | 寶箱名稱已在繁中表。[131978](https://nether.wowhead.com/forever/tooltip/object/131978?locale=10) · [153469](https://nether.wowhead.com/forever/tooltip/object/153469?locale=10) |
| 凹陷的箱子 | 626718, 626752 | 微風島永恆物件，寶箱名稱已在繁中表。[626718](https://nether.wowhead.com/forever/tooltip/object/626718?locale=10) · [626752](https://nether.wowhead.com/forever/tooltip/object/626752?locale=10) |
| 本尼迪克的箱子 | 3239 | 杜洛塔任務箱，名字已在繁中表。[3239](https://nether.wowhead.com/forever/tooltip/object/3239?locale=10) |
| 沉沒的箱子 | 32 | 名字和任務 ID 都在 NodeSight 表。[32](https://nether.wowhead.com/forever/tooltip/object/32?locale=10) |
| 七賢之箱 | 169243 | 黑石深淵寶箱，繁中不在固定寶箱對照，閃光【需遊戲實測】。[169243](https://nether.wowhead.com/forever/tooltip/object/169243?locale=10) |
| 競技場財寶箱（Arena Treasure Chest） | 179697 | 繁中取 QuestieDB，永恆提示回傳英文，實際台服名稱及閃光【需遊戲實測】。[179697](https://nether.wowhead.com/forever/tooltip/object/179697?locale=10) |
| 血瓣花苗 | 164958 | 安戈洛容器，已在 NodeSight 任務物件表（9052）；完成任務或未接時的分類【需遊戲實測】。[164958](https://nether.wowhead.com/forever/tooltip/object/164958?locale=10) |
| 藍色／綠色／紅色／黃色能量水晶 | 164658, 164659, 164660, 164661 | 依顏色順序對應安戈洛採集物件。普通互動或任務物件實際閃光【需遊戲實測】。[164658](https://nether.wowhead.com/forever/tooltip/object/164658?locale=10) · [164661](https://nether.wowhead.com/forever/tooltip/object/164661?locale=10) |
| 貝殼陷阱 | 176582, 176635 | 淒涼之地容器，含任務與戰利品。閃光【需遊戲實測】。[176582](https://nether.wowhead.com/forever/tooltip/object/176582?locale=10) · [176635](https://nether.wowhead.com/forever/tooltip/object/176635?locale=10) |
| 巨型蚌殼 | 2744, 19017, 19018 | 水下容器。閃光【需遊戲實測】。[2744](https://nether.wowhead.com/forever/tooltip/object/2744?locale=10) · [19017](https://nether.wowhead.com/forever/tooltip/object/19017?locale=10) |
| Fresh Wreckage | 630533 | 大河林地永恆新任務互動物，台服名及閃光【需遊戲實測】。[物件](https://www.wowhead.com/forever/tw/object=630533/fresh-wreckage) · [任務 95267](https://forever-tool.com/en/quests/95267/) |
| 浮標（Fishing Bobber） | 35591 | NodeSight 直接辨識。台服名稱來自本機 1.60.1.70009 測試版 zhTW 物件快取，正式服提示【需遊戲實測】。[程式](https://github.com/Krelock/NodeSight/blob/v3.0.0/Sparkles.lua) |
| 魚群／可口魚魚群／變異魚魚群 | 180184／180248／180658 | 各類 ID 依順序對應，魚群閃光【需遊戲實測】。[180184](https://nether.wowhead.com/forever/tooltip/object/180184?locale=10) · [180248](https://nether.wowhead.com/forever/tooltip/object/180248?locale=10) · [180658](https://nether.wowhead.com/forever/tooltip/object/180658?locale=10) |
| 黑口魚魚群 | 180582, 180664, 180682, 180750, 180900 | 型別 25 見正式服互動紀錄，魚群閃光【需遊戲實測】。[180582](https://nether.wowhead.com/forever/tooltip/object/180582?locale=10) |
| 火鰭鯛魚群 | 180657, 180683, 180752, 180902 | 部分 ID 的型別 25 見正式服互動紀錄，魚群閃光【需遊戲實測】。[180657](https://nether.wowhead.com/forever/tooltip/object/180657?locale=10) |
| 鼠尾魚魚群／大型鼠尾魚魚群 | 180656, 180663／180684 | 魚群閃光【需遊戲實測】。[180656](https://nether.wowhead.com/forever/tooltip/object/180656?locale=10) · [180684](https://nether.wowhead.com/forever/tooltip/object/180684?locale=10) |
| 石鱗鰻魚群 | 180712 | 魚群閃光【需遊戲實測】。[180712](https://nether.wowhead.com/forever/tooltip/object/180712?locale=10) |
| 漂浮的碎片／漂浮的殘骸／漂浮殘骸 | 180655／180662／180685, 180751, 180901 | 三個台服提示名依序對應，屬釣魚水池。閃光【需遊戲實測】。[180655](https://nether.wowhead.com/forever/tooltip/object/180655?locale=10) · [180662](https://nether.wowhead.com/forever/tooltip/object/180662?locale=10) · [180685](https://nether.wowhead.com/forever/tooltip/object/180685?locale=10) |
| 元素之水／混濁的水 | 180753／180369 | 釣魚水池。閃光【需遊戲實測】。[180753](https://nether.wowhead.com/forever/tooltip/object/180753?locale=10) · [180369](https://nether.wowhead.com/forever/tooltip/object/180369?locale=10) |
| 墓穴草 | 694732 | 提里斯法林地巴尼爾農莊任務 99142 的物件。Wowhead 標草藥學 1，70938 Lock #259 的草藥欄為 0；互動紀錄有任務物品 286204，採集門檻及有無任務時的閃光【需遊戲實測】。[永恆物件](https://nether.wowhead.com/forever/tooltip/object/694732?locale=10) · [任務資料](https://zephras.com/forever/enUS/quest/99142/) · [原始物件欄位](https://github.com/JIVESCORP/eg-link-output-wowf/tree/main/data/wowf) · [Lock](https://wago.tools/db2/Lock/csv?build=1.60.1.70938) |
| School of Whimsyfin | 572928 | 新釣魚水池，永恆 Beta 1.60.1.70450 有互動型別 25 記錄；台服名稱、正式服出現與閃光【需遊戲實測】。[永恆物件](https://nether.wowhead.com/forever/tooltip/object/572928?locale=10) · [原始物件欄位](https://github.com/JIVESCORP/eg-link-output-wowf/tree/main/data/wowf) |
| 油井／礫石 | 180661／414658 | 永恆提示都標為釣魚水池，互動紀錄也是型別 25。礫石鎖欄為 0，油井為 4。實際用途及閃光【需遊戲實測】。[油井](https://nether.wowhead.com/forever/tooltip/object/180661?locale=10) · [礫石](https://nether.wowhead.com/forever/tooltip/object/414658?locale=10) · [原始物件欄位](https://github.com/JIVESCORP/eg-link-output-wowf/tree/main/data/wowf) |

軟泥覆蓋礦脈屬採礦物件。軟泥怪是 NPC，從怪物取得的軟泥袋是背包物品，沒有查到可獨立追蹤的通用「軟泥」採集點。[軟泥覆蓋的富瑟銀](https://nether.wowhead.com/forever/tooltip/object/177388?locale=10) · [滲漏的袋子（物品）](https://www.wowhead.com/forever/tw/item=20768)



淒涼之地的巨型軟殼蚌 **177784** 也是可開啟容器，實際閃光【需遊戲實測】。[永恆台服物件提示](https://nether.wowhead.com/forever/tooltip/object/177784?locale=10)

## 法術引用的臨時採集物件

70938 的 SpellEffect 效果 76 引用下列臨時召喚物件。名稱欄取法術的台服文字，物件滑鼠名稱、門檻與野外刷新【需遊戲實測】。這些 ID 供比對臨時生成樣本。619047、619059 各被兩種不同草藥法術引用，應等實際物件回報才定名。618987 的 Wowhead 提示已有草藥學 85，尚未核實獨立野外刷新。619109 的實際產出【需遊戲實測】。[70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938) · [70938 台服 SpellName](https://wago.tools/db2/SpellName/csv?build=1.60.1.70938&locale=zhTW) · [臨時召喚效果 76 示例](https://www.wowhead.com/forever/es/spell=1272737/marefoil) · [618987 物件提示](https://nether.wowhead.com/forever/tooltip/object/618987?locale=10)

| 法術名稱（台服資料） | 分類 | 法術 ID | 物件 ID | 技能點 |
|---|---|---|---:|---:|
| 銅礦脈 | 礦 | 1271688 | 618841 | ? |
| 錫礦脈 | 礦 | 1272212 | 618901 | ? |
| 銀礦脈 | 礦 | 1272213 | 618902 | ? |
| 鐵礦脈 | 礦 | 1272214 | 618904 | ? |
| 金礦脈 | 礦 | 1272215 | 618905 | ? |
| 秘銀礦脈 | 礦 | 1272216 | 618906 | ? |
| 真銀礦脈 | 礦 | 1272217 | 618908 | ? |
| 黑鐵礦脈 | 礦 | 1272218 | 618909 | ? |
| 瑟銀礦脈 | 礦 | 1272219 | 618910 | ? |
| 富瑟銀礦脈 | 礦 | 1272220 | 618912 | ? |
| 沉重瑟銀礦脈 | 礦 | 1272221 | 618913 | ? |
| 寧神花 | 草 | 1272224 | 618918 | ? |
| 銀葉草 | 草 | 1272274 | 618946 | ? |
| 地根草 | 草 | 1272275 | 618948 | ? |
| 魔皇草 | 草 | 1272340 | 618959 | ? |
| 石南草 | 草 | 1272343 | 618974 | ? |
| 荊棘藻 | 草 | 1272356 | 618987 | 85（物件提示） |
| 跌打草 | 草 | 1272367 | 618995 | ? |
| 野鋼花 | 草 | 1272368 | 618996 | ? |
| 墓地苔 | 草 | 1272369 | 618997 | ? |
| 皇血草 | 草 | 1272370 | 618999 | ? |
| 活根草 | 草 | 1272417 | 619005 | ? |
| 枯葉草 | 草 | 1272418 | 619006 | ? |
| 金棘草 | 草 | 1272419 | 619015 | ? |
| 卡德加的鬍鬚 | 草 | 1272420 | 619016 | ? |
| 冬刺草 | 草 | 1272436 | 619018 | ? |
| 火焰花 | 草 | 1272490 | 619040 | ? |
| 紫蓮花 | 草 | 1272492 | 619043 | ? |
| 幽靈菇 | 草 | 1272495 | 619046 | ? |
| 太陽草／黃金蔘 | 草 | 1272494、1272496 | 619047 | ? |
| 夢葉草 | 草 | 1272530 | 619058 | ? |
| 盲目草／山鼠草 | 草 | 1272529、1272531 | 619059 | ? |
| 格羅姆之血 | 草 | 1272532 | 619064 | ? |
| 黑蓮花 | 草 | 1272651 | 619097 | ? |
| 瘟疫花 | 草 | 1272655 | 619101 | ? |
| 阿薩斯之淚 | 草 | 1272660 | 619102 | ? |
| 冰蓋草 | 草 | 1272665 | 619105 | ? |
| 惡夢葉草 | 草 | 1272737 | 619109 | ? |

奇石園（Rock Garden）的生成法術 1279455／1279456／1279459 引用一般銅礦 1731、錫礦 1732、鐵礦床 1735，可沿用一般物件 ID。設施本體 654285 是法術 1307386 引用的物件，溫室本體 612087 由 1307248 引用，種植種子 1246989 引用 659886。另兩個內部 Spawn Herb 法術 1314197／1314205 引用 677487／677486。這些設施、種子和未定名物件的台服滑鼠提示及是否閃光【需遊戲實測】。[奇石園法術](https://www.wowhead.com/forever/spell=1307386/rock-garden) · [70938 SpellEffect](https://wago.tools/db2/SpellEffect/csv?build=1.60.1.70938) · [營地機制](https://www.wowhead.com/forever/guide/camping-overview-unlock-rewards)

## 遊戲內補驗清單

- 【需遊戲實測】海加爾山 **566779**、**566786** 的 zhTW 滑鼠物件名，以及 **654624** 的名稱與實際互動門檻。
- 【需遊戲實測】**618987** 是否有獨立野外刷新，及臨時召喚物件實際名稱、技能門檻與是否提供互動提示。團本物件等副本可進入後再測。
- 【需遊戲實測】用普通礦草、寶箱、任務容器和魚群各測一次。記下物件 ID、滑鼠名稱、距離、是否為軟互動目標、閃光和音效是否觸發，及有無戰鬥／任務條件。魚群與玩家浮標各記一筆。[NodeSight 偵測程式](https://github.com/Krelock/NodeSight/blob/v3.0.0/Sparkles.lua)
