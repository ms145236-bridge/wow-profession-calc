# 永恆 1.60.1 聯盟專業訓練師

查核版本為 **1.60.1.70938**，格式比照 `tools/verify-prof-trainers.md`（部落）。插件欄位沿用「專家 225／大師 300」，台服遊戲文字對應「高級（Expert）／專家級（Artisan）」。座標用 `uiMapID x, y`，0–100 比例。費用是基礎價，角色等級與技能門檻和部落相同。[暴雪台服專業階級](https://worldofwarcraft.blizzard.com/zh-tw/news/24301516) · [永恆版專業總覽](https://www.wowhead.com/forever/tw/guide/professions/overview)

NPC 名稱優先用 Wowhead 永恆版 zhTW 提示，座標用本機 QuestieDB Forever 的刷新點（`friendlyToFaction` 為 A 或 AH）。階段對照 Wowhead 永恆版各專業總覽的訓練師表，以及 wow-professions 永恆版訓練師頁的 Expert／Artisan 分區。NPC 頭銜跟部落一樣錯一階：頭銜「Artisan」的教到專家，頭銜「Master」的教到大師。其他語言的名字比對 Wowhead 各語系提示與 QuestieDB l10n，地點用 70938 AreaTable 各語系官方名，和英文相同的不列。[QuestieDB](https://github.com/Questie/QuestieDB) · [AreaTable](https://wago.tools/db2/AreaTable?build=1.60.1.70938)

中立點兩邊共用部落表同一筆：鍛造大師布里克（藏寶海灣）、附魔大師安諾拉（奧達曼）、工程大師巴茲克（加基森）、鍊金大師 Shurome（翡翠聖地）、釣魚專家老人海明威（藏寶海灣）、烹飪大師迪爾格（加基森）、釣魚大師納特·帕格（狂潮灣小島）。烹飪、急救的專家書與部落是同一本，書名直接沿用。

## ShengProfession 精簡表

| 專業 | 階段（專家/大師） | 條件 | 聯盟訓練師（名稱、地圖ID、x、y） | 備註 |
|---|---|---|---|---|
| 鍊金術 | 專家 | 角色 20 級，技能 125，50 銀 | 安尼希爾（1457 54.88, 24.02）／琳西‧黑栓（1416 18.53, 62.43） | 達納蘇斯工匠區／達拉然，達拉然進入條件【需遊戲實測】 |
| 鍊金術 | 大師 | 角色 35 級，技能 200，5 金 | 凱蘭娜·風語（1444 32.62, 43.78）／Master Mycologist Shurome（1448 51.41, 82.01） | 羽月要塞／翡翠聖地（共用），Shurome 台服名【需遊戲實測】 |
| 鍛造 | 專家 | 角色 20 級，技能 125，50 銀 | 本古斯·深爐（1455 52.55, 41.46） | 鐵爐堡大熔爐 |
| 鍛造 | 大師 | 角色 35 級，技能 200，5 金 | 布里克·基克拉夫（1434 28.99, 75.56） | 藏寶海灣（共用） |
| 附魔 | 專家 | 角色 20 級，技能 125，50 銀 | 基塔·費溫德（1429 64.93, 70.71） | 艾爾文森林阿祖拉之塔頂層 |
| 附魔 | 大師 | 角色 35 級，技能 200，5 金 | 安諾拉（奧達曼副本，座標 ?） | 共用，副本地圖定位【需遊戲實測】 |
| 工程學 | 專家 | 角色 20 級，技能 125，50 銀 | 賓斯匹德（1455 68.46, 43.54） | 鐵爐堡地精區 |
| 工程學 | 大師 | 角色 35 級，技能 200，5 金 | 巴茲克·布拉斯溫（1446 52.34, 27.72） | 加基森（共用） |
| 草藥學 | 專家／大師 | 技能 125／200，50 銀／5 金 | 塔尼莎（1453 54.29, 84.10）／雷納·石枝（1455 55.90, 59.13）／菲羅迪恩·喚月（1457 47.95, 68.03）／卡利（1432 36.47, 48.54）／泰倫瑞諾·月影（1437 7.99, 55.84） | 三主城＋塞爾薩瑪、米奈希爾港，兩階同一位 |
| 製皮 | 專家 | 角色 20 級，技能 125，50 銀 | 泰龍尼斯（1457 64.43, 21.54） | 達納蘇斯工匠區二樓 |
| 製皮 | 大師 | 角色 35 級，技能 200，5 金 | 德拉克·石拳（1425 13.39, 43.49） | 辛特蘭鷹巢山 |
| 採礦 | 專家／大師 | 技能 125／200，50 銀／5 金 | 吉爾曼·石手（1453 59.25, 37.83）／吉爾弗拉姆·石趾（1455 50.00, 26.29）／庫德拉姆·石錘（1439 38.25, 41.01）／布洛克·尋石者（1432 37.02, 47.81）／瑪特·約翰森（1431 74.05, 49.62） | 暴風城、鐵爐堡＋奧伯丁、塞爾薩瑪、夜色鎮；達納蘇斯沒有採礦訓練師 |
| 剝皮 | 專家／大師 | 技能 125／200，50 銀／5 金 | 馬瑞斯·格蘭治（1453 72.14, 62.21）／巴爾薩斯·裂石（1455 39.86, 32.50）／艾拉迪爾（1457 64.14, 22.26）／海倫尼·派特斯金納（1429 46.24, 62.24）／傑拉（1440 49.98, 67.29） | 三主城＋閃金鎮、銀風避難所 |
| 裁縫 | 專家 | 角色 20 級，技能 125，50 銀 | 喬吉奧·波利羅（1453 53.08, 81.35） | 暴風城法師區 |
| 裁縫 | 大師 | 角色 35 級，技能 200，5 金 | 提莫斯·沃森特（1445 66.18, 51.81） | 塞拉摩島，下船後左手第一棟二樓 |
| 烹飪 | 專家 | 技能 125，1 金，書無等級欄 | 珊蒂瑞亞（1440 49.48, 67.09） | 梣谷銀風避難所買書 16072，20 級以下使用【需遊戲實測】 |
| 烹飪 | 大師 | 角色 35 級，技能 225，0 金 | 迪爾格·奎克里弗（1446 52.63, 28.11） | 加基森任務 6610（共用），引導 6612 |
| 急救 | 專家 | 技能 125，1 金，書無等級欄 | 德尼布·沃克（1417 26.97, 58.83） | 阿拉希高地激流堡買書 16084，20 級以下使用【需遊戲實測】 |
| 急救 | 大師 | 角色 35 級，技能 225，0 金 | 古斯塔夫·范沃森醫生（1445 67.76, 48.97） | 塞拉摩島任務 6624，引導 6625 |
| 釣魚 | 專家 | 角色 20 級，技能 125，1 金 | 老人海明威（1434 27.42, 77.16） | 藏寶海灣買書 16083（共用） |
| 釣魚 | 大師 | 角色 35 級，技能 225，0 金 | 納特·帕格（1445 58.61, 60.06） | 狂潮灣小島任務 6607（共用），引導 6609 |

## 六個製作主專業

| 專業 | 階段 | NPC（ID） | 城市／區域 | 地圖 ID 與座標 | 來源 |
|---|---|---|---|---|---|
| 鍊金術 | 專家 | 安尼希爾（4160） | 達納蘇斯・工匠區一樓 | 1457 54.88, 24.02 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4160?locale=10) · [Wowhead 永恆鍊金表](https://www.wowhead.com/forever/guide/professions/alchemy-overview-trainer-locations-recipes) · [訓練師頁](https://www.wow-professions.com/forever/alchemy-trainers) |
| 鍊金術 | 專家 | 琳西‧黑栓（246795） | 奧特蘭克山脈・達拉然 農藝藥劑坊 | 1416 18.53, 62.43 | 永恆新點，兩份資料都列 Expert（225）。達拉然對聯盟的進入條件【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/246795?locale=10) · [Wowhead 永恆鍊金表](https://www.wowhead.com/forever/guide/professions/alchemy-overview-trainer-locations-recipes) |
| 鍊金術 | 大師 | 凱蘭娜·風語（7948） | 菲拉斯・羽月要塞 | 1444 32.62, 43.78 | 島東北角樹屋底部。[NPC](https://nether.wowhead.com/forever/tooltip/npc/7948?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/alchemy-trainers) |
| 鍊金術 | 大師 | Master Mycologist Shurome（259585） | 費伍德森林・翡翠聖地（中立） | 1448 51.41, 82.01 | 共用部落表。QuestieDB 現有 zhTW 名「大師級真菌學家蘇羅姆」，台服顯示名【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/259585?locale=10) |
| 鍛造 | 專家 | 本古斯·深爐（4258） | 鐵爐堡・大熔爐 | 1455 52.55, 41.46 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4258?locale=10) · [Wowhead 永恆鍛造表](https://www.wowhead.com/forever/guide/professions/blacksmithing/overview) · [訓練師頁](https://www.wow-professions.com/forever/blacksmithing-trainers) |
| 鍛造 | 大師 | 布里克·基克拉夫（2836） | 荊棘谷・藏寶海灣（中立） | 1434 28.99, 75.56 | 共用部落表。 |
| 附魔 | 專家 | 基塔·費溫德（11072） | 艾爾文森林・阿祖拉之塔頂層 | 1429 64.93, 70.71 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/11072?locale=10) · [Wowhead 永恆附魔表](https://www.wowhead.com/forever/guide/professions/enchanting/overview) · [訓練師頁](https://www.wow-professions.com/forever/enchanting-trainers) |
| 附魔 | 大師 | 安諾拉（11073） | 荒蕪之地・奧達曼副本（中立） | 座標 ?【需遊戲實測】 | 共用部落表，清掉蠍群才現身。 |
| 工程學 | 專家 | 賓斯匹德（5174） | 鐵爐堡・地精區 Springspindle's Gadgets | 1455 68.46, 43.54 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/5174?locale=10) · [Wowhead 永恆工程表](https://www.wowhead.com/forever/guide/professions/engineering-overview-trainer-locations-recipes) · [訓練師頁](https://www.wow-professions.com/forever/engineering-trainers) |
| 工程學 | 大師 | 巴茲克·布拉斯溫（8736） | 塔納利斯・加基森（中立） | 1446 52.34, 27.72 | 共用部落表。 |
| 製皮 | 專家 | 泰龍尼斯（4212） | 達納蘇斯・工匠區二樓 | 1457 64.43, 21.54 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4212?locale=10) · [Wowhead 永恆製皮表](https://www.wowhead.com/forever/guide/professions/leatherworking-overview-trainer-locations-recipes) · [訓練師頁](https://www.wow-professions.com/forever/leatherworking-trainers) |
| 製皮 | 大師 | 德拉克·石拳（11097） | 辛特蘭・鷹巢山 | 1425 13.39, 43.49 | 有信箱的主建築，入口左轉走到底下樓。[NPC](https://nether.wowhead.com/forever/tooltip/npc/11097?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/leatherworking-trainers) |
| 裁縫 | 專家 | 喬吉奧·波利羅（1346） | 暴風城・法師區 鄧肯紡織品店 | 1453 53.08, 81.35 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1346?locale=10) · [Wowhead 永恆裁縫表](https://www.wowhead.com/forever/guide/professions/tailoring-overview-trainer-locations-recipes) · [訓練師頁](https://www.wow-professions.com/forever/tailoring-trainers) |
| 裁縫 | 大師 | 提莫斯·沃森特（11052） | 塵泥沼澤・塞拉摩島 | 1445 66.18, 51.81 | 下船或下飛行點後左手第一棟，二樓。[NPC](https://nether.wowhead.com/forever/tooltip/npc/11052?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/tailoring-trainers) |

製皮、鍛造、工程、鍊金的聯盟大師地點和經典版相同；裁縫大師沒有部落那樣改到別的城鎮。永恆的自訂點集中在達拉然（專家）與中立新點。

### 候選訓練師（未列入插件）

- 鍛造專家，艾拉得·席彌德（28694），達拉然 `1416 19.75, 63.36`。wow-professions 列在 Expert 區，頭銜只寫 Blacksmith，Wowhead 鍛造表沒有他。225 訓練項目【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/28694?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/blacksmithing-trainers)
- 附魔專家，凡妮莎‧塞勒斯（251978），達拉然 `1416 16.78, 62.27`。wow-professions 列在 Expert 區，Wowhead 附魔表沒有她。225 訓練項目【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/251978?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/enchanting-trainers)
- 附魔專家，梅蘭妮‧沙伯（259287），大河林地法霍爾德要塞 `2548 66.21, 83.36`。wow-professions 列為聯盟 Expert；QuestieDB 的陣營欄是空的，提示的聲望為「戰馬兄弟會」。友善程度與 225 訓練項目【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/259287?locale=10) · [訓練師頁](https://www.wow-professions.com/forever/enchanting-trainers)
- 裁縫專家，查理斯‧沃斯（251972），達拉然 `1416 17.71, 60.26`。wow-professions 列在 Expert 區，Wowhead 裁縫表的頭銜是 Expert Tailor，依頭銜慣例可能只教到 150。到場看 225 項目【需遊戲實測】。[NPC](https://nether.wowhead.com/forever/tooltip/npc/251972?locale=10) · [Wowhead 永恆裁縫表](https://www.wowhead.com/forever/guide/professions/tailoring-overview-trainer-locations-recipes)
- 工程學專家／大師，凱蕾娜‧春語者（249235），海加爾山 `2482 60.10, 61.18`，中立。部落文件已列為候選，聯盟同樣【需遊戲實測】。
- 製皮、裁縫專家，賈瑞爾（255721）、梅菈諾莉（255724），申德拉拉 `2652`，中立。要先完成五段任務「Strange Pylons」到「Meeting the Magister」，wow-professions 作者不確定是否為錯誤。[訓練師頁](https://www.wow-professions.com/forever/leatherworking-trainers)

## 三個採集主專業

條件與部落相同：專家技能 125／50 銀，大師技能 200／5 金，訓練表的角色等級欄是空的。下表是可教兩階的主城與順路據點。[草藥訓練表](https://www.wow-professions.com/forever/herbalism-trainers) · [採礦訓練表](https://www.wow-professions.com/forever/mining-trainers) · [剝皮訓練表](https://www.wow-professions.com/forever/skinning-trainers)

| 專業 | NPC（ID） | 城市／區域 | 地圖 ID 與座標 | 來源 |
|---|---|---|---|---|
| 草藥學 | 塔尼莎（5566） | 暴風城・法師區鍊金店外 | 1453 54.29, 84.10 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/5566?locale=10) |
| 草藥學 | 雷納·石枝（5137） | 鐵爐堡・大熔爐南側醫師店 | 1455 55.90, 59.13 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/5137?locale=10) |
| 草藥學 | 菲羅迪恩·喚月（4204） | 達納蘇斯・月神殿 | 1457 47.95, 68.03 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4204?locale=10) |
| 草藥學 | 卡利（1473） | 洛克莫丹・塞爾薩瑪 | 1432 36.47, 48.54 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1473?locale=10) |
| 草藥學 | 泰倫瑞諾·月影（1458） | 濕地・米奈希爾港 | 1437 7.99, 55.84 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1458?locale=10) |
| 採礦 | 吉爾曼·石手（5513） | 暴風城・矮人區 | 1453 59.25, 37.83 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/5513?locale=10) |
| 採礦 | 吉爾弗拉姆·石趾（4254） | 鐵爐堡・大熔爐北側 | 1455 50.00, 26.29 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/4254?locale=10) |
| 採礦 | 庫德拉姆·石錘（6297） | 黑海岸・奧伯丁 | 1439 38.25, 41.01 | 離達納蘇斯最近的採礦師。[NPC](https://nether.wowhead.com/forever/tooltip/npc/6297?locale=10) |
| 採礦 | 布洛克·尋石者（1681） | 洛克莫丹・塞爾薩瑪 | 1432 37.02, 47.81 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1681?locale=10) |
| 採礦 | 瑪特·約翰森（3137） | 暮色森林・夜色鎮 | 1431 74.05, 49.62 | 鐵匠鋪後方室外。[NPC](https://nether.wowhead.com/forever/tooltip/npc/3137?locale=10) |
| 剝皮 | 馬瑞斯·格蘭治（1292） | 暴風城・舊城區 | 1453 72.14, 62.21 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/1292?locale=10) |
| 剝皮 | 巴爾薩斯·裂石（6291） | 鐵爐堡・大熔爐西北皮革店 | 1455 39.86, 32.50 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/6291?locale=10) |
| 剝皮 | 艾拉迪爾（6292） | 達納蘇斯・工匠區二樓 | 1457 64.14, 22.26 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/6292?locale=10) |
| 剝皮 | 海倫尼·派特斯金納（6306） | 艾爾文森林・閃金鎮 | 1429 46.24, 62.24 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/6306?locale=10) |
| 剝皮 | 傑拉（6288） | 梣谷・銀風避難所 | 1440 49.98, 67.29 | [NPC](https://nether.wowhead.com/forever/tooltip/npc/6288?locale=10) |

其他可教兩階、未列入插件的點：草藥學莎拉米爾（5502，暴風城公園）、塞蘭妮婭·伏根（3965，銀風避難所）、布蘭特·加斯布魯姆（4898，塞拉摩島）、草藥師博米洛伊（1218，艾爾文森林）、奧瑪·詹洛斯（812，湖畔鎮）、Edward Egan（246792，達拉然，QuestieDB 無刷新點）；採礦丹克·利刃（1701）、亞爾·錘石（5392，丹莫洛）；剝皮威爾瑪·蘭薩爾（6295，赤脊山）、拉德納爾·織髮（6287，泰達希爾）。中立點（部落文件已列）：微風島四位、火線港格朗格、加基森皮庫爾（8128，採礦）、藏寶海灣芙羅拉·希沃溫德（908，草藥）、月光林地瑪沃爾（12025，草藥）。

## 烹飪、急救、釣魚

書與任務的等級、費用規則和部落相同（見部落文件）。三本書的物品 ID 相同，聯盟換賣書 NPC；大師任務烹飪、釣魚兩陣營共用，急救聯盟用 6624。主城引導任務均可選。[Wowhead 永恆烹飪](https://www.wowhead.com/forever/guide/professions/cooking/overview-leveling) · [Wowhead 永恆急救](https://www.wowhead.com/forever/guide/professions/first-aid/overview) · [Wowhead 永恆釣魚](https://www.wowhead.com/forever/guide/professions/fishing/overview-leveling)

| 專業 | 階段 | 條件 | 聯盟可用 NPC／地圖 ID 座標 | 方式與費用 |
|---|---|---|---|---|
| 烹飪 | 專家 225 | 烹飪 125，書無角色等級欄 | 珊蒂瑞亞 Shandrina #3955，梣谷 銀風避難所（塔隆深谷東北）`1440 49.48, 67.09` | 購買高級烹飪教材 #16072，1 金。QuestieDB 的賣家只有她和部落烏蘭。[NPC](https://nether.wowhead.com/forever/tooltip/npc/3955?locale=10) · [物品](https://www.wowhead.com/forever/tw/item=16072) |
| 烹飪 | 大師 300 | 角色 35 級，烹飪 225 | 迪爾格·奎克里弗 #8125，加基森 `1446 52.63, 28.11` | 任務蚌肉大餐 #6610（`races=0`，兩陣營共用）。鐵爐堡達瑞爾·瑞克努索 Daryl Riknussun #5159 `1455 60.08, 36.43` 可先接「我認識一個傢伙…」I Know A Guy... #6612。[引導](https://www.wowhead.com/forever/tw/quest=6612) · [NPC](https://nether.wowhead.com/forever/tooltip/npc/5159?locale=10) |
| 急救 | 專家 225 | 急救 125，書無角色等級欄 | 德尼布·沃克 Deneb Walker #2805，阿拉希高地 激流堡 `1417 26.97, 58.83` | 購買高級急救教材 - 繃帶縛體 #16084，1 金，同趟可買厚絲質、魔紋繃帶手冊。[NPC](https://nether.wowhead.com/forever/tooltip/npc/2805?locale=10) · [物品](https://www.wowhead.com/forever/tw/item=16084) |
| 急救 | 大師 300 | 角色 35 級，急救 225 | 古斯塔夫·范沃森醫生 Doctor Gustaf VanHowzen #12939，塵泥沼澤 塞拉摩島 `1445 67.76, 48.97` | 任務救死扶傷 Triage #6624（聯盟版，各語系任務名與部落 6622 部分不同：esES「Atenciones médicas」、ruRU「Очередность перевязки」）。鐵爐堡尼莎·火石 Nissa Firestone #5150 `1455 55.09, 58.26` 可先接聯盟醫療隊 Alliance Trauma #6625。[任務](https://www.wowhead.com/forever/tw/quest=6624) · [引導](https://www.wowhead.com/forever/tw/quest=6625) |
| 釣魚 | 專家 225 | 角色 20 級，釣魚 125 | 老人海明威 #2626，藏寶海灣 `1434 27.42, 77.16` | 共用部落表。 |
| 釣魚 | 大師 300 | 角色 35 級，釣魚 225 | 納特·帕格 #12919，狂潮灣小島 `1445 58.61, 60.06` | 任務 #6607 共用。鐵爐堡格瑞諾爾·石印 Grimnur Stonebrand #5161 `1455 48.07, 6.91` 可先接 I Got Nothin' Left! #6609。zhTW 任務名 Wowhead 為「我已經傾囊相授了！」，QuestieDB 為「青出於藍！」，插件用 Wowhead，台服實際名稱【需遊戲實測】。[引導](https://www.wowhead.com/forever/tw/quest=6609) · [NPC](https://nether.wowhead.com/forever/tooltip/npc/5161?locale=10) |

## 其他語言

NPC 名稱以 Wowhead Forever 各語系提示為主（`locale=zhCN/deDE/frFR/esES/esMX/ruRU/koKR/ptBR`），和 QuestieDB l10n 比對，除下列外兩來源一致：

- 德拉克·石拳 esMX：Wowhead 回退英文 `[Drakk Stonehand]`，QuestieDB 有 `Drakk Petramano`，採用 QuestieDB。
- 任務 6609 zhTW：見上表。

引導任務名的各語系文字也取自同兩來源，寫在 `note_<語言>`；材料名沿用部落備註。
