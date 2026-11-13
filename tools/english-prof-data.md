# ShengProfession 永恆 enUS 名稱與位置查核

- 訓練師姓名與所在區域查到 **34／34**，查無 **0**。航點查到 **33／34**，查無 **1**（Annora 的副本內座標）。
- 採集路線區域查到 **41／41**（19 張不同地圖），查無 **0**。路線中的命名地標有 **65 個**可對到 1.60.1 客戶端資料，另有 **5 組**原文地標指涉待確認，重複出現在多條路線只計一次。
- 額外核對 `Trainers.lua` 的升階書與任務名稱，查到 **6／6**，查無 **0**。備註中另有 **3／3** 引導任務查到英文名。

版本為 WoW Forever 1.60.1.70938。區域及地標的英文用 enUS `Name_lang`／`AreaName_lang`，座標用 0–100。訓練師以本機 QuestieDB Forever 的英文欄及刷新點逐筆比對 Wowhead 永恆版。Wowhead 點位欄列與插件現值最接近的一筆採樣，兩個來源會因取樣有小幅差異。 `AreaID` 與 `uiMapID` 是不同欄位。 [UiMap enUS](https://wago.tools/db2/UiMap?build=1.60.1.70938&locale=enUS) · [AreaTable enUS](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=enUS) · [AreaTable zhTW](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=zhTW)

## 訓練師與升階 NPC

行號對應 `addon/ShengProfession/Trainers.lua`。`expert` 是 Expert（上限 225），`master` 是 Artisan（上限 300）。草藥、採礦、剝皮共用兩階的 NPC，每位只列一行。烹飪、急救、釣魚包含賣書及任務 NPC。 [永恆專業概覽](https://www.wowhead.com/forever/guide/professions/overview)

| Lua 行 | 專業／階段 | NPC 插件現名 | NPC enUS | NPC ID | 據點 zhTW → enUS | 地圖 enUS | 插件與 QuestieDB 航點 | Wowhead 最近點 x, y | 來源 |
|---:|---|---|---|---:|---|---|---|---|---|
| 10 | Alchemy / Expert | 赫伯特·哈爾希醫生 | Doctor Herbert Halsey | 4611 | 幽暗城 → Undercity | Undercity | `1458 47.77, 73.34` | `47.60, 73.00` | [NPC](https://www.wowhead.com/forever/npc=4611) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/4611?locale=0) |
| 13 | Alchemy / Artisan | 羅格瓦爾 | Rogvar | 1386 | 斯通納德 → Stonard | Swamp of Sorrows | `1435 48.53, 55.85` | `48.60, 55.60` | [NPC](https://www.wowhead.com/forever/npc=1386) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/1386?locale=0) |
| 15 | Alchemy / Artisan | Master Mycologist Shurome | Master Mycologist Shurome | 259585 | 翡翠聖地 → Emerald Sanctuary | Felwood | `1448 51.41, 82.01` | `51.40, 82.00` | [NPC](https://www.wowhead.com/forever/npc=259585) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/259585?locale=0) |
| 20 | Blacksmithing / Expert | 薩魯·鋼怒 | Saru Steelfury | 3355 | 奧格瑪 → Orgrimmar | Orgrimmar | `1454 82.35, 22.97` | `82.20, 23.00` | [NPC](https://www.wowhead.com/forever/npc=3355) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3355?locale=0) |
| 23 | Blacksmithing / Artisan | 布里克·基克拉夫 | Brikk Keencraft | 2836 | 藏寶海灣 → Booty Bay | Stranglethorn Vale | `1434 28.99, 75.56` | `29.00, 75.60` | [NPC](https://www.wowhead.com/forever/npc=2836) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/2836?locale=0) |
| 28 | Enchanting / Expert | 赫加斯 | Hgarth | 11074 | 烈日石居 → Sun Rock Retreat | Stonetalon Mountains | `1442 49.18, 57.18` | `49.20, 57.20` | [NPC](https://www.wowhead.com/forever/npc=11074) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/11074?locale=0) |
| 32 | Enchanting / Artisan | 安諾拉 | Annora | 11073 | 奧達曼副本 → Uldaman | Uldaman（副本） | 【需遊戲實測】 | 無圖釘 | [NPC](https://www.wowhead.com/forever/npc=11073) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/11073?locale=0) |
| 37 | Engineering / Expert | 羅克希克 | Roxxik | 11017 | 奧格瑪 → Orgrimmar | Orgrimmar | `1454 76.17, 25.17` | `76.00, 25.00` | [NPC](https://www.wowhead.com/forever/npc=11017) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/11017?locale=0) |
| 40 | Engineering / Artisan | 巴茲克·布拉斯溫 | Buzzek Bracketswing | 8736 | 加基森 → Gadgetzan | Tanaris | `1446 52.34, 27.72` | `52.20, 27.60` | [NPC](https://www.wowhead.com/forever/npc=8736) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/8736?locale=0) |
| 45 | Leatherworking / Expert | 猶納 | Una | 3007 | 雷霆崖 → Thunder Bluff | Thunder Bluff | `1456 41.50, 42.57` | `41.40, 42.60` | [NPC](https://www.wowhead.com/forever/npc=3007) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3007?locale=0) |
| 48 | Leatherworking / Artisan | 哈拉納·鐵皮 | Hahrana Ironhide | 11098 | 莫沙徹營地 → Camp Mojache | Feralas | `1444 74.36, 43.12` | `74.40, 43.00` | [NPC](https://www.wowhead.com/forever/npc=11098) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/11098?locale=0) |
| 53 | Tailoring / Expert | 喬瑟夫·格里高利 | Josef Gregorian | 4576 | 幽暗城 → Undercity | Undercity | `1458 70.76, 30.69` | `70.60, 30.60` | [NPC](https://www.wowhead.com/forever/npc=4576) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/4576?locale=0) |
| 56 | Tailoring / Artisan | 達瑞爾·斯塔克 | Daryl Stack | 2399 | 塔倫米爾 → Tarren Mill | Hillsbrad Foothills | `1424 63.75, 20.79` | `63.60, 20.80` | [NPC](https://www.wowhead.com/forever/npc=2399) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/2399?locale=0) |
| 62 | Herbalism / Expert / Artisan | 加迪 | Jandi | 3404 | 奧格瑪 → Orgrimmar | Orgrimmar | `1454 55.62, 39.46` | `55.60, 39.60` | [NPC](https://www.wowhead.com/forever/npc=3404) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3404?locale=0) |
| 63 | Herbalism / Expert / Artisan | 馬爾薩·奧列斯塔 | Martha Alliestar | 4614 | 幽暗城 → Undercity | Undercity | `1458 54.00, 49.55` | `54.20, 49.40` | [NPC](https://www.wowhead.com/forever/npc=4614) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/4614?locale=0) |
| 64 | Herbalism / Expert / Artisan | 克米恩·冰蹄 | Komin Winterhoof | 3013 | 雷霆崖 → Thunder Bluff | Thunder Bluff | `1456 49.95, 40.41` | `49.80, 39.80` | [NPC](https://www.wowhead.com/forever/npc=3013) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3013?locale=0) |
| 65 | Herbalism / Expert / Artisan | 法魯薩 | Faruza | 2114 | 布瑞爾 → Brill | Tirisfal Glades | `1420 59.79, 52.12` | `59.80, 52.00` | [NPC](https://www.wowhead.com/forever/npc=2114) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/2114?locale=0) |
| 66 | Herbalism / Expert / Artisan | 米什基 | Mishiki | 3185 | 森金村 → Sen'jin Village | Durotar | `1411 55.44, 75.08` | `55.40, 75.00` | [NPC](https://www.wowhead.com/forever/npc=3185) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3185?locale=0) |
| 71 | Mining / Expert / Artisan | 馬卡魯 | Makaru | 3357 | 奧格瑪 → Orgrimmar | Orgrimmar | `1454 73.12, 26.08` | `73.00, 26.40` | [NPC](https://www.wowhead.com/forever/npc=3357) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3357?locale=0) |
| 72 | Mining / Expert / Artisan | 布羅姆·基里安 | Brom Killian | 4598 | 幽暗城 → Undercity | Undercity | `1458 56.03, 37.45` | `56.00, 37.00` | [NPC](https://www.wowhead.com/forever/npc=4598) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/4598?locale=0) |
| 73 | Mining / Expert / Artisan | 布瑞克·石蹄 | Brek Stonehoof | 3001 | 雷霆崖 → Thunder Bluff | Thunder Bluff | `1456 34.37, 57.90` | `34.40, 57.60` | [NPC](https://www.wowhead.com/forever/npc=3001) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3001?locale=0) |
| 74 | Mining / Expert / Artisan | 克魯恩 | Krunn | 3175 | 剃刀嶺 → Razor Hill | Durotar | `1411 51.81, 40.88` | `51.80, 40.80` | [NPC](https://www.wowhead.com/forever/npc=3175) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3175?locale=0) |
| 75 | Mining / Expert / Artisan | 喬漢·弗徹 | Johan Focht | 3555 | 瑟伯切爾 → The Sepulcher | Silverpine Forest | `1421 43.41, 40.45` | `43.40, 40.40` | [NPC](https://www.wowhead.com/forever/npc=3555) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/3555?locale=0) |
| 80 | Skinning / Expert / Artisan | 蘇爾德 | Thuwd | 7088 | 奧格瑪 → Orgrimmar | Orgrimmar | `1454 63.36, 45.42` | `63.20, 45.60` | [NPC](https://www.wowhead.com/forever/npc=7088) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/7088?locale=0) |
| 81 | Skinning / Expert / Artisan | 基里安·哈根 | Killian Hagey | 7087 | 幽暗城 → Undercity | Undercity | `1458 70.16, 59.18` | `70.40, 59.20` | [NPC](https://www.wowhead.com/forever/npc=7087) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/7087?locale=0) |
| 82 | Skinning / Expert / Artisan | 莫蘭塔 | Mooranta | 7089 | 雷霆崖 → Thunder Bluff | Thunder Bluff | `1456 44.44, 43.15` | `44.60, 43.00` | [NPC](https://www.wowhead.com/forever/npc=7089) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/7089?locale=0) |
| 83 | Skinning / Expert / Artisan | 姚恩·深刺 | Yonn Deepcut | 6290 | 血蹄村 → Bloodhoof Village | Mulgore | `1412 44.97, 61.40` | `45.00, 61.40` | [NPC](https://www.wowhead.com/forever/npc=6290) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/6290?locale=0) |
| 84 | Skinning / Expert / Artisan | 庫雷格·石角 | Kulleg Stonehorn | 8144 | 莫沙徹營地 → Camp Mojache | Feralas | `1444 74.47, 43.04` | `74.40, 43.00` | [NPC](https://www.wowhead.com/forever/npc=8144) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/8144?locale=0) |
| 91 | Cooking / Expert | 烏蘭 | Wulan | 12033 | 葬影村 → Shadowprey Village | Desolace | `1443 26.17, 69.65` | `26.20, 69.80` | [NPC](https://www.wowhead.com/forever/npc=12033) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/12033?locale=0) |
| 96 | Cooking / Artisan | 迪爾格·奎克里弗 | Dirge Quikcleave | 8125 | 加基森 → Gadgetzan | Tanaris | `1446 52.63, 28.11` | `52.60, 28.00` | [NPC](https://www.wowhead.com/forever/npc=8125) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/8125?locale=0) |
| 102 | First Aid / Expert | 巴萊·洛克維 | Balai Lok'Wein | 13476 | 蕨牆村 → Brackenwall Village | Dustwallow Marsh | `1445 36.49, 30.36` | `36.40, 30.40` | [NPC](https://www.wowhead.com/forever/npc=13476) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/13476?locale=0) |
| 107 | First Aid / Artisan | 格里高利·維克托醫生 | Doctor Gregory Victor | 12920 | 落錘鎮 → Hammerfall | Arathi Highlands | `1417 73.41, 36.89` | `73.40, 36.80` | [NPC](https://www.wowhead.com/forever/npc=12920) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/12920?locale=0) |
| 112 | Fishing / Expert | 老人海明威 | Old Man Heming | 2626 | 藏寶海灣 → Booty Bay | Stranglethorn Vale | `1434 27.42, 77.16` | `27.40, 77.00` | [NPC](https://www.wowhead.com/forever/npc=2626) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/2626?locale=0) |
| 117 | Fishing / Artisan | 納特·帕格 | Nat Pagle | 12919 | 狂潮灣小島 → Tidefury Cove (islet) | Dustwallow Marsh | `1445 58.61, 60.06` | `58.60, 60.00` | [NPC](https://www.wowhead.com/forever/npc=12919) · [圖釘 JSON](https://nether.wowhead.com/forever/tooltip/npc/12919?locale=0) |

### 位置備註

- 目前 `Trainers.lua` 的 34 個 `name_enUS` 都與核對值一致。地點欄有兩處採描述性寫法：Annora 用 `Uldaman (dungeon)`，客戶端地名為 `Uldaman`；Nat Pagle 用 `Dustwallow Marsh island`，具名海灣為 `Tidefury Cove`，小島本身無已核實的獨立名稱。 [永恆 AreaTable enUS](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=enUS) · [Nat Pagle 航點](https://nether.wowhead.com/forever/tooltip/npc/12919?locale=0)
- **Annora（11073）** 在 Uldaman 的 Map Chamber 與 Temple Hall 之間。清掉洞中的蠍群後她才會現身。Wowhead 的 AreaID 1337 沒有座標圖釘，本機 QuestieDB 的 `-1, -1` 是未提供座標。副本 `uiMapID`、樓層、點位【需遊戲實測】。 [Annora](https://www.wowhead.com/forever/npc=11073/annora) · [永恆奧達曼攻略](https://www.wowhead.com/forever/guide/uldaman-dungeon-overview-location-rewards)
- **Master Mycologist Shurome（259585）** 是費伍德森林 Emerald Sanctuary 的永恆新 NPC。Wowhead 的 `51.4, 82.0` 對得上現行航點。QuestieDB 還收了 `51.00, 83.09`，維持 Lua 現有的點位。 [Wowhead 永恆圖釘](https://nether.wowhead.com/forever/tooltip/npc/259585?locale=0)
- **Dirge Quikcleave（8125）** 在 Lua 的中文為「迪爾格·奎克里弗」。英文以 NPC ID 核對，本機英文及 Wowhead 均為 **Dirge Quikcleave**。 [Wowhead 英文](https://nether.wowhead.com/forever/tooltip/npc/8125?locale=0)

### 副專業升階資料

| 種類 | ID | Lua 中文 | enUS | 來源 |
|---|---:|---|---|---|
| 技能書 | 16072 | 高級烹飪教材 | Expert Cookbook | [永恆 enUS](https://www.wowhead.com/forever/item=16072) |
| 技能書 | 16084 | 高級急救教材 - 繃帶縛體 | Expert First Aid - Under Wraps | [永恆 enUS](https://www.wowhead.com/forever/item=16084) |
| 技能書 | 16083 | 高級釣魚教材 - 鱸魚與你 | Expert Fishing - The Bass and You | [永恆 enUS](https://www.wowhead.com/forever/item=16083) |
| 升階任務 | 6610 | 蚌肉大餐 | Clamlette Surprise | [永恆 enUS](https://www.wowhead.com/forever/quest=6610) |
| 升階任務 | 6622 | 救死扶傷 | Triage | [永恆 enUS](https://www.wowhead.com/forever/quest=6622) |
| 升階任務 | 6607 | 釣魚專家納特·帕格 | Nat Pagle, Angler Extreme | [永恆 enUS](https://www.wowhead.com/forever/quest=6607) |
| 引導任務 | 6611 | 加基森之旅！ | To Gadgetzan You Go! | [永恆 enUS](https://www.wowhead.com/forever/quest=6611) |
| 引導任務 | 6623 | 部落醫療隊 | Horde Trauma | [永恆 enUS](https://www.wowhead.com/forever/quest=6623) |
| 引導任務 | 6608 | 你真棒！ | You Too Good. | [永恆 enUS](https://www.wowhead.com/forever/quest=6608) |

## 採集路線

區域與 uiMapID 已逐條和 `tools/verify-gather-routes.md` 核對。英文路線標題是供插件顯示的描述，表中的「地標 enUS」才是 1.60.1 客戶端名稱。地標可包含原路線要避開的危險點。「方向描述」可用於英文說明，表達原路線所指地形，座標串請沿用原報告。

| 代號 | 原路線標題 | 建議英文路線標題 | 區域 enUS、uiMapID | 地標 enUS | 方向描述 | 來源 |
|---|---|---|---|---|---|---|
| M01 | 杜洛塔北段山腳與剃刀嶺 | Durotar — Northern Foothills and Razor Hill | Durotar `1411` | Razor Hill、Orgrimmar、Thunder Ridge、Tiragarde Keep | valley mouth outside Orgrimmar’s south gate; cave at Thunder Ridge | [永恆區域圖](https://www.wowhead.com/forever/zone=14) |
| M02 | 提里斯法林地布瑞爾西北外圈 | Tirisfal Glades — Northwest Brill Loop | Tirisfal Glades `1420` | Brill、Scarlet Monastery、Agamand Mills | — | [永恆區域圖](https://www.wowhead.com/forever/zone=85) |
| M03 | 希爾斯布萊德塔倫米爾東北坡 | Hillsbrad Foothills — Northeast Tarren Mill Slopes | Hillsbrad Foothills `1424` | Tarren Mill、Durnholde Keep | hills north of Durnholde Keep | [永恆區域圖](https://www.wowhead.com/forever/zone=267) |
| M04 | 貧瘠之地南段山腳 | The Barrens — Southern Foothills Loop | The Barrens `1413` | Camp Taurajo、Razorfen Kraul、Razorfen Downs | foothills north of the Razorfen dungeon entrances | [永恆區域圖](https://www.wowhead.com/forever/zone=17) |
| M05 | 阿拉希高地落錘鎮與外坡 | Arathi Highlands — Hammerfall and the Outer Slopes | Arathi Highlands `1417` | Hammerfall、Refuge Pointe、Stromgarde Keep | elemental camps to the south | [永恆區域圖](https://www.wowhead.com/forever/zone=45) |
| M06 | 千針石林谷底 | Thousand Needles — Valley Floor Loop | Thousand Needles `1441` | Freewind Post、The Great Lift | — | [永恆區域圖](https://www.wowhead.com/forever/zone=400) |
| M07 | 辛特蘭中央山坡 | The Hinterlands — Central Hillsides | The Hinterlands `1425` | Revantusk Village、Aerie Peak、Seradane、Jintha'Alor | Ghost Mushroom cave entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=47) |
| M08 | 荒蕪之地卡加斯外圈 | Badlands — Outer Kargath Loop | Badlands `1418` | Kargath、Uldaman、Lethlor Ravine | Uldaman excavation site and cave mouth | [永恆區域圖](https://www.wowhead.com/forever/zone=3) |
| M09 | 安戈洛環形山外緣 | Un'Goro Crater — Outer Rim Loop | Un'Goro Crater `1449` | Marshal's Refuge、Tanaris、Fire Plume Ridge、The Slithering Scar、Fungal Rock | southern silithid hive at The Slithering Scar and northern gorilla cave at Fungal Rock | [永恆區域圖](https://www.wowhead.com/forever/zone=490) |
| M10 | 費伍德森林路廊與山腳 | Felwood — Road and Foothills Loop | Felwood `1448` | Bloodvenom Post、Jaedenar、Shadow Hold、Timbermaw Hold | — | [永恆區域圖](https://www.wowhead.com/forever/zone=361) |
| M11 | 冬泉谷永望鎮北圈 | Winterspring — Northern Everlook Loop | Winterspring `1452` | Everlook、Frostwhisper Gorge、Darkwhisper Gorge、Lake Kel'Theril | lakeshore of Lake Kel'Theril and nearby mine | [永恆區域圖](https://www.wowhead.com/forever/zone=618) |
| M12 | 東瘟疫之地中北圈 | Eastern Plaguelands — North-Central Loop | Eastern Plaguelands `1423` | Light's Hope Chapel、Tyr's Hand、Plaguewood、Stratholme | Stratholme entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=139) |
| M13 | 燃燒平原烈焰峰與谷地 | Burning Steppes — Flame Crest and the Valley | Burning Steppes `1428` | Flame Crest、Morgan's Vigil、Blackrock Mountain、Dreadmaul Rock | Blackrock Mountain entrance and the caves at Dreadmaul Rock | [永恆區域圖](https://www.wowhead.com/forever/zone=46) |
| H01 | 杜洛塔西坡短圈 | Durotar — Short Western Slope Loop | Durotar `1411` | Razor Hill、Southfury River | — | [永恆區域圖](https://www.wowhead.com/forever/zone=14) |
| H02 | 提里斯法林地布瑞爾西側 | Tirisfal Glades — West of Brill | Tirisfal Glades `1420` | Brill、Agamand Mills | — | [永恆區域圖](https://www.wowhead.com/forever/zone=85) |
| H03 | 銀松森林瑟伯切爾南段 | Silverpine Forest — South of The Sepulcher | Silverpine Forest `1421` | The Sepulcher、Pyrewood Village、Ambermill | mine entrance near (60, 72) | [永恆區域圖](https://www.wowhead.com/forever/zone=130) |
| H04 | 貧瘠之地十字路口北緣 | The Barrens — Northern Crossroads Loop | The Barrens `1413` | The Crossroads、The Forgotten Pools、The Sludge Fen | dry ravine north of The Crossroads | [永恆區域圖](https://www.wowhead.com/forever/zone=17) |
| H05 | 希爾斯布萊德敦霍爾德外圈 | Hillsbrad Foothills — Outer Durnholde Loop | Hillsbrad Foothills `1424` | Tarren Mill、Durnholde Keep、Dun Garok、Southshore | — | [永恆區域圖](https://www.wowhead.com/forever/zone=267) |
| H06 | 石爪山脈東南入口短圈 | Stonetalon Mountains — Short Southeast Entrance Loop | Stonetalon Mountains `1442` | The Barrens、Hillsbrad Foothills | southeast entrance from The Barrens | [永恆區域圖](https://www.wowhead.com/forever/zone=406) |
| H07 | 阿拉希高地落錘鎮南北環 | Arathi Highlands — North–South Hammerfall Loop | Arathi Highlands `1417` | Hammerfall、Refuge Pointe、Stromgarde Keep | farm compounds and troll caves to the southeast | [永恆區域圖](https://www.wowhead.com/forever/zone=45) |
| H08 | 塵泥沼澤蕨牆村北圈 | Dustwallow Marsh — North of Brackenwall Village | Dustwallow Marsh `1445` | Brackenwall Village、Theramore Isle、Alcaz Island | causeway between (42, 32) and (47, 42) | [永恆區域圖](https://www.wowhead.com/forever/zone=15) |
| H09 | 塔納利斯沙地與遺跡 | Tanaris — Desert and Ruins Loop | Tanaris `1446` | Gadgetzan、Zul'Farrak | Gadgetzan’s south gate, pirate camp, and southern silithid hive | [永恆區域圖](https://www.wowhead.com/forever/zone=440) |
| H10 | 灼熱峽谷東西地表 | Searing Gorge — East–West Surface Loop | Searing Gorge `1427` | Thorium Point、The Slag Pit、Blackrock Mountain | — | [永恆區域圖](https://www.wowhead.com/forever/zone=51) |
| H11 | 辛特蘭中央太陽草圈 | The Hinterlands — Central Sungrass Loop | The Hinterlands `1425` | Revantusk Village、Aerie Peak、Seradane、Jintha'Alor | Ghost Mushroom cave entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=47) |
| H12 | 費伍德森林低門檻草圈 | Felwood — Entry-Level Herbalism Loop | Felwood `1448` | Bloodvenom Post、Jaedenar、Shadow Hold、Timbermaw Hold | — | [永恆區域圖](https://www.wowhead.com/forever/zone=361) |
| H13 | 費伍德森林高階草圈 | Felwood — High-Skill Herbalism Loop | Felwood `1448` | Bloodvenom Post、Jaedenar、Shadow Hold、Timbermaw Hold | — | [永恆區域圖](https://www.wowhead.com/forever/zone=361) |
| H14 | 東瘟疫之地夢葉草與瘟疫花圈 | Eastern Plaguelands — Dreamfoil and Plaguebloom Loop | Eastern Plaguelands `1423` | Light's Hope Chapel、Tyr's Hand、Plaguewood、Stratholme | Stratholme entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=139) |
| H15 | 冬泉谷冰湖草圈 | Winterspring — Lake Kel'Theril Loop | Winterspring `1452` | Everlook、Frostwhisper Gorge、Darkwhisper Gorge、Lake Kel'Theril | lakeshore of Lake Kel'Theril and nearby mine | [永恆區域圖](https://www.wowhead.com/forever/zone=618) |
| D01 | 杜洛塔剃刀嶺北面雙採 | Durotar — North of Razor Hill | Durotar `1411` | Razor Hill、Orgrimmar、Thunder Ridge、Tiragarde Keep | cave at Thunder Ridge | [永恆區域圖](https://www.wowhead.com/forever/zone=14) |
| D02 | 微風島西側雙採 | Zephras Isle — West Side Loop | Zephras Isle `2521` | Windsong Lake | western settlement and the path along the western shore of Windsong Lake | [永恆區域圖](https://www.wowhead.com/forever/zone=16593) · [任務 93737](https://www.wowhead.com/forever/quest=93737) |
| D03 | 貧瘠之地十字路口北段雙採 | The Barrens — North of The Crossroads | The Barrens `1413` | The Crossroads、The Forgotten Pools、The Sludge Fen | dry ravine north of The Crossroads | [永恆區域圖](https://www.wowhead.com/forever/zone=17) |
| D04 | 銀松森林南段雙採 | Silverpine Forest — Southern Loop | Silverpine Forest `1421` | The Sepulcher、Pyrewood Village、Ambermill | mine entrance near (60, 72) | [永恆區域圖](https://www.wowhead.com/forever/zone=130) |
| D05 | 希爾斯布萊德東側雙採 | Hillsbrad Foothills — Eastern Loop | Hillsbrad Foothills `1424` | Tarren Mill、Durnholde Keep、Dun Garok、Southshore | — | [永恆區域圖](https://www.wowhead.com/forever/zone=267) |
| D06 | 阿拉希高地落錘鎮外圈雙採 | Arathi Highlands — Outer Hammerfall Loop | Arathi Highlands `1417` | Hammerfall、Refuge Pointe、Stromgarde Keep | mine and troll caves to the southeast | [永恆區域圖](https://www.wowhead.com/forever/zone=45) |
| D07 | 荒蕪之地卡加斯外圈雙採 | Badlands — Outer Kargath Loop | Badlands `1418` | Kargath、Uldaman、Lethlor Ravine | Uldaman excavation site and cave mouth | [永恆區域圖](https://www.wowhead.com/forever/zone=3) |
| D08 | 塔納利斯加基森外圍雙採 | Tanaris — Outer Gadgetzan Loop | Tanaris `1446` | Gadgetzan | Gadgetzan’s south gate, troll fortifications, and southern silithid hive | [永恆區域圖](https://www.wowhead.com/forever/zone=440) |
| D09 | 辛特蘭中央雙採 | The Hinterlands — Central Loop | The Hinterlands `1425` | Revantusk Village、Aerie Peak、Seradane、Jintha'Alor | Ghost Mushroom cave entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=47) |
| D10 | 費伍德森林山腳雙採 | Felwood — Foothills Loop | Felwood `1448` | Bloodvenom Post、Jaedenar、Shadow Hold、Timbermaw Hold | — | [永恆區域圖](https://www.wowhead.com/forever/zone=361) |
| D11 | 東瘟疫之地中北圈雙採 | Eastern Plaguelands — North-Central Loop | Eastern Plaguelands `1423` | Light's Hope Chapel、Tyr's Hand、Plaguewood、Stratholme | Stratholme entrance | [永恆區域圖](https://www.wowhead.com/forever/zone=139) |
| D12 | 冬泉谷永望鎮外圍雙採 | Winterspring — Outer Everlook Loop | Winterspring `1452` | Everlook、Frostwhisper Gorge、Darkwhisper Gorge、Lake Kel'Theril | lakeshore of Lake Kel'Theril and nearby mine | [永恆區域圖](https://www.wowhead.com/forever/zone=618) |
| D13 | 安戈洛環形山外緣雙採 | Un'Goro Crater — Outer Rim Loop | Un'Goro Crater `1449` | Marshal's Refuge、Tanaris、Fire Plume Ridge、The Slithering Scar、Fungal Rock | southern silithid hive at The Slithering Scar and northern gorilla cave at Fungal Rock | [永恆區域圖](https://www.wowhead.com/forever/zone=490) |

### 地標詞彙

此表以 1.60.1 的 `AreaTable.ID` 為索引。列出 41 條路線用到的命名地標，可對照台服拼法。 [AreaTable enUS](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=enUS) · [AreaTable zhTW](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=zhTW)

| AreaID | 客戶端 zhTW | 客戶端 enUS |
|---:|---|---|
| 17 | 貧瘠之地 | The Barrens |
| 157 | 阿加曼德磨坊 | Agamand Mills |
| 159 | 布瑞爾 | Brill |
| 204 | 焚木村 | Pyrewood Village |
| 228 | 瑟伯切爾 | The Sepulcher |
| 233 | 安伯米爾 | Ambermill |
| 249 | 巨槌石 | Dreadmaul Rock |
| 251 | 烈焰峰 | Flame Crest |
| 254 | 黑石山 | Blackrock Mountain |
| 267 | 希爾斯布萊德丘陵 | Hillsbrad Foothills |
| 271 | 南海鎮 | Southshore |
| 272 | 塔倫米爾 | Tarren Mill |
| 275 | 敦霍爾德城堡 | Durnholde Keep |
| 290 | 丹加洛克 | Dun Garok |
| 320 | 避難谷地 | Refuge Pointe |
| 321 | 落錘鎮 | Hammerfall |
| 324 | 激流堡 | Stromgarde Keep |
| 339 | 萊瑟羅峽谷 | Lethlor Ravine |
| 340 | 卡加斯 | Kargath |
| 348 | 鷹巢山 | Aerie Peak |
| 354 | 辛薩羅 | Jintha'Alor |
| 356 | 瑟拉丹 | Seradane |
| 362 | 剃刀嶺 | Razor Hill |
| 369 | 雷霆山 | Thunder Ridge |
| 372 | 提拉加德城堡 | Tiragarde Keep |
| 378 | 陶拉祖營地 | Camp Taurajo |
| 380 | 十字路口 | The Crossroads |
| 382 | 淤泥沼澤 | The Sludge Fen |
| 386 | 遺忘之池 | The Forgotten Pools |
| 440 | 塔納利斯 | Tanaris |
| 484 | 亂風崗 | Freewind Post |
| 485 | 升降梯 | The Great Lift |
| 496 | 蕨牆村 | Brackenwall Village |
| 513 | 塞拉摩島 | Theramore Isle |
| 537 | 火羽山 | Fire Plume Ridge |
| 540 | 巨痕谷 | The Slithering Scar |
| 541 | 馬紹爾營地 | Marshal's Refuge |
| 542 | 蘑菇石 | Fungal Rock |
| 796 | 血色修道院 | Scarlet Monastery |
| 814 | 怒水河 | Southfury River |
| 976 | 加基森 | Gadgetzan |
| 978 | 祖爾法拉克 | Zul'Farrak |
| 1316 | 剃刀高地 | Razorfen Downs |
| 1443 | 熔渣之池 | The Slag Pit |
| 1445 | 黑石山 | Blackrock Mountain |
| 1446 | 瑟銀哨塔 | Thorium Point |
| 1517 | 奧達曼 | Uldaman |
| 1637 | 奧格瑪 | Orgrimmar |
| 1717 | 剃刀沼澤 | Razorfen Kraul |
| 1763 | 加德納爾 | Jaedenar |
| 1769 | 木喉要塞 | Timbermaw Hold |
| 1770 | 暗影堡 | Shadow Hold |
| 1997 | 血毒崗哨 | Bloodvenom Post |
| 2079 | 奧卡茲島 | Alcaz Island |
| 2249 | 霜語峽谷 | Frostwhisper Gorge |
| 2251 | 凱斯利爾湖 | Lake Kel'Theril |
| 2255 | 永望鎮 | Everlook |
| 2256 | 暗語峽谷 | Darkwhisper Gorge |
| 2266 | 提爾之手 | Tyr's Hand |
| 2268 | 聖光之願禮拜堂 | Light's Hope Chapel |
| 2277 | 病木林 | Plaguewood |
| 2279 | 斯坦索姆 | Stratholme |
| 2418 | 摩根的崗哨 | Morgan's Vigil |
| 3317 | 惡齒村 | Revantusk Village |
| 16625 | 風歌湖 | Windsong Lake |

地形比對補充

- M04 最南的折點約 (47, 85)，兩個剃刀副本入口在其南方，方向描述可用複數 Razorfen dungeon entrances。 [永恆貧瘠之地地圖](https://undying.app/zones/the-barrens)
- M09／D13 的北端猩猩洞對應 Fungal Rock（約 64, 16），南側蟲巢對應 The Slithering Scar（約 52, 80）。 [永恆安戈洛地圖](https://undying.app/zones/ungoro-crater)

### 待確認的地標

| 路線 | 原路線描述 | 查核結果 |
|---|---|---|
| H03、D04 | 銀松森林 (60, 72) 礦洞 | 【需遊戲實測】永恆地圖的 Deep Elem Mine（AreaID 213）約在 (55.2, 51.4)，與原路線位置不符。(60, 72) 附近的洞口名稱待現場確認。 [永恆銀松森林地圖](https://senseos.gg/wiki/wow-forever/interactive-map/?map=1421&x=53.9&y=51.9) |
| H04、D03 | 十字路口以北的乾谷 | 【需遊戲實測】The Dry Hills（AreaID 383，無水嶺）約 (40, 15)，在路線西北。路線也經 Dreadmist Peak 一帶，原文沒有標出是哪段。Drygulch Ravine（AreaID 370）屬杜洛塔。 [永恆貧瘠之地地圖](https://undying.app/zones/the-barrens) · [AreaTable](https://wago.tools/db2/AreaTable?build=1.60.1.70938&locale=enUS) |
| M07、H11、D09 | 辛特蘭幽靈菇洞口 | 【需遊戲實測】路線沒有給洞口名或座標，保留 Ghost Mushroom cave entrance。 [The Hinterlands](https://www.wowhead.com/forever/zone=47) |
| M11、H15、D12 | 冬泉谷冰湖礦洞 | 【需遊戲實測】路線 (52, 45)→(50, 43) 經 Lake Kel'Theril（AreaID 2251）附近。湖已定位，礦洞名稱與入口待確認。 [永恆冬泉谷地圖](https://senseos.gg/wiki/wow-forever/interactive-map/winterspring/) |
| D02 | 微風島西側聚落 | 【需遊戲實測】Shen’dar Village（AreaID 16624）在第一個折點東南，可當附近地標。原文未指定名稱，待確認是否由該村出發。 [Welcome to Shen’dar Village](https://www.wowhead.com/forever/quest=92514) · [村內訓練師點位](https://nether.wowhead.com/forever/tooltip/npc/257021?locale=0) |

微風島 D02 的湖西步道可用 **Windsong Lake**。AreaTable 16625 對到「風歌湖」，永恆任務 The Broken Construct 指名該湖，任務物件也出現在路線向湖岸轉折的區域。原報告的 `46,54` 轉折仍需遊戲實測。 [區域圖](https://www.wowhead.com/forever/zone=16593) · [任務](https://www.wowhead.com/forever/quest=93737) · [湖內物件](https://wowamobi.com/quests/93737)
